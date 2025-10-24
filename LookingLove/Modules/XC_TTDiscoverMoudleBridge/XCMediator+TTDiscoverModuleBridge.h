//
//  XCMediator+TTDiscoverModuleBridge.h
//  TuTu
//
//  Created by gzlx on 2018/10/29.
//  Copyright © 2018年 YiZhuan. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "XCMediator.h"

NS_ASSUME_NONNULL_BEGIN

@interface XCMediator (TTDiscoverModuleBridge)

/**
 最新的tabbar上的控制器
 */
- (UIViewController *)ttDiscoverMoudle_TTDiscoverContainViewController;

/** 跳转到群资料详情*/
- (UIViewController *)ttDiscoverMoudle_TTGroupManagerViewController:(NSString *)teamId;
/** 发现的主控制器*/
- (UIViewController *)ttDiscoverMoudle_TTDiscoverViewController;
/** 家族客泰页
 家族 的ID
 */
- (UIViewController *)ttDiscoverMoudle_TTFamilyPersonViewController:(long long)familyId;

/** 家族广场*/
- (UIViewController *)ttDiscoverMoudle_TTFamilySquareViewController;

/**没有家族的时候 */
- (UIViewController *)ttDiscoverMoudle_TTFamilyEmptyViewController;

/**跳转家族游戏 */
- (UIViewController *)ttDiscoverMoudle_TTFamilyGroupGameViewController:(long long)famiyId;

/**
 我的hb奖励(分享奖励、邀请新人奖励）
 */
- (UIViewController *)ttDiscoverMoudle_TTInviteRewardsViewController;
/**
分享到 粉丝 关注 群 好友
 */
- (UIViewController *)ttDiscoverMoudle_TTFamilyShareContainViewController;

/**
 师徒主页
 */
- (UIViewController *)ttDiscoverMoudle_TTMasterViewController;
/**
 签到
 */
- (UIViewController *)ttDiscoverMoudle_TTCheckinViewController;

/**
 任务中心
 */
- (UIViewController *)ttDiscoverMoudle_TTMissionViewController;
@end

NS_ASSUME_NONNULL_END
