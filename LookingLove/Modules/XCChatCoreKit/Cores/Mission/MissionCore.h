//
//  MissionCore.h
//  XCChatCoreKit
//
//  Created by lee on 2019/3/28.
//  Copyright © 2019 YiZhuan. All rights reserved.
//
// 任务 core

#import "BaseCore.h"

NS_ASSUME_NONNULL_BEGIN

@interface MissionCore : BaseCore

/**
 获取任务列表
 interface /mission/list
 */
- (void)requestMissionList;

/**
 请求成就任务列表
 interface mission/achievement/list
 */
- (void)requestMissionAchievementList;

/**
 任务完成领取奖励

 @param configId 任务id
 */
- (void)requestMissionReceiveByMissionID:(NSString *)configId;

/**
 任务完成领取奖励
 
 @param configId 任务id
 @param type 1 是每日任务 2 是成就任务
 */
- (void)requestMissionReceiveByMissionID:(NSString *)configId type:(NSInteger)type;

/**
 查询是否可以领取新人有礼
 
 interface  mission/check/new/user
 */
- (void)requestMissionNewUser;

@end

NS_ASSUME_NONNULL_END
