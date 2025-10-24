//
//  TTWorldletMainTableViewCell.h
//  XC_TTGameMoudle
//
//  Created by apple on 2019/7/1.
//  Copyright © 2019 YiZhuan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LittleWorldListModel.h"
NS_ASSUME_NONNULL_BEGIN

typedef void(^avatorClickAction)(void);

@interface TTWorldletMainTableViewCell : UITableViewCell

@property (nonatomic, strong) LittleWorldListItem *model;

@property (nonatomic, copy) avatorClickAction avatorClick;

@end

NS_ASSUME_NONNULL_END
