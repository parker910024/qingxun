//
//  XCMediator+TTHomeMoudle.m
//  TuTu
//
//  Created by Macx on 2018/10/29.
//  Copyright © 2018 YiZhuan. All rights reserved.
//

#import "XCMediator+TTHomeMoudle.h"

@implementation XCMediator (TTHomeMoudle)
/**
 首页控制器
 */
- (UIViewController *)ttHomeMoudle_homeContainerViewController {
    return [self performTarget:@"TTHomeMoudle" action:@"TTHomeViewController" params:nil shouldCacheTarget:YES];
}

/**
 家族控制器
 */
- (UIViewController *)ttHomeMoudle_familyViewController {
    return [self performTarget:@"TTHomeMoudle" action:@"TTHomeFamilyViewController" params:nil shouldCacheTarget:YES];
}

/**
 搜索控制器
 */
- (UIViewController *)ttHomeMoudleBridge_searchRoomController:(BOOL)isPresent block:(id)block {
    NSDictionary *params = @{@"isPresent" : @(isPresent), @"block" : block};
    return [self performTarget:@"TTHomeMoudle" action:@"TTSearchRoomViewController" params:params shouldCacheTarget:YES];
}

// modal出搜索控制器, 点击cell时dismissBlock回调 dismissBlock:typedef void(^DismissAndDidClickPersonBlcok)(long long uid);
- (UIViewController *)ttHomeMoudleBridge_modalSearchRoomControllerWithBlock:(id)dismissBlock {
    NSDictionary *params = @{@"dismissBlock" : dismissBlock};
    return [self performTarget:@"TTHomeMoudle" action:@"TTSearchRoomViewController" params:params shouldCacheTarget:YES];
}

// modal出搜索控制器,包含历史搜索记录和进房记录, 点击cell时dismissBlock回调 dismissBlock:typedef void(^DismissAndDidClickPersonBlcok)(long long uid);
- (UIViewController *)ttHomeMoudleBridge_modalRecordSearchRoomControllerWithBlock:(id)dismissBlock {
    NSDictionary *params = @{@"dismissBlock" : dismissBlock,
                             @"showHistoryRecord" : @(1)};
    return [self performTarget:@"TTHomeMoudle" action:@"TTSearchRoomViewController" params:params shouldCacheTarget:YES];
}

// modal出搜索控制器，包含历史搜索记录和进房记录，包含进房回调
- (UIViewController *)ttHomeMoudleBridge_modalRecordSearchRoomControllerWithDismissHandler:(void(^)(long long uid))dismissHandler enterRoomHandler:(void(^)(long long roomUid))enterRoomHandler {
    NSDictionary *params = @{@"dismissBlock" : dismissHandler,
                             @"enterRoomBlock" : enterRoomHandler,
                             @"showHistoryRecord" : @(1)};
    return [self performTarget:@"TTHomeMoudle" action:@"TTSearchRoomViewController" params:params shouldCacheTarget:YES];
}

// 模厅邀请用户
- (UIViewController *)ttHomeMoudleBridge_inviteSearchRoomController {
    NSDictionary *params = @{@"isInvite" : @(1)};
    return [self performTarget:@"TTHomeMoudle" action:@"TTSearchRoomViewController" params:params shouldCacheTarget:YES];
}

// 是否是模厅内部搜索
- (UIViewController *)ttHomeMoudleBridge_hallSearchSearchRoomController {
    NSDictionary *params = @{@"isHallSearch" : @(1)};
    return [self performTarget:@"TTHomeMoudle" action:@"TTSearchRoomViewController" params:params shouldCacheTarget:YES];
}
@end
