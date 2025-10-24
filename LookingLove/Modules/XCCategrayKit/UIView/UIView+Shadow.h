//
//  UIView+Shadow.h
//  XCCategrayKit
//
//  Created by lvjunhang on 2019/4/25.
//  Copyright © 2019 WuJieHuDong. All rights reserved.
//  阴影、圆角设置

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIView (Shadow)

/*
 视图添加阴影、圆角
 */
+ (void)xc_addShadowToView:(UIView *)view
             shadowOpacity:(float)shadowOpacity
               shadowColor:(UIColor *)shadowColor
              shadowRadius:(CGFloat)shadowRadius
              cornerRadius:(CGFloat)cornerRadius
               borderWidth:(CGFloat)borderWidth
               borderColor:(UIColor *)borderColor;

@end

NS_ASSUME_NONNULL_END
