//
//  TTHalfhourContributionHeadView.h
//  TTPlay
//
//  Created by lvjunhang on 2019/3/13.
//  Copyright © 2019 YiZhuan. All rights reserved.
//  半小时榜头部视图

#import <UIKit/UIKit.h>
#import "RoomBounsListInfo.h"

NS_ASSUME_NONNULL_BEGIN

@class RankData;

@interface TTHalfhourContributionHeadView : UIView

@property (nonatomic, strong) RankData *myRankData;//我的榜单数据

@property (nonatomic, strong) void(^tapInfoViewBlock)(UserID uid);

@end

NS_ASSUME_NONNULL_END
