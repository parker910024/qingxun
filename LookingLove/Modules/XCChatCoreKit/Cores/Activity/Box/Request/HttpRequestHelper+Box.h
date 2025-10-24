//
//  HttpRequestHelper+Box.h
//  BberryCore
//
//  Created by KevinWang on 2018/7/16.
//  Copyright © 2018年 chenran. All rights reserved.
//

#import "HttpRequestHelper.h"
#import "BoxKeyInfoModel.h"
#import "BoxPrizeModel.h"
#import "BoxConfigInfo.h"
#import "BoxCirtData.h"
#import "BoxOpenInfo.h"

@interface HttpRequestHelper (Box)

/*
 获取钥匙数量与价格
 */
+ (void)requestBoxKeysInfoSuccess:(void (^)(BoxKeyInfoModel *keyInfo))success
                       failure:(void (^)(NSNumber *resCode, NSString *message))failure;



/*
 购买钥匙
 keysNum: 钥匙数
 */
+ (void)requestBuyBoxKeysByKey:(int)keyNum
                        success:(void (^)(NSDictionary *info))success
                       failure:(void (^)(NSNumber *resCode, NSString *message))failure;

/*
 开奖
 keysNum: 钥匙数
 sendMessage: 是否需要发送消息
 */
+ (void)requestOpenBoxByKey:(int)keyNum
                sendMessage:(BOOL)sendMessage
                    success:(void (^)(NSArray<BoxPrizeModel *> *boxPrizes))success
                    failure:(void (^)(NSNumber *resCode, NSString *message))failure;

/*
 中奖纪录
 page: 页数
 sortType：排序类型
 */
+ (void)requestBoxDrawRecordByPage:(int)page
                           sortType:(BoxDrawRecordSortType)sortType
                            success:(void (^)(NSArray<BoxPrizeModel *> *boxDrawRecords))success
                            failure:(void (^)(NSNumber *resCode, NSString *message))failure;

/*
 获取背景，规则图片
 */
+ (void)requestBoxConfigSourceSuccess:(void (^)(BoxConfigInfo *configInfo))success
                      failure:(void (^)(NSNumber *resCode, NSString *message))failure;

/*
 获取奖池
 */
+ (void)requestBoxPrizesSuccess:(void (^)(NSArray<BoxPrizeModel *> *boxPrizes))success
                        failure:(void (^)(NSNumber *resCode, NSString *message))failure;

/*  ---------------------------------------萌声 宝箱 2.0------------------------------------------------  */

/*
 根据房间 获取奖池
 */
+ (void)requestBoxPrizesV2Success:(void (^)(NSArray<BoxPrizeModel *> *boxPrizes))success
                        failure:(void (^)(NSNumber *resCode, NSString *message))failure;
/*
 开奖
 keysNum: 钥匙数
 sendMessage: 是否需要发送消息
 isInRoom:是否在房间开宝箱,如果不是在房间则不需要传房间id
 */
+ (void)requestOpenBoxV2ByKey:(int)keyNum
                  sendMessage:(BOOL)sendMessage
                     isInRoom:(BOOL)isInRoom
                      success:(void (^)(NSArray<BoxPrizeModel *> *boxPrizes))success
                      failure:(void (^)(NSNumber *resCode, NSString *message))failure;

/*
 获取奖池概率
 */
+ (void)requestBoxPrizesProbabilitySuccess:(void (^)(NSArray<BoxPrizeModel *> *boxPrizes))success
                        failure:(void (^)(NSNumber *resCode, NSString *message))failure;


/*  ---------------------------------------开箱子暴击------------------------------------------------  */

/**
 获取暴击活动数据

 @param success 成功
 @param failure 失败
 */
+ (void)requestBoxCritActivityDataSuccess:(void (^)(BoxCirtData *cirtData))success
                              failure:(void (^)(NSNumber *resCode, NSString *message))failure;

/*  ---------------------------------------开箱子暴击/能量值------------------------------------------------  */

/**
 获取开箱子活动的暴击，能量值信息
 @param success 成功
 @param failure 失败
 */
+ (void)requestBoxActivityDataByBoxType:(XCBoxType)type
                                Success:(void (^)(BoxOpenInfo *boxOpenInfo))success
                                failure:(void (^)(NSNumber *resCode, NSString *message))failure;
@end
