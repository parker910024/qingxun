//
//  TTRoomContributionController.h
//  TuTu
//
//  Created by KevinWang on 2018/11/6.
//  Copyright © 2018年 YiZhuan. All rights reserved.
//  房间榜

#import "BaseUIViewController.h"
#import "RoomInfo.h"

@class TTRoomContributionController;

@protocol TTRoomContributionControllerDelegate <NSObject>

@optional

/**
 半小时榜选中用户
 
 @param userId 用户ID
 */
- (void)halfhourContributionDidSelectUser:(UserID)userId;

/**
 房内榜选中用户
 
 @param userId 用户ID
 */
- (void)inRoomContributionDidSelectUser:(UserID)userId;

@end

@interface TTRoomContributionController : BaseUIViewController

@property (nonatomic, strong) RoomInfo *info;

@property (nonatomic, weak) id<TTRoomContributionControllerDelegate> delegate;

@end
