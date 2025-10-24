//
//  XCLogger.h
//  BberryFramework
//
//  Created by 卫明何 on 2018/3/14.
//  Copyright © 2018年 chenran. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LogSK.h"
#import "LogTag.h"

@interface XCLogger : BaseObject

@property (nonatomic, strong)LogSK * _Nullable sk;

+ (instancetype _Nonnull )shareXClogger;
- (void)sendLog:(NSDictionary<NSString*,NSString*>*_Nullable)logContent error:(nullable NSError *)error topic:(nonnull NSString *)topic logLevel:(XCLogLevel)logLevel;
@end
