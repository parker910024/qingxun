//
//  TTCheckinAccumulatePrizeCell.h
//  TTPlay
//
//  Created by lvjunhang on 2019/3/20.
//  Copyright © 2019 YiZhuan. All rights reserved.
//  礼物图标、礼物标题、时间节点

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/**
 cell类型，按大小分（7天、14天、21天、28天）

 - TTCheckinAccumulatePrizeCellTypeFirst: 第一种
 - TTCheckinAccumulatePrizeCellTypeSecond: 第二种
 - TTCheckinAccumulatePrizeCellTypeThird: 第三种
 - TTCheckinAccumulatePrizeCellTypeFourth: 第四种
 */
typedef NS_ENUM(NSUInteger, TTCheckinAccumulatePrizeCellType) {
    TTCheckinAccumulatePrizeCellTypeFirst,
    TTCheckinAccumulatePrizeCellTypeSecond,
    TTCheckinAccumulatePrizeCellTypeThird,
    TTCheckinAccumulatePrizeCellTypeFourth
};

@interface TTCheckinAccumulatePrizeCell : UIView
@property (nonatomic, strong) UIButton *prizeButton;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *dayLabel;

@property (nonatomic, assign) TTCheckinAccumulatePrizeCellType cellType;

- (instancetype)initWithCellType:(TTCheckinAccumulatePrizeCellType)cellType;

@end

NS_ASSUME_NONNULL_END
