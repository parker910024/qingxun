//
//  LLGameHomeEntranceView.h
//  XC_TTGameMoudle
//
//  Created by lvjunhang on 2019/7/27.
//  Copyright © 2019 YiZhuan. All rights reserved.
//  首页卡片化入口

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

///卡片入口高度
extern CGFloat const LLGameHomeEntranceViewHeight;

@class BannerInfo;
@class LLGameHomeEntranceView;

@protocol LLGameHomeEntranceViewDelegate <NSObject>

/**
 点击卡片入口
 */
- (void)entranceView:(LLGameHomeEntranceView *)entranceView didSelectItemWithInfo:(BannerInfo *)bannerInfo;

@end

@interface LLGameHomeEntranceView : UIView

@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, weak) id<LLGameHomeEntranceViewDelegate> delegate;

@property (nonatomic, strong) NSArray<BannerInfo *> *bannerArray;

/**
 改变view 的 scale
 
 @param minValue value 大小(max 1， min 不限制)
 */
- (void)scaleViewTransformValue:(CGFloat)minValue;

@end


/**
 卡片入口自定义 cell
 */
@interface LLGameHomeEntranceCell : UICollectionViewCell

@property (nonatomic, strong) BannerInfo *bannerInfo;

@property (nonatomic, copy) void (^effectAreaActionBlock)(BannerInfo *bannerInfo);

/**
 缩小 or 放大
 
 @param minValue scale 的值
 */
- (void)scaleCellMin:(CGFloat)minValue;

@end

NS_ASSUME_NONNULL_END
