//
//  MissionCoreClient.h
//  XCChatCoreKit
//
//  Created by lee on 2019/3/28.
//  Copyright © 2019 YiZhuan. All rights reserved.
//
// 任务相关接口回调
//
#import "MissionInfo.h"

@protocol MissionCoreClient <NSObject>
@optional

/** 获取任务列表 */
- (void)getMissionList:(NSArray< MissionInfo *> *)list code:(NSInteger)code message:(NSString *)message;
/** 获取成就任务列表 */
- (void)getMissionAchievementList:(NSArray< MissionInfo *> *)list code:(NSInteger)code message:(NSString *)message;

/** 领取任务奖励 */
- (void)getMissionReceive:(BOOL)isSuccess code:(NSInteger)code message:(NSString *)message;
/** 领取任务奖励（区分类型 1 是每日 2 是成就） */
- (void)getMissionReceive:(BOOL)isSuccess type:(NSInteger)type code:(NSInteger)code message:(NSString *)message;
/** 是否是符合条件的新用户 */
- (void)getMissionNewUser:(BOOL)isSuccess configID:(NSInteger)configID code:(NSInteger)code message:(NSString *)message;
@end
