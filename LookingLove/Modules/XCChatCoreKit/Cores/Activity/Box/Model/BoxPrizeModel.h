//
//  BoxPrizeModel.h
//  BberryCore
//
//  Created by KevinWang on 2018/7/16.
//  Copyright © 2018年 YiZhuan. All rights reserved.
//

#import "BaseObject.h"

typedef enum : NSUInteger {
    BoxPrizeLevelOne=1,
    BoxPrizeLevelTwo,
    BoxPrizeLevelThree,
    BoxPrizeLevelFour,
} BoxPrizeLevel;

//奖品类型。1-萌币，2-礼物，3-座驾，4-头饰，5-背景，6-实物，7-靓号，8-全麦礼物
typedef NS_ENUM(NSUInteger, BoxPrizeType) {
    BoxPrizeType_Gold = 1,
    BoxPrizeType_Gift,
    BoxPrizeType_Car,
    BoxPrizeType_Headwear,
    BoxPrizeType_Background,
    BoxPrizeType_Matter,
    BoxPrizeType_Beautif,
    BoxPrizeType_WholeServer
    
};

@interface BoxPrizeModel : BaseObject

@property (nonatomic, copy) NSString *prizeName;//奖品名称
@property (nonatomic, copy) NSString *prizeImgUrl;//奖品icon
@property (nonatomic, assign) BoxPrizeType prizeType;//奖品类型
@property (nonatomic, copy) NSString *prizeTypeDesc;//奖品类型描述
@property (nonatomic, assign) int prizeNum;//奖品数量
@property (nonatomic, assign) CGFloat platformValue;//价格
@property (nonatomic, assign) BoxPrizeLevel prizeLevel;//奖品等级
@property (nonatomic, assign) NSInteger referenceId;//相关实体id
@property (nonatomic, assign) NSInteger prizeId;//奖品id
@property (nonatomic, assign) long createTime;//中奖时间
@property (nonatomic, copy) NSString * showRate;//中奖概率
@property (nonatomic, assign,getter=isTriggerCrit) BOOL triggerCrit;//是否触发暴击
@property (nonatomic, assign,getter=isTriggerEnergy) BOOL triggerEnergy;//是否能量礼物
//客户端自己添加属性
@property (nonatomic, copy) NSString *recodeTimeStr;//转换后的时间
@property (nonatomic, assign) BOOL isJackpot;//是否是奖池

@end
