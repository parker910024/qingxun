//
//  AuctionUserInfo.h
//  BberryCore
//
//  Created by chenran on 2017/6/2.
//  Copyright © 2017年 chenran. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseObject.h"
#import "UserInfo.h"

@interface AuctionUserInfo : BaseObject
@property(nonatomic, strong) NSString *auctId;
@property(nonatomic, strong) NSString *rivalId;
@property(nonatomic, assign) UserID uid;
@property(nonatomic, assign) NSInteger auctMoney;
@property(nonatomic, strong) UserInfo *userVo;
@end
