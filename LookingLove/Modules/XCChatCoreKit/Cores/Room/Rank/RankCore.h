//
//  RankCore.h
//  BberryCore
//
//  Created by KevinWang on 2018/7/3.
//  Copyright © 2018年 chenran. All rights reserved.
//

#import "BaseCore.h"
#import "RankData.h"

@interface RankCore : BaseCore
/*
 * 获取房间贡献榜
 * RankType  排行榜类型 贡献榜,魅力榜
 */
- (void)getRoomBounsListWithType:(RankType )rankType dataType:(RankDataType)type;

/**
 清除贡献榜，魅力榜缓存
 */
- (void)clearCache;

/**
 获取服务端排行榜
 
 @param rankType 排行榜类型
 @param rankDataType 排行榜时间类型
 */
- (void)getTheServerRankByRankType:(RankType)rankType andRankDateType:(RankDataType)rankDataType;


/**
 获取当前房间排行榜
 
 @param roomUid 房主uid
 @param rankDataType 排行榜时间类型
 */
- (void)getTheRoomRankByRoomUid:(NSString *)roomUid andRankDateType:(RankDataType)rankDataType rankType:(RankType )rankType;


/*------------------------ 半小时榜 -------------------------------*/

/**
 获取当前半小时榜

 @param roomUid 房主uid
 */
- (void)getHalfHourRankByRoomUid:(NSString *)roomUid;


/*------------------------ 周星榜 -------------------------------*/

/**
 获取周星榜
 
 @param uid uid
 */
- (void)getWeekStarRankByUid:(NSString *)uid;


@end
