//
//  XCAlertControllerCenter.h
//  XChat
//
//  Created by 卫明何 on 2017/11/6.
//  Copyright © 2017年 XC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <TYAlertController/TYAlertController.h>

@interface XCAlertControllerCenter : NSObject

@property (nonatomic, assign) CGFloat alertViewOriginY;
@property (nonatomic, assign) CGFloat alertHeight;
@property (strong, nonatomic) TYAlertController *alert;
@property (nonatomic, copy) void (^dismissComplete)(void);

+ (instancetype)defaultCenter;

/**
 在顶层控制器弹窗

 @param alertParaents 需要在哪弹，如果不传默认最上层
 @param view 需要弹出来的View
 @param dismissBlock 消失执行
 */
- (void)presentAlertWith:(UIViewController *)alertParaents view:(UIView *)view dismissBlock:(void(^)(void))dismissBlock;

/**
 在顶层控制器弹窗

 @param alertParaents 需要在哪弹，如果不传默认最上层
 @param view 需要弹出来的View
 @param preferredStyle 弹出Type
 @param dismissBlock 消失执行
 @param completionBlock 弹出完成执行
 */
- (void)presentAlertWith:(UIViewController *)alertParaents
                    view:(UIView *)view
          preferredStyle:(TYAlertControllerStyle)preferredStyle
            dismissBlock:(void (^)(void))dismissBlock
         completionBlock:(void (^)(void))completionBlock;

/**
 弹窗
 
 @param controller 在此控制器上弹窗，如果不传默认最上层
 @param view 需要弹出来的View
 @param backgroundColor 背景蒙层颜色，值为空则使用默认，只对当前弹窗有效
 @param preferredStyle 弹出Type
 @param dismissBlock 消失执行
 @param completionBlock 弹出完成执行
 */
- (void)showAlertInController:(UIViewController *)controller
                            view:(UIView *)view
                 backgroundColor:(UIColor *)backgroundColor
                  preferredStyle:(TYAlertControllerStyle)preferredStyle
                    dismissBlock:(void (^)(void))dismissBlock
                 completionBlock:(void (^)(void))completionBlock;

/**
 弹窗

 @param controller 在此控制器上弹窗，如果不传默认最上层
 @param view 需要弹出来的View
 @param backgroundColor 背景蒙层颜色，值为空则使用默认，只对当前弹窗有效
 @param backgoundTapDismissEnable 点击背景是否可消失，默认 YES
 @param preferredStyle 弹出Type
 @param dismissBlock 消失执行
 @param completionBlock 弹出完成执行
 */
- (void)showAlertInController:(UIViewController *)controller
                         view:(UIView *)view
              backgroundColor:(UIColor *)backgroundColor
    backgoundTapDismissEnable:(BOOL)backgoundTapDismissEnable
               preferredStyle:(TYAlertControllerStyle)preferredStyle
                 dismissBlock:(void (^)(void))dismissBlock
              completionBlock:(void (^)(void))completionBlock;

/**
 dissmiss 弹窗

 @param needBlock 是都需要执行block，如果是NO，那block不会执行并且清空
 */
- (void)dismissAlertNeedBlock:(BOOL)needBlock;

/**
 dismiss 弹窗

 @param needBlock 是都需要执行block，如果是NO，那block不会执行并且清空
 @param animate 消失的时候是否需要动画
 */
- (void)dismissAlertNeedBlock:(BOOL)needBlock andAnimate:(BOOL)animate;

@end
