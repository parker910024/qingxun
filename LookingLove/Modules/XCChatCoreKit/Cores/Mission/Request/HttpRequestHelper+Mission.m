//
//  HttpRequestHelper+Mission.m
//  XCChatCoreKit
//
//  Created by lee on 2019/3/28.
//  Copyright © 2019 YiZhuan. All rights reserved.
//

#import "HttpRequestHelper+Mission.h"
#import "AuthCore.h"
@implementation HttpRequestHelper (Mission)
/**
 获取任务列表
 interface /mission/list
 */
+ (void)requestMissionListAndCompletionHandler:(HttpResponseHelperMissionCompletionHandler)completionHandler {
    NSString *method = @"mission/list";
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:GetCore(AuthCore).getUid forKey:@"uid"];
    
    [self mission_request:method
                   method:HttpRequestHelperMethodPOST
                   params:dict
               completion:completionHandler];
}

/**
 请求成就任务列表
 interface mission/achievement/list
 */
+ (void)requestMissionAchievementListAndCompletionHandler:(HttpResponseHelperMissionCompletionHandler)completionHandler {
    NSString *method = @"mission/achievement/list";
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:GetCore(AuthCore).getUid forKey:@"uid"];
    
    [self mission_request:method
                   method:HttpRequestHelperMethodPOST
                   params:dict
               completion:completionHandler];
}

/**
 任务完成领取奖励
 interface /mission/receive
 
 @param configId 任务id
 @param completionHandler 完成回调
 */
+ (void)requestMissionReceiveByMissionID:(NSString *)configId
                    AndCompletionHandler:(HttpResponseHelperMissionCompletionHandler)completionHandler {
    NSString *method = @"mission/receive";
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:GetCore(AuthCore).getUid forKey:@"uid"];
    [dict setObject:configId forKey:@"configId"];
    
    [self mission_request:method
                   method:HttpRequestHelperMethodPOST
                   params:dict
               completion:completionHandler];
}

/**
 查询是否可以领取新人有礼
 
 interface  mission/check/new/user
 @param completionHandler 完成回调
 */
+ (void)requestMissionNewUserAndCompletionHandler:(HttpResponseHelperMissionCompletionHandler)completionHandler {
    NSString *method = @"mission/check/new/user";
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:GetCore(AuthCore).getUid forKey:@"uid"];

    [self mission_request:method
                   method:HttpRequestHelperMethodGET
                   params:dict
               completion:completionHandler];
}

#pragma mark - Private Methods
+ (void)mission_request:(NSString *)url
                 method:(HttpRequestHelperMethod)method
                 params:(NSDictionary *)params
             completion:(HttpResponseHelperMissionCompletionHandler)completion {
    if ([url hasPrefix:@"/"]) {
        url = [url substringFromIndex:1];
    }
    
    [self request:url method:method params:params success:^(id data) {
        if (completion) {
            completion(data, nil, nil);
        }
    } failure:^(NSNumber *resCode, NSString *message) {
        if (completion) {
            completion(nil, resCode, message);
        }
    }];
}
@end
