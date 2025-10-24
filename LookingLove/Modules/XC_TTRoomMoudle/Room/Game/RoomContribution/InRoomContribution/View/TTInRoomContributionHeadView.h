//
//  XC_MSRoomContributionHeaderView.h
//  XCRoomMoudle
//
//  Created by KevinWang on 2018/10/16.
//  Copyright © 2018年 YiZhuan. All rights reserved.
//  房内榜头部视图

#import <UIKit/UIKit.h>
#import "RankCore.h"

typedef void(^HeadViewSelectDataBlock)(RankType rankType, RankDataType type);
typedef void(^HeadViewSelectedRankTypeBlock)(RankType rankType, RankDataType type);

@interface TTInRoomContributionHeadView : UIView

//选择日，周，总
@property (nonatomic, copy) HeadViewSelectDataBlock headViewSelectDataBlock;
//选择排行榜，魅力榜
@property (nonatomic, copy) HeadViewSelectedRankTypeBlock headViewSelectedRankTypeBlock;

@end
