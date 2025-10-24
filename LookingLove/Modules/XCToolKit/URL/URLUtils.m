//
//  URLUtils.m
//  YYMobileFramework
//
//  Created by 小城 on 14-7-31.
//  Copyright (c) 2014年 YY Inc. All rights reserved.
//

#import "URLUtils.h"

@implementation URLUtils

+ (NSArray*) urlsFromString:(NSString*)string
{
    if (string) {
        NSError *error;
        NSString *regulaStr = @"((http[s]{0,1}|ftp)://[a-zA-Z0-9\\.\\-]+\\.([a-zA-Z]{2,4})(:\\d+)?(/[a-zA-Z0-9\\.\\-~!@#$%^&*+?:_/=<>]*)?)|(www.[a-zA-Z0-9\\.\\-]+\\.([a-zA-Z]{2,4})(:\\d+)?(/[a-zA-Z0-9\\.\\-~!@#$%^&*+?:_/=<>]*)?)|(\\w\\.(com|cn|net))";
        NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:regulaStr
                                                                               options:NSRegularExpressionCaseInsensitive
                                                                                 error:&error];
        NSArray *arrayOfAllMatches = [regex matchesInString:string options:0 range:NSMakeRange(0, [string length])];
        
    //    for (NSTextCheckingResult *match in arrayOfAllMatches)
    //    {
    //        NSString* substringForMatch = [string substringWithRange:match.range];
    //    }
        if (arrayOfAllMatches.count != 0) {
            return arrayOfAllMatches;
        }
    }
    
    return nil;
}

@end
