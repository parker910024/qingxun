//
//  TTRedEntranceView.h
//  XC_TTRoomMoudle
//
//  Created by lvjunhang on 2020/5/11.
//  Copyright © 2020 WUJIE INTERACTIVE. All rights reserved.
//  红包入口

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

extern NSString *const TTRedEntranceViewDrawCountdownNotify;

@class RoomRedListItem, TTRedEntranceView;

@protocol TTRedEntranceViewDelegate <NSObject>

/// 选中红包入口
- (void)didSelectedEntranceView:(TTRedEntranceView *)view;

/// 全体注意，开始抢红包了~
/// @param redItem 红包
- (void)entranceView:(TTRedEntranceView *)view startDraw:(RoomRedListItem *)redItem;

/// 抢红包结束了~
/// @param redItem 红包
- (void)entranceView:(TTRedEntranceView *)view endDraw:(RoomRedListItem *)redItem;

@end

@interface TTRedEntranceView : UIControl

@property (nonatomic, assign, nullable) id<TTRedEntranceViewDelegate> delegate;

/// 更新倒计时
/// @param redItem 红包模型
- (void)updateCountdownWithRedItem:(RoomRedListItem *_Nullable)redItem;

/// 显示动画
- (void)showAnimation;

@end

NS_ASSUME_NONNULL_END
