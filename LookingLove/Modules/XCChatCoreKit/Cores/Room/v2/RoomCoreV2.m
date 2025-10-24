//
//  RoomCoreV2.m
//  BberryCore
//
//  Created by Mac on 2017/12/12.
//  Copyright © 2017年 chenran. All rights reserved.
//

#import "RoomCoreV2.h"
#import "HttpRequestHelper+Room.h"

#import "RoomQueueCoreV2.h"
#import "RoomQueueCoreClient.h"
#import "AuthCore.h"
#import "AuthCoreClient.h"
#import "MeetingCore.h"
#import "MeetingCoreClient.h"
#import "ImMessageCore.h"
#import "ImMessageCoreClient.h"
#import "FaceCore.h"
#import "FaceCoreClient.h"
#import "ImRoomCoreV2.h"
#import "ImRoomCoreClient.h"
#import "ImRoomCoreClientV2.h"
#import "RoomMessageClient.h"
#import "GiftCore.h"
#import "UserCore.h"
#import "GameCore.h"
#import "RoomMagicCore.h"
#import "RoomRedClient.h"

#import "GiftReceiveInfo.h"
#import "ShareSendInfo.h"
#import "Attachment.h"
#import "RoomQueueAttachment.h"
#import "XCArrangeMicAttachment.h"
#import "XCRoomGiftValueSyncAttachment.h"
#import "TTRoomLoveModelAttachment.h"

#import "NSObject+YYModel.h"
#import "NSString+JsonToDic.h"
#import "YYUtility.h"
#import "VersionCore.h"

#import "FaceSendInfo.h"
#import "WBNamePlateChanelNotifyInfo.h"


#import "GiftCoreClient.h"
//排麦
#import "ArrangeMicCore.h"
#import "XCArrangeMicAttachment.h"

#import "XCMacros.h"
#import "XCHUDTool.h"
#import "XCCurrentVCStackManager.h"

#import "XChatWeakTimer.h"

#import "TTGameCPPrivateChatModel.h"
#import "TTGameStaticTypeCore.h"

#import "XCRoomSuperAdminAttachment.h"

@interface RoomCoreV2()<ImRoomCoreClient, ImRoomCoreClientV2, ImMessageCoreClient,AuthCoreClient, MeetingCoreClient, RoomQueueCoreClient,FaceCoreClient>

@property (nonatomic, strong) dispatch_source_t timer; //计时器

@property (nonatomic,assign) ProjectType cacheProjectType;

@property (nonatomic, assign) BOOL isShowCPMessage;
@end

@implementation RoomCoreV2
{
    NSTimer *_notifyChannelTextTimer;//用来通知公屏更新
}

- (instancetype)init{
    self = [super init];
    if (self) {
        AddCoreClient(ImRoomCoreClient, self);
        AddCoreClient(ImMessageCoreClient, self);
        AddCoreClient(AuthCoreClient, self);
        AddCoreClient(MeetingCoreClient, self);
        AddCoreClient(ImRoomCoreClientV2, self);
        AddCoreClient(RoomQueueCoreClient, self);
        AddCoreClient(FaceCoreClient, self);
    }
    return self;
}
- (void)dealloc{
    RemoveCoreClientAll(self);
}





#pragma mark - Dragon Ball
/**
 获取龙珠
 
 @param roomUid 房间id
 @param uid  用户id
 */
- (void)getDragonWithRoomUid:(UserID )roomUid
                         uid:(UserID )uid
                     success:(void (^)(NSArray* ballList, BOOL isNew))success
                     failure:(void (^)(NSNumber *code, NSString *msg))failure{
    
    [HttpRequestHelper getDragonBallWithRoomUid:roomUid uid:uid success:^(NSArray *ballList,BOOL isNew) {
        if (success) {
            success(ballList,isNew);
        }
    } failure:^(NSNumber *code, NSString *msg) {
        if (failure) {
            failure(code,msg);
        }
    }];
    
}

/**
 清除龙珠状态
 @param roomUid 房间id
 @param uid  用户id
 */
- (void)clearDragonWithRoomUid:(UserID )roomUid uid:(UserID )uid {
    [HttpRequestHelper clearDragonBallWithRoomUid:roomUid uid:uid success:^(BOOL success) {
    } failure:^(NSNumber *code, NSString *msg) {
    }];
    
}



#pragma mark - ImMessageCoreClient
//收到text消息

- (void)onRecvChatRoomTextMsg:(NIMMessage *)msg{
    
    [self addMessageToArray:msg];
}
//收到自定义消息
- (void)onRecvChatRoomCustomMsg:(NIMMessage *)msg{
    [self handlerCustomMsg:msg];
    
}

//系统广播
- (void)onRecvAnBroadcastMsg:(NIMBroadcastMessage *)msg{
    
    if (msg.content) {
        NSDictionary *msgDictionary = [NSString dictionaryWithJsonString:msg.content];
        
        Attachment *attachment = [Attachment yy_modelWithJSON:msgDictionary[@"body"]];
        if (attachment.first == Custom_Noti_Header_NobleNotify) {
            //贵族
            NotifyCoreClient(RoomCoreClient, @selector(onReceiveNobleBroadcastMsg:), onReceiveNobleBroadcastMsg:msg.content);
        }else if (attachment.first == Custom_Noti_Header_Gift && attachment.second == Custom_Noti_Sub_Gift_ChannelNotify){
            //礼物
            NotifyCoreClient(RoomCoreClient, @selector(onReceiveGiftBoardcast:), onReceiveGiftBoardcast:msg.content);
        }else if (attachment.first == Custom_Noti_Header_Game){//怪兽
            
            NotifyCoreClient(RoomCoreClient, @selector(onReceiveMonsterGameBoardcast:), onReceiveMonsterGameBoardcast:msg.content);
        } else if (attachment.first == Custom_Noti_Header_Red) {
            if (attachment.second == Custom_Noti_Sub_Red_Authority_All ||
                attachment.second == Custom_Noti_Sub_Red_Authority_Specific) {
                
                XCRedAuthorityAttachment *attach = [XCRedAuthorityAttachment modelWithJSON:msgDictionary[@"body"]];
                attach.hideRedPacket = [[attach.data objectForKey:@"hideRedPacket"] boolValue];
                
                GetCore(ImRoomCoreV2).currentRoomInfo.hideRedPacket = attach.hideRedPacket;
                GetCore(RoomCoreV2).hideRedPacket = attach.hideRedPacket;
                
                NotifyCoreClient(RoomRedClient, @selector(onReceiveRedAuthorityChange:), onReceiveRedAuthorityChange:attach);
            }
        } else if (attachment.first == Custom_Noti_Header_Broadcast) {

            if (attachment.second == Custom_Noti_Sub_Broadcast_Nameplate) {
                //铭牌全屏
                NSArray *dataArray = [WBNamePlateChanelNotifyInfo modelsWithArray:attachment.data[@"list"]];
                NotifyCoreClient(GiftCoreClient, @selector(onReceiveNamePlateChannelNotify:), onReceiveNamePlateChannelNotify:dataArray);
                
            } else if (attachment.second == Custom_Noti_Sub_Broadcast_Annual) {
                //年度全服公告
                MessageLayout *layout = [MessageLayout yy_modelWithJSON:attachment.data[@"layout"]];
                
                AnnualBroadcastNotifyInfo *info = [AnnualBroadcastNotifyInfo modelWithJSON:attachment.data];
                info.layout = layout;
                
                NotifyCoreClient(GiftCoreClient, @selector(onReceiveAnnualBroadcastNotify:), onReceiveAnnualBroadcastNotify:info);
            }
        }
        
        
        //收到通知的时候 刷新首页
        NotifyCoreClient(RoomCoreClient, @selector(onReceiveAllBoardcast:), onReceiveAllBoardcast:msg.content);
        
        
    }
}
// && attachment.first != Custom_Noti_Header_Game

//发送聊天室消息成功

- (void)onSendChatRoomMessageSuccess:(NIMMessage *)msg {
    if (msg.messageType == NIMMessageTypeCustom) {
        NIMCustomObject *obj = (NIMCustomObject *)msg.messageObject;
        Attachment *attachment = (Attachment *)obj.attachment;
        
        if (attachment.first != Custom_Noti_Header_Face &&
            attachment.second != Custom_Noti_Sub_NobleNotify_Welocome &&
            attachment.first != Custom_Noti_Header_Gift &&
            attachment.first != Custom_Noti_Header_ALLMicroSend &&
            attachment.first != Custom_Noti_Header_Segment_AllMicSend &&
            attachment.first != Custom_Noti_Header_RoomMagic &&
            attachment.first != Custom_Noti_Header_CarNotify &&
            attachment.first != Custom_Noti_Header_Game &&
            attachment.first != Custom_Noti_Header_Box) {
            
            if (attachment.second == Custom_Noti_Sub_Update_RoomInfo_AnimateEffect){
                if (!self.hasChangeGiftEffectControl) {
                    [self addMessageToArray:msg];
                }
            }else if (attachment.second == Custom_Noti_Sub_Update_RoomInfo_AgoraAudioQuity){
                
                if ([self getMicStateByUid:GetCore(AuthCore).getUid.userIDValue]) {
                    [GetCore(MeetingCore) resetMeeting:[NSString stringWithFormat:@"%ld",GetCore(ImRoomCoreV2).currentRoomInfo.roomId] actor:YES];
                }else{
                    [GetCore(MeetingCore) resetMeeting:[NSString stringWithFormat:@"%ld",GetCore(ImRoomCoreV2).currentRoomInfo.roomId] actor:YES];
                }
                
                if (GetCore(ImRoomCoreV2).currentRoomInfo.audioQuality == AudioQualityType_High) {
                    [self addMessageToArray:msg];
                }
            }else if (attachment.first == Custom_Noti_Header_Dragon){
                if (attachment.second != Custom_Noti_Sub_Dragon_Start) {
                    [self addMessageToArray:msg];
                }
                
            } else if (attachment.first == Custom_Noti_Header_Queue){
                if (attachment.second == Custom_Noti_Sub_Queue_Invite) {
                    //房间开启排麦的时候 被抱上麦需要公屏显示
                    RoomInfo *  infor = [GetCore(RoomCoreV2) getCurrentRoomInfo];
                    if (infor.roomModeType == RoomModeType_Open_Micro_Mode) {
                        XCInviteMicAttachment *inviteatt = [XCInviteMicAttachment yy_modelWithJSON:attachment.data];
                        if (inviteatt.targetNick && inviteatt.targetNick.length > 0) {
                            [self addMessageToArray:msg];
                        }
                    }
                }else if (attachment.second == Custom_Noti_Sub_Queue_Kick){
                    ChatRoomQueueNotifyModel *notifyInfo = [ChatRoomQueueNotifyModel yy_modelWithJSON:attachment.data];
                    if (notifyInfo.targetNick && notifyInfo.targetNick.length > 0 && notifyInfo.handleNick.length >= 0) {
                        [self addMessageToArray:msg];
                    }
                }
            }else if (attachment.first == Custom_Noti_Header_CPGAME){
                if (attachment.second == Custom_Noti_Sub_CPGAME_Open || attachment.second == Custom_Noti_Sub_CPGAME_Select || attachment.second == Custom_Noti_Sub_CPGAME_Start || attachment.second == Custom_Noti_Sub_CPGAME_End || attachment.second == Custom_Noti_Sub_CPGAME_Close || attachment.second == Custom_Noti_Sub_CPGAME_Ai_Enter) {
                    [self addMessageToArray:msg];
                }
            }else if (attachment.first == Custom_Noti_Header_CPGAME_PublicChat_Respond){
                if (attachment.second == Custom_Noti_Sub_CPGAME_PublicChat_Respond_Accept || attachment.second == Custom_Noti_Sub_CPGAME_PublicChat_Respond_Cancel) {
                    
                }
                
            } else if (attachment.first == Custom_Noti_Header_GiftValue) {
                //更新礼物值不走公屏，所以这里只是接下逻辑判断，不做处理
                
            } else if (attachment.first == Custom_Noti_Header_Room_LeaveMode) {
                if (attachment.second == Custom_Noti_Sub_Room_LeaveMode_Notice) {
                    //  离开模式状态m
                    NotifyCoreClient(RoomCoreClient, @selector(onNoticeRoomIsOpenLeaveMode:), onNoticeRoomIsOpenLeaveMode:msg);
                }
            } else if (attachment.first == Custom_Noti_Header_RoomPublicScreen) {
                if (attachment.second == Custom_Noti_Sub_RoomPublicScreen_greeting) {
                    //只给目标用户发欢迎语，欢迎语仅对被欢迎者和欢迎者可见，这里是欢迎者视角
                    UserID fromUid = msg.from.userIDValue;
                    if (fromUid == GetCore(AuthCore).getUid.userIDValue) {
                        NSMutableDictionary *mdict = [attachment.data mutableCopy];
                        [mdict setObject:@(YES) forKey:@"isFans"];
                        attachment.data = mdict.copy;
                        
                        [self addMessageToArray:msg];
                    }
                }
                
            } else if (attachment.first == Custom_Noti_Header_Room_Tip) {
                if (attachment.second == Custom_Noti_Header_Room_Tip_Attentent_Owner) {
                    NotifyCoreClient(RoomCoreClient, @selector(onRecvFocusOwner:), onRecvFocusOwner:msg);
                }
                
                [self addMessageToArray:msg];
                
            } else if (attachment.first == Custom_Noti_Header_RoomLoveModelFirst) {
                if (attachment.second == Custom_Noti_Sub_Room_LoveModel_Sec_PublicLoveEffect) {
                    NotifyCoreClient(RoomCoreClient, @selector(onRecvBlindDatePublicLoveResult:), onRecvBlindDatePublicLoveResult:msg);
                }
            } else {
                [self addMessageToArray:msg];
            }
        }
        
    } else {
        [self addMessageToArray:msg];
    }
}

#pragma mark - ImRoomCoreClientV2
//进入聊天室成功
- (void)onMeInterChatRoomSuccess{
    if (GetCore(ImRoomCoreV2).currentRoomInfo == nil) {
        return;
    }
    //轻聊房房主为-1
    if (GetCore(AuthCore).getUid.userIDValue == GetCore(ImRoomCoreV2).currentRoomInfo.uid && GetCore(ImRoomCoreV2).currentRoomInfo.type == RoomType_Party){
        [GetCore(RoomQueueCoreV2) upMic:-1];
        NSLog(@"====");
    }
    
    
#ifdef DEBUG
    //        [GetCore(GiftCore) startGiftTimer];
    //        [GetCore(RoomMagicCore) startMagicTimer];
    //        [GetCore(FaceCore) startFaceTimer];
    //        [GetCore(GameCore) startAttackTimer];
    //        __block int i = 0;
    //    @KWeakify(self);
    //        [XChatWeakTimer scheduledTimerWithTimeInterval:0.1 block:^(id userInfo) {
    //            @KStrongify(self);
    //            int x = i++;
    ////            [GetCore(ImRoomCoreV2) s0endMessage:[NSString stringWithFormat:@"%d---%d",x,x+1]];
    //            NIMMessage *message = [[NIMMessage alloc]init];
    //            NIMSession *session = [NIMSession session:GetCore(ImRoomCoreV2).currentChatRoom.roomId type:NIMSessionTypeChatroom];
    //            [message setValue:session forKey:@"session"];
    //            [message setValue:GetCore(AuthCore).getUid forKey:@"from"];
    //            message.text = [NSString stringWithFormat:@"%d---%d",x,x+1];
    //            [self addMessageToArray:message];
    //
    //        } userInfo:nil repeats:YES];
#else
    //do sth.
#endif
    
    [self reportUserInterRoom];//上报进入房间
    [self startRoomTimer];
    
    //轻聊房房主为-1
    if (GetCore(AuthCore).getUid.userIDValue == GetCore(ImRoomCoreV2).currentRoomInfo.uid && GetCore(ImRoomCoreV2).currentRoomInfo.type == RoomType_Party){
        [GetCore(RoomQueueCoreV2) upMic:-1];
    }
    
    if (GetCore(ImRoomCoreV2).currentRoomInfo.type == RoomType_Game) {
      
        [GetCore(MeetingCore) joinMeeting:[NSString stringWithFormat:@"%ld",(long)GetCore(ImRoomCoreV2).currentRoomInfo.roomId] actor:NO];

    }else if (GetCore(ImRoomCoreV2).currentRoomInfo.type == RoomType_CP){
        //判断是否为房主
        if (GetCore(ImRoomCoreV2).currentRoomInfo.uid == GetCore(AuthCore).getUid.userIDValue) {
            [GetCore(RoomQueueCoreV2) upMic:-1];
            [GetCore(MeetingCore) joinMeeting:[NSString stringWithFormat:@"%ld",(long)GetCore(ImRoomCoreV2).currentRoomInfo.roomId] actor:YES];
        }else{
            [GetCore(MeetingCore) joinMeeting:[NSString stringWithFormat:@"%ld",(long)GetCore(ImRoomCoreV2).currentRoomInfo.roomId] actor:NO];
        }
    }else{
        //判断是否为房主
        if (GetCore(ImRoomCoreV2).currentRoomInfo.uid == GetCore(AuthCore).getUid.userIDValue) {
            [GetCore(RoomQueueCoreV2) upMic:-1];
            [GetCore(MeetingCore) joinMeeting:[NSString stringWithFormat:@"%ld",(long)GetCore(ImRoomCoreV2).currentRoomInfo.roomId] actor:YES];
        }else{
            [GetCore(MeetingCore) joinMeeting:[NSString stringWithFormat:@"%ld",(long)GetCore(ImRoomCoreV2).currentRoomInfo.roomId] actor:NO];
        }
    }
}

//退出房
- (void)onMeExitChatRoomSuccessV2{
    
#ifdef DEBUG
    [GetCore(GiftCore) cancelGiftTimer];
    [GetCore(FaceCore) cancelFaceTimer];
    [GetCore(RoomMagicCore) cancelMagicTimer];
    [GetCore(GameCore) cancelAttackTimer];
#else
    //do sth.
#endif
    //退出房间上报
    [self reportUserOuterRoom];
    [self cancelRoomRecord];
    if (GetCore(ImRoomCoreV2).currentRoomInfo.uid == [GetCore(AuthCore) getUid].userIDValue && GetCore(ImRoomCoreV2).currentRoomInfo.type != RoomType_Game) {
        [self closeRoom:GetCore(ImRoomCoreV2).currentRoomInfo.uid];
    }
    [GetCore(MeetingCore) leaveMeeting:[NSString stringWithFormat:@"%ld",(long)GetCore(ImRoomCoreV2).currentRoomInfo.roomId]];
    self.speakingList = nil;
    self.messages = nil;
    
}
//用户被踢
- (void)onUserBeKicked:(NSString *)roomid reason:(NIMChatroomKickReason)reason{
    
    [GetCore(MeetingCore) leaveMeeting:[NSString stringWithFormat:@"%ld",(long)GetCore(ImRoomCoreV2).currentRoomInfo.roomId]];
    self.speakingList = nil;
    self.messages = nil;
    //排麦别踢的话 取消排麦
    if (self.getCurrentRoomInfo.roomModeType == RoomModeType_Open_Micro_Mode && [GetCore(ArrangeMicCore).arrangeMicModel.myPos intValue] > 0) {
        [GetCore(ArrangeMicCore) userBegainOrCancleArrangeMicWith:1 operuid:[GetCore(AuthCore) getUid].userIDValue roomUid:self.getCurrentRoomInfo.uid];
    }
}

//用户被踢
- (void)onUserBeKicked:(NSString *)roomid kickResult:(NIMChatroomBeKickedResult *)kickResult{
    [self onUserBeKicked:roomid reason:kickResult.reason];
}

- (void)onUserBeKicked:(NIMMessage *)message{
    
}

//用户进入聊天室
- (void)onUserInterChatRoom:(NIMMessage *)message {
    
    if ([message.from isEqualToString:[GetCore(AuthCore)getUid]]) {
        self.currenDragonFaceSendInfo = nil;
    }
    
    NIMNotificationObject *notiMsg = (NIMNotificationObject *)message.messageObject;
    NIMChatroomNotificationContent *content = (NIMChatroomNotificationContent *)notiMsg.content;
    
    NSString *dict = ((NIMMessageChatroomExtension *)message.messageExt).roomExt;
    NSDictionary *userDic = [NSString dictionaryWithJsonString:dict];
    UserInfo *userInfo = [UserInfo yy_modelWithJSON:[userDic valueForKey:message.from]];
    
    BOOL enterRoom = content.eventType == NIMChatroomEventTypeEnter;
    BOOL superAdmin = userInfo.platformRole == XCUserInfoPlatformRoleSuperAdmin;
    BOOL superAdminEnterRoom = enterRoom && superAdmin;
    
    //超管进房不公屏通知
    if (!superAdminEnterRoom) {
        [self addMessageToArray:message];
    }
    
    [self addRoomCloseGiftEffectTip:message];
}

//收到移除管理更新通知
- (void)managerRemove:(NIMMessage *)message {
    if (message.messageType == NIMMessageTypeNotification) {
        NIMNotificationObject *notiMsg = (NIMNotificationObject *)message.messageObject;
        NIMChatroomNotificationContent *content = (NIMChatroomNotificationContent *)notiMsg.content;
        if (content.eventType == NIMChatroomEventTypeRemoveManager) {//移除管理员
            NIMChatroomNotificationMember *tempMember = content.targets[0];
            [[GetCore(ImRoomCoreV2) rac_queryChartRoomMemberByUid:tempMember.userId] subscribeNext:^(id x) {
                NIMChatroomMember *chatRoomMember = (NIMChatroomMember *)x;
                NSString *position = [self findThePositionByUid:chatRoomMember.userId.userIDValue];
                ChatRoomMicSequence *sequence = [GetCore(ImRoomCoreV2).micQueue objectForKey:position];
                sequence.chatRoomMember = chatRoomMember;
                NotifyCoreClient(RoomCoreClient, @selector(onManagerRemove:), onManagerRemove:chatRoomMember);
            }];
        }
    }
}
//收到添加管理更新通知
- (void)managerAdd:(NIMMessage *)message {
    if (message.messageType == NIMMessageTypeNotification) {
        NIMNotificationObject *notiMsg = (NIMNotificationObject *)message.messageObject;
        NIMChatroomNotificationContent *content = (NIMChatroomNotificationContent *)notiMsg.content;
        if (content.eventType == NIMChatroomEventTypeAddManager) {
            NIMChatroomNotificationMember *tempMember = content.targets[0];
            [[GetCore(ImRoomCoreV2) rac_queryChartRoomMemberByUid:tempMember.userId] subscribeNext:^(id x) {
                NIMChatroomMember *chatRoomMember = (NIMChatroomMember *)x;
                NSString *position = [self findThePositionByUid:chatRoomMember.userId.userIDValue];
                ChatRoomMicSequence *sequence = [GetCore(ImRoomCoreV2).micQueue objectForKey:position];
                sequence.chatRoomMember = chatRoomMember;
                NotifyCoreClient(RoomCoreClient, @selector(onManagerAdd:), onManagerAdd:chatRoomMember);
            }];
        }
    }
}
//black
- (void)onUserBeAddBlack:(NIMMessage *)message{
    
    if (message.messageType == NIMMessageTypeNotification) {
        NIMNotificationObject *notiMsg = (NIMNotificationObject *)message.messageObject;
        NIMChatroomNotificationContent *content = (NIMChatroomNotificationContent *)notiMsg.content;
        if (content.eventType == NIMChatroomEventTypeAddBlack) {
            NIMChatroomNotificationMember *tempMember = content.targets[0];
            [[GetCore(ImRoomCoreV2) rac_queryChartRoomMemberByUid:tempMember.userId] subscribeNext:^(id x) {
                NIMChatroomMember *chatRoomMember = (NIMChatroomMember *)x;
                NSString *position = [self findThePositionByUid:chatRoomMember.userId.userIDValue];
                //修改队列
                if (position) {
                    [GetCore(RoomQueueCoreV2) removeChatroomQueueWithPosition:position uid:tempMember.userId.userIDValue success:^(BOOL success) {
                        
                    } failure:^(NSString *message) {
                        
                    }];
                }
                ChatRoomMicSequence *sequence = [GetCore(ImRoomCoreV2).micQueue objectForKey:position];
                sequence.chatRoomMember = nil;
                sequence.userInfo = nil;
                
                NotifyCoreClient(RoomCoreClient, @selector(userBeAddBlack:), userBeAddBlack:chatRoomMember);
            }];
        }
    }
    
}
- (void)onUserBeRemoveBlack:(NIMMessage *)message{
    
    if (message.messageType == NIMMessageTypeNotification) {
        NIMNotificationObject *notiMsg = (NIMNotificationObject *)message.messageObject;
        NIMChatroomNotificationContent *content = (NIMChatroomNotificationContent *)notiMsg.content;
        if (content.eventType == NIMChatroomEventTypeRemoveBlack) {
            NIMChatroomNotificationMember *tempMember = content.targets[0];
            [[GetCore(ImRoomCoreV2) rac_queryChartRoomMemberByUid:tempMember.userId] subscribeNext:^(id x) {
                NIMChatroomMember *chatRoomMember = (NIMChatroomMember *)x;
                NSString *position = [self findThePositionByUid:chatRoomMember.userId.userIDValue];
                ChatRoomMicSequence *sequence = [GetCore(ImRoomCoreV2).micQueue objectForKey:position];
                sequence.chatRoomMember = chatRoomMember;
                NotifyCoreClient(RoomCoreClient, @selector(userBeRemoveBlack:), userBeRemoveBlack:chatRoomMember);
            }];
        }
    }
    
    
}

#pragma mark - MeetingCoreClient
//加入声网成功
- (void)onJoinMeetingSuccess
{
    UserID uid = [GetCore(AuthCore) getUid].userIDValue;
    if (GetCore(ImRoomCoreV2).currentRoomInfo.uid == uid) {
        if (GetCore(ImRoomCoreV2).currentRoomInfo.type != RoomType_Game) {
            [GetCore(MeetingCore)setMeetingRole:YES];
            [GetCore(MeetingCore)setCloseMicro:NO];
            
        }
    }
    [YYUtility checkMicPrivacy:^(BOOL succeed) {
        if (!succeed) {
            NotifyCoreClient(RoomCoreClient, @selector(thereIsNoMicoPrivacy), thereIsNoMicoPrivacy);
        }
    }];
    
}
//说话回调
- (void)onSpeakingUsersReport:(NSMutableArray *)userInfos
{
    self.speakingList = userInfos;
    
    NSMutableArray *uidArray = [NSMutableArray array];
    for (ChatRoomMicSequence *sequence in GetCore(ImRoomCoreV2).micQueue.allValues) {
        [uidArray addObject:@(sequence.userInfo.uid)];
    }
    
    if (projectType() != ProjectType_VKiss) {
        if (GetCore(ImRoomCoreV2).currentRoomInfo){ // 公聊和私聊的时候需要加入声网，但是不进入房间。不能静音
            for (NSNumber *uid in userInfos) {
                if (![uidArray containsObject:uid]) {//这里会把对方声音静音了
                    [GetCore(MeetingCore).engine muteRemoteAudioStream:uid.integerValue mute:YES];
                }else{
                    [GetCore(MeetingCore).engine muteRemoteAudioStream:uid.integerValue mute:false];
                }
            }
        }
    }
    
    NotifyCoreClient(RoomCoreClient, @selector(onSpeakUsersReport:), onSpeakUsersReport:self.speakingList);
}

- (void)onMySpeakingStateUpdate:(BOOL)speaking
{
    NotifyCoreClient(RoomCoreClient, @selector(onMySpeakStateUpdate:), onMySpeakStateUpdate:speaking);
}

#pragma mark - FaceCoreClient
- (void)onFaceIsResult:(FacePlayInfo *)info {
    if ([NSThread isMainThread]){
        [self addMessageToArray:info.message];
    }
}


#pragma mark - puble method
#pragma mark --room
//开拍卖房
-(void) rewardAndOpenRoom:(UserID)uid rewardMonye:(NSInteger)rewardMonye title:(NSString *)title roomDesc:(NSString *)roomDesc backPic:(NSString*)backPic
{
    if (uid <= 0) {
        return;
    }
    @weakify(self)
    [HttpRequestHelper rewardForRoom:uid servDura:30 rewardMonye:rewardMonye success:^(RewardInfo *rewardInfo) {
        if (rewardInfo.rewardId != nil) {
            @strongify(self)
            [self openRoom:uid type:RoomType_Party title:title roomDesc:roomDesc backPic:backPic rewardId:rewardInfo.rewardId];
        }
    } failure:^(NSNumber *resCode, NSString *message) {
        
    }];
}
//开启房间
- (void)openRoom:(UserID)uid type:(RoomType)type title:(NSString *)title roomDesc:(NSString *)roomDesc backPic:(NSString *)backPic rewardId:(NSString *)rewardId
{
    if (uid <= 0) {
        return;
    }
    @weakify(self);
    [HttpRequestHelper openRoom:uid type:type title:title roomDesc:roomDesc backPic:backPic rewardId:rewardId success:^(RoomInfo *roomInfo) {
        @strongify(self);
        NotifyCoreClient(RoomCoreClient, @selector(onOpenRoomSuccess:), onOpenRoomSuccess:roomInfo);
    } failure:^(NSNumber *resCode, NSString *message) {
        NotifyCoreClient(RoomCoreClient, @selector(onOpenRoomFailth:message:), onOpenRoomFailth:resCode message:message);
    }];
}

- (void)openCPRoom:(UserID)uid type:(RoomType)type title:(NSString *)title roomDesc:(NSString *)roomDesc backPic:(NSString *)backPic rewardId:(NSString *)rewardId success:(void (^)(BOOL success))success{
    
    if (uid <= 0) {
        return;
    }
    @weakify(self);
    [HttpRequestHelper openRoom:uid type:type title:title roomDesc:roomDesc backPic:backPic rewardId:rewardId success:^(RoomInfo *roomInfo) {
        @strongify(self);
        NotifyCoreClient(RoomCoreClient, @selector(onOpenRoomSuccess:), onOpenRoomSuccess:roomInfo);
        if (success) {
            success(YES);
        }
    } failure:^(NSNumber *resCode, NSString *message) {
        NotifyCoreClient(RoomCoreClient, @selector(onOpenRoomFailth:message:), onOpenRoomFailth:resCode message:message);
    }];
}

// 修改房间信息
- (void)updateGameRoomInfo:(NSDictionary *)infoDict
                      type:(UpdateRoomInfoType)type {
    [self updateGameRoomInfo:infoDict type:type hasAnimationEffect:GetCore(ImRoomCoreV2).currentRoomInfo.hasAnimationEffect audioQuality:GetCore(ImRoomCoreV2).currentRoomInfo.audioQuality eventType:RoomUpdateEventTypeOther];
}

- (void)updateGameRoomInfo:(NSDictionary *)infoDict
                      type:(UpdateRoomInfoType)type
        hasAnimationEffect:(BOOL)hasAnimationEffect
              audioQuality:(AudioQualityType)audioQuality
                 eventType:(RoomUpdateEventType)eventType {
    [HttpRequestHelper updateRoomInfo:infoDict type:type hasAnimationEffect:hasAnimationEffect audioQuality:audioQuality success:^(RoomInfo *roomInfo) {
        if (eventType == RoomUpdateEventTypeCloseGiftEffect) {
            [[BaiduMobStat defaultStat]logEvent:@"room_close_gift_effects_click" eventLabel:@"关闭礼物特效"];
        }
        [self handleUpdateRoomInfoSuccessCallBack:roomInfo eventType:eventType];
        
        if ([[infoDict allKeys] containsObject:@"isPureMode"]) {
            if ([infoDict[@"isPureMode"] boolValue] == roomInfo.isPureMode) {
                NSString *tip = @"管理员开启纯净模式，砸蛋消息将不在当前房间公屏展示";
                if (!roomInfo.isPureMode) {
                    tip = @"管理员关闭纯净模式";
                }
                
                Attachment *attachement = [[Attachment alloc]init];
                attachement.first = Custom_Noti_Header_Update_RoomInfo;
                attachement.second = Custom_Noti_Sub_Update_RoomInfo_Notice;
                attachement.data = @{@"tips" : tip};
                
                NSString *sessionID = [NSString stringWithFormat:@"%ld", GetCore(ImRoomCoreV2).currentRoomInfo.roomId];
                [GetCore(ImMessageCore) sendCustomMessageAttachement:attachement sessionId:sessionID type:(NIMSessionType)NIMSessionTypeChatroom];
            }
        }
        
    } failure:^(NSNumber *resCode, NSString *message) {
        NotifyCoreClient(RoomCoreClient, @selector(onGameRoomInfoUpdateFailth:), onGameRoomInfoUpdateFailth:message);
    }];
}


- (void)unlockRoomLimitType:(NSString *)limitType roomPwd:(NSString *)roomPwd success:(void (^)(void))success failure:(void (^)(NSNumber *, NSString *))failure {
 
    [HttpRequestHelper requestSettingUnlockRoomLimitType:limitType roomPwd:roomPwd success:^{
        
        success();
    } failure:^(NSNumber *resCode, NSString *message) {
        failure(resCode,message);
    }];
}

/*  CP 房 邀请 */
-(void)getRoomInviteUid:(NSArray *)array roomUid:(UserID )roomUid success:(void (^)(void))success{
    [HttpRequestHelper getRoomInviteByUids:array getRoomInfo:roomUid success:^{
        success();
    } failure:^(NSNumber *resCode, NSString *message) {
        NotifyCoreClient(RoomCoreClient, @selector(onGameRoomInfoUpdateFailth:), onGameRoomInfoUpdateFailth:message);
    }];
}

- (void)handleUpdateRoomInfoSuccessCallBack:(RoomInfo *)roomInfo eventType:(RoomUpdateEventType)eventType{
    
    
    Attachment *attachement = [[Attachment alloc]init];
    attachement.first = Custom_Noti_Header_Update_RoomInfo;
    NSString *sessionID = [NSString stringWithFormat:@"%ld",GetCore(ImRoomCoreV2).currentRoomInfo.roomId];
    attachement.data = [roomInfo model2dictionary];
    
    switch (eventType) {
        case RoomUpdateEventTypeCloseGiftEffect:
        {
            
            attachement.second = Custom_Noti_Sub_Update_RoomInfo_AnimateEffect;
            [GetCore(ImMessageCore)sendCustomMessageAttachement:attachement sessionId:sessionID type:(NIMSessionType)NIMSessionTypeChatroom];
        }
            break;
        case RoomUpdateEventTypeOpenAudioHight:
        case RoomUpdateEventTypeCloseAudioHight:
        {
            attachement.second = Custom_Noti_Sub_Update_RoomInfo_AgoraAudioQuity;
            [GetCore(ImMessageCore)sendCustomMessageAttachement:attachement sessionId:sessionID type:(NIMSessionType)NIMSessionTypeChatroom];
        }
            break;
        case RoomUpdateEventTypeOpenMessageView:
        case RoomUpdateEventTypeCloseMessageView:
        {
            attachement.second = Custom_Noti_Sub_Update_RoomInfo_MessageState;
            [GetCore(ImMessageCore)sendCustomMessageAttachement:attachement sessionId:sessionID type:(NIMSessionType)NIMSessionTypeChatroom];
        }
            break;
        default:
            break;
    }
    
    roomInfo.closeBox = GetCore(ImRoomCoreV2).currentRoomInfo.closeBox;
    [GetCore(ImRoomCoreV2) setCurrentRoomInfo:roomInfo];
    NotifyCoreClient(RoomCoreClient, @selector(onGameRoomInfoUpdateSuccess:eventType:), onGameRoomInfoUpdateSuccess:roomInfo eventType:eventType);
}

//处理关闭房间公屏的  超管
- (void)handleSuperAdminUpdateRoomInfoSuccessCallBack:(RoomInfo *)roomInfo eventType:(RoomUpdateEventType)eventType {
    XCRoomSuperAdminAttachment *attachement = [[XCRoomSuperAdminAttachment alloc]init];
    attachement.first = Custom_Noti_Header_Room_SuperAdmin;
    NSString *sessionID = [NSString stringWithFormat:@"%ld",GetCore(ImRoomCoreV2).currentRoomInfo.roomId];
    attachement.data = [roomInfo model2dictionary];
    
    SuperAdminOperateType operateType = SuperAdminOperateTypeOpenMessage;
    
    if (eventType == RoomUpdateEventTypeCloseMessageView) {
        attachement.second = Custom_Noti_Sub_Room_SuperAdmin_CloseChat;
        [GetCore(ImMessageCore)sendCustomMessageAttachement:attachement sessionId:sessionID type:(NIMSessionType)NIMSessionTypeChatroom];
        // 超管关闭公屏操作统计
        operateType = SuperAdminOperateTypeCloseMessage;
    }
    roomInfo.closeBox = GetCore(ImRoomCoreV2).currentRoomInfo.closeBox;
    // 超管开启公屏操作统计
    [GetCore(RoomCoreV2) recordSuperAdminOperate:operateType superAdminUid:[GetCore(AuthCore).getUid userIDValue] roomUid:roomInfo.uid targetUid:nil];
    
    [GetCore(ImRoomCoreV2) setCurrentRoomInfo:roomInfo];
NotifyCoreClient(RoomCoreClient, @selector(onGameRoomInfoUpdateSuccess:eventType:), onGameRoomInfoUpdateSuccess:roomInfo eventType:eventType);
}


//更新房间关闭公屏状态 是不是超管
- (void)updateRoomMessageViewState:(UserID)uid isCloseScreen:(BOOL)isCloseScreen isSuperAdmin:(BOOL)isSuperAdmin {
    [HttpRequestHelper updateRoomMessageViewState:uid isCloseScreen:isCloseScreen success:^(RoomInfo *info) {
        if (isSuperAdmin) {
            if (isCloseScreen) {
                [self handleSuperAdminUpdateRoomInfoSuccessCallBack:info eventType:RoomUpdateEventTypeCloseMessageView];
            }else{
                [self handleSuperAdminUpdateRoomInfoSuccessCallBack:info eventType:RoomUpdateEventTypeOpenMessageView];
            }
        }else {
            if (isCloseScreen) {
                [self handleUpdateRoomInfoSuccessCallBack:info eventType:RoomUpdateEventTypeCloseMessageView];
            }else{
                [self handleUpdateRoomInfoSuccessCallBack:info eventType:RoomUpdateEventTypeOpenMessageView];
            }
        }
    } failure:^(NSNumber *resCode, NSString *message) {
        NotifyCoreClient(RoomCoreClient, @selector(onGameRoomInfoUpdateFailth:), onGameRoomInfoUpdateFailth:message);
    }];
}

//更新房间关闭公屏状态
- (void)updateRoomMessageViewState:(UserID)uid isCloseScreen:(BOOL)isCloseScreen {
    [self updateRoomMessageViewState:uid isCloseScreen:isCloseScreen isSuperAdmin:NO];
}


//关闭房间
- (void)closeRoom:(UserID)uid{
    if (uid <= 0) {
        return;
    }
    [HttpRequestHelper closeRoom:uid success:^{
        NotifyCoreClient(RoomCoreClient, @selector(onCloseRoomSuccess), onCloseRoomSuccess);
    } failure:^(NSNumber *resCode, NSString *message) {
        NotifyCoreClient(RoomCoreClient, @selector(onCloseRoomFailth:code:), onCloseRoomFailth:message code:resCode);
    }];
}

- (void)closeRoomWithBlock:(UserID)uid Success:(void(^)(UserID uid))success failure:(void(^)(NSNumber *resCode, NSString *message))failure {
    if (uid <= 0) {
        return;
    }
    [HttpRequestHelper closeRoom:uid success:^{
        success(uid);
    } failure:^(NSNumber *resCode, NSString *message) {
        failure(resCode, message);
    }];
    
}


#pragma mark --房间信息相关
//根据房主id请求房间信息
- (RACSignal *)requestRoomInfo:(UserID)uid{
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [HttpRequestHelper getRoomInfo:uid success:^(RoomInfo *roomInfo) {
            [subscriber sendNext:roomInfo];
            [subscriber sendCompleted];
        } failure:^(NSNumber *resCode, NSString *message) {
            [subscriber sendError:CORE_API_ERROR(RoomCoreErrorDomain, resCode.integerValue, message)];
        }];
        return nil;
    }];
}
- (RoomInfo *)getCurrentRoomInfo{
    return GetCore(ImRoomCoreV2).currentRoomInfo;
}

//获取用户进入了的房间的信息
- (void)getUserInterRoomInfo:(UserID)uid {
    [HttpRequestHelper requestUserInRoomInfoBy:uid Success:^(RoomInfo *roomInfo) {
        NotifyCoreClient(RoomCoreClient, @selector(requestUserRoomInterInfo: uid:), requestUserRoomInterInfo:roomInfo uid:uid);
    } failure:^(NSNumber *resCode, NSString *message) {
        NotifyCoreClient(RoomCoreClient, @selector(requestUserRoomInterInfoFailth:), requestUserRoomInterInfoFailth:message);
    }];
}
//获取用户进入了的房间的信息 Bolck
- (void)getUserInterRoomInfo:(UserID)uid Success:(void (^)(RoomInfo *roomInfo))success failure:(void (^)(NSNumber *resCode, NSString *message))failure {
    [HttpRequestHelper requestUserInRoomInfoBy:uid Success:^(RoomInfo *roomInfo) {
        success(roomInfo);
    } failure:^(NSNumber *resCode, NSString *message) {
        failure(resCode, message);
    }];
}
//获取用户进入了的房间的信息 rac
- (RACSignal *)rac_getUserInterRoomInfo:(UserID)uid{
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [HttpRequestHelper requestUserInRoomInfoBy:uid Success:^(RoomInfo *roomInfo) {
            [subscriber sendNext:roomInfo];
            [subscriber sendCompleted];
        } failure:^(NSNumber *resCode, NSString *message) {
            NSError *error = [NSError errorWithDomain:NSCocoaErrorDomain code:[resCode integerValue] userInfo:@{NSLocalizedDescriptionKey:message}];
            [subscriber sendError:error];
        }];
        return nil;
    }];
}

/**
 开启房间离开模式
 interface 开启 room/leave/mode/open ， 关闭 room/leave/mode/close
 @param roomUid 房间uid
 @param leaveMode YES 开启 or NO 关闭
 */
- (void)requestChangeRoomLeaveMode:(long long)roomUid leaveMode:(BOOL)leaveMode {
    [HttpRequestHelper requestChangeRoomLeaveMode:roomUid leaveMode:leaveMode success:^(BOOL success) {
        NotifyCoreClient(RoomCoreClient, @selector(onChangeRoomLeaveModeSuccess:), onChangeRoomLeaveModeSuccess:leaveMode);
    } failure:^(NSNumber *code, NSString *msg) {
        NotifyCoreClient(RoomCoreClient, @selector(onChangeRoomLeaveModeFailth:code:), onChangeRoomLeaveModeFailth:msg code:code);
    }];
}

#pragma mark - blacklist
//判断自己是否在黑名单
- (void)judgeIsInBlackList:(NSString *)roomID {
    NSString *uid = [GetCore(AuthCore) getUid];
    NIMChatroomMembersByIdsRequest *request = [[NIMChatroomMembersByIdsRequest alloc]init];
    request.roomId = roomID;
    request.userIds = @[uid];
    [[NIMSDK sharedSDK].chatroomManager fetchChatroomMembersByIds:request completion:^(NSError * _Nullable error, NSArray<NIMChatroomMember *> * _Nullable members) {
        for (NIMChatroomMember *member in members) {
            if (member.isInBlackList) {
                NotifyCoreClient(AuthCoreClient, @selector(mySelfIsInBalckList:), mySelfIsInBalckList:YES);
            }else {
                NotifyCoreClient(AuthCoreClient, @selector(mySelfIsInBalckList:), mySelfIsInBalckList:NO);
            }
        }
    }];
}

//保存XCGameRoomPositionView计算的游戏房cell的位置
- (void)savePosition:(NSMutableArray *)list {
    self.positionArr = list;
}

#pragma mark - private method
//处理聊天室下发通知
- (void)handlerCustomMsg:(NIMMessage *)msg{
    
    NIMCustomObject *obj = (NIMCustomObject *)msg.messageObject;
    if (obj.attachment != nil && [obj.attachment isKindOfClass:[Attachment class]]) {
        Attachment *attachment = (Attachment *)obj.attachment;
        
        if (attachment.first == Custom_Noti_Header_Auction) {
            [self addMessageToArray:msg];
        } else if (attachment.first == Custom_Noti_Header_Gift) {//gift core handle
            
            //            [self addMessageToArray:msg];
            //在GiftCore里面已经处理了 所以这里就不要重复处理
            
        } else if (attachment.first == Custom_Noti_Header_Room_Tip) {
            [self addMessageToArray:msg];
        } else if (attachment.first == Custom_Noti_Header_ALLMicroSend) {//gift core handle
            
            //            [self addMessageToArray:msg];
            //在GiftCore里面已经处理了 所以这里就不要重复处理
            
        }else if (attachment.first == Custom_Noti_Header_NobleNotify) {
            if (attachment.second == Custom_Noti_Sub_NobleNotify_Open_Success || attachment.second == Custom_Noti_Sub_NobleNotify_Renew_Success) {
                [self addMessageToArray:msg];
            }
        }else if (attachment.first == Custom_Noti_Header_Queue){
            if (attachment.second == Custom_Noti_Sub_Queue_Kick) {//踢下麦
                XCInviteMicAttachment *queueAttachment = [XCInviteMicAttachment modelWithJSON:attachment.data];
                if (queueAttachment.targetNick.length <=0 || queueAttachment.handleNick.length <= 0) {
                    return;
                }
                [self addMessageToArray:msg];
                
                //被踢下麦就 视为 弃牌
                if(queueAttachment.uid.longLongValue == GetCore(AuthCore).getUid.longLongValue){
                    RoomInfo *roominfo = GetCore(RoomCoreV2).getCurrentRoomInfo;
                    [GetCore(RoomCoreV2) clearDragonWithRoomUid:roominfo.uid uid:GetCore(AuthCore).getUid.longLongValue];
                    GetCore(RoomCoreV2).currenDragonFaceSendInfo = nil;
                }
            }else if(attachment.second == Custom_Noti_Sub_Queue_Invite){
                RoomInfo * infor = [GetCore(RoomCoreV2) getCurrentRoomInfo];
                if (infor.roomModeType == RoomModeType_Open_Micro_Mode) {
                    XCInviteMicAttachment *inviteatt = [XCInviteMicAttachment yy_modelWithJSON:attachment.data];
                    if (inviteatt.targetNick && inviteatt.targetNick.length > 0) {
                        [self addMessageToArray:msg];
                    }
                }
            }
        }else if (attachment.first == Custom_Noti_Header_Kick){
            ChatRoomQueueNotifyModel *notifyInfo = [ChatRoomQueueNotifyModel yy_modelWithJSON:attachment.data];
            if (notifyInfo.targetNick.length <= 0 || notifyInfo.handleNick.length <= 0) {
                return;
            }
            if (attachment.second == Custom_Noti_Sub_Kick_BeKicked){//踢出房间
                [self addMessageToArray:msg];
                
            }else if (attachment.second == Custom_Noti_Sub_Kick_BlackList){//拉黑
                [self addMessageToArray:msg];
            }
        }else if (attachment.first == Custom_Noti_Header_Game) {
            if (GetCore(VersionCore).loadingData) {
                return;
            }
            if (attachment.second == Custom_Noti_Sub_Game_Start) {
                if (GetCore(VersionCore).loadingData) {
                    return;
                }
                MonsterGameModel *monster = [MonsterGameModel yy_modelWithJSON:attachment.data];
                if (monster.monsterStatus == MonsterStatus_WillAppear && monster) {
                    if (0 <monster.beforeAppearSeconds  && monster.beforeAppearSeconds<=15) {
                        [self addMessageToArray:msg];
                    }
                }else if(monster && monster.monsterStatus ==MonsterStatus_DidAppear){
                    [self addMessageToArray:msg];
                }
                
            }else if (attachment.second == Custom_Noti_Sub_Game_Result) {
                if (GetCore(VersionCore).loadingData) {
                    return;
                }
                [self addMessageToArray:msg];
            }
        }else if (attachment.first == Custom_Noti_Header_Update_RoomInfo){//房间开起高音质/关闭礼物特效
            if (attachment.second == Custom_Noti_Sub_Update_RoomInfo_AgoraAudioQuity) {
                if (projectType() == ProjectType_VKiss) {
                    [GetCore(MeetingCore) resetMeeting:[NSString stringWithFormat:@"%ld",GetCore(ImRoomCoreV2).currentRoomInfo.roomId] actor:YES];
                }else{
                    if ([self getMicStateByUid:GetCore(AuthCore).getUid.userIDValue]) {
                        [GetCore(MeetingCore) resetMeeting:[NSString stringWithFormat:@"%ld",GetCore(ImRoomCoreV2).currentRoomInfo.roomId] actor:YES];
                    }else{
                        [GetCore(MeetingCore) resetMeeting:[NSString stringWithFormat:@"%ld",GetCore(ImRoomCoreV2).currentRoomInfo.roomId] actor:NO];
                    }
                }
                if (GetCore(ImRoomCoreV2).currentRoomInfo.audioQuality == AudioQualityType_High) {
                    NotifyCoreClient(RoomCoreClient, @selector(onGameRoomInfoUpdateSuccess:eventType:), onGameRoomInfoUpdateSuccess:GetCore(ImRoomCoreV2).currentRoomInfo eventType:RoomUpdateEventTypeOpenAudioHight);
                    [self addMessageToArray:msg];
                }else{
                    NotifyCoreClient(RoomCoreClient, @selector(onGameRoomInfoUpdateSuccess:eventType:), onGameRoomInfoUpdateSuccess:GetCore(ImRoomCoreV2).currentRoomInfo eventType:RoomUpdateEventTypeCloseAudioHight);
                }
                
            }else if (attachment.second == Custom_Noti_Sub_Update_RoomInfo_AnimateEffect){
                if (!self.hasChangeGiftEffectControl) {
                    [self addMessageToArray:msg];
                }
            }else if (attachment.second == Custom_Noti_Sub_Update_RoomInfo_MessageState){
                [self addMessageToArray:msg];
            }else if (attachment.second == Custom_Noti_Sub_Update_RoomInfo_Notice){
                [self addMessageToArray:msg];
            }
        }else if (attachment.first == Custom_Noti_Header_Dragon){
            
            if (attachment.second != Custom_Noti_Sub_Dragon_Start) {
                //龙珠结果 展示
                [self addMessageToArray:msg];
            }
            NotifyCoreClient(RoomCoreClient, @selector(onRecvChatRoomDragonMsg:), onRecvChatRoomDragonMsg:msg);
        }else if (attachment.first == Custom_Noti_Header_Box){//开箱子
            
            if (attachment.second == Custom_Noti_Sub_Box_Me) {
                if ([attachment.data[@"uid"] longLongValue] == GetCore(AuthCore).getUid.userIDValue) {
                    [self addMessageToArray:msg];
                }
            }else if (attachment.second == Custom_Noti_Sub_Box_InRoom || attachment.second == Custom_Noti_Sub_Box_AllRoom){
                if (GetCore(ImRoomCoreV2).currentRoomInfo.isPureMode) {
                    if ([attachment.data[@"uid"] userIDValue] == GetCore(AuthCore).getUid.userIDValue) {
                        [self addMessageToArray:msg];
                    }
                } else {
                    [self addMessageToArray:msg];
                }
            }else if (attachment.second == Custom_Noti_Sub_Box_AllRoom_Notify){
                if (GetCore(ImRoomCoreV2).currentRoomInfo.isPureMode) {
                    if ([attachment.data[@"uid"] userIDValue] == GetCore(AuthCore).getUid.userIDValue) {
                        [self addMessageToArray:msg];
                    }
                } else {
                    [self addMessageToArray:msg];
                }
                NotifyCoreClient(RoomCoreClient, @selector(onReceiveOpenBoxBigPrizeMsg:), onReceiveOpenBoxBigPrizeMsg:msg);
            }else if (attachment.second == Custom_Noti_Sub_Box_OpenBoxCirt_Start){
                if (GetCore(ImRoomCoreV2).currentRoomInfo.isPureMode) {
                    if ([attachment.data[@"uid"] userIDValue] == GetCore(AuthCore).getUid.userIDValue) {
                        [self addMessageToArray:msg];
                    }
                } else {
                    [self addMessageToArray:msg];
                }
            }else if (attachment.second == Custom_Noti_Sub_Box_OpenBoxCirt_Win){
                if (GetCore(ImRoomCoreV2).currentRoomInfo.isPureMode) {
                    if ([attachment.data[@"uid"] userIDValue] == GetCore(AuthCore).getUid.userIDValue) {
                        [self addMessageToArray:msg];
                    }
                } else {
                    [self addMessageToArray:msg];
                }
            }
            
        } else if (attachment.first == Custom_Noti_Header_ArrangeMic){
            //开启排麦 关闭排麦
            if (attachment.second  ==Custom_Noti_Header_ArrangeMic_Mode_Open || attachment.second == Custom_Noti_Header_ArrangeMic_Mode_Close) {
                [self addMessageToArray:msg];
            }else if (attachment.second == Custom_Noti_Header_ArrangeMic_Free_Mic_Open || attachment.second == Custom_Noti_Header_ArrangeMic_Free_Mic_Close){
                XCArrangeMicAttachment * arrangeMicAtt = [XCArrangeMicAttachment yy_modelWithJSON:attachment.data];
                if (![arrangeMicAtt.micPos isEqualToString:@"-1"]) {
                    [self addMessageToArray:msg];
                }
            }
        }else if (attachment.first == Custom_Noti_Header_CPGAME_PrivateChat) {
            if (attachment.second == Custom_Noti_Sub_CPGAME_PrivateChat_LaunchGame) {
                TTGameCPPrivateChatModel *model = [TTGameCPPrivateChatModel modelWithJSON:attachment.data];
                for (int i = 0; i < GetCore(TTGameStaticTypeCore).privateMessageArray.count; i++) {
                    CPGameListModel *gameModel = [CPGameListModel modelWithJSON:GetCore(TTGameStaticTypeCore).privateMessageArray[i]];
                    if ([gameModel.gameId isEqualToString:model.gameInfo.gameId]) {
                        [self addMessageToArray:msg];
                        break;
                    }
                }
            }
        }else if (attachment.first == Custom_Noti_Header_CPGAME){
            if (attachment.second == Custom_Noti_Sub_CPGAME_RoomGame) {
                NIMCustomObject *obj = (NIMCustomObject *)msg.messageObject;
                Attachment *attachment = (Attachment *)obj.attachment;
                NotifyCoreClient(RoomCoreClient, @selector(responseRoomGame:), responseRoomGame:attachment);
                [self addMessageToArray:msg];
            }
            if (attachment.second == Custom_Noti_Sub_CPGAME_Select || attachment.second == Custom_Noti_Sub_CPGAME_Start) {
                TTGameCPPrivateChatModel *model = [TTGameCPPrivateChatModel modelWithJSON:attachment.data];
                for (int i = 0; i < GetCore(TTGameStaticTypeCore).privateMessageArray.count; i++) {
                    CPGameListModel *gameModel = [CPGameListModel modelWithJSON:GetCore(TTGameStaticTypeCore).privateMessageArray[i]];
                    if ([gameModel.gameId isEqualToString:model.gameInfo.gameId]) {
                        self.isShowCPMessage = YES;
                        [self addMessageToArray:msg];
                        break;
                    }else{
                        self.isShowCPMessage = NO;
                    }
                }
            }
            if (attachment.second == Custom_Noti_Sub_CPGAME_End) {
                TTCPGameCustomModel *model = [TTCPGameCustomModel modelWithJSON:attachment.data];
                for (int i = 0; i < GetCore(TTGameStaticTypeCore).privateMessageArray.count; i++) {
                    CPGameListModel *gameModel = [CPGameListModel modelWithJSON:GetCore(TTGameStaticTypeCore).privateMessageArray[i]];
                    if ([gameModel.gameId isEqualToString:model.gameResultInfo.gameId]) {
                        [self addMessageToArray:msg];
                        break;
                    }
                }
            } else if (attachment.second == Custom_Noti_Sub_CPGAME_Open || attachment.second == Custom_Noti_Sub_CPGAME_Close) {
                [self addMessageToArray:msg];
            }
            
        } else if (attachment.first == Custom_Noti_Header_Checkin) {//签到
            if (attachment.second == Custom_Noti_Sub_Checkin_Draw_second_coin) {//二级瓜分金币
                [self addMessageToArray:msg];
            }
        } else if (attachment.first == Custom_Noti_Header_GiftValue) {//礼物值
            
            if (attachment.second == Custom_Noti_Sub_GiftValue_sync) {//房间礼物值同步
                
                XCRoomGiftValueSyncAttachment *gvAttach = (XCRoomGiftValueSyncAttachment *)attachment;
                if ([gvAttach isKindOfClass:XCRoomGiftValueSyncAttachment.class]) {
                    
                    RoomOnMicGiftValue *model = [[RoomOnMicGiftValue alloc] init];
                    model.currentTime = gvAttach.currentTime;
                    model.giftValueVos = gvAttach.giftValueVos;
                    
                    NotifyCoreClient(RoomCoreClient, @selector(onReceiveCleanGiftValueSync:), onReceiveCleanGiftValueSync:model);

                }
            }
        } else if (attachment.first == Custom_Noti_Header_Room_LeaveMode) { // 房间离开模式
            if (attachment.second == Custom_Noti_Sub_Room_LeaveMode_Notice) {
                // do somethings
                NotifyCoreClient(RoomCoreClient, @selector(onNoticeRoomIsOpenLeaveMode:), onNoticeRoomIsOpenLeaveMode:msg);
            }
        }else if (attachment.first == Custom_Noti_Header_Game_LittleWorld) {
            if (attachment.second == Custom_Noti_Sub_Little_World_Room_Join_Notify) {
                [self addMessageToArray:msg];
            }
        } else if (attachment.first == Custom_Noti_Header_Room_SuperAdmin) {
//            if (attachment.second == Custom_Noti_Sub_Room_SuperAdmin_unLimmit || attachment.second == Custom_Noti_Sub_Room_SuperAdmin_unLock || attachment.second == Custom_Noti_Sub_Room_SuperAdmin_LockMic || attachment.second == Custom_Noti_Sub_Room_SuperAdmin_noVoiceMic || attachment.second == Custom_Noti_Sub_Room_SuperAdmin_DownMic || attachment.second == Custom_Noti_Sub_Room_SuperAdmin_Shield || attachment.second == Custom_Noti_Sub_Room_SuperAdmin_TickRoom || attachment.second == Custom_Noti_Sub_Room_SuperAdmin_TickManagerRoom || attachment.second == Custom_Noti_Sub_Room_SuperAdmin_CloseChat||attachment.second == Custom_Noti_Sub_Room_SuperAdmin_CloseRoom) {
                [self addMessageToArray:msg];
                if (attachment.second == Custom_Noti_Sub_Room_SuperAdmin_TickManagerRoom || attachment.second == Custom_Noti_Sub_Room_SuperAdmin_DownMic) {
                    NotifyCoreClient(RoomCoreClient, @selector(onReceiveSuperAdminKickUsersWithMessage:), onReceiveSuperAdminKickUsersWithMessage:msg);
                    
                }else if (attachment.second == Custom_Noti_Sub_Room_SuperAdmin_unLock||attachment.second == Custom_Noti_Sub_Room_SuperAdmin_unLimmit||attachment.second == Custom_Noti_Sub_Room_SuperAdmin_CloseRoom) {
                    NotifyCoreClient(RoomCoreClient, @selector(onReceiveSuperAdminOffical:), onReceiveSuperAdminOffical:msg);
                    
                }
//            }
            
        } else if (attachment.first == Custom_Noti_Header_RoomPublicScreen) {
            if (attachment.second == Custom_Noti_Sub_RoomPublicScreen_greeting) {
                //只给目标用户发欢迎语，欢迎语仅对被欢迎者和欢迎者可见，这里是被欢迎者视角
                UserID toUid = [attachment.data[@"targetUid"] longLongValue];
                if (toUid == GetCore(AuthCore).getUid.userIDValue) {
                    [self addMessageToArray:msg];
                }
            }
            
        } else if (attachment.first == Custom_Noti_Header_Red &&
                   !GetCore(VersionCore).loadingData) {//红包
            
            if (attachment.second == Custom_Noti_Sub_Red_Room_Current ||
                attachment.second == Custom_Noti_Sub_Red_Room_Other ||
                attachment.second == Custom_Noti_Sub_Red_Room_Draw) {
                
                if (attachment.second == Custom_Noti_Sub_Red_Room_Current) {
                    NotifyCoreClient(RoomRedClient, @selector(onReceiveCurrentRoomSendRed), onReceiveCurrentRoomSendRed);
                }
                
                [self addMessageToArray:msg];
            }
        } else if (attachment.first == Custom_Noti_Header_RoomLoveModelFirst) {
            if (attachment.second == Custom_Noti_Sub_Room_LoveModel_Sec_SrceenMsg ||
                attachment.second == Custom_Noti_Sub_Room_LoveModel_Sec_SuccessMsg) {
                [self addMessageToArray:msg];
            } else if (attachment.second == Custom_Noti_Sub_Room_LoveModel_Sec_DownMicToast) {
                
                TTRoomLoveModelAttachment *roomLoveAtt = [TTRoomLoveModelAttachment modelDictionary:attachment.data];
                // 抱下麦提示文案 && 被抱下麦的人中有自己才提示
                if (roomLoveAtt.msg && [roomLoveAtt.toUids containsObject:@(GetCore(AuthCore).getUid.userIDValue)]) {
                    [XCHUDTool showErrorWithMessage:roomLoveAtt.msg];
                }
            } else if (attachment.second == Custom_Noti_Sub_Room_LoveModel_Sec_Anmintions) {
                
                RoomLoveModelSuccess *successModel = [RoomLoveModelSuccess modelDictionary:attachment.data];
                NotifyCoreClient(RoomCoreClient, @selector(onRecvBlindDateResult:), onRecvBlindDateResult:successModel);
            } else if (attachment.second == Custom_Noti_Sub_Room_LoveModel_Sec_PublicLoveEffect) {
                NotifyCoreClient(RoomCoreClient, @selector(onRecvBlindDatePublicLoveResult:), onRecvBlindDatePublicLoveResult:msg);
            }
        }
    }
}




#pragma mark -
/*
 - (void)handlerDragonMessage:(NIMMessage *)message {
 if (!self.dragonArray) {
 self.dragonArray = @[].mutableCopy;
 }
 
 NIMCustomObject *obj = (NIMCustomObject *)message.messageObject;
 Attachment *attachment = (Attachment *)obj.attachment;
 FaceSendInfo *faceattachement = [FaceSendInfo yy_modelWithJSON:attachment.data];
 
 // 只保存最开始的状态 其他状态都会删除然后下发通知 给其他需要处理的去处理
 __block FaceSendInfo *find;
 [self.dragonArray enumerateObjectsUsingBlock:^(FaceSendInfo * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
 if (faceattachement.uid == obj.uid) {
 find = obj;
 *stop = YES;
 }
 
 }];
 
 if (find) {
 [self.dragonArray removeObject:find];
 }
 
 if (attachment.second == Custom_Noti_Sub_Dragon_Start) {
 [self.dragonArray addObject:faceattachement];
 NotifyCoreClient(FaceCoreClient, @selector(onReceiveMicDragonStateStart), onReceiveMicDragonStateStart);
 }else {
 //之前参与过龙珠 现在更新状态
 NotifyCoreClient(FaceCoreClient, @selector(onReceiveMicDragonStateChange:dragonInfo:), onReceiveMicDragonStateChange:attachment.second dragonInfo:faceattachement);
 }
 
 
 }
 */


//添加消息到内存，最多保留1000
- (void)addMessageToArray:(NIMMessage *)msg{
    if (self.cacheProjectType == 0) {
        self.cacheProjectType = projectType();
    }
    
    if (self.cacheProjectType == ProjectType_Pudding ||
        self.cacheProjectType == ProjectType_LookingLove ||
        self.cacheProjectType == ProjectType_Planet ||
        self.cacheProjectType == ProjectType_CeEr) {
        if (msg.session.sessionType == NIMSessionTypeChatroom && msg.session.sessionId.integerValue == GetCore(ImRoomCoreV2).currentRoomInfo.roomId) {
            NotifyCoreClient(RoomMessageClient, @selector(onReceiveMessageNeedDisplayOnScreen:), onReceiveMessageNeedDisplayOnScreen:msg);
        }
    }else {
        if (msg.session.sessionType == NIMSessionTypeChatroom && msg.session.sessionId.integerValue == GetCore(ImRoomCoreV2).currentRoomInfo.roomId) {
            BOOL force = NO;
            if (self.messages == nil) {
                self.messages = [NSMutableArray array];
                force = YES;
            }
            if (self.messages.count > 200) {
                NIMMessage *message = self.messages.firstObject;
                NotifyCoreClient(RoomCoreClient, @selector(onMessageDidRemoveFromCache:), onMessageDidRemoveFromCache:message);
                
                [self.messages removeObjectAtIndex:0];
            }
            [self.messages addObject:msg];
            
            [self _notifyReceiveChannelText:force];
        }
    }
}

- (void)addRoomCloseGiftEffectTip:(NIMMessage *)message{
    if (message.messageType == NIMMessageTypeNotification) {
        NIMNotificationObject *notiMsg = (NIMNotificationObject *)message.messageObject;
        NIMChatroomNotificationContent *content = (NIMChatroomNotificationContent *)notiMsg.content;
        NIMChatroomNotificationMember *member = content.targets[0];
        if (member.userId.integerValue == GetCore(AuthCore).getUid.integerValue) {
            if (!GetCore(ImRoomCoreV2).currentRoomInfo.hasAnimationEffect) {
                Attachment *attachement = [[Attachment alloc]init];
                attachement.first = Custom_Noti_Header_Update_RoomInfo;
                attachement.second = Custom_Noti_Sub_Update_RoomInfo_AnimateEffect;
                NIMMessage *tempMessage = [[NIMMessage alloc]init];
                NIMCustomObject *customObject = [[NIMCustomObject alloc]init];
                customObject.attachment = attachement;
                tempMessage.messageObject = customObject;
                NSString *sessionID = [NSString stringWithFormat:@"%ld",GetCore(ImRoomCoreV2).currentRoomInfo.roomId];
                NIMSession *session = [NIMSession session:sessionID type:NIMSessionTypeChatroom];
                [tempMessage setValue:session forKey:@"session"];
                [self addMessageToArray:tempMessage];
            }
        }
    }
}

- (void) _notifyReceiveChannelText:(BOOL)forceOrNot{
    
    const static float UPDATE_UI_CHANNEL_TEXT_INTERVAL = 0.5; //每0.5s刷新公屏
    if (_notifyChannelTextTimer == nil) {
        _notifyChannelTextTimer = [NSTimer scheduledTimerWithTimeInterval:UPDATE_UI_CHANNEL_TEXT_INTERVAL target:self selector:@selector(onDoNotifyReceiveChannelText:) userInfo:nil repeats:NO];
    }
    
    if (forceOrNot) {
        [_notifyChannelTextTimer fire];
    }
}

- (void) onDoNotifyReceiveChannelText:(NSTimer *)timer{
    
    [_notifyChannelTextTimer invalidate];
    _notifyChannelTextTimer = nil;
    if (GetCore(ImRoomCoreV2).currentRoomInfo.isCloseScreen) {
            [self.messages removeAllObjects];
        //是超管关闭的公屏的话
        if (GetCore(RoomCoreV2).getCurrentRoomInfo.closeScreenFlag == 1) {
            XCRoomSuperAdminAttachment *attachement = [[XCRoomSuperAdminAttachment alloc]init];
            attachement.first = Custom_Noti_Header_Room_SuperAdmin;
            attachement.second = Custom_Noti_Sub_Room_SuperAdmin_CloseChat;
            NIMMessage *closeMessage = [[NIMMessage alloc]init];
            NIMCustomObject *customObject = [[NIMCustomObject alloc]init];
            customObject.attachment = attachement;
            closeMessage.messageObject = customObject;
            NSString *sessionID = [NSString stringWithFormat:@"%ld",GetCore(ImRoomCoreV2).currentRoomInfo.roomId];
            NIMSession *session = [NIMSession session:sessionID type:NIMSessionTypeChatroom];
            [closeMessage setValue:session forKey:@"session"];
            [self.messages addObject:closeMessage];
        }else {
            Attachment *attachement = [[Attachment alloc]init];
            attachement.first = Custom_Noti_Header_Update_RoomInfo;
            attachement.second = Custom_Noti_Sub_Update_RoomInfo_MessageState;
            NIMMessage *tempMessage = [[NIMMessage alloc]init];
            NIMCustomObject *customObject = [[NIMCustomObject alloc]init];
            customObject.attachment = attachement;
            tempMessage.messageObject = customObject;
            NSString *sessionID = [NSString stringWithFormat:@"%ld",GetCore(ImRoomCoreV2).currentRoomInfo.roomId];
            NIMSession *session = [NIMSession session:sessionID type:NIMSessionTypeChatroom];
            [tempMessage setValue:session forKey:@"session"];
            [self.messages addObject:tempMessage];
        }
    }
    NotifyCoreClient(RoomCoreClient, @selector(onCurrentRoomMsgUpdate:), onCurrentRoomMsgUpdate:self.messages);
}



- (void)reportUserInterRoom {
    if ([GetCore(AuthCore)getTicket].length > 0) {
        [HttpRequestHelper reportUserInterRoomSuccess:^(BOOL success) {
        } failure:^(NSNumber *resCode, NSString *message) {
        }];
    }
}
- (void)reportUserOuterRoom {
    if ([GetCore(AuthCore) getTicket].length > 0) {
        if (GetCore(ImRoomCoreV2).currentRoomInfo.type == RoomType_Stranger) {
            //离开陌生人房间上报
            [HttpRequestHelper requestStrangerLeaveRoomWithRoomUid:GetCore(ImRoomCoreV2).currentRoomInfo.uid withUid:[GetCore(AuthCore).getUid userIDValue] success:^{} failure:^(NSString *message) {}];
        }
        if ([GetCore(ImRoomCoreV2)isInRoom]) {
            [HttpRequestHelper reportUserOutRoomSuccess:^(BOOL success) {
            } failure:^(NSNumber *resCode, NSString *message) {
            }];
        }
    }
}


//房间埋点统计
- (void)recordTheRoomTime:(UserID)uid roomUid:(UserID)roomUid {
    [HttpRequestHelper recordTheRoomTime:uid roomUid:roomUid];
}
//开始房间统计（60s之后才统计）
- (void)startRoomTimer {
    // 获得队列
    dispatch_queue_t queue = dispatch_get_main_queue();
    // 创建一个定时器(dispatch_source_t本质还是个OC对象)
    self.timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    // 设置定时器的各种属性（几时开始任务，每隔多长时间执行一次）
    // GCD的时间参数，一般是纳秒（1秒 == 10的9次方纳秒）
    // 何时开始执行第一个任务
    // dispatch_time(DISPATCH_TIME_NOW, 1.0 * NSEC_PER_SEC) 比当前时间晚3秒
    dispatch_time_t start = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC));
    uint64_t interval = (uint64_t)(60.0 * NSEC_PER_SEC);
    dispatch_source_set_timer(self.timer, start, interval, 0);
    
    // 设置回调
    @weakify(self);
    dispatch_source_set_event_handler(self.timer, ^{
        @strongify(self);
        if (GetCore(ImRoomCoreV2).currentRoomInfo) {
            if ([GetCore(AuthCore) getUid].userIDValue != GetCore(ImRoomCoreV2).currentRoomInfo.uid) {
                [self recordTheRoomTime:[GetCore(AuthCore) getUid].userIDValue roomUid:GetCore(ImRoomCoreV2).currentRoomInfo.uid];
            }
        }
    });
    // 启动定时器
    dispatch_resume(self.timer);
    
}
- (void)cancelRoomRecord {
    self.timer = nil;
}

- (void)onRoomInvalid
{
    
    self.speakingList = nil;
    self.messages = nil;
}


//通过uid判断麦位
- (NSString *)findThePositionByUid:(UserID)uid{
    if (uid > 0) {
        NSDictionary *micQueue = GetCore(ImRoomCoreV2).micQueue;
        NSArray *keys = [micQueue allKeys];
        if (keys.count > 0) {
            for (NSString *key in keys) {
                NIMChatroomMember *member = [[micQueue objectForKey:key] chatRoomMember];
                if (member.userId.userIDValue == uid) {
                    return key;
                }
            }
        }
    }
    return nil;
}

//查询麦序状态
- (BOOL)getMicStateByUid:(UserID)uid  {
    NSString *key = [self findThePositionByUid:uid];
    if (key != nil) {
        ChatRoomMicSequence *micSequence = [GetCore(ImRoomCoreV2).micQueue objectForKey:key];
        if (micSequence != nil) {
            if (micSequence.microState.micState == MicroMicStateOpen && !GetCore(MeetingCore).isCloseMicro) {
                return YES;
            }
        }
    }
    return NO;
    
}

#pragma mark - Setter & Getter
//判断是否在房间
- (BOOL)isInRoom {
    if (GetCore(ImRoomCoreV2).currentRoomInfo != nil) {
        return YES;
    }else {
        return NO;
    }
}


- (NSMutableArray *)positionArr {
    if (_positionArr == nil) {
        _positionArr = [NSMutableArray array];
    }
    return _positionArr;
}

#pragma mark - CP陌生人房间

- (void)requestStrangerWithCreat{
    [HttpRequestHelper requestStrangerWithCreateSuccess:^(RoomInfo * _Nonnull roomInfo) {
        NotifyCoreClient(RoomCoreClient, @selector(onCreatStrangerSuccessWithRoomInfo:), onCreatStrangerSuccessWithRoomInfo:roomInfo);
    } failure:^(NSString * _Nonnull message) {
        NotifyCoreClient(RoomCoreClient, @selector(onCreatStrangerFailth:), onCreatStrangerFailth:message);
        
    }];
}

- (void)requestDynamicStrangerWithCreat {
    [HttpRequestHelper requestDynamicStrangerWithCreateSuccess:^(RoomInfo *roomInfo) {
        NotifyCoreClient(RoomCoreClient, @selector(onCreatDynamicStrangerSuccessWithRoomInfo:), onCreatDynamicStrangerSuccessWithRoomInfo:roomInfo);
    } failure:^(NSString *message) {
        NotifyCoreClient(RoomCoreClient, @selector(onCreatDynamicStrangerFailth:), onCreatDynamicStrangerFailth:message);
    }];
}

- (void)requestStrangerRoomListWithStart:(NSUInteger)pageNum page:(NSUInteger)pageSize{
    [HttpRequestHelper requestStrangerListRoomWithStart:pageNum pageSize:pageSize success:^(NSArray<StrangerRoomInfo *> * _Nonnull roomInfoList) {
        NotifyCoreClient(RoomCoreClient, @selector(onStrangerRoomListSuccess:), onStrangerRoomListSuccess:roomInfoList);
    } failure:^(NSString * _Nonnull message) {
        NotifyCoreClient(RoomCoreClient, @selector(onStrangerRoomListFailth:), onStrangerRoomListFailth:message);
    }];
}
- (void)requestStrangerWithFindRoom{
    [HttpRequestHelper requestStrangerWithFindRoomSuccess:^(RoomInfo * _Nonnull roomInfo) {
        NotifyCoreClient(RoomCoreClient, @selector(onStrangerFindRoomSuccess:), onStrangerFindRoomSuccess:roomInfo);
    } failure:^(NSString * _Nonnull message) {
        NotifyCoreClient(RoomCoreClient, @selector(onStrangerFindRoomFailth:), onStrangerFindRoomFailth:message);
    }];
}

- (void)requestStrangerRoomInfo:(UserID)roomId title:(NSString *)title{
    [HttpRequestHelper requestStrangerRoomInfo:roomId title:title success:^(RoomInfo *roomInfo) {
        NotifyCoreClient(RoomCoreClient, @selector(onStrangerRoomInfoSuccess:), onStrangerRoomInfoSuccess:roomInfo);
    } failure:^(NSString *message) {
        NotifyCoreClient(RoomCoreClient, @selector(onStrangerRoomInfoFailth:), onStrangerRoomInfoFailth:message)
    }];
}

- (void)requestStrangerBindCpWithRoomInfo:(UserID)roomId coupleUid:(UserID)coupleUid withIsAgree:(BOOL)isAgree withType:(int)type{
    [HttpRequestHelper requestStrangerBindCpWithRoomInfo:roomId coupleUid:coupleUid withType:type
                                                 success:^(StrangerCoupleInfo *coupleInfo) {
                                                     NotifyCoreClient(RoomCoreClient,@selector(onStrangerBindCpSuccess:withIsAgree:),onStrangerBindCpSuccess:coupleInfo withIsAgree:isAgree);
                                                 } failure:^(NSString *message) {
                                                     NotifyCoreClient(RoomCoreClient,@selector(onStrangerBindCpFailth:),onStrangerBindCpFailth:message);
                                                 }];
}
- (void)requestUserP2PUidOuterRoom:(UserID)roomUid withUid:(UserID)uid{
    if (GetCore(ImRoomCoreV2).currentRoomInfo.type == RoomType_Stranger) {
        //离开陌生人房间上报
        [HttpRequestHelper requestStrangerLeaveRoomWithRoomUid:roomUid withUid:uid success:^{} failure:^(NSString *message) {}];
    }
}

- (void)requestP2PUidInterRoomUid:(UserID)roomUid {
    [HttpRequestHelper requestStrangeJoinRoomWithRoomUid:roomUid success:^{
        NotifyCoreClient(RoomCoreClient,@selector(onStrangeJoinRoomSuccess),onStrangeJoinRoomSuccess);
    } failure:^(NSString *message) {
        NotifyCoreClient(RoomCoreClient,@selector(onStrangeJoinRoomFailth:),onStrangeJoinRoomFailth:message);
        
    }];
}

- (void)requeStrangerMessageWishCoupleUid:(UserID)coupleUid withType:(int)type sender:(id)sender{
    [HttpRequestHelper requeStrangerMessageWishCoupleUid:coupleUid withType:(int)type success:^(StrangerCoupleInfo *coupleInfo) {
        NotifyCoreClient(RoomCoreClient, @selector(onStrangerMessageWishCoupleSuccess:sender:), onStrangerMessageWishCoupleSuccess:coupleInfo sender:sender);
    } failure:^(NSString *message) {
        NotifyCoreClient(RoomCoreClient, @selector(onStrangerMessageWishCoupleFailth:sender:), onStrangerMessageWishCoupleFailth:message sender:sender);
        
    }];
}
- (void)requeStrangerMessageAgreeCoupleUid:(UserID)coupleUid withRoomId:(NSInteger)roomId{
    [HttpRequestHelper requeStrangerMessageAgreeCoupleUid:coupleUid withRoomId:roomId success:^(StrangerCoupleInfo *coupleInfo) {
        
        NotifyCoreClient(RoomCoreClient, @selector(onStrangerMessageAgreeCoupleSuccess:), onStrangerMessageAgreeCoupleSuccess:coupleInfo);
    } failure:^(NSString *message) {
        
        NotifyCoreClient(RoomCoreClient, @selector(onStrangerMessageAgreeCoupleFailth:), onStrangerMessageAgreeCoupleFailth:message);
    }];
}

#pragma mark - officalManagerRoomSetting

- (void)requestSettingHideRoom:(BOOL)hideFlag success:(void (^)(BOOL success))success {

    [HttpRequestHelper requestSettingHideRoom:hideFlag success:^{
        success(YES);
    } failure:^(NSNumber *num, NSString *msg) {
        if ([num intValue] == 18004) {
            [[XCCurrentVCStackManager shareManager].currentNavigationController popViewControllerAnimated:YES];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"NotSuperAdmin" object:nil];
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"deleteSuperAdmin"];
        }
    }];
}

//@fengshuo start
/**
 房间超管
 
 @param targetUid 目标的uid
 @param opt //1: 设置为管理员;2:设置普通等级用户;-1:设为黑名单用户;-2:设为禁言用户
 @param success 成功
 */
- (void)requsetRoomSettingSuperAdminWithTargetUid:(UserID)targetUid opt:(int)opt success:(void (^)(BOOL success))success {
    NSDictionary * dic = @{@"handleUid":GetCore(AuthCore).getUid, @"role":[NSNumber numberWithInteger:1]};
    NSString * notifyExt =[dic yy_modelToJSONString];
    [HttpRequestHelper requestSettingRoomAdminWithRoomUid:self.getCurrentRoomInfo.uid targetUid:targetUid opt:opt notifyExt:notifyExt success:^{
        success(YES);
        // 统计超管拉黑用户操作
        if (opt == -1) {
            [GetCore(RoomCoreV2) recordSuperAdminOperate:SuperAdminOperateTypeBlackUser superAdminUid:GetCore(AuthCore).getUid.userIDValue roomUid:GetCore(RoomCoreV2).getCurrentRoomInfo.uid targetUid:targetUid];
        }
    } failure:^(NSNumber *number, NSString *message) {
        
        if ([number intValue] == 18004) {
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"NotSuperAdmin" object:nil];
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"deleteSuperAdmin"];
        }
        success(NO);
    }];
}


/**
 发送自定义消息

 @param targetUserid 目标的uid
 @param targetName 目标的名字
 @param position 坑位
 @param second second
 */
- (void)sendCustomMessageToManagerOutRoomWithTargetUid:(UserID)targetUserid targetName:(NSString *_Nullable)targetName position:(NSString * _Nullable)position second:(Custom_Noti_Sub_Room_SuperAdmin)second {
    
    TTRoomSuperAdminModel * adminModel = [[TTRoomSuperAdminModel alloc]init];
   
    if (position) {
        adminModel.micNumber = position;
    }
    
    if (targetUserid) {
        
        adminModel.targetNick = targetName;
        adminModel.targetUid = targetUserid;
    }
    adminModel.handleNick = GetCore(ImRoomCoreV2).myMember.roomNickname;
    adminModel.handleUid = GetCore(AuthCore).getUid.userIDValue;
    
    XCRoomSuperAdminAttachment *attachement = [[XCRoomSuperAdminAttachment alloc]init];
    attachement.first = Custom_Noti_Header_Room_SuperAdmin;
    attachement.second = second;
    attachement.data = [adminModel model2dictionary];
    
    [GetCore(ImMessageCore) sendCustomMessageAttachement:attachement sessionId:[NSString stringWithFormat:@"%ld",(long)GetCore(ImRoomCoreV2).currentRoomInfo.roomId] type:NIMSessionTypeChatroom];
}


//@fengshuo end

- (void)sendOfficalManagerCustomMessage:(Custom_Noti_Sub_Room_SuperAdmin)type {
    
    TTRoomSuperAdminModel * adminModel = [[TTRoomSuperAdminModel alloc]init];
    
    XCRoomSuperAdminAttachment *attachement = [[XCRoomSuperAdminAttachment alloc]init];
    attachement.first = Custom_Noti_Header_Room_SuperAdmin;
    attachement.second = type;
    attachement.data = [adminModel model2dictionary];
    
    [GetCore(ImMessageCore) sendCustomMessageAttachement:attachement sessionId:[NSString stringWithFormat:@"%ld",(long)GetCore(ImRoomCoreV2).currentRoomInfo.roomId] type:NIMSessionTypeChatroom];
}

#pragma mark -
#pragma mark 超管操作记录统计
/// 超管操作的事项进行统计
- (void)recordSuperAdminOperate:(SuperAdminOperateType)operateType
                  superAdminUid:(UserID)uid
                        roomUid:(UserID)roomUid
                      targetUid:(UserID)targetUid {
    
    UserInfo *info = [GetCore(UserCore) getUserInfoInDB:uid];
    
    // 超管才可以使用当前接口
    if (info.platformRole == XCUserInfoPlatformRoleSuperAdmin) {
        
        [HttpRequestHelper recordSuperAdminOperate:operateType superAdminUid:uid roomUid:roomUid targetUid:targetUid success:^{
            // 仅用于告诉服务器此次操作，不需要回调处理
        } failure:^(NSNumber *resCode, NSString *msg) {
            // 就算是失败了也无需处理。
        }];
    }
}

/// 进房记录
- (void)requestRoomVisitRecord {
    [HttpRequestHelper requestRoomVisitRecordOnCompletion:^(id data, NSNumber *code, NSString *msg) {
        
        NSArray *list = [NSArray yy_modelArrayWithClass:RoomVisitRecord.class json:data];
        NotifyCoreClient(RoomCoreClient, @selector(responseRoomVisitRecord:errorCode:msg:), responseRoomVisitRecord:list errorCode:code msg:msg);
    }];
}

/// 进房记录清除
- (void)requestRoomVisitRecordClean {
    [HttpRequestHelper requestRoomVisitRecordCleanOnCompletion:^(id data, NSNumber *code, NSString *msg) {
        
        BOOL isSuccess = code == nil && msg == nil;
        NotifyCoreClient(RoomCoreClient, @selector(responseRoomVisitRecordClean:errorCode:msg:), responseRoomVisitRecordClean:isSuccess errorCode:code msg:msg);
    }];
}

/// 进房欢迎语
/// 接收方uid
- (void)requestRoomEnterGreetingToUid:(NSString *)toUid {
    [HttpRequestHelper requestRoomEnterGreetingToUid:toUid completion:^(id data, NSNumber *code, NSString *msg) {
        
        RoomEnterGreeting *model = [RoomEnterGreeting modelWithJSON:data];
        NotifyCoreClient(RoomCoreClient, @selector(responseRoomEnterGreeting:errorCode:msg:), responseRoomEnterGreeting:model errorCode:code msg:msg);
    }];
}

/// 进房欢迎语
/// 接收方uid
- (void)requestRoomEnterGreetingToUid:(NSString *_Nonnull)toUid completion:(void(^_Nullable)(RoomEnterGreeting * _Nullable data, NSNumber * _Nullable code, NSString * _Nullable msg))completion {
    
    [HttpRequestHelper requestRoomEnterGreetingToUid:toUid completion:^(id data, NSNumber *code, NSString *msg) {
        
        RoomEnterGreeting *model = [RoomEnterGreeting modelWithJSON:data];
        !completion ?: completion(model, code, msg);
    }];
}

/// 获取红包配置信息
- (void)requestRoomRedConfigCompletion:(void(^)(RoomRedConfig * _Nullable data, NSNumber * _Nullable code, NSString * _Nullable msg))completion {
    
    [HttpRequestHelper requestRoomRedConfigCompletion:^(id data, NSNumber *code, NSString *msg) {
        
        RoomRedConfig *model = [RoomRedConfig modelWithJSON:data];
        !completion ?: completion(model, code, msg);
    }];
}

/// 红包分享
/// @param roomUid 房主uid
/// @param packetId 红包id
- (void)requestRoomRedShare:(NSString *)packetId
                    roomUid:(NSString *)roomUid
                 completion:(void(^)(BOOL success, NSNumber * _Nullable code, NSString * _Nullable msg))completion {
    
    [HttpRequestHelper requestRoomRedShare:packetId roomUid:roomUid completion:^(id data, NSNumber *code, NSString *msg) {
        
        BOOL success = code == nil && msg == nil;
        !completion ?: completion(success, code, msg);
    }];
}

/// 获取房间内可抢的红包列表
/// @param roomUid 房主uid
- (void)requestRoomRedList:(NSString *)roomUid
                completion:(void(^)(NSArray<RoomRedListItem *> *_Nullable data, NSNumber * _Nullable code, NSString * _Nullable msg))completion {
    
    [HttpRequestHelper requestRoomRedList:roomUid completion:^(id data, NSNumber *code, NSString *msg) {
        
        NSArray *list = [RoomRedListItem modelsWithArray:data];
        !completion ?: completion(list, code, msg);
    }];
}

/// 获取红包详情
/// @param packetId 红包id
- (void)requestRoomRedDetail:(NSString *)packetId
                  completion:(void(^)(RoomRedDetail * _Nullable data, NSNumber * _Nullable code, NSString * _Nullable msg))completion {
    
    [HttpRequestHelper requestRoomRedDetail:packetId completion:^(id data, NSNumber *code, NSString *msg) {
        
        RoomRedDetail *model = [RoomRedDetail modelWithJSON:data];
        !completion ?: completion(model, code, msg);
    }];
}

/// 抢红包
/// @param packetId 红包id
- (void)requestRoomRedDraw:(NSString *)packetId
                completion:(void(^)(NSString * _Nullable data, NSNumber * _Nullable code, NSString * _Nullable msg))completion {
    
    [HttpRequestHelper requestRoomRedDraw:packetId completion:^(id data, NSNumber *code, NSString *msg) {
        
        !completion ?: completion(data, code, msg);
    }];
}

//发红包
- (void)requestRoomSendRedByRoomUid:(UserID)roomUid amount:(NSInteger)amount num:(NSInteger)num requirementType:(int)requirementType notifyText:(NSString *_Nullable)notifyText
                         completion:(void(^_Nonnull)(NSDictionary * _Nullable data, NSNumber * _Nullable code, NSString * _Nullable msg))completion {
    [HttpRequestHelper requestRoomSendRedByRoomUid:roomUid amount:amount num:num requirementType:requirementType notifyText:notifyText completion:^(id data, NSNumber *code, NSString *msg) {
        !completion ?: completion(data, code, msg);
    }];
}

@end
