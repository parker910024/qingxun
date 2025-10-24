//
//  LLGameHomeNavView.h
//  XC_TTGameMoudle
//
//  Created by lvjunhang on 2019/7/25.
//  Copyright © 2019 YiZhuan. All rights reserved.
//  轻寻首页导航

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class LLGameHomeNavView;

@protocol LLGameHomeNavViewDelegate <NSObject>
/** 点击创建我的房间 */
- (void)navViewDidClickCreateRoom:(LLGameHomeNavView *)view;

/** 点击搜索 */
- (void)navViewDidClickSearch:(LLGameHomeNavView *)view;

/** 点击签到 */
- (void)navViewDidClickCheckin:(LLGameHomeNavView *)view;

@end

@interface LLGameHomeNavView : UIView

@property (nonatomic, weak) id<LLGameHomeNavViewDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
