//
//  TTVoiceBottleView.m
//  XC_TTGameMoudle
//
//  Created by Macx on 2019/5/31.
//  Copyright © 2019 YiZhuan. All rights reserved.
//

#import "TTVoiceBottleView.h"
#import "TTVoiceProgressView.h"

#import "BaseAttrbutedStringHandler+Voice.h"
#import "NSString+Voice.h"

#import "VoiceBottleModel.h"

#import "XCTheme.h"
#import "XCMacros.h"
#import "UIImageView+QiNiu.h"
#import "TTStatisticsService.h"

#import <Masonry/Masonry.h>
#import <YYText/YYLabel.h>

#define kScale (KScreenWidth / 375)

@interface TTVoiceBottleView ()
/** 瓶子gif */
@property (nonatomic, strong) SVGAImageView *bottleImageView;
/** 飘动的"心"gif */
@property (nonatomic, strong) SVGAImageView *heartImageView;
/** containView */
@property (nonatomic, strong) UIView *containView;
/** 头像 */
@property (nonatomic, strong) UIImageView *avatarBottomImageView;
/** 头像 */
@property (nonatomic, strong) UIImageView *avatarImageView;
/** 举报 */
@property (nonatomic, strong) UIButton *reportButton;
/** 昵称 + 性别 + 星座 + 位置 */
@property (nonatomic, strong) YYLabel *nickLabel;
/** 暂停or播放 */
@property (nonatomic, strong) UIButton *playOrPauseButton;
/** 播放进度的view */
@property (nonatomic, strong) TTVoiceProgressView *progressView;
/** 喜欢icon */
@property (nonatomic, strong) UIImageView *likeImageView;
/** 喜欢数 */
@property (nonatomic, strong) UILabel *likeLabel;

/** SVGAParserManager */
@property (nonatomic, strong) SVGAParserManager *parserManager;
@end

@implementation TTVoiceBottleView

#pragma mark - life cycle

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initView];
        [self initConstrations];
    }
    return self;
}

#pragma mark - public methods
- (void)setBottleModel:(VoiceBottleModel *)bottleModel {
    _bottleModel = bottleModel;
    
    [self.avatarImageView qn_setImageImageWithUrl:bottleModel.avatar placeholderImage:[XCTheme defaultTheme].placeholder_image_square type:ImageTypeUserIcon];
    [self.avatarBottomImageView qn_setImageImageWithUrl:bottleModel.avatar placeholderImage:[XCTheme defaultTheme].placeholder_image_square type:ImageTypeUserIcon];
    [self resetBottleView];
    
    // 设置昵称
    UserInfo *userInfo = [[UserInfo alloc] init];
    userInfo.nick = bottleModel.nick;
    userInfo.gender = bottleModel.gender;
    userInfo.birth = bottleModel.birth;
    
    self.nickLabel.attributedText = [BaseAttrbutedStringHandler creatNick_Sex_Constellation_CityLimitByUserInfo:userInfo location:bottleModel.location textColor:[XCTheme getTTMainTextColor] font:[UIFont boldSystemFontOfSize:18]];
    
    self.likeLabel.text = [NSString countNumberFormatStr:bottleModel.likeCount];
}

- (void)resetBottleView {
    [self.progressView updateProgress:0];
    self.playOrPauseButton.selected = NO;
}

#pragma mark - [系统控件的Protocol]   //注意要把名字改掉，这个MARK只做功能划分，不是一个真正的MARK，每个不一样的Protocol，需要一个新的MARK”

#pragma mark - SwipeableViewProtocol
- (BOOL)enableSwipe {
    return YES;
}

#pragma mark - XCPlayerToolDelegate
/** 播放完成 */
- (void)playerToolDidFinish:(XCPlayerTool *)playerTool {
    [playerTool rePlay];
}

/**
 播放进度的回调
 
 @param playerTool tool
 @param duration 总时间
 @param time 当前播放的时间
 */
- (void)playerTool:(XCPlayerTool *)playerTool duration:(NSInteger)duration time:(NSInteger)time {
    CGFloat progress = (CGFloat)time / duration;
    [self.progressView updateProgress:progress];
}

#pragma mark - [core相关的Protocol]  //注意要把名字改掉，这个MARK只做功能划分，不是一个真正的MARK，每个不一样的Protocol，需要一个新的MARK”

#pragma mark - event response
- (void)didClickReportButton:(UIButton *)button {
    if (self.delegate && [self.delegate respondsToSelector:@selector(voiceBottleView:didClickReportButton:)]) {
        [self.delegate voiceBottleView:self didClickReportButton:button];
    }
}

- (void)didClickPlayOrPauseButton:(UIButton *)button {
    button.selected = !button.selected;
    if (button.selected) {
        [[XCPlayerTool sharedPlayerTool] pause];
        [TTStatisticsService trackEvent:@"soundmatch_suspend" eventDescribe:@"声音瓶子-暂停"];
    } else {
        [[XCPlayerTool sharedPlayerTool] resume];
        [TTStatisticsService trackEvent:@"soundmatch_suspend" eventDescribe:@"声音瓶子-播放"];
    }
}

#pragma mark - private method

- (void)initView {
    [self addSubview:self.heartImageView];
    [self addSubview:self.bottleImageView];
    [self addSubview:self.containView];
    [self.containView addSubview:self.avatarBottomImageView];
    [self.containView addSubview:self.avatarImageView];
    [self.containView addSubview:self.reportButton];
    [self.containView addSubview:self.nickLabel];
    [self.containView addSubview:self.progressView];
    [self.containView addSubview:self.playOrPauseButton];
    [self.containView addSubview:self.likeImageView];
    [self.containView addSubview:self.likeLabel];

    NSString *bottlePath = [[NSBundle mainBundle] pathForResource:@"voiceMatching_bottle" ofType:@"svga"];
    NSURL *bottleUrl = [NSURL fileURLWithPath:bottlePath];
    
    @KWeakify(self);
    [self.parserManager loadSvgaWithURL:bottleUrl completionBlock:^(SVGAVideoEntity * _Nullable videoItem) {
        @KStrongify(self)
        self.bottleImageView.loops = INT_MAX;
        self.bottleImageView.clearsAfterStop = NO;
        self.bottleImageView.videoItem = videoItem;
        [self.bottleImageView startAnimation];
    } failureBlock:^(NSError * _Nullable error) {
        
    }];
    
    NSString *heartPath = [[NSBundle mainBundle] pathForResource:@"voiceMatching_bubble" ofType:@"svga"];
    NSURL *heartUrl = [NSURL fileURLWithPath:heartPath];
    
    [self.parserManager loadSvgaWithURL:heartUrl completionBlock:^(SVGAVideoEntity * _Nullable videoItem) {
        @KStrongify(self)
        self.heartImageView.loops = INT_MAX;
        self.heartImageView.clearsAfterStop = NO;
        self.heartImageView.videoItem = videoItem;
        [self.heartImageView startAnimation];
    } failureBlock:^(NSError * _Nullable error) {
        
    }];
}

- (void)initConstrations {
    UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    UIView *whiteView = [[UIView alloc] init];
    whiteView.backgroundColor = RGBACOLOR(255, 255, 255, 0.5);
    
    [self.avatarBottomImageView insertSubview:effectView atIndex:0];
    [effectView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.mas_equalTo(self.avatarBottomImageView);
    }];
    
    [self.avatarBottomImageView insertSubview:whiteView aboveSubview:effectView];
    [whiteView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.mas_equalTo(effectView);
    }];
    
    [self.heartImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.mas_equalTo(self);
        make.bottom.mas_equalTo(-100);
    }];
    
    [self.bottleImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.mas_equalTo(self.heartImageView);
    }];
    
    [self.containView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.bottleImageView);
        make.top.mas_equalTo(100 * kScale);
        make.height.mas_equalTo(341 * kScale);
    }];
    
    [self.avatarImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(self.avatarBottomImageView);
        make.width.height.mas_equalTo(80 * kScale);
    }];
    
    [self.avatarBottomImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self);
        make.top.mas_equalTo(102 * kScale);
        make.width.height.mas_equalTo(90 * kScale);
    }];
    
    [self.reportButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self);
        make.top.mas_equalTo(166 * kScale);
        make.width.mas_equalTo(49 * kScale);
        make.height.mas_equalTo(26 * kScale);
    }];
    
    [self.nickLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self);
        make.top.mas_equalTo(self.avatarImageView.mas_bottom).offset(35 * kScale);
        make.height.mas_equalTo(22);
    }];
    
    [self.playOrPauseButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(113 * kScale);
        make.top.mas_equalTo(self.avatarImageView.mas_bottom).offset(73 * kScale);
        make.width.height.mas_equalTo(26);
    }];
    
    [self.progressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.mas_equalTo(self.playOrPauseButton);
    }];
    
    [self.likeImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.playOrPauseButton);
        make.left.mas_equalTo(self.playOrPauseButton.mas_right).offset(18 * kScale);
        make.width.height.mas_equalTo(26);
    }];
    
    [self.likeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.likeImageView);
        make.left.mas_equalTo(self.likeImageView.mas_right).offset(4 * kScale);
    }];
}

#pragma mark - getters and setters
- (UIImageView *)avatarImageView {
    if (!_avatarImageView) {
        _avatarImageView = [[UIImageView alloc] init];
        _avatarImageView.layer.cornerRadius = 40 * kScale;
        _avatarImageView.layer.masksToBounds = YES;
    }
    return _avatarImageView;
}

- (UIImageView *)avatarBottomImageView {
    if (!_avatarBottomImageView) {
        _avatarBottomImageView = [[UIImageView alloc] init];
        _avatarBottomImageView.layer.cornerRadius = 45 * kScale;
        _avatarBottomImageView.layer.masksToBounds = YES;
    }
    return _avatarBottomImageView;
}

- (UIButton *)reportButton {
    if (!_reportButton) {
        _reportButton = [[UIButton alloc] init];
        [_reportButton setImage:[UIImage imageNamed:@"voice_report_bg"] forState:UIControlStateNormal];
        [_reportButton addTarget:self action:@selector(didClickReportButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _reportButton;
}

- (YYLabel *)nickLabel {
    if (!_nickLabel) {
        _nickLabel = [[YYLabel alloc] init];
    }
    return _nickLabel;
}

- (UIButton *)playOrPauseButton {
    if (!_playOrPauseButton) {
        _playOrPauseButton = [[UIButton alloc] init];
        [_playOrPauseButton setImage:[UIImage imageNamed:@"voice_pause_btn"] forState:UIControlStateNormal];
        [_playOrPauseButton setImage:[UIImage imageNamed:@"voice_play_btn"] forState:UIControlStateSelected];
        [_playOrPauseButton addTarget:self action:@selector(didClickPlayOrPauseButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _playOrPauseButton;
}

- (UIImageView *)likeImageView {
    if (!_likeImageView) {
        _likeImageView = [[UIImageView alloc] init];
        _likeImageView.image = [UIImage imageNamed:@"voice_like_count_icon"];
    }
    return _likeImageView;
}

- (UILabel *)likeLabel {
    if (!_likeLabel) {
        _likeLabel = [[UILabel alloc] init];
        _likeLabel.font = [UIFont systemFontOfSize:12];
        _likeLabel.textColor = [XCTheme getTTDeepGrayTextColor];
    }
    return _likeLabel;
}

- (SVGAImageView *)bottleImageView {
    if (!_bottleImageView) {
        _bottleImageView = [[SVGAImageView alloc] init];
        _bottleImageView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _bottleImageView;
}

- (SVGAImageView *)heartImageView {
    if (!_heartImageView) {
        _heartImageView = [[SVGAImageView alloc] init];
        _heartImageView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _heartImageView;
}

- (SVGAParserManager *)parserManager {
    if (!_parserManager) {
        _parserManager = [[SVGAParserManager alloc] init];
    }
    return _parserManager;
}

- (UIView *)containView {
    if (!_containView) {
        _containView = [[UIView alloc] init];
    }
    return _containView;
}

- (TTVoiceProgressView *)progressView {
    if (!_progressView) {
        _progressView = [[TTVoiceProgressView alloc] initWithLineWidth:2.0];
        _progressView.progressLayer.strokeColor = [RGBCOLOR(50, 236, 217) CGColor];
        _progressView.outLayer.strokeColor = [RGBCOLOR(244, 244, 244) CGColor];
    }
    return _progressView;
}
@end
