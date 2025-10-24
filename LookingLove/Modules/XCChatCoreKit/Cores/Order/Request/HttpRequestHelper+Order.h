//
//  HttpRequestHelper+Order.h
//  BberryCore
//
//  Created by chenran on 2017/6/21.
//  Copyright © 2017年 chenran. All rights reserved.
//

#import "HttpRequestHelper.h"
#import "OrderInfo.h"
@interface HttpRequestHelper (Order)
+ (void)requestOrderService:(NSString *)orderId uid:(UserID)uid channelId:(UInt64)channelId
                    success:(void (^)(OrderInfo *))success
                    failure:(void (^)(NSNumber *resCode, NSString *message))failure;

+ (void)requestOrderList:(UserID)uid
                 success:(void (^)(NSArray *orderList))success
                 failure:(void (^)(NSNumber *resCode, NSString *message))failure;

+ (void)requestFinishOrder:(NSString *)orderId
                   success:(void (^)(void))success
                   failure:(void (^)(NSNumber *resCode, NSString *message))failure;

/**
 查询订单详情

 @param orderID orderID
 @param success 成功
 @param failure 失败
 */
+ (void)requestOrder:(NSString *)orderID
             success:(void (^)(OrderInfo *orderInfo))success
             failure:(void (^)(NSNumber *resCode, NSString *message))failure;
@end
