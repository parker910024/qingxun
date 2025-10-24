//
//  TTWeeklyStarContributionViewController.h
//  TTPlay
//
//  Created by lvjunhang on 2019/3/13.
//  Copyright © 2019 YiZhuan. All rights reserved.
//  房内榜

#import "BaseUIViewController.h"
#import "ZJScrollPageViewDelegate.h"
#import "UserID.h"

NS_ASSUME_NONNULL_BEGIN

@class RankData;

@interface TTInRoomContributionViewController : BaseUIViewController<ZJScrollPageViewChildVcDelegate>

@property (nonatomic, strong) void(^roomContributionSelectBlock)(UserID uid);

@end

NS_ASSUME_NONNULL_END
