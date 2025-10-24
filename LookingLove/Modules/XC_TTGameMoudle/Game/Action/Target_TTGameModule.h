//
//  Target_TTGameModule.h
//  TTPlay
//
//  Created by new on 2019/3/27.
//  Copyright © 2019 YiZhuan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Target_TTGameModule : NSObject
/** 跳转到游戏新首页(主页) */
- (UIViewController *)Action_TTNewGameHomeViewController;

/** 跳转到游戏首页*/
- (UIViewController *)Action_TTGameViewController;

/** 跳转到全部游戏*/
- (UIViewController *)Action_TTCompleteGameListViewController;

/** 跳转到找玩友*/
- (UIViewController *)Action_TTGameFindFriendViewController;

/**
 跳转到匹配控制器
 */
- (UIViewController *)Action_TTGameMatchingViewController:(NSDictionary *)dict;

/** 跳转到游戏页*/
- (UIViewController *)Action_TTWkGameViewController:(NSDictionary *)dict;

/** 跳转到我的声音 */
- (UIViewController *)Action_TTVoiceMyViewController;

/** 跳转到声音匹配 */
- (UIViewController *)Action_TTVoiceMatchingViewController;

/** 跳转到录音界面*/
- (UIViewController *)Action_TTVoiceRecordViewController;

/** 跳转小世界 */
- (UIViewController *)Action_TTWorldSquareViewController;

/** 跳转小世界客态页 */
- (UIViewController *)Action_TTWorldletContainerViewController:(NSDictionary *)dict;

/// 跳转小世界动态详情
/// @param dict 参数
- (UIViewController *)Action_LLDynamicDetailViewController:(NSDictionary *)dict;

/// 动态广场发布
/// @param params @"refreshDynamicBlock"回调
- (UIViewController *)Action_LLPostDynamicViewController:(NSDictionary *)params;

@end

NS_ASSUME_NONNULL_END
