//
//  HttpRequestHelper+Order.m
//  BberryCore
//
//  Created by chenran on 2017/6/21.
//  Copyright © 2017年 chenran. All rights reserved.
//

#import "HttpRequestHelper+Order.h"
#import "AuthCore.h"

@implementation HttpRequestHelper (Order)
+ (void)requestOrderService:(NSString *)orderId uid:(UserID)uid channelId:(UInt64)channelId success:(void (^)(OrderInfo *))success failure:(void (^)(NSNumber *, NSString *))failure
{
    NSString *method = @"order/serv";
    NSString *ticket = [GetCore(AuthCore) getTicket];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:@(uid) forKey:@"uid"];
    [params setObject:orderId forKey:@"orderId"];
    [params setObject:@(channelId) forKey:@"channelId"];
    [params setObject:ticket forKey:@"ticket"];
    
    [HttpRequestHelper POST:method params:params success:^(id data) {
//        OrderInfo *orderInfo = [OrderInfo yy_modelWithDictionary:data];
        OrderInfo *orderInfo = [OrderInfo modelDictionary:data];
        if (orderInfo != nil) {
            success(orderInfo);
        } else {
            failure(@(10), @"ticket为空");
        }
    } failure:^(NSNumber *resCode, NSString *message) {
        if (failure) {
            failure(resCode, message);
        }
    }];
}

+ (void)requestOrderList:(UserID)uid success:(void (^)(NSArray *))success failure:(void (^)(NSNumber *, NSString *))failure
{
    NSString *method = @"order/list";
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:@(uid) forKey:@"uid"];
    [params setObject:@(1) forKey:@"type"];
    
    [HttpRequestHelper GET:method params:params success:^(id data) {
//        NSArray *orderList = [NSArray yy_modelArrayWithClass:[OrderInfo class] json:data];
        NSArray *orderList = [OrderInfo modelsWithArray:data];
        success(orderList);
    } failure:^(NSNumber *resCode, NSString *message) {
        if (failure) {
            failure(resCode, message);
        }
    }];
}

+ (void)requestFinishOrder:(NSString *)orderId success:(void (^)(void))success failure:(void (^)(NSNumber *, NSString *))failure
{
    NSString *method = @"order/finish";
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    NSString *ticket = [GetCore(AuthCore) getTicket];
    UserID uid = [GetCore(AuthCore) getUid].userIDValue;
    [params setObject:@(uid) forKey:@"uid"];
    [params setObject:ticket forKey:@"ticket"];
    [params setObject:orderId forKey:@"orderId"];
    
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

+ (void)requestOrder:(NSString *)orderID success:(void (^)(OrderInfo *orderInfo))success failure:(void (^)(NSNumber *resCode, NSString *message))failure {
    
    NSString *method = @"order/get";
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:orderID forKey:@"orderId"];
    
    [HttpRequestHelper GET:method params:params success:^(id data) {
//        OrderInfo *orderInfo = [OrderInfo yy_modelWithDictionary:data];
        OrderInfo *orderInfo = [OrderInfo modelDictionary:data];
        success(orderInfo);
    } failure:^(NSNumber *resCode, NSString *message) {
        failure(resCode, message);
    }];
}

@end
