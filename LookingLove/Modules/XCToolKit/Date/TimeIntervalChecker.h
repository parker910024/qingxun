//
//  TimeIntervalChecker.h
//  YYMobile
//  检测时间间隔类,用来检测是否过了指定的时间间隔
//  Created by penglong on 14-9-26.
//  Copyright (c) 2014年 YY.inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TimeIntervalChecker : NSObject

//设置时间间隔(毫秒为单位)
- (void)setInterval:(NSUInteger)timeInterval;

//更新时间
- (void)updateTime;

//是否过了指定的时间间隔
- (BOOL)checkIntervalAble;

@end
