//
//  TTMasterTimeView.h
//  TTPlay
//
//  Created by Macx on 2019/2/15.
//  Copyright © 2019 YiZhuan. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class TTMasterTimeView;

@protocol TTMasterTimeViewDelegate <NSObject>
@optional
/**
 倒计时结束, 变为"去送花", 点击事件
 
 @param view self
 */
- (void)masterTimeView:(TTMasterTimeView *)view didClickTimeView:(UIView *)timeView;
@end

@interface TTMasterTimeView : UIView
/** delegate */
@property (nonatomic, weak) id<TTMasterTimeViewDelegate> delegate;

// 更新为"去送礼"状态
- (void)updateSendGiftStatus;
@end

NS_ASSUME_NONNULL_END
