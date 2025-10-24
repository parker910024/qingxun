//
//  TTWorldListCell.h
//  XC_TTGameMoudle
//
//  Created by lvjunhang on 2019/7/1.
//  Copyright © 2019 YiZhuan. All rights reserved.
//  小世界列表(搜索) cell

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class LittleWorldListItem;

@interface TTWorldListCell : UITableViewCell

/**
 小世界列表数据模型
 */
@property (nonatomic, strong, nullable) LittleWorldListItem *model;

@end

NS_ASSUME_NONNULL_END
