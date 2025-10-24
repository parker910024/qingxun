//
//  TTVoiceMyEmptyView.h
//  XC_TTGameMoudle
//
//  Created by Macx on 2019/6/3.
//  Copyright © 2019 YiZhuan. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class TTVoiceMyEmptyView;

@protocol TTVoiceMyEmptyViewDelegate<NSObject>
@optional
/** 点击了去录制按钮 */
- (void)voiceMyEmptyView:(TTVoiceMyEmptyView *)voiceMyEmptyView didClickRecordButton:(UIButton *)button;
@end

@interface TTVoiceMyEmptyView : UIView
@property (nonatomic, weak) id<TTVoiceMyEmptyViewDelegate> delegate;
@end

NS_ASSUME_NONNULL_END
