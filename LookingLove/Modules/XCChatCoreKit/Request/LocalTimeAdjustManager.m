//
//  LocalTimeAdjustManager.m
//  XCChatCoreKit
//
//  Created by KevinWang on 2018/6/2.
//  Copyright © 2018年 XC. All rights reserved.
//

#import "LocalTimeAdjustManager.h"

@interface LocalTimeAdjustManager()


@end

@implementation LocalTimeAdjustManager

static LocalTimeAdjustManager * instance = nil;


static NSDateFormatter *dateFormatter() {
    static NSDateFormatter *formatter = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        formatter = [[NSDateFormatter alloc] init] ;
        
        [formatter setDateStyle:NSDateFormatterMediumStyle];
        
        [formatter setTimeStyle:NSDateFormatterShortStyle];
        
        [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"]; // ----------设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制
        //设置时区,这个对于时间的处理有时很重要
        
        NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
        
        [formatter setTimeZone:timeZone];
        
    });
    return formatter;
}

+ (instancetype)shareManager{
    
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        instance = [[LocalTimeAdjustManager alloc]init];
    });
    
    return instance;
}

#pragma mark - puble method

- (long)adjustedLocalTimestamp{
    
    return self.localTimestamp + self.offset;
}


- (long)localTimestamp{
    
    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    [dateFormatter() setTimeZone:timeZone];
    NSDate *datenow = [NSDate date];
    
    return (long)[datenow timeIntervalSince1970]*1000;
}


@end
