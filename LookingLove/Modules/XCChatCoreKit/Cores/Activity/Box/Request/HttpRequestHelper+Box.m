//
//  HttpRequestHelper+Box.m
//  BberryCore
//
//  Created by KevinWang on 2018/7/16.
//  Copyright © 2018年 YiZhuan. All rights reserved.
//

#import "HttpRequestHelper+Box.h"
#import "AuthCore.h"
#import "ImRoomCoreV2.h"
#import "BoxCore.h"
#import "BoxCoreClient.h"
#import "PurseCore.h"

@implementation HttpRequestHelper (Box)

/*
 获取钥匙数量与价格
 */
+ (void)requestBoxKeysInfoSuccess:(void (^)(BoxKeyInfoModel *keyInfo))success
                          failure:(void (^)(NSNumber *resCode, NSString *message))failure {
    
    NSString *method = @"box/userkey";
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params safeSetObject:GetCore(AuthCore).getUid forKey:@"uid"];

    [HttpRequestHelper GET:method params:params success:^(id data) {
        BoxKeyInfoModel *info = [BoxKeyInfoModel modelWithJSON:data];
        success(info);
    } failure:^(NSNumber *resCode, NSString *message) {
        failure(resCode, message);
    }];
}

/*
 购买钥匙
 keysNum: 钥匙数
 */
+ (void)requestBuyBoxKeysByKey:(int)keyNum
                       success:(void (^)(NSDictionary *info))success
                       failure:(void (^)(NSNumber *resCode, NSString *message))failure{
    NSString *method = @"box/buykey";
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params safeSetObject:GetCore(AuthCore).getUid forKey:@"uid"];
    [params safeSetObject:@(keyNum) forKey:@"keyNum"];
    [HttpRequestHelper POST:method params:params success:^(id data) {
        NSLog(@"%@",data);
        success((NSDictionary *)data);
    } failure:^(NSNumber *resCode, NSString *message) {
        failure(resCode, message);
    }];
}

/*
 开奖
 keysNum: 钥匙数
 sendMessage: 是否需要发送消息
 */
+ (void)requestOpenBoxByKey:(int)keyNum
                sendMessage:(BOOL)sendMessage
                    success:(void (^)(NSArray<BoxPrizeModel *> *boxPrizes))success
                    failure:(void (^)(NSNumber *resCode, NSString *message))failure{
    NSString *method = @"box/draw";
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params safeSetObject:GetCore(AuthCore).getUid forKey:@"uid"];
    [params safeSetObject:@(keyNum) forKey:@"keyNum"];
    [params safeSetObject:@(sendMessage) forKey:@"sendMessage"];
    [params safeSetObject:@(GetCore(ImRoomCoreV2).currentRoomInfo.uid) forKey:@"roomUid"];
    [HttpRequestHelper POST:method params:params success:^(id data) {
        if ([data isKindOfClass:[NSDictionary class]]) {
            NSArray *infos = [BoxPrizeModel modelsWithArray:data[@"prizeItemList"]];
            int energyValue = [data[@"spendGold"] intValue];
            NotifyCoreClient(BoxCoreClient, @selector(onGetBoxOpenEnergy:), onGetBoxOpenEnergy:energyValue);
            GetCore(BoxCore).keyInfo.keyNum = [data[@"remainKeyNum"] intValue];
            success(infos);
        }else{
            success(nil);
        }
        
    } failure:^(NSNumber *resCode, NSString *message) {
        failure(resCode, message);
    }];
}

/*
 中奖纪录
 page: 页数
 sortType：排序类型
 */
+ (void)requestBoxDrawRecordByPage:(int)page
                          sortType:(BoxDrawRecordSortType)sortType
                           success:(void (^)(NSArray<BoxPrizeModel *> *boxDrawRecords))success
                           failure:(void (^)(NSNumber *resCode, NSString *message))failure{
    NSString *method = @"box/drawrecord";
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params safeSetObject:GetCore(AuthCore).getUid forKey:@"uid"];
    [params safeSetObject:@(page) forKey:@"page"];
    [params safeSetObject:@(50) forKey:@"pageSize"];
    if (sortType == BoxDrawRecordSortTypeTime) {
        [params safeSetObject:@"time" forKey:@"sortType"];
    }else{
        [params safeSetObject:@"worth" forKey:@"sortType"];
    }
    [HttpRequestHelper GET:method params:params success:^(id data) {
        NSArray *infos = [BoxPrizeModel modelsWithArray:data];
        success(infos);
    } failure:^(NSNumber *resCode, NSString *message) {
        failure(resCode, message);
    }];
}

/*
 获取背景，规则图片
 */
+ (void)requestBoxConfigSourceSuccess:(void (^)(BoxConfigInfo *configInfo))success
                      failure:(void (^)(NSNumber *resCode, NSString *message))failure{
    
    NSString *method = @"box/configimgurl";
    [HttpRequestHelper GET:method params:nil success:^(id data) {
        BoxConfigInfo *info = [BoxConfigInfo modelWithJSON:data];
        success(info);
    } failure:^(NSNumber *resCode, NSString *message) {
        failure(resCode, message);
    }];
}

/*
 获取奖池
 */
+ (void)requestBoxPrizesSuccess:(void (^)(NSArray<BoxPrizeModel *> *boxPrizes))success
                        failure:(void (^)(NSNumber *resCode, NSString *message))failure{
    
    NSString *method = @"box/prizes";
    [HttpRequestHelper GET:method params:nil success:^(id data) {
        NSArray *infos = [BoxPrizeModel modelsWithArray:data];
        success(infos);
    } failure:^(NSNumber *resCode, NSString *message) {
        failure(resCode, message);
    }];
}

/*  ---------------------------------------萌声 宝箱 2.0------------------------------------------------  */
/*
 根据房间 获取奖池
 */
+ (void)requestBoxPrizesV2Success:(void (^)(NSArray<BoxPrizeModel *> *boxPrizes))success
                        failure:(void (^)(NSNumber *resCode, NSString *message))failure{
    
    NSString *method = @"box/prizesV2";
    NSMutableDictionary *params = @{}.mutableCopy;
    [params safeSetObject:@(GetCore(ImRoomCoreV2).currentRoomInfo.uid) forKey:@"roomUid"];
    [HttpRequestHelper GET:method params:params success:^(id data) {
        NSArray *infos = [BoxPrizeModel modelsWithArray:data];
        success(infos);
    } failure:^(NSNumber *resCode, NSString *message) {
        failure(resCode, message);
    }];
}


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
                    failure:(void (^)(NSNumber *resCode, NSString *message))failure{
    
    NSString *method = @"box/drawV2";
    if (projectType() == ProjectType_MengSheng || projectType() == ProjectType_BB) {
        method = @"box/drawV3";
    }
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params safeSetObject:GetCore(AuthCore).getUid forKey:@"uid"];
    [params safeSetObject:@(keyNum) forKey:@"keyNum"];
    [params safeSetObject:@(sendMessage) forKey:@"sendMessage"];
    
    if (isInRoom) {
        [params safeSetObject:@(GetCore(ImRoomCoreV2).currentRoomInfo.uid) forKey:@"roomUid"];
    }
    
    [HttpRequestHelper POST:method params:params success:^(id data) {
        if ([data isKindOfClass:[NSDictionary class]]) {
            NSArray *infos = [BoxPrizeModel modelsWithArray:data[@"prizeItemList"]];
            GetCore(BoxCore).keyInfo.keyNum = [data[@"remainKeyNum"] intValue];
            GetCore(PurseCore).balanceInfo.goldNum = [NSString stringWithFormat:@"%@",data[@"goldNum"]];
            success(infos);
        }else{
            success(nil);
        }
        
    } failure:^(NSNumber *resCode, NSString *message) {
        failure(resCode, message);
    }];
}

/*
 获取奖池概率
 */
+ (void)requestBoxPrizesProbabilitySuccess:(void (^)(NSArray<BoxPrizeModel *> *boxPrizes))success
                                   failure:(void (^)(NSNumber *resCode, NSString *message))failure{
    NSString *method = @"box/prizes/withRate";
    [HttpRequestHelper GET:method params:nil success:^(id data) {
        NSArray *infos = [BoxPrizeModel modelsWithArray:data];
        success(infos);
    } failure:^(NSNumber *resCode, NSString *message) {
        failure(resCode, message);
    }];
}


/*  ---------------------------------------开箱子暴击------------------------------------------------  */

/**
 获取暴击活动数据
 
 @param success 成功
 @param failure 失败
 */
+ (void)requestBoxCritActivityDataSuccess:(void (^)(BoxCirtData *cirtData))success
                                  failure:(void (^)(NSNumber *resCode, NSString *message))failure{
    
    NSString *method = @"box/crit/act";
    [HttpRequestHelper GET:method params:nil success:^(id data) {
        BoxCirtData *info = [BoxCirtData modelWithJSON:data];
        success(info);
    } failure:^(NSNumber *resCode, NSString *message) {
        failure(resCode, message);
    }];
}

/*  ---------------------------------------开箱子暴击/能量值------------------------------------------------  */

/**
 获取开箱子活动的暴击，能量值信息
 @param success 成功
 @param failure 失败
 */
+ (void)requestBoxActivityDataByBoxType:(XCBoxType)type
                                Success:(void (^)(BoxOpenInfo *boxOpenInfo))success
                                failure:(void (^)(NSNumber *resCode, NSString *message))failure {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params safeSetObject:GetCore(AuthCore).getUid forKey:@"uid"];
    [params safeSetObject:@(type) forKey:@"type"];
    
    NSString *method = @"box/act";
    [HttpRequestHelper POST:method params:params success:^(id data) {
        BoxOpenInfo *info = [BoxOpenInfo modelWithJSON:data];
        success(info);
    } failure:^(NSNumber *resCode, NSString *message) {
        failure(resCode, message);
    }];
}

@end
