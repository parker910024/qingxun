//
//  UIColor+LightAndDark.h
//  YY2
//
//  Created by wuwei on 13-10-28.
//  Copyright (c) 2013年 YY Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (LightAndDark)

- (UIColor *)lighterColor;
- (UIColor *)darkerColor;

- (UIColor *)darkerColorWithBrightnessCoefficient:(CGFloat)coe;

@end
