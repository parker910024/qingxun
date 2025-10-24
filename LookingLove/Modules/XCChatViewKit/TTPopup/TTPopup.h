//
//  TTPopup.h
//  XC_TTChatViewKit
//
//  Created by lvjunhang on 2019/5/22.
//  Copyright © 2019 YiZhuan. All rights reserved.
//  弹窗工具类

#import <Foundation/Foundation.h>
#import "TTPopupConstants.h"
#import "TTAlertConfig.h"
#import "TTActionSheetConfig.h"
#import "TTPopupService.h"

NS_ASSUME_NONNULL_BEGIN

@class UIView;

@interface TTPopup : NSObject

#pragma mark Alert
/**
 显示 alert 弹窗

 @discussion 显示四个内容：默认标题‘提示’，提示内容，取消按钮，确认按钮
 
 @param message 提示内容，不能为空(⊙o⊙)哦
 @param confirmHandler 确认操作
 @param cancelHandler 取消操作
 */
+ (void)alertWithMessage:(NSString *)message
           confirmHandler:(TTPopupCompletionHandler)confirmHandler
            cancelHandler:(TTPopupCompletionHandler)cancelHandler;

/**
 显示 alert 弹窗
 
 @discussion 显示四个内容：标题，提示内容，取消按钮，确认按钮
 
 @param config 完善的视图配置，为您变态的需求保驾护航
 @param cancelHandler 取消操作
 @param confirmHandler 确认操作
 */
+ (void)alertWithConfig:(TTAlertConfig *)config
          confirmHandler:(TTPopupCompletionHandler)confirmHandler
           cancelHandler:(TTPopupCompletionHandler)cancelHandler;

#pragma mark Action Sheet
/**
 显示 action sheet 弹窗，自带贴心的取消按钮😊

 @param items 配置列表
 */
+ (void)actionSheetWithItems:(NSArray<TTActionSheetConfig *> *)items;

/**
 显示 action sheet 弹窗

 @param items 配置列表
 @param showCancelItem 是否显示取消按钮
 */
+ (void)actionSheetWithItems:(NSArray<TTActionSheetConfig *> *)items
              showCancelItem:(BOOL)showCancelItem;

/**
 显示 action sheet 弹窗

 @param items 配置列表
 @param cancelHandler 取消按钮回调
 */
+ (void)actionSheetWithItems:(NSArray<TTActionSheetConfig *> *)items
                cancelHandler:(TTActionSheetClickAction)cancelHandler;

#pragma mark Popup
/**
 显示自定义弹窗

 @param customView 自定义 view
 @param style 弹窗样式
 */
+ (void)popupView:(UIView *)customView
            style:(TTPopupStyle)style;

/**
 显示自定义弹窗

 @param config 自定义弹窗配置
 */
+ (void)popupWithConfig:(TTPopupService *)config;

#pragma mark Dismiss
/**
 消除当前弹窗
 */
+ (void)dismiss;

#pragma mark Query
/**
 当前是否有显示弹窗
 */
+ (BOOL)hasShowPopup;

@end

NS_ASSUME_NONNULL_END
