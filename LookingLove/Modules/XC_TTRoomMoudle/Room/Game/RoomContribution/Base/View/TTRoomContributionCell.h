//
//  XC_MSRoomContributionCell.h
//  XCRoomMoudle
//
//  Created by KevinWang on 2018/10/16.
//  Copyright © 2018年 YiZhuan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RoomBounsListInfo.h"
#import "RankData.h"

@interface TTRoomContributionCell : UITableViewCell

/**
 房内榜类型（经验|魅力）
 */
@property (nonatomic, assign) RankType rankType;

/**
 房内榜数据
 */
@property (nonatomic, strong) RoomBounsListInfo *inRoomData;

/**
 半小时榜数据
 */
@property (nonatomic, strong) RankData *halfhourData;

/**
 初始化一个cell
 */
+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
