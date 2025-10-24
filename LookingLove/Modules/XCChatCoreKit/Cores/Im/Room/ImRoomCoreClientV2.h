//
//  ImRoomCoreClientV2.h
//  BberryCore
//
//  Created by chenran on 2017/8/1.
//  Copyright © 2017年 chenran. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ImRoomCoreClientV2 <NSObject>
@optional
//exit room
- (void)onMeExitChatRoomSuccessV2;
//获取队列
- (void)onGetPreRoomQueueSuccessV2:(NSMutableDictionary*)info;//获取房间队列
- (void)onGetRoomQueueSuccessV2:(NSMutableDictionary*)info;//获取了chatroommember后
//get onlinelist
- (void)fetchRoomUserListSuccess:(int)state;
- (void)fetchRoomUserListFail:(int)state;

//当前房间用户列表请求响应，当前兔兔使用，create by @lvjunhang
- (void)responseChatroomMembersSuccess;
- (void)responseChatroomMembersError:(NSError *)error;

//get manager or back list
- (void)fetchAllRegularMemberSuccess;
- (void)fetchAllRegularMemberError:(NSError *)error;

//房间信息改变
- (void)onCurrentRoomInfoChanged;
//更新房间在线人数
- (void)onCurrentRoomOnLineUserCountUpdate;

@end
