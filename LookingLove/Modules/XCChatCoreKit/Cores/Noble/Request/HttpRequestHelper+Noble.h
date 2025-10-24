//
//  HttpRequestHelper+Noble.h
//  BberryCore
//
//  Created by Mac on 2018/1/18.
//  Copyright © 2018年 chenran. All rights reserved.
//

#import "HttpRequestHelper.h"


typedef enum : NSUInteger {
    OrderNoble_Buy = 1,
    OrderNoble_Renew = 2,
} OrderNobleType;


@interface HttpRequestHelper (Noble)
/*
查询房间贵族列表
roomUid:房主uid
 http://beta.erbanyy.com/noble/room/user/get?roomUid=xxxx
*/
+ (void)requestRoomNobleUserList:(NSString *)roomUid
                         success:(void (^)(NSArray *list))success
                         failure:(void (^)(NSNumber *resCode, NSString *message))failure;


/*
 请求购买贵族订单
 nobleId:      贵族的id
 nobleOptType: 1购买。 2续费
 */
+ (void)requestNobleOrderByNobleId:(NSNumber *)nobleId
                      nobleOptType:(OrderNobleType)nobleOptType
                           success:(void (^)(NSString *))success
                           failure:(void (^)(NSNumber *, NSString *))failure;

/**
 贵族苹果内购二次验证
 
 @param receipt 购买成功同步返回的收据数据
 @param success 成功
 @param failure 失败
 */
+ (void)checkReceiptWithReceipt:(NSData *)receipt
                  nobleRecordId:(NSString *)nobleRecordId
                  transcationId:(NSString *)transcationId
                        success:(void (^)(NSString *orderStatus))success
                        failure:(void(^)(NSNumber *resCode, NSString *message))failure;

@end
