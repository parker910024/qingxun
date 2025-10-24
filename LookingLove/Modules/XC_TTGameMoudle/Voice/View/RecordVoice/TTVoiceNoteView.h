//
//  TTVoiceNoteView.h
//  XC_TTGameMoudle
//
//  Created by fengshuo on 2019/5/31.
//  Copyright © 2019 YiZhuan. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void (^ShowLoadingCircleCallback)(void);

@interface TTVoiceNoteView : UIView

/**
 *  开始声波动画
 */
- (void)startVoiceWave;


/**
 *  移掉声波
 */
- (void)removeFromParent;

/**
 *  添加并初始化波纹视图
 *
 *  @param parentView                 父视图
 */
- (void)showInParentView:(UIView *)parentView;

/**
 *  设置波纹个数，默认两个
 *
 *  @param waveNumber                 波纹个数
 */
- (void)setVoiceWaveNumber:(NSInteger)waveNumber;


/**
 *  改变音量来改变声波振动幅度
 *
 *  @param volume                  音量大小 大小为0~1
 */
- (void)changeVolume:(CGFloat)volume;

@end

NS_ASSUME_NONNULL_END
