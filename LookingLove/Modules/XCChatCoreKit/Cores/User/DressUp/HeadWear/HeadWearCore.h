//
//  HeadWearCore.h
//  BberryCore
//
//  Created by Macx on 2018/5/10.
//  Copyright © 2018年 chenran. All rights reserved.
//

#import "BaseCore.h"
#import "UserHeadWear.h"

@interface HeadWearCore : BaseCore
@property(nonatomic, assign)BOOL hasNewCarOrder;

/**
 请求头饰商城列表
 
 @param page 页码
 @param pageSize 每页数量
 */
- (void)requestHeadwearListByPage:(NSString *)page pageSize:(NSString *)pageSize state:(int)state uid:(UserID)uid;


/**
 请求头饰账单
 @param page 页码
 @param pageSize 每页数量
 */
- (void)requestHeadwearBillByPage:(NSString *)page pageSize:(NSString *)pageSize state:(int)state;




/**
 请求头饰列表
 */
- (void)requestUserHeadwear:(UserHeadwearPlaceType)placeType uid:(NSString *)uid;

/**
 购买头饰
 
 @param headwearId 头饰Id
 @return complete就是成功 error就是失败
 */
- (RACSignal *)buyHeadwearByHeadwearId:(NSString *)headwearId type:(NSInteger)type;




/**
 赠送头饰
 
 @param headwearId 头饰Id
 @param targetUid  被赠送Id
 @return complete就是成功 error就是失败
 */
- (RACSignal *)presentHeadwearByHeadwearId:(NSString *)headwearId toTargetUid:(UserID)targetUid;



/**
 使用头饰（headwearId传0则不适用头饰）
 
 @param headwearId 头饰Id
 */
- (void)userHeadwearByHeadwearId:(NSString *)headwearId;

/**
 使用头饰（headwearId传0则不适用头饰）
 
 @param headwearId 头饰Id
 */
- (void)userHeadwearByHeadwearId:(NSString *)headwearId andHeadWear:(UserHeadWear *)headwear;

/**
 获取头饰详情
 
 @param headwearId 头饰Id
 @return 包含头饰详情模型的signal
 */
- (RACSignal *)getHeadwearDetailByHeadwearId:(NSString *)headwearId;
/**
 购买头饰
 
 @param headwearId 头饰Id
 @return complete就是成功 error就是失败
 */
- (RACSignal *)buyHeadwearByHeadwearId:(NSString *)headwearId headwear:(UserHeadWear *)headerwear type:(NSInteger)type;

#pragma mark -
#pragma mark v2 版本
//***************** 2019年03月25日 公会线添加 v2 版本  ******************/
/**
 购买头饰 v2 版本
 interface headwear/v2/buy

 @param headwearId 头饰id
 @param currencyType 支付货币类型：0金币，1萝卜
 @return complete就是成功 error就是失败

 */
- (RACSignal *)buyHeadwearByHeadwearId:(NSString *)headwearId currencyType:(BuyGoodsType)currencyType;

/**
 赠送头饰 v2 版本
 interface headwear/v2/headwear/donate

 @param headwearId 头饰 id
 @param targetUid 赠送目标 uid
 @param currencyType 支付货币类型：0金币，1萝卜
 @return complete就是成功 error就是失败
 */
- (RACSignal *)presentHeadwearByHeadwearId:(NSString *)headwearId toTargetUid:(UserID)targetUid currencyType:(BuyGoodsType)currencyType;

@end
