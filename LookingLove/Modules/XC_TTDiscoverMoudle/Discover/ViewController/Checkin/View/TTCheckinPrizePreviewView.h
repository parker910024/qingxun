//
//  TTCheckinPrizePreviewView.h
//  TTPlay
//
//  Created by lvjunhang on 2019/3/19.
//  Copyright © 2019 YiZhuan. All rights reserved.
//  奖励预告（二十八天的奖励排列）

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class CheckinRewardTodayNotice;

@interface TTCheckinPrizePreviewView : UIView

@property (nonatomic, strong) NSArray<CheckinRewardTodayNotice *> *dataModelArray;

@property (nonatomic, copy) void (^selectPreviewPrizeBlock)(CheckinRewardTodayNotice *prize);

/**
 是否可以补签，判断补签机会是否用完，用完则补签标记变灰色
 */
@property (nonatomic, assign) BOOL canReplenishSign;

/**
 更新数据源后刷新
 */
/**
 签到获取当天礼物刷新（因服务器接口延迟，这里手动处理
 
 @param todaySignDay 当天签到是28天中的第几天
 */
- (void)refreshViewAfterReceivePrizeForDay:(NSInteger)todaySignDay;

@end

NS_ASSUME_NONNULL_END
