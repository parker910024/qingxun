//
//  XCAlertControllerCenter.m
//  XChat
//
//  Created by 卫明何 on 2017/11/6.
//  Copyright © 2017年 XC. All rights reserved.
//

#import "XCAlertControllerCenter.h"
#import "XCCurrentVCStackManager.h"
#import "XCMacros.h"


@implementation XCAlertControllerCenter


+ (instancetype)defaultCenter
{
    static dispatch_once_t onceToken = 0;
    static id instance;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
        
    });
    
    return instance;
}

- (void)presentAlertWith:(UIViewController *)alertParaents view:(UIView *)view dismissBlock:(void (^)(void))dismissBlock {
    
    [self presentAlertWith:alertParaents view:view preferredStyle:(TYAlertControllerStyle)TYAlertControllerStyleAlert dismissBlock:dismissBlock completionBlock:nil];
}

- (void)presentAlertWith:(UIViewController *)alertParaents view:(UIView *)view preferredStyle:(TYAlertControllerStyle)preferredStyle dismissBlock:(void (^)(void))dismissBlock completionBlock:(void (^)(void))completionBlock{
    
    [self showAlertInController:alertParaents
                              view:view
                   backgroundColor:nil
                    preferredStyle:preferredStyle
                      dismissBlock:dismissBlock
                   completionBlock:completionBlock];
}

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
                 completionBlock:(void (^)(void))completionBlock {

    [self showAlertInController:controller
                           view:view
                backgroundColor:backgroundColor
      backgoundTapDismissEnable:YES
                 preferredStyle:preferredStyle
                   dismissBlock:dismissBlock
                completionBlock:completionBlock];
}

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
              completionBlock:(void (^)(void))completionBlock {

    if (self.alert) {
        [self.alert dismissViewControllerAnimated:NO];
        self.alert = nil;
    }

    self.alert = [TYAlertController alertControllerWithAlertView:view preferredStyle:preferredStyle transitionAnimation:TYAlertTransitionAnimationFade];
    self.alert.backgoundTapDismissEnable = backgoundTapDismissEnable;

    if (self.alertViewOriginY > 0) {
        self.alert.alertViewOriginY = self.alertViewOriginY;
    }

    if (backgroundColor && [backgroundColor isKindOfClass:UIColor.class]) {
        self.alert.backgroundColor = backgroundColor;
    }

    @KWeakify(self);
    [self.alert setDismissComplete:^{
        @KStrongify(self);
        if (dismissBlock) {
            dismissBlock();
        }
        self.alert = nil;
        self.alertViewOriginY = 0;
    }];

    if (controller == nil) {
        controller = [[XCCurrentVCStackManager shareManager] getCurrentVC];
    }

    [controller presentViewController:self.alert animated:YES completion:completionBlock];
}


- (void)dismissAlertNeedBlock:(BOOL)needBlock {
    
    [self dismissAlertNeedBlock:needBlock andAnimate:YES];

}

- (void)dismissAlertNeedBlock:(BOOL)needBlock andAnimate:(BOOL)animate {
    @KWeakify(self);
    self.alertViewOriginY = 0;
    [self.alert setDismissComplete:^{
        @KStrongify(self);
        self.alert = nil;
        if (needBlock && self.dismissComplete) {
            self.dismissComplete();
        }else {
            self.dismissComplete = nil;
        }
        
    }];
    if (self.alert) {
        [self.alert dismissViewControllerAnimated:YES];
    }else {
        if ([[[XCCurrentVCStackManager shareManager]getCurrentVC] isKindOfClass:[TYAlertController class]]) {
            TYAlertController *alert = (TYAlertController *)[[XCCurrentVCStackManager shareManager] getCurrentVC];
            [alert dismissViewControllerAnimated:animate completion:self.dismissComplete];
        }
    }
}






@end
