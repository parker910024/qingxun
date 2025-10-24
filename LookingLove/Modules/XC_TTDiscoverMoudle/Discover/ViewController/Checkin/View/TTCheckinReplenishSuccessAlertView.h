//
//  TTCheckinReplenishSuccessAlertView.h
//  XC_TTDiscoverMoudle
//
//  Created by lvjunhang on 2019/5/8.
//  Copyright © 2019 fengshuo. All rights reserved.
//  补签成功弹窗

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TTCheckinReplenishSuccessAlertView : UIView

@property (nonatomic, copy) void(^sureBlock)(void);

/**
 设置礼物

 @param rewardName 奖品名称
 */
- (void)configRerard:(NSString *)rewardName;

@end

NS_ASSUME_NONNULL_END
