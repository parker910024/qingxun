//
//  TTMasterTaskSuccessView.h
//  TTPlay
//
//  Created by Macx on 2019/1/21.
//  Copyright © 2019 YiZhuan. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class TTMasterTaskSuccessView;
@protocol TTMasterTaskSuccessViewDelegate <NSObject>
@optional;
/** 点击了灰色背景 - 消失close */
- (void)masterTaskSuccessView:(TTMasterTaskSuccessView *)view didClickCloseButton:(UIView *)closeView;
@end

@interface TTMasterTaskSuccessView : UIView
/** 代理 */
@property (nonatomic, weak) id<TTMasterTaskSuccessViewDelegate> delegate;
@end

NS_ASSUME_NONNULL_END
