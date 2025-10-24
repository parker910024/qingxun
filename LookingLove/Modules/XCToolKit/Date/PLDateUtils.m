//
//  YY2DateUtils.m
//  YY2
//
//  Created by 甘鹏龙 on 14-5-22.
//  Copyright (c) 2014年 YY Inc. All rights reserved.
//

#import "PLDateUtils.h"

@implementation PLDateUtils

+ (BOOL) isToday:(NSUInteger) since1970
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"YYYY/MM/dd"];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:since1970];
    NSString *dateSMS = [dateFormatter stringFromDate:date];
    NSDate *now = [NSDate date];
    NSString *dateNow = [dateFormatter stringFromDate:now];
    if ([dateSMS isEqualToString:dateNow]) {
        return YES;
    }
    return NO;
}



@end
