//
//  NSString+FullWidth.m
//  YYMobileFramework
//
//  Created by 武帮民 on 14-6-30.
//  Copyright (c) 2014年 YY Inc. All rights reserved.
//

#import "NSString+FullWidth.h"

@implementation NSString (FullWidth)

- (NSUInteger)fullWidth {
    
    NSUInteger length = 0;
    
    for (NSUInteger i = 0; i < self.length; i++) {
        unichar c = [self characterAtIndex:i];
        if (c > 0xff) {
            length += 2;    // 中文算两个字符
        } else {
            length ++;
        }
    }
    
    return length;
}

@end