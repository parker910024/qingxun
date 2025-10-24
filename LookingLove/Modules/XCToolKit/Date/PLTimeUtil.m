//
//  PLTimeUtil.m
//  YYMobile
//
//  Created by penglong on 14/10/28.
//  Copyright (c) 2014年 YY.inc. All rights reserved.
//

#import "PLTimeUtil.h"
#import "NVDate.h"
#import "YYUtility.h"
@implementation PLTimeUtil

+ (NSString *)getTimeWithSecond:(NSUInteger)second
{
    NSUInteger hours = second / 3600;
    NSUInteger minutes = (second % 3600) / 60;
    NSUInteger seconds  = second % 60;
    return [NSString stringWithFormat:@"%@:%@:%@",[self getConent:hours],
            [self getConent:minutes],[self getConent:seconds]];
}

+ (NSString *)getConent:(NSUInteger)count
{
    if(count >= 10){
        return [NSString stringWithFormat:@"%lu",(unsigned long)count];
    }
    return [NSString stringWithFormat:@"0%lu",(unsigned long)count];
}

+(NSDate *)getDateWithYmd:(NSString *)time
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy:MM:dd"];
    NSDate* date = [dateFormatter dateFromString:time];
    return date;
}

+(NSDate *)getDateWithYearMonthDay:(NSString *)time
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSDate* date = [dateFormatter dateFromString:time];
    return date;
}

+ (NSDate *)getDateWithCompleteTime:(NSString *)time
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy:MM:dd HH:mm:ss"];
    NSDate* date = [dateFormatter dateFromString:time];
    return date;
}

+ (NSDate *)getDateWithTime:(NSString *)time
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"HH:mm:ss"];
    NSDate* date = [dateFormatter dateFromString:time];
    return date;
}

+ (NSString *)getMonthDayContent:(NSDate *)date
{
    NVDate *currentNVDate = [[NVDate alloc] initUsingDate:date];
    
    NSString *month = [self getContent:currentNVDate.month];
    NSString *day = [self getContent:currentNVDate.day];
    
    NSString *content = [NSString stringWithFormat:@"%@-%@",month,day];
    return content;
}

+ (NSString *)getContent:(NSUInteger)count
{
    if(count >= 10){
        return [NSString stringWithFormat:@"%lu",(unsigned long)count];
    }
    return [NSString stringWithFormat:@"0%lu",(unsigned long)count];
}

+ (NSString *)getYYMMDDWithDate:(NSDate *)date {
//    NSTimeZone *zome = [NSTimeZone systemTimeZone];
//    NSTimeInterval seconds1 = [zome secondsFromGMTForDate:date];
//    NSDate *date2 = [date dateByAddingTimeInterval:seconds1];
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Beijing"];
    [formatter setTimeZone:timeZone];
    formatter.dateFormat = @"yyyy-MM-dd";
    NSString *dateStr = [formatter stringFromDate:date];
    return dateStr;
}

+ (NSString *)getYYMMDDWithDateFormatter:(NSDate *)date {
//    NSTimeZone *zome = [NSTimeZone systemTimeZone];
//    NSTimeInterval seconds1 = [zome secondsFromGMTForDate:date];
//    NSDate *date2 = [date dateByAddingTimeInterval:seconds1];
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Beijing"];
    [formatter setTimeZone:timeZone];
    formatter.dateFormat = @"yyyy年MM月dd日";
    NSString *dateStr = [formatter stringFromDate:date];
    return dateStr;
}


+ (NSString *)getYYMMWithDate:(NSDate *)date {
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Beijing"];
    [formatter setTimeZone:timeZone];
    formatter.dateFormat = @"YYYY年MM月";
    NSString *dateStr = [formatter stringFromDate:date];
    return dateStr;
}

+ (NSString *)getDateWithYYMMDD:(NSString *)time {
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    formatter.timeZone = [NSTimeZone timeZoneWithName:@"Asia/Beijing"];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"YYYY年MM月dd日"];
    // 毫秒值转化为秒
    NSString * times;
    if ([self is32bit] && [[YYUtility systemVersion] floatValue] <= 10.0) {
        times = [NSString stringWithFormat:@"%f", ([time doubleValue] + 3600 * 1000 * 8)];
    }else{
        times = time;
    }
    NSDate* date = [NSDate dateWithTimeIntervalSince1970:[times longLongValue]/ 1000.0];
    NSString* dateString = [formatter stringFromDate:date];
    return dateString;
}

+ (BOOL)is32bit

{
    
#if defined(__LP64__) && __LP64__
    
    return NO;
    
#else
    
    return YES;
    
#endif
    
}


+ (NSString *)getDateWithYYMM:(NSString *)time {
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    formatter.timeZone = [NSTimeZone timeZoneWithName:@"Asia/Beijing"];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"yyyy年MM月"];
    // 毫秒值转化为秒
    NSString * times;
    if ([self is32bit] && [[YYUtility systemVersion] floatValue] <= 10.0) {
        times = [NSString stringWithFormat:@"%f", ([time doubleValue] + 3600 * 1000 * 8)];
    }else{
        times = time;
    }
    NSDate* date = [NSDate dateWithTimeIntervalSince1970:[times doubleValue]/ 1000.0];
    NSString* dateString = [formatter stringFromDate:date];
    return dateString;
}



+ (NSString *)getDateWithHHMMSS:(NSString *)time {
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    formatter.timeZone = [NSTimeZone timeZoneWithName:@"Asia/Beijing"];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"HH:mm:ss"];
    // 毫秒值转化为秒
    NSString * times;
    if ([self is32bit] && [[YYUtility systemVersion] floatValue] <= 10.0) {
        times = [NSString stringWithFormat:@"%f", ([time doubleValue] + 3600 * 1000 * 8)];
    }else{
        times = time;
    }
    NSDate* date = [NSDate dateWithTimeIntervalSince1970:[times doubleValue]/ 1000.0];
    NSString* dateString = [formatter stringFromDate:date];
    return dateString;
}

+ (NSString *)getDateWithTotalTimeWith:(NSString *)time {
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    formatter.timeZone = [NSTimeZone timeZoneWithName:@"Asia/Beijing"];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"yyyy.MM.dd HH:mm:ss"];
    // 毫秒值转化为秒
    NSString * times;
    if ([self is32bit] && [[YYUtility systemVersion] floatValue] <= 10.0) {
        times = [NSString stringWithFormat:@"%f", ([time doubleValue] + 3600 * 1000 * 8)];
    }else{
        times = time;
    }
    NSDate* date = [NSDate dateWithTimeIntervalSince1970:[times doubleValue]/ 1000.0];
    NSString* dateString = [formatter stringFromDate:date];
    return dateString;
}


+ (NSString *)getNowTimeTimestampMillisecond{
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;

    [formatter setDateStyle:NSDateFormatterMediumStyle];

    [formatter setTimeStyle:NSDateFormatterShortStyle];

    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"]; // ----------设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制

    //设置时区,这个对于时间的处理有时很重要

    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Beijing"];

    [formatter setTimeZone:timeZone];
    
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval a=[dat timeIntervalSince1970]*1000;
    NSString * timeSp = [NSString stringWithFormat:@"%.0f", a];
    
    return timeSp;
}



@end

