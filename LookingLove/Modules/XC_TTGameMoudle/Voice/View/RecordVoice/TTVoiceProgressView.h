//
//  TTVoiceProgressView.h
//  XC_TTGameMoudle
//
//  Created by fengshuo on 2019/5/31.
//  Copyright © 2019 YiZhuan. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TTVoiceProgressView : UIView
@property (nonatomic, strong, readonly) CAShapeLayer *outLayer;
@property (nonatomic, strong, readonly) CAShapeLayer *progressLayer;

- (instancetype)initWithLineWidth:(CGFloat)lineWidth;
/** 更新进度 0-1 */
- (void)updateProgress:(CGFloat)progress;
@end

NS_ASSUME_NONNULL_END
