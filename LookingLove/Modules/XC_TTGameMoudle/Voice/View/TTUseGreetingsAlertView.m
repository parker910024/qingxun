//
//  TTUseGreetingsAlertView.m
//  XC_TTGameMoudle
//
//  Created by Macx on 2019/5/30.
//  Copyright © 2019 YiZhuan. All rights reserved.
//

#import "TTUseGreetingsAlertView.h"

#import "VoiceBottleModel.h"
#import "XCPlayerTool.h"

#import "XCMacros.h"
#import "XCTheme.h"
#import "SVGA.h"
#import "SVGAParserManager.h"
#import <Masonry/Masonry.h>

@interface TTUseGreetingsAlertView ()<XCPlayerToolDelegate>
/** containView */
@property (nonatomic, strong) UIView *containView;
/** 提示 */
@property (nonatomic, strong) UILabel *alertLabel;
/** 内容 */
@property (nonatomic, strong) UILabel *contentLabel;
/** 音频背景 */
@property (nonatomic, strong) UIImageView *bgImageView;
/** 播放or暂停 */
@property (nonatomic, strong) UIButton *playOrPauseButton;
/** 动画 */
@property (nonatomic, strong) SVGAImageView *svgaImageView;
/** 音频长度 */
@property (nonatomic, strong) UILabel *voiceLenthLabel;
/** 重新录制 */
@property (nonatomic, strong) UIButton *reorderButton;
/** 确认使用 */
@property (nonatomic, strong) UIButton *sureUseButton;

/** SVGAParserManager */
@property (nonatomic, strong) SVGAParserManager *parserManager;
@end

@implementation TTUseGreetingsAlertView

#pragma mark - life cycle

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initView];
        [self initConstrations];
    }
    return self;
}

#pragma mark - public methods
- (void)setModel:(VoiceBottleModel *)model {
    _model = model;
    
    self.voiceLenthLabel.text = [NSString stringWithFormat:@"%lds", model.voiceLength];
}

#pragma mark - [系统控件的Protocol]   //注意要把名字改掉，这个MARK只做功能划分，不是一个真正的MARK，每个不一样的Protocol，需要一个新的MARK”

#pragma mark - XCPlayerToolDelegate
/** 播放完成 */
- (void)playerToolDidFinish:(XCPlayerTool *)playerTool {
    [[XCPlayerTool sharedPlayerTool] stop];
    self.playOrPauseButton.selected = YES;
    [self.svgaImageView pauseAnimation];
}

#pragma mark - [core相关的Protocol]  //注意要把名字改掉，这个MARK只做功能划分，不是一个真正的MARK，每个不一样的Protocol，需要一个新的MARK”

#pragma mark - event response
- (void)didClickReorderButton:(UIButton *)button {
    [[XCPlayerTool sharedPlayerTool] stop];
    if (self.delegate && [self.delegate respondsToSelector:@selector(useGreetingsAlertView:didClickRecordButton:)]) {
        [self.delegate useGreetingsAlertView:self didClickRecordButton:button];
    }
}

- (void)didClickSureUseButton:(UIButton *)button {
    [[XCPlayerTool sharedPlayerTool] stop];
    if (self.delegate && [self.delegate respondsToSelector:@selector(useGreetingsAlertView:didClickSureUseButton:)]) {
        [self.delegate useGreetingsAlertView:self didClickSureUseButton:button];
    }
}

- (void)didTapBgView:(UITapGestureRecognizer *)tap {
    // 控制暂停和播放
    XCPlayerTool *player = [XCPlayerTool sharedPlayerTool];
    self.playOrPauseButton.selected = !self.playOrPauseButton.selected;
    if (self.playOrPauseButton.selected) {
        [player pause];
        [self.svgaImageView pauseAnimation];
    } else {
        [self.svgaImageView startAnimation];
        if (player.filePath.length && [player.filePath isEqualToString:self.model.voiceUrl]) {
            [player resume];
        } else {
            player.delegate = self;
            [player startPlay:self.model.voiceUrl];
        }
    }
}

#pragma mark - private method

- (void)initView {
    self.frame = CGRectMake(0, 0, KScreenWidth, KScreenHeight);
    [self addSubview:self.containView];
    [self.containView addSubview:self.alertLabel];
    [self.containView addSubview:self.contentLabel];
    [self.containView addSubview:self.bgImageView];
    [self.bgImageView addSubview:self.playOrPauseButton];
    [self.bgImageView addSubview:self.svgaImageView];
    [self.bgImageView addSubview:self.voiceLenthLabel];
    [self.containView addSubview:self.reorderButton];
    [self.containView addSubview:self.sureUseButton];
    
    // voiceMatching_vocal_print
    [self loadSvgaAnimation:@"voiceMatching_vocal_print"];
}

- (void)initConstrations {
    [self.containView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(self);
        make.width.mas_equalTo(295);
        make.height.mas_equalTo(246);
    }];
    
    [self.alertLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.containView);
        make.top.mas_equalTo(30);
    }];
    
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(18);
        make.right.mas_equalTo(-18);
        make.top.mas_equalTo(60);
    }];
    
    [self.bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(43);
        make.right.mas_equalTo(-43);
        make.top.mas_equalTo(119);
        make.height.mas_equalTo(40);
    }];
    
    [self.playOrPauseButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(7);
        make.centerY.mas_equalTo(self.bgImageView);
        make.width.height.mas_equalTo(26);
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
    
    [self.reorderButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.bottom.mas_equalTo(-15);
        make.width.mas_equalTo(120);
        make.height.mas_equalTo(38);
    }];
    
    [self.sureUseButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-20);
        make.bottom.width.height.mas_equalTo(self.reorderButton);
    }];
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

#pragma mark - getters and setters

- (UIView *)containView {
    if (!_containView) {
        _containView = [[UIView alloc] init];
        _containView.layer.cornerRadius = 14;
        _containView.backgroundColor = [UIColor whiteColor];
    }
    return _containView;
}

- (UILabel *)alertLabel {
    if (!_alertLabel) {
        _alertLabel = [[UILabel alloc] init];
        _alertLabel.text = @"提示";
        _alertLabel.textColor = [XCTheme getTTMainTextColor];
        _alertLabel.font = [UIFont systemFontOfSize:16];
    }
    return _alertLabel;
}

- (UILabel *)contentLabel {
    if (!_contentLabel) {
        _contentLabel = [[UILabel alloc] init];
        _contentLabel.text = @"你已经录制过声音啦，确定使用你的\n“打招呼”还是重新录制呢？";
        _contentLabel.textAlignment = NSTextAlignmentCenter;
        _contentLabel.textColor = [XCTheme getTTMainTextColor];
        _contentLabel.font = [UIFont systemFontOfSize:14];
        _contentLabel.numberOfLines = 0;
    }
    return _contentLabel;
}

- (UIImageView *)bgImageView {
    if (!_bgImageView) {
        _bgImageView = [[UIImageView alloc] init];
        _bgImageView.image = [UIImage imageNamed:@"voice_my_heard_bg"];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapBgView:)];
        [_bgImageView addGestureRecognizer:tap];
        _bgImageView.userInteractionEnabled = YES;
    }
    return _bgImageView;
}

- (UIButton *)playOrPauseButton {
    if (!_playOrPauseButton) {
        _playOrPauseButton = [[UIButton alloc] init];
        [_playOrPauseButton setImage:[UIImage imageNamed:@"voice_my_pause"] forState:UIControlStateNormal];
        [_playOrPauseButton setImage:[UIImage imageNamed:@"voice_my_play"] forState:UIControlStateSelected];
        _playOrPauseButton.selected = YES;
        [_playOrPauseButton addTarget:self action:@selector(didTapBgView:) forControlEvents:UIControlEventTouchUpInside];
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

- (UIButton *)reorderButton {
    if (!_reorderButton) {
        _reorderButton = [[UIButton alloc] init];
        [_reorderButton setTitle:@"重新录制" forState:UIControlStateNormal];
        _reorderButton.titleLabel.font = [UIFont systemFontOfSize:15];
        [_reorderButton setTitleColor:[XCTheme getTTMainColor] forState:UIControlStateNormal];
        _reorderButton.backgroundColor = RGBACOLOR(254, 245, 237, 1);
        _reorderButton.layer.cornerRadius = 19;
        _reorderButton.layer.masksToBounds = YES;
        [_reorderButton addTarget:self action:@selector(didClickReorderButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _reorderButton;
}

- (UIButton *)sureUseButton {
    if (!_sureUseButton) {
        _sureUseButton = [[UIButton alloc] init];
        [_sureUseButton setTitle:@"确定使用" forState:UIControlStateNormal];
        [_sureUseButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _sureUseButton.titleLabel.font = [UIFont systemFontOfSize:15];
        _sureUseButton.backgroundColor = [XCTheme getTTMainColor];
        _sureUseButton.layer.cornerRadius = 19;
        _sureUseButton.layer.masksToBounds = YES;
        [_sureUseButton addTarget:self action:@selector(didClickSureUseButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _sureUseButton;
}

- (SVGAParserManager *)parserManager {
    if (!_parserManager) {
        _parserManager = [[SVGAParserManager alloc] init];
    }
    return _parserManager;
}

@end
