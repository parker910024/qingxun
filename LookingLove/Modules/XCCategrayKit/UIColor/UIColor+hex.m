//
//  UIColor+hex.m
//  XChatFramework
//
//  Created by 卫明何 on 2018/1/10.
//  Copyright © 2018年 chenran. All rights reserved.
//

#import "UIColor+hex.h"

@implementation UIColor (hex)

+ (UIColor *) getColor:(NSString *)hexColor
{
    unsigned int alpha, red, green, blue;
    NSRange range;
    range.length =2;
    
    range.location =1;
    [[NSScanner scannerWithString:[hexColor substringWithRange:range]]scanHexInt:&alpha];//透明度
    range.location =3;
    [[NSScanner scannerWithString:[hexColor substringWithRange:range]]scanHexInt:&red];
    range.location =5;
    [[NSScanner scannerWithString:[hexColor substringWithRange:range]]scanHexInt:&green];
    range.location =7;
    [[NSScanner scannerWithString:[hexColor substringWithRange:range]]scanHexInt:&blue];
    return [UIColor colorWithRed:(float)(red/255.0f)green:(float)(green/255.0f)blue:(float)(blue/255.0f)alpha:(float)(alpha/255.0f)];
}

@end
