//
//  TTGameRoomContainerController+MusicPlayer.m
//  TuTu
//
//  Created by KevinWang on 2018/10/31.
//  Copyright © 2018年 YiZhuan. All rights reserved.
//

#import "TTGameRoomContainerController+MusicPlayer.h"
#import "TTGameRoomViewController+Private.h"

#import "TTMusicListController.h"
#import "TTRoomMusicContainerViewController.h"
#import "TTStatisticsService.h"

#import <Masonry/Masonry.h>


@implementation TTGameRoomContainerController (MusicPlayer)


#pragma mark - TTMusicEntranceDelegate

- (void)onDidTapToShowMusicPlayerMusicEntrance:(TTMusicEntrance *)entrance {

    NSString *prefix = GetCore(RoomCoreV2).getCurrentRoomInfo.type == RoomType_CP ? @"cp" : @"mp";
    NSString *fullName = [NSString stringWithFormat:@"%@_%@", prefix, TTStatisticsServiceRoomMusicClick];
    
    [TTStatisticsService trackEvent:fullName
                      eventDescribe:@"音乐"];
    
    [self.view addSubview:self.musicPlayerContainView];
    [self.musicPlayerContainView addSubview:self.musicPlayerView];
    
    [self.musicPlayerContainView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.mas_equalTo(self.view);
    }];
    [self.musicPlayerView ttUpdateStatus];
    // 音乐播放器界面
    [self.musicPlayerView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.musicPlayerContainView.mas_right).offset(0);
        make.top.mas_equalTo(kSafeAreaTopHeight + 15 + 37 + 44);
        make.width.mas_equalTo(self.view.frame.size.width - 85);
        make.height.mas_equalTo(80);
    }];
    
    [self.view layoutIfNeeded];
    
    [self.musicPlayerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(kSafeAreaTopHeight + 15 + 37 + 44);
        make.width.mas_equalTo(303);
        make.height.mas_equalTo(80);
        make.centerX.mas_equalTo(self.musicPlayerContainView.mas_centerX);
    }];
    
    [UIView animateWithDuration:0.2 animations:^{
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished) {
        self.musicPlayerContainView.hidden = NO;
    }];

}

#pragma mark - TTMusicPlayerViewDelegate

/**
 播放按钮点击
 
 @param player 播放器 self
 */
- (void)onPlaySongClickPlayerView:(TTMusicPlayerView *)player {
    if (GetCore(MeetingCore).musicLists.count <= 0) {
        [self onPlaySongListClickPlayerView:player];
    }else{
        if (GetCore(MeetingCore).isPlaying == NO &&GetCore(MeetingCore).currentMusic == nil) {
            [GetCore(MeetingCore) startPlayMusicAtIndex:0];
            //            [GetCore(MeetingCore) adjustMusicSoundVol:self.musicPlayerView.volSlider.value];
            GetCore(MeetingCore).isPlaying = YES;
            [self.musicPlayerView ttUpdateStatus];
        }else{
            if (GetCore(MeetingCore).isPlaying == YES) {
                [GetCore(MeetingCore) pausePlayMusic];
                GetCore(MeetingCore).isPlaying = NO;
                [self.musicPlayerView ttUpdateStatus];
            }else{
                [GetCore(MeetingCore) resumePlayMusic];
                GetCore(MeetingCore).isPlaying = YES;
                [self.musicPlayerView ttUpdateStatus];
            }
        }
    }

}

/**
 下一首按钮点击
 
 @param player 播放器 self
 */
- (void)onPlayNextSongClickPlayerView:(TTMusicPlayerView *)player {
    if (GetCore(MeetingCore).musicLists.count <= 0) {
        [self onPlaySongListClickPlayerView:player];
    }else{
        if (GetCore(MeetingCore).isPlaying == NO &&GetCore(MeetingCore).currentMusic == nil) {
            [GetCore(MeetingCore) startPlayMusicAtIndex:0];
            GetCore(MeetingCore).isPlaying = YES;
            [self.musicPlayerView ttUpdateStatus];
        }else{
            NSInteger index = GetCore(MeetingCore).currentIndex + 1;
            NSArray * array = GetCore(MeetingCore).musicLists;
            
            if (index >= array.count) {
                index = 0;
                if (!GetCore(MeetingCore).isPlaying && GetCore(MeetingCore).currentMusic) {
                    [GetCore(MeetingCore)resumePlayMusic];
                }else {
                    [GetCore(MeetingCore) startPlayMusicAtIndex:index];
                }
                GetCore(MeetingCore).isPlaying = YES;
                [self.musicPlayerView ttUpdateStatus];
            } else if (index < array.count) {
                GetCore(MeetingCore).isPlaying = YES;
                [GetCore(MeetingCore) startPlayMusicAtIndex:index];
                [self.musicPlayerView ttUpdateStatus];
            }
        }
    }
}

/**
 歌曲列表按钮点击
 
 @param player 播放器 self
 */
- (void)onPlaySongListClickPlayerView:(TTMusicPlayerView *)player {
    TTRoomMusicContainerViewController *musicContainerVC = [[TTRoomMusicContainerViewController alloc] init];
    musicContainerVC.musicListVC.delegate = self;
    [self.navigationController pushViewController:musicContainerVC animated:YES];
}

/**
 调整播放器音量
 
 @param player 播放器
 @param value 调整音量后的数值
 */
- (void)onPlayAdjustVolumClickPlayerView:(TTMusicPlayerView *)player adjustMusicVol:(NSInteger)value {
    [GetCore(MeetingCore) adjustMusicSoundVol:value];
}


#pragma mark - TTMusicListControllerDelegate

- (void)musicListController:(TTMusicListController *)listController updateSongName:(NSString *)musicName {
    [self.musicPlayerView ttUpdateStatus];
}

- (void)musicListController:(TTMusicListController *)listController updateVolValue:(float)value {
    [self.musicPlayerView ttUpdateStatus];
}

- (void)onUpdatePlayingStateMusicListController:(TTMusicListController *)listController {
    [self.musicPlayerView ttUpdateStatus];
}

@end
