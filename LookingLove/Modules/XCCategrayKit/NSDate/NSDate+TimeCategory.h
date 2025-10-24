//
//  NSDate+TimeCategory.h
//  XChatFramework
//
//  Created by 卫明何 on 2018/5/29.
//  Copyright © 2018年 chenran. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (TimeCategory)
/**
 *  字符串转NSDate
 *
 *  @param theTime 字符串时间
 *  @param format  转化格式 如yyyy-MM-dd HH:mm:ss,即2015-07-15 15:00:00
 *
 *  @return <#return value description#>
 */
+ (NSDate *)dateFromString:(NSString *)timeStr
                    format:(NSString *)format;

/**
 *  NSDate转时间戳
 *
 *  @param date 字符串时间
 *
 *  @return 返回时间戳
 */
+ (NSInteger)cTimestampFromDate:(NSDate *)date;

/**
 *  字符串转时间戳
 *
 *  @param theTime 字符串时间
 *  @param format  转化格式 如yyyy-MM-dd HH:mm:ss,即2015-07-15 15:00:00
 *
 *  @return 返回时间戳的字符串
 */
+(NSInteger)cTimestampFromString:(NSString *)timeStr
                          format:(NSString *)format;


/**
 *  时间戳转字符串
 *
 *  @param timeStamp 时间戳
 *  @param format    转化格式 如yyyy-MM-dd HH:mm:ss,即2015-07-15 15:00:00
 *
 *  @return 返回字符串格式时间
 */
+ (NSString *)dateStrFromCstampTime:(NSInteger)timeStamp
                     withDateFormat:(NSString *)format;

/**
 *  NSDate转字符串
 *
 *  @param date   NSDate时间
 *  @param format 转化格式 如yyyy-MM-dd HH:mm:ss,即2015-07-15 15:00:00
 *
 *  @return 返回字符串格式时间
 */
+ (NSString *)datestrFromDate:(NSDate *)date
               withDateFormat:(NSString *)format;

///传入今天的时间，返回明天的时间
- (NSString *)GetTomorrowDay:(NSDate *)aDate formatter:(NSString *)fmt;

//根据出生日期返回年龄的方法
+ (NSInteger)ageWithDateOfBirth:(NSDate *)date;

//根据出生日期返回详细的年龄(精确到天)
+ (NSString *)dateToDetailOld:(NSDate *)bornDate;

//根据出生日期返回年龄的方法
+ (NSInteger)ageWithDateFromBirth:(NSInteger)birth;

//返回格式时间(时分秒) 00:00:00
+ (NSString *)numberWithTimeString:(NSString *)timeStr;
//返回格式时间(分秒) 00:00
+ (NSString *)getMinuteTimeWithTimeString:(NSString *)timeStr;
// ---------------------------------------

/**
 是否今天
 
 @return yes or no
 */
- (BOOL)isToday;

/**
 是否昨天
 
 @return yes or no
 */
- (BOOL)isYesterday;

/**
 是否前天
 
 @return yes or no
 */
- (BOOL)isBeforeYesterday;

/**
 是否今年
 
 @return yes or no
 */
- (BOOL)isThisYear;

/**
 和今天是否在同一周
 
 @return yes or no
 */
- (BOOL)isSameWeek;

+ (NSDate *)date:(NSString *)datestr WithFormat:(NSString *)format;

@property (readonly) NSInteger day;
@property (readonly) NSInteger month;
@property (readonly) NSInteger year;

// ---------------------------------------

@end
