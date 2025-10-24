//
//  UIImage+Utils.h
//  YYMobileFramework
//
//  Created by wuwei on 14/6/20.
//  Copyright (c) 2014年 YY Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, GradientType) {
    GradientTypeTopToBottom = 0,//从上到小
    GradientTypeLeftToRight = 1,//从左到右
    GradientTypeUpleftToLowright = 2,//左上到右下
    GradientTypeUprightToLowleft = 3,//右上到左下
};

@interface UIImage (Utils)

- (UIImage *)grayscaleImage;

- (UIImage *)imageBlendInGray;

- (UIImage *)imageWithBlendMode:(CGBlendMode)blendMode;

+ (UIImage *)imageWithColor:(UIColor *)color;

+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size;

+ (UIImage *)fixOrientation:(UIImage *)aImage;

- (UIImage *)imageWithColor:(UIColor *)color;



//异步生成纯色圆角图片
- (void)imageWithSize:(CGSize)size radius:(CGFloat)radius backColor:(UIColor *)backColor completion:(void(^)(UIImage *image))completion;
/**
 返回指定大小，颜色，渐变模式的渐变色图片
 */
+ (UIImage *)gradientColorImageFromColors:(NSArray<UIColor *>*)colors gradientType:(GradientType)gradientType imgSize:(CGSize)imgSize;
@end
