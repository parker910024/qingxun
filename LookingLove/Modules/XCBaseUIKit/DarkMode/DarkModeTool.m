//
//  DarkModeTool.m
//  CatASMR
//
//  Created by ShenJun_Mac on 2020/3/16.
//  Copyright © 2020 WUJIE INTERACTIVE. All rights reserved.
//

#import "DarkModeTool.h"
#import "XCTheme.h"
#import "XCMacros.h"

API_AVAILABLE(ios(12.0))
@interface DarkModeTool()
@property (nonatomic, assign) BOOL isFlowSystem;//是否根据系统的模式（默认为Yes)
@property (nonatomic, assign) UIUserInterfaceStyle style;//当前style

@end

@implementation DarkModeTool
static NSString * const kDarkModeIsFlowSystem = @"kDarkModeIsFlowSystem";
static NSString * const kDarkMode = @"kDarkMode";

+ (instancetype)shareInstance {
    static dispatch_once_t once;
    static DarkModeTool *sharedInstance;
    dispatch_once(&once, ^{
        if (sharedInstance == NULL) {
            sharedInstance = [[self alloc] init];
            if ([[NSUserDefaults standardUserDefaults] objectForKey:kDarkModeIsFlowSystem]) {
                sharedInstance.isFlowSystem =  [[[NSUserDefaults standardUserDefaults] objectForKey:kDarkModeIsFlowSystem] boolValue];
            } else {
                [sharedInstance configFlowSystem:YES];
            }
            
            if ([[NSUserDefaults standardUserDefaults] objectForKey:kDarkMode]) {
                sharedInstance.style =  [[[NSUserDefaults standardUserDefaults] objectForKey:kDarkMode] integerValue];
                if (@available(iOS 13.0, *)) {
                    if (sharedInstance.style == UIUserInterfaceStyleDark || sharedInstance.style == UIUserInterfaceStyleLight) {
                        [sharedInstance getWindow].overrideUserInterfaceStyle = sharedInstance.style;
                        if (sharedInstance.style == UIUserInterfaceStyleDark) {
                            [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
                        } else if (sharedInstance.style == UIUserInterfaceStyleLight){
                            [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDarkContent animated:YES];
                        }
                    } else {
                        [sharedInstance getWindow].overrideUserInterfaceStyle = UIUserInterfaceStyleUnspecified;
                        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
                    }
                }
            }
            
        }
    });
    return sharedInstance;
}

#pragma mark - Public Method
//设置是否根据系统设置来调节(默认为YES)
-  (void)configFlowSystem:(BOOL)isFlow {
    self.isFlowSystem = isFlow;
    if (@available(iOS 13.0, *)) {
        if (isFlow) {
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:kDarkModeIsFlowSystem];
            [self getWindow].overrideUserInterfaceStyle = UIUserInterfaceStyleUnspecified;
            self.style = UIUserInterfaceStyleUnspecified;
            [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
            // [self getWindow].backgroundColor = [self configColorWithLight:[UIColor whiteColor] Dark:[UIColor redColor]];
        } else {
            self.style = [self getWindow].traitCollection.userInterfaceStyle;
            if (self.style == UIUserInterfaceStyleDark) {
                [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
            } else if (self.style == UIUserInterfaceStyleLight){
                [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDarkContent animated:YES];
            }
            [[NSUserDefaults standardUserDefaults] setBool:NO forKey:kDarkModeIsFlowSystem];
            [self getWindow].overrideUserInterfaceStyle = self.style;
        }
    }
}

- (BOOL)isFlowWithSystem {
    return self.isFlowSystem;
}

/// 当你需要暗黑模式 显示背景是 0x141414 。 不是暗黑模式是 白色 时
- (UIColor *)defaultBackgroundColorConfiguration {
    return [self configColorWithLight:UIColorFromRGB(0xffffff) Dark:UIColorFromRGB(0x141414)];
}

/// 当你需要暗黑模式 显示颜色是白色 alpha 透明度。 不是暗黑模式是 [XCTheme getTTMainTextColor] 时
- (UIColor *)defaultWhiteColorConfigurationWithAlpha:(CGFloat)alpha {
    return [self configColorWithLight:[XCTheme getTTMainTextColor] Dark:UIColorRGBAlpha(0xffffff, alpha)];
}

/// 当你需要暗黑模式 显示title颜色是白色 0.7 透明度。 不是暗黑模式是 [XCTheme getTTMainTextColor] 时
- (UIColor *)defaultTitleColorConfiguration {
    return [self configColorWithLight:[XCTheme getTTMainTextColor] Dark:UIColorRGBAlpha(0xffffff, 0.7)];
}

/// 当你需要暗黑模式 显示subtitle颜色是白色 0.5 透明度。 不是暗黑模式是 [XCTheme getTTDeepGrayTextColor] 时
- (UIColor *)defaultSubtitleColorConfiguration {
    return [self configColorWithLight:[XCTheme getTTDeepGrayTextColor] Dark:UIColorRGBAlpha(0xffffff, 0.5)];
}

/// 当你需要暗黑模式 显示cell的背景色是 0x141414 。 不是暗黑模式是 白色 时
- (UIColor *)defaultCellBackgroundColorConfiguration {
    return [self configColorWithLight:UIColorFromRGB(0xffffff) Dark:UIColorFromRGB(0x141414)];
}

//设置字体颜色
- (UIColor *)configColorWithLight:(UIColor *)lightColor Dark:(UIColor *)darkColor {
    if (projectType() != ProjectType_CatASMR) {
        return lightColor;
    }
    if (@available(iOS 13.0, *)) {
        UIColor *dyColor = [UIColor colorWithDynamicProvider:^UIColor * _Nonnull(UITraitCollection * _Nonnull traitCollection) {
            if (self.isFlowSystem) {
                if (traitCollection.userInterfaceStyle == UIUserInterfaceStyleLight) {
                    return lightColor;
                }else {
                    return darkColor;
                }
                
            } else {
                if (self.style == UIUserInterfaceStyleLight) {
                    return lightColor;
                }else {
                    return darkColor;
                }
            }
            
        }];
        return dyColor;
    }else{
        return lightColor;
    }
}

#pragma mark -Private Method
- (UIWindow*)getWindow {
    NSArray *windows = [UIApplication sharedApplication].windows;
    for (UIWindow *window in windows) {
        if ([window isKindOfClass:[UIWindow class]] && CGRectEqualToRect(window.bounds, [UIScreen mainScreen].bounds)) {
            return window;
        }
    }
    return [UIApplication sharedApplication].keyWindow;
}

#pragma mark - Setter && Getter
- (void)setStyle:(UIUserInterfaceStyle)style  API_AVAILABLE(ios(12.0)){
    if (style != _style) {
        _style = style;
        [[NSUserDefaults standardUserDefaults] setValue:@(style) forKey:kDarkMode];
    }
    
}
@end

