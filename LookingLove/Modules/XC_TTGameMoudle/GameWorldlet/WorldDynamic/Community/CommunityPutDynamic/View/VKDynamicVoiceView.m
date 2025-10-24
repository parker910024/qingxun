//
//  VKDynamicVoiceView.m
//  UKiss
//
//  Created by apple on 2019/2/20.
//  Copyright © 2019 yizhuan. All rights reserved.
//

#import "VKDynamicVoiceView.h"
#import <UIImage+GIF.h>
#import "UIView+XCToast.h"
#import "UIView+NTES.h"
#import "XCMacros.h"
#import "XCTheme.h"

@interface VKDynamicVoiceView ()
///声音背景view
@property (nonatomic, strong) UIImageView *voiceBgView;
///声音气泡
@property (nonatomic, strong) UIImageView *voiceImg;
///声音lab
@property (nonatomic, strong) UILabel *durationLab;
///删除按钮
@property (nonatomic, strong) UIButton *deleteBtn;

@property (nonatomic, strong) UIButton *playBtn;
@end

@implementation VKDynamicVoiceView

#pragma mark - life cycle

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initView];
        [self initConstrations];
    }
    return self;
}

#pragma mark - public methods

#pragma mark - [系统控件的Protocol]

#pragma mark - [自定义控件的Protocol]

#pragma mark - [core相关的Protocol] 

#pragma mark - event response

- (void)didClickDeleteButton:(UIButton *)button {
    if (self.delegate && [self.delegate respondsToSelector:@selector(deleteVoice)]) {
        [self.delegate deleteVoice];
    }
}

- (void)tapVoiceImg:(UITapGestureRecognizer *)tap {
    self.voiceBgView.userInteractionEnabled = NO;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.voiceBgView.userInteractionEnabled = YES;
    });
    self.isPlaying = !self.isPlaying;
    if (self.delegate && [self.delegate respondsToSelector:@selector(tapVoiceImageActionWithIsPlaying:)]) {
        [self.delegate tapVoiceImageActionWithIsPlaying:self.isPlaying];
    }
}

#pragma mark - private method

- (void)initView {
    [self addSubview:self.voiceBgView];
    [self addSubview:self.deleteBtn];
    [self.voiceBgView addSubview:self.voiceImg];
    [self.voiceBgView addSubview:self.playBtn];
    [self.voiceBgView addSubview:self.durationLab];
}

- (void)initConstrations {
    self.playBtn.frame = CGRectMake(15, 10, 40, 40);
    self.voiceImg.left = self.playBtn.right + 10;
    self.voiceImg.centerY = 30;
    self.deleteBtn.left = CGRectGetMaxX(self.voiceBgView.frame) + 17;
    self.deleteBtn.centerY = 30;
}

#pragma mark - getters and setters

- (void)setIsPlaying:(BOOL)isPlaying {
//    if (isPlaying == _isPlaying) return;
    _isPlaying = isPlaying;
    if (_isPlaying) {
        NSString  *filePath = [[NSBundle bundleWithPath:[[NSBundle mainBundle] bundlePath]] pathForResource:@"community_speech_playing.gif" ofType:nil];
        NSData  *imageData = [NSData dataWithContentsOfFile:filePath];
        self.voiceImg.image = [UIImage sd_animatedGIFWithData:imageData];
    }else {
        self.voiceImg.image = [UIImage imageNamed:@"community_speech_bg"];
    }
    self.playBtn.selected = isPlaying;
}

- (void)setIsDynamicList:(BOOL)isDynamicList {
    _isDynamicList = isDynamicList;
    self.deleteBtn.hidden = isDynamicList;
}


- (void)setDuration:(CGFloat)duration {
    if (duration == 0) return;
    _duration = duration;
    self.durationLab.text = [NSString stringWithFormat:@"%dS",(int)duration];
    [self.durationLab sizeToFit];
    self.durationLab.centerY = self.voiceImg.centerY;
    self.durationLab.right = self.voiceBgView.width - 15;
}

//- (void)setIsPiaComment:(BOOL)isPiaComment {
//    _isPiaComment = isPiaComment;
//    if (isPiaComment) {
//        self.durationLab.text = @"戏";
//        [self.durationLab sizeToFit];
//        self.durationLab.centerY = self.voiceImg.centerY;
//        self.durationLab.right = self.voiceBgView.width - 15;
//    }
//}

- (UIImageView *)voiceBgView {
    if (!_voiceBgView) {
//        _voiceBgView = [[UIImageView alloc]initWithFrame:CGRectMake(16, 0, 248, 60)];
        _voiceBgView = [[UIImageView alloc]init];

        _voiceBgView.image = [UIImage imageNamed:@"dynamic_play_voice_bg"];
        [_voiceBgView sizeToFit];
        _voiceBgView.left = 20;
//        _voiceBgView.backgroundColor = UIColorFromRGB(0x222222);
//        _voiceBgView.layer.cornerRadius = 22;
//        _voiceBgView.layer.masksToBounds = YES;
        _voiceBgView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapVoiceImg:)];
        [_voiceBgView addGestureRecognizer:tap];
    }
    return _voiceBgView;
}

- (UIImageView *)voiceImg {
    if (!_voiceImg) {
        _voiceImg = [[UIImageView alloc]init];
        _voiceImg.image = [UIImage imageNamed:@"community_speech_bg"];
        [_voiceImg sizeToFit];
    }
    return _voiceImg;
}

- (UIButton *)deleteBtn {
    if (!_deleteBtn) {
        _deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_deleteBtn setBackgroundImage:[UIImage imageNamed:@"community_delete_voice_put"] forState:UIControlStateNormal];
        [_deleteBtn sizeToFit];
        [_deleteBtn addTarget:self action:@selector(didClickDeleteButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _deleteBtn;
}

- (UILabel *)durationLab {
    if (!_durationLab) {
        _durationLab = [[UILabel alloc]init];
        _durationLab.textColor = UIColorFromRGB(0xFFFFFF);
        _durationLab.font = [UIFont systemFontOfSize:14];
    }
    return _durationLab;
}

- (UIButton *)playBtn{
    if (!_playBtn) {
        _playBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _playBtn.userInteractionEnabled = NO;
        [_playBtn setImage:[UIImage imageNamed:@"dynamic_play_voice"] forState:UIControlStateNormal];
        [_playBtn setImage:[UIImage imageNamed:@"dynamic_pause_voice"] forState:UIControlStateSelected];
    }
    return _playBtn;
}

@end
