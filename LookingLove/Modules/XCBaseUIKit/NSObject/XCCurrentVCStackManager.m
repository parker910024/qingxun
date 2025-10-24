//
//  XCCurrentVCStackManager.m
//  XCBaseUIKit
//
//  Created by 卫明何 on 2018/8/9.
//  Copyright © 2018年 KevinWang. All rights reserved.
//

#import "XCCurrentVCStackManager.h"

@implementation XCCurrentVCStackManager

+ (instancetype)shareManager {
    
    static dispatch_once_t onceToken = 0;
    static id instance;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
        
    });
    
    return instance;
}

- (UIViewController *)getCurrentVC {
    
    UIViewController *rootViewController = [UIApplication sharedApplication].keyWindow.rootViewController;
    if (!rootViewController) {
        for (UIWindow *window in [UIApplication sharedApplication].windows) {
            if (window.windowLevel == 0) {
                rootViewController = window.rootViewController;
            }
        }
    }
    if ([rootViewController isKindOfClass:NSClassFromString(@"MMDrawerController")]) {
        rootViewController = (UIViewController *)[rootViewController valueForKey:@"centerViewController"];
    }
    UIViewController *currentVC = [self getCurrentVCFrom:rootViewController];
    
    return currentVC;
}

- (UIViewController *)getCurrentVCFrom:(UIViewController *)rootVC {
    
    UIViewController *currentVC;
    
    if ([rootVC presentedViewController]) {
        // 视图是被presented出来的
        rootVC = [rootVC presentedViewController];
    }
    
    if ([rootVC isKindOfClass:[UITabBarController class]]) {
        // 根视图为UITabBarController
        currentVC = [self getCurrentVCFrom:[(UITabBarController *)rootVC selectedViewController]];
        
    } else if ([rootVC isKindOfClass:[UINavigationController class]]) {
        // 根视图为UINavigationController
        currentVC = [self getCurrentVCFrom:[(UINavigationController *)rootVC visibleViewController]];
        
    } else {
        // 根视图为非导航类
        currentVC = rootVC;
    }
    
    return currentVC;
}

- (UIViewController *)currentViewController {
    
    UIWindow *keyWindow  = [UIApplication sharedApplication].keyWindow;
    UIViewController *vc = keyWindow.rootViewController;
    while (vc.presentedViewController) {
        
        vc = vc.presentedViewController;
        
        if ([vc isKindOfClass:[UINavigationController class]]) {
            
            vc = [(UINavigationController *)vc visibleViewController];
        }
        else if ([vc isKindOfClass:[UITabBarController class]]) {
            
            vc = [(UITabBarController *)vc selectedViewController];
        }
    }
    return vc;
}

- (UINavigationController *)currentNavigationController {
    return [self currentNC];
}

- (UINavigationController *)currentNC
{
    if (![[UIApplication sharedApplication].windows.lastObject isKindOfClass:[UIWindow class]]) {
        NSAssert(0, @"未获取到导航控制器");
        return nil;
    }
    UIViewController *rootViewController = [UIApplication sharedApplication].keyWindow.rootViewController;
    return [self getCurrentNCFrom:rootViewController];
}

//递归
- (UINavigationController *)getCurrentNCFrom:(UIViewController *)vc
{
    if ([vc isKindOfClass:NSClassFromString(@"MMDrawerController")]) {
        vc = (UIViewController *)[vc valueForKey:@"centerViewController"];
    }
    
    if ([vc isKindOfClass:[UITabBarController class]]) {
        UINavigationController *nc = ((UITabBarController *)vc).selectedViewController;
        return [self getCurrentNCFrom:nc];
    }
    else if ([vc isKindOfClass:[UINavigationController class]]) {
        if (((UINavigationController *)vc).presentedViewController) {
            return [self getCurrentNCFrom:((UINavigationController *)vc).presentedViewController];
        }
        return [self getCurrentNCFrom:((UINavigationController *)vc).topViewController];
    }
    else if ([vc isKindOfClass:[UIViewController class]]) {
        if (vc.presentedViewController) {
            return [self getCurrentNCFrom:vc.presentedViewController];
        }
        else {
            if (!vc.navigationController) {
                if (vc.presentingViewController) {
                    [vc dismissViewControllerAnimated:NO completion:nil];
                    
                    return [self getCurrentNCFrom:vc.presentingViewController];
                } else {
                    NSAssert(0, @"未获取到导航控制器");
                    return nil;
                }
            } else {
                return vc.navigationController;
            }
        }
    }
    else {
        NSAssert(0, @"未获取到导航控制器");
        return nil;
    }
}

@end
