//
//  TTVoiceMyCell.m
//  XC_TTGameMoudle
//
//  Created by Macx on 2019/6/3.
//  Copyright © 2019 YiZhuan. All rights reserved.
//

#import "TTVoiceMyCell.h"

#import "NSString+Voice.h"

#import "XCMacros.h"
#import "XCTheme.h"
#import "SVGA.h"
#import "SVGAParserManager.h"
#import "VoiceBottleModel.h"
#import "XCPlayerTool.h"

#import <Masonry/Masonry.h>

@interface TTVoiceMyCell ()<XCPlayerToolDelegate>
/** 音频背景 */
@property (nonatomic, strong) UIImageView *bgImageView;
/** 播放or暂停 */
@property (nonatomic, strong) UIButton *playOrPauseButton;
/** 动画 */
@property (nonatomic, strong) SVGAImageView *svgaImageView;
/** 音频长度 */
@property (nonatomic, strong) UILabel *voiceLenthLabel;
/** 重新录制按钮 */
@property (nonatomic, strong) UIButton *reorderButton;
/** 听过数icon */
@property (nonatomic, strong) UIImageView *heardCountImageView;
/** 听过数label */
@property (nonatomic, strong) UILabel *heardCountLabel;
/** 喜欢数icon */
@property (nonatomic, strong) UIImageView *likeCountImageView;
/** 喜欢数label */
@property (nonatomic, strong) UILabel *likeCountLabel;

/** SVGAParserManager */
@property (nonatomic, strong) SVGAParserManager *parserManager;
@end

@implementation TTVoiceMyCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initView];
        [self initConstraint];
    }
    return self;
}

#pragma mark - public method
- (void)setModel:(VoiceBottleModel *)model {
    _model = model;
    
    if (model.status == TTVoiceStatusAudit) {
        self.likeCountLabel.hidden = YES;
        self.likeCountImageView.hidden = YES;
        self.heardCountLabel.hidden = NO;
        self.heardCountImageView.hidden = NO;
        
        self.heardCountImageView.image = [UIImage imageNamed:@"voice_my_checking"];
        self.heardCountLabel.text = @"努力审核中...";
        self.heardCountLabel.textColor = RGBCOLOR(255, 96, 110);
        
        self.voiceLenthLabel.text = [NSString stringWithFormat:@"%lds", model.voiceLength];
        
        [self.bgImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(15);
            make.top.mas_equalTo(21);
            make.right.mas_equalTo(self.reorderButton.mas_left).offset(-20);
            make.height.mas_equalTo(40);
        }];
    } else if (model.status == TTVoiceStatusPass) {
        self.likeCountLabel.hidden = NO;
        self.likeCountImageView.hidden = NO;
        self.heardCountLabel.hidden = NO;
        self.heardCountImageView.hidden = NO;
        
        self.heardCountImageView.image = [UIImage imageNamed:@"voice_my_heard"];
        self.heardCountLabel.text = [NSString stringWithFormat:@"%@人听过", [NSString countNumberFormatStr:model.playCount]];
        self.heardCountLabel.textColor = [XCTheme getTTDeepGrayTextColor];
        
        self.likeCountLabel.text = [NSString stringWithFormat:@"%@人喜欢", [NSString countNumberFormatStr:model.likeCount]];
        
        self.voiceLenthLabel.text = [NSString stringWithFormat:@"%lds", model.voiceLength];
        
        [self.bgImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(15);
            make.top.mas_equalTo(21);
            make.right.mas_equalTo(self.reorderButton.mas_left).offset(-20);
            make.height.mas_equalTo(40);
        }];
    } else if (model.status == TTVoiceStatusNoSubmit) {
        self.likeCountLabel.hidden = YES;
        self.likeCountImageView.hidden = YES;
        self.heardCountLabel.hidden = YES;
        self.heardCountImageView.hidden = YES;
        
        self.voiceLenthLabel.text = [NSString stringWithFormat:@"%lds", model.voiceLength];
        
        [self.bgImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(15);
            make.centerY.mas_equalTo(self);
            make.right.mas_equalTo(self.reorderButton.mas_left).offset(-20);
            make.height.mas_equalTo(40);
        }];
    }
}

- (void)resetVoiceMyCell {
    [[XCPlayerTool sharedPlayerTool] stop];
    self.playOrPauseButton.selected = YES;
    [self.svgaImageView pauseAnimation];
}

#pragma mark - XCPlayerToolDelegate
/** 播放完成 */
- (void)playerToolDidFinish:(XCPlayerTool *)playerTool {
    [self resetVoiceMyCell];
    [self.svgaImageView pauseAnimation];
}

#pragma mark - event
- (void)didClickReorderButton:(UIButton *)button {
    if (self.reorderButtonDidClickAction) {
        self.reorderButtonDidClickAction(self.model);
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

#pragma mark - private
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

- (void)initView {
    self.backgroundColor = [UIColor whiteColor];
    self.layer.cornerRadius = 14;
    [self addSubview:self.bgImageView];
    [self addSubview:self.reorderButton];
    [self addSubview:self.heardCountImageView];
    [self addSubview:self.heardCountLabel];
    [self addSubview:self.likeCountImageView];
    [self addSubview:self.likeCountLabel];
    
    [self.bgImageView addSubview:self.playOrPauseButton];
    [self.bgImageView addSubview:self.svgaImageView];
    [self.bgImageView addSubview:self.voiceLenthLabel];
    
    // voiceMatching_vocal_print
    [self loadSvgaAnimation:@"voiceMatching_vocal_print"];
}

- (void)initConstraint {
    CGFloat scale = KScreenWidth/375.0;
    
    [self.bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.top.mas_equalTo(21);
        make.right.mas_equalTo(self.reorderButton.mas_left).offset(-20);
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
        make.right.mas_equalTo(-15);
        make.centerY.mas_equalTo(self.bgImageView);
        make.width.mas_equalTo(84 * scale);
        make.height.mas_equalTo(40);
    }];
    
    [self.heardCountImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(30);
        make.top.mas_equalTo(self.bgImageView.mas_bottom).offset(9);
        make.width.mas_equalTo(13);
        make.height.mas_equalTo(13);
    }];
    
    [self.heardCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.heardCountImageView.mas_right).offset(5);
        make.centerY.mas_equalTo(self.heardCountImageView);
    }];
    
    [self.likeCountImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.heardCountLabel.mas_right).offset(16);
        make.centerY.width.height.mas_equalTo(self.heardCountImageView);
    }];
    
    [self.likeCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.likeCountImageView.mas_right).offset(5);
        make.centerY.mas_equalTo(self.likeCountImageView);
    }];
}

#pragma mark - getter
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
        [_reorderButton setTitleColor:[XCTheme getTTMainColor] forState:UIControlStateNormal];
        _reorderButton.titleLabel.font = [UIFont systemFontOfSize:13];
        _reorderButton.backgroundColor = [UIColor whiteColor];
        _reorderButton.layer.cornerRadius = 20;
        _reorderButton.layer.masksToBounds = YES;
        _reorderButton.layer.borderColor = [[XCTheme getTTMainColor] CGColor];
        _reorderButton.layer.borderWidth = 1;
        [_reorderButton addTarget:self action:@selector(didClickReorderButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _reorderButton;
}

- (UIImageView *)heardCountImageView {
    if (!_heardCountImageView) {
        _heardCountImageView = [[UIImageView alloc] init];
        _heardCountImageView.image = [UIImage imageNamed:@"voice_my_heard"];
    }
    return _heardCountImageView;
}

- (UILabel *)heardCountLabel {
    if (!_heardCountLabel) {
        _heardCountLabel = [[UILabel alloc] init];
        _heardCountLabel.textColor = [XCTheme getTTDeepGrayTextColor];
        _heardCountLabel.font = [UIFont systemFontOfSize:12];
    }
    return _heardCountLabel;
}

- (UIImageView *)likeCountImageView {
    if (!_likeCountImageView) {
        _likeCountImageView = [[UIImageView alloc] init];
        _likeCountImageView.image = [UIImage imageNamed:@"voice_my_like"];
    }
    return _likeCountImageView;
}

- (UILabel *)likeCountLabel {
    if (!_likeCountLabel) {
        _likeCountLabel = [[UILabel alloc] init];
        _likeCountLabel.textColor = [XCTheme getTTDeepGrayTextColor];
        _likeCountLabel.font = [UIFont systemFontOfSize:12];
    }
    return _likeCountLabel;
}

- (SVGAParserManager *)parserManager {
    if (!_parserManager) {
        _parserManager = [[SVGAParserManager alloc] init];
    }
    return _parserManager;
}
@end
