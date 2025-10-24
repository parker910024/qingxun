//
//  HttpRequestHelper+Search.m
//  BberryCore
//
//  Created by chenran on 2017/5/16.
//  Copyright © 2017年 chenran. All rights reserved.
//

#import "HttpRequestHelper+Search.h"
#import "SearchResultInfo.h"
#import "UserInfo.h"

@implementation HttpRequestHelper (Search)

+ (void)requestInfoWithKey:(NSString *)key Success:(void (^)(NSArray *))success failure:(void (^)(NSNumber *, NSString *))failure {
    NSString *method = @"search/room";
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:key forKey:@"key"];
    [HttpRequestHelper GET:method params:params success:^(id data) {
//        NSArray *resultList = [NSArray yy_modelArrayWithClass:[SearchResultInfo class] json:data];
        NSArray *resultList = [SearchResultInfo modelsWithArray:data];
        success(resultList);
    } failure:^(NSNumber *resCode, NSString *message) {
        failure(resCode, message);
    }];
    
}

+ (void)searchUser:(NSString *)key pageNo:(NSInteger)pageNo pageSize:(NSInteger)pageSize success:(void (^)(NSArray *))success failure:(void (^)(NSNumber *, NSString *))failure
{
    if (key == nil) {
        return;
    }
    
    NSString *method = @"search/user";
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:key forKey:@"key"];
    [params setObject:@(pageSize) forKey:@"pageSize"];
    [params setObject:@(pageNo) forKey:@"pageNo"];
    
    [HttpRequestHelper GET:method params:params success:^(id data) {
//        NSArray *userInfos = [NSArray yy_modelArrayWithClass:[UserInfo class] json:data];
        NSArray *userInfos = [UserInfo modelsWithArray:data];
        if (success) {
            success(userInfos);
        }
    } failure:^(NSNumber *resCode, NSString *message) {
        if (failure) {
            failure(resCode, message);
        }
    }];
}

@end
