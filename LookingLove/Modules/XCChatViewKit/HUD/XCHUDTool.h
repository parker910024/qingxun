//
//  XCHUDTool.h
//  TTPlay
//
//  Created by Macx on 2019/5/15.
//  Copyright © 2019 YiZhuan. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/**
 showGIFLoading使用注意:
 1.谁负责showLoading, 谁负责hideHUD
 2.showLoading是指定了加载在那个View, hideHUD时请指定hide那个view的hud
 */

@interface XCHUDTool : NSObject
/**
 隐藏HUD
 */
+ (void)hideHUD;

/**
 隐藏HUD, 如果view为nil, 则默认隐藏主窗口的HUD
 
 @param view view
 */
+ (void)hideHUDInView:(nullable UIView *)view;

/**
 显示成功message, 默认显示在窗口上, 2.5s后消失, 默认不拦截点击事件
 
 @param message 文字
 */
+ (void)showSuccessWithMessage:(NSString *)message;

/**
 显示成功message, 2.5s后消失, 默认不拦截点击事件
 
 @param message 文字
 @param view 显示在哪个view上
 */
+ (void)showSuccessWithMessage:(NSString *)message inView:(nullable UIView *)view;

/**
 显示成功message
 
 @param message 文字
 @param view 显示在哪个view上
 @param afterDelay 延迟消失时间
 @param enabled 是否可以拦截事件 no:不拦截 yes:拦截
 */
+ (void)showSuccessWithMessage:(NSString *)message inView:(nullable UIView *)view delay:(NSTimeInterval)afterDelay enabled:(BOOL)enabled;

/**
 显示错误message, 默认显示在窗口上, 2.5s后消失, 默认不拦截点击事件
 
 @param message 文字
 */
+ (void)showErrorWithMessage:(NSString *)message;

/**
 显示错误message, 2.5s后消失, 默认不拦截点击事件
 
 @param message 文字
 @param view 显示在哪个view上
 */
+ (void)showErrorWithMessage:(NSString *)message inView:(nullable UIView *)view;

/**
 显示错误message
 
 @param message 文字
 @param view 显示在哪个view上
 @param afterDelay 延迟消失时间
 @param enabled 是否可以拦截事件 no:不拦截 yes:拦截
 */
+ (void)showErrorWithMessage:(NSString *)message inView:(nullable UIView *)view delay:(NSTimeInterval)afterDelay enabled:(BOOL)enabled;

/**
 在窗口上显示自定义GIFLoading, 背景默认黑色0.35透明度, 默认拦截点击事件
 */
+ (void)showGIFLoading;

/**
 在指定的view上显示自定义GIFLoading, 背景默认黑色0.35透明度, 默认拦截点击事件
 
 @param view 显示在哪个view上
 */
+ (void)showGIFLoadingInView:(nullable UIView *)view;

/**
 在指定的view上显示自定义GIFLoading
 
 @param view 显示在哪个view上
 @param bgColor 背景颜色, 遮盖
 @param enabled 是否可以拦截事件 no:不拦截 yes:拦截
 */
+ (void)showGIFLoadingInView:(nullable UIView *)view bgColor:(nullable UIColor *)bgColor enabled:(BOOL)enabled;

/**
 在窗口上显示菊花
 */
+ (void)showLoading;

/**
 在view上显示菊花
 */
+ (void)showLoadingInView:(nullable UIView *)view;

/**
 在view上显示菊花
 */
+ (void)showLoadingInView:(nullable UIView *)view enabled:(BOOL)enabled;

/**
 在窗口上显示菊花+文字
 */
+ (void)showLoadingWithMessage:(NSString *)message;

/**
 在view上显示菊花+文字
 */
+ (void)showLoadingWithMessage:(NSString *)message inView:(nullable UIView *)view;

/**
 在view上显示菊花+文字
 */
+ (void)showLoadingWithMessage:(NSString *)message inView:(nullable UIView *)view enabled:(BOOL)enabled;
@end

NS_ASSUME_NONNULL_END
