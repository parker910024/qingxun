//
//  TTMineInfoGiftReusableHeaderView.h
//  TuTu
//
//  Created by lee on 2018/11/1.
//  Copyright © 2018 YiZhuan. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class RoomMagicWallInfo, UserGift, UserGiftAchievementList;
@interface TTMineInfoGiftReusableHeaderView : UICollectionReusableView

@property (nonatomic, strong) NSArray<UserGift *>* userGiftList;
@property (nonatomic, strong) NSArray<RoomMagicWallInfo *>* userMagicList;
@property (nonatomic, strong) NSArray<UserGift *>* carrotGiftList;

/// 成就礼物
@property (nonatomic, strong) UserGiftAchievementList *achievementGiftList;
/// 隐藏礼物计数
@property (nonatomic, assign) BOOL hiddenGiftCount;

@end

NS_ASSUME_NONNULL_END
