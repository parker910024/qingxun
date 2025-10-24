//
//  HttpRequestHelper+HeadWear.h
//  BberryCore
//
//  Created by Macx on 2018/5/10.
//  Copyright © 2018年 chenran. All rights reserved.
//

#import "HttpRequestHelper.h"
#import "UserHeadWear.h"

@interface HttpRequestHelper (HeadWear)

/**
 获取头饰商城列表
 
 @param success 成功
 @param failure 失败
 */
+ (void)getHeadwearListWithPageSize:(NSString *)pageSize page:(NSString *)page uid:(UserID)uid Success:(void (^)(NSArray *))success failure:(void (^)(NSNumber *, NSString *))failure;


/**
 使用头饰
 
 @param headwearId 头饰ID
 @param success 成功
 @param failure 失败
 */
+ (void)userHeadwearByHeadwearId:(NSString *)headwearId Success:(void (^)(BOOL))success failure:(void (^)(NSNumber *, NSString *))failure;

/**
 购买头饰
 
 @param headwearId 头饰ID
 @param type 1.购买 2.续费
 @param success 成功
 @param failure 失败
 */
+ (void)buyOrRenewHeadwearByHeadwearId:(NSString *)headwearId type:(NSInteger)type Success:(void (^)(BOOL))success failure:(void (^)(NSNumber *, NSString *))failure;


/**
 获取头饰详情
 
 @param headwearId 头饰ID
 @param success 成功
 @param failure 失败
 */
+ (void)getHeadwearDetailWithHeadwearId:(NSString *)headwearId Success:(void (^)(UserHeadWear *))success failure:(void (^)(NSNumber *, NSString *))failure;

/**
 获取用户的头饰列表
 @param uid     用户id
 @param success 成功
 @param failure 失败
 */
+ (void)getUserHeadwearList:(NSString *)uid
               success:(void (^)(NSArray *))success
               failure:(void (^)(NSNumber *, NSString *))failure;

/**
 赠送头饰
 @param uid     赠送的用户id
 @param targetUid     被赠送的用户id
 @param headwearId     头饰id
 @param success 成功
 @param failure 失败
 */
+ (void)presentHeadwearFromUid:(NSString *)uid
                   toTargetUid:(UserID)targetUid
                withHeadwearId:(NSString *)headwearId
                       success:(void (^)(BOOL))success
                       failure:(void (^)(NSNumber *, NSString *))failure;
/**
 获取我的头饰账单

 @param success 成功
 @param failure 失败
 */
+ (void)getHeadwearBillListWithPageSize:(NSString *)pageSize page:(NSString *)page Success:(void (^)(NSArray *))success failure:(void (^)(NSNumber *, NSString *))failure;



// ***********  2019-03-25 公会线添加  v2 版本接口(赠送，购买) *************/

/**
 v2 版购买头饰接口
 interface /headwear/v2/buy

 @param headwearID 头饰 id
 @param currencyType 支付货币类型：0金币，1萝卜
 @param success 成功
 @param failure 失败
 */
+ (void)buyHeadwearWithHeadwearID:(NSString *)headwearID
                     currencyType:(BuyGoodsType)currencyType
                          Success:(void (^)(BOOL))success
                          failure:(void (^)(NSNumber *, NSString *))failure;

/**
 赠送头饰
 @param targetUid     被赠送的用户id
 @param headwearId     头饰id
 @param currencyType 支付货币类型：0金币，1萝卜
 @param success 成功
 @param failure 失败
 */
+ (void)presentHeadwearWithHeadwearId:(NSString *)headwearId
                          toTargetUid:(UserID)targetUid
                         currencyType:(BuyGoodsType)currencyType
                              success:(void (^)(BOOL))success
                              failure:(void (^)(NSNumber *, NSString *))failure;

@end
