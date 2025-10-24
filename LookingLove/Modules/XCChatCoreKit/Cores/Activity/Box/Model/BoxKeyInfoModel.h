//
//  BoxKeyInfoModel.h
//  BberryCore
//
//  Created by KevinWang on 2018/7/16.
//  Copyright © 2018年 chenran. All rights reserved.
//

#import "BaseObject.h"

typedef enum : NSUInteger {
    BoxDrawRecordSortTypeTime, //时间排序
    BoxDrawRecordSortTypeWorth,//价值排序
} BoxDrawRecordSortType;


typedef enum : NSUInteger {
    XCBoxBuyKeyType_Buy = 0, //主动购买
    XCBoxBuyKeyType_Need = 1 //缺少钥匙购买
} XCBoxBuyKeyType;


typedef enum : NSUInteger {
    XCBoxOpenBoxType_Auto = 0, //自动开箱子
    XCBoxOpenBoxType_Manual = 1 //手动
} XCBoxOpenBoxType;

@interface BoxKeyInfoModel : BaseObject

@property (nonatomic, assign) int keyNum; //钥匙数
@property (nonatomic, assign) int keyPrice;//钥匙价格

@end
