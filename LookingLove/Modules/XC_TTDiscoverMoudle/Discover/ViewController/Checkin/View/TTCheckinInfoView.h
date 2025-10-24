//
//  TTCheckinInfoView.h
//  TTPlay
//
//  Created by lvjunhang on 2019/3/19.
//  Copyright © 2019 YiZhuan. All rights reserved.
//  签到信息（当前奖池累计金币、签到功能等）

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class CheckinSignDetail;
@class CheckinSign;

@interface TTCheckinInfoView : UIView
@property (nonatomic, strong) CheckinSignDetail *signDetail;//签到状态详情

@property (nonatomic, strong) UIButton *checkinButton;//签到按钮

@property (nonatomic, copy) void (^signActionBlock)(void);//签到
@property (nonatomic, copy) void (^partitionCoinActionBlock)(void);//瓜分金币

/**
 增加金币个数
 
 @param coinNum 金币个数
 */
- (void)appendCoin:(NSInteger)coinNum;

@end

NS_ASSUME_NONNULL_END
