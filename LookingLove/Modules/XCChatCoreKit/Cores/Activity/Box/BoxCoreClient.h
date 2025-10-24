//
//  BoxCoreClient.h
//  BberryCore
//
//  Created by KevinWang on 2018/7/16.
//  Copyright © 2018年 YiZhuan. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "BoxKeyInfoModel.h"
#import "BoxConfigInfo.h"
#import "BoxCirtData.h"
#import "BoxOpenInfo.h"
#import <NIMSDK/NIMSDK.h>

@protocol BoxCoreClient <NSObject>

@optional
//获取钥匙信息
- (void)onGetKeysInfoSuccess:(BoxKeyInfoModel *)info;
- (void)onGetKeysInfoFailth:(NSString *)message;

//购买钥匙
- (void)onbuyBoxKeysType:(XCBoxBuyKeyType)type success:(int)keyNum;
- (void)onbuyBoxKeysType:(XCBoxBuyKeyType)type Failth:(NSString *)message;
- (void)onBoxKeysUpdate;

//开奖
- (void)onOpenBoxByKeyType:(XCBoxOpenBoxType)type success:(NSArray *)boxPrizes;
- (void)onOpenBoxByKeyType:(XCBoxOpenBoxType)type failth:(NSString *)message;

//中奖纪录
- (void)onGetBoxDrawRecordByState:(int)state success:(NSArray *)boxDrawRecord;
- (void)onGetBoxDrawRecordByState:(int)state failth:(NSString *)message;

//获取背景，规则图片
- (void)onGetBoxConfigSourceSuccess:(BoxConfigInfo *)configInfo;
- (void)onGetBoxConfigSourceFailth:(NSString *)message;

//获取奖池
- (void)onGetBoxPrizesSuccess:(NSArray *)boxPrizes;
- (void)onGetBoxPrizesFailth:(NSString *)message;

//获取奖池概率
- (void)onGetBoxPrizeProbabilitySuccess:(NSArray *)boxPrizes;
- (void)onGetBoxPrizeProbabilityFailth:(NSString *)message;

/*  ---------------------------------------开箱子暴击------------------------------------------------  */

/**
 获取暴击活动数据
 */
- (void)onGetBoxCritActivityDataSuccess:(BoxCirtData *)cirtData;
- (void)onGetBoxCritActivityDataFailth:(NSString *)message;

//暴击活动状态改变
- (void)boxCirtActivityStatusUpdate:(NSUInteger)status msg:(NIMMessage *)msg;

/*  --------------------------------------- 钻石宝箱 ------------------------------------------------  */
// 购买钥匙
- (void)onGetDiamondBoxKeysInfoSuccess:(BoxKeyInfoModel *)info;
- (void)onGetDiamondBoxKeysInfoFailth:(NSString *)message;

// 购买钥匙
- (void)onbuyDiamondBoxKeysType:(XCBoxBuyKeyType)type success:(int)keyNum;
- (void)onbuyDiamondBoxKeysType:(XCBoxBuyKeyType)type Failth:(NSString *)message;
- (void)onDiamondBoxKeysUpdate;

//开奖
- (void)onOpenDiamondBoxByKeyType:(XCBoxOpenBoxType)type success:(NSArray *)boxPrizes;
- (void)onOpenDiamondBoxByKeyType:(XCBoxOpenBoxType)type failth:(NSString *)message;

// 获取奖池
- (void)onGetDiamondBoxPrizesSuccess:(NSArray *)boxPrizes;
- (void)onGetDiamondBoxPrizesFailth:(NSString *)message;

// 开箱子活动信息获取
- (void)onGetBoxOpenActivityData:(XCBoxType)type success:(BoxOpenInfo *)openBoxInfo;
- (void)onGetBoxOpenActivityData:(XCBoxType)type failth:(NSString *)message;

// 获取能量值
- (void)onGetBoxOpenEnergy:(int)value;

@end
