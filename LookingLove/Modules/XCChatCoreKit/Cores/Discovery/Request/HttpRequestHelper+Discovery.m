//
//  HttpRequestHelper+Discovery.m
//  BberryCore
//
//  Created by Macx on 2018/3/5.
//  Copyright © 2018年 chenran. All rights reserved.
//

#import "HttpRequestHelper+Discovery.h"
#import "DiscoveryAdListModel.h"

#import "AuthCore.h"
#import "XCMacros.h"

@implementation HttpRequestHelper (Discovery)

+ (void)requestDisCoveryAdListWithUid:(NSString *)uid
                              success:(void (^)(NSArray *list))success
                              failure:(void (^)(NSNumber *resCode, NSString *message))failure{
    if (!uid) {
        uid = @"0";
    }
    NSString *method = @"advertise/getList";
    [HttpRequestHelper GET:method params:@{@"uid":uid} success:^(id data) {

        NSArray *discoveryAdList = [DiscoveryAdListModel modelsWithArray:data];
        success(discoveryAdList);

    } failure:^(NSNumber *resCode, NSString *message) {

        failure(resCode, message);
    }];
   
}

+ (void)requstLastWeekGiftListsuccess:(void (^)(NSArray<DiscoverGiftRankModel *> *list))success
                              failure:(void (^)(NSNumber *resCode, NSString *message))failure
{
    NSString *method = @"week/star/previous";
    [HttpRequestHelper GET:method params:nil success:^(id data) {
        
        NSArray *discoveryAdList = [DiscoverGiftRankModel modelsWithArray:data];
        success(discoveryAdList);
        
    } failure:^(NSNumber *resCode, NSString *message) {
        
        failure(resCode, message);
    }];
}


+ (void)requestDiscoverTypeListSuccess:(void (^)(NSArray<DiscoverListModel *> *list))success
                               failure:(void (^)(NSNumber *resCode, NSString *message))failure
{
    NSString *method = @"discovery/items";
    [HttpRequestHelper GET:method params:nil success:^(id data) {
        
        NSArray *discoveryAdList = [DiscoverListModel modelsWithArray:data];
        success(discoveryAdList);
        
    } failure:^(NSNumber *resCode, NSString *message) {
        
        failure(resCode, message);
    }];
}

+ (void)requestNewUserListWith:(int)page
                      pageSize:(int)pageSize
                        gender:(int)gender
                       success:(void (^)(NSArray<UserInfo *> *list))success
                       failure:(void (^)(NSNumber *resCode, NSString *message))failure {
    NSString * method = @"user/list/new";
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    ProjectType apptype = projectType();
    if (apptype == ProjectType_MengSheng || projectType() == ProjectType_BB) {
        [params setValue:GetCore(AuthCore).getUid forKey:@"uid"];
    }
    [params safeSetObject:@(page) forKey:@"page"];
    [params safeSetObject:@(pageSize) forKey:@"pageSize"];
    [params safeSetObject:@(gender) forKey:@"gender"];
    [HttpRequestHelper GET:method params:params success:^(id data) {
        NSArray * array = [UserInfo modelsWithArray:data];
        success(array);
    } failure:^(NSNumber *resCode, NSString *message) {
        failure(resCode, message);
    }];
}
#pragma mark -
#pragma mark 2019-03-29  公会线添加
/**
 获取发现页信息 v2
 interface discovery/v2/get
 */
+ (void)requestDiscoverV2InfoAndCompletionHandler:(HttpResponseHelperDiscoverCompletionHandler)completionHandler {
    NSString * method = @"discovery/v2/get";
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    [params setValue:GetCore(AuthCore).getUid forKey:@"uid"];

    [HttpRequestHelper GET:method params:params success:^(id data) {
        if (completionHandler) {
            completionHandler(data, nil, nil);
        }
    } failure:^(NSNumber *resCode, NSString *message) {
        if (completionHandler) {
            completionHandler(nil, resCode, message);
        }
    }];
}

@end
