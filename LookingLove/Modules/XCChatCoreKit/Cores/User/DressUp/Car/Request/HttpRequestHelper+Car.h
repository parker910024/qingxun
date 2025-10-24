//
//  HttpRequestHelper+Car.h
//  BberryCore
//
//  Created by 卫明何 on 2018/3/1.
//  Copyright © 2018年 chenran. All rights reserved.
//

#import "HttpRequestHelper.h"
#import "UserCar.h"

@interface HttpRequestHelper (Car)

/**
 获取车库
 @param uid     用户id
 @param success 成功
 @param failure 失败
 */
+ (void)getUserCarList:(NSString *)uid
               success:(void (^)(NSArray *))success
               failure:(void (^)(NSNumber *, NSString *))failure;


/**
 获取座驾商城列表
 
 @param success 成功
 @param failure 失败
 */
+ (void)getCarListWithPageSize:(NSString *)pageSize page:(NSString *)page Success:(void (^)(NSArray *))success failure:(void (^)(NSNumber *, NSString *))failure;


/**
 使用座驾

 @param carId 座驾ID
 @param success 成功
 @param failure 失败
 */
+ (void)userCarByCarId:(NSString *)carId Success:(void (^)(BOOL))success failure:(void (^)(NSNumber *, NSString *))failure;

/**
 购买座驾

 @param carId 座驾ID
 @param success 成功
 @param failure 失败
 */
+ (void)buyOrRenewCarByCarId:(NSString *)carId Success:(void (^)(BOOL))success failure:(void (^)(NSNumber *, NSString *))failure;




/**
 赠送座驾
 
 @param carId 座驾ID
 @param targetUid 被赠送者Id
 @param success 成功
 @param failure 失败
 */
+ (void)presneteCarByCarId:(NSString *)carId targetUid:(UserID)targetUid Success:(void (^)(BOOL))success failure:(void (^)(NSNumber *, NSString *))failure;


/**
 获取座驾详情

 @param carId 座驾ID
 @param success 成功
 @param failure 失败
 */
+ (void)getCarDetailWithCarid:(NSString *)carId Success:(void (^)(UserCar *))success failure:(void (^)(NSNumber *, NSString *))failure;


/**
 座驾下单
 
 @param chargeProdId 内购ID
 @param success 成功
 @param failure 失败
 */
+ (void)requestInAppRechargeWithChargeProdId:(NSString *)chargeProdId success:(void (^)(BOOL , NSString *))success failure:(void (^)(NSNumber *, NSString *))failure;

#pragma mark -
#pragma mark v2 版本
// ***********  2019-03-25 公会线添加  v2 版本接口(赠送，购买) *************/
/**
 v2 版，购买座驾接口
 interface /car/pay/v2/buy
 
 @param carID 座驾id
 @param currencyType 支付货币类型：0金币，1萝卜
 @param success 成功
 @param failure 失败
 */
+ (void)buyCarWithCarID:(NSString *)carID
           currencyType:(BuyGoodsType)currencyType
                Success:(void (^)(BOOL))success
                failure:(void (^)(NSNumber *, NSString *))failure;


/**
 赠送座驾
 interface car/pay/v2/giveCar
 @param carId 座驾ID
 @param targetUid 被赠送者Id
 @param currencyType 支付货币类型：0金币，1萝卜
 @param success 成功
 @param failure 失败
 */
+ (void)presneteCarByCarId:(NSString *)carId
                 targetUid:(UserID)targetUid
              currencyType:(BuyGoodsType)currencyType
                   Success:(void (^)(BOOL))success
                   failure:(void (^)(NSNumber *, NSString *))failure;

/**
获取铭牌列表

@param success 成功
@param failure 失败
*/
+ (void)getNameplateListWithPageSize:(NSString *)pageSize page:(NSString *)page Success:(void (^)(NSArray *))success failure:(void (^)(NSNumber *, NSString *))failure;

/**
制作铭牌

@param fixedWord 文案
@param namePlateId 铭牌库id
*/
+ (void)getMakeNamePlate:(NSString *)namePlateId fixedWord:(NSString *)fixedWord
                 success:(void (^)(bool))success
                 failure:(void (^)(NSNumber *, NSString *))failure;

/**
使用摘下铭牌

@param used 操作(0 -- 摘下, 1 -- 使用)
@param namePlateId 铭牌库id
*/
+ (void)getUseNamePlate:(NSString *)namePlateId used:(NSInteger)used
                 success:(void (^)(bool))success
                failure:(void (^)(NSNumber *, NSString *))failure;
@end
