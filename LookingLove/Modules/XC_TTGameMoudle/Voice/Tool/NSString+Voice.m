//
//  NSString+Voice.m
//  XC_TTGameMoudle
//
//  Created by Macx on 2019/6/6.
//  Copyright © 2019 YiZhuan. All rights reserved.
//

#import "NSString+Voice.h"

@implementation NSString (Voice)
// 将数量格式化为字符串
+ (NSString *)countNumberFormatStr:(NSInteger)number {
    NSString *numStr = [NSString stringWithFormat:@"%li", number];
    NSInteger num = number;
    if (num > 99990000) {
        numStr = @"9999万+";
    } else if (num >= 10000) {
        CGFloat numF = num / 10000.0;
        numStr = [NSString stringWithFormat:@"%.2f万", numF];
        numStr = [numStr stringByReplacingOccurrencesOfString:@".00" withString:@""];
    }
    return numStr;
}
@end
