//
//  TTAdjustMixView.m
//  TuTu
//
//  Created by Macx on 2018/11/22.
//  Copyright © 2018 YiZhuan. All rights reserved.
//

#import "TTAdjustMixView.h"

//core
#import "MeetingCore.h"

//theme
#import "XCTheme.h"

//const
#import "XCMacros.h"

//3rd part
#import <Masonry/Masonry.h>

typedef enum : NSUInteger {
    TTAdjustMixValueChange_Sound = 1,  //音乐声音调整
    TTAdjustMixValueChange_Voice = 2,  //人声声音调整
} TTAdjustMixValueChange;

@interface TTAdjustMixView ()

/** 分割线 */
@property (nonatomic, strong) UIView *topLineView;

/**
 音乐声音标题
 */
@property (strong, nonatomic) UILabel *soundLabel;

/**
 人声声音标题
 */
@property (strong, nonatomic) UILabel *voiceLabel;

/**
 音乐音量调节滑块
 */
@property (strong, nonatomic) UISlider *soundVolumeSlider;

/**
 人声音量调节滑块
 */
@property (strong, nonatomic) UISlider *voiceVolumeSlider;

/**
 音乐音量标签
 */
@property (strong, nonatomic) UILabel *soundVolumeLabel;

/**
 人声音量标签
 */
@property (strong, nonatomic) UILabel *voiceVolumeLabel;

@end

@implementation TTAdjustMixView

#pragma mark - life cycle

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initView];
        [self initConstrations];
        [self updateStatus];
    }
    return self;
}

#pragma mark - public methods

#pragma mark - [系统控件的Protocol]   //注意要把名字改掉，这个MARK只做功能划分，不是一个真正的MARK，每个不一样的Protocol，需要一个新的MARK”

#pragma mark - [自定义控件的Protocol] //注意要把名字改掉，这个MARK只做功能划分，不是一个真正的MARK，每个不一样的Protocol，需要一个新的MARK”

#pragma mark - [core相关的Protocol]  //注意要把名字改掉，这个MARK只做功能划分，不是一个真正的MARK，每个不一样的Protocol，需要一个新的MARK”

#pragma mark - event response

- (void)onSliderValueChange:(UISlider *)sender {
    switch (sender.tag) {
        case TTAdjustMixValueChange_Voice:
        {
            GetCore(MeetingCore).voiceVol = sender.value;
            GetCore(MeetingCore).isVoiceOperated = YES;
            self.voiceVolumeLabel.text = [[NSString stringWithFormat:@"%ld",(NSInteger)sender.value] stringByAppendingString:@"%"];
            
            if ([self.delegate respondsToSelector:@selector(adjustMixView:adjustVoiceVolFromMixView:)]) {
                [self.delegate adjustMixView:self adjustVoiceVolFromMixView:sender.value];
            }
        }
            break;
        case TTAdjustMixValueChange_Sound:
        {
            GetCore(MeetingCore).soundVol = sender.value;
            [GetCore(MeetingCore) adjustMusicSoundVol:sender.value];
            self.soundVolumeLabel.text = [[NSString stringWithFormat:@"%ld",(NSInteger)sender.value] stringByAppendingString:@"%"];
            
            if ([self.delegate respondsToSelector:@selector(adjustMixView:adjustSoundVolFromMixView:)]) {
                [self.delegate adjustMixView:self adjustSoundVolFromMixView:sender.value];
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
    
    [self addSubview:self.topLineView];
    [self addSubview:self.soundLabel];
    [self addSubview:self.voiceLabel];
    [self addSubview:self.soundVolumeLabel];
    [self addSubview:self.voiceVolumeLabel];
    [self addSubview:self.soundVolumeSlider];
    [self addSubview:self.voiceVolumeSlider];
}

- (void)initConstrations {
    [self.topLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(1);
        make.left.right.top.mas_equalTo(self);
    }];
    [self.voiceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.mas_leading).offset(20);
        make.top.mas_equalTo(self.mas_top).offset(23);
    }];
    [self.voiceVolumeSlider mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self).offset(55);
        make.right.mas_equalTo(self).offset(-49);
        make.centerY.mas_equalTo(self.voiceLabel.mas_centerY);
    }];
    [self.voiceVolumeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.mas_equalTo(self.mas_trailing).offset(-15);
        make.centerY.mas_equalTo(self.voiceLabel.mas_centerY);
    }];
    
    [self.soundLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.voiceLabel);
        make.top.mas_equalTo(self.voiceLabel.mas_bottom).offset(20);
    }];
    [self.soundVolumeSlider mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.voiceVolumeSlider);
        make.centerY.mas_equalTo(self.soundLabel.mas_centerY);
    }];
    [self.soundVolumeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.mas_equalTo(self.voiceVolumeLabel);
        make.centerY.mas_equalTo(self.soundLabel.mas_centerY);
    }];
}

- (void)updateStatus {
    
    self.voiceVolumeSlider.value = GetCore(MeetingCore).voiceVol == 0 && GetCore(MeetingCore).isVoiceOperated == NO ? 50 : GetCore(MeetingCore).voiceVol;
    self.soundVolumeSlider.value = GetCore(MeetingCore).soundVol == 0 ? 50 : GetCore(MeetingCore).soundVol;
    
    
    NSString * soundValue = [NSString stringWithFormat:@"%ld%%", GetCore(MeetingCore).soundVol == 0 ? 50 : GetCore(MeetingCore).soundVol];
    self.soundVolumeLabel.text = soundValue;
    
    NSString * voiceValue = [NSString stringWithFormat:@"%ld%%", GetCore(MeetingCore).voiceVol == 0 ? 50 : GetCore(MeetingCore).voiceVol];
    self.voiceVolumeLabel.text = voiceValue;
}

#pragma mark - getters and setters

- (UIView *)topLineView {
    if (!_topLineView) {
        _topLineView = [[UIView alloc] init];
        _topLineView.backgroundColor = RGBCOLOR(240, 240, 240);
    }
    return _topLineView;
}

- (UILabel *)soundLabel {
    if (!_soundLabel) {
        _soundLabel = [[UILabel alloc]init];
        _soundLabel.textColor = RGBCOLOR(153, 153, 153);
        _soundLabel.font = [UIFont systemFontOfSize:13.f];
        _soundLabel.text = @"音乐";
    }
    return _soundLabel;
}

- (UILabel *)voiceLabel {
    if (!_voiceLabel) {
        _voiceLabel = [[UILabel alloc]init];
        _voiceLabel.textColor = RGBCOLOR(153, 153, 153);
        _voiceLabel.font = [UIFont systemFontOfSize:13.f];
        _voiceLabel.text = @"人声";
    }
    return _voiceLabel;
}

- (UISlider *)soundVolumeSlider {
    if (!_soundVolumeSlider) {
        _soundVolumeSlider = [[UISlider alloc]init];
        _soundVolumeSlider.value = 50;
        _soundVolumeSlider.minimumValue = 0;
        _soundVolumeSlider.maximumValue = 100;
        _soundVolumeSlider.minimumTrackTintColor = [XCTheme getTTMainColor];
        _soundVolumeSlider.maximumTrackTintColor = RGBCOLOR(225, 225, 225);
        _soundVolumeSlider.tag = TTAdjustMixValueChange_Sound;
        [_soundVolumeSlider setThumbImage:[UIImage imageNamed:@"room_music_list_vol_dot"] forState:UIControlStateNormal];
        [_soundVolumeSlider addTarget:self action:@selector(onSliderValueChange:) forControlEvents:UIControlEventValueChanged];
        
    }
    return _soundVolumeSlider;
}

- (UISlider *)voiceVolumeSlider {
    if (!_voiceVolumeSlider) {
        _voiceVolumeSlider = [[UISlider alloc]init];
        _voiceVolumeSlider.value = 50;
        _voiceVolumeSlider.minimumValue = 0;
        _voiceVolumeSlider.maximumValue = 100;
        _voiceVolumeSlider.minimumTrackTintColor = [XCTheme getTTMainColor];
        _voiceVolumeSlider.maximumTrackTintColor = RGBCOLOR(225, 225, 225);
        _voiceVolumeSlider.tag = TTAdjustMixValueChange_Voice;
        [_voiceVolumeSlider setThumbImage:[UIImage imageNamed:@"room_music_list_vol_dot"] forState:UIControlStateNormal];
        [_voiceVolumeSlider addTarget:self action:@selector(onSliderValueChange:) forControlEvents:UIControlEventValueChanged];
    }
    return _voiceVolumeSlider;
}

- (UILabel *)soundVolumeLabel {
    if (!_soundVolumeLabel) {
        _soundVolumeLabel = [[UILabel alloc]init];
        _soundVolumeLabel.font = [UIFont systemFontOfSize:12.f];
        _soundVolumeLabel.textColor = RGBCOLOR(153, 153, 153);
    }
    return _soundVolumeLabel;
}

- (UILabel *)voiceVolumeLabel {
    if (!_voiceVolumeLabel) {
        _voiceVolumeLabel = [[UILabel alloc]init];
        _voiceVolumeLabel.font = [UIFont systemFontOfSize:12.f];
        _voiceVolumeLabel.textColor = RGBCOLOR(153, 153, 153);
    }
    return _voiceVolumeLabel;
}

@end
