//
//  CarCore.h
//  BberryCore
//
//  Created by 卫明何 on 2018/3/1.
//  Copyright © 2018年 chenran. All rights reserved.
//

#import "BaseCore.h"
#import "UserCar.h"


static const NSString * kDressNewMessageReadKey = @"kDressNewMessageReadKey";

@interface CarCore : BaseCore

@property(nonatomic, assign)BOOL hasNewCarOrder;

/**
 请求商城座驾列表
 
 @param page 页码
 @param pageSize 每页数量
 */
- (void)requestCarListByPage:(NSString *)page pageSize:(NSString *)pageSize state:(int)state;

/**
 请求车库座驾列表
 */
- (void)requestUserCar:(UserCarPlaceType)placeType uid:(NSString *)uid;

/**
 购买座驾
 
 @param carId 座驾Id
 @return complete就是成功 error就是失败
 */
- (RACSignal *)buyCarByCarId:(NSString *)carId;


/**
 使用座驾（CarId传0则不适用座驾）
 
 @param carId 座驾Id
 */
- (void)userCarByCarId:(NSString *)carId;

/**
 使用座驾（CarId传0则不适用座驾）
 
 @param carId 座驾Id
 */
- (void)userCarByCarId:(NSString *)carId andUserCar:(UserCar *)userCar;

/**
 赠送座驾
 
 @param carId 座驾Id
 @param targetUid 被赠送者Id
 @return complete就是成功 error就是失败
 */
- (RACSignal *)presentCarByCarId:(NSString *)carId targetUid:(UserID)targetUid;

/**
 获取座驾详情
 
 @param carId 座驾Id
 @return 包含座驾详情模型的signal
 */
- (RACSignal *)getCarDetailByCarId:(NSString *)carId;


- (void)requestInAppPurseProductAndBuy:(NSString *)productID;

#pragma mark -
#pragma mark v2 版本
// ***********  2019-03-25 公会线添加  v2 版本接口(赠送，购买) *************/

/**
 购买座驾 v2 ，
 interface /car/pay/v2/buy

 @param carId 座驾id
 @param currencyType 支付货币类型：0金币，1萝卜
 @return complete就是成功 error就是失败
 */
- (RACSignal *)buyCarByCarId:(NSString *)carId
                currencyType:(BuyGoodsType)currencyType;

/**
 赠送座驾 v2 版本
 interface car/pay/v2/giveCar
 @param carId 座驾id
 @param targetUid 被赠送者 uid
 @param currencyType 支付货币类型：0金币，1萝卜
 @return complete就是成功 error就是失败
 */
- (RACSignal *)presentCarByCarId:(NSString *)carId
                       targetUid:(UserID)targetUid
                    currencyType:(BuyGoodsType)currencyType;

/**
请求铭牌列表

@param page 页码
@param pageSize 每页数量
*/
- (void)requestNameplateListByPage:(NSString *)page pageSize:(NSString *)pageSize state:(int)state;

/**
制作铭牌

@param fixedWord 文案
@param namePlateId 铭牌库id
*/
- (void)requestMakeNameplate:(NSString *)namePlateId fixedWord:(NSString *)fixedWord;

/**
使用/摘下铭牌

@param used 操作(0 -- 摘下, 1 -- 使用)
@param namePlateId 铭牌库id
*/
- (void)requestUseNameplate:(NSString *)namePlateId used:(NSInteger)used;


@end
