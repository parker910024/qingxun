//
//  WeekStarRankListInfo.h
//  XCChatCoreKit
//
//  Created by zoey on 2019/2/13.
//  Copyright © 2019年 KevinWang. All rights reserved.
//

#import "BaseObject.h"
#import "RankData.h"
#import "GiftInfo.h"

NS_ASSUME_NONNULL_BEGIN

@interface WeekStarRankListInfo : BaseObject

@property (strong , nonatomic) NSArray<RankData *> *weekStarRankList;

@property (strong , nonatomic) RankData *me;//查询用户的相关信息

@property (strong , nonatomic) GiftInfo *gift;//礼物的信息

@end

NS_ASSUME_NONNULL_END
