//
//  UIImage+_1x1Color.m
//  YY2
//
//  Created by wuwei on 14-4-4.
//  Copyright (c) 2014年 YY Inc. All rights reserved.
//

#import "UIImage+_1x1Color.h"

@implementation UIImage (_1x1Color)

+ (instancetype)instantiate1x1ImageWithColor:(UIColor *)color
{
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}

@end
