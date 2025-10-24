//
//  Target_TTDiscoverMoudle.m
//  TuTu
//
//  Created by gzlx on 2018/11/16.
//  Copyright © 2018年 YiZhuan. All rights reserved.
//

#import "Target_TTDiscoverMoudle.h"
#import "TTGroupManagerViewController.h"
#import "TTDiscoverViewController.h"
#import "TTFamilyPersonViewController.h"
#import "TTFamilySquareViewController.h"
#import "TTFamilyEmptyViewController.h"
#import "TTFamilyGroupGameViewController.h"
#import "TTInviteRewardsViewController.h"
#import "TTFamilyShareContainViewController.h"
#import "TTMasterViewController.h"
#import "TTCheckinViewController.h"
#import "TTMissionViewController.h"
#import "TTDiscoverContainViewController.h"
#import "TTMissionContainViewController.h"
#import "LLDiscoverContainerViewController.h"
#import "XCMacros.h"

@implementation Target_TTDiscoverMoudle

/**
 最新的发现页的tabbar上的控制器
 */
- (UIViewController *)Action_TTDiscoverContainViewController{
    if (projectType() ==  ProjectType_LookingLove || projectType() == ProjectType_Planet) {
        LLDiscoverContainerViewController * controller = [[LLDiscoverContainerViewController alloc] init];
        return controller;
    }else {
        TTDiscoverContainViewController * controller = [[TTDiscoverContainViewController alloc] init];
        return controller;
    }
}

/*** 群资料*/
- (UIViewController *)Action_TTGroupManagerViewController:(NSDictionary *)teamDic{
    TTGroupManagerViewController * groupVC = [[TTGroupManagerViewController alloc] init];
    groupVC.teamId = [teamDic[@"teamId"] integerValue];
    return groupVC;
}

/** 发现的主控制器*/
- (UIViewController *)Action_TTDiscoverViewController{
    TTDiscoverViewController * discoverVC = [[TTDiscoverViewController alloc] init];
    return discoverVC;
}
/** 家族客泰页
 家族 的ID
 */
- (UIViewController *)Action_TTFamilyPersonViewController:(NSDictionary *)params{
    TTFamilyPersonViewController * familyVC = [[TTFamilyPersonViewController alloc] init];
    familyVC.familyId = params[@"familyId"];
    return familyVC;
}
/** 家族广场*/
- (UIViewController *)Action_TTFamilySquareViewController{
    TTFamilySquareViewController * squareVC = [[TTFamilySquareViewController alloc] init];
    return squareVC;
}


/**没有家族的时候 */
- (UIViewController *)Action_TTFamilyEmptyViewController{
    TTFamilyEmptyViewController * controller = [[TTFamilyEmptyViewController alloc] init];
    return controller;
}

/**跳转家族游戏 */
- (UIViewController *)Action_TTFamilyGroupGameViewController:(NSDictionary *)params{
    TTFamilyGroupGameViewController * controller = [[TTFamilyGroupGameViewController alloc] init];
    controller.familyId = [params[@"familyId"] integerValue];
    return controller;
}

/** 我的hb奖励(分享奖励、邀请新人奖励） */
- (UIViewController *)Action_TTInviteRewardsViewController {
    TTInviteRewardsViewController *vc = [[TTInviteRewardsViewController alloc] init];
    return vc;
}

- (UIViewController *)Action_TTFamilyShareContainViewController{
    TTFamilyShareContainViewController * shareVC = [[TTFamilyShareContainViewController alloc] init];
    return shareVC;
}

/**
 师徒主页
 */
- (UIViewController *)Action_TTMasterViewController{
    TTMasterViewController * masterVC = [[TTMasterViewController alloc] init];
    return masterVC;
}

/**
 签到
 */
- (UIViewController *)Action_TTCheckinViewController {
    TTCheckinViewController *vc = [[TTCheckinViewController alloc] init];
    return vc;
}

/**
 任务中心
 */
- (UIViewController *)Action_TTMissionViewController{
    TTMissionContainViewController * missionVC = [[TTMissionContainViewController alloc] init];
    return missionVC;
}
@end
