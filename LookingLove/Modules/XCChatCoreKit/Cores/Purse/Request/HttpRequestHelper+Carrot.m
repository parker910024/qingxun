//
//  HttpRequestHelper+Carrot.m
//  AFNetworking
//
//  Created by lee on 2019/3/26.
//

#import "HttpRequestHelper+Carrot.h"
#import "AuthCore.h"

@implementation HttpRequestHelper (Carrot)

#pragma mark -
#pragma mark 公会线添加 2019年03月26日

/**
 获取钱包萝卜数
 
 @param currencyType 货币类型，1：萝卜 0：金币
 @param completionHandler 成功回调
 */
+ (void)requestCarrotWalletWithType:(NSInteger)currencyType andCompletionBlock:(HttpResponseHelperCarrotCompletionHandler)completionHandler {
    // 接口路径
    NSString *method = @"wallet/get";
    // 参数
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    [params setObject:GetCore(AuthCore).getUid forKey:@"uid"];
    [params setObject:@(currencyType) forKey:@"currencyType"];
    
    [self carrot_request:method
                  method:HttpRequestHelperMethodGET
                  params:params
              completion:completionHandler];
}

/**
 萝卜礼物记录
 
 @param giftType giftType 1赠送，2收入
 @param time 时间戳
 @param pageNo 页码
 @param pageSize 每页数量
 @param completionHandler 完成回调
 */
+ (void)requestCarrotGiftWityType:(NSInteger)giftType
                             time:(NSString *)time
                           pageNo:(NSInteger)pageNo
                         pageSize:(NSInteger)pageSize andCompletionBlock:(HttpResponseHelperCarrotCompletionHandler)completionHandler {
    // 接口路径
    NSString *method = @"gift/radish/record/get";
    // 参数
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    [params setObject:GetCore(AuthCore).getUid forKey:@"uid"];
    [params setObject:time forKey:@"date"];
    [params setObject:@(pageNo) forKey:@"page"];
    [params setObject:@(pageSize) forKey:@"pageSize"];
    [params setObject:@(giftType) forKey:@"type"];
    
    [self carrot_request:method
                  method:HttpRequestHelperMethodGET
                  params:params
              completion:completionHandler];
}

/**
 萝卜账单记录
 
 @param giftType giftType 1赠送，2收入
 @param time 时间戳
 @param pageNo 页码
 @param pageSize 每页数量
 @param completionHandler 完成回调
 */
+ (void)requestCarrotGiftBillWityType:(NSInteger)giftType
                                 time:(NSString *)time
                               pageNo:(NSInteger)pageNo
                             pageSize:(NSInteger)pageSize andCompletionBlock:(HttpResponseHelperCarrotCompletionHandler)completionHandler {
    // 接口路径
    NSString *method = @"radish/bill/record/get";
    // 参数
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    [params setObject:GetCore(AuthCore).getUid forKey:@"uid"];
    [params setObject:time forKey:@"date"];
    [params setObject:@(pageNo) forKey:@"page"];
    [params setObject:@(pageSize) forKey:@"pageSize"];
    [params setObject:@(giftType) forKey:@"type"];
    
    [self carrot_request:method
                  method:HttpRequestHelperMethodGET
                  params:params
              completion:completionHandler];
}

/// 用户是否是第一次充值
+ (void)requestUserIsFirstRechargeAndCompletionBlock:(HttpResponseHelperCarrotCompletionHandler)completionHandler {
    NSString *method = @"/chargeRecord/isFirstCharge";

    [self carrot_request:method
                  method:HttpRequestHelperMethodGET
                  params:nil
              completion:completionHandler];
}


#pragma mark - Private Methods
+ (void)carrot_request:(NSString *)url
               method:(HttpRequestHelperMethod)method
               params:(NSDictionary *)params
           completion:(HttpResponseHelperCarrotCompletionHandler)completionHandler
{
    if ([url hasPrefix:@"/"]) {
        url = [url substringFromIndex:1];
    }
    
    [self request:url method:method params:params success:^(id data) {
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
