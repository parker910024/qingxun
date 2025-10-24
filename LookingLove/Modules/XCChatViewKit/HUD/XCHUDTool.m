//
//  XCHUDTool.m
//  TTPlay
//
//  Created by Macx on 2019/5/15.
//  Copyright © 2019 YiZhuan. All rights reserved.
//

#import "XCHUDTool.h"
#import "XCMacros.h"
#import <MBProgressHUD/MBProgressHUD.h>

#define kDelayTime 2.5

@implementation XCHUDTool
/**
 隐藏HUD, 如果view为nil, 则默认隐藏主窗口的HUD
 
 @param view view
 */
+ (void)hideHUDInView:(nullable UIView *)view {
    if (view) {
        [MBProgressHUD hideHUDForView:view animated:NO];
        [MBProgressHUD hideHUDForView:[UIApplication sharedApplication].keyWindow animated:NO];
    } else {
        [MBProgressHUD hideHUDForView:[UIApplication sharedApplication].keyWindow animated:NO];
    }
}

/**
 隐藏HUD
 */
+ (void)hideHUD {
    [self hideHUDInView:nil];
}

/**
 显示成功message, 默认显示在窗口上, 2.5s后消失, 默认不拦截点击事件
 
 @param message 文字
 */
+ (void)showSuccessWithMessage:(NSString *)message {
    [self showSuccessWithMessage:message inView:[UIApplication sharedApplication].keyWindow];
}

/**
 显示成功message, 2.5s后消失, 默认不拦截点击事件
 
 @param message 文字
 @param view 显示在哪个view上
 */
+ (void)showSuccessWithMessage:(NSString *)message inView:(nullable UIView *)view {
    [self showSuccessWithMessage:message inView:view delay:kDelayTime enabled:NO];
}

/**
 显示成功message
 
 @param message 文字
 @param view 显示在哪个view上
 @param afterDelay 延迟消失时间
 @param enabled 是否可以拦截事件 no:不拦截 yes:拦截
 */
+ (void)showSuccessWithMessage:(NSString *)message inView:(nullable UIView *)view delay:(NSTimeInterval)afterDelay enabled:(BOOL)enabled {
    
    if (message.length == 0) { return; }
    __block UIView *inView = view;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        if (!inView) {
            inView = [UIApplication sharedApplication].keyWindow;
        }
        
        [self hideHUDInView:view]; // 先隐藏
        
        MBProgressHUD *hud = [self normalProgressHUD:view];
        hud.userInteractionEnabled = enabled;
        hud.mode = MBProgressHUDModeText;
        hud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
        hud.margin = 8;
        // 方框背景颜色
        hud.bezelView.color = [[UIColor blackColor] colorWithAlphaComponent:0.8];
        hud.label.text = message;
        hud.label.numberOfLines = 0;
        hud.label.textColor = [UIColor whiteColor];
        hud.label.font = [UIFont systemFontOfSize:14];
        [hud hideAnimated:YES afterDelay:afterDelay];
        
    });
}

/**
 显示错误message, 默认显示在窗口上, 2.5s后消失, 默认不拦截点击事件
 
 @param message 文字
 */
+ (void)showErrorWithMessage:(NSString *)message {
    [self showErrorWithMessage:message inView:[UIApplication sharedApplication].keyWindow];
}

/**
 显示错误message, 2.5s后消失, 默认不拦截点击事件
 
 @param message 文字
 @param view 显示在哪个view上
 */
+ (void)showErrorWithMessage:(NSString *)message inView:(nullable UIView *)view {
    [self showErrorWithMessage:message inView:view delay:kDelayTime enabled:NO];
}

/**
 显示错误message
 
 @param message 文字
 @param view 显示在哪个view上
 @param afterDelay 延迟消失时间
 @param enabled 是否可以拦截事件 no:不拦截 yes:拦截
 */
+ (void)showErrorWithMessage:(NSString *)message inView:(nullable UIView *)view delay:(NSTimeInterval)afterDelay enabled:(BOOL)enabled {
    if (message.length == 0) { return; }
    if (!view) {
        view = [UIApplication sharedApplication].keyWindow;
    }
    
    [self hideHUDInView:view]; // 先隐藏
    
    MBProgressHUD *hud = [self normalProgressHUD:view];
    hud.userInteractionEnabled = enabled;
    hud.mode = MBProgressHUDModeText;
    hud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
    hud.margin = 8;
    // 方框背景颜色
    hud.bezelView.color = [[UIColor blackColor] colorWithAlphaComponent:0.8];
    hud.label.text = message;
    hud.label.numberOfLines = 0;
    hud.label.textColor = [UIColor whiteColor];
    hud.label.font = [UIFont systemFontOfSize:14];
    [hud hideAnimated:YES afterDelay:afterDelay];
}

/**
 *  在窗口上显示菊花
 */
+ (void)showLoading {
    [self showLoadingInView:[UIApplication sharedApplication].keyWindow];
}

/**
 *  在view上显示菊花
 */
+ (void)showLoadingInView:(nullable UIView *)view {
    [self showLoadingInView:view enabled:YES];
}

/**
 *  在view上显示菊花
 */
+ (void)showLoadingInView:(nullable UIView *)view enabled:(BOOL)enabled {
    [self showLoadingWithMessage:@"" inView:view enabled:enabled];
}

/**
 *  在窗口上显示菊花+文字
 */
+ (void)showLoadingWithMessage:(NSString *)message {
    [self showLoadingWithMessage:message inView:[UIApplication sharedApplication].keyWindow];
}

/**
 *  在view上显示菊花+文字
 */
+ (void)showLoadingWithMessage:(NSString *)message inView:(nullable UIView *)view {
    [self showLoadingWithMessage:message inView:view enabled:YES];
}

/**
 *  在view上显示菊花+文字
 */
+ (void)showLoadingWithMessage:(NSString *)message inView:(nullable UIView *)view enabled:(BOOL)enabled {
    if (!view) {
        view = [UIApplication sharedApplication].keyWindow;
    }
    
    [self hideHUDInView:view];
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.userInteractionEnabled = enabled;
    hud.bezelView.color = [[UIColor whiteColor] colorWithAlphaComponent:0.8];
    hud.removeFromSuperViewOnHide = YES;
    if (message.length) {
        hud.label.text = message;
        hud.label.numberOfLines = 0;
        hud.label.textColor = [UIColor blackColor];
        hud.label.font = [UIFont systemFontOfSize:14];
    }
}

/**
 在窗口上显示自定义GIFLoading, 背景默认黑色0.35透明度, 默认拦截点击事件
 */
+ (void)showGIFLoading {
    [self showGIFLoadingInView:[UIApplication sharedApplication].keyWindow];
}

/**
 在指定的view上显示自定义GIFLoading, 背景默认黑色0.35透明度, 默认拦截点击事件
 
 @param view 显示在哪个view上
 */
+ (void)showGIFLoadingInView:(nullable UIView *)view {
    [self showGIFLoadingInView:view bgColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.35] enabled:YES];
}

/**
 在指定的view上显示自定义GIFLoading
 
 @param view 显示在哪个view上
 @param bgColor 背景颜色, 遮盖
 @param enabled 是否可以拦截事件 no:不拦截 yes:拦截
 */
+ (void)showGIFLoadingInView:(nullable UIView *)view bgColor:(nullable UIColor *)bgColor enabled:(BOOL)enabled {
    if (!view) {
        view = [UIApplication sharedApplication].keyWindow;
    }
    
    [self hideHUDInView:view];
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
    hud.minSize = CGSizeMake(168, 133);
    hud.userInteractionEnabled = enabled;
    hud.mode = MBProgressHUDModeCustomView;
//    hud.customView = [self gifCustomView];
    if (projectType() == ProjectType_LookingLove || projectType() == ProjectType_Planet) {
        hud.minSize = CGSizeMake(150, 150);
        [hud.bezelView addSubview:[self loadingView]];
    }else {
        hud.minSize = CGSizeMake(168, 133);
        [hud.bezelView addSubview:[self gifCustomView]];
    }
    

    hud.backgroundColor = bgColor;
    hud.bezelView.color = [UIColor clearColor];
    hud.removeFromSuperViewOnHide = YES;
}

#pragma mark - private
+ (MBProgressHUD *)normalProgressHUD:(UIView *)view {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.removeFromSuperViewOnHide = YES;
    return hud;
}

+ (UIView *)gifCustomView {
    NSArray *loadingImages = @[[UIImage imageNamed:@"loading_custom_0"],
                               [UIImage imageNamed:@"loading_custom_1"],
                               [UIImage imageNamed:@"loading_custom_2"],
                               [UIImage imageNamed:@"loading_custom_3"],
                               [UIImage imageNamed:@"loading_custom_4"],
                               [UIImage imageNamed:@"loading_custom_5"],
                               [UIImage imageNamed:@"loading_custom_6"],
                               [UIImage imageNamed:@"loading_custom_7"],
                               [UIImage imageNamed:@"loading_custom_8"],
                               [UIImage imageNamed:@"loading_custom_9"],
                               [UIImage imageNamed:@"loading_custom_10"],
                               [UIImage imageNamed:@"loading_custom_11"],
                               [UIImage imageNamed:@"loading_custom_12"],
                               [UIImage imageNamed:@"loading_custom_13"]];
    if (projectType() == ProjectType_CatASMR || projectType() == ProjectType_CatEar) {
        loadingImages = @[[UIImage imageNamed:@"loading_custom_0"],
                          [UIImage imageNamed:@"loading_custom_1"],
                          [UIImage imageNamed:@"loading_custom_2"],
                          [UIImage imageNamed:@"loading_custom_3"],
                          [UIImage imageNamed:@"loading_custom_4"],
                          [UIImage imageNamed:@"loading_custom_5"],
                          [UIImage imageNamed:@"loading_custom_6"],
                          [UIImage imageNamed:@"loading_custom_7"],
                          [UIImage imageNamed:@"loading_custom_8"],
                          [UIImage imageNamed:@"loading_custom_9"],
                          [UIImage imageNamed:@"loading_custom_10"],
                          [UIImage imageNamed:@"loading_custom_11"],
                          [UIImage imageNamed:@"loading_custom_12"],
                          [UIImage imageNamed:@"loading_custom_13"],
                          [UIImage imageNamed:@"loading_custom_14"],
                          [UIImage imageNamed:@"loading_custom_15"],
                          [UIImage imageNamed:@"loading_custom_16"],
                          [UIImage imageNamed:@"loading_custom_17"],
                          [UIImage imageNamed:@"loading_custom_18"],
                          [UIImage imageNamed:@"loading_custom_19"]];
    }
    
    UIView *loadingBGView = [[UIView alloc] init];
    loadingBGView.layer.cornerRadius = 20;
    loadingBGView.backgroundColor = [UIColor whiteColor];
    
    UIImageView *loadingImageView = [[UIImageView alloc] init];
    
    UILabel *loadingTitleLabel = [[UILabel alloc] init];
    loadingTitleLabel = [[UILabel alloc] init];
    loadingTitleLabel.textColor = [UIColor colorWithRed:(153.0)/255.0f green:(153.0)/255.0f blue:(153.0)/255.0f alpha:1];
    loadingTitleLabel.font = [UIFont systemFontOfSize:14];
    loadingTitleLabel.text = @" loading...";
    loadingTitleLabel.textAlignment = NSTextAlignmentCenter;
    
    [loadingBGView addSubview:loadingImageView];
    [loadingBGView addSubview:loadingTitleLabel];
    
    loadingBGView.frame = CGRectMake(0, 0, 168, 133);
    if (projectType() == ProjectType_CatASMR || projectType() == ProjectType_CatEar) {
        loadingImageView.frame = CGRectMake(69, 34, 30, 35);
        loadingTitleLabel.frame = CGRectMake(0, 88, loadingBGView.frame.size.width, 15);
    } else {
        loadingImageView.frame = CGRectMake(66, 18, 37, 70);
        loadingTitleLabel.frame = CGRectMake(0, 100, loadingBGView.frame.size.width, 15);
    }
    
    loadingImageView.animationImages = loadingImages;
    loadingImageView.animationDuration = 1.0;
    loadingImageView.animationRepeatCount = 0;
    [loadingImageView startAnimating];
    
    return loadingBGView;
}

+ (UIView *)loadingView {
    UIView *loadingBGView = [[UIView alloc] init];
    loadingBGView.layer.cornerRadius = 20;
    loadingBGView.backgroundColor = [UIColor whiteColor];
    
    UIImageView *loadingImageView = [[UIImageView alloc] init];
    
    UILabel *loadingTitleLabel = [[UILabel alloc] init];
    loadingTitleLabel = [[UILabel alloc] init];
    loadingTitleLabel.textColor = [UIColor colorWithRed:(153.0)/255.0f green:(153.0)/255.0f blue:(153.0)/255.0f alpha:1];
    loadingTitleLabel.font = [UIFont systemFontOfSize:14];
    loadingTitleLabel.text = @" loading...";
    loadingTitleLabel.textAlignment = NSTextAlignmentCenter;
    
    [loadingBGView addSubview:loadingImageView];
    [loadingBGView addSubview:loadingTitleLabel];
    
    loadingBGView.frame = CGRectMake(0,0,130,130);
    loadingImageView.frame = CGRectMake((CGRectGetWidth(loadingBGView.frame)-40)/ 2, (CGRectGetHeight(loadingBGView.frame) - 40 -15-15) / 2, 40, 40);
    loadingTitleLabel.frame = CGRectMake(0, CGRectGetMaxY(loadingImageView.frame) + 15, loadingBGView.frame.size.width, 15);
    
    loadingImageView.image = [UIImage imageNamed:@"loading"];
    
    CABasicAnimation * animage = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
    animage.fromValue = 0;
    animage.toValue = @(2 * M_PI);
    animage.duration = 1;
    animage.repeatCount = CGFLOAT_MAX;
    animage.autoreverses = NO;
    animage.removedOnCompletion = NO;
    [loadingImageView.layer addAnimation:animage forKey:@"animation"];
    return loadingBGView;
}



@end
