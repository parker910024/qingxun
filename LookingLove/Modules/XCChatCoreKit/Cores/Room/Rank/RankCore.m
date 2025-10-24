//
//  RankCore.m
//  BberryCore
//
//  Created by KevinWang on 2018/7/3.
//  Copyright © 2018年 chenran. All rights reserved.
//

#import "RankCore.h"
#import "RankCoreClient.h"
#import "HttpRequestHelper+Rank.h"

@interface RankCore()

@property (nonatomic, strong) NSDictionary *roomSendBounsListData;
@property (nonatomic, strong) NSDictionary *roomReceiveBounsListData;
@end

@implementation RankCore

//获取房间贡献榜
- (void)getRoomBounsListWithType:(RankType )rankType dataType:(RankDataType)type{
    
    if (rankType == RankType_Send) {
        if (self.roomSendBounsListData != nil) {
             NotifyCoreClient(RankCoreClient, @selector(onGetRoomBounsListWithType:dataType:success:), onGetRoomBounsListWithType:rankType dataType:type success:self.roomSendBounsListData[rankKey(type)]);
            return;
        }
    }else{
        if (self.roomReceiveBounsListData != nil) {
             NotifyCoreClient(RankCoreClient, @selector(onGetRoomBounsListWithType:dataType:success:), onGetRoomBounsListWithType:rankType dataType:type success:self.roomReceiveBounsListData[rankKey(type)]);
            return;
        }
    }
    
    [HttpRequestHelper requestRoomBounsListWithType:rankType success:^(NSDictionary *bounsListInfo) {
        
        if (rankType == RankType_Send) {
            self.roomSendBounsListData = bounsListInfo;
        }else{
            self.roomReceiveBounsListData = bounsListInfo;
        }
        
        NotifyCoreClient(RankCoreClient, @selector(onGetRoomBounsListWithType:dataType:success:), onGetRoomBounsListWithType:rankType dataType:type success:bounsListInfo[rankKey(type)]);
    } failure:^(NSNumber *resCode, NSString *message) {
        
        NotifyCoreClient(RankCoreClient, @selector(onGetRoomBounsListWihthType:dataType:failth:), onGetRoomBounsListWihthType:rankType dataType:type failth:message);
    }];
}


- (void)clearCache{

    self.roomReceiveBounsListData = nil;
    self.roomSendBounsListData = nil;
}

NSString *rankKey (RankDataType dateType){
    
    switch (dateType) {
        case RankDataType_Day:
        {
            return @"dayRankings";
        }
            
            break;
        case RankDataType_Week:
        {
            return @"weekRankings";
        }
            
            break;
        case RankDataType_Total:
        {
            return @"totalRankings";
        }
            
            break;
        default:
            return @"dayRankings";
            break;
    }
    
}

- (void)getTheServerRankByRankType:(RankType)rankType andRankDateType:(RankDataType)rankDataType {
    [HttpRequestHelper requestServerRankByType:rankType rankDataType:rankDataType Success:^(NSArray *array) {
        NotifyCoreClient(RankCoreClient, @selector(onRequestServerSuccessRankType:andRankDateType:rankList:),onRequestServerSuccessRankType:rankType andRankDateType:rankDataType rankList:array);
    } failure:^(NSNumber *number, NSString *string) {
        
    }];
}

- (void)getTheRoomRankByRoomUid:(NSString *)roomUid andRankDateType:(RankDataType)rankDataType rankType:(RankType )rankType {
    
    [HttpRequestHelper requestRoomRankByRankDataType:rankDataType rankType:rankType roomUid:roomUid Success:^(NSDictionary *dic) {
        NotifyCoreClient(RankCoreClient, @selector(onRequestRoomSuccessRankDateType:rankType:rankList:), onRequestRoomSuccessRankDateType:rankDataType rankType:rankType rankList:dic);
    } failure:^(NSNumber *number, NSString *message) {
        
    }];

}


/*------------------------ 半小时榜 -------------------------------*/

/**
 获取当前半小时榜
 
 @param roomUid 房主uid
 */
- (void)getHalfHourRankByRoomUid:(NSString *)roomUid {
    [HttpRequestHelper requestHalfHourRankListWithRoomUid:roomUid success:^(NSArray<RankData *> *rankVoList, RankData *me) {
        NotifyCoreClient(RankCoreClient, @selector(onGetHalfHourRankWithRoomUid:success:meRankData:),onGetHalfHourRankWithRoomUid:roomUid success:rankVoList meRankData:me);
    } failure:^(NSNumber *errorCode, NSString *message) {
        NotifyCoreClient(RankCoreClient, @selector(onGetHalfHourRankWithRoomUid:fauile:), onGetHalfHourRankWithRoomUid:roomUid fauile:message);
    }];
}


/*------------------------ 周星榜 -------------------------------*/

/**
 获取周星榜
 
 @param uid uid
 */
- (void)getWeekStarRankByUid:(NSString *)uid {
    [HttpRequestHelper requestWeekStarRankListWithUid:uid success:^(NSArray<WeekStarRankListInfo *> *rankVoList) {
        NotifyCoreClient(RankCoreClient, @selector(onGetWeekStarWithUid:success:), onGetWeekStarWithUid:uid success:rankVoList);
    } failure:^(NSNumber *errorCode, NSString *message) {
        NotifyCoreClient(RankCoreClient, @selector(onGetWeekStarWithUid:fauile:), onGetWeekStarWithUid:uid fauile:message);
    }];
}

@end
