//
//  TTVoiceBottleView.h
//  XC_TTGameMoudle
//
//  Created by Macx on 2019/5/31.
//  Copyright © 2019 YiZhuan. All rights reserved.
//  瓶子整体的view

#import <UIKit/UIKit.h>
#import "MLSwipeableView.h"
#import "SVGA.h"
#import "SVGAParserManager.h"
#import "XCPlayerTool.h"

NS_ASSUME_NONNULL_BEGIN
@class TTVoiceBottleView, VoiceBottleModel;

@protocol TTVoiceBottleViewDelegate<NSObject>
@optional
/** 点击了去举报按钮 */
- (void)voiceBottleView:(TTVoiceBottleView *)voiceBottleView didClickReportButton:(UIButton *)button;
@end

@interface TTVoiceBottleView : UIView<SwipeableViewProtocol, XCPlayerToolDelegate>
@property (nonatomic, weak) id<TTVoiceBottleViewDelegate> delegate;

/** 飘动的"心"gif */
@property (nonatomic, strong, readonly) SVGAImageView *heartImageView;
/** 模型 */
@property (nonatomic, strong) VoiceBottleModel *bottleModel;
/** 暂停or播放 */
@property (nonatomic, strong, readonly) UIButton *playOrPauseButton;

/** 重置播放按钮和播放进度的显示 */ 
- (void)resetBottleView;
@end

NS_ASSUME_NONNULL_END
