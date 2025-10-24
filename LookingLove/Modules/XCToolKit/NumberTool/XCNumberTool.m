//
//  XCNumberTool.m
//  Allo
//
//  Created by apple on 2019/1/28.
//  Copyright © 2019 yizhuan. All rights reserved.
//

#import "XCNumberTool.h"

@implementation XCNumberTool

+ (NSInteger)getUnits:(NSInteger)targetInt {
    NSString *strNum = [NSString stringWithFormat:@"%ld", targetInt];
    NSString *resultStr = [strNum substringWithRange:NSMakeRange(strNum.length - 1, 1)];
    return [resultStr integerValue];
}

+ (NSInteger)getTens:(NSInteger)targetInt {
    if (targetInt < 10 && targetInt > -10) {
        return 0;
    }
    NSString *strNum = [NSString stringWithFormat:@"%ld", targetInt];
    NSString *resultStr = [strNum substringWithRange:NSMakeRange(strNum.length - 2, 1)];
    return [resultStr integerValue];
}

+ (NSInteger)getHundreds:(NSInteger)targetInt {
    if (targetInt < 100 && targetInt > -100) {
        return 0;
    }
    NSString *strNum = [NSString stringWithFormat:@"%ld", targetInt];
    NSString *resultStr = [strNum substringWithRange:NSMakeRange(strNum.length - 3, 1)];
    return [resultStr integerValue];
}

+ (NSInteger)getThousands:(NSInteger)targetInt {
    if (targetInt < 1000 && targetInt > -1000) {
        return 0;
    }
    NSString *strNum = [NSString stringWithFormat:@"%ld", targetInt];
    NSString *resultStr = [strNum substringWithRange:NSMakeRange(strNum.length - 4, 1)];
    return [resultStr integerValue];
}

@end
