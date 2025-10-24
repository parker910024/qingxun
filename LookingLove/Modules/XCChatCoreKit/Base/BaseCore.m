//
//  BaseCore.m
//  YYMobileCore
//
//  Created by daixiang on 14-6-5.
//  Copyright (c) 2014年 YY.inc. All rights reserved.
//

#import <objc/runtime.h>
#import "BaseCore.h"
#import "YYLogger.h"

@implementation BaseCore

- (id)init
{
    if (self = [super init])
    {
        _logger = [YYLogger getYYLogger:[NSString stringWithCString:class_getName(object_getClass(self)) encoding:NSUTF8StringEncoding]];
    }
    return self;
} 

@end
