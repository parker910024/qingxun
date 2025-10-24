//
//  PLTimeUtil.h
//  YYMobile
//
//  Created by penglong on 14/10/28.
//  Copyright (c) 2014年 YY.inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PLTimeUtil : NSObject

/**
 *  根据秒数获取倒计时时间
 *
 *  @param second 秒
 *
 *  @return 格式为 01:02:00
 */
+ (NSString *)getTimeWithSecond:(NSUInteger)second;

+ (NSDate *)getDateWithCompleteTime:(NSString *)time;

+ (NSDate *)getDateWithTime:(NSString *)time;

+ (NSDate *)getDateWithYmd:(NSString *)time;

+ (NSString *)getDateWithHHMMSS:(NSString *)time;

+ (NSString *)getDateWithYYMMDD:(NSString *)time;

+ (NSString *)getDateWithYYMM:(NSString *)time;

+ (NSDate *)getDateWithYearMonthDay:(NSString *)time;

+ (NSString *)getMonthDayContent:(NSDate *)date;

+ (NSString *)getYYMMWithDate:(NSDate *)date;

+ (NSString *)getYYMMDDWithDate:(NSDate *)date;

+ (NSString *)getYYMMDDWithDateFormatter:(NSDate *)date;

+ (NSString *)getDateWithTotalTimeWith:(NSString *)time;

+ (NSString *)getNowTimeTimestampMillisecond;

@end

