//
//  AuctionInfo.h
//  BberryCore
//
//  Created by chenran on 2017/5/27.
//  Copyright © 2017年 chenran. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AuctionUserInfo.h"
#import "BaseObject.h"
#import "UserInfo.h"
@interface AuctionInfo : BaseObject
@property(nonatomic, strong) NSString *auctId;
@property(nonatomic, assign) UserID uid;
@property(nonatomic, assign) UserID auctUid;
@property(nonatomic, assign) NSInteger auctMoney;
@property(nonatomic, assign) NSInteger servDura;
@property(nonatomic, assign) NSInteger minRaiseMoney;
@property(nonatomic, assign) NSInteger curMaxMoney;
@property(nonatomic, assign) UserID curMaxUid;
@property(nonatomic, strong) NSString *auctDesc;
@property(nonatomic, assign) long createTime;
@property(nonatomic, strong) NSArray<AuctionUserInfo *> *rivals;
@property(nonatomic, strong) UserInfo *auctUserVo;
@property(nonatomic, strong) UserInfo *curMaxUserVo;
@end
