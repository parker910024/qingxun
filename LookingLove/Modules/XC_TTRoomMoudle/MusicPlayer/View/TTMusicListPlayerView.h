//
//  TTMusicListPlayerView.h
//  TuTu
//
//  Created by Macx on 2018/11/22.
//  Copyright © 2018 YiZhuan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MusicInfo.h"

@class TTMusicListPlayerView;

@protocol TTMusicListPlayerViewDelegate<NSObject>

/**
 点击播放按钮，默认播放列表第一首
 
 @param playerView 播放器 self
 */
- (void)playSongButtonClickPlayerView:(TTMusicListPlayerView *)playerView;

/**
 混响调整按钮点击
 
 @param playerView 播放器 self
 */
- (void)adjustMixButtonClickPlayerView:(TTMusicListPlayerView *)playerView;

@end

@interface TTMusicListPlayerView : UIView
/**
 delegate:TTMusicListPlayerViewDelegate
 */
@property (weak, nonatomic) id <TTMusicListPlayerViewDelegate> delegate;

/**
 更新播放器状态
 
 @param musicInfo 传空即为停止播放，否则显示当前播放歌曲名
 */
- (void)playStatusChangeWithMusicInfo:(MusicInfo *)musicInfo;

- (void)ttUpdateMusicName:(NSString *)musicName;
@end
