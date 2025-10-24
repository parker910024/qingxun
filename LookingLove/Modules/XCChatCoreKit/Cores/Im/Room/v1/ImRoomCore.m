////
////  ImRoomCore.m
////  BberryCore
////
////  Created by chenran on 2017/4/19.
////  Copyright © 2017年 chenran. All rights reserved.
////
//
//#import "ImRoomCore.h"
//#import "ImRoomCoreClient.h"
//#import "ImMessageCoreClient.h"
//#import "ImRoomCoreClientV2.h"
//
//#import "ImLoginCoreClient.h"
//#import "PhoneCallCoreClient.h"
//#import "ImLoginCore.h"
//
//@interface ImRoomCore()<NIMChatroomManagerDelegate, ImMessageCoreClient, ImLoginCoreClient, PhoneCallCoreClient>
//
//@end
//
//@implementation ImRoomCore
//- (instancetype)init
//{
//    self = [super init];
//    if (self) {
//        AddCoreClient(ImMessageCoreClient, self);
//        AddCoreClient(ImLoginCoreClient, self);
//        AddCoreClient(PhoneCallCoreClient, self);
//        [[NIMSDK sharedSDK].chatroomManager addDelegate:self];
//    }
//    return self;
//}
//
//- (void)dealloc
//{
//    RemoveCoreClient(ImMessageCoreClient, self);
//    RemoveCoreClient(ImLoginCoreClient, self);
//    RemoveCoreClient(PhoneCallCoreClient, self);
//    [[NIMSDK sharedSDK].chatroomManager removeDelegate:self];
//}
//
//- (void)enterChatRoom:(NSInteger )roomId
//{
//    if (roomId <= 0) {
//        return;
//    }
//    
//    if (roomId == self.currentRoom.roomId.integerValue) {
//        return;
//    }
//    
//    NIMChatroomEnterRequest *request = [[NIMChatroomEnterRequest alloc] init];
//    request.roomId = [NSString stringWithFormat:@"%ld", roomId];
//    [[NIMSDK sharedSDK].chatroomManager enterChatroom:request completion:^(NSError * _Nullable error, NIMChatroom * _Nullable chatroom, NIMChatroomMember * _Nullable me) {
//        if (error == nil) {
//            [YYLogger info:@"join room" message:@"join room success-->%ld", roomId];
////            self.currentRoom = chatroom;
////            NotifyCoreClient(ImRoomCoreClient, @selector(onMeInterChatRoomSuccess), onMeInterChatRoomSuccess);
//        } else {
//            [YYLogger info:@"join room" message:@"join room failth-->%ld", roomId];
//            if (error.code == 13003) {
//                NotifyCoreClient(ImRoomCoreClient, @selector(onMeInterChatRoomInBlackList), onMeInterChatRoomInBlackList);
//            }else if (error.code == 13) {
////                GetCore(ImLoginCore)
//            }
//            else if (error.code == 404 || error.code == 13002) {
//                NotifyCoreClient(ImRoomCoreClient, @selector(onMeInterChatRoomFailth), onMeInterChatRoomFailth);
//            }else {
//
//                NotifyCoreClient(ImRoomCoreClient, @selector(onMeInterChatRoomBadNetWork), onMeInterChatRoomBadNetWork)
//            }
//
//        }
//    }];
//}
//
//- (void)exitChatRoom:(NSInteger)roomId
//{
//    if (_currentRoom == nil || roomId != _currentRoom.roomId.integerValue ) {
//        NotifyCoreClient(ImRoomCoreClientV2, @selector(onMeExitChatRoomSuccessV2), onMeExitChatRoomSuccessV2);
//        return;
//    }
//    
//    [[NIMSDK sharedSDK].chatroomManager exitChatroom:[NSString stringWithFormat:@"%ld", roomId] completion:^(NSError * _Nullable error) {
//        [YYLogger info:@"exitRoomSuccess" message:@"success--->%@",self.currentRoom.name];
//        self.currentRoom = nil;
//        NotifyCoreClient(ImRoomCoreClientV2, @selector(onMeExitChatRoomSuccessV2), onMeExitChatRoomSuccessV2);
//    }];
//}
//
//- (void)kickUser:(UserID)beKickedUid
//{
//    NIMChatroomMemberKickRequest *request = [[NIMChatroomMemberKickRequest alloc] init];
//    request.roomId = self.currentRoom.roomId;
//    request.userId = [NSString stringWithFormat:@"%lld",beKickedUid];
//    [[NIMSDK sharedSDK].chatroomManager kickMember:request completion:^(NSError * _Nullable error) {
//        
//    }];
//}
//
//- (void)getRoomQueueWithRoomId:(NSString *)roomId {
//    [[NIMSDK sharedSDK].chatroomManager fetchChatroomQueue:roomId completion:^(NSError * _Nullable error, NSArray<NSDictionary<NSString *,NSString *> *> * _Nullable info) {
//        if (error == nil) {
//            NotifyCoreClient(ImRoomCoreClient, @selector(onGetRoomQueueSuccess:), onGetRoomQueueSuccess:info);
//            
//        } else {
//            NotifyCoreClient(ImRoomCoreClient, @selector(onGetRoomQueueFailth:), onGetRoomQueueFailth:error.description);
//        }
//    }];
//}
//
//- (void)updateMyRoomMemberInfoWithrequest:(NIMChatroomMemberInfoUpdateRequest *)request {
//    request.needNotify = YES;
//    request.roomId = self.currentRoom.roomId;
//    __block NIMChatroomMemberInfoUpdateRequest * updateRequest = request;
//    [[NIMSDK sharedSDK].chatroomManager updateMyChatroomMemberInfo:request completion:^(NSError * _Nullable error) {
//        if (error == nil) {
//            NotifyCoreClient(ImRoomCoreClient, @selector(onUpdateRoomMemberInfoSuccess:), onUpdateRoomMemberInfoSuccess:updateRequest);
//        }else {
//            NotifyCoreClient(ImRoomCoreClient, @selector(onUpdateRoomMemberInfoFailth:), onUpdateRoomMemberInfoFailth:error.code);
//        }
//    }];
//}
//
//#pragma mark - ImLoginCoreClient
//- (void)onImKick
//{
//    if (self.currentRoom != nil) {
//        [self exitChatRoom:self.currentRoom.roomId.integerValue];
//    }
//}
//
//- (void)onImLogoutSuccess
//{
//    if (self.currentRoom != nil) {
//        [self exitChatRoom:self.currentRoom.roomId.integerValue];
//    }
//}
//
//#pragma mark - NIMChatroomManagerDelegate
//- (void)chatroom:(NSString *)roomId beKicked:(NIMChatroomKickReason)reason
//{
//    self.currentRoom = nil;
//    NotifyCoreClient(ImRoomCoreClient, @selector(onUserBeKicked:reason:), onUserBeKicked:roomId reason:reason);
//}
//
//- (void)chatroom:(NSString *)roomId connectionStateChanged:(NIMChatroomConnectionState)state
//{
//    NotifyCoreClient(ImRoomCoreClient, @selector(onConnectionStateChanged:), onConnectionStateChanged:state);
//}
//
//- (void)chatroom:(NSString *)roomId autoLoginFailed:(NSError *)error
//{
//    
//}
//
//#pragma mark - PhoneCallCoreClient
//- (void)onStartPhoneCallSuccess:(UserID)callUid
//{
//    if (self.currentRoom !=nil) {
//        [self exitChatRoom:self.currentRoom.roomId.integerValue];
//    }
//}
//
//- (void)onResponsePhoneCall:(NSString *)from accept:(BOOL)accept
//{
//    if (accept && self.currentRoom != nil) {
//        [self exitChatRoom:self.currentRoom.roomId.integerValue];
//    }
//}
//
//#pragma mark - ImMessageCoreClient
//- (void)onRecvChatRoomNotiMsg:(NIMMessage *)msg
//{
//    
//    NIMNotificationObject *notiMsg = (NIMNotificationObject *)msg.messageObject;
//
//    NIMChatroomNotificationContent *content = (NIMChatroomNotificationContent *)notiMsg.content;
//    switch (content.eventType) {
//        case NIMChatroomEventTypeEnter:
//            NotifyCoreClient(ImRoomCoreClient, @selector(onUserInterChatRoom:), onUserInterChatRoom:msg);
//            break;
//        case NIMChatroomEventTypeExit:
//            NotifyCoreClient(ImRoomCoreClient, @selector(onUserExitChatRoom:), onUserExitChatRoom:msg);
//            break;
//        case NIMChatroomEventTypeAddBlack:
//            NotifyCoreClient(ImRoomCoreClient, @selector(onUserBeAddBlack:), onUserBeAddBlack:msg);
//            break;
//        case NIMChatroomEventTypeRemoveBlack:
//            NotifyCoreClient(ImRoomCoreClient, @selector(onUserBeRemoveBlack:), onUserBeRemoveBlack:msg);
//            break;
//        case NIMChatroomEventTypeAddMute:
//            break;
//        case NIMChatroomEventTypeRemoveMute:
//            NotifyCoreClient(ImRoomCoreClient, @selector(onRoomInfoUpdate:), onRoomInfoUpdate:msg);
//            break;
//        case NIMChatroomEventTypeMemberUpdateInfo:
//            NotifyCoreClient(ImRoomCoreClient, @selector(onReceiveChatRoomMemberInfoUpdateMessages:), onReceiveChatRoomMemberInfoUpdateMessages:msg);
//            break;
//        case NIMChatroomEventTypeRemoveManager: //移除管理员
//            NotifyCoreClient(ImRoomCoreClient, @selector(managerRemove:), managerRemove:msg);
//            break;
//        case NIMChatroomEventTypeAddManager: //添加管理员
//            NotifyCoreClient(ImRoomCoreClient, @selector(managerAdd:), managerAdd:msg);
//            break;
//        case NIMChatroomEventTypeInfoUpdated:
//            NotifyCoreClient(ImRoomCoreClient, @selector(onRoomInfoUpdate:), onRoomInfoUpdate:msg);
//            break;
//        case NIMChatroomEventTypeKicked:
//            NotifyCoreClient(ImRoomCoreClient, @selector(onUserExitChatRoom:), onUserExitChatRoom:msg);
//            break;
//        case NIMChatroomEventTypeQueueChange:
//            NotifyCoreClient(ImRoomCoreClient, @selector(onRoomQueueUpdate:), onRoomQueueUpdate:msg);
//            break;
//        default:
//            break;
//    }
//}
//@end
//
//
//
