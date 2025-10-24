//
//  WBMakeNameplateView.h
//  WanBan
//
//  Created by HUA on 2020/9/5.
//  Copyright © 2020 WUJIE INTERACTIVE. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef void(^AlertViewInputCompletion)(NSString *content);
typedef void(^AlertViewCancelDismiss)(void);

@interface WBMakeNameplateAlertView : UIView

/**
 标题
 */
@property (nonatomic, copy) NSString *title;

/**
 原内容
 */
@property (nonatomic, copy) NSString *content;

/**
 输入框提示占位字符
 */
@property (nonatomic, copy) NSString *placeholder;

/**
 最大文字个数，默认 0，无限制
 */
@property (nonatomic, assign) NSUInteger maxCount;

/**
 最小文字个数，默认 0
 */
@property (nonatomic, assign) NSUInteger minCount;

/**
 铭牌url
 */
@property (nonatomic, copy) NSString *url;

/**
 键盘类型，默认 UIKeyboardTypeDefault
 */
@property (nonatomic, assign) UIKeyboardType keyboardType;

/**
 显示 alert 输入框

 @param completion 输入完成回调
 @param dismiss 弹窗消失回调（包括点击背景取消和点击取消按钮）
 */
- (void)showAlertWithCompletion:(AlertViewInputCompletion)completion dismiss:(AlertViewCancelDismiss)dismiss;


@end

NS_ASSUME_NONNULL_END
