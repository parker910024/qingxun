////
////  RoomCore.m
////  BberryCore
////
////  Created by chenran on 2017/5/27.
////  Copyright © 2017年 chenran. All rights reserved.
////
//
//#import "RoomCore.h"
//#import "HttpRequestHelper+Room.h"
//#import "RoomCoreClient.h"
//#import "ImRoomCoreClient.h"
//#import "AuthCore.h"
//#import "AuthCoreClient.h"
//#import "UserCore.h"
//#import "MeetingCore.h"
//#import "MeetingCoreClient.h"
//#import "ImMessageCore.h"
//#import "ImMessageCoreClient.h"
//#import "Attachment.h"
//#import "GiftReceiveInfo.h"
//#import "GiftCore.h"
//#import "NSObject+YYModel.h"
//
//#import "ImRoomCoreClientV2.h"
//
//#import "RoomQueueAttachment.h"
//#import "RoomQueueCoreClient.h"
//
//#import "RoomQueueCore.h"
//#import "FaceCore.h"
//#import "FaceCoreClient.h"
//#import "ShareSendInfo.h"
//#import "YYUtility.h"
//
//@interface RoomCore()<ImRoomCoreClient, ImMessageCoreClient,AuthCoreClient, MeetingCoreClient, ImRoomCoreClientV2, RoomQueueCoreClient,FaceCoreClient>
//
//@property (nonatomic, strong) dispatch_source_t timer; //计时器
//
//@end
//
//@implementation RoomCore
//- (instancetype)init
//{
//    self = [super init];
//    if (self) {
//        AddCoreClient(ImRoomCoreClient, self);
//        AddCoreClient(ImMessageCoreClient, self);
//        AddCoreClient(AuthCoreClient, self);
//        AddCoreClient(MeetingCoreClient, self);
//        AddCoreClient(ImRoomCoreClientV2, self);
//        AddCoreClient(RoomQueueCoreClient, self);
//        AddCoreClient(FaceCoreClient, self);
//    }
//    return self;
//}
//
//- (void)dealloc
//{
//    RemoveCoreClientAll(self);
//}
////开拍卖房
//-(void) rewardAndOpenRoom:(UserID)uid rewardMonye:(NSInteger)rewardMonye title:(NSString *)title roomDesc:(NSString *)roomDesc backPic:(NSString*)backPic
//{
//    if (uid <= 0) {
//        return;
//    }
//    @weakify(self)
//    [HttpRequestHelper rewardForRoom:uid servDura:30 rewardMonye:rewardMonye success:^(RewardInfo *rewardInfo) {
//        if (rewardInfo.rewardId != nil) {
//            @strongify(self)
//            [self openRoom:uid type:RoomType_Party title:title roomDesc:roomDesc backPic:backPic rewardId:rewardInfo.rewardId];
//        }
//    } failure:^(NSNumber *resCode, NSString *message) {
//
//    }];
//}
////开启房间
//- (void)openRoom:(UserID)uid type:(RoomType)type title:(NSString *)title roomDesc:(NSString *)roomDesc backPic:(NSString *)backPic rewardId:(NSString *)rewardId
//{
//    if (uid <= 0) {
//        return;
//    }
//
//    @weakify(self);
//    [HttpRequestHelper openRoom:uid type:type title:title roomDesc:roomDesc backPic:backPic rewardId:rewardId success:^(RoomInfo *roomInfo) {
//        @strongify(self);
//        NotifyCoreClient(RoomCoreClient, @selector(onOpenRoomSuccess:), onOpenRoomSuccess:roomInfo);
//    } failure:^(NSNumber *resCode, NSString *message) {
//        NotifyCoreClient(RoomCoreClient, @selector(onOpenRoomFailth:message:), onOpenRoomFailth:resCode message:message);
//    }];
//}
////根据房主id请求房间信息
//- (RACSignal *)requestRoomInfo:(UserID)uid
//{
//    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
//        [HttpRequestHelper getRoomInfo:uid success:^(RoomInfo *roomInfo) {
//            [subscriber sendNext:roomInfo];
//            [subscriber sendCompleted];
//        } failure:^(NSNumber *resCode, NSString *message) {
//            [subscriber sendError:CORE_API_ERROR(RoomCoreErrorDomain, resCode.integerValue, message)];
//        }];
//        return nil;
//    }];
//}
////批量查询房间信息
//- (RACSignal *)requestRoomInfoByUids:(NSArray *)uids {
//    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
//        [HttpRequestHelper getRoomInfoByUids:uids success:^(NSArray<RoomInfo *> *roomInfoArr) {
//            [subscriber sendNext:roomInfoArr];
//            [subscriber sendCompleted];
//        } failure:^(NSNumber *resCode, NSString *message) {
//            [subscriber sendError:CORE_API_ERROR(RoomCoreErrorDomain, resCode.integerValue, message)];
//        }];
//        return nil;
//    }];
//}
//
//- (RoomInfo *)getCurrentRoomInfo
//{
//    return self.currentRoomInfo;
//}
//
//- (void) setCurrentRoomInfo:(RoomInfo *)currentRoomInfo
//{
//    _currentRoomInfo = currentRoomInfo;
////    NotifyCoreClient(RoomCoreClient, @selector(onCurrentRoomInfoChanged), onCurrentRoomInfoChanged);
//}
////获取麦上人员
//- (NSMutableArray *)getAdminMembers {
//    return self.adminMembers;
//}
//
////获取房间贡献榜
//- (void)getRoomBounsList {
//    [HttpRequestHelper requestRoomBounsListSuccess:^(NSMutableArray *bounsInfoList) {
//        if (bounsInfoList.count > 0) {
//            NotifyCoreClient(RoomCoreClient, @selector(onGetRoomBounsListSuucess:), onGetRoomBounsListSuucess:bounsInfoList);
//        }
//    } failure:^(NSNumber *resCode, NSString *message) {
//        NotifyCoreClient(RoomCoreClient, @selector(onGetRoomBounsListFailth:), onGetRoomBounsListFailth:message);
//    }];
//}
//
////房主更新房间信息
//- (void)updateRoomInfo:(UserID)uid title:(NSString *)title roomDesc:(NSString *)roomDesc backPic:(NSString *)backPic
//{
//    if (uid <= 0) {
//        return;
//    }
//    @weakify(self)
//    [HttpRequestHelper updateRoomInfo:uid title:title roomDesc:roomDesc backPic:backPic roomPassword:nil tag:nil success:^(RoomInfo *roomInfo) {
//        @strongify(self)
//        self.currentRoomInfo = roomInfo;
//        NotifyCoreClient(RoomCoreClient, @selector(onUpdateRoomInfoSuccess:), onUpdateRoomInfoSuccess:roomInfo);
//    } failure:^(NSNumber *resCode, NSString *message) {
//        NotifyCoreClient(RoomCoreClient, @selector(onUpdateRoomInfoFailth:), onUpdateRoomInfoFailth:message);
//    }];
//}
////关闭房间
//- (void)closeRoom:(UserID)uid
//{
//    if (uid <= 0) {
//        return;
//    }
//    [HttpRequestHelper closeRoom:uid success:^{
//        NotifyCoreClient(RoomCoreClient, @selector(onCloseRoomSuccess), onCloseRoomSuccess);
//    } failure:^(NSNumber *resCode, NSString *message) {
//        NotifyCoreClient(RoomCoreClient, @selector(onCloseRoomFailth:code:), onCloseRoomFailth:message code:resCode);
//    }];
//}
////发送公屏消息
//- (void)sendMessage:(NSString *)message
//{
//    NSString *sessionId = [NSString stringWithFormat:@"%ld", self.currentRoomInfo.roomId];
//    if (sessionId.length > 0) {
//        NSString *nick = [GetCore(UserCore) getUserInfoInDB:[GetCore(AuthCore) getUid].userIDValue].nick;
//        [GetCore(ImMessageCore) sendTextMessage:message nick:nick sessionId:sessionId type:NIMSessionTypeChatroom];
//    }
//}
//
////请求上麦
//- (void)applyMicro:(UserID)uid roomOwnerUid:(UserID)roomOwnerUid
//{
//    if (uid <= 0 || roomOwnerUid <= 0) {
//        return;
//    }
//    [HttpRequestHelper applyMicro:uid roomOwnerUid:roomOwnerUid success:^{
//        NotifyCoreClient(RoomCoreClient, @selector(onApplyMicroSuccess), onApplyMicroSuccess);
//    } failure:^(NSNumber *resCode, NSString *message) {
//        NotifyCoreClient(RoomCoreClient, @selector(onApplyMicroFailth:), onApplyMicroFailth:message);
//    }];
//}
////上
//- (void)upMicro:(UserID)uid roomOwnerUid:(UserID)roomOwnerUid seqNo:(NSInteger)seqNo
//{
//    if (uid <= 0 || roomOwnerUid <= 0) {
//        return;
//    }
//    [HttpRequestHelper upMicro:uid roomId:roomOwnerUid position:seqNo success:^{
//        NotifyCoreClient(RoomCoreClient, @selector(onUpMicroSuccess), onApplyMicroSuccess);
//    } failure:^(NSNumber *resCode, NSString *message) {
//        NotifyCoreClient(RoomCoreClient, @selector(onUpMicroFailth:), onApplyMicroFailth:message);
//    }];
//}
////下麦
//- (void)leftMicro:(UserID)uid roomOwnerUid:(UserID)roomOwnerUid
//{
//    if (uid <= 0 || roomOwnerUid <= 0) {
//        return;
//    }
//    [HttpRequestHelper leftMicro:uid roomId:roomOwnerUid position:0 success:^{
//        NotifyCoreClient(RoomCoreClient, @selector(onLeftMicroSuccess), onLeftMicroSuccess);
//    } failure:^(NSNumber *resCode, NSString *message) {
//        NotifyCoreClient(RoomCoreClient, @selector(onLeftMicroFailth:), onLeftMicroFailth:message);
//    }];
//}
//
////- (void)requestCurrentMicroList:(UserID)roomOwnerUid
////{
////    if (roomOwnerUid <= 0) {
////        return;
////    }
////
////    @weakify(self)
////    [HttpRequestHelper requestMicroList:roomOwnerUid success:^(MicroListInfo *microListInfo) {
////        @strongify(self)
////        [self updateMicroList:microListInfo.seqUids];
////        NotifyCoreClient(RoomCoreClient, @selector(onCurrentMicroListUpdate:applyList:), onCurrentMicroListUpdate:self.currentMicroList applyList:self.currentApplyList);
////    } failure:^(NSNumber *resCode, NSString *message) {
////    }];
////
////}
////
////- (void)updateMicroList:(NSArray *)microList
////{
////    if (microList.count > 0) {
////        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
////        for (int i=0; i<microList.count; i++){
////            NSDictionary * uidPosition = [microList objectAtIndex:i];
////            NSNumber *uid = [uidPosition objectForKey:@"uid"];
////            NSNumber *seqNo = [uidPosition objectForKey:@"seqNo"];
////            [dic setObject:uid forKey:seqNo];
////        }
////        self.currentMicroList = [dic copy];
////    }
////}
////拒绝
//- (void)denyApplyMicro:(UserID)uid roomOwnerUid:(UserID)roomOwnerUid
//{
//    if (uid <=0 || roomOwnerUid <= 0) {
//        return;
//    }
//
//    [HttpRequestHelper denyApplyMicro:uid roomOwnerUid:roomOwnerUid success:^{
//        NotifyCoreClient(RoomCoreClient, @selector(onDenyApplyMicroSuccess), onDenyApplyMicroSuccess);
//    } failure:^(NSNumber *resCode, NSString *message) {
//        NotifyCoreClient(RoomCoreClient, @selector(onDenyApplyMicroFailth:), onDenyApplyMicroFailth:message);
//    }];
//}
////更新麦序
//-(void) updateMicroList:(UserID)roomOwnerUid curUids:(NSArray *)curUids type:(NSInteger)type
//{
//    if (roomOwnerUid > 0) {
//        [HttpRequestHelper updateMicroList:roomOwnerUid curUids:curUids type:type success:^{
//
//        } failure:^(NSNumber *resCode, NSString *message) {
//
//        }];
//    }
//}
//
////用户同意上麦
//- (void)userAgreeUpMicroRoomUid:(NSString *)roomUid {
//    [HttpRequestHelper userAgreeUpMicroRoomUid:roomUid success:^(BOOL isSuccess) {
//
//    } failure:^(NSNumber *resCode, NSString *message) {
//
//    }];
//}
//
////房主邀请上麦
//- (void)OwnerInviteUserUpMicroByUid:(NSString *)uid {
////    [HttpRequestHelper inviteUpMicroWithUid:uid.userIDValue success:^(BOOL isSuccess) {
////
////    } failure:^(NSNumber *resCode, NSString *message) {
////
////    }];
//}
//
////房主踢用户下麦
//- (void)ownerKickUserByUid:(NSString *)uid {
////    [HttpRequestHelper ownerKickUserByUid:uid success:^(BOOL isSuccess) {
////
////    } failure:^(NSNumber *resCode, NSString *message) {
////
////    }];
//}
////添加消息到内存，最多保留200
//- (void)addMessageToArray:(NIMMessage *)msg
//{
//    if (msg.session.sessionType == NIMSessionTypeChatroom && msg.session.sessionId.integerValue == self.currentRoomInfo.roomId) {
//        if (self.messages == nil) {
//            self.messages = [NSMutableArray array];
//        }
//
//        if (self.messages.count > 200) {
//            [self.messages removeObjectAtIndex:0];
//        }
//
//        [self.messages addObject:msg];
//        NotifyCoreClient(RoomCoreClient, @selector(onCurrentRoomMsgUpdate:), onCurrentRoomMsgUpdate:self.messages);
//    }
//}
//
//
////处理聊天室下发通知
//- (void)handlerCustomMsg:(NIMMessage *)msg
//{
//    NIMCustomObject *obj = (NIMCustomObject *)msg.messageObject;
//    if (obj.attachment != nil && [obj.attachment isKindOfClass:[Attachment class]]) {
//        Attachment *attachment = (Attachment *)obj.attachment;
//        if (attachment.first == Custom_Noti_Header_Auction) {
//            [self addMessageToArray:msg];
//        } else if (attachment.first == Custom_Noti_Header_Gift) {
//            GiftReceiveInfo *info = [GiftReceiveInfo yy_modelWithDictionary:attachment.data];
//            GiftInfo *giftInfo = [GetCore(GiftCore) findGiftInfoByGiftId:info.giftId];
//            if (giftInfo.goldPrice > 0) {
//                [self addMessageToArray:msg];
//            }
//        } else if (attachment.first == Custom_Noti_Header_Room_Tip) {
//            [self addMessageToArray:msg];
//        } else if (attachment.first == Custom_Noti_Header_ALLMicroSend) {
//            if (attachment.second == Custom_Noti_Sub_AllMicroSend) {
//                [self addMessageToArray:msg];
//            }
//        }
//
//    }
//}
//
//#pragma mark - RoomQueueCoreClient
//
//- (void)onMicroStateChange {
//    [self fetchRoomRegularMembers];
//}
//
//#pragma mark - MeetingCoreClient
////加入声网成功
//- (void)onJoinMeetingSuccess
//{
//    UserID uid = [GetCore(AuthCore) getUid].userIDValue;
//    if (self.currentRoomInfo.uid == uid) {
//        //        [self upMicro:uid roomOwnerUid:uid seqNo:0];
//        [GetCore(MeetingCore)setMeetingRole:YES];
//        [GetCore(MeetingCore)setCloseMicro:NO];
//    }
//    [YYUtility checkMicPrivacy:^(BOOL succeed) {
//        if (!succeed) {
//            NotifyCoreClient(RoomCoreClient, @selector(thereIsNoMicoPrivacy), thereIsNoMicoPrivacy);
//        }
//    }];
//
//}
////说话回调
//- (void)onSpeakingUsersReport:(NSMutableArray *)userInfos
//{
//    self.speakingList = userInfos;
//    NotifyCoreClient(RoomCoreClient, @selector(onSpeakUsersReport:), onSpeakUsersReport:self.speakingList);
//}
//
//- (void)onMySpeakingStateUpdate:(BOOL)speaking
//{
//    NotifyCoreClient(RoomCoreClient, @selector(onMySpeakStateUpdate:), onMySpeakStateUpdate:speaking);
//}
//
////- (void)onSpeakingStateUpdate:(BOOL)speaking
////{
////    if (volume > 1000) {
////        for (NSNumber *sUid in self.speakingList) {
////            if (sUid.userIDValue == uid) {
////                return;
////            }
////        }
////        [self.speakingList addObject:@(uid)];
////        NotifyCoreClient(RoomCoreClient, @selector(onSpeakingStateUpdate:), onSpeakingStateUpdate:YES);
////    } else {
////        NotifyCoreClient(RoomCoreClient, @selector(onSpeakingStateUpdate:), onSpeakingStateUpdate:NO);
////    }
////}
//
//#pragma mark - ImMessageCoreClient
////收到text消息
//- (void)onRecvChatRoomTextMsg:(NIMMessage *)msg
//{
//    [self addMessageToArray:msg];
//}
////收到自定义消息
//- (void)onRecvChatRoomCustomMsg:(NIMMessage *)msg
//{
//    [self handlerCustomMsg:msg];
//}
//
//- (void)onWillSendMessage:(NIMMessage *)msg {
//    if (msg.messageType == NIMMessageTypeCustom) {
//        NIMCustomObject *obj = (NIMCustomObject *)msg.messageObject;
//        Attachment *attachment = (Attachment *)obj.attachment;
//        if (attachment.first != Custom_Noti_Header_Queue && attachment.first != Custom_Noti_Header_Face) {
//            [self addMessageToArray:msg];
//        }
//    }else {
//        [self addMessageToArray:msg];
//    }
//}
////房间信息更新
//- (void)roomInfoUpdate {
//    [[GetCore(RoomCore) requestRoomInfo:[GetCore(RoomCore)getCurrentRoomInfo].uid]subscribeNext:^(id x) {
//        RoomInfo *info = (RoomInfo *)x;
//        if (info != nil) {
//            self.currentRoomInfo = info;
//        }
//    }];
//}
//
//#pragma mark - ImRoomCoreClient
////收到房间信息更新通知
//- (void)onRoomInfoUpdate:(NIMMessage *)message {
//    if (message.messageType == NIMMessageTypeNotification) {//通知类型消息
//        NIMNotificationObject *notiMsg = (NIMNotificationObject *)message.messageObject;
//        NIMChatroomNotificationContent *content = (NIMChatroomNotificationContent *)notiMsg.content;
//        if (content.eventType == NIMChatroomEventTypeInfoUpdated) {//聊天室信息更新
//#warning remove
////            [self roomInfoUpdate];
//            NotifyCoreClient(RoomCoreClient, @selector(onRoomInfoUpdateSuccess), onRoomInfoUpdateSuccess);
//        }
//
//    }
//}
////收到移除管理更新通知
//- (void)managerRemove:(NIMMessage *)message {
//    if (message.messageType == NIMMessageTypeNotification) {
//        NIMNotificationObject *notiMsg = (NIMNotificationObject *)message.messageObject;
//        NIMChatroomNotificationContent *content = (NIMChatroomNotificationContent *)notiMsg.content;
//        if (content.eventType == NIMChatroomEventTypeRemoveManager) {//移除管理员
//            NIMChatroomNotificationMember *tempMember = content.targets[0];
//            NIMChatroomMembersByIdsRequest *request = [[NIMChatroomMembersByIdsRequest alloc]init];
//            request.roomId = [NSString stringWithFormat:@"%ld",(long)self.currentRoomInfo.roomId];
//            request.userIds = @[tempMember.userId];
//            [[NIMSDK sharedSDK].chatroomManager fetchChatroomMembersByIds:request completion:^(NSError * _Nullable error, NSArray<NIMChatroomMember *> * _Nullable members) {
//                if (error == nil) {
//                    if (members.count > 0) {
//                        NIMChatroomMember *chatRoomMember = members[0];
//                        NotifyCoreClient(RoomCoreClient, @selector(onManagerRemove:), onManagerRemove:chatRoomMember);
//                    }
//                }else {
//
//                }
//            }];
//        }
//    }
//}
////收到添加管理更新通知
//- (void)managerAdd:(NIMMessage *)message {
//    if (message.messageType == NIMMessageTypeNotification) {
//        NIMNotificationObject *notiMsg = (NIMNotificationObject *)message.messageObject;
//        NIMChatroomNotificationContent *content = (NIMChatroomNotificationContent *)notiMsg.content;
//        if (content.eventType == NIMChatroomEventTypeAddManager) {//设置为管理员
//            NIMChatroomNotificationMember *tempMember = content.targets[0];
//            NIMChatroomMembersByIdsRequest *request = [[NIMChatroomMembersByIdsRequest alloc]init];
//            request.roomId = [NSString stringWithFormat:@"%ld",(long)self.currentRoomInfo.roomId];
//            request.userIds = @[tempMember.userId];
//            [[NIMSDK sharedSDK].chatroomManager fetchChatroomMembersByIds:request completion:^(NSError * _Nullable error, NSArray<NIMChatroomMember *> * _Nullable members) {
//                if (error == nil) {
//                    if (members.count > 0) {
//                        NIMChatroomMember *chatRoomMember = members[0];
//                        NotifyCoreClient(RoomCoreClient, @selector(onManagerAdd:), onManagerAdd:chatRoomMember);
//                    }
//                }else {
//
//                }
//            }];
//        }
//    }
//}
////收到聊天室成员主动更新了聊天室的角色信息通知
//- (void)onReceiveChatRoomMemberInfoUpdateMessages:(NIMMessage *)message {
//    NotifyCoreClient(RoomCoreClient, @selector(onMicroStateChange), onMicroStateChange);
//    if (message.messageType == NIMMessageTypeNotification) {
//        NIMNotificationObject *notiMsg = (NIMNotificationObject *)message.messageObject;
//        NIMChatroomNotificationContent *content = (NIMChatroomNotificationContent *)notiMsg.content;
//        if (content.eventType == NIMChatroomEventTypeMemberUpdateInfo) {//  聊天室成员主动更新了聊天室的角色信息
//            NIMChatroomNotificationMember *tempMember = content.targets[0];
//            NIMChatroomMembersByIdsRequest *request = [[NIMChatroomMembersByIdsRequest alloc]init];
//            request.roomId = [NSString stringWithFormat:@"%ld",(long)self.currentRoomInfo.roomId];
//            request.userIds = @[tempMember.userId];
//            [[NIMSDK sharedSDK].chatroomManager fetchChatroomMembersByIds:request completion:^(NSError * _Nullable error, NSArray<NIMChatroomMember *> * _Nullable members) {
//                if (error == nil) {
//                    if (members.count > 0) {
//                        NIMChatroomMember *chatRoomMember = members[0];
//                        NotifyCoreClient(RoomCoreClient, @selector(userInfoUpdateWithInfo:), userInfoUpdateWithInfo:chatRoomMember);
//                    }
//                }else {
//
//                }
//            }];
//        }
//    }
//}
////链接状态改变
//- (void)onConnectionStateChanged:(NIMChatroomConnectionState)state
//{
//    if(state == NIMChatroomConnectionStateEnterOK) {//进入聊天室成功
//
//        //        [self requestCurrentMicroList:self.currentRoomInfo.uid];
////        [self fetchRoomMembers];
////        [self fetchRoomRegularMembers];
//    }
//}
//
//
////进入聊天室成功
//- (void)onMeInterChatRoomSuccess
//{
//    if (self.currentRoomInfo == nil) {
//        return;
//    }
//    [self reportUserInterRoom];//上报进入房间
//    [self startRoomTimer];
//    UserID uid = [GetCore(AuthCore) getUid].userIDValue;
//    if (self.currentRoomInfo.uid == uid) {
//        //        [GetCore(MeetingCore) reserveMeeting:[NSString stringWithFormat:@"%ld",self.currentRoomInfo.roomId]];
//        [GetCore(MeetingCore) joinMeeting:[NSString stringWithFormat:@"%ld",self.currentRoomInfo.roomId] actor:YES];
//    } else {
//        [GetCore(MeetingCore) joinMeeting:[NSString stringWithFormat:@"%ld",self.currentRoomInfo.roomId] actor:NO];
//    }
//
//    if (GetCore(MeetingCore).actor) {
//        //        GetCore(RoomQueueCore)
//    }
//
////    [GetCore(RoomCore)fetchRoomMembers];
////    [GetCore(RoomCore)fetchRoomRegularMembers];
//}
//
//
//
////退出房
//- (void)onMeExitChatRoomSuccessV2
//{
//    [self cancelRoomRecord];
//    if (self.currentRoomInfo.uid == [GetCore(AuthCore) getUid].userIDValue && self.currentRoomInfo.type != RoomType_Game) {
//        [self closeRoom:self.currentRoomInfo.uid];
//    }
//    [self reportUserOuterRoom];
//    [GetCore(MeetingCore) leaveMeeting:[NSString stringWithFormat:@"%ld",self.currentRoomInfo.roomId]];
//    self.currentRoomInfo = nil;
//    self.currentMicroList = nil;
//    self.currentApplyList = nil;
//    self.speakingList = nil;
//    self.messages = nil;
//    [self.adminMembers removeAllObjects];
//    [self.members removeAllObjects];
//}
////用户被踢
//- (void)onUserBeKicked:(NSString *)roomid reason:(NIMChatroomKickReason)reason
//{
//    [GetCore(MeetingCore) leaveMeeting:[NSString stringWithFormat:@"%ld",self.currentRoomInfo.roomId]];
//    self.currentRoomInfo = nil;
//    self.currentMicroList = nil;
//    self.currentApplyList = nil;
//    self.speakingList = nil;
//    self.messages = nil;
//    [self.adminMembers removeAllObjects];
//    [self.members removeAllObjects];
//}
////退出房 或者被踢通知
//- (void)onUserExitChatRoom:(NIMMessage *)message {
////    [self fetchRoomMembers];
////    [self fetchRoomRegularMembers];
//    if (message.messageType == NIMMessageTypeNotification){ //房间人员进出
//        NIMNotificationObject *notiMsg = (NIMNotificationObject *)message.messageObject;
//        NIMChatroomNotificationContent *content = (NIMChatroomNotificationContent *)notiMsg.content;
//        if (content.eventType == NIMChatroomEventTypeExit ||content.eventType == NIMChatroomEventTypeKicked) {// 成员离开聊天室||聊天室成员被踢
//            NIMChatroomNotificationMember *member = content.targets[0];
//
//            NotifyCoreClient(RoomCoreClient, @selector(userExitChatRoomWith:), userExitChatRoomWith:member.userId);
//        }
//    }
//}
////用户被加入黑名单通知
//- (void)onUserBeAddBlack:(NIMMessage *)message {
//    if (message.messageType == NIMMessageTypeNotification){ //房间人员进出
//        NIMNotificationObject *notiMsg = (NIMNotificationObject *)message.messageObject;
//        NIMChatroomNotificationContent *content = (NIMChatroomNotificationContent *)notiMsg.content;
//        if (content.eventType == NIMChatroomEventTypeAddBlack) {//成员被拉黑
//            NIMChatroomNotificationMember *member = content.targets[0];
//            NIMChatroomMembersByIdsRequest *request = [[NIMChatroomMembersByIdsRequest alloc]init];
//            request.roomId = [NSString stringWithFormat:@"%ld",(long)self.currentRoomInfo.roomId];
//            request.userIds = @[member.userId];
//            [[NIMSDK sharedSDK].chatroomManager fetchChatroomMembersByIds:request completion:^(NSError * _Nullable error, NSArray<NIMChatroomMember *> * _Nullable members) {
//                if (error == nil) {
//                    if (members.count > 0) {
//                        NIMChatroomMember *chatRoomMember = members[0];
//                        NotifyCoreClient(RoomCoreClient, @selector(userBeAddBlack:), userBeAddBlack:chatRoomMember);
//                    }
//                }else {
//
//                }
//            }];
//
//        }
//    }
//}
////用户被移除黑名单通知
//- (void)onUserBeRemoveBlack:(NIMMessage *)message {
//    if (message.messageType == NIMMessageTypeNotification){ //房间人员进出
//        NIMNotificationObject *notiMsg = (NIMNotificationObject *)message.messageObject;
//        NIMChatroomNotificationContent *content = (NIMChatroomNotificationContent *)notiMsg.content;
//        if (content.eventType == NIMChatroomEventTypeRemoveBlack) {//成员被取消拉黑
//            NIMChatroomNotificationMember *member = content.targets[0];
//
//            NotifyCoreClient(RoomCoreClient, @selector(userBeRemoveBlack:), userBeRemoveBlack:member.userId);
//        }
//    }
//}
////用户进入聊天室
//- (void)onUserInterChatRoom:(NIMMessage *)message
//{
////    [self fetchRoomMembers];
////    [self fetchRoomRegularMembers];
//
//    if (message.messageType == NIMMessageTypeNotification){ //房间人员进出
//        NIMNotificationObject *notiMsg = (NIMNotificationObject *)message.messageObject;
//        NIMChatroomNotificationContent *content = (NIMChatroomNotificationContent *)notiMsg.content;
//        if (content.eventType == NIMChatroomEventTypeEnter) {// 成员进入聊天室
//            NIMChatroomNotificationMember *member = content.targets[0];
//
//            NIMChatroomMembersByIdsRequest *request = [[NIMChatroomMembersByIdsRequest alloc]init];
//            request.roomId = [NSString stringWithFormat:@"%ld",(long)self.currentRoomInfo.roomId];
//            request.userIds = @[member.userId];
//            [[NIMSDK sharedSDK].chatroomManager fetchChatroomMembersByIds:request completion:^(NSError * _Nullable error, NSArray<NIMChatroomMember *> * _Nullable members) {
//                if (error == nil) {
//                    if (members.count > 0) {
//                        NIMChatroomMember *chatRoomMember = members[0];
//                        NotifyCoreClient(RoomCoreClient, @selector(userInterRoomWith:), userInterRoomWith:chatRoomMember);
//                    }
//                }else {
//
//                }
//            }];
//        }
//    }
//    [self addMessageToArray:message];
//}
//
////获取房间成员
//- (void)fetchRoomMembers {
//    NIMChatroomMemberRequest *request = [[NIMChatroomMemberRequest alloc]init];
//    request.roomId = [NSString stringWithFormat:@"%ld",(long)self.currentRoomInfo.roomId];
//    request.type = NIMChatroomFetchMemberTypeTemp;//聊天室临时成员，只有在线时才能在列表中看到,数量无上限
//    request.limit = 200;
//    @weakify(self);
//    [[NIMSDK sharedSDK].chatroomManager fetchChatroomMembers:request completion:^(NSError * _Nullable error, NSArray<NIMChatroomMember *> * _Nullable members) {
//        @strongify(self);
//        if (error == nil) {
//
//            NSArray *sortReuslt = [members sortedArrayUsingComparator:^NSComparisonResult(NIMChatroomMember *obj1, NIMChatroomMember *obj2) {
//
//                return obj2.enterTimeInterval > obj1.enterTimeInterval;
//            }];
//
//
//            [self.members addObjectsFromArray:sortReuslt];
//
//
//            NotifyCoreClient(RoomCoreClient, @selector(fetchMembersSuccess:), fetchMembersSuccess:self.members);
//            [YYLogger info:@"fetchAllRoomMembersSuccess" message:@"success--->%ld",self.members.count];
//        } else {
//            [YYLogger info:@"fetchAllRoomMembersError" message:@"error--->%@",error.description];
//        }
//    }];
//}
//
////获取所有有固定成员（管理与黑名单）
//- (void)fetchRoomAllRegularMembers {
//    NIMChatroomMemberRequest *request = [[NIMChatroomMemberRequest alloc]init];
//    request.roomId = [NSString stringWithFormat:@"%ld",(long)self.currentRoomInfo.roomId];
//    request.type = NIMChatroomFetchMemberTypeRegular;
//    request.limit = 200;
//    @weakify(self);
//    [[NIMSDK sharedSDK].chatroomManager fetchChatroomMembers:request completion:^(NSError * _Nullable error, NSArray<NIMChatroomMember *> * _Nullable members) {
//        @strongify(self);
//        if (error == nil) {
//
//            NSArray *sortReuslt = [members sortedArrayUsingComparator:^NSComparisonResult(NIMChatroomMember *obj1, NIMChatroomMember *obj2) {
//                return obj2.enterTimeInterval > obj1.enterTimeInterval;
//            }];
//
//
//            NSMutableArray *managerMembersArr = [NSMutableArray array];
//            NSMutableArray *blackListMembersArr = [NSMutableArray array];
//            for (NIMChatroomMember *item in sortReuslt) {
//                if (item.type == NIMChatroomMemberTypeManager) {
//                    [managerMembersArr addObject:item];
//                }else if (item.isInBlackList) {
//                    [blackListMembersArr addObject:item];
//                }
//            }
//
//            GetCore(RoomQueueCore).mamagerMembers = managerMembersArr;
//            GetCore(RoomQueueCore).backList = blackListMembersArr;
//            NotifyCoreClient(RoomCoreClient, @selector(fetchAllRegularMemberSuccess), fetchAllRegularMemberSuccess);
//            [YYLogger info:@"fetchRoomMembersSuccess" message:@"success--->%ld",self.members.count];
//        } else {
//            [YYLogger info:@"fetchRoomMembersError" message:@"error--->%@",error.description];
//            NotifyCoreClient(RoomCoreClient, @selector(fetchAllRegulatMemberFailth:), fetchAllRegulatMemberFailth:error.description);
//        }
//
//    }];
//}
//
//
////聊天室在线的固定成员
//- (void)fetchRoomRegularMembers {
//
//    NIMChatroomMemberRequest *request = [[NIMChatroomMemberRequest alloc]init];
//    request.roomId = [NSString stringWithFormat:@"%ld",(long)self.currentRoomInfo.roomId];
//    request.type = NIMChatroomFetchMemberTypeRegularOnline;//聊天室在线的固定成员
//    request.limit = 200;
//    @weakify(self);
//    [[NIMSDK sharedSDK].chatroomManager fetchChatroomMembers:request completion:^(NSError * _Nullable error, NSArray<NIMChatroomMember *> * _Nullable members) {
//        @strongify(self);
//        if (error == nil) {
//
//            NSArray *sortReuslt = [members sortedArrayUsingComparator:^NSComparisonResult(NIMChatroomMember *obj1, NIMChatroomMember *obj2) {
//                return obj2.enterTimeInterval > obj1.enterTimeInterval;
//            }];
//
//
//            NSMutableArray *membersArr = [sortReuslt mutableCopy];
//            self.members = membersArr;
//            [self fetchRoomMembers];
//        } else {
//
//        }
//    }];
//
//}
//
////加入黑名单
//- (void)updateMemberInBlackList:(UserID)userID{
//    NIMChatroomMemberUpdateRequest *request = [[NIMChatroomMemberUpdateRequest alloc]init];
//    request.roomId = [NSString stringWithFormat:@"%ld",(long)self.currentRoomInfo.roomId];
//    request.userId = [NSString stringWithFormat:@"%lld",userID];
//    request.enable = YES;
//    [[NIMSDK sharedSDK].chatroomManager updateMemberBlack:request completion:^(NSError * _Nullable error) {
//        if (error == nil) {
//            NotifyCoreClient(RoomCoreClient, @selector(updateMemberInBlackListSuccess), updateMemberInBlackListSuccess);
//        }else {
//            NotifyCoreClient(RoomCoreClient, @selector(updateMemberInBlackListFailth:), updateMemberInBlackListFailth:error.description);
//        }
//    }];
//}
//
//
////判断自己是否在黑名单
//- (void)judgeIsInBlackList:(NSString *)roomID {
//    NSString *uid = [GetCore(AuthCore) getUid];
//    NIMChatroomMembersByIdsRequest *request = [[NIMChatroomMembersByIdsRequest alloc]init];
//    request.roomId = roomID;
//    request.userIds = @[uid];
//    [[NIMSDK sharedSDK].chatroomManager fetchChatroomMembersByIds:request completion:^(NSError * _Nullable error, NSArray<NIMChatroomMember *> * _Nullable members) {
//        for (NIMChatroomMember *member in members) {
//            if (member.isInBlackList) {
//                NotifyCoreClient(AuthCoreClient, @selector(mySelfIsInBalckList:), mySelfIsInBalckList:YES);
//            }else {
//                NotifyCoreClient(AuthCoreClient, @selector(mySelfIsInBalckList:), mySelfIsInBalckList:NO);
//            }
//        }
//    }];
//}
//
//
//
////获取房间收听人数
//- (NSInteger)getTheLisnterNumber {
//    //    return self.adminMembers.count + self.members.count + 1;
//    return GetCore(RoomQueueCore).displayAllMembers.count;
//}
//
////房间埋点统计
//- (void)recordTheRoomTime:(UserID)uid roomUid:(UserID)roomUid {
//    [HttpRequestHelper recordTheRoomTime:uid roomUid:roomUid];
//}
////开始房间统计（60s之后才统计）
//- (void)startRoomTimer {
//    // 获得队列
//    dispatch_queue_t queue = dispatch_get_main_queue();
//
//    // 创建一个定时器(dispatch_source_t本质还是个OC对象)
//    self.timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
//
//    // 设置定时器的各种属性（几时开始任务，每隔多长时间执行一次）
//    // GCD的时间参数，一般是纳秒（1秒 == 10的9次方纳秒）
//    // 何时开始执行第一个任务
//    // dispatch_time(DISPATCH_TIME_NOW, 1.0 * NSEC_PER_SEC) 比当前时间晚3秒
//    dispatch_time_t start = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC));
//    uint64_t interval = (uint64_t)(60.0 * NSEC_PER_SEC);
//    dispatch_source_set_timer(self.timer, start, interval, 0);
//
//    // 设置回调
//    @weakify(self);
//    dispatch_source_set_event_handler(self.timer, ^{
////        NSLog(@"------------%@", [NSThread currentThread]);
//        @strongify(self);
//        if ([GetCore(AuthCore) getUid].userIDValue != self.currentRoomInfo.uid) {
//            [self recordTheRoomTime:[GetCore(AuthCore) getUid].userIDValue roomUid:self.currentRoomInfo.uid];
//        }
//    });
//
//    // 启动定时器
//    dispatch_resume(self.timer);
//
//}
//
//- (void)cancelRoomRecord {
//    self.timer = nil;
//}
//
////用户离开麦序
//- (void)userLeftMicroWithRoomUid:(UserID)roomuid {
//    [HttpRequestHelper userLeftMicroWithRoomUid:roomuid];
//}
//
//- (void)setRoomManagerWithUid:(UserID)uid {
//    NIMChatroomMemberUpdateRequest *request = [[NIMChatroomMemberUpdateRequest alloc]init];
//    request.roomId = [NSString stringWithFormat:@"%ld",(long)self.currentRoomInfo.roomId];
//    request.userId = [NSString stringWithFormat:@"%lld",uid];
//    [[NIMSDK sharedSDK].chatroomManager markMemberManager:request completion:^(NSError * _Nullable error) {
//        if (error != nil) {
//
//        }else {
//
//        }
//    }];
//}
//
////移除黑名单 enable为no
//- (void)removeBlackListWithUid:(UserID)uid {
//    NIMChatroomMemberUpdateRequest *request = [[NIMChatroomMemberUpdateRequest alloc]init];
//    request.roomId = [NSString stringWithFormat:@"%ld",(long)self.currentRoomInfo.roomId];
//    request.userId = [NSString stringWithFormat:@"%lld",uid];
//    request.enable = NO;
//    [[NIMSDK sharedSDK].chatroomManager updateMemberBlack:request completion:^(NSError * _Nullable error) {
//        if (error != nil) {
//
//        }else {
//
//        }
//    }];
//}
////移除管理员 enable 为no
//- (void)removeRoomManagerWithUid:(UserID)uid {
//    NIMChatroomMemberUpdateRequest *request = [[NIMChatroomMemberUpdateRequest alloc]init];
//    request.roomId = [NSString stringWithFormat:@"%ld",(long)self.currentRoomInfo.roomId];
//    request.userId = [NSString stringWithFormat:@"%lld",uid];
//    request.enable = NO;
//    [[NIMSDK sharedSDK].chatroomManager markMemberManager:request completion:^(NSError * _Nullable error) {
//        if (error != nil) {
//
//        }else {
//
//        }
//    }];
//}
//
//- (void)setRoomNormalWithUid:(UserID)uid {
//    NIMChatroomMemberUpdateRequest *request = [[NIMChatroomMemberUpdateRequest alloc]init];
//    request.roomId = [NSString stringWithFormat:@"%ld",(long)self.currentRoomInfo.roomId];
//    request.userId = [NSString stringWithFormat:@"%lld",uid];
//    [[NIMSDK sharedSDK].chatroomManager markNormalMember:request completion:^(NSError * _Nullable error) {
//        if (error != nil) {
//
//        }else {
//
//        }
//    }];
//}
//
////获取用户进入了的房间的信息
//- (void)getUserInterRoomInfo:(UserID)uid {
//    [HttpRequestHelper requestUserInRoomInfoBy:uid Success:^(RoomInfo *roomInfo) {
//        NotifyCoreClient(RoomCoreClient, @selector(requestUserRoomInterInfo: uid:), requestUserRoomInterInfo:roomInfo uid:uid);
//    } failure:^(NSNumber *resCode, NSString *message) {
//        NotifyCoreClient(RoomCoreClient, @selector(requestUserRoomInterInfoFailth:), requestUserRoomInterInfoFailth:message);
//    }];
//}
//
//- (void)reportUserInterRoom {
//    if ([GetCore(AuthCore)getTicket].length > 0) {
//        [HttpRequestHelper reportUserInterRoomSuccess:^(BOOL success) {
//        } failure:^(NSNumber *resCode, NSString *message) {
//        }];
//    }
//}
//
//- (void)reportUserOuterRoom {
//    if ([GetCore(AuthCore) getTicket].length > 0) {
//        [HttpRequestHelper reportUserOutRoomSuccess:^(BOOL success) {
//        } failure:^(NSNumber *resCode, NSString *message) {
//
//        }];
//    }
//}
//
//#pragma mark - Getter
////判断是否在房间
//- (BOOL)isInRoom {
//    if (_currentRoomInfo != nil) {
//        return YES;
//    }else {
//        return NO;
//    }
//}
//
////房主修改游戏房间信息
//- (void)updateGameRoomInfo:(UserID)uid title:(NSString *)title roomTopic:(NSString *)roomTopic roomPassword:(NSString *)roomPassword tag:(int)tag {
//    [HttpRequestHelper updateRoomInfo:uid title:title roomDesc:roomTopic backPic:nil roomPassword:roomPassword tag:tag success:^(RoomInfo *roomInfo) {
//        self.currentRoomInfo = roomInfo;
//        NotifyCoreClient(RoomCoreClient, @selector(onGameRoomInfoUpdateSuccess:), onGameRoomInfoUpdateSuccess:roomInfo);
//    } failure:^(NSNumber *resCode, NSString *message) {
//        NotifyCoreClient(RoomCoreClient, @selector(onGameRoomInfoUpdateFailth:), onGameRoomInfoUpdateFailth:message);
//    }];
//}
//
////管理员修改房间信息
//- (void)managerUpdateGameRoomInfo:(UserID)uid title:(NSString *)title roomTopic:(NSString *)roomTopic roomPassword:(NSString *)roomPassword tag:(int)tag {
//    [HttpRequestHelper managerUpdateRoomInfo:uid title:title roomDesc:roomTopic backPic:nil roomPassword:roomPassword tag:tag success:^(RoomInfo *roomInfo) {
//        self.currentRoomInfo = roomInfo;
//        NotifyCoreClient(RoomCoreClient, @selector(onGameRoomInfoUpdateSuccess:), onGameRoomInfoUpdateSuccess:roomInfo);
//    } failure:^(NSNumber *resCode, NSString *message) {
//        NotifyCoreClient(RoomCoreClient, @selector(onGameRoomInfoUpdateFailth:), onGameRoomInfoUpdateFailth:message);
//    }];
//}
////根据uid获取用户资料
//- (RACSignal *)fetchMemberInfoByUid:(NSString *)uid {
//    if (uid == nil || uid.length<=0) {
//        return nil;
//    }
//    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
//        NIMUser *user = [[NIMSDK sharedSDK].userManager userInfo:uid];//从本地获取用户资料
//        if (user.userInfo) {
//            [subscriber sendNext:user];
//            [subscriber sendCompleted];
//        }else {
//            NSArray *uids = @[uid];
//            //从云信服务器批量获取用户资料
//            [[NIMSDK sharedSDK].userManager fetchUserInfos:uids completion:^(NSArray<NIMUser *> * _Nullable users, NSError * _Nullable error) {
//                if (error == nil) {
//                    [subscriber sendNext:users[0]];
//                    [subscriber sendCompleted];
//                }else {
//                    [subscriber sendError:error];
//                }
//
//            }];
//        }
//        return nil;
//    }];
//}
//
////批量获取用户信息
//- (void)fetchMembersInfoByUids:(NSArray *)uids type:(NSInteger)type {
//    if (uids > 0) {
//        [[NIMSDK sharedSDK].userManager fetchUserInfos:uids completion:^(NSArray<NIMUser *> * _Nullable users, NSError * _Nullable error) {
//            if (error == nil) {
//                if (type == 1) {
//                    GetCore(RoomQueueCore).backListUsers = [users mutableCopy];
//                }else {
//                    GetCore(RoomQueueCore).mamagerUsers = [users mutableCopy];
//                }
//
//                NotifyCoreClient(RoomCoreClient, @selector(fetchMembersInfoSuccess:), fetchMembersInfoSuccess:users);
//            }else {
//                //            NotifyCoreClient(RoomCoreClient, @selector(fetchMembersInfoFailth:), fetchMembersInfoFailth:error.description);
//            }
//        }];
//    }
//
//}
//
////保存XCGameRoomPositionView计算的游戏房cell的位置
//- (void)savePosition:(NSMutableArray *)list {
//    self.positionArr = list;
//}
//
//#pragma mark - FaceCoreClient
//- (void)onFaceIsResult:(FacePlayInfo *)info {
//    if ([NSThread isMainThread]){
//        [self addMessageToArray:info.message];
//    }
//}
//
//- (NSMutableArray *)members {
//    if (_members == nil) {
//        _members = [[NSMutableArray alloc]init];
//    }
//    return _members;
//}
//
//- (NSMutableArray *)positionArr {
//    if (_positionArr == nil) {
//        _positionArr = [NSMutableArray array];
//    }
//    return _positionArr;
//}
//
//
//- (void)onRoomInvalid
//{
//    self.currentRoomInfo = nil;
//    self.currentMicroList = nil;
//    self.currentApplyList = nil;
//    self.speakingList = nil;
//    self.messages = nil;
//    [self.adminMembers removeAllObjects];
//    [self.members removeAllObjects];
//}
//@end
//
