//
//  DiscoverGiftRankModel.h
//  XCChatCoreKit
//
//  Created by gzlx on 2018/8/29.
//  Copyright © 2018年 KevinWang. All rights reserved.
//

#import "BaseObject.h"
#import "DiscoverStarModel.h"
#import "GiftInfo.h"

@interface DiscoverGiftRankModel : BaseObject

@property (nonatomic, strong) GiftInfo * gift;
@property (nonatomic, copy) NSArray<DiscoverStarModel *> * stars;
@property (nonatomic, copy) NSString * backImageName;//礼物周星榜的背景
@end
