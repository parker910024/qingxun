//
//  HttpRequestHelper+Rank.m
//  BberryCore
//
//  Created by KevinWang on 2018/7/3.
//  Copyright © 2018年 chenran. All rights reserved.
//

#import "HttpRequestHelper+Rank.h"
#import "ImRoomCoreV2.h"
#import "XCConst.h"


@implementation HttpRequestHelper (Rank)

//贡献榜
+ (void)requestRoomBounsListWithType:(RankType )rankType
                             success:(void (^)(NSDictionary *))success
                             failure:(void (^)(NSNumber *, NSString *))failure {
    
    NSString *method = nil;
    if (rankType == RankType_Send) {
        method = @"room/rankings/summary";
    }else if (rankType == RankType_Receive){
        if (projectType() == ProjectType_TuTu ||
            projectType() == ProjectType_Pudding ||
            projectType() == ProjectType_LookingLove ||
            projectType() == ProjectType_Planet) { // tt
            method = @"room/recive/rankings/summary";
            // 兼容erban旧版本, 使用recive, 新版使用receive, 修改前需要测试
//            method = @"room/receive/rankings/summary";
        } else if (projectType() == ProjectType_MengSheng || projectType() == ProjectType_BB) { // ms
            method = @"room/recive/rankings/summary";
        } else if (projectType() == ProjectType_Haha) { // hh
            method = @"room/receive/rankings/summary";
        }
    }
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    NSString *roomUid = [NSString stringWithFormat:@"%lld",GetCore(ImRoomCoreV2).currentRoomInfo.uid];
    [params setObject:roomUid forKey:@"roomUid"];
    
    [HttpRequestHelper GET:method params:params success:^(id data) {
        NSMutableDictionary *rankDatas = [NSMutableDictionary dictionary];
        //总榜
        NSDictionary *allRankings = data[@"totalRankings"];
        NSArray *allRankList = [RoomBounsListInfo modelsWithArray:allRankings];
        if (allRankList.count > 0) {
            [rankDatas setObject:allRankList forKey:@"totalRankings"];
        }
        
        //周榜
        NSDictionary *weekRankings = data[@"weekRankings"];
        NSArray *weekRankList  = [RoomBounsListInfo modelsWithArray:weekRankings];
        if (weekRankList.count > 0) {
            [rankDatas setObject:weekRankList forKey:@"weekRankings"];
        }
        
        //日榜
        NSDictionary *dayRankings = data[@"dayRankings"];
        NSArray *dayRankList = [RoomBounsListInfo modelsWithArray:dayRankings];
        if (dayRankList.count > 0) {
            [rankDatas setObject:dayRankList forKey:@"dayRankings"];
        }
        success(rankDatas);
        
    } failure:^(NSNumber *resCode, NSString *message) {
        failure(resCode, message);
    }];
}

+ (void)requestRoomRankByRankDataType:(RankDataType)rankDataType
                             rankType:(RankType )rankType
                              roomUid:(NSString *)roomUid
                              Success:(void (^)(NSDictionary *))success
                              failure:(void (^)(NSNumber *, NSString *))failure {
    NSString *method = nil;
    if (rankType == RankType_Send) {
        method = @"room/rankings/summary";
    }else if (rankType == RankType_Receive){
        method = @"room/recive/rankings/summary";
    }
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    [params setObject:roomUid forKey:@"roomUid"];
    
    [HttpRequestHelper GET:method params:params success:^(id data) {
        NSMutableDictionary *rankDatas = [NSMutableDictionary dictionary];
        //总榜
        NSDictionary *allRankings = data[@"totalRankings"];
//        NSArray *allRankList = [NSArray yy_modelArrayWithClass:[RankData class] json:allRankings];
        NSArray *allRankList = [RankData modelsWithArray:allRankings];
        if (allRankList.count > 0) {
            [rankDatas setObject:allRankList forKey:@"totalRankings"];
        }
        
        //周榜
        NSDictionary *weekRankings = data[@"weekRankings"];
//        NSArray *weekRankList  = [NSArray yy_modelArrayWithClass:[RankData class] json:weekRankings];
        NSArray *weekRankList = [RankData modelsWithArray:weekRankings];
        if (weekRankList.count > 0) {
            [rankDatas setObject:weekRankList forKey:@"weekRankings"];
        }
        
        //日榜
        NSDictionary *dayRankings = data[@"dayRankings"];
//        NSArray *dayRankList = [NSArray yy_modelArrayWithClass:[RankData class] json:dayRankings];
        NSArray *dayRankList = [RankData modelsWithArray:dayRankings];
        if (dayRankList.count > 0) {
            [rankDatas setObject:dayRankList forKey:@"dayRankings"];
        }
        
        success(rankDatas);
    } failure:^(NSNumber *resCode, NSString *message) {
        
    }];
}


+ (void)requestServerRankByType:(RankType)type rankDataType:(RankDataType)rankDataType Success:(void (^)(NSArray *))success failure:(void (^)(NSNumber *, NSString *))failure {
    NSString *method = @"allrank/geth5";
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [HttpRequestHelper GET:method params:params success:^(id data) {
        
        NSDictionary *formateData = data[@"rankVoList"];
        NSArray *rankList = [NSArray yy_modelArrayWithClass:[RankData class] json:formateData];
        success(rankList);
    } failure:^(NSNumber *resCode, NSString *message) {
        
    }];
}



/**
 获取半小时榜
 
 @param roomUid 用户所在的房间uid
 @param success 成功
 @param failure 失败
 */
+ (void)requestHalfHourRankListWithRoomUid:(NSString *)roomUid
                                   success:(void (^)(NSArray *,RankData *))success
                                   failure:(void (^)(NSNumber *, NSString *))failure {
    
    NSString *method = @"allrank/room/halfHour";
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:roomUid forKey:@"currentRoomUid"];
    [HttpRequestHelper GET:method params:params success:^(id data) {
        
        NSDictionary *formateData = data[@"rankVoList"];
        NSDictionary *meData = data[@"me"];
        RankData *rankData = [RankData yy_modelWithJSON:meData];
        NSArray *rankList = [NSArray yy_modelArrayWithClass:[RankData class] json:formateData];
        if (success) {
            success(rankList,rankData);
        }
    } failure:^(NSNumber *resCode, NSString *message) {
        if (failure) {
            failure(resCode,message);
        }
    }];
    
}


/**
 获取周星榜
 
 @param uid 用户uid
 @param success 成功
 @param failure 失败
 */
+ (void)requestWeekStarRankListWithUid:(NSString *)uid
                               success:(void (^)(NSArray<WeekStarRankListInfo *> *))success
                               failure:(void (^)(NSNumber *, NSString *))failure {
    NSString *method = @"weekStar/getRankListInRoom";
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:uid forKey:@"uid"];
    [HttpRequestHelper GET:method params:params success:^(id data) {
        
        
        if ([data isKindOfClass:[NSArray class]]) {
            NSArray *dataArray = (NSArray *)data;
            NSMutableArray *modelArray = @[].mutableCopy;
            [dataArray enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                WeekStarRankListInfo *weekStar = [WeekStarRankListInfo yy_modelWithJSON:obj];
                [modelArray addObject:weekStar];
            }];
            if (success) {
                success(modelArray);
            }
        }else {
            if (failure) {
                failure(@(0),@"数据格式错误");
            }
        }
        
       
    } failure:^(NSNumber *resCode, NSString *message) {
        if (failure) {
            failure(resCode,message);
        }
    }];
}

@end
