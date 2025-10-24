//
//  TTCheckinAccumulatePrizeView.h
//  TTPlay
//
//  Created by lvjunhang on 2019/3/19.
//  Copyright © 2019 YiZhuan. All rights reserved.
//  累积签到奖励（7天、14天、21天、28天）

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class CheckinRewardTotalNotice;
@class CheckinSignDetail;

@interface TTCheckinAccumulatePrizeView : UIView
@property (nonatomic, strong) NSArray<CheckinRewardTotalNotice *> *modelArray;

@property (nonatomic, strong) CheckinSignDetail *signDetail;

@property (nonatomic, copy) void (^selectPrizeBlock)(CheckinRewardTotalNotice *prize);//领取对应奖励
@property (nonatomic, copy) void (^drawCoinBlock)(void);//瓜分金币(签到满28天）

@end

NS_ASSUME_NONNULL_END
