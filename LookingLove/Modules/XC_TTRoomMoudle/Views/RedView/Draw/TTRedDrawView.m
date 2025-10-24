//
//  TTRedDrawView.m
//  XC_TTRoomMoudle
//
//  Created by lvjunhang on 2020/5/14.
//  Copyright © 2020 WUJIE INTERACTIVE. All rights reserved.
//

#import "TTRedDrawView.h"
#import "TTRedEntranceView.h"

#import "RoomRedListItem.h"
#import "RoomRedDetail.h"

#import "UIButton+EnlargeTouchArea.h"
#import "UIImageView+QiNiu.h"
#import "XCTheme.h"
#import "BaseAttrbutedStringHandler.h"

#import <Masonry/Masonry.h>
#import <YYText/YYText.h>
#import "SVGAImageView.h"
#import "SVGAParserManager.h"

static NSString *const kBgViewRepeatAnimationKey = @"TTRedDrawViewBgViewRepeatAnimationKey";//背景上下飘动动画

@interface TTRedDrawView ()<CAAnimationDelegate>

@property (nonatomic, strong) UIImageView *topImageView;
@property (nonatomic, strong) UIImageView *bottomImageView;

@property (nonatomic, strong) UILabel *nickLabel;
@property (nonatomic, strong) UIImageView *avatarImageView;
@property (nonatomic, strong) UIView *avatarBgView;//设置头像环圈

@property (nonatomic, strong) UILabel *wordLabel;//“大家快来抢啊~”

@property (nonatomic, strong) UIView *conditionBgView;//条件
@property (nonatomic, strong) YYLabel *conditionLabel;

@property (nonatomic, strong) UILabel *countdownLabel;//倒计时
@property (nonatomic, strong) UILabel *timeLabel;

@property (nonatomic, strong) UIButton *closeButton;
@property (nonatomic, strong) UIButton *sendButton;

@property (nonatomic, strong) SVGAImageView *redbagSVGAImageView;
@property (nonatomic, strong) SVGAParserManager *redbagParserManager;

@end

@implementation TTRedDrawView

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (CGRectEqualToRect(frame, CGRectZero)) {
        frame = UIScreen.mainScreen.bounds;
    }
    
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = UIColorRGBAlpha(0x0C0C1F, 0.65);
        [self setupUI];
        [self layoutUI];
        [self loadRedbagSvgaAnimation:@"redbag_draw"];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didReceiveDrawCountdownNoti:) name:TTRedEntranceViewDrawCountdownNotify object:nil];
    }
    return self;
}

- (void)setupUI {
    [self addSubview:self.bgImageView];
    [self addSubview:self.closeButton];
    [self.bgImageView addSubview:self.drawBgView];
    
    [self.drawBgView addSubview:self.bottomImageView];
    [self.drawBgView addSubview:self.topImageView];
    [self.drawBgView addSubview:self.avatarBgView];
    [self.drawBgView addSubview:self.avatarImageView];
    [self.drawBgView addSubview:self.wordLabel];
    [self.drawBgView addSubview:self.nickLabel];
    [self.drawBgView addSubview:self.conditionBgView];
    [self.conditionBgView addSubview:self.conditionLabel];
    [self.drawBgView addSubview:self.countdownLabel];
    [self.drawBgView addSubview:self.timeLabel];
    [self.drawBgView addSubview:self.redbagSVGAImageView];
}

- (void)layoutUI {
    [self.bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.centerY.mas_equalTo(0);
        make.width.mas_equalTo(295);
        make.height.mas_equalTo(385);
    }];
    
    [self.closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.bgImageView.mas_bottom).offset(25);
        make.centerX.mas_equalTo(0);
        make.width.height.mas_equalTo(30);
    }];
    
    [self.drawBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];
    
    [self.topImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.right.mas_equalTo(0);
    }];
    
    [self.bottomImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.mas_equalTo(0);
    }];
    
    [self.avatarImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(27);
        make.centerX.mas_equalTo(0);
        make.width.height.mas_equalTo(47);
    }];
    
    [self.avatarBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(self.avatarImageView);
        make.width.height.mas_equalTo(52);
    }];
    
    [self.nickLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.top.mas_equalTo(self.avatarImageView.mas_bottom).offset(9);
    }];
    
    [self.wordLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.nickLabel.mas_bottom).offset(23);
        make.left.right.mas_equalTo(self.bgImageView).inset(6);
    }];
    
    [self.conditionBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.wordLabel.mas_bottom).offset(8);
        make.height.mas_equalTo(24);
        make.centerX.mas_equalTo(0);
    }];
    
    [self.conditionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(0);
        make.left.mas_equalTo(9);
        make.right.mas_equalTo(-2);
        make.height.mas_equalTo(20);
    }];
    
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.redbagSVGAImageView.mas_top).offset(-14);
        make.centerX.mas_equalTo(0);
    }];
    
    [self.countdownLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.timeLabel.mas_top).offset(0);
        make.centerX.mas_equalTo(0);
    }];
    
    [self.redbagSVGAImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.bottomImageView).offset(-10);
        make.centerX.mas_equalTo(0);
        make.width.height.mas_equalTo(120);
    }];
}

#pragma mark - NSNotification
- (void)didReceiveDrawCountdownNoti:(NSNotification *)noti {
    int seconds = [noti.object intValue];
    if (seconds < 0) {
        seconds = 0;
    }
    
    NSString *s = @"s";
    NSString *content = [NSString stringWithFormat:@"%d%@", seconds, s];
    NSRange sRange = [content rangeOfString:s];
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:content];
    [str addAttribute:NSForegroundColorAttributeName value:UIColor.whiteColor range:NSMakeRange(0, content.length)];
    [str addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:30] range:NSMakeRange(0, content.length)];
    [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:20] range:sRange];
    
    self.timeLabel.attributedText = str;
}

#pragma mark - Action
- (void)didClickCloseButton {
    [self endAnimation];
    [self action:TTRedDrawViewActionClose];
}

- (void)didClickDrawButton {
    [self action:TTRedDrawViewActionDraw];
}

- (void)action:(TTRedDrawViewAction)action {
    if ([self.delegate respondsToSelector:@selector(redDrawView:didAction:)]) {
        [self.delegate redDrawView:self didAction:action];
    }
}

/// 关注
- (void)didClickFocusButton:(UIButton *)sender {
    [self action:TTRedDrawViewActionFocus];
}

#pragma mark - Private
- (NSMutableAttributedString *)redInfoAttributedString:(RoomRedDetail *)red {
    if (!red) {
        return nil;
    }
    
    if (red.requirement == 0 || red.requirementDesc.length == 0) {
        return nil;
    }
    
    NSString *what = [NSString stringWithFormat:@"抢红包条件：%@", red.requirementDesc];
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:what];
    str.yy_font = [UIFont systemFontOfSize:12];
    str.yy_color = UIColor.whiteColor;
    
    if (!red.reachRequirement) {
        [str appendAttributedString:[BaseAttrbutedStringHandler placeholderAttributedString:4]];
    }
    
    [str appendAttributedString:[self focusAttributedString:red.reachRequirement]];
    
    if (red.reachRequirement) {
        [str appendAttributedString:[BaseAttrbutedStringHandler placeholderAttributedString:6]];
    }
    
    return str;
}

- (NSAttributedString *)focusAttributedString:(BOOL)reachRequirement {
    if (reachRequirement) {
        return [[NSAttributedString alloc] initWithString:@"（已满足）" attributes:@{NSForegroundColorAttributeName:UIColorFromRGB(0xFFD961)}];
    }
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, 45, 20);
    [button setTitle:@"关注" forState:UIControlStateNormal];
    [button setTitleColor:UIColorFromRGB(0xFF3E3D) forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont boldSystemFontOfSize:11];
    button.backgroundColor = UIColorFromRGB(0xFFD961);
    button.layer.cornerRadius = 10;
    button.layer.masksToBounds = YES;
    [button addTarget:self action:@selector(didClickFocusButton:) forControlEvents:UIControlEventTouchUpInside];
    
    NSMutableAttributedString *str = [NSMutableAttributedString yy_attachmentStringWithContent:button contentMode:UIViewContentModeScaleAspectFit attachmentSize:button.frame.size alignToFont:[UIFont systemFontOfSize:12.0] alignment:YYTextVerticalAlignmentCenter];
    return str.copy;
}

- (void)loadRedbagSvgaAnimation:(NSString *)matchStr {
    
    NSString *matchString = [[NSBundle mainBundle] pathForResource:matchStr ofType:@"svga"];
    if (!matchString) {
        return;
    }
    NSURL *matchUrl = [NSURL fileURLWithPath:matchString];
    
    @weakify(self);
    [self.redbagParserManager loadSvgaWithURL:matchUrl completionBlock:^(SVGAVideoEntity * _Nullable videoItem) {
        @strongify(self)
        self.redbagSVGAImageView.loops = INT_MAX;
        self.redbagSVGAImageView.clearsAfterStop = NO;
        self.redbagSVGAImageView.videoItem = videoItem;
        [self.redbagSVGAImageView startAnimation];
    } failureBlock:^(NSError * _Nullable error) {
        
    }];
}

#pragma mark - Public
/// 显示动画
- (void)showAnimation {
    self.alpha = 0;
    self.bgImageView.transform = CGAffineTransformMakeScale(0.96, 0.96);
    
    @weakify(self)
    [UIView animateKeyframesWithDuration:1.1 delay:0.0
    options:UIViewKeyframeAnimationOptionBeginFromCurrentState animations:^{
        @strongify(self)
        //启动缩放关键帧
        [UIView addKeyframeWithRelativeStartTime:0 relativeDuration:0.2 animations:^{
            self.alpha = 1;
        }];
        [UIView addKeyframeWithRelativeStartTime:0 relativeDuration:0.4 animations:^{
            @strongify(self)
            self.bgImageView.transform = CGAffineTransformMakeScale(1.02, 1.02);
        }];
        [UIView addKeyframeWithRelativeStartTime:0.4 relativeDuration:0.4 animations:^{
            @strongify(self)
            self.bgImageView.transform = CGAffineTransformMakeScale(0.98, 0.98);
        }];
        [UIView addKeyframeWithRelativeStartTime:0.8 relativeDuration:0.3 animations:^{
            @strongify(self)
            self.bgImageView.transform = CGAffineTransformMakeScale(1, 1);
        }];
    } completion:^(BOOL finished) {
        @strongify(self)
        if (CGPointEqualToPoint(self.bgImageView.frame.origin, CGPointZero)) {
            [self layoutIfNeeded];
        }
        
        //循环上下浮动
        CABasicAnimation *posAni = [CABasicAnimation animationWithKeyPath:@"position"];
        posAni.fromValue = [NSValue valueWithCGPoint:self.bgImageView.center];
        posAni.toValue = [NSValue valueWithCGPoint:CGPointMake(self.bgImageView.center.x, self.bgImageView.center.y+10)];
        posAni.repeatCount = CGFLOAT_MAX;
        posAni.autoreverses = YES;
        posAni.duration = 2;
        [self.bgImageView.layer addAnimation:posAni forKey:kBgViewRepeatAnimationKey];
    }];
}

/// 结束动画
- (void)endAnimation {
    
    //设置结束状态，准备下一次展现初始化状态
    self.alpha = 0;
    self.bgImageView.transform = CGAffineTransformMakeScale(0.96, 0.96);
    
    //因为 removedOnCompletion = NO，需手动移除，否者view不能销毁
    [self.bgImageView.layer removeAnimationForKey:kBgViewRepeatAnimationKey];
}

/// 显示抢红包结果动画
- (void)showDrawResultAnimationWithView:(TTRedDrawResultView *)drawResultView {
    
    CGFloat duration = 0.4;
    
    CABasicAnimation *posAni = [CABasicAnimation animationWithKeyPath:@"position"];
    posAni.delegate = self;
    posAni.fromValue = [NSValue valueWithCGPoint:CGPointMake(295/2.0, 385/2.0)];
    posAni.toValue = [NSValue valueWithCGPoint:CGPointMake(295/2.0, -385/2.0*5)];
    posAni.duration = duration*2;
    posAni.beginTime = CACurrentMediaTime() + duration/2;
    [self.drawBgView.layer addAnimation:posAni forKey:nil];

    CABasicAnimation *posAni2 = [CABasicAnimation animationWithKeyPath:@"position"];
    posAni2.fromValue = [NSValue valueWithCGPoint:CGPointMake(295/2.0, 385/2.0*5)];
    posAni2.toValue = [NSValue valueWithCGPoint:CGPointMake(295/2.0, 385/2.0)];
    posAni2.duration = duration*2;
    [drawResultView.layer addAnimation:posAni2 forKey:nil];
    
    CABasicAnimation *scaleSmall = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    scaleSmall.fromValue = [NSNumber numberWithFloat:1];
    scaleSmall.toValue = [NSNumber numberWithFloat:0.85];
    scaleSmall.duration = duration/2;
    
    CABasicAnimation *scaleNormal = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    scaleNormal.fromValue = [NSNumber numberWithFloat:0.85];
    scaleNormal.toValue = [NSNumber numberWithFloat:1];
    scaleNormal.duration = duration/2;
    scaleNormal.beginTime = CACurrentMediaTime() + duration/2;
    
    [self.bgImageView.layer addAnimation:scaleSmall forKey:nil];
    [self.bgImageView.layer addAnimation:scaleNormal forKey:nil];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(duration*2+0.4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [drawResultView countAnimation];
    });
}

#pragma mark - CAAnimationDelegate
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
}

#pragma mark - Lazy Load
- (void)setModel:(RoomRedDetail *)model {
    _model = model;
    
    self.conditionBgView.hidden = model.requirement == 0;
    
    if (!model) {
        return;
    }

    NSMutableString *nick = [[NSMutableString alloc] init];
    if (model.nick.length > 5) {
        [nick appendString:[model.nick substringToIndex:5]];
        [nick appendString:@"..."];
    } else {
        [nick appendString:model.nick];
    }
    
    [nick appendString:@"的红包"];
    
    self.nickLabel.text = nick;
    self.wordLabel.text = model.notifyText;
    self.conditionLabel.attributedText = [self redInfoAttributedString:model];
    
    [self.wordLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        CGFloat top = 23 + (model.requirement==0 ? 10 : 0);
        make.top.mas_equalTo(self.nickLabel.mas_bottom).offset(top);
    }];
    
    [self.avatarImageView qn_setImageImageWithUrl:model.avatar placeholderImage:[XCTheme defaultTheme].default_avatar type:ImageTypeUserIcon];
}

- (UIImageView *)bgImageView {
    if (_bgImageView == nil) {
        _bgImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"room_red_list_bg"]];
        _bgImageView.userInteractionEnabled = YES;
        _bgImageView.clipsToBounds = YES;
        _bgImageView.layer.cornerRadius = 16;
        _bgImageView.layer.masksToBounds = YES;
    }
    return _bgImageView;
}

- (UIView *)drawBgView {
    if (_drawBgView == nil) {
        _drawBgView = [[UIView alloc] init];
    }
    return _drawBgView;
}

- (UIImageView *)topImageView {
    if (_topImageView == nil) {
        _topImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"room_red_list_bg_top"]];
    }
    return _topImageView;
}

- (UIImageView *)bottomImageView {
    if (_bottomImageView == nil) {
        _bottomImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"room_red_list_bg_bottom"]];
    }
    return _bottomImageView;
}

- (UIImageView *)avatarImageView {
    if (_avatarImageView == nil) {
        _avatarImageView = [[UIImageView alloc] init];
        _avatarImageView.layer.cornerRadius = 47/2.0;
        _avatarImageView.layer.masksToBounds = YES;
    }
    return _avatarImageView;
}

- (UIView *)avatarBgView {
    if (_avatarBgView == nil) {
        _avatarBgView = [[UIView alloc] init];
        _avatarBgView.backgroundColor = UIColor.clearColor;
        _avatarBgView.layer.borderColor = UIColor.whiteColor.CGColor;
        _avatarBgView.layer.borderWidth = 0.5;
        _avatarBgView.layer.cornerRadius = 52/2.0;
        _avatarBgView.layer.masksToBounds = YES;
    }
    return _avatarBgView;
}

- (UILabel *)nickLabel {
    if (_nickLabel == nil) {
        _nickLabel = [[UILabel alloc] init];
        _nickLabel.text = @"...的红包";
        _nickLabel.font = [UIFont systemFontOfSize:13];
        _nickLabel.textColor = [UIColor.whiteColor colorWithAlphaComponent:0.5];
    }
    return _nickLabel;
}

- (UILabel *)wordLabel {
    if (_wordLabel == nil) {
        _wordLabel = [[UILabel alloc] init];
        _wordLabel.text = @"“大家快来抢啊~”";
        _wordLabel.font = [UIFont boldSystemFontOfSize:15];
        _wordLabel.textColor = [UIColor.whiteColor colorWithAlphaComponent:1];
        _wordLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _wordLabel;
}

- (UIView *)conditionBgView {
    if (_conditionBgView == nil) {
        _conditionBgView = [[UIView alloc] init];
        _conditionBgView.backgroundColor = [UIColor.blackColor colorWithAlphaComponent:0.1];
        _conditionBgView.layer.cornerRadius = 12;
        _conditionBgView.layer.masksToBounds = YES;
    }
    return _conditionBgView;
}

- (YYLabel *)conditionLabel {
    if (_conditionLabel == nil) {
        _conditionLabel = [[YYLabel alloc] init];
    }
    return _conditionLabel;
}

- (UILabel *)countdownLabel {
    if (_countdownLabel == nil) {
        _countdownLabel = [[UILabel alloc] init];
        _countdownLabel.font = [UIFont systemFontOfSize:30];
        _countdownLabel.textColor = [UIColor.whiteColor colorWithAlphaComponent:1];
    }
    return _countdownLabel;
}

- (UILabel *)timeLabel {
    if (_timeLabel == nil) {
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.text = @"剩余抢夺时间";
        _timeLabel.font = [UIFont systemFontOfSize:13];
        _timeLabel.textColor = [UIColor.whiteColor colorWithAlphaComponent:0.5];
    }
    return _timeLabel;
}

- (UIButton *)closeButton {
    if (_closeButton == nil) {
        _closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_closeButton setImage:[UIImage imageNamed:@"room_red_list_close"] forState:UIControlStateNormal];
        [_closeButton addTarget:self action:@selector(didClickCloseButton) forControlEvents:UIControlEventTouchUpInside];
        
        [_closeButton enlargeTouchArea:UIEdgeInsetsMake(10, 10, 10, 10)];
    }
    return _closeButton;
}

- (UIButton *)sendButton {
    if (_sendButton == nil) {
        _sendButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_sendButton setImage:[UIImage imageNamed:@"room_red_list_draw"] forState:UIControlStateNormal];
        [_sendButton addTarget:self action:@selector(didClickDrawButton) forControlEvents:UIControlEventTouchUpInside];
    }
    return _sendButton;
}

- (SVGAParserManager *)redbagParserManager {
    if (_redbagParserManager == nil) {
        _redbagParserManager = [[SVGAParserManager alloc] init];
    }
    return _redbagParserManager;
}

- (SVGAImageView *)redbagSVGAImageView {
    if (_redbagSVGAImageView == nil) {
        _redbagSVGAImageView = [[SVGAImageView alloc] init];
        _redbagSVGAImageView.autoPlay = YES;
        _redbagSVGAImageView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didClickDrawButton)];
        [_redbagSVGAImageView addGestureRecognizer:tap];
    }
    return _redbagSVGAImageView;
}

@end
