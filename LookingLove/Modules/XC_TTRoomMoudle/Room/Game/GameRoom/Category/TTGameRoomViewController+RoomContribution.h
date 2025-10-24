//
//  TTGameRoomViewController+RoomContribution.h
//  TuTu
//
//  Created by KevinWang on 2018/11/6.
//  Copyright © 2018年 YiZhuan. All rights reserved.
//  房间榜

#import "TTGameRoomViewController.h"
#import "TTRoomContributionController.h"

@interface TTGameRoomViewController (RoomContribution)<TTRoomContributionControllerDelegate>

//房间榜
- (void)ttShowRoomGiftListView;

@end
