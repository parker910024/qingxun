//
//  BalanceInfo.h
//  BberryCore
//
//  Created by chenran on 2017/7/8.
//  Copyright © 2017年 chenran. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseObject.h"

typedef NS_ENUM(NSInteger ,XCPaymentStatus) {
    XCPaymentStatusPurchasing,//付款中
    XCPaymentStatusPurchased, //付款操作已经完成
    XCPaymentStatusFailed, //付款操作失败
    XCPaymentStatusDeferred, //未知状态
};


typedef enum : NSUInteger {
    ApplyRechargeType_IAP,//内购
    ApplyRechargeType_Shop,//商城
} ApplyRechargeType;

typedef enum : NSUInteger {
    ShopProductType_Car = 1,//座驾
    ShopProductType_HeadWear,//头饰
    ShopProductType_RoomBg,//房间背景
} ShopProductType;

@interface BalanceInfo : BaseObject
/// 用户 uid
@property(nonatomic, assign)UserID uid;
/// 金币数量
@property(nonatomic, copy)NSString *goldNum;
@property(nonatomic, copy)NSString *chargeGoldNum;
/// 贵族金币数量
@property(nonatomic, copy)NSString *nobleGoldNum;

@property(nonatomic, assign)NSInteger amount;
/// 钻石数量
@property(nonatomic, assign) double diamondNum;

@property(nonatomic, copy)NSString *depositNum;
/// 是否有金币转增功能
@property (nonatomic, assign) BOOL sendGold;
@end
