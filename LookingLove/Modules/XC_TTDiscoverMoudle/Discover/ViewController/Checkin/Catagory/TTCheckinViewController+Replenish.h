//
//  TTCheckinViewController+Replenish.h
//  XC_TTDiscoverMoudle
//
//  Created by lvjunhang on 2019/5/9.
//  Copyright © 2019 fengshuo. All rights reserved.
//  补签

#import "TTCheckinViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface TTCheckinViewController (Replenish)

/**
 补签
 
 @param signDay 第几天补签
 */
- (void)replenishWithSignDay:(NSUInteger)signDay;

//显示分享获取补签弹窗
- (void)showShareGetReplenishChanceAlert;

/**
 显示支付萝卜获取补签弹窗
 
 @param radishNum 萝卜数量
 */
- (void)showPayRadishGetReplenishChanceAlertWithRadish:(NSInteger)radishNum;

/**
 显示萝卜余额不足弹窗
 */
- (void)showNoEnoughRadishBalanceAlert;

/**
 显示补签成功弹窗
 
 @param rewardName 补签获得奖励
 */
- (void)showReplenishSuccessAlertWithReward:(NSString *)rewardName;

@end

NS_ASSUME_NONNULL_END
