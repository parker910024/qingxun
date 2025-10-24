//
//  TTVoiceLoadingView.h
//  XC_TTGameMoudle
//
//  Created by Macx on 2019/6/11.
//  Copyright © 2019 YiZhuan. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class TTVoiceLoadingView;

typedef enum : NSUInteger {
    TTVoiceLoadingViewStatusLoading,    // 刷新状态
    TTVoiceLoadingViewStatusNoNet,      // 没网状态
    TTVoiceLoadingViewStatusNoMore,     // 没有更多数据
} TTVoiceLoadingViewStatus;

@protocol TTVoiceLoadingViewDelegate<NSObject>
@optional
/** 点击了刷新按钮 */
- (void)voiceLoadingView:(TTVoiceLoadingView *)voiceLoadingView didClickRrefreshButton:(UIButton *)button;
@end

@interface TTVoiceLoadingView : UIView
@property (nonatomic, weak) id<TTVoiceLoadingViewDelegate> delegate;

/** 状态 */
@property (nonatomic, assign) TTVoiceLoadingViewStatus status;
@end

NS_ASSUME_NONNULL_END
