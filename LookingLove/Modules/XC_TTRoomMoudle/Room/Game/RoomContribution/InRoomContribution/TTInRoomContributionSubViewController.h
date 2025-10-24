//
//  TTWeeklyStarContributionSubViewController.h
//  TTPlay
//
//  Created by lvjunhang on 2019/3/13.
//  Copyright © 2019 YiZhuan. All rights reserved.
//  房内榜

#import "TTBaseContributionViewController.h"
#import "ZJScrollPageViewDelegate.h"
#import "RankCore.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^giftListSelectUserBlock)(UserID uid);

@interface TTInRoomContributionSubViewController : TTBaseContributionViewController<ZJScrollPageViewChildVcDelegate>

@property (nonatomic, copy) giftListSelectUserBlock  giftListSelectUserBlock;
@property (nonatomic, assign) RankDataType  rankDataType;
@property (nonatomic, assign) RankType rankingsType;

@end

NS_ASSUME_NONNULL_END
