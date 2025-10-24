//
//  UIColor+UIColor_Hex.h
//  YYMobile
//
//  Created by siyuxing on 15/6/1.
//  Copyright (c) 2015年 YY.inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (UIColor_Hex)

+ (UIColor *) colorWithHexString:(NSString *) hexString;
+ (NSString *) hexStringFromColor:(UIColor *)color;
@end
