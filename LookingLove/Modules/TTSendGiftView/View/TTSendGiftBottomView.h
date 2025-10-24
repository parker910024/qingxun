//
//  TTSendGiftBottomView.h
//  TTSendGiftView
//
//  Created by Macx on 2019/4/24.
//  Copyright © 2019 YiZhuan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TTSendGiftView.h"
#import "TTSendGiftCountItem.h"

NS_ASSUME_NONNULL_BEGIN
@class TTSendGiftBottomView, BalanceInfo, CarrotWallet;

@protocol TTSendGiftBottomViewDelegate<NSObject>
@optional

/**
 充值按钮的点击

 @param bottomView bottomView
 @param button 充值按钮
 @param type 当前选中礼物的类型 金币/萝卜
 */
- (void)sendGiftBottomView:(TTSendGiftBottomView *)bottomView didClickRechargeButton:(UIButton *)button type:(GiftConsumeType)type;

/**
 选择礼物数量按钮的点击

 @param bottomView bottomView
 @param button 选择礼物数量按钮
 */
- (void)sendGiftBottomView:(TTSendGiftBottomView *)bottomView didClickSelectCountBtn:(UIButton *)button;

/**
 送礼按钮的点击

 @param bottomView bottomView
 @param button 送礼按钮
 */
- (void)sendGiftBottomView:(TTSendGiftBottomView *)bottomView didClickSendButton:(UIButton *)button;
@end

@interface TTSendGiftBottomView : UIView
@property (nonatomic, weak) id<TTSendGiftBottomViewDelegate> delegate;
@property (nonatomic, assign) SelectGiftType currentType;//当前选择的礼物类型
/** 金币钱包 */
@property (nonatomic, strong) BalanceInfo *balanceInfo;
/** 萝卜钱包 */
@property (nonatomic, strong) CarrotWallet *carrotWallet;
/** 礼物数量 */
@property (nonatomic, strong, readonly) UILabel *selectedCountLabel;

/** 更新 送礼的金币/萝卜 类型 */
- (void)updateBottomViewInfo:(id)giftItem;
/** 更新礼物数量 */
- (void)updateGiftCountWithItem:(TTSendGiftCountItem *)countItem;
/** 更新箭头的图片 */
- (void)updateArrowImage:(BOOL)isUp;
@end

NS_ASSUME_NONNULL_END
