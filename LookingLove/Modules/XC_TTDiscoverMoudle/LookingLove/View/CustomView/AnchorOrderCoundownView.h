//
//  AnchorOrderCoundownView.h
//  XC_TTGameMoudle
//
//  Created by lvjunhang on 2020/5/10.
//  Copyright © 2020 WUJIE INTERACTIVE. All rights reserved.
//  主播订单倒计时

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class AnchorOrderInfo;

@interface AnchorOrderCoundownView : UIControl

@property (nonatomic, strong) AnchorOrderInfo *order;

/// 点击交互
/// @param handler 点击回调
- (void)tapOrderHandler:(void(^)(void))handler;

/// 点击问号交互（调用此方法才显示问号）
/// @param handler 点击回调
- (void)tapMarkHandler:(void(^)(void))handler;

@end

NS_ASSUME_NONNULL_END
