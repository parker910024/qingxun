//
//  Target_TTGameModule.m
//  TTPlay
//
//  Created by new on 2019/3/27.
//  Copyright © 2019 YiZhuan. All rights reserved.
//

#import "Target_TTGameModule.h"
#import "TTGameViewController.h"
#import "TTCompleteGameListViewController.h"
#import "TTGameFindFriendViewController.h"
#import "TTGameMatchingViewController.h"
#import "TTWkGameViewController.h"
#import "TTVoiceMyViewController.h"
#import "TTVoiceMatchingViewController.h"
#import "TTVoiceRecordViewController.h"
#import "CPGameListModel.h"
#import "TTWorldSquareViewController.h"
#import "TTWorldletContainerViewController.h"
#import "LLGameHomeContainerViewController.h"
#import "LLPostDynamicViewController.h"
#import "LLDynamicDetailController.h"

#import "XCMacros.h"

@implementation Target_TTGameModule

/** 跳转到游戏新首页(主页) */
- (UIViewController *)Action_TTNewGameHomeViewController {
    return [[LLGameHomeContainerViewController alloc] init];
}

/** 跳转到游戏首页*/
- (UIViewController *)Action_TTGameViewController{
    TTGameViewController *gameMainVC = [[TTGameViewController alloc] init];
    return gameMainVC;
}

- (UIViewController *)Action_TTCompleteGameListViewController{
    TTCompleteGameListViewController *completeVC = [[TTCompleteGameListViewController alloc] init];
    return completeVC;
}

- (UIViewController *)Action_TTGameFindFriendViewController{
    TTGameFindFriendViewController *friendFindVC = [[TTGameFindFriendViewController alloc] init];
    return friendFindVC;
}

- (UIViewController *)Action_TTGameMatchingViewController:(NSDictionary *)dict {
    TTGameMatchingViewController *matchVC = [[TTGameMatchingViewController alloc] init];
    matchVC.model = [CPGameListModel modelDictionary:dict[@"model"]];
    matchVC.hiddenNavBar = dict[@"hiddenNavBar"];
    return matchVC;
}

/** 跳转到游戏页*/
- (UIViewController *)Action_TTWkGameViewController:(NSDictionary *)dict{
    TTWkGameViewController *gameVC = [[TTWkGameViewController alloc] init];
    gameVC.gameUrlString = dict[@"gameUrlString"];
    gameVC.watching = [dict[@"watching"] boolValue];
    gameVC.superviewType = dict[@"superviewType"];
    gameVC.clickButton = dict[@"block"];
    return gameVC;
}

/** 跳转到我的声音 */
- (UIViewController *)Action_TTVoiceMyViewController {
    TTVoiceMyViewController *myVC = [[TTVoiceMyViewController alloc] init];
    return myVC;
}

/** 跳转到声音匹配 */
- (UIViewController *)Action_TTVoiceMatchingViewController {
    TTVoiceMatchingViewController *voiceVC = [[TTVoiceMatchingViewController alloc] init];
    return voiceVC;
}

/** 跳转到录音界面*/
- (UIViewController *)Action_TTVoiceRecordViewController {
    TTVoiceRecordViewController *voiceVC = [[TTVoiceRecordViewController alloc] init];
    return voiceVC;
}

/** 跳转小世界 */
- (UIViewController *)Action_TTWorldSquareViewController {
    TTWorldSquareViewController *vc = [[TTWorldSquareViewController alloc] init];
    return vc;
}

/** 跳转小世界客态页 */
- (UIViewController *)Action_TTWorldletContainerViewController:(NSDictionary *)dict {
    TTWorldletContainerViewController *VC = [[TTWorldletContainerViewController alloc] init];
    VC.worldId = dict[@"worldId"];
    VC.isFromRoom = [dict[@"isFromRoom"] boolValue];
    return VC;
}
/// 跳转小世界动态详情
/// @param dict 参数
- (UIViewController *)Action_LLDynamicDetailViewController:(NSDictionary *)dict {
    LLDynamicDetailController *vc = [[LLDynamicDetailController alloc] init];
    vc.dynamicId = [dict[@"dynamicID"] integerValue];
    vc.worldId = dict[@"worldID"];
    vc.isShowKeyboard = [dict[@"comment"] boolValue];
    id block = [dict objectForKey:@"dynamicChangeCallBack"];
    if (block) {
        vc.dynamicChangeCallBack = [block copy];
    }
    return vc;
}

/// 动态广场发布
/// @param params @"refreshDynamicBlock"回调
- (UIViewController *)Action_LLPostDynamicViewController:(NSDictionary *)params {
    LLPostDynamicViewController *vc = [[LLPostDynamicViewController alloc] init];
    id block = [params objectForKey:@"refreshDynamicBlock"];
    if (block) {
        vc.refreshDynamicBlock = [block copy];
    }
    return vc;
}

@end
