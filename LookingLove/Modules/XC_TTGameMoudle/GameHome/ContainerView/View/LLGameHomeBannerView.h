//
//  LLGameHomeBannerView.h
//  XC_TTGameMoudle
//
//  Created by lvjunhang on 2019/7/26.
//  Copyright © 2019 YiZhuan. All rights reserved.
//  首页 banner

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class BannerInfo;
@class LLGameHomeBannerView;

@protocol LLGameHomeBannerViewDelegate<NSObject>

/**
 选中 Banner
 
 @param data 选中的数据源
 */
- (void)didSelectBannerView:(LLGameHomeBannerView *)view bannerData:(BannerInfo *)data;

@end

///banner 纵横比
extern CGFloat const LLGameHomeBannerViewBannerAspectRatio;

///顶部留白距离
extern CGFloat const LLGameHomeBannerViewTopMargin;

///底部留白距离
extern CGFloat const LLGameHomeBannerViewBottomMargin;

///水平留白距离
extern CGFloat const LLGameHomeBannerViewHoriMargin;

@interface LLGameHomeBannerView : UIView
@property (nonatomic, strong) NSArray<BannerInfo *> *bannerModelArray;
@property (nonatomic, assign) id<LLGameHomeBannerViewDelegate> delegate;

/**
 self自身高度
 */
- (CGFloat)height;

@end

NS_ASSUME_NONNULL_END
