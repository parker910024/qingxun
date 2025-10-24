//
//  HttpRequestHelper+Recommend.m
//  XCChatCoreKit
//
//  Created by zoey on 2019/1/2.
//  Copyright © 2019年 KevinWang. All rights reserved.
//

#import "HttpRequestHelper+Recommend.h"
#import "AuthCore.h"
#import "NSObject+YYModel.h"



@implementation HttpRequestHelper (Recommend)

+ (void)requestMyRecommendCardStatus:(RecommendState)status page:(int)page success:(void (^)(NSArray<RecommendModel *> *))success  failure:(void (^)(NSNumber *, NSString *))failure{
    NSString *method = @"recommend/backpack";
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    NSString *uid = [GetCore(AuthCore) getUid];
    [params setObject:uid forKey:@"uid"];
    [params setObject:@(status) forKey:@"status"];
    [params setObject:@(page) forKey:@"page"];
    [params setObject:@(10) forKey:@"pageSize"];
    
    [HttpRequestHelper POST:method params:params success:^(id data) {
        NSArray *listData = [RecommendModel modelsWithArray:data];
        if (success) {
            success(listData);
        }
    } failure:^(NSNumber *resCode, NSString *message) {
        if (failure) {
            failure(resCode, message);
        }
    }];
}

//申请推荐
+ (void)requestRecommendUsebyCardvalidStartTime:(NSString *)validStartTime validEndTime:(NSString *)validEndTime useStartTime:(NSString*)useStartTime  success:(void (^)(BOOL))success  failure:(void (^)(NSNumber *, NSString *))failure {
    
    NSString *method = @"recommend/apply";
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    NSString *uid = [GetCore(AuthCore) getUid];
    [params setObject:uid forKey:@"uid"];
   
    [params setObject:validStartTime forKey:@"validStartTime"];
    [params setObject:validEndTime forKey:@"validEndTime"];
    [params setObject:useStartTime forKey:@"useStartTime"];
    
    [HttpRequestHelper POST:method params:params success:^(id data) {
        if (success) {
            success(YES);
        }
    } failure:^(NSNumber *resCode, NSString *message) {
        if (failure) {
            failure(resCode, message);
        }
    }];
}

//获取指定时间点的推荐位可用数  时间格式
+ (void)requestRecommendCanUsebyTime:(NSString*)time  success:(void (^)(NSNumber *))success  failure:(void (^)(NSNumber *, NSString *))failure {
    NSString *method = @"recommend/stock/get";
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    NSString *uid = [GetCore(AuthCore) getUid];
    [params setObject:uid forKey:@"uid"];
    [params setObject:time forKey:@"time"];
    
    [HttpRequestHelper GET:method params:params success:^(id data) {
        if (success) {
            success(data);
        }
    } failure:^(NSNumber *resCode, NSString *message) {
        if (failure) {
            failure(resCode, message);
        }
    }];
}



@end
