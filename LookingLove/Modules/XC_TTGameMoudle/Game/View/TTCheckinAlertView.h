//
//  TTCheckinAlertView.h
//  TTPlay
//
//  Created by lvjunhang on 2019/3/22.
//  Copyright © 2019 YiZhuan. All rights reserved.
//  首页签到弹窗

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^DismissBlock)(void);//取消9
typedef void(^CheckinBlock)(void);//签到
typedef void(^BonusBlock)(void);//奖池

@class CheckinSignDetail;

@interface TTCheckinAlertView : UIView

@property (nonatomic, copy) DismissBlock dismissBlock;
@property (nonatomic, copy) CheckinBlock checkinBlock;
@property (nonatomic, copy) BonusBlock bonusBlock;

@property (nonatomic, strong) CheckinSignDetail *signDetail;//签到状态详情

@property (nonatomic, strong) UIButton *checkinButton;//签到

/**
 添加金币
 
 @param coinNumber 金币数量
 */
- (void)addCoin:(NSUInteger)coinNumber;

@end

NS_ASSUME_NONNULL_END
