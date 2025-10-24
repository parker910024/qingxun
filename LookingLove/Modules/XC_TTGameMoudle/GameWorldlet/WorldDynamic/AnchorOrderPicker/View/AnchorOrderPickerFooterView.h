//
//  AnchorOrderPickerFooterView.h
//  XC_TTGameMoudle
//
//  Created by lvjunhang on 2020/4/28.
//  Copyright © 2020 WUJIE INTERACTIVE. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class AnchorOrderInfo;

@interface AnchorOrderPickerFooterView : UIView
@property (nonatomic, copy) void (^doneHandler)(void);

/// 根据订单填写状态设置按钮状态
/// @param order 订单
- (void)updateButtonStatusWithOrder:(AnchorOrderInfo *)order;

@end

NS_ASSUME_NONNULL_END
