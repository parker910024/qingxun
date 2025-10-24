//
//  LogCore.m
//  BberryCore
//
//  Created by 卫明何 on 2018/3/14.
//  Copyright © 2018年 chenran. All rights reserved.
//

#import "LogCore.h"
#import "XCLogger.h"
#import "HttpRequestHelper+Log.h"

@implementation LogCore

- (instancetype)init {
    if (self = [super init]) {
        [self requestLogSk];
    }
    return self;
}

- (void)requestLogSk {
    @weakify(self);
    [HttpRequestHelper requestLogSKSuccess:^(LogSK *sk) {
        @strongify(self);
        self.sk = sk;
        [[XCLogger shareXClogger]setSk:sk];
    } failure:^(NSNumber *resCode, NSString *message) {
        
    }];
}

@end
