//
//  AuctionCore.h
//  BberryCore
//
//  Created by chenran on 2017/5/27.
//  Copyright © 2017年 chenran. All rights reserved.
//

#import "BaseCore.h"
#import "AuctionInfo.h"

@interface AuctionCore : BaseCore
@property(nonatomic, strong)AuctionInfo *currentAuction;

- (void) startAuction:(UserID)uid auctUid:(UserID)auctUid auctMoney:(NSInteger)auctMoney servDura:(NSInteger)servDura minRaiseMoney:(NSInteger)minRaiseMoney auctDesc:(NSString *)auctDesc;
- (void) upAuction:(UserID)uid auctId:(NSString *)auctId roomUid:(UserID)roomUid type:(NSInteger)type money:(NSInteger)money;
- (void) finishAuction:(UserID)uid auctId:(NSString *)auctId;


/**
 获取周榜

 @param roomUid 房间ID
 */
- (void) fetchAuctionWeeklyList:(NSString *)roomUid;


/**
 获取总榜

 @param roomUid 房间ID
 */
- (void) fetchAuctionTotallyList:(NSString *)roomUid;
@end
