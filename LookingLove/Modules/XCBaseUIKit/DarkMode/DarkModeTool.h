//
//  DarkModeTool.h
//  CatASMR
//
//  Created by ShenJun_Mac on 2020/3/16.
//  Copyright © 2020 WUJIE INTERACTIVE. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface DarkModeTool : NSObject
//单例
+ (instancetype)shareInstance;
//设置是否根据系统设置来调节(默认为YES)
-  (void)configFlowSystem:(BOOL)isFlow;
//获取是否根据系统的设置(默认为YES)
- (BOOL)isFlowWithSystem;

/// 当你需要暗黑模式 显示背景是 0x141414 。 不是暗黑模式是 白色 时
- (UIColor *)defaultBackgroundColorConfiguration;

/// 当你需要暗黑模式 显示颜色是白色 alpha 透明度。 不是暗黑模式是 [XCTheme getTTMainTextColor] 时 
- (UIColor *)defaultWhiteColorConfigurationWithAlpha:(CGFloat)alpha;

/// 当你需要暗黑模式 显示title颜色是白色 0.7 透明度。 不是暗黑模式是 [XCTheme getTTMainTextColor] 时 
- (UIColor *)defaultTitleColorConfiguration;

/// 当你需要暗黑模式 显示subtitle颜色是白色 0.5 透明度。 不是暗黑模式是 [XCTheme getTTDeepGrayTextColor] 时
- (UIColor *)defaultSubtitleColorConfiguration;

/// 当你需要暗黑模式 显示cell的背景色是 0x141414。 不是暗黑模式是 白色 时
- (UIColor *)defaultCellBackgroundColorConfiguration;

//设置自定义颜色
- (UIColor *)configColorWithLight:(UIColor *)lightColor Dark:(UIColor *)darkColor;

@end

NS_ASSUME_NONNULL_END
