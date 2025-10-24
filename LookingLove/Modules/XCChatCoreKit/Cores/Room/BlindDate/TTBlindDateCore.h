//
//  TTBlindDateCore.h
//  WanBan
//
//  Created by jiangfuyuan on 2020/10/20.
//  Copyright © 2020 WUJIE INTERACTIVE. All rights reserved.
//

#import "BaseCore.h"

NS_ASSUME_NONNULL_BEGIN

@interface TTBlindDateCore : BaseCore

// 创建倒计时
- (void)createSelectLoveTimer:(NSString *)startTime;

// 停止倒计时
- (void)stopTimer;

/// 更新相亲流程
/// @param roomUid 房间uid
/// @param uid 用户uid
/// @param position 用户麦位
/// @param procedure   当前流程  流程(1 -- 自我介绍, 2 -- 心动选择, 3 -- 心动公布, 4 -- 重新自我介绍)
- (void)updateLoveRoomProcedureWithRoomUid:(UserID)roomUid uid:(UserID)uid position:(NSInteger)position procedure:(NSInteger)procedure;

/// 相亲房上麦
/// @param roomUid 房间uid
/// @param uid 用户uid
/// @param position 用户麦位
- (void)requestLoveRoomUpMicWithRoomUid:(UserID)roomUid uid:(UserID)uid position:(NSInteger)position;

/// 相亲房下麦
/// @param roomUid 房间uid
/// @param uid 用户uid
/// @param position 用户麦位
- (void)requestLoveRoomDownMicWithRoomUid:(UserID)roomUid uid:(UserID)uid position:(NSInteger)position;


/// 相亲房选择心动
/// @param roomUid 房间uid
/// @param uid 用户uid
/// @param position 用户麦位
/// @param choosePosition 选择对象麦位
/// @param chooseUid 选择对象uid
- (void)requestLoveRoomChooseLoveWithRoomUid:(UserID)roomUid uid:(UserID)uid position:(NSInteger)position choosePosition:(NSInteger)choosePosition chooseUid:(UserID)chooseUid;


/// 相亲房公布心动
/// @param roomUid 房间uid
/// @param uid 用户uid
/// @param position 用户麦位
/// @param choosePosition 选择对象麦位
/// @param chooseUid 选择对象uid
/// @param targetPosition 被公布人选择人的uid
/// @param targetMic 被公布人选择人的麦位
- (void)requestLoveRoomPublicLoveWithRoomUid:(UserID)roomUid uid:(UserID)uid position:(NSInteger)position choosePosition:(NSInteger)choosePosition chooseUid:(UserID)chooseUid targetPosition:(NSString *)targetPosition targetMic:(NSString *)targetMic;

@end

NS_ASSUME_NONNULL_END
