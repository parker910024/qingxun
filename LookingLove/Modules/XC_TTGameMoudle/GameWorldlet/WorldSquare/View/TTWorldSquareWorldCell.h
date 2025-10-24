//
//  TTWorldSquareWorldCell.h
//  XC_TTGameMoudle
//
//  Created by lvjunhang on 2019/6/28.
//  Copyright © 2019 YiZhuan. All rights reserved.
//  世界广场 小世界

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class LittleWorldListItem;

@interface TTWorldSquareWorldCell : UICollectionViewCell

/**
 小世界列表数据模型
 */
@property (nonatomic, strong, nullable) LittleWorldListItem *model;

/**
 发现世界入口
 
 @discussion 若此值为真，对 model 赋值将被置空
 */
@property (nonatomic, assign, getter=isFindWorldEntrance) BOOL findWorldEntrance;

@end

NS_ASSUME_NONNULL_END
