//
//  LLGameHomeHeaderContainerView.h
//  XC_TTGameMoudle
//
//  Created by lvjunhang on 2019/7/26.
//  Copyright © 2019 YiZhuan. All rights reserved.
//  轻寻首页头部容器，包含导航栏，banner（如果有），入口（如果有）

#import <UIKit/UIKit.h>

#import "LLGameHomeEntranceView.h"
#import "LLGameHomeNavView.h"
#import "LLGameHomeBannerView.h"

NS_ASSUME_NONNULL_BEGIN

@class HomeV5Category;

@interface LLGameHomeHeaderContainerView : UIView

// 导航栏
@property (nonatomic, strong) LLGameHomeNavView *navView;

// banner
@property (nonatomic, strong) LLGameHomeBannerView *bannerView;

// 卡片化入口
@property (nonatomic, strong) LLGameHomeEntranceView *cardEntranceView;

/**
 配置数据源
 */
- (void)configData:(HomeV5Category *)data;

/**
 当前容器高度：navHeight+bannerHeight+cardHeight
 */
- (CGFloat)height;

@end

NS_ASSUME_NONNULL_END
