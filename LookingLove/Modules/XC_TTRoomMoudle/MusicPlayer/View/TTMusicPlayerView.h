//
//  TTMusicPlayerView.h
//  TuTu
//
//  Created by KevinWang on 2018/10/31.
//  Copyright © 2018年 YiZhuan. All rights reserved.
//
// 房间播放器调节view


#import <UIKit/UIKit.h>


@class TTMusicPlayerView;

@protocol TTMusicPlayerViewDelegate<NSObject>

/**
 播放按钮点击
 
 @param player 播放器 self
 */
- (void)onPlaySongClickPlayerView:(TTMusicPlayerView *)player;

/**
 下一首按钮点击
 
 @param player 播放器 self
 */
- (void)onPlayNextSongClickPlayerView:(TTMusicPlayerView *)player;

/**
 歌曲列表按钮点击
 
 @param player 播放器 self
 */
- (void)onPlaySongListClickPlayerView:(TTMusicPlayerView *)player;


/**
 调整播放器音量
 
 @param player 播放器
 @param value 调整音量后的数值
 */
- (void)onPlayAdjustVolumClickPlayerView:(TTMusicPlayerView *)player adjustMusicVol:(NSInteger)value;

@end

@interface TTMusicPlayerView : UIView

@property (weak, nonatomic) id <TTMusicPlayerViewDelegate> delegate;

//更新播放器状态
- (void)ttUpdateStatus;

@end
