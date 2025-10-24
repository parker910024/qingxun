//
//  XCBoxTableViewCell.h
//  XCRoomMoudle
//
//  Created by KevinWang on 2018/8/22.
//  Copyright © 2018年 YiZhuan. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BoxPrizeModel;
@interface XCBoxTableViewCell : UITableViewCell

@property (nonatomic, strong) BoxPrizeModel  *model;
@property (nonatomic, assign) BOOL isTimeList;

@end
