//
//  HttpRequestHelper+Rank.h
//  BberryCore
//
//  Created by KevinWang on 2018/7/3.
//  Copyright © 2018年 chenran. All rights reserved.
//

#import "HttpRequestHelper.h"
#import "RoomBounsListInfo.h"
#import "RankData.h"
#import "weekStarRankListInfo.h"

@interface HttpRequestHelper (Rank)

/**
 请求服务器排行榜数据
 
 @param type 排行榜类型
 @param rankDataType 排行榜时间类型
 @param success 成功
 @param failure 失败
 */
+ (void)requestServerRankByType:(RankType)type
                   rankDataType:(RankDataType)rankDataType
                        Success:(void (^) (NSArray *))success
                        failure:(void (^) (NSNumber *, NSString *))failure;


/**
 请求房间排行榜数据
 
 @param roomUid 房主uid
 @param rankDataType 排行榜时间类型
 @param success 成功
 @param failure 失败
 */
+ (void)requestRoomRankByRankDataType:(RankDataType)rankDataType
                             rankType:(RankType )rankType
                              roomUid:(NSString *)roomUid
                              Success:(void (^)(NSDictionary *))success
                              failure:(void (^)(NSNumber *, NSString *))failure;

/**
 获取房间榜单
 @param rankType  排行榜类型 贡献榜,魅力榜
 @param success 成功
 @param failure 失败
 */
+ (void)requestRoomBounsListWithType:(RankType )rankType
                             success:(void (^)(NSDictionary *))success
                             failure:(void (^)(NSNumber *, NSString *))failure;






/**
 获取半小时榜

 @param roomUid 用户所在的房间uid
 @param success 成功
 @param failure 失败
 */
+ (void)requestHalfHourRankListWithRoomUid:(NSString *)roomUid
                             success:(void (^)(NSArray<RankData *> *,RankData *))success
                             failure:(void (^)(NSNumber *, NSString *))failure;

/**
 获取周星榜

 @param uid 用户uid
 @param success 成功
 @param failure 失败
 */
+ (void)requestWeekStarRankListWithUid:(NSString *)uid
                                   success:(void (^)(NSArray<WeekStarRankListInfo *> *))success
                                   failure:(void (^)(NSNumber *, NSString *))failure;


@end
