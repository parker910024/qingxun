//
//  LogGroup.m
//  AliyunLogObjc
//
//  Created by 陆家靖 on 2016/10/27.
//  Copyright © 2016年 陆家靖. All rights reserved.
//

#import "LogGroup.h"
#import "Log.h"

@implementation LogGroup

- (id)initWithTopic: (NSString *) topic andSource:(NSString *) source {
    if(self = [super init]) {
        _mTopic = topic;
        _mSource = source;
        __mContent = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)PutTopic: (NSString *)topic {
    _mTopic = topic;
}

- (void)PutSource: (NSString *)source {
    _mSource = source;
}

- (void)PutLog: (Log *)log {
    [__mContent addObject:[log GetContent]];
}

- (NSString *)GetJsonPackage {
    NSMutableDictionary<NSString*,NSObject*> *package = [[NSMutableDictionary alloc] init];
    [package setValue:_mTopic forKey:@"__topic__"];
    [package setValue:_mSource forKey:@"__source__"];
    [package setValue:__mContent forKey:@"__logs__"];
    NSError *e = nil;
    NSData *data;
    @try {
        data = [NSJSONSerialization dataWithJSONObject:package options:NSJSONWritingPrettyPrinted error: &e];
    } @catch (NSException *exception) {
        return @"";
    } @finally {
        if(e) {
            return @"";
        }
    }
    return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
}


@end
