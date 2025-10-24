//
//  BaseCore.h
//  YYMobileCore
//
//  Created by daixiang on 14-6-5.
//  Copyright (c) 2014年 YY.inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CoreManager.h"
#import "CoreError.h"
#import <ReactiveObjC/ReactiveObjC.h>
#import "UserID.h"
#import "GCDHelper.h"
#import <BaiduMobStatCodeless/BaiduMobStat.h>

#import "XCLogger.h"

@class YYLogger;

@interface BaseCore : NSObject
{
    YYLogger *_logger;
}

@end
