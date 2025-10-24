//
//  TTVoiceLoadingView.m
//  XC_TTGameMoudle
//
//  Created by Macx on 2019/6/11.
//  Copyright © 2019 YiZhuan. All rights reserved.
//

#import "TTVoiceLoadingView.h"

#import "XCMacros.h"
#import "XCTheme.h"
#import "SVGA.h"
#import "SVGAParserManager.h"
#import <Masonry/Masonry.h>

#define kScale (KScreenWidth / 375)

@interface TTVoiceLoadingView ()
/** 动画 */
@property (nonatomic, strong) SVGAImageView *svgaImageView;
/** icon */
@property (nonatomic, strong) UIImageView *iconImageView;
/** tip */
@property (nonatomic, strong) UILabel *tipLabel;
/** 刷新按钮 */
@property (nonatomic, strong) UIButton *refreshButton;

/** SVGAParserManager */
@property (nonatomic, strong) SVGAParserManager *parserManager;
@end

@implementation TTVoiceLoadingView

#pragma mark - life cycle

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initView];
        [self initConstrations];
    }
    return self;
}

#pragma mark - public methods
- (void)setStatus:(TTVoiceLoadingViewStatus)status {
    _status = status;
    
    if (status == TTVoiceLoadingViewStatusLoading) {
        self.refreshButton.hidden = YES;
        self.tipLabel.text = @"努力捕获声音瓶子...";
        self.svgaImageView.hidden = NO;
        self.iconImageView.hidden = YES;
    } else if (status == TTVoiceLoadingViewStatusNoNet) {
        self.refreshButton.hidden = NO;
        self.svgaImageView.hidden = YES;
        self.iconImageView.hidden = NO;
        self.iconImageView.image = [UIImage imageNamed:@"voice_no_network"];
        self.tipLabel.text = @"网络出问题了";
    } else if (status == TTVoiceLoadingViewStatusNoMore) {
        self.refreshButton.hidden = NO;
        self.svgaImageView.hidden = YES;
        self.iconImageView.hidden = NO;
        self.iconImageView.image = [UIImage imageNamed:@"voice_no_data"];
        self.tipLabel.text = @"暂时还没有更多声音瓶子";
    }
}

#pragma mark - [系统控件的Protocol]   //注意要把名字改掉，这个MARK只做功能划分，不是一个真正的MARK，每个不一样的Protocol，需要一个新的MARK”

#pragma mark - [自定义控件的Protocol] //注意要把名字改掉，这个MARK只做功能划分，不是一个真正的MARK，每个不一样的Protocol，需要一个新的MARK”

#pragma mark - [core相关的Protocol]  //注意要把名字改掉，这个MARK只做功能划分，不是一个真正的MARK，每个不一样的Protocol，需要一个新的MARK”

#pragma mark - event response
- (void)didClickRefreshButton:(UIButton *)button {
    if (self.delegate && [self.delegate respondsToSelector:@selector(voiceLoadingView:didClickRrefreshButton:)]) {
        [self.delegate voiceLoadingView:self didClickRrefreshButton:button];
    }
}

#pragma mark - private method
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
    } failureBlock:^(NSError * _Nullable error) {
        
    }];
}

- (void)initView {
    [self addSubview:self.svgaImageView];
    [self addSubview:self.iconImageView];
    [self addSubview:self.tipLabel];
    [self addSubview:self.refreshButton];
    
    [self loadSvgaAnimation:@"voiceMatching_loading"];
}

- (void)initConstrations {
    [self.svgaImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self);
        make.top.mas_equalTo(300 * kScale + kSafeAreaTopHeight);
        make.width.mas_equalTo(50);
        make.height.mas_equalTo(28);
    }];
    
    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self);
        make.top.mas_equalTo(278 * kScale + kSafeAreaTopHeight);
        make.width.mas_equalTo(63);
        make.height.mas_equalTo(50);
    }];
    
    [self.tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self);
        make.top.mas_equalTo(self.svgaImageView.mas_bottom).offset(26 * kScale);
    }];
    
    [self.refreshButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self);
        make.top.mas_equalTo(self.svgaImageView.mas_bottom).offset(100 * kScale);
        make.width.mas_equalTo(160);
        make.height.mas_equalTo(44);
    }];
}

#pragma mark - getters and setters

- (SVGAImageView *)svgaImageView {
    if (!_svgaImageView) {
        _svgaImageView = [[SVGAImageView alloc]init];
        _svgaImageView.contentMode = UIViewContentModeScaleAspectFill;
        _svgaImageView.userInteractionEnabled = NO;
    }
    return _svgaImageView;
}

- (UILabel *)tipLabel {
    if (!_tipLabel) {
        _tipLabel = [[UILabel alloc] init];
        _tipLabel.textColor = [UIColor whiteColor];
        _tipLabel.font = [UIFont systemFontOfSize:15];
    }
    return _tipLabel;
}

- (UIButton *)refreshButton {
    if (!_refreshButton) {
        _refreshButton = [[UIButton alloc] init];
        _refreshButton.backgroundColor = [UIColor whiteColor];
        [_refreshButton setTitle:@"刷新一下" forState:UIControlStateNormal];
        [_refreshButton setTitleColor:RGBCOLOR(50, 236, 217) forState:UIControlStateNormal];
        _refreshButton.layer.cornerRadius = 22;
        _refreshButton.layer.masksToBounds = YES;
        _refreshButton.titleLabel.font = [UIFont systemFontOfSize:15];
        [_refreshButton addTarget:self action:@selector(didClickRefreshButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _refreshButton;
}

- (SVGAParserManager *)parserManager {
    if (!_parserManager) {
        _parserManager = [[SVGAParserManager alloc] init];
    }
    return _parserManager;
}

- (UIImageView *)iconImageView {
    if (!_iconImageView) {
        _iconImageView = [[UIImageView alloc] init];
    }
    return _iconImageView;
}

@end
