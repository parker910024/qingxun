//
//  UIColor+LightAndDark.m
//  YY2
//
//  Created by wuwei on 13-10-28.
//  Copyright (c) 2013年 YY Inc. All rights reserved.
//

#import "UIColor+LightAndDark.h"

@implementation UIColor (LightAndDark)

- (UIColor *)lighterColor
{
    CGFloat h, s, b, a;
    if ([self getHue:&h saturation:&s brightness:&b alpha:&a])
        return [UIColor colorWithHue:h
                          saturation:s
                          brightness:MIN(b * 1.3, 1.0)
                               alpha:a];
    return nil;
}

- (UIColor *)darkerColor
{
    return [self darkerColorWithBrightnessCoefficient:0.75];
}

- (UIColor *)darkerColorWithBrightnessCoefficient:(CGFloat)coe
{
    CGFloat h, s, b, a;
    if ([self getHue:&h saturation:&s brightness:&b alpha:&a])
        return [UIColor colorWithHue:h
                          saturation:s
                          brightness:MIN(MAX(0, b * coe), 1.0)
                               alpha:a];
    return nil;
}

@end