//
//  UIView+Gradient.h
//  XCCategrayKit
//
//  Created by KevinWang on 2019/4/15.
//  Copyright © 2019 WuJieHuDong. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIView (Gradient)

@property (nonatomic, strong) NSArray *xc_colors;
@property (nonatomic, strong) NSArray<NSNumber *> *xc_locations;

@property (nonatomic, assign) CGPoint xc_startPoint;
@property (nonatomic, assign) CGPoint xc_endPoint;



+ (UIView *_Nullable)xc_gradientViewWithColors:(NSArray<UIColor *> *_Nullable)colors locations:(NSArray<NSNumber *> *_Nullable)locations startPoint:(CGPoint)startPoint endPoint:(CGPoint)endPoint;

- (void)xc_setGradientBackgroundWithColors:(NSArray<UIColor *> *_Nullable)colors locations:(NSArray<NSNumber *> *_Nullable)locations startPoint:(CGPoint)startPoint endPoint:(CGPoint)endPoint;

- (void)setGradientLayer:(UIColor*)startColor endColor:(UIColor*)endColor;

// 左右渐变
- (void)setLeftAndRightGradientLayer:(UIColor*)startColor endColor:(UIColor*)endColor;

@end

NS_ASSUME_NONNULL_END
