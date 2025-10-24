//
//  TTSendGiftSegmentView.h
//  TTSendGiftView
//
//  Created by Macx on 2019/4/24.
//  Copyright © 2019 YiZhuan. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "TTSendGiftView.h"

NS_ASSUME_NONNULL_BEGIN
@class TTSendGiftSegmentItem, TTSendGiftSegmentView;

@protocol TTSendGiftSegmentViewDelegate<NSObject>
@optional

/**
 点击了成为贵族按钮

 @param segmentView segmentView
 @param button 成为贵族按钮
 */
- (void)sendGiftSegmentView:(TTSendGiftSegmentView *)segmentView didClickBecomeNobeButton:(UIButton *)button;

/// 点击了一元首冲按钮
/// @param segmentView segmentView
/// @param button 一元首冲按钮
- (void)sendGiftSegmentView:(TTSendGiftSegmentView *)segmentView didClickFirstRechargeButton:(UIButton *)button;

/**
 点击了菜单栏

 @param segmentView segmentView
 @param item 菜单栏模型
 @param type 菜单的类型
 */
- (void)sendGiftSegmentView:(TTSendGiftSegmentView *)segmentView didClickSegmentItem:(TTSendGiftSegmentItem *)item SelectGiftType:(SelectGiftType)type;
@end

@interface TTSendGiftSegmentView : UIView
@property (nonatomic, weak) id<TTSendGiftSegmentViewDelegate> delegate;
/** 当前选择的礼物类型 */
@property (nonatomic, assign, readonly) SelectGiftType currentType;
/** 送礼组件使用的地方 */
@property (nonatomic, assign) XCSendGiftViewUsingPlace usingPlace;

/// 首次充值按钮更新
- (void)updateFirstRechargeButtonLayout:(BOOL)isFirst;
@end

NS_ASSUME_NONNULL_END
