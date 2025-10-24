//
//  NSString+Urls.m
//  YYMobileFramework
//
//  Created by Jeanson on 2015/3/16.
//  Copyright (c) 2015年 YY Inc. All rights reserved.
//

#import "NSString+Urls.h"

@implementation NSString (Urls)

- (NSArray*) matchUrls
{
    if (self) {
        NSError *error;
        NSString *regulaStr = @"((http[s]{0,1}|ftp)://[a-zA-Z0-9\\.\\-]+\\.([a-zA-Z]{2,4})(:\\d+)?(/[a-zA-Z0-9\\.\\-~!@#$%^&*+?:_/=<>]*)?)|(www.[a-zA-Z0-9\\.\\-]+\\.([a-zA-Z]{2,4})(:\\d+)?(/[a-zA-Z0-9\\.\\-~!@#$%^&*+?:_/=<>]*)?)|(\\w\\.(com|cn|net))";
        NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:regulaStr
                                                                               options:NSRegularExpressionCaseInsensitive
                                                                                 error:&error];
        NSArray *arrayOfAllMatches = [regex matchesInString:self options:0 range:NSMakeRange(0, [self length])];
        
        if (arrayOfAllMatches.count != 0) {
            return arrayOfAllMatches;
        }
    }
    
    return nil;
}

@end
