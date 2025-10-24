//
//  MessageLayout.m
//  BberryCore
//
//  Created by 卫明何 on 2018/5/25.
//  Copyright © 2018年 chenran. All rights reserved.
//

#import "MessageLayout.h"
#import "NSObject+YYModel.h"
#import "ImMessageCore.h"

@implementation MessageLayout

+ (nullable NSDictionary<NSString *, id> *)modelContainerPropertyGenericClass {
    return @{
             @"contents":LayoutParams.class
             };
}

- (void)setTime:(LayoutParams *)time {
    _time = time;
//    _time.content = [self translateTimeStampToDateStr:time.content];
}

- (NSString *)translateTimeStampToDateStr:(NSString *)timeStamp {
    NSTimeInterval timeInterval=[timeStamp doubleValue];
    NSDate *UTCDate=[NSDate dateWithTimeIntervalSince1970:timeInterval/1000];
    return [GetCore(ImMessageCore).dateFormatter stringFromDate:UTCDate];
}




@end
