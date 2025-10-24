//
//  HttpRequestHelper+DiamondBox.m
//  XCChatCoreKit
//
//  Created by JarvisZeng on 2019/5/10.
//  Copyright © 2019 YiZhuan. All rights reserved.
//

#import "HttpRequestHelper+DiamondBox.h"
#import "AuthCore.h"
#import "ImRoomCoreV2.h"
#import "BoxCore.h"
#import "BoxCoreClient.h"
#import "PurseCore.h"


@implementation HttpRequestHelper (DiamondBox)

/*
 获取钻石钥匙数量与价格
 */
+ (void)requestDiamondBoxKeysInfoSuccess:(void (^)(BoxKeyInfoModel *keyInfo))success
                                 failure:(void (^)(NSNumber *resCode, NSString *message))failure {
    
    NSString *method = @"box/diamond/userkey";
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
 购买钻石钥匙
 keysNum: 钥匙数
 */
+ (void)requestBuyDiamondBoxKeysByKey:(int)keyNum
                           success:(void (^)(NSDictionary *info))success
                           failure:(void (^)(NSNumber *resCode, NSString *message))failure {
    NSString *method = @"box/diamond/buykey";
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
 钻石宝箱开奖
 keysNum: 钥匙数
 sendMessage: 是否需要发送消息
 */
+ (void)requestOpenDiamondBoxByKey:(int)keyNum
                       sendMessage:(BOOL)sendMessage
                           success:(void (^)(NSArray<BoxPrizeModel *> *boxPrizes))success
                           failure:(void (^)(NSNumber *resCode, NSString *message))failure {
    NSString *method = @"box/diamond/draw";
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params safeSetObject:GetCore(AuthCore).getUid forKey:@"uid"];
    [params safeSetObject:@(keyNum) forKey:@"keyNum"];
    [params safeSetObject:@(sendMessage) forKey:@"sendMessage"];
    [params safeSetObject:@(GetCore(ImRoomCoreV2).currentRoomInfo.uid) forKey:@"roomUid"];
    [HttpRequestHelper POST:method params:params success:^(id data) {
        if ([data isKindOfClass:[NSDictionary class]]) {
            NSArray *infos = [BoxPrizeModel modelsWithArray:data[@"prizeItemList"]];
            GetCore(BoxCore).keyInfo.keyNum = [data[@"remainKeyNum"] intValue];
            int energyValue = [data[@"spendGold"] intValue];
            NotifyCoreClient(BoxCoreClient, @selector(onGetBoxOpenEnergy:), onGetBoxOpenEnergy:energyValue);
            success(infos);
        }else{
            success(nil);
        }
        
    } failure:^(NSNumber *resCode, NSString *message) {
        failure(resCode, message);
    }];
}

/*
钻石宝箱本期奖池
 */
+ (void)requestDiamondBoxPrizesSuccess:(void (^)(NSArray<BoxPrizeModel *> *boxPrizes))success
                               failure:(void (^)(NSNumber *resCode, NSString *message))failure {
    
    NSString *method = @"box/diamond/prizes/withRate";
    [HttpRequestHelper GET:method params:nil success:^(id data) {
        NSArray *infos = [BoxPrizeModel modelsWithArray:data];
        success(infos);
    } failure:^(NSNumber *resCode, NSString *message) {
        failure(resCode, message);
    }];
}


@end
