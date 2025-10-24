//
//  TTVoiceTableViewCell.m
//  XC_TTPersonalMoudle
//
//  Created by fengshuo on 2019/6/6.
//  Copyright © 2019 YiZhuan. All rights reserved.
//

#import "TTMineInfoVoiceCell.h"
#import "XCMacros.h"
#import "XCTheme.h"
#import "SVGA.h"
#import "SVGAParserManager.h"
#import <Masonry/Masonry.h>
#import "UIButton+EnlargeTouchArea.h"
//XC_tt
#import "XCHUDTool.h"
//core
#import "FileCore.h"
#import "MediaCore.h"
#import "FileCoreClient.h"
#import "MediaCoreClient.h"
#import "VoiceBottleCore.h"
#import "XCPlayerTool.h"
#import "AuthCore.h"


@interface TTMineInfoVoiceCell ()<FileCoreClient, MediaCoreClient, XCPlayerToolDelegate>
/** 音频背景 */
@property (nonatomic, strong) UIImageView *bgImageView;
/** Ta的声音*/
@property (nonatomic,strong) UILabel *titleLabel;
/** 播放or暂停 */
@property (nonatomic, strong) UIButton *playOrPauseButton;
/** 动画 */
@property (nonatomic, strong) SVGAImageView *svgaImageView;
/** 音频长度 */
@property (nonatomic, strong) UILabel *voiceLenthLabel;
/** 箭头*/
@property (nonatomic,strong) UIImageView *arrowImageView;
/** SVGAParserManager */
@property (nonatomic, strong) SVGAParserManager *parserManager;
/** 语音y信息地址*/
@property (nonatomic, strong) NSString *filePath;

/** 主泰没有声音的时候*/
@property (nonatomic,strong) UIButton *noVoiceButton;
@end

@implementation TTMineInfoVoiceCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self addCore];
        [self initView];
        [self initConstrations];
    }
    return self;
}

#pragma mark - public methods
#pragma mark - delegate

#pragma mark - MediaCoreClient
/** 播放完成 */
- (void)playerToolDidFinish:(XCPlayerTool *)playerTool {
    _playOrPauseButton.selected = NO;
    [self.svgaImageView pauseAnimation];
}
/**
 播放进度的回调
 
 @param playerTool tool
 @param duration 总时间
 @param time 当前播放的时间
 */
- (void)playerTool:(XCPlayerTool *)playerTool duration:(NSInteger)duration time:(NSInteger)time {
    _playOrPauseButton.selected = [XCPlayerTool sharedPlayerTool].isPlaying;
}

#pragma mark - event response
- (void)payeOrPauseVoice {
    if ([XCPlayerTool sharedPlayerTool].isPlaying) {
        [[XCPlayerTool sharedPlayerTool] pause];
        [self.svgaImageView pauseAnimation];
    }else{
        [[XCPlayerTool sharedPlayerTool] startPlay:self.userInfo.userVoice];
        [XCPlayerTool sharedPlayerTool].delegate = self;
        [self.svgaImageView startAnimation];
        [GetCore(VoiceBottleCore) addVoicePlayCountRequestWithVoiceId:0 voiceUid:GetCore(AuthCore).getUid.userIDValue];
    }
    self.playOrPauseButton.selected = [[XCPlayerTool sharedPlayerTool] isPlaying];
}


- (void)noVoiceAction:(UIButton *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(personNoVoiceToAddVoice:)]) {
        [self.delegate personNoVoiceToAddVoice:self];
    }
}


#pragma mark - private method
- (void)addCore {
    AddCoreClient(FileCoreClient, self);
    AddCoreClient(MediaCoreClient, self);
}

- (void)initView {
     [self.contentView addSubview:self.arrowImageView];
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.bgImageView];
    [self.contentView addSubview:self.noVoiceButton];
    [self.bgImageView addSubview:self.playOrPauseButton];
    [self.bgImageView addSubview:self.svgaImageView];
    [self.bgImageView addSubview:self.voiceLenthLabel];
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(payeOrPauseVoice)];
    [self.bgImageView addGestureRecognizer:tap];
    
    [self.playOrPauseButton addTarget:self action:@selector(playOrPauseButton) forControlEvents:UIControlEventTouchUpInside];
 
     [self.noVoiceButton addTarget:self action:@selector(noVoiceAction:) forControlEvents:UIControlEventTouchUpInside];
    [self loadSvgaAnimation:@"voiceMatching_vocal_print"];
}

- (void)loadSvgaAnimation:(NSString *)matchStr {
    
    NSString *matchString = [[NSBundle mainBundle] pathForResource:matchStr ofType:@"svga"];
    NSURL *matchUrl = [NSURL fileURLWithPath:matchString];
    
    @KWeakify(self);
    [self.parserManager loadSvgaWithURL:matchUrl completionBlock:^(SVGAVideoEntity * _Nullable videoItem) {
        @KStrongify(self)
        self.svgaImageView.loops = INT_MAX;
        self.svgaImageView.clearsAfterStop = NO;
        self.svgaImageView.videoItem = videoItem;
        [self.svgaImageView startAnimation];
        [self.svgaImageView pauseAnimation];
    } failureBlock:^(NSError * _Nullable error) {
        
    }];
}

- (void)initConstrations {
    [self.bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.width.mas_equalTo(210);
        make.top.mas_equalTo(30);
        make.height.mas_equalTo(40);
    }];
    
    [self.playOrPauseButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(7);
        make.centerY.mas_equalTo(self.bgImageView);
        make.width.height.mas_equalTo(26);
    }];
    
    [self.noVoiceButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(100, 40));
        make.left.centerY.mas_equalTo(self.bgImageView);
    }];
    
    [self.svgaImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(40);
        make.centerY.mas_equalTo(self.bgImageView);
        make.width.mas_equalTo(47);
        make.height.mas_equalTo(19);
    }];
    
    [self.voiceLenthLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-15);
        make.centerY.mas_equalTo(self.bgImageView);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self).offset(15);
        make.top.mas_equalTo(self);
    }];
    
    [self.arrowImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.contentView);
        make.right.mas_equalTo(self.contentView).offset(-15);
        make.size.mas_equalTo(CGSizeMake(9, 16));
    }];
}
#pragma mark - getters and setters
- (void)setStyle:(TTMineInfoViewStyle)style {
    _style = style;
    self.arrowImageView.hidden = _style == TTMineInfoViewStyleOhter;
    if (_style == TTMineInfoViewStyleDefault) {
        self.titleLabel.text = @"我的声音";
    }else{
        self.titleLabel.text = @"Ta的声音";
    }
}

- (void)setUserInfo:(UserInfo *)userInfo {
    _userInfo = userInfo;
    if (_userInfo) {
        if (_userInfo.userVoice) {
             self.noVoiceButton.hidden = YES;
            self.bgImageView.hidden = NO;
            if (self.style == TTMineInfoViewStyleDefault) {
                self.arrowImageView.hidden = NO;
            }else{
                self.arrowImageView.hidden = YES;
            }
             self.voiceLenthLabel.text = [NSString stringWithFormat:@"%lds", (long)_userInfo.voiceDura];
        } else {
             self.noVoiceButton.hidden = YES;
            if (self.style == TTMineInfoViewStyleDefault) {
               self.noVoiceButton.hidden = NO;
            }
            self.bgImageView.hidden = YES;
             self.voiceLenthLabel.text = @"";
            self.arrowImageView.hidden = YES;
        }
    }
    
    if (![XCPlayerTool sharedPlayerTool].isPlaying) {
        [self.svgaImageView pauseAnimation];
    }
    
    self.playOrPauseButton.selected = [XCPlayerTool sharedPlayerTool].isPlaying;
}

- (UIImageView *)bgImageView {
    if (!_bgImageView) {
        _bgImageView = [[UIImageView alloc] init];
        _bgImageView.image = [UIImage imageNamed:@"voice_my_heard_bg"];
        _bgImageView.userInteractionEnabled = YES;
    }
    return _bgImageView;
}

- (UIButton *)playOrPauseButton {
    if (!_playOrPauseButton) {
        _playOrPauseButton = [[UIButton alloc] init];
        [_playOrPauseButton setImage:[UIImage imageNamed:@"voice_my_play"] forState:UIControlStateNormal];
        [_playOrPauseButton setImage:[UIImage imageNamed:@"voice_my_pause"] forState:UIControlStateSelected];
        _playOrPauseButton.userInteractionEnabled = NO;
    }
    return _playOrPauseButton;
}

- (SVGAImageView *)svgaImageView {
    if (!_svgaImageView) {
        _svgaImageView = [[SVGAImageView alloc]init];
        _svgaImageView.contentMode = UIViewContentModeScaleAspectFill;
        _svgaImageView.userInteractionEnabled = NO;
    }
    return _svgaImageView;
}

- (UILabel *)voiceLenthLabel {
    if (!_voiceLenthLabel) {
        _voiceLenthLabel = [[UILabel alloc] init];
        _voiceLenthLabel.text = @"0s";
        _voiceLenthLabel.textColor = [UIColor whiteColor];
        _voiceLenthLabel.font = [UIFont fontWithName:@"DINAlternate-Bold" size:18];
    }
    return _voiceLenthLabel;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont systemFontOfSize:14];
        _titleLabel.textColor = [XCTheme getMSMainTextColor];
        _titleLabel.text = @"Ta的声音";
    }
    return _titleLabel;
}

- (UIImageView *)arrowImageView {
    if (!_arrowImageView) {
        _arrowImageView = [[UIImageView alloc] init];
        _arrowImageView.image = [UIImage imageNamed:@"person_arrow"];
        _arrowImageView.hidden = YES;
    }
    return _arrowImageView;
}

- (SVGAParserManager *)parserManager {
    if (!_parserManager) {
        _parserManager = [[SVGAParserManager alloc] init];
    }
    return _parserManager;
}

- (UIButton *)noVoiceButton {
    if (!_noVoiceButton) {
        _noVoiceButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_noVoiceButton setBackgroundColor:UIColorFromRGB(0xF6F7F9)];
        _noVoiceButton.layer.masksToBounds = YES;
        _noVoiceButton.layer.cornerRadius = 20;
        [_noVoiceButton setImage:[UIImage imageNamed:@"game_voice_person_no"] forState:UIControlStateNormal];
        _noVoiceButton.hidden = YES;
    }
    return _noVoiceButton;
}

@end
