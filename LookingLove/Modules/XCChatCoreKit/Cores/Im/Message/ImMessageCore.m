//
//  ImMessageCore.m
//  BberryCore
//
//  Created by chenran on 2017/4/19.
//  Copyright © 2017年 chenran. All rights reserved.
//

#import "ImMessageCore.h"
#import <NIMSDK/NIMSDK.h>
#import "GiftAllMicroSendInfo.h"
#import "XCKeyWordTool.h"

#import "UserCore.h"
#import "AuthCore.h"
#import "ImRoomCoreV2.h"
#import "RoomQueueCoreV2.h"
#import "ImLoginCoreClient.h"
#import "ImMessageCoreClient.h"
#import "RoomRedClient.h"
#import "RoomCoreV2.h"

#import <NSObject+YYModel.h>
#import "NSString+JsonToDic.h"
#import "NSString+SpecialClean.h"
#import "NSString+Regex.h"
#import "XCLogger.h"

#import "ImPublicChatroomCore.h"
#import "XCMacros.h"
#import "PublicChatAtMemberAttachment.h"

#import "TTCPGamePrivateChatClient.h"

#import "TTGameStaticTypeCore.h"
#import "TTGameCPPrivateChatModel.h"

#import "MessageCollection.h"
#import "TTStatisticsService.h"

// 最大次数
static NSInteger const kMaxCount = 3;

@interface ImMessageCore ()<NIMChatManagerDelegate,NIMBroadcastManagerDelegate,NIMConversationManagerDelegate,ImLoginCoreClient>

@property (nonatomic, assign) NSInteger resendCount; // 重发的次数

@end

@implementation ImMessageCore

#pragma mark - life cycle

+ (void)load {
    GetCore(ImMessageCore);
}

- (instancetype)init {
    self = [super init];
    if (self) {
        [[NIMSDK sharedSDK].chatManager addDelegate:self];
        [[NIMSDK sharedSDK].broadcastManager addDelegate:self];
        
        [[NIMSDK sharedSDK].conversationManager addDelegate:self];
        AddCoreClient(ImLoginCoreClient, self);
        AddCoreClient(TTCPGamePrivateChatClient, self);
    }
    return self;
}

-(void)dealloc {
    RemoveCoreClientAll(self);
    [[NIMSDK sharedSDK].chatManager removeDelegate:self];
    [[NIMSDK sharedSDK].broadcastManager removeDelegate:self];
    [[NIMSDK sharedSDK].conversationManager removeDelegate:self];
}


#pragma mark - NIMChatManagerDelegate

//已读云信新方法
- (void)onRecvMessageReceipts:(NSArray<NIMMessageReceipt *> *)receipts {
    NotifyCoreClient(ImMessageCoreClient, @selector(onRecvP2PMessageReceipt:), onRecvP2PMessageReceipt:receipts.lastObject);
}

//已读云信旧的方法
- (void)onRecvMessageReceipt:(NIMMessageReceipt *)receipt {
    NotifyCoreClient(ImMessageCoreClient, @selector(onRecvP2PMessageReceipt:), onRecvP2PMessageReceipt:receipt);
}


- (void)sendMessage:(NIMMessage *)message progress:(float)progress{
    NotifyCoreClient(ImMessageCoreClient, @selector(onSendMessage:progress:), onSendMessage:message progress:progress);
}

//发送消息成功回调
- (void)sendMessage:(NIMMessage *)message didCompleteWithError:(NSError *)error {
    
    if (error == nil) {
        if (message.session.sessionType == NIMSessionTypeChatroom) {
            
            NSDictionary *meRoomExt = [NSString dictionaryWithJsonString:GetCore(ImRoomCoreV2).myMember.roomExt];
            NSMutableDictionary *memberExtDic = [GetCore(ImRoomCoreV2) queryOnMicroMemberExt];
            [memberExtDic setValuesForKeysWithDictionary:meRoomExt];
            
            message.remoteExt = memberExtDic;
            NotifyCoreClient(ImMessageCoreClient, @selector(onSendChatRoomMessageSuccess:), onSendChatRoomMessageSuccess:message);
            
            if (message.messageType == NIMMessageTypeCustom) {
                NIMCustomObject *obj = (NIMCustomObject *)message.messageObject;
                Attachment *attachment = (Attachment *)obj.attachment;
                if (attachment.first == Custom_Noti_Header_Gift) {
                    
                    // 赠送礼物发送公屏消息成功后，置空次数
                    [self cleanFailMsgResendCount];
                    
                    GiftAllMicroSendInfo *info = [GiftAllMicroSendInfo modelDictionary:attachment.data];
                    if (error) {
                        [[XCLogger shareXClogger] sendLog:@{@"senderUid" : [NSString stringWithFormat:@"%lld",info.uid],
                                                            @"receiveUid":[NSString stringWithFormat:@"%lld",info.targetUid],
                                                            @"room_id":GetCore(ImRoomCoreV2).currentChatRoom.roomId,
                                                            @"number":[NSString stringWithFormat:@"%ld",(long)info.giftNum],
                                                            @"result":@"true",
                                                            EVENT_ID:CGift_channel}
                                                    error:error
                                                    topic:BussinessLog
                                                 logLevel:(XCLogLevel)XCLogLevelError];
                    } else {
                        [[XCLogger shareXClogger] sendLog:@{@"senderUid":[NSString stringWithFormat:@"%lld",info.uid],
                                                            @"receiveUid":[NSString stringWithFormat:@"%lld",info.targetUid],
                                                            @"room_id":GetCore(ImRoomCoreV2).currentChatRoom.roomId,
                                                            @"number":[NSString stringWithFormat:@"%ld",(long)info.giftNum],
                                                            @"result":@"true",
                                                            EVENT_ID:CGift_channel}
                                                    error:nil
                                                    topic:BussinessLog
                                                 logLevel:(XCLogLevel)XCLogLevelVerbose];
                    }
                    
                } else if (attachment.first == Custom_Noti_Header_ALLMicroSend ||
                           attachment.first == Custom_Noti_Header_RoomMagic) {
                    // 赠送礼物发送公屏消息成功后，置空次数
                    [self cleanFailMsgResendCount];
                    
                } else if(attachment.first == Custom_Noti_Header_Dragon) {
                    //龙珠
                    NotifyCoreClient(ImMessageCoreClient, @selector(onSendDragonMessageSuccess:), onSendDragonMessageSuccess:message);
                    
                } else if (attachment.first == Custom_Noti_Header_CPGAME){
                    // CP 房  自定义消息
                    NotifyCoreClient(ImMessageCoreClient, @selector(onSendCPGameMessageSuccess:), onSendCPGameMessageSuccess:message);
                    
                } else if (attachment.first == Custom_Noti_Header_CPGAME_PrivateChat){
                    NotifyCoreClient(TTCPGamePrivateChatClient, @selector(onSendCPGamePublicChatMessageSuccess:), onSendCPGamePublicChatMessageSuccess:message);
                } else if (attachment.first == Custom_Noti_Header_CPGAME_PublicChat_Respond){
                    if (attachment.second == Custom_Noti_Sub_CPGAME_PublicChat_Respond_Accept) {
                        NSLog(@"公聊发送接受消息成功");
                    }
                }
            }
        } else if (message.session.sessionType == NIMSessionTypeP2P) {
            if (message.messageType == NIMMessageTypeCustom) {
                NIMCustomObject *obj = (NIMCustomObject *)message.messageObject;
                Attachment *attachment = (Attachment *)obj.attachment;
                if (attachment.first == Custom_Noti_Header_Gift) {
                    NotifyCoreClient(ImMessageCoreClient, @selector(onRecvP2PCustomMsg:), onRecvP2PCustomMsg:message);
                    if (error) {
                        GiftAllMicroSendInfo *info = [GiftAllMicroSendInfo yy_modelWithDictionary:attachment.data];
                        [[XCLogger shareXClogger]sendLog:@{@"senderUid":[NSString stringWithFormat:@"%lld",info.uid],@"receiveUid":[NSString stringWithFormat:@"%lld",info.targetUid],@"room_id":GetCore(ImRoomCoreV2).currentChatRoom.roomId,@"number":[NSString stringWithFormat:@"%ld",(long)info.giftNum],@"result":@"true",EVENT_ID:CGift_P2P} error:error topic:BussinessLog logLevel:(XCLogLevel)XCLogLevelError];
                    } else {
                        GiftAllMicroSendInfo *info = [GiftAllMicroSendInfo yy_modelWithDictionary:attachment.data];
                        [[XCLogger shareXClogger]sendLog:@{@"senderUid":[NSString stringWithFormat:@"%lld",info.uid],@"receiveUid":[NSString stringWithFormat:@"%lld",info.targetUid],@"room_id":GetCore(ImRoomCoreV2).currentChatRoom.roomId ? GetCore(ImRoomCoreV2).currentChatRoom.roomId : @"",@"number":[NSString stringWithFormat:@"%ld",(long)info.giftNum],@"result":@"true",EVENT_ID:CGift_P2P} error:nil topic:BussinessLog logLevel:(XCLogLevel)XCLogLevelVerbose];
                    }
                } else if (attachment.first == Custom_Noti_Header_InApp_Share){
                    NotifyCoreClient(ImMessageCoreClient, @selector(sendCustomMessageShare:), sendCustomMessageShare:message);
                } else if (attachment.first == Custom_Noti_Header_CPGAME){
                    // CP 房  自定义消息
                    NotifyCoreClient(ImMessageCoreClient, @selector(onSendCPGameMessageSuccess:), onSendCPGameMessageSuccess:message);
                    
                } else if (attachment.first == Custom_Noti_Header_CPGAME_PrivateChat){
                    NotifyCoreClient(TTCPGamePrivateChatClient, @selector(onSendCPGamePrivateChatMessageSuccess:), onSendCPGamePrivateChatMessageSuccess:message);
                } else if (attachment.first == Custom_Noti_Header_CPGAME_PrivateChat_SystemNotification){
                    NotifyCoreClient(TTCPGamePrivateChatClient, @selector(onSendCPGamePrivateChatCancelGameMessageSuccess:), onSendCPGamePrivateChatCancelGameMessageSuccess:message);
                } else if (attachment.first == Custom_Noti_Header_Dynamic) {
                    NotifyCoreClient(ImMessageCoreClient, @selector(sendCustomMessageShare:), sendCustomMessageShare:message);
                } else if (attachment.first == Custom_Noti_Header_RoomActivityHot) {
                    NotifyCoreClient(ImMessageCoreClient, @selector(onSendRoomActivityCountDownTimeWithMsg:error:), onSendRoomActivityCountDownTimeWithMsg:message error:error);
                }
            }
        }else if (message.session.sessionType == NIMSessionTypeTeam){
            if (message.messageType == NIMMessageTypeCustom) {
                NIMCustomObject *obj = (NIMCustomObject *)message.messageObject;
                Attachment *attachment = (Attachment *)obj.attachment;
                if (attachment.first == Custom_Noti_Header_InApp_Share){
                    NotifyCoreClient(ImMessageCoreClient, @selector(sendCustomMessageShare:), sendCustomMessageShare:message);
                }
            }
        }
        
        NotifyCoreClient(ImMessageCoreClient, @selector(onSendMessageSuccess:), onSendMessageSuccess:message);
    } else {
        if (error.code == 408 || error.code == 415) {
            
            NIMCustomObject *obj = (NIMCustomObject *)message.messageObject;
            Attachment *attachment = (Attachment *)obj.attachment;
            
            if (attachment.first == Custom_Noti_Header_Gift ||
                attachment.first == Custom_Noti_Header_ALLMicroSend ||
                attachment.first == Custom_Noti_Header_RoomMagic) { // 送礼失败时，重发三次。成功后就取消重发
                [self resendGiftMsg:message];
            } else {
                [[NIMSDK sharedSDK].chatManager resendMessage:message error:nil];
            }
            
        } else {
            if (message.messageType == NIMMessageTypeCustom){
                NIMCustomObject *obj = (NIMCustomObject *)message.messageObject;
                Attachment *attachment = (Attachment *)obj.attachment;
                if(attachment.first == Custom_Noti_Header_Dragon){
                    // 发送龙珠失败
                    NotifyCoreClient(ImMessageCoreClient, @selector(onSendDragonMessageFailthWithMsg:error:), onSendDragonMessageFailthWithMsg:message error:error );
                } else if (attachment.first == Custom_Noti_Header_Gift ||
                           attachment.first == Custom_Noti_Header_ALLMicroSend ||
                           attachment.first == Custom_Noti_Header_RoomMagic) { // 送礼失败时，重发三次。成功后就取消重发
                  
                    // 重发逻辑
                    [self resendGiftMsg:message];
                }
            }
        }
    }
}

- (void)willSendMessage:(NIMMessage *)message {
    
    NotifyCoreClient(ImMessageCoreClient, @selector(onWillSendMessage:), onWillSendMessage:message);
}

- (void)onRecvMessages:(NSArray<NIMMessage *> *)messages
{
    if (messages.count <= 0) {
        return;
    }
    for (NIMMessage *message in messages) {
        if ([message.session.sessionId integerValue] == GetCore(ImRoomCoreV2).currentRoomInfo.roomId) {
            ((NIMMessageChatroomExtension *)message.messageExt).roomNickname = [((NIMMessageChatroomExtension *)message.messageExt).roomNickname cleanSpecialText];
            if (message.messageType == NIMMessageTypeText) {
                if (message.session.sessionType == NIMSessionTypeChatroom) {
                    NotifyCoreClient(ImMessageCoreClient, @selector(onRecvChatRoomTextMsg:), onRecvChatRoomTextMsg:message);
                }
            } else if (message.messageType == NIMMessageTypeNotification) {
                NIMNotificationObject *notiMsg = (NIMNotificationObject *)message.messageObject;
                if (notiMsg.notificationType == NIMNotificationTypeChatroom) {
                    NotifyCoreClient(ImMessageCoreClient, @selector(onRecvChatRoomNotiMsg:), onRecvChatRoomNotiMsg:message);
                }
                [GetCore(MessageCollection) sendMessageCollectionRequestWithMessage:message firstAttachment:0];
                
            } else if (message.messageType == NIMMessageTypeCustom) {
                
                NIMCustomObject *obj = (NIMCustomObject *)message.messageObject;
                Attachment *att = (Attachment *)obj.attachment;
                if (att.first == Custom_Noti_Header_Red) {
                    if (att.second == Custom_Noti_Sub_Red_Authority_All ||
                        att.second == Custom_Noti_Sub_Red_Authority_Specific) {
                        
                        XCRedAuthorityAttachment *attach = (XCRedAuthorityAttachment*)att;
                        
                        GetCore(ImRoomCoreV2).currentRoomInfo.hideRedPacket = attach.hideRedPacket;
                        GetCore(RoomCoreV2).hideRedPacket = attach.hideRedPacket;
                        
                        NotifyCoreClient(RoomRedClient, @selector(onReceiveRedAuthorityChange:), onReceiveRedAuthorityChange:attach);
                    }
                }
                
                NIMSession *session = message.session;
                if (session.sessionType == NIMSessionTypeChatroom) {
                    NotifyCoreClient(ImMessageCoreClient, @selector(onRecvChatRoomCustomMsg:), onRecvChatRoomCustomMsg:message);
                    
                } else if (session.sessionType == NIMSessionTypeP2P) {
                    
                } else {
                    
                }
            }
            
            
            
            
        } else if ([message.session.sessionId integerValue] == GetCore(ImRoomCoreV2).p2pUid) {//cp模式
            if (message.messageType == NIMMessageTypeCustom) {
                NIMSession *session = message.session;
                if (session.sessionType == NIMSessionTypeP2P) {
                    //用于接收到p表情处理
                    NotifyCoreClient(ImMessageCoreClient, @selector(onRecvChatRoomCustomMsg:), onRecvChatRoomCustomMsg:message);
                }
            }
        } else if (([message.session.sessionId integerValue] == GetCore(ImPublicChatroomCore).publicChatroomId)) {
            if (message.messageType == NIMMessageTypeNotification) {
                NIMNotificationObject *notiMsg = (NIMNotificationObject *)message.messageObject;
                if (notiMsg.notificationType == NIMNotificationTypeChatroom) {
                    NotifyCoreClient(ImMessageCoreClient, @selector(onRecvChatRoomNotiMsg:), onRecvChatRoomNotiMsg:message);
                }
            }
        }
        
        if (message.messageType == NIMMessageTypeCustom) {
            if (message.session.sessionType == NIMSessionTypeP2P) {
                NIMCustomObject *obj = (NIMCustomObject *)message.messageObject;
                Attachment *attachment = (Attachment *)obj.attachment;
                if (attachment.first == Custom_Noti_Header_CPGAME_PrivateChat) {
                    TTGameCPPrivateChatModel *model = [TTGameCPPrivateChatModel modelWithJSON:attachment.data];
                    for (int i = 0; i < GetCore(TTGameStaticTypeCore).privateMessageArray.count; i++) {
                        CPGameListModel *gameModel = [CPGameListModel modelWithJSON:GetCore(TTGameStaticTypeCore).privateMessageArray[i]];
                        if ([gameModel.gameId isEqualToString:model.gameInfo.gameId]) {
                            NotifyCoreClient(TTCPGamePrivateChatClient, @selector(onReceiveCPGamePrivateChatMessageSuccess:), onReceiveCPGamePrivateChatMessageSuccess:message);
                            break;
                        }
                    }
                }else if (attachment.first == Custom_Noti_Header_CPGAME_PrivateChat_SystemNotification){
                    NotifyCoreClient(TTCPGamePrivateChatClient, @selector(onReceiveCPGamePrivateChatCancelGameMessageSuccess:), onReceiveCPGamePrivateChatCancelGameMessageSuccess:message);
                }else{
                    NotifyCoreClient(ImMessageCoreClient, @selector(onRecvP2PCustomMsg:), onRecvP2PCustomMsg:message);
                }
            }else if (message.session.sessionType == NIMSessionTypeChatroom){
                NIMCustomObject *obj = (NIMCustomObject *)message.messageObject;
                Attachment *attachment = (Attachment *)obj.attachment;
                if (attachment.first == Custom_Noti_Header_CPGAME_PrivateChat) {
                    TTGameCPPrivateChatModel *model = [TTGameCPPrivateChatModel modelWithJSON:attachment.data];
                    for (int i = 0; i < GetCore(TTGameStaticTypeCore).privateMessageArray.count; i++) {
                        CPGameListModel *gameModel = [CPGameListModel modelWithJSON:GetCore(TTGameStaticTypeCore).privateMessageArray[i]];
                        if ([gameModel.gameId isEqualToString:model.gameInfo.gameId]) {
                            NotifyCoreClient(TTCPGamePrivateChatClient, @selector(onReceiveCPGamePublicChatMessageSuccess:), onReceiveCPGamePublicChatMessageSuccess:message);
                            break;
                        }
                    }
                }else if (attachment.first == Custom_Noti_Header_CPGAME_PublicChat_Respond){
                    if (attachment.second == Custom_Noti_Sub_CPGAME_PublicChat_Respond_Accept) {
                        NotifyCoreClient(TTCPGamePrivateChatClient, @selector(onReceiveCPGamePublicChatAcceptGameMessageSuccess:), onReceiveCPGamePublicChatAcceptGameMessageSuccess:message);
                    }else if (attachment.second == Custom_Noti_Sub_CPGAME_PublicChat_Respond_Cancel){
                        NotifyCoreClient(TTCPGamePrivateChatClient, @selector(onReceiveCPGamePublicChatGameCancelMessageSuccess:), onReceiveCPGamePublicChatGameCancelMessageSuccess:message);
                    }
                }else if (attachment.first == Custom_Noti_Header_CPGAME_PrivateChat_SystemNotification){
                    if (attachment.second == Custom_Noti_Sub_CPGAME_PrivateChat_SysNoti_GameOver) {
                        NotifyCoreClient(TTCPGamePrivateChatClient, @selector(onReceiveCPGamePublicChatGameOverMessageSuccess:), onReceiveCPGamePublicChatGameOverMessageSuccess:message);
                    }
                }
            }
        }
        NotifyCoreClient(ImMessageCoreClient, @selector(onRecvAnMsg:), onRecvAnMsg:message);
        
        
    }
}

#pragma mark - NIMConversationManagerDelegate

- (void)didAddRecentSession:(NIMRecentSession *)recentSession
           totalUnreadCount:(NSInteger)totalUnreadCount {
    [self handleNoNotifyTeamUnReadCount:recentSession];
    NotifyCoreClient(ImMessageCoreClient, @selector(onImUnReadCountHandleComplete), onImUnReadCountHandleComplete);
}

- (void)didUpdateRecentSession:(NIMRecentSession *)recentSession totalUnreadCount:(NSInteger)totalUnreadCount {
    [self handleNoNotifyTeamUnReadCount:recentSession];
    NotifyCoreClient(ImMessageCoreClient, @selector(onImUnReadCountHandleComplete), onImUnReadCountHandleComplete);
}


#pragma mark - ImMessageCoreClient

- (void)onImSyncSuccess {
    NotifyCoreClient(ImMessageCoreClient, @selector(onImUnReadCountHandleComplete), onImUnReadCountHandleComplete);
}

#pragma mark - NIMBroadcastDelegate
- (void)onReceiveBroadcastMessage:(NIMBroadcastMessage *)broadcastMessage{
    NotifyCoreClient(ImMessageCoreClient, @selector(onRecvAnBroadcastMsg:), onRecvAnBroadcastMsg:broadcastMessage);
}

#pragma mark - puble method

- (NSInteger)getUnreadCount {
    
    return [[NIMSDK sharedSDK].conversationManager allUnreadCount];
}


- (void)sendTextMessage:(NSString *)text nick:(NSString *)nick  sessionId:(NSString *)sessionId type:(NIMSessionType)type {
    BOOL isEmpty = [NSString isEmpty:text];
    if (isEmpty) {
        return;
    }
    //添加扩展信息
    NIMMessageChatroomExtension *ext = [[NIMMessageChatroomExtension alloc]init];
    UserInfo *userInfo = [GetCore(UserCore)getUserInfoInDB:[GetCore(AuthCore) getUid].userIDValue];
    ext.roomNickname = userInfo.nick;
    ext.roomAvatar = userInfo.avatar;
    NSMutableDictionary *meRoomExt = nil;
    if ([sessionId integerValue] == GetCore(ImPublicChatroomCore).publicChatroomId) { //公聊大厅
        meRoomExt = [[NSString dictionaryWithJsonString:GetCore(ImPublicChatroomCore).publicMe.roomExt] mutableCopy];
    }else {
        meRoomExt = [[NSString dictionaryWithJsonString:GetCore(ImRoomCoreV2).myMember.roomExt] mutableCopy];
        
        if (GetCore(ImRoomCoreV2).currentRoomInfo) {
            if ([GetCore(RoomQueueCoreV2) isOnMicro:GetCore(AuthCore).getUid.userIDValue]) {
                NSString *position = [GetCore(RoomQueueCoreV2) findThePositionByUid:GetCore(AuthCore).getUid.userIDValue];
                NSMutableDictionary *dict = [[meRoomExt objectForKey:GetCore(AuthCore).getUid] mutableCopy];
                [dict safeSetObject:position forKey:@"micPos"];
                [meRoomExt safeSetObject:dict forKey:GetCore(AuthCore).getUid];
            }
        }
    }
    
    
    NSMutableDictionary *memberExtDic = [NSMutableDictionary dictionary];
    [memberExtDic setValuesForKeysWithDictionary:meRoomExt];
    ext.roomExt = [memberExtDic yy_modelToJSONString];
    //构造消息
    NIMMessage *message = [[NIMMessage alloc] init];
    message.text    = [self antiSpam:text withMessage:message] ;
    if (message.text.length <= 0) {
        return;
    }
    message.messageExt = ext;
    message.remoteExt = memberExtDic;
    //构造会话
    NIMSession *session = [NIMSession session:sessionId type:type];
    
    //发送消息
    [[NIMSDK sharedSDK].chatManager sendMessage:message toSession:session error:nil];
    
    [GetCore(MessageCollection) sendMessageCollectionRequestWithMessage:message firstAttachment:0];
}


- (void)sendTipsMessage:(NSDictionary *)attchment sessionId:(NSString *)sessionId
                   type:(NIMSessionType)type{
    NIMMessage *message = [[NIMMessage alloc]init];
    // 获得文件附件对象
    NIMTipObject *object = [[NIMTipObject alloc] init];
    message.remoteExt = attchment;
    message.messageObject = object;
    NIMMessageSetting *setting = [[NIMMessageSetting alloc]init];
    setting.apnsEnabled = YES;
    message.setting = setting;
    message.text = [NSString stringWithFormat:@"%@%@",attchment[@"nick"],[NSString stringWithFormat:@"领取了你的%@",[XCKeyWordTool sharedInstance].xcRedColor]];
    //构造会话
    NIMSession *session = [NIMSession session:sessionId type:type];
    
    [[NIMSDK sharedSDK].chatManager sendMessage:message toSession:session error:nil];
    
    [GetCore(MessageCollection) sendMessageCollectionRequestWithMessage:message firstAttachment:0];
}


- (void)sendTipsMessageWithAttachment:(Attachment *)attachment sessionId:(NSString *)sessionId type:(NIMSessionType)type {
    
}





//发送自定义消息
- (void)sendCustomMessageAttachement:(Attachment *)attachment
                           sessionId:(NSString *)sessionId
                                type:(NIMSessionType)type {

    [self sendCustomMessageAttachement:attachment sessionId:sessionId type:type needApns:NO apnsContent:nil];
    
}

//发送自定义消息-带推送
- (void)sendCustomMessageAttachement:(Attachment *)attachment
                           sessionId:(NSString *)sessionId
                                type:(NIMSessionType)type
                            needApns:(BOOL)needApns
                         apnsContent:(NSString *)apnsContent {
    
    [self sendCustomMessageAttachement:attachment sessionId:sessionId type:type yidunEnabled:NO needApns:needApns apnsContent:apnsContent];
}

- (void)sendCustomMessageAttachement:(Attachment *)attachment
                           sessionId:(NSString *)sessionId
                                type:(NIMSessionType)type
                        yidunEnabled:(BOOL)yidunEnabled
                            needApns:(BOOL)needApns
                         apnsContent:(NSString *)apnsContent {
    
    if (type == NIMSessionTypeChatroom) {
        
        if ([GetCore(RoomQueueCoreV2) getChatRoomConnectState]) {
            
            NotifyCoreClient(ImMessageCoreClient, @selector(onSendMessageFailthWithError), onSendMessageFailthWithError);
            return;
        }
    }
    
    NIMMessage *message = [[NIMMessage alloc]init];
    //yidun
    NIMAntiSpamOption *option = [NIMAntiSpamOption new];
    option.yidunEnabled =yidunEnabled;
    
    
    NSMutableDictionary *meRoomExt = nil;
    if ([sessionId integerValue] == GetCore(ImPublicChatroomCore).publicChatroomId) { //公聊大厅
        meRoomExt = [[NSString dictionaryWithJsonString:GetCore(ImPublicChatroomCore).publicMe.roomExt] mutableCopy];
        
        
        if (attachment.second == Custom_Noti_Sub_PublicChatroom_Send_At) {
            PublicChatAtMemberAttachment *antiSpamAtt = [PublicChatAtMemberAttachment yy_modelWithJSON:attachment.data];
            option.content = antiSpamAtt.content;
            antiSpamAtt.content = [self antiSpam:antiSpamAtt.content withMessage:message];
            attachment.data = [antiSpamAtt model2dictionary];
            if (antiSpamAtt.content.length <= 0) {
                return;
            }
        }
    }else {
        meRoomExt = [[NSString dictionaryWithJsonString:GetCore(ImRoomCoreV2).myMember.roomExt] mutableCopy];
        
        if (GetCore(ImRoomCoreV2).currentRoomInfo) {
            if ([GetCore(RoomQueueCoreV2) isOnMicro:GetCore(AuthCore).getUid.userIDValue]) {
                NSString *position = [GetCore(RoomQueueCoreV2) findThePositionByUid:GetCore(AuthCore).getUid.userIDValue];
                NSMutableDictionary *dict = [[meRoomExt objectForKey:GetCore(AuthCore).getUid] mutableCopy];
                [dict safeSetObject:position forKey:@"micPos"];
                [meRoomExt safeSetObject:dict forKey:GetCore(AuthCore).getUid];
            }
        }
    }
    
    NIMCustomObject *customObject = [[NIMCustomObject alloc]init];
    customObject.attachment = attachment;
    message.messageObject = customObject;
    if (needApns) {
        message.apnsContent = apnsContent;
    }
    
    NSMutableDictionary *memberExtDic = [NSMutableDictionary dictionary];
    
    NSMutableDictionary *realMeExt = [NSMutableDictionary dictionary];
    
    [realMeExt removeObjectForKey:@"banner"];
    [realMeExt removeObjectForKey:@"open_effect"];
    [realMeExt removeObjectForKey:@"halo"];
    [realMeExt removeObjectForKey:@"headwear"];
    [realMeExt removeObjectForKey:@"recommend"];
    [realMeExt removeObjectForKey:@"pic"];
    [realMeExt removeObjectForKey:@"cardbg"];
    [realMeExt removeObjectForKey:@"zonebg"];
    
    [memberExtDic setValuesForKeysWithDictionary:meRoomExt];

    if (type == NIMSessionTypeChatroom) {
        message.remoteExt = memberExtDic;
    }
    message.antiSpamOption = option;
    
    NIMMessageSetting *setting = [[NIMMessageSetting alloc]init];
    setting.apnsEnabled = needApns;
    message.setting = setting;
    
    //构造会话
    NIMSession *session = [NIMSession session:sessionId type:type];
    [[NIMSDK sharedSDK].chatManager sendMessage:message toSession:session error:nil];
    
    [GetCore(MessageCollection) sendMessageCollectionRequestWithMessage:message firstAttachment:attachment.first];
}

- (void)sendStrangerTextMessage:(NSString *)text nick:(NSString *)communityNick sessionId:(NSString *)sessionId type:(NIMSessionType)type{
    BOOL isEmpty = [NSString isEmpty:text];
    if (isEmpty) {
        return;
    }
    //添加扩展信息
    NIMMessageChatroomExtension *ext = [[NIMMessageChatroomExtension alloc]init];
    UserInfo *userInfo = [GetCore(UserCore)getUserInfoInDB:[GetCore(AuthCore) getUid].userIDValue];
    ext.roomNickname = userInfo.nick;
    ext.roomAvatar = userInfo.avatar;
    NSMutableDictionary *meRoomExt = nil;
    meRoomExt = [[NSString dictionaryWithJsonString:GetCore(ImRoomCoreV2).myMember.roomExt] mutableCopy];
    
    NSMutableDictionary *memberExtDic = [NSMutableDictionary dictionary];
    [memberExtDic setValuesForKeysWithDictionary:meRoomExt];
    ext.roomExt = [memberExtDic yy_modelToJSONString];
    //构造消息
    NIMMessage *message = [[NIMMessage alloc] init];
    message.text    = text;
    if (message.text.length <= 0) {
        return;
    }
    NSMutableDictionary *aps = [NSMutableDictionary dictionary];
    NSMutableDictionary *alert = [NSMutableDictionary dictionary];
    [alert safeSetObject:[NSString stringWithFormat:@"%@:%@",[GetCore(UserCore)getUserInfoInDB:[GetCore(AuthCore)getUid].userIDValue].communityNick,message.text] forKey:@"body"];
    [aps safeSetObject:alert forKey:@"alert"];
    NSDictionary *dic = @{@"alert":[alert copy]};
    message.apnsPayload = @{@"apsField":dic};
    message.apnsContent = [NSString stringWithFormat:@"%@:%@",[GetCore(UserCore)getUserInfoInDB:[GetCore(AuthCore)getUid].userIDValue].communityNick,message.text];
    message.messageExt = ext;
    message.remoteExt = memberExtDic;
    //构造会话
    NIMSession *session = [NIMSession session:sessionId type:type];
    
    //发送消息
    [[NIMSDK sharedSDK].chatManager sendMessage:message toSession:session error:nil];
    
    [GetCore(MessageCollection) sendMessageCollectionRequestWithMessage:message firstAttachment:0];
}

- (void)resendP2pMessage:(NIMMessage *)message{
    
    [[NIMSDK sharedSDK].chatManager resendMessage:message error:nil];
}

- (void)sendMessageReceipt:(NSArray *)messages {
    
    //只有在当前 Application 是激活的状态下才发送已读回执
    if ([[UIApplication sharedApplication] applicationState] == UIApplicationStateActive){
        
        //找到最后一个需要发送已读回执的消息标记为已读
        for (NSInteger i = [messages count] - 1; i >= 0; i--) {
            id item = [messages objectAtIndex:i];
            NIMMessage *message = nil;
            if ([item isKindOfClass:[NIMMessage class]]){
                message = item;
            }
            if (!message.isOutgoingMsg) {
                NIMMessageReceipt *receipt = [[NIMMessageReceipt alloc] initWithMessage:message];
                [[[NIMSDK sharedSDK] chatManager] sendMessageReceipt:receipt
                                                          completion:^(NSError * _Nullable error) {
                                                              
                                                          }];  //忽略错误,如果失败下次再发即可
            }
        }
    }
}

- (void)updateMessage:(NIMMessage *)message session:(NIMSession *)session {
    [[NIMSDK sharedSDK].conversationManager updateMessage:message forSession:session completion:^(NSError * _Nullable error) {
        if (!error) {
            NotifyCoreClient(ImMessageCoreClient, @selector(onUpdateMessageSuccess:), onUpdateMessageSuccess:message);
        }
    }];
}


- (nullable NSArray<NIMMessage *> *)getMessagesInSession:(NIMSession *)session
                                                 message:(nullable NIMMessage *)message
                                                   limit:(NSInteger)limit{
    return [[[NIMSDK sharedSDK] conversationManager] messagesInSession:session
                                                               message:message
                                                                 limit:limit];
}



- (NSString *)antiSpam:(NSString *)orginString withMessage:(NIMMessage *)message  {
    
    NIMLocalAntiSpamCheckOption *option = [[NIMLocalAntiSpamCheckOption alloc]init];
    option.content = orginString;
    option.replacement = @"***";
    NIMLocalAntiSpamCheckResult *rs = [[NIMSDK sharedSDK].antispamManager checkLocalAntispam:option error:nil];
    
    switch (rs.type) {
        case NIMAntiSpamResultLocalForbidden:
        {
            return nil;
        }
            break;
        case NIMAntiSpamResultNotHit:
        {
            
        }
            break;
        case NIMAntiSpamResultLocalReplace:
        {
            NIMAntiSpamOption *option = [[NIMAntiSpamOption alloc]init];
            option.hitClientAntispam = YES;
            message.antiSpamOption = option;
            return rs.content;
        }
            break;
        case NIMAntiSpamOperateFileNotExists:
        {
            
        }
            break;
        case NIMAntiSpamResultServerForbidden:
        {
            NIMAntiSpamOption *option = [[NIMAntiSpamOption alloc]init];
            option.hitClientAntispam = YES;
            message.antiSpamOption = option;
            return orginString;
        }
            break;
        default:
            break;
    }
    
    return orginString;
}



#pragma mark - private method

- (void)handleNoNotifyTeamUnReadCount:(NIMRecentSession *)recentSession {
    if (recentSession.session.sessionType == NIMSessionTypeTeam) {
        if (recentSession.unreadCount > 0) {
            NIMTeam *team = [[NIMSDK sharedSDK].teamManager teamById:recentSession.session.sessionId];
            if (team.notifyStateForNewMsg == NIMTeamNotifyStateNone || team.notifyStateForNewMsg == NIMTeamNotifyStateOnlyManager) {
                [[NIMSDK sharedSDK].conversationManager markAllMessagesReadInSession:recentSession.session];
            }
            
        }
    }
}

// 重置失败重发消息计数
- (void)cleanFailMsgResendCount {
    if (self.resendCount) {
        NSString *eventString = [NSString stringWithFormat:@"房间礼物消息发送失败后重发成功-第%ld次", (long)self.resendCount];
        [TTStatisticsService trackEvent:@"room_gift_retry_succeed" eventDescribe:eventString];
    }
    _resendCount = 0; // 赠送礼物发送公屏消息成功后，置空次数
}

// 礼物消息重发
- (void)resendGiftMsg:(NIMMessage *)message {
    // 埋点
    if (self.resendCount) {
        [TTStatisticsService trackEvent:@"room_gift_retry_failed" eventDescribe:@"房间礼物消息发送失败后重发失败"];
    } else {
        [TTStatisticsService trackEvent:@"room_gift_failed" eventDescribe:@"房间礼物消息发送失败"];
    }
    
    // 失败后30秒重发一次，最多三次
    @weakify(self);
    dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(30.0/*延迟执行时间*/ * NSEC_PER_SEC));
    dispatch_after(delayTime, dispatch_get_main_queue(), ^{
        @strongify(self);
        
        // 不在房间内时就不进行操作
        if (!GetCore(ImRoomCoreV2).isInRoom) {
            NSLog(@"房间礼物消息-退出房间不再重试");
            return;
        }
        
        if (self.resendCount >= kMaxCount) {
            self.resendCount = 0;
            return; // 最多重新发送三次
        }
        
        // 通过礼物发送消息失败的回调重新发送礼物公屏消息
        [[NIMSDK sharedSDK].chatManager resendMessage:message error:nil];
        
        self.resendCount += 1;
    });
}

#pragma mark - Getter

- (dispatch_queue_t)attrCreatQueue {
    if (!_attrCreatQueue) {
        _attrCreatQueue = dispatch_queue_create("com.yy.attr.creat", DISPATCH_QUEUE_SERIAL);
    }
    return _attrCreatQueue;
}

- (NSDateFormatter *)dateFormatter {
    if (!_dateFormatter) {
        //        _dateFormatter = p[
        _dateFormatter = [[NSDateFormatter alloc] init];
        NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Beijing"];
        [_dateFormatter setTimeZone:timeZone];
        [_dateFormatter setDateStyle:NSDateFormatterMediumStyle];
        [_dateFormatter setTimeStyle:NSDateFormatterShortStyle];
        [_dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        
    }
    return _dateFormatter;
}

- (NSCache *)radiousImageCache {
    if (!_radiousImageCache) {
        _radiousImageCache = [[NSCache alloc]init];
    }
    return _radiousImageCache;
}


@end

