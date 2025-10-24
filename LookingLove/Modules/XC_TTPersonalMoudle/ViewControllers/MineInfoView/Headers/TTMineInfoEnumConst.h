//
//  TTMineInfoEnumConst.h
//  TuTu
//
//  Created by lee on 2018/10/29.
//  Copyright © 2018 YiZhuan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, TTMineInfoViewStyle) {
    /** 默认布局 查看自己 */
    TTMineInfoViewStyleDefault = 0,
    /** 他人布局 查看他人 */
    TTMineInfoViewStyleOhter = 1,
};

/**
礼物展示类型

- TTGiftExhibitTypeAchievement: 礼物成就
- TTGiftExhibitTypeReceive: 收到的礼物
*/
typedef NS_ENUM(NSInteger, TTGiftExhibitType) {
    TTGiftExhibitTypeAchievement = 0,
    TTGiftExhibitTypeReceive
};

// UI Const
static CGFloat const kIconImageViewW = 67.f;
static CGFloat const kHeadwearImageViewW = 92.f;
static CGFloat const kMineInfoHeadTopMargin = 44.f;

static CGFloat const kMineViewHeight = 284.f;      // mineInfoHeadView Height
