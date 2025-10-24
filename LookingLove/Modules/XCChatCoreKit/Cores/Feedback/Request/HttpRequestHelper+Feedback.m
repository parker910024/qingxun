//
//  HttpRequestHelper+Feedback.m
//  BberryCore
//
//  Created by chenran on 2017/7/19.
//  Copyright © 2017年 chenran. All rights reserved.
//

#import "HttpRequestHelper+Feedback.h"
#import "AuthCore.h"

@implementation HttpRequestHelper (Feedback)
+ (void)requestFeedback:(NSString *)content contact:(NSString *)contact
                success:(void (^)(void))success
                failure:(void (^)(NSNumber *resCode, NSString *message))failure;
{
    NSString *method = @"feedback";
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    NSString *ticket = [GetCore(AuthCore) getTicket];
    UserID uid = [GetCore(AuthCore) getUid].userIDValue;
    [params setObject:ticket forKey:@"ticket"];
    [params setObject:@(uid) forKey:@"uid"];
    [params setObject:content forKey:@"feedbackDesc"];
    [params setObject:contact forKey:@"contact"];
    
    [HttpRequestHelper POST:method params:params success:^(id data) {
        if (success) {
            success();
        }
    } failure:^(NSNumber *resCode, NSString *message) {
        if (failure) {
            failure(resCode, message);
        }
    }];
}

+ (void)requestFeedback:(NSString *)content contact:(NSString *)contact image:(NSString *)imageURL
                success:(void (^)(void))success
                failure:(void (^)(NSNumber *resCode, NSString *message))failure {
    
    NSString *method = @"feedback";
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    NSString *ticket = [GetCore(AuthCore) getTicket];
    UserID uid = [GetCore(AuthCore) getUid].userIDValue;
    [params setObject:ticket forKey:@"ticket"];
    [params setObject:@(uid) forKey:@"uid"];
    [params setObject:content forKey:@"feedbackDesc"];
    [params setObject:contact forKey:@"contact"];
    [params setObject:imageURL forKey:@"img"];
    
    [HttpRequestHelper POST:method params:params success:^(id data) {
        if (success) {
            success();
        }
    } failure:^(NSNumber *resCode, NSString *message) {
        if (failure) {
            failure(resCode, message);
        }
    }];
}

/// 用户反馈
/// @param content 内容
/// @param contact 联系方式
/// @param source 反馈来源(SET_UP_PAGE -- 设置页, DRAW -- 转盘活动, ROOM_RED -- 房间红包)
/// @param imageURLs 图片url,用逗号隔开
+ (void)requestFeedback:(NSString *)content
                contact:(NSString *)contact
                 source:(NSString *)source
              imageURLs:(NSString *)imageURLs
                success:(void (^)(void))success
                failure:(void (^)(NSNumber *resCode, NSString *message))failure {
    
    NSString *method = @"feedback";
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:[GetCore(AuthCore) getTicket] forKey:@"ticket"];
    [params setObject:[GetCore(AuthCore) getUid] forKey:@"uid"];
    [params setObject:content forKey:@"feedbackDesc"];
    [params setValue:contact forKey:@"contact"];
    [params setValue:imageURLs forKey:@"img"];
    [params setValue:source forKey:@"source"];
    
    [HttpRequestHelper POST:method params:params success:^(id data) {
        if (success) {
            success();
        }
    } failure:^(NSNumber *resCode, NSString *message) {
        if (failure) {
            failure(resCode, message);
        }
    }];
}

@end
