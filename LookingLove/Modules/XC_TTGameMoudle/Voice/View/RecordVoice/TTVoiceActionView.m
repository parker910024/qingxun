//
//  TTVoiceActionView.m
//  XC_TTGameMoudle
//
//  Created by fengshuo on 2019/5/31.
//  Copyright © 2019 YiZhuan. All rights reserved.
//

#import "TTVoiceActionView.h"

#import "TTVoiceProgressView.h"

#import "XCTheme.h"
#import <Masonry/Masonry.h>
#import "XCMacros.h"
#import "XCFloatView.h"
#import "TTPopup.h"
#import "XCMediator+TTRoomMoudleBridge.h"

#define kScale (KScreenWidth / 375)

@interface  TTVoiceActionView ()

/** 重新录*/
@property (nonatomic, strong) UIButton * restartButton;
/** 重新录*/
@property (nonatomic, strong) UILabel * restartLabel;
/** 完成*/
@property (nonatomic, strong) UIButton * completeButton;
/** 录音的进度条*/
@property (nonatomic,strong) TTVoiceProgressView *progressView;
@end

@implementation TTVoiceActionView

#pragma mark - life cyecle
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initView];
        [self initContrations];
    }
    return self;
}
#pragma mark - public method
- (void)updateProgress:(NSUInteger)progress {
    if (progress > 60) {
        progress = 60;
    }
    if (progress < 0) {
        progress = 0;
    }
    [self.progressView updateProgress:progress/60.0];
}


#pragma mark - response
- (void)restartButtonClick:(UIButton *)sender {
    if (self.delegate  && [self.delegate respondsToSelector:@selector(ttVoiceActionView:didClickRestart:)]) {
        [self.delegate ttVoiceActionView:self didClickRestart:sender];
    }
}

- (void)completeButtonClick:(UIButton *)sender {
    
    if (![XCFloatView shareFloatView].hidden) {  // 如果房间最小化状态下
        [TTPopup alertWithMessage:@"当前正在房间无法录音，是否关闭房间？" confirmHandler:^{
            // 关闭房间
            [[XCMediator sharedInstance] ttRoomMoudle_closeRoomViewController];
        } cancelHandler:^{
            // 没事做
        }];
        return;
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(ttVoiceActionView:didClickComplete:)]) {
        [self.delegate ttVoiceActionView:self didClickComplete:sender];
    }
}

- (void)auditionButtonClick:(UIButton *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(ttVoiceActionView:didClickAudition:)]) {
        [self.delegate ttVoiceActionView:self didClickAudition:sender];
    }
}

#pragma mark - private method
- (void)initView {
    [self addSubview:self.progressView];
    [self addSubview:self.restartButton];
    [self addSubview:self.restartLabel];
    [self addSubview:self.completeButton];
    [self addSubview:self.auditionButton];
    [self addSubview:self.auditionLabel];
    
    [self addAction];
}

- (void)initContrations {
    [self.restartButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(56 * kScale);
        make.right.mas_equalTo(self.completeButton.mas_left).offset(-36 * kScale);
        make.centerY.mas_equalTo(self.completeButton);
    }];
    
    [self.restartLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.centerX.mas_equalTo(self.restartButton);
        make.top.mas_equalTo(self.restartButton.mas_bottom).offset(10 * kScale);
    }];
    
    [self.completeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(74 * kScale);
        make.center.mas_equalTo(self);
    }];
    
    [self.auditionButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(56 * kScale);
        make.left.mas_equalTo(self.completeButton.mas_right).offset(36 * kScale);
        make.top.mas_equalTo(self.restartButton);
    }];
    
    [self.auditionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.centerX.mas_equalTo(self.auditionButton);
        make.top.mas_equalTo(self.auditionButton.mas_bottom).offset(10 * kScale);
    }];
    
    [self.progressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(@(86 * kScale));
        make.center.equalTo(self.completeButton);
    }];
}

- (void)addAction {
    [self.restartButton addTarget:self action:@selector(restartButtonClick:) forControlEvents:UIControlEventTouchUpInside];
      [self.completeButton addTarget:self action:@selector(completeButtonClick:) forControlEvents:UIControlEventTouchUpInside];
      [self.auditionButton addTarget:self action:@selector(auditionButtonClick:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)hiddenView {
    self.progressView.hidden = YES;
    self.restartButton.hidden = YES;
    self.restartLabel.hidden = YES;
    self.completeButton.hidden = YES;
    self.auditionLabel.hidden = YES;
    self.auditionButton.hidden = YES;
}

#pragma mark - setters and getters
- (void)setRecordState:(HandleActionRecordState)recordState {
    _recordState = recordState;
    if (_recordState) {
        [self hiddenView];
    }
    switch (_recordState) {
            //录音
        case HandleActionRecordState_Prepare:
            self.completeButton.hidden = NO;
            [self.completeButton setImage:[UIImage imageNamed:@"game_voice_record_prepare"] forState:UIControlStateNormal];
            [self.completeButton setImage:[UIImage imageNamed:@"game_voice_record_prepare"] forState:UIControlStateSelected];
            break;
            
            //正在录音
        case HandleActionRecordState_Record:
            self.progressView.hidden = NO;
            self.completeButton.hidden = NO;
            [self.completeButton setImage:[UIImage imageNamed:@"game_voice_record_record"] forState:UIControlStateNormal];
            [self.completeButton setImage:[UIImage imageNamed:@"game_voice_record_record"] forState:UIControlStateSelected];
            break;
            
            //录音完成了
        case HandleActionRecordState_Finshed:
            self.restartButton.hidden = NO;
            self.restartLabel.hidden = NO;
            self.completeButton.hidden = NO;
            self.auditionLabel.hidden = NO;
            self.auditionButton.hidden = NO;
            [self.completeButton setImage:[UIImage imageNamed:@"game_voice_record_complete"] forState:UIControlStateNormal];
            [self.completeButton setImage:[UIImage imageNamed:@"game_voice_record_complete"] forState:UIControlStateSelected];

            break;
            
        default:
            break;
    }
}


- (UIButton *)restartButton {
    if (!_restartButton) {
        _restartButton =[UIButton buttonWithType:UIButtonTypeCustom];
        [_restartButton setImage:[UIImage imageNamed:@"game_voice_record_restart"] forState:UIControlStateNormal];
    }
    return _restartButton;
}

- (UIButton *)completeButton {
    if (!_completeButton) {
        _completeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_completeButton setImage:[UIImage imageNamed:@"game_voice_record_complete"] forState:UIControlStateNormal];
    }
    return _completeButton;
}

- (UIButton *)auditionButton {
    if (!_auditionButton) {
        _auditionButton = [[UIButton alloc] init];
        [_auditionButton setImage:[UIImage imageNamed:@"game_voice_record_start"] forState:UIControlStateNormal];
        [_auditionButton setImage:[UIImage imageNamed:@"game_voice_record_puase"] forState:UIControlStateSelected];
    }
    return _auditionButton;
}

- (UILabel *)restartLabel {
    if (!_restartLabel) {
        _restartLabel = [[UILabel alloc] init];
        _restartLabel.text = @"重录";
        _restartLabel.textAlignment = NSTextAlignmentCenter;
        _restartLabel.textColor = [UIColor whiteColor];
        _restartLabel.font = [UIFont systemFontOfSize:11];
    }
    return _restartLabel;
}

- (UILabel *)auditionLabel {
    if (!_auditionLabel) {
        _auditionLabel = [[UILabel alloc] init];
        _auditionLabel.text = @"试听";
        _auditionLabel.textAlignment = NSTextAlignmentCenter;
        _auditionLabel.textColor = [UIColor whiteColor];
        _auditionLabel.font = [UIFont systemFontOfSize:11];
    }
    return _auditionLabel;
}

- (TTVoiceProgressView *)progressView {
    if (!_progressView) {
        _progressView = [[TTVoiceProgressView alloc] initWithLineWidth:4.0];
        _progressView.outLayer.hidden = YES;
    }
    return _progressView;
}

@end
