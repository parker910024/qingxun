//
//  DressUpModel.h
//  BberryCore
//
//  Created by Macx on 2018/7/2.
//  Copyright © 2018年 chenran. All rights reserved.
//

#import "BaseObject.h"

typedef enum {
    DressUpLabelType_Not = 0, //无
    DressUpLabelType_New = 1, //新品
    DressUpLabelType_Discount = 2, //折扣
    DressUpLabelType_Limit = 3,//限定
    DressUpLabelType_Exclusive = 4//专属
}DressUpLabelType;


/**
 购买商品使用的货币类型
 
 - Coin: 金币
 - Carrot: 萝卜
 */
typedef NS_ENUM(NSUInteger, BuyGoodsType) {
    /** 金币 */
    Coin = 0,
    /** 萝卜 */
    Carrot = 1,
};

/** 萝卜不足 返回错误码 */
static NSInteger const kNotCarrotCode = 881201;


@interface DressUpModel : BaseObject

@property (nonatomic, copy) NSString *channel;
/** 内购金额*/
@property (nonatomic, copy) NSString *money;


@property (nonatomic, assign) DressUpLabelType  labelType;//标签类型

@property (nonatomic, copy) NSString  *limitDesc;//限定描述
@property (nonatomic, copy) NSString  *redirectLink;//获取链接

@property (nonatomic, copy) NSString  *originalPrice;//原价
@property (nonatomic, copy) NSString  *price;//现价
@property (nonatomic, copy) NSString  *renewPrice;//续费价格

/****** 2019年03月25日 公会线添加萝卜相关属性 *******/
/** 是否支持金币购买 */
@property (nonatomic, assign) BOOL goldSale;
/** 是否支持萝卜购买 */
@property (nonatomic, assign) BOOL radishSale;
/** 萝卜购买价格     */
@property (nonatomic, copy) NSString *radishPrice;
/** 萝卜续费价格     */
@property (nonatomic, copy) NSString *radishRenewPrice;
/** 萝卜原价 */
@property (nonatomic, copy) NSString *radishOriginalPrice;


/** 内购id*/
@property (nonatomic, copy) NSString *chargeProdId;
/** 区分项目*/

/** 拼接好的购买价格字符串 */
@property(nonatomic, copy) NSString *priceStr;

@end
