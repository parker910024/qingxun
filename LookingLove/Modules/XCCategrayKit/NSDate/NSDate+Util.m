//
//  NSDate+Util.m
//  XChat
//
//  Created by chenran on 2017/5/22.
//  Copyright © 2017年 chenran. All rights reserved.
//

#import "NSDate+Util.h"

@implementation NSDate (Util)
+(NSInteger) getMonth:(long )time
{
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:time/1000];
    NSCalendar* calendar = [NSCalendar currentCalendar];
    NSDateComponents* components = [calendar components:NSCalendarUnitMonth fromDate:date];
    NSInteger month = components.month;
    return month;
}

+ (NSInteger) getDay:(long) time
{
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:time/1000];
    NSCalendar* calendar = [NSCalendar currentCalendar];
    NSDateComponents* components = [calendar components:NSCalendarUnitDay fromDate:date];
    NSInteger day = components.day;
    return day;
}

+(NSString *)calculateConstellationWithMonth:(long)time
{
    NSString *astroString = @"魔羯水瓶双鱼白羊金牛双子巨蟹狮子处女天秤天蝎射手魔羯";
    NSString *astroFormat = @"102123444543";
    NSString *result;
    
    NSInteger month = [NSDate getMonth:time];
    NSInteger day = [NSDate getDay:time];
    
    if (month<1 || month>12 || day<1 || day>31){
        return @"错误日期格式!";
    }
    
    if(month==2 && day>29)
    {
        return @"错误日期格式!!";
    }else if(month==4 || month==6 || month==9 || month==11) {
        if (day>30) {
            return @"错误日期格式!!!";
        }
    }
    
    result=[NSString stringWithFormat:@"%@",[astroString substringWithRange:NSMakeRange(month*2-(day < [[astroFormat substringWithRange:NSMakeRange((month-1), 1)] intValue] - (-19))*2,2)]];
    
    return [NSString stringWithFormat:@"%@座",result];
}
@end
