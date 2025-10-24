//
//  ImRoomCoreClient.h
//  BberryCore
//
//  Created by chenran on 2017/5/28.
//  Copyright © 2017年 chenran. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <NIMSDK/NIMSDK.h>
@protocol ImRoomCoreClient <NSObject>
@optional


//我进入房间

- (void)onMeInterCharRoomWhenMessageCome;
- (void)onMeInterChatRoomSuccess;
// 进入同一房间(不会调用NIM的enterRoom方法)
- (void)onMeInterChatSameRoomSuccess;
- (void)onMeInterChatRoomFailth;
- (void)onMeInterChatRoomInBlackList;
- (void)onMeInterChatRoomBadNetWork;
//链接状态改变
- (void)onConnectionStateChanged:(NIMChatroomConnectionState)state;
//退出房间
- (void)onMeExitChatRoomFailth;
//获取队列
- (void)onGetRoomQueueSuccess:(NSArray<NSDictionary<NSString *,NSString *> *> *)info;
- (void)onGetRoomQueueFailth:(NSString *)message;

//user进入
- (void)onUserInterChatRoom:(NIMMessage *)message;
//user退出
- (void)onUserExitChatRoom:(NIMMessage *)message;
//user被踢
- (void)onUserBeKicked:(NSString *)roomid reason:(NIMChatroomKickReason)reason;
//user被踢 传出result
- (void)onUserBeKicked:(NSString *)roomid kickResult:(NIMChatroomBeKickedResult *)kickResult;
- (void)onUserBeKicked:(NIMMessage *)message;

//manager
- (void)managerAdd:(NIMMessage *)message;
- (void)managerRemove:(NIMMessage *)message;
//black
- (void)onUserBeAddBlack:(NIMMessage *)message;
- (void)onUserBeRemoveBlack:(NIMMessage *)message;
//麦序
- (void)onRoomQueueUpdate:(NIMMessage *)message;
//micstate/bg
- (void)onRoomInfoUpdate:(NIMMessage *)message;

//memberinfo修改ext
- (void)onReceiveChatRoomMemberInfoUpdateMessages:(NIMMessage *)message;
- (void)onUpdateRoomMemberInfoSuccess:(NIMChatroomMemberInfoUpdateRequest *)request;
- (void)onUpdateRoomMemberInfoFailth:(NSInteger)message;

// 用户被禁言
- (void)onUserHaveBannedForChatRoom:(NIMMessage *)message;


@end

