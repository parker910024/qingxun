//
//  RankCoreClient.h
//  BberryCore
//
//  Created by KevinWang on 2018/7/3.
//  Copyright © 2018年 chenran. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RoomBounsListInfo.h"
@class WeekStarRankListInfo,RankData;
@protocol RankCoreClient <NSObject>

@optional
//获取房间贡献榜成功
- (void)onGetRoomBounsListWithType:(RankType )rankType dataType:(RankDataType)type success:(NSArray *)bounsListInfo;
//获取房间贡献榜失败
- (void)onGetRoomBounsListWihthType:(RankType )rankType dataType:(RankDataType)type failth:(NSString *)message;
- (void)onRequestServerSuccessRankType:(RankType)rankType andRankDateType:(RankDataType)rankDataType rankList:(NSArray *)rankList;
//耳伴专用
- (void)onRequestRoomSuccessRankDateType:(RankDataType)rankDataType rankType:(RankType)rankType rankList:(NSMutableDictionary *)rankDatas;


//萌声。半小时榜
//用户当前所在房间的roomUid
- (void)onGetHalfHourRankWithRoomUid:(NSString *)roomUid success:(NSArray<RankData *> *)rankVoList meRankData:(RankData *)meRankData;

- (void)onGetHalfHourRankWithRoomUid:(NSString *)roomUid fauile:(NSString *)message;

//萌声 房内周星榜
//用户uid
- (void)onGetWeekStarWithUid:(NSString *)uid success:(NSArray<WeekStarRankListInfo *> *)weekStarRankList;
- (void)onGetWeekStarWithUid:(NSString *)uid fauile:(NSString *)message;


@end
