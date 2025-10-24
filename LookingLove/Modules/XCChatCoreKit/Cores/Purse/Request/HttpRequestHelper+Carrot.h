//
//  HttpRequestHelper+Carrot.h
//  AFNetworking
//
//  Created by lee on 2019/3/26.
//

#import "HttpRequestHelper.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^HttpResponseHelperCarrotCompletionHandler)(id _Nullable resultObject, NSNumber * _Nullable code, NSString * _Nullable msg);

@interface HttpRequestHelper (Carrot)
#pragma mark -
#pragma mark 公会线添加 2019年03月26日

/**
 获取钱包萝卜数
 
 @param currencyType 货币类型，1：萝卜 0：金币
 @param completionHandler 成功回调
 */
+ (void)requestCarrotWalletWithType:(NSInteger)currencyType andCompletionBlock:(HttpResponseHelperCarrotCompletionHandler)completionHandler;

/// 用户是否是第一次充值
+ (void)requestUserIsFirstRechargeAndCompletionBlock:(HttpResponseHelperCarrotCompletionHandler)completionHandler;
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
                         pageSize:(NSInteger)pageSize andCompletionBlock:(HttpResponseHelperCarrotCompletionHandler)completionHandler;

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
                         pageSize:(NSInteger)pageSize andCompletionBlock:(HttpResponseHelperCarrotCompletionHandler)completionHandler;
@end

NS_ASSUME_NONNULL_END
