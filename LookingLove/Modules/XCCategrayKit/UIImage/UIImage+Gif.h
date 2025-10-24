//
//  UIImage+Gif.h
//  YYMobileFramework
//
//  Created by wuwei on 14/7/14.
//  Copyright (c) 2014年 YY Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (GIF)

+ (UIImage *)animatedGIFWithData:(NSData *)data;
+ (UIImage *)animatedGrayGIFWithData:(NSData *)data;


+ (UIImage *)animatedGIFNamed:(NSString *)name;

@end
