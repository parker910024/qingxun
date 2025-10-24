//
//  HttpRequestHelper+Alert.m
//  BberryCore
//
//  Created by 卫明何 on 2017/9/26.
//  Copyright © 2017年 chenran. All rights reserved.
//

#import "HttpRequestHelper+Alert.h"
#import "NSObject+YYModel.h"

@implementation HttpRequestHelper (Alert)

+ (void)requestAlertInfoByTyp:(NSInteger)type
                      Success:(void (^)(AlertInfo *info))success
                      failure:(void (^)(NSNumber *resCode, NSString *message))failure {
    NSString *method = @"activity/query";
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    [params setObject:@(type) forKey:@"type"];
    
    [HttpRequestHelper GET:method params:params success:^(id data) {
        AlertInfo *info = [AlertInfo yy_modelWithJSON:data];
        success(info);
    } failure:^(NSNumber *resCode, NSString *message) {
        failure(resCode,message);
    }];
}

@end
