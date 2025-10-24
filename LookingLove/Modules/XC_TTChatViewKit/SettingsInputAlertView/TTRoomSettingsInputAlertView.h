//
//  TTRoomSettingsInputAlertView.h
//  TuTu
//
//  Created by lvjunhang on 2018/11/6.
//  Copyright © 2018年 YiZhuan. All rights reserved.
//  房间设置弹窗填写信息：房间名、密码等

#import <UIKit/UIKit.h>



NS_ASSUME_NONNULL_BEGIN

typedef void(^AlertViewInputCompletion)(NSString *content);
typedef void(^AlertViewCancelDismiss)(void);

@interface TTRoomSettingsInputAlertView : UIView

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
