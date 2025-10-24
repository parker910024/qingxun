//
//  HttpRequestHelper+Log.m
//  BberryCore
//
//  Created by 卫明何 on 2018/3/13.
//  Copyright © 2018年 chenran. All rights reserved.
//

#import "HttpRequestHelper+Log.h"
#import "LogSK.h"

@implementation HttpRequestHelper (Log)

+(void)requestLogSKSuccess:(void (^)(LogSK *))success failure:(void (^)(NSNumber *, NSString *))failure {
    NSString *method = @"aliyun/log/gettoken";
    [HttpRequestHelper GET:method params:nil success:^(id data) {

        LogSK *sk = [LogSK modelWithJSON:data];
        success(sk);
    } failure:^(NSNumber *resCode, NSString *message) {
        failure(resCode,message);
    }];
}

@end
