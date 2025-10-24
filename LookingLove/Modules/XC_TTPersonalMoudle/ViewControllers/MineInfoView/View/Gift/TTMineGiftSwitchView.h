//
//  TTMineGiftSwitchView.h
//  XC_TTPersonalMoudle
//
//  Created by lvjunhang on 2020/2/24.
//  Copyright © 2020 WUJIE INTERACTIVE. All rights reserved.
//  礼物成就、获得礼物之间切换视图

#import <Foundation/Foundation.h>
#import "TTMineInfoEnumConst.h"

NS_ASSUME_NONNULL_BEGIN

@interface TTMineGiftSwitchView : UIView
@property (nonatomic, assign) TTGiftExhibitType exhibitType;//礼物展示类型
@property (nonatomic, copy) void (^switchTypeHandler)(TTGiftExhibitType type);//切换展示

/// 禁止展示成就礼物（后端未配置成就礼物时）
- (void)forbidExhibitAchievementGift;

@end

NS_ASSUME_NONNULL_END
