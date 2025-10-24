//
//  RoomQueueCoreClient.h
//  BberryCore
//
//  Created by 卫明何 on 2017/9/5.
//  Copyright © 2017年 chenran. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef enum : NSUInteger {
    BePreventTypeDownMic,//皇帝下麦保护
    BePreventTypecloseMic,//皇帝关闭mic保护
} BePreventType;//保护类型



typedef enum : NSUInteger {
    RoomQueueUpateTypeRemove,//从队列移除
    RoomQueueUpateTypeAdd, //加入队列
} RoomQueueUpateType;//队列变更类型

@protocol RoomQueueCoreClient <NSObject>
@optional
- (void)thereIsNoLockPosition;//没有足够的锁麦的坑位了
- (void)thereIsNoFreePosition;//没有足够的空位
- (void)onMicroQueueUpdate:(NSMutableDictionary *)micQueue;//麦序状态变化


- (void)onMicroStateChange;//micstate改变
- (void)onMicroLocked;//锁麦
- (void)onMicroUnLocked;//解锁麦
- (void)onMicroBeInvite;//被邀请
- (void)onMicroBeKicked;//被踢
- (void)onMicroBeSqueezedOut;//被挤下麦
- (void)thisUserIsBePrevent:(BePreventType)type;//不能被踢

//*************队列变更**************
/// 上麦成功
/// @param position 上麦的坑位
/// @param uid 谁上麦了
/// @param isReConnect 是否是断网重连
- (void)onMicroUpMicSuccessWithPosition:(NSString *)position uid:(UserID)uid isReConnect:(BOOL)isReConnect;

- (void)onMicroUpMicFail;//上麦失败

/// 下麦成功
/// @param position 下麦的坑位
- (void)onMicroDownMicSuccessWithPosition:(NSString *)position;

/**
 队列变更回调

 @param userId 队列变更的uid
 @param position 队列变更的位置
 @param updateType 队列变更类型
 */
- (void)onRoomQueueUpdate:(UserID)userId position:(int)position type:(RoomQueueUpateType)updateType;


//fengshuo
- (void)handleCloseMicPlaceSuccessWithPosition:(int)position state:(int)state;



@end
