//
//  TTMineGiftAchievementCell.h
//  XC_TTPersonalMoudle
//
//  Created by lvjunhang on 2020/2/24.
//  Copyright © 2020 WUJIE INTERACTIVE. All rights reserved.
//  礼物成就cell

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class UserGiftAchievementItem;

@interface TTMineGiftAchievementCell : UICollectionViewCell
@property (nonatomic, strong) UserGiftAchievementItem *data;

/// 配置背景图片，根据分类名字hardcode
/// @param categoryName 分类名
- (void)configBgImageWithCategoryName:(NSString *)categoryName;

@end

NS_ASSUME_NONNULL_END
