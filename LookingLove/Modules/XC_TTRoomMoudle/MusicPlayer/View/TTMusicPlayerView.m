//
//  TTMusicPlayerView.m
//  TuTu
//
//  Created by KevinWang on 2018/10/31.
//  Copyright © 2018年 YiZhuan. All rights reserved.
//

#import "TTMusicPlayerView.h"
//view
#import "TTMusicPlayerSlider.h"

//tool
#import <Masonry/Masonry.h>

//core
#import "MeetingCore.h"

//client
#import "MeetingCoreClient.h"
#import "ImRoomCoreClientV2.h"

//theme
#import "XCTheme.h"

typedef enum : NSUInteger {
    TTMusicPlayerViewButtonType_Play       = 1,    //点击播放按钮
    TTMusicPlayerViewButtonType_Next       = 2,    //点击播放下一首按钮
    TTMusicPlayerViewButtonType_SongList   = 3,    //点击歌曲列表按钮
} TTMusicPlayerViewButtonType;

@interface TTMusicPlayerView ()
<
MeetingCoreClient,
ImRoomCoreClientV2
>

/**
 音乐标题
 */
@property (strong, nonatomic) UILabel *musicTitleLabel;

/**
 音量滑块
 */
@property (strong, nonatomic) TTMusicPlayerSlider *slider;

/**
 音量小图标
 */
@property (strong, nonatomic) UIImageView *hornIconImageView;

/**
 播放，暂停按钮
 */
@property (strong, nonatomic) UIButton *playControlButton;

/**
 下一首按钮
 */
@property (strong, nonatomic) UIButton *nextButton;

/**
 歌曲列表按钮
 */
@property (strong, nonatomic) UIButton *musicListButton;


@end

@implementation TTMusicPlayerView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initView];
        [self initConstrations];
        [self addCoreClient];
        [self ttUpdateStatus];
    }
    return self;
}

- (void)initView {
    self.userInteractionEnabled = YES;
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = 40.f;
    self.backgroundColor = UIColorRGBAlpha(0x000000, 0.8);
    
    
    // 拦截手势
    [self addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didRecognizedMusicPlayerViewTapGestureRecognizer:)]];
    
    [self addSubview:self.musicTitleLabel];
    [self addSubview:self.slider];
    [self addSubview:self.hornIconImageView];
    [self addSubview:self.playControlButton];
    [self addSubview:self.nextButton];
    [self addSubview:self.musicListButton];
}

- (void)addCoreClient {
    AddCoreClient(ImRoomCoreClientV2, self);
}

- (void)initConstrations {
    [self.musicTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.mas_leading).offset(30);
        make.right.mas_equalTo(self).offset(-30);
        make.top.mas_equalTo(self.mas_top).offset(17);
        make.height.mas_equalTo(14);
    }];
    [self.hornIconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.musicTitleLabel.mas_leading);
        make.width.mas_equalTo(12);
        make.height.mas_equalTo(15);
        make.top.mas_equalTo(self.musicTitleLabel.mas_bottom).offset(18);
    }];
    [self.slider mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.hornIconImageView.mas_trailing).offset(5);
        make.centerY.mas_equalTo(self.hornIconImageView.mas_centerY);
        make.trailing.mas_equalTo(self.playControlButton.mas_leading).offset(-21);
    }];
    [self.playControlButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.mas_equalTo(self.nextButton.mas_leading).offset(-23); make.centerY.mas_equalTo(self.hornIconImageView.mas_centerY);
        make.width.height.mas_equalTo(22);
    }];
    [self.nextButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.mas_equalTo(self.musicListButton.mas_leading).offset(-23);
        make.width.height.mas_equalTo(22);
        make.centerY.mas_equalTo(self.hornIconImageView.mas_centerY);
    }];
    [self.musicListButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.hornIconImageView.mas_centerY);
        make.trailing.mas_equalTo(self.mas_trailing).offset(-26);
        make.width.height.mas_equalTo(22);
    }];
}

- (void)didRecognizedMusicPlayerViewTapGestureRecognizer:(UIGestureRecognizer *)recognizer {}

#pragma mark - user respone

- (void)onVolumValueChange:(TTMusicPlayerSlider *)slider {
    if ([self.delegate respondsToSelector:@selector(onPlayAdjustVolumClickPlayerView:adjustMusicVol:)]) {
        [self.delegate onPlayAdjustVolumClickPlayerView:self adjustMusicVol:(NSInteger)slider.value];
    }
}

#pragma mark - public method

- (void)ttUpdateStatus{
    self.nextButton.enabled = YES;
    if (GetCore(MeetingCore).currentMusic != nil && GetCore(MeetingCore).isPlaying == YES) {
        self.musicTitleLabel.text = GetCore(MeetingCore).currentMusic.musicName;
        self.slider.value = GetCore(MeetingCore).soundVol;
        self.nextButton.enabled = YES;
        [self.playControlButton setBackgroundImage:[UIImage imageNamed:@"room_music_player_pause"] forState:UIControlStateNormal];
    }else if(GetCore(MeetingCore).isPlaying == NO &&GetCore(MeetingCore).currentMusic == nil) {
        self.musicTitleLabel.text = @"暂无音乐播放";
        [self.playControlButton setBackgroundImage:[UIImage imageNamed:@"room_music_player_play"] forState:UIControlStateNormal];
    }else if(GetCore(MeetingCore).isPlaying == NO && GetCore(MeetingCore).currentMusic != nil) {
        self.musicTitleLabel.text = GetCore(MeetingCore).currentMusic.musicName;
        self.slider.value = GetCore(MeetingCore).soundVol;
        self.nextButton.enabled = YES;
        [self.playControlButton setBackgroundImage:[UIImage imageNamed:@"room_music_player_play"] forState:UIControlStateNormal];
    }
    if (GetCore(MeetingCore).soundVol != 0) {
        self.slider.value = GetCore(MeetingCore).soundVol;
    }else{
        self.slider.value = 50;
    }
    self.playControlButton.enabled = YES;
}

#pragma mark - private method
- (void)onMusicPlayerButtonClick:(UIButton *)sender {
    switch (sender.tag) {
        case TTMusicPlayerViewButtonType_Next:
        {
            if ([self.delegate respondsToSelector:@selector(onPlayNextSongClickPlayerView:)]) {
                [self.delegate onPlayNextSongClickPlayerView:self];
            }
        }
            break;
        case TTMusicPlayerViewButtonType_Play:
        {
            if ([self.delegate respondsToSelector:@selector(onPlaySongClickPlayerView:)]) {
                [self.delegate onPlaySongClickPlayerView:self];
            }
        }
            break;
        case TTMusicPlayerViewButtonType_SongList:
        {
            if ([self.delegate respondsToSelector:@selector(onPlaySongListClickPlayerView:)]) {
                [self.delegate onPlaySongListClickPlayerView:self];
            }
        }
            break;
        default:
            break;
    }
}

#pragma mark - ImRoomCoreClientV2
//获取队列
- (void)onGetRoomQueueSuccessV2:(NSMutableDictionary*)info {
    [self ttUpdateStatus];
}

#pragma mark - MeetingCoreClient
- (void)onUpdateNextMusicName:(NSString *)musicName Artist:(NSString *)artistName {
    [self.musicTitleLabel setText:musicName];
}

#pragma mark - setter & getter

- (TTMusicPlayerSlider *)slider {
    if (!_slider) {
        _slider = [[TTMusicPlayerSlider alloc]init];
        _slider.value = 50;
        _slider.minimumValue = 0;
        _slider.maximumValue = 100;
        _slider.minimumTrackTintColor = UIColorFromRGB(0xffffff);
        _slider.maximumTrackTintColor = UIColorFromRGB(0xffffff);
        [_slider addTarget:self action:@selector(onVolumValueChange:) forControlEvents:UIControlEventValueChanged];
        [_slider setThumbImage:[UIImage imageNamed:@"room_music_player_vol_dot"] forState:UIControlStateNormal];
        
    }
    return _slider;
}

- (UIImageView *)hornIconImageView {
    if (!_hornIconImageView) {
        _hornIconImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"room_music_player_hond"]];
    }
    return _hornIconImageView;
}

- (UILabel *)musicTitleLabel {
    if (!_musicTitleLabel) {
        _musicTitleLabel = [[UILabel alloc]init];
        _musicTitleLabel.font = [UIFont systemFontOfSize:13.f];
        _musicTitleLabel.textColor = UIColorFromRGB(0xffffff);
    }
    return _musicTitleLabel;
}

- (UIButton *)musicListButton {
    if (!_musicListButton) {
        _musicListButton = [[UIButton alloc]init];
        _musicListButton.tag = TTMusicPlayerViewButtonType_SongList;
        [_musicListButton addTarget:self action:@selector(onMusicPlayerButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [_musicListButton setImage:[UIImage imageNamed:@"room_music_player_list"] forState:UIControlStateNormal];
    }
    return _musicListButton;
}

- (UIButton *)nextButton {
    if (!_nextButton) {
        _nextButton = [[UIButton alloc]init];
        _nextButton.tag = TTMusicPlayerViewButtonType_Next;
        [_nextButton addTarget:self action:@selector(onMusicPlayerButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [_nextButton setImage:[UIImage imageNamed:@"room_music_player_next"] forState:UIControlStateNormal];
    }
    
    return _nextButton;
}

- (UIButton *)playControlButton {
    if (!_playControlButton) {
        _playControlButton = [[UIButton alloc]init];
        _playControlButton.tag = TTMusicPlayerViewButtonType_Play;
        [_playControlButton addTarget:self action:@selector(onMusicPlayerButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _playControlButton;
}

@end
