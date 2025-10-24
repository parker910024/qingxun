//
//  TTCheckinPrizePreviewViewCell.h
//  TTPlay
//
//  Created by lvjunhang on 2019/3/20.
//  Copyright © 2019 YiZhuan. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class CheckinRewardTodayNotice;

@interface TTCheckinPrizePreviewViewCell : UICollectionViewCell

@property (nonatomic, strong) CheckinRewardTodayNotice *model;

/**
 是否可以补签，判断补签机会是否用完，用完则补签标记变灰色
 */
@property (nonatomic, assign) BOOL canReplenishSign;

@end

NS_ASSUME_NONNULL_END
