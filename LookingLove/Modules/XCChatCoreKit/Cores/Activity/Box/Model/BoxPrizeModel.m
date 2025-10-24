//
//  BoxPrizeModel.m
//  BberryCore
//
//  Created by KevinWang on 2018/7/16.
//  Copyright © 2018年 YiZhuan. All rights reserved.
//

#import "BoxPrizeModel.h"

@implementation BoxPrizeModel


- (NSString *)messageTimeShowWithTimeInterval: (NSTimeInterval)secs{
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *todayString = [dateFormatter stringFromDate:[NSDate date]];
    todayString = [NSString stringWithFormat:@"%@ %@", todayString, @"00:00:00"];
    
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *todayDate = [dateFormatter dateFromString:todayString];
    
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:secs];
    if ([todayDate compare:date] == NSOrderedAscending || [todayDate compare:date] == NSOrderedSame){
        // 今天
        if ([date timeIntervalSinceNow] > -10){
            // 10s内
            return @"刚刚";
        }else if ([date timeIntervalSinceNow] > -60){
            // 1分钟内
            return [NSString stringWithFormat:@"%@%@", @((int)[date timeIntervalSinceNow]/(-1)), @"秒前"];
        }else if ([date timeIntervalSinceNow] > -3600){
            // 1小时内
            return [NSString stringWithFormat:@"%@%@", @((int)[date timeIntervalSinceNow]/(-60)), @"分钟前"];
        }else{
            // 1天内
            [dateFormatter setDateFormat:@"HH:mm"];
            return [dateFormatter stringFromDate:date];
        }
    }else{
        // 1天以上 yy/MM/dd
        [dateFormatter setDateFormat:@"MM/dd HH:mm"];
        return [dateFormatter stringFromDate:date];
    }
}

- (NSString *)recodeTimeStr{
  
    return [self messageTimeShowWithTimeInterval:self.createTime/1000];
}

@end
