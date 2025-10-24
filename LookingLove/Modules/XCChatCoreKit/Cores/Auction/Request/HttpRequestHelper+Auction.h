//
//  HttpRequestHelper+Auction.h
//  BberryCore
//
//  Created by chenran on 2017/5/27.
//  Copyright © 2017年 chenran. All rights reserved.
//

#import "HttpRequestHelper.h"
#import "AuctionInfo.h"

@interface HttpRequestHelper (Auction)

/**
 获取总榜
 
 @param roomUid 房主UID
 @param success 成功
 @param failure 失败
 */
+ (void)fetchAuctionTotalListWith:(NSString *)roomUid success:(void (^)(NSArray *totallyList))success
                           failure:(void (^)(NSNumber *resCode, NSString *message))failure;

/**
 获取周榜

 @param roomUid 房主UID
 @param success 成功
 @param failure 失败
 */
+ (void)fetchAuctionWeeklyListWith:(NSString *)roomUid success:(void (^)(NSArray *weeklyList))success
                           failure:(void (^)(NSNumber *resCode, NSString *message))failure;

/**
 开启拍卖

 @param uid 用户uid
 @param auctUid 被拍卖uid
 @param auctMoney 起拍价
 @param servDura 服务时间
 @param minRaiseMoney 最小加价服务
 @param auctDesc 拍卖描述
 @param success 成功
 @param failure 失败
 */
+ (void) startAuction:(UserID)uid auctUid:(UserID)auctUid auctMoney:(NSInteger)auctMoney servDura:(NSInteger)servDura minRaiseMoney:(NSInteger)minRaiseMoney auctDesc:(NSString *)auctDesc
               success:(void (^)(AuctionInfo *))success
               failure:(void (^)(NSNumber *resCode, NSString *message))failure;


/**
 竞拍加价

 @param uid 用户uid
 @param auctId 被拍卖
 @param roomUid 房主uid
 @param type 拍卖类型：1、加价 2、出价
 @param money 拍卖金额
 @param success 成功
 @param failure 失败
 */
+ (void) upAuction:(UserID)uid auctId:(NSString *)auctId roomUid:(UserID)roomUid type:(NSInteger)type money:(NSInteger)money
           success:(void (^)(AuctionInfo *))success
           failure:(void (^)(NSNumber *resCode, NSString *message))failure;

/**
 结束竞拍

 @param uid 房主uid
 @param auctId 拍卖id
 @param success 成功
 @param failure 失败
 */
+ (void) finishAuction:(UserID)uid auctId:(NSString *)auctId
               success:(void (^)(AuctionInfo *))success
               failure:(void (^)(NSNumber *resCode, NSString *message))failure;

/**
 获取拍卖信息

 @param uid 房主uid
 @param success 成功
 @param failure 失败
 */
+ (void) getAuction:(UserID) uid
            success:(void (^)(AuctionInfo *))success
            failure:(void (^)(NSNumber *resCode, NSString *message))failure;
@end
