//
//  Target_TTDiscoverMoudle.h
//  TuTu
//
//  Created by gzlx on 2018/11/16.
//  Copyright © 2018年 YiZhuan. All rights reserved.
//

#import "BaseObject.h"

NS_ASSUME_NONNULL_BEGIN

@interface Target_TTDiscoverMoudle : BaseObject
/**
 最新的发现页的tabbar上的控制器
 */
- (UIViewController *)Action_TTDiscoverContainViewController;


/*** 群资料*/
- (UIViewController *)Action_TTGroupManagerViewController:(NSDictionary *)teamDic;

/** 发现的主控制器*/
- (UIViewController *)Action_TTDiscoverViewController;
/** 家族客泰页
 家族 的ID
 */
- (UIViewController *)Action_TTFamilyPersonViewController:(NSDictionary *)params;

/** 家族广场*/
- (UIViewController *)Action_TTFamilySquareViewController;

/**没有家族的时候 */
- (UIViewController *)Action_TTFamilyEmptyViewController;

/**跳转家族游戏 */
- (UIViewController *)Action_TTFamilyGroupGameViewController:(NSDictionary *)params;

/** 我的hb奖励(分享奖励、邀请新人奖励） */
- (UIViewController *)Action_TTInviteRewardsViewController;
/**
 分享 粉丝 好友 关注
 */
- (UIViewController *)Action_TTFamilyShareContainViewController;

/**
 师徒主页
 */
- (UIViewController *)Action_TTMasterViewController;

/**
 签到
 */
- (UIViewController *)Action_TTCheckinViewController;

/**
 任务中心
 */
- (UIViewController *)Action_TTMissionViewController;

@end

NS_ASSUME_NONNULL_END
