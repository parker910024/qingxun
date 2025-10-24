//
//  TTMusicListPlayerView.m
//  TuTu
//
//  Created by Macx on 2018/11/22.
//  Copyright © 2018 YiZhuan. All rights reserved.
//

#import "TTMusicListPlayerView.h"

// view
#import "TTSlider.h"

//3rd part
#import <Masonry/Masonry.h>
#import "XCMacros.h"

//theme
#import "XCTheme.h"

//core
#import "MeetingCore.h"

typedef enum : NSUInteger {
    TTMusicListPlayerButton_Play           = 1, //播放按钮
    TTMusicListPlayerButton_MixAdjust      = 2, //混响调整按钮
} TTMusicListPlayerButton_Type;

@interface TTMusicListPlayerView ()
/** 分割线 */
@property (nonatomic, strong) UIView *topLineView;
/**
 歌曲名字
 */
@property (strong, nonatomic) UILabel *musicNameLabel;

/**
 暂停、播放按钮
 */
@property (strong, nonatomic) UIButton *pauseButton;

/**
 混响音量调整按钮
 */
@property (strong, nonatomic) UIButton *adjustVoiceButton;

/**
 音量调节按钮
 */
//@property (strong, nonatomic) XCSlider *progressSlider;

@end

@implementation TTMusicListPlayerView

#pragma mark - life cycle

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initView];
        [self initConstrations];
        [self ttUpdateStatus];
    }
    return self;
}

#pragma mark - public methods

- (void)playStatusChangeWithMusicInfo:(MusicInfo *)musicInfo {
    self.musicNameLabel.text = musicInfo.musicName.length > 0 ? musicInfo.musicName : @"暂无歌曲";
    
    if (musicInfo != nil && !GetCore(MeetingCore).isPlaying) { //暂停
        [self.pauseButton setImage:[UIImage imageNamed:@"room_music_list_play"] forState:UIControlStateNormal];
    }else if (!musicInfo && !GetCore(MeetingCore).isPlaying) { //停止
        [self.pauseButton setImage:[UIImage imageNamed:@"room_music_list_play"] forState:UIControlStateNormal];
    }else if (musicInfo && GetCore(MeetingCore).isPlaying) { //播放中
        [self.pauseButton setImage:[UIImage imageNamed:@"room_music_list_pause"] forState:UIControlStateNormal];
    }
}

- (void)ttUpdateMusicName:(NSString *)musicName {
    self.musicNameLabel.text = musicName;
}

#pragma mark - [系统控件的Protocol]   //注意要把名字改掉，这个MARK只做功能划分，不是一个真正的MARK，每个不一样的Protocol，需要一个新的MARK”

#pragma mark - [自定义控件的Protocol] //注意要把名字改掉，这个MARK只做功能划分，不是一个真正的MARK，每个不一样的Protocol，需要一个新的MARK”

#pragma mark - [core相关的Protocol]  //注意要把名字改掉，这个MARK只做功能划分，不是一个真正的MARK，每个不一样的Protocol，需要一个新的MARK”

#pragma mark - event response

- (void)didClickPlayerControlButton:(UIButton *)sender {
    switch (sender.tag) {
        case TTMusicListPlayerButton_Play:
        {
            if ([self.delegate respondsToSelector:@selector(playSongButtonClickPlayerView:)]) {
                [self.delegate playSongButtonClickPlayerView:self];
            }
        }
            break;
        case TTMusicListPlayerButton_MixAdjust:
        {
            if ([self.delegate respondsToSelector:@selector(adjustMixButtonClickPlayerView:)]) {
                [self.delegate adjustMixButtonClickPlayerView:self];
            }
        }
            break;
        default:
            break;
    }
}

#pragma mark - private method

- (void)initView {
    self.backgroundColor = [UIColor whiteColor];
    
    [self addSubview:self.adjustVoiceButton];
    [self addSubview:self.pauseButton];
    [self addSubview:self.musicNameLabel];
//    [self addSubview:self.progressSlider];
    [self addSubview:self.topLineView];
}

- (void)initConstrations {
    [self.topLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.mas_equalTo(self);
        make.height.mas_equalTo(1);
    }];
    [self.adjustVoiceButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.mas_equalTo(self.mas_trailing);
        make.top.mas_equalTo(self.mas_top);
        make.bottom.mas_equalTo(self.mas_bottom);
        make.width.mas_equalTo(46);
    }];
    [self.pauseButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self).offset(18);
        make.width.height.mas_equalTo(43);
        make.centerY.mas_equalTo(self);
    }];
    [self.musicNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.pauseButton.mas_trailing).offset(15);
        make.width.mas_equalTo([UIScreen mainScreen].bounds.size.width * 0.6);
        make.centerY.mas_equalTo(self);
    }];
    
//    [self.progressSlider mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.mas_equalTo(self).offset(82);
//        make.right.mas_equalTo(self).offset(-127 * KScreenWidth / 375);
//        make.top.mas_equalTo(self.musicNameLabel.mas_bottom).offset(6.5);
//    }];
}

- (void)ttUpdateStatus {
    self.musicNameLabel.text = GetCore(MeetingCore).currentMusic.musicName.length > 0 ? GetCore(MeetingCore).currentMusic.musicName : @"暂无歌曲";
}

#pragma mark - getters and setters

- (UIView *)topLineView {
    if (!_topLineView) {
        _topLineView = [[UIView alloc] init];
        _topLineView.backgroundColor = RGBCOLOR(240, 240, 240);
    }
    return _topLineView;
}

- (UILabel *)musicNameLabel {
    if (!_musicNameLabel) {
        _musicNameLabel = [[UILabel alloc]init];
        _musicNameLabel.textColor = [XCTheme getTTMainTextColor];
        _musicNameLabel.font = [UIFont systemFontOfSize:14.f];
    }
    return _musicNameLabel;
}

- (UIButton *)pauseButton {
    if (!_pauseButton) {
        _pauseButton = [[UIButton alloc]init];
        _pauseButton.tag = TTMusicListPlayerButton_Play;
        [_pauseButton addTarget:self action:@selector(didClickPlayerControlButton:) forControlEvents:UIControlEventTouchUpInside];
        if (GetCore(MeetingCore).isPlaying) {
            [_pauseButton setImage:[UIImage imageNamed:@"room_music_list_play"] forState:UIControlStateNormal];
        }else{
            [_pauseButton setImage:[UIImage imageNamed:@"room_music_list_pause"] forState:UIControlStateNormal];
        }
        
    }
    return _pauseButton;
}

- (UIButton *)adjustVoiceButton {
    if (!_adjustVoiceButton) {
        _adjustVoiceButton = [[UIButton alloc]init];
        _adjustVoiceButton.tag = TTMusicListPlayerButton_MixAdjust;
        [_adjustVoiceButton setImage:[UIImage imageNamed:@"room_music_list_volume_change"] forState:UIControlStateNormal];
        [_adjustVoiceButton addTarget:self action:@selector(didClickPlayerControlButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _adjustVoiceButton;
}

//- (XCSlider *)progressSlider {
//    if (!_progressSlider) {
//        _progressSlider = [[XCSlider alloc]init];
//        _progressSlider.value = 50;
//        _progressSlider.minimumValue = 0;
//        _progressSlider.maximumValue = 100;
//        _progressSlider.minimumTrackTintColor = RGBCOLOR(32, 151, 251);
//        _progressSlider.maximumTrackTintColor = RGBCOLOR(153, 153, 153);
//        [_progressSlider addTarget:self action:@selector(onVolumSliderValueChange:) forControlEvents:UIControlEventValueChanged];
//    }
//    return _progressSlider;
//}

@end
