//
//  TTUseGreetingsAlertView.h
//  XC_TTGameMoudle
//
//  Created by Macx on 2019/5/30.
//  Copyright © 2019 YiZhuan. All rights reserved.
//  提示使用"打招呼"的view

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class TTUseGreetingsAlertView, VoiceBottleModel;

@protocol TTUseGreetingsAlertViewDelegate<NSObject>
@optional
/** 点击了去录制按钮 */
- (void)useGreetingsAlertView:(TTUseGreetingsAlertView *)useGreetingsAlertView didClickRecordButton:(UIButton *)button;
/** 点击了确认使用按钮 */
- (void)useGreetingsAlertView:(TTUseGreetingsAlertView *)useGreetingsAlertView didClickSureUseButton:(UIButton *)button;
@end

@interface TTUseGreetingsAlertView : UIView
@property (nonatomic, weak) id<TTUseGreetingsAlertViewDelegate> delegate;
/** model */
@property (nonatomic, strong) VoiceBottleModel *model;
@end

NS_ASSUME_NONNULL_END
