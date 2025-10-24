//
//  AuctionCoreClient.h
//  BberryCore
//
//  Created by chenran on 2017/5/27.
//  Copyright © 2017年 chenran. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AuctionInfo.h"

@protocol AuctionCoreClient <NSObject>
@optional
- (void) onStartAuctionSuccess:(AuctionInfo *)auctionInfo;
- (void) onStartAuctionFailth:(NSNumber *)code message:(NSString *)message;

- (void) onUpAuctionSuccess:(AuctionInfo *)auctionInfo;
- (void) onUpAuctionFailth:(NSNumber *)code message:(NSString *)message;

- (void) onFinishAuctionSuccess:(AuctionInfo *)auctionInfo;
- (void) onFinishAuctionFailth:(NSNumber *)code message:(NSString *)message;

- (void) onGetAuctionSuccess:(AuctionInfo *)auctionInfo;
- (void) onGetAuctionFailth:(NSNumber *)code message:(NSString *)message;

- (void) onAuctionStart:(AuctionInfo *)auctionInfo;
- (void) onAuctionWillFinished:(AuctionInfo *)auctionInfo;
- (void) onCurrentAuctionInfoUpdate:(AuctionInfo *)auctionInfo;

//获取周榜
- (void) onFetchAuctionListWeeklySuccess:(NSArray *)list;
- (void) onFetchAuctionListWeeklyFailth:(NSString *)message;

//获取总榜
- (void) onFetchAuctionListTotallySuccess:(NSArray *)list;
- (void) onFetchAuctionListTotallyFailth:(NSString *)message;

@end
