//
//  TimeIntervalChecker.m
//  YYMobile
//
//  Created by penglong on 14-9-26.
//  Copyright (c) 2014年 YY.inc. All rights reserved.
//

#import "TimeIntervalChecker.h"

@interface TimeIntervalChecker()

//时间间隔
@property (nonatomic,assign) double timeInterval;
//上一次记录的时间
@property (nonatomic,assign) double prepRecordTime;

@end

@implementation TimeIntervalChecker


//设置时间间隔  (毫秒为单位)
- (void)setInterval:(NSUInteger)timeInterval
{
    _timeInterval = timeInterval;
}

//更新时间
- (void)updateTime
{
    self.prepRecordTime = CFAbsoluteTimeGetCurrent();
}

//是否过了指定的时间间隔
- (BOOL)checkIntervalAble
{
    double currentTime = CFAbsoluteTimeGetCurrent();
    NSUInteger timeSpacing = (currentTime - self.prepRecordTime)*1000;
    if(timeSpacing >= self.timeInterval){
        self.prepRecordTime = currentTime;
        return YES;
    }
    return NO;
}


@end
