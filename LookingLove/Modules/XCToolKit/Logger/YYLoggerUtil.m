//
//  PLLogUtil.m
//  MyTest
//
//  Created by penglong on 14-6-10.
//  Copyright (c) 2014年 YY Inc. All rights reserved.
//

#import "YYLoggerUtil.h"



@implementation YYLoggerUtil
{
    NSString *_splitContent; //每条log的分隔符
    NSInteger _keepCount; //超过最大数量,删除后保留的条数
    NSInteger _maxCount; //最大的log条数
    NSInteger _contentCount; //现存log数量
    
    NSMutableString *_logContent;
    NSMutableString *_logContent_2;

}

+ (YYLoggerUtil *) shareInstance
{
    static YYLoggerUtil *instance = nil;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        instance = [[super allocWithZone:NULL] init];
    });
    return instance;
}

- (id) init
{
    self = [super init];
    if(self != nil){
        _keepCount = 3000;
        _maxCount = 6000;
        _logContent = [[NSMutableString alloc] initWithString:@""];
        _logContent_2 = [[NSMutableString alloc] initWithString:@""];
        
        _contentCount = 0;
    }
    return self;
}

+ (id)allocWithZone:(struct _NSZone *)zone
{
    return [YYLoggerUtil shareInstance];
}

- (void)setInitSplitSymbol:(NSString *)splitSymbol KeepCount:(NSInteger)keepCount maxCount:(NSInteger)maxCount
{
    _splitContent = splitSymbol;
    _keepCount = keepCount;
    _maxCount  = maxCount;
    
}


- (void) addLog:(NSString *)content
{
    if (_contentCount < (_maxCount - _keepCount)) { //如果未超过指定数量
        [_logContent appendString:content];
        if(_splitContent){
           [_logContent appendString:_splitContent];
        }
    }else if(_contentCount < _maxCount){ // 未超过最大数量
        [_logContent_2 appendString:content];
        if(_splitContent){
            [_logContent_2 appendString:_splitContent];
        }
    }else{  //超过最大数量,则删除前面的部分
        [_logContent_2 appendString:content];
        if(_splitContent){
            [_logContent_2 appendString:_splitContent];
        }
        
        _logContent = [[NSMutableString alloc] initWithString:@""];
        _logContent = [_logContent_2 copy];
        _logContent_2  = [[NSMutableString alloc] initWithString:@""];
         _contentCount = _keepCount-1;
    }

    _contentCount++;
}

//获取log
- (NSString *)getLog
{
    NSMutableString *resultLog = [[NSMutableString alloc] initWithString:@""];
    [resultLog appendString:[_logContent copy]];
    [resultLog appendString:[_logContent_2 copy]];
    
    return resultLog;
}


@end
