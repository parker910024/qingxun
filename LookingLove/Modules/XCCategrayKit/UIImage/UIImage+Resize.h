//
//  UIImage+Resize.h
//  YYMobileFramework
//
//  Created by wuwei on 14/7/18.
//  Copyright (c) 2014年 YY Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Resize)

- (UIImage *)resizedImageWithRestrictSize:(CGSize)size;

- (UIImage *)resizedImageWithTargetRestrictSize:(CGSize)dstSize;

- (UIImage *)resizedImage:(CGSize)newSize
     interpolationQuality:(CGInterpolationQuality)quality;

- (UIImage *)resizedImage:(CGSize)newSize
                transform:(CGAffineTransform)transform
           drawTransposed:(BOOL)transpose
     interpolationQuality:(CGInterpolationQuality)quality;
+(UIImage *)resizeWithImage:(UIImage *)image;


/**
 兔兔广告页专业裁剪方法

 @param newSize 屏幕尺寸
 @return 裁剪后的图片
 */
- (UIImage *)cutImage:(CGSize)newSize;

-(UIImage *)getSubImage:(CGRect)rect;

@end
