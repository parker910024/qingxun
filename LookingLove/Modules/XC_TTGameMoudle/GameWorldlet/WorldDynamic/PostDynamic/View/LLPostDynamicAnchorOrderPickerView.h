//
//  LLPostDynamicAnchorOrderPickerView.h
//  XC_TTGameMoudle
//
//  Created by lvjunhang on 2020/4/28.
//  Copyright © 2020 WUJIE INTERACTIVE. All rights reserved.
//  发布动态的主播订单

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class AnchorOrderInfo;

@interface LLPostDynamicAnchorOrderPickerView : UIView
@property (nonatomic, strong, nullable) AnchorOrderInfo *selectOrder;//当前选择订单

@property (nonatomic, copy) void (^selectOrderHandler)(void);//选择订单
@end

NS_ASSUME_NONNULL_END
