//
//  TTAlertConfig.h
//  XC_TTChatViewKit
//
//  Created by lee on 2019/5/20.
//  Copyright © 2019 YiZhuan. All rights reserved.
//  alert 配置

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "TTAlertButtonConfig.h"
#import "TTAlertMessageAttributedConfig.h"

NS_ASSUME_NONNULL_BEGIN

@interface TTAlertConfig : NSObject

// 容器背景设置
@property (nonatomic, strong) UIColor *backgroundColor;

// 标题设置
@property (nonatomic, copy) NSString *title;
@property (nonatomic, strong) UIFont *titleFont;
@property (nonatomic, strong) UIColor *titleColor;

// 内容设置
@property (nonatomic, copy) NSString *message;
@property (nonatomic, strong) UIFont *messageFont;
@property (nonatomic, strong) UIColor *messageColor;
/** 内容的行间距，默认不设置，当值为 0 或负数时无效 */
@property (nonatomic, assign) CGFloat messageLineSpacing;
/** 内容富文本配置 */
@property (nonatomic, strong) NSArray<TTAlertMessageAttributedConfig *> *messageAttributedConfig;

// 取消按钮配置
@property (nonatomic, strong) TTAlertButtonConfig *cancelButtonConfig;

// 确定按钮配置
@property (nonatomic, strong) TTAlertButtonConfig *confirmButtonConfig;

/**
 背景蒙层的透明度
 @Description 默认是 000000 黑色 0.3 alpha
 */
@property (nonatomic, assign) CGFloat maskBackgroundAlpha;

// 圆角
@property (nonatomic, assign) CGFloat cornerRadius;

// 点击蒙层是否消失，默认：YES
@property (nonatomic, assign) BOOL shouldDismissOnBackgroundTouch;

/**
 点击‘确定’‘取消’按钮时禁止弹窗自动消失，默认：NO
 
 @discussion 若值为 YES，需要主动调用 [TTPopup dismiss] 消除弹窗
 */
@property (nonatomic, assign) BOOL disableAutoDismissWhenClickButton;

/**
 重复弹窗过滤，默认：NO
 
 @discussion 设置过滤时，队列中将不会出现相同过滤标识的弹窗
 过滤标识通过 #<filterIdentifier> 设置
 */
@property (nonatomic, assign) BOOL shouldFilterPopup;

/**
 过滤标识，默认：nil
 */
@property (nonatomic, copy) NSString *filterIdentifier;

@end

NS_ASSUME_NONNULL_END
