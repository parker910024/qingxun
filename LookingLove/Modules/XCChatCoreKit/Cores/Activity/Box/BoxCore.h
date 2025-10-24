//
//  BoxCore.h
//  BberryCore
//
//  Created by KevinWang on 2018/7/16.
//  Copyright © 2018年 YiZhuan. All rights reserved.
//

#import "BaseCore.h"
#import "BoxKeyInfoModel.h"
#import "BoxPrizeModel.h"
#import "BoxConfigInfo.h"
#import "BoxCirtData.h"
#import "BoxOpenInfo.h"

@interface BoxCore : BaseCore

@property (nonatomic, strong) BoxKeyInfoModel *keyInfo; //钥匙信息
@property (nonatomic, strong) BoxConfigInfo *configInfo;
@property (nonatomic, strong) NSArray<BoxPrizeModel *> *boxPrizes;//奖池
@property (nonatomic, strong) NSArray<BoxPrizeModel *> *diamondBoxPrizes;//奖池

/**
 暴击活动状态
 */
@property (nonatomic, assign) BoxCirtActivityStatus activityStatus;

/*
 获取钥匙数量与价格
 */
- (void)getBoxKeysInfo;

/*
 购买钥匙
 keysNum: 钥匙数
 type: 0, 主动购买  1,缺少钥匙购买
 */
- (void)buyBoxKeysByKey:(int)keyNum type:(XCBoxBuyKeyType)type;

/*
 开奖
 keysNum: 钥匙数
 sendMessage: 是否需要发送消息
 type:手动or自动开箱子
 */
- (void)openBoxByKey:(int)keyNum sendMessage:(BOOL)sendMessage type:(XCBoxOpenBoxType)type;

/*
 中奖纪录
 state:0 结束头部刷新。  1 结束底部刷新
 page: 页数
 sortType：排序类型
 */
- (void)getBoxDrawRecordByState:(int)state page:(int)page sortType:(BoxDrawRecordSortType)sortType;

/*
 获取背景，规则图片
 */
- (void)getBoxConfigSource;

/*
 获取奖池
 */
- (void)getBoxPrizes;

/*
 清空背景，规则图片缓存
 */
- (void)clearBoxConfigSource;


/*  ---------------------------------------萌声 宝箱 2.0------------------------------------------------  */

/*
 开奖
 keysNum: 钥匙数
 sendMessage: 是否需要发送消息
 type:手动or自动开箱子
 isInRoom:是否在房间开宝箱,如果不是在房间则不需要传房间id
 */
- (void)openBoxV2ByKey:(int)keyNum sendMessage:(BOOL)sendMessage type:(XCBoxOpenBoxType)type isInRoom:(BOOL)isInRoom;
/*
 获取奖池
 */
- (void)getBoxPrizesV2;

/*
 获取奖池概率
 */
- (void)getBoxPrizesV2Probability;


/*  ---------------------------------------开箱子暴击------------------------------------------------  */

/**
 获取暴击活动数据
 */
- (void)getBoxCritActivityData;

/*  --------------------------------------- 钻石宝箱 ------------------------------------------------  */

/*
 获取钻石宝箱钥匙数量与价格
 */
- (void)getDiamondBoxKeysInfo;

/*
 购买钻石宝箱钥匙
 keysNum: 钥匙数
 */
- (void)buyDiamondBoxKeysByKey:(int)keyNum type:(XCBoxBuyKeyType)type;

/*
 钻石宝箱开奖
 keysNum: 钥匙数
 sendMessage: 是否需要发送消息
 type:手动or自动开箱子
 */
- (void)openDiamondBoxByKey:(int)keyNum sendMessage:(BOOL)sendMessage type:(XCBoxOpenBoxType)type;

/*
 获取钻石宝箱奖池
 */
- (void)getDiamondBoxPrizes;

/*
 获取钻石宝箱活动状态
 */
- (void)getDiamondBoxActivityStatus;

/*  ---------------------------------------开箱子暴击/能量值------------------------------------------------  */

/*
 获取开箱子活数据
 */
- (void)getBoxOpenActivityDataByBoxType:(XCBoxType)type;
@end
 
