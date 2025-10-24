//
//  UIView+Gradient.m
//  XCCategrayKit
//
//  Created by KevinWang on 2019/4/15.
//  Copyright © 2019 WuJieHuDong. All rights reserved.
//

#import "UIView+Gradient.h"
#import <objc/runtime.h>

@implementation UIView (Gradient)

+ (Class)layerClass {
    return [CAGradientLayer class];
}

+ (UIView *)xc_gradientViewWithColors:(NSArray<UIColor *> *)colors locations:(NSArray<NSNumber *> *)locations startPoint:(CGPoint)startPoint endPoint:(CGPoint)endPoint {
    UIView *view = [[self alloc] init];
    [view xc_setGradientBackgroundWithColors:colors locations:locations startPoint:startPoint endPoint:endPoint];
    return view;
}

- (void)xc_setGradientBackgroundWithColors:(NSArray<UIColor *> *)colors locations:(NSArray<NSNumber *> *)locations startPoint:(CGPoint)startPoint endPoint:(CGPoint)endPoint {
    NSMutableArray *colorsM = [NSMutableArray array];
    for (UIColor *color in colors) {
        [colorsM addObject:(__bridge id)color.CGColor];
    }
    self.xc_colors = [colorsM copy];
    self.xc_locations = locations;
    self.xc_startPoint = startPoint;
    self.xc_endPoint = endPoint;
}


- (void)setGradientLayer:(UIColor*)startColor endColor:(UIColor*)endColor{
    //初始化CAGradientlayer对象，使它的大小为UIView的大小
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.frame = self.bounds;
    
    [self.layer addSublayer:gradientLayer];
    
    gradientLayer.startPoint = CGPointMake(0, 0);
    gradientLayer.endPoint = CGPointMake(1, 0);
    
    //设置颜色数组
    gradientLayer.colors = @[(__bridge id)startColor.CGColor,
                             (__bridge id)endColor.CGColor];
    
    //设置颜色分割点（范围：0-1）
    gradientLayer.locations = @[@(0.5f), @(1.0f)];
}

- (void)setLeftAndRightGradientLayer:(UIColor*)startColor endColor:(UIColor*)endColor {
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    
    gradientLayer.frame = self.bounds;
    
    [self.layer addSublayer:gradientLayer];
    
    gradientLayer.startPoint = CGPointMake(0, 0.5);
    gradientLayer.endPoint = CGPointMake(1, 0.5);
    
    //设置颜色数组
    gradientLayer.colors = @[(__bridge id)startColor.CGColor,
                             (__bridge id)endColor.CGColor];
}

#pragma mark- Getter&Setter

- (NSArray *)xc_colors {
    
    return objc_getAssociatedObject(self, _cmd);
}
- (void)setXc_colors:(NSArray *)colors {
    
    objc_setAssociatedObject(self, @selector(xc_colors), colors, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    if ([self.layer isKindOfClass:[CAGradientLayer class]]) {
        [((CAGradientLayer *)self.layer) setColors:self.xc_colors];
    }
}



- (NSArray<NSNumber *> *)xc_locations {
    return objc_getAssociatedObject(self, _cmd);
}
- (void)setXc_locations:(NSArray<NSNumber *> *)locations{

    objc_setAssociatedObject(self, @selector(xc_locations), locations, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    if ([self.layer isKindOfClass:[CAGradientLayer class]]) {
        [((CAGradientLayer *)self.layer) setLocations:self.xc_locations];
    }
}


- (CGPoint)xc_startPoint {
    return [objc_getAssociatedObject(self, _cmd) CGPointValue];
}
- (void)setXc_startPoint:(CGPoint)startPoint{
    objc_setAssociatedObject(self, @selector(xc_startPoint), [NSValue valueWithCGPoint:startPoint], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    if ([self.layer isKindOfClass:[CAGradientLayer class]]) {
        [((CAGradientLayer *)self.layer) setStartPoint:self.xc_startPoint];
    }
}


- (CGPoint)xc_endPoint {
    return [objc_getAssociatedObject(self, _cmd) CGPointValue];
}
- (void)setXc_endPoint:(CGPoint)endPoint{
    objc_setAssociatedObject(self, @selector(xc_endPoint), [NSValue valueWithCGPoint:endPoint], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    if ([self.layer isKindOfClass:[CAGradientLayer class]]) {
        [((CAGradientLayer *)self.layer) setEndPoint:self.xc_endPoint];
    }
}




@end

@implementation UILabel (Gradient)

+ (Class)layerClass {
    return [CAGradientLayer class];
}

@end

