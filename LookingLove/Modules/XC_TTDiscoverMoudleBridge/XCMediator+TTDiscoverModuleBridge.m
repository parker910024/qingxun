//
//  XCMediator+TTDiscoverModuleBridge.m
//  TuTu
//
//  Created by gzlx on 2018/10/29.
//  Copyright © 2018年 YiZhuan. All rights reserved.
//

#import "XCMediator+TTDiscoverModuleBridge.h"


@implementation XCMediator (TTDiscoverModuleBridge)

/**
 最新的tabbar上的控制器
 */
- (UIViewController *)ttDiscoverMoudle_TTDiscoverContainViewController{
    return [self performTarget:@"TTDiscoverMoudle" action:@"TTDiscoverContainViewController" params:nil shouldCacheTarget:NO];
}

/** 跳转到群资料详情*/
- (UIViewController *)ttDiscoverMoudle_TTGroupManagerViewController:(NSString *)teamId{
     NSDictionary * params = @{@"teamId":teamId};
    return [self performTarget:@"TTDiscoverMoudle" action:@"TTGroupManagerViewController" params:params shouldCacheTarget:NO];
}

/** 发现的主控制器*/
- (UIViewController *)ttDiscoverMoudle_TTDiscoverViewController{
    return [self performTarget:@"TTDiscoverMoudle" action:@"TTDiscoverViewController" params:nil shouldCacheTarget:NO];
}
/** 家族客泰页
 家族 的ID
 */
- (UIViewController *)ttDiscoverMoudle_TTFamilyPersonViewController:(long long)familyId{
    NSDictionary * params = @{@"familyId":@(familyId)};
    return [self performTarget:@"TTDiscoverMoudle" action:@"TTFamilyPersonViewController" params:params shouldCacheTarget:NO];
}

/** 家族广场*/
- (UIViewController *)ttDiscoverMoudle_TTFamilySquareViewController{
    return [self performTarget:@"TTDiscoverMoudle" action:@"TTFamilySquareViewController" params:nil shouldCacheTarget:NO];
}

/**没有家族的时候 */
- (UIViewController *)ttDiscoverMoudle_TTFamilyEmptyViewController{
    return [self performTarget:@"TTDiscoverMoudle" action:@"TTFamilyEmptyViewController" params:nil shouldCacheTarget:NO];
}

/**跳转家族游戏 */
- (UIViewController *)ttDiscoverMoudle_TTFamilyGroupGameViewController:(long long)famiyId{
    NSDictionary * params = @{@"familyId":@(famiyId)};
    return [self performTarget:@"TTDiscoverMoudle" action:@"TTFamilyGroupGameViewController" params:params shouldCacheTarget:NO];
}

/**
 我的hb奖励(分享奖励、邀请新人奖励）
 */
- (UIViewController *)ttDiscoverMoudle_TTInviteRewardsViewController {
    return [self performTarget:@"TTDiscoverMoudle" action:@"TTInviteRewardsViewController" params:nil shouldCacheTarget:NO];
}

- (UIViewController *)ttDiscoverMoudle_TTFamilyShareContainViewController{
    return [self performTarget:@"TTDiscoverMoudle" action:@"TTFamilyShareContainViewController" params:nil shouldCacheTarget:NO];
}

/**
 师徒主页
 */
- (UIViewController *)ttDiscoverMoudle_TTMasterViewController{
    return [self performTarget:@"TTDiscoverMoudle" action:@"TTMasterViewController" params:nil shouldCacheTarget:NO];
}
/**
 签到
 */
- (UIViewController *)ttDiscoverMoudle_TTCheckinViewController {
    return [self performTarget:@"TTDiscoverMoudle" action:@"TTCheckinViewController" params:nil shouldCacheTarget:NO];
}

/**
 任务中心
 */
- (UIViewController *)ttDiscoverMoudle_TTMissionViewController{
    return [self performTarget:@"TTDiscoverMoudle" action:@"TTMissionViewController" params:nil shouldCacheTarget:NO];
}

@end
