//
//  TTCheckinReceiptAlertView.m
//  TTPlay
//
//  Created by lvjunhang on 2019/3/27.
//  Copyright © 2019 YiZhuan. All rights reserved.
//

#import "TTCheckinReceiptAlertView.h"

#import "XCMacros.h"
#import "XCTheme.h"
#import "XCCurrentVCStackManager.h"
#import "UIImageView+QiNiu.h"

#import <Masonry/Masonry.h>
#import <UICountingLabel/UICountingLabel.h>

#import <WebKit/WebKit.h>

@interface TTCheckinReceiptAlertView ()

@property (nonatomic, strong) UIImageView *decorateImageView;//装饰背景
@property (nonatomic, strong) UIImageView *giftImageView;//礼物图片
@property (nonatomic, strong) UILabel *giftNameLabel;//萝卜x30
@property (nonatomic, strong) UIButton *shareButton;//分享

@end

@implementation TTCheckinReceiptAlertView

#pragma mark - life cycle

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor.blackColor colorWithAlphaComponent:0.75];
        
        [self initView];
        [self initConstraints];
        
        UITapGestureRecognizer *tapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapViewAciton)];
        [self addGestureRecognizer:tapGR];
    }
    return self;
}

#pragma mark - public method
- (void)configGift:(NSString *)giftName icon:(NSString *)icon {
    [self setupGift:giftName icon:icon];
}

- (void)configCoin:(NSInteger)coin {
    [self setupDrawCoin:coin];
}

#pragma mark - custom protocols
#pragma mark - core protocols
#pragma mark - event response
- (void)shareButtonTapped:(UIButton *)sender {
    !self.shareBlock ?: self.shareBlock();
}

- (void)tapViewAciton {
    [self removeFromSuperview];
}

#pragma mark - private method
- (void)initView {
    [self addSubview:self.decorateImageView];
    [self addSubview:self.giftImageView];
    [self addSubview:self.giftNameLabel];
    [self addSubview:self.shareButton];
    
    self.decorateImageView.hidden = YES;
    self.giftImageView.hidden = YES;
    self.giftNameLabel.hidden = YES;
    self.shareButton.hidden = YES;
}

- (void)initConstraints {
    [self.decorateImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(204);
        make.centerX.mas_equalTo(self);
        make.top.mas_equalTo(144 + (iPhoneXSeries ? 44 : 0));//刘海屏：+44
    }];
    
    [self.giftImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(80);
        make.center.mas_equalTo(self.decorateImageView);
    }];
    
    [self.shareButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.decorateImageView.mas_bottom).offset(46);
        make.centerX.mas_equalTo(self);
    }];
    
    [self.giftNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self).inset(20);
        make.centerY.mas_equalTo(self.decorateImageView.mas_bottom);
    }];
}

- (void)addAnimation {
    self.decorateImageView.hidden = NO;
    self.giftImageView.hidden = NO;
    self.giftNameLabel.hidden = NO;
    self.shareButton.hidden = NO;
    
    CAKeyframeAnimation *keyframe = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
    keyframe.values = @[@0.0, @1.1, @1];
    keyframe.duration = 0.7;
    keyframe.fillMode = kCAFillModeForwards;
    keyframe.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    
    //把动画添加到要作用的Layer上面
    [self.decorateImageView.layer addAnimation:keyframe forKey:nil];
    [self.giftImageView.layer addAnimation:keyframe forKey:nil];
}

- (void)setupGift:(NSString *)giftName icon:(NSString *)icon {
    self.giftNameLabel.text = giftName;
    
    @KWeakify(self)
    [self.giftImageView qn_setImageImageWithUrl:icon placeholderImage:[XCTheme defaultTheme].placeholder_image_square type:ImageTypeHomePageItem success:^(UIImage *image) {
        @KStrongify(self)
        [self addAnimation];
    }];
}

- (void)setupDrawCoin:(NSInteger)coin {
    NSString *reward = [NSString stringWithFormat:@"金币 x %ld", coin];
    self.giftNameLabel.text = reward;
    
    self.giftImageView.image = [UIImage imageNamed:@"checkin_receipt_alert_coin"];
    self.decorateImageView.image = [UIImage imageNamed:@"checkin_receipt_alert_decorate"];
    [self addAnimation];
}

#pragma mark - Getter Setter
- (UIImageView *)decorateImageView {
    if (_decorateImageView == nil) {
        _decorateImageView = [[UIImageView alloc] init];
        _decorateImageView.image = [UIImage imageNamed:@"checkin_receipt_alert_decorate"];
        _decorateImageView.userInteractionEnabled = YES;
    }
    return _decorateImageView;
}

- (UIImageView *)giftImageView {
    if (_giftImageView == nil) {
        _giftImageView = [[UIImageView alloc] init];
        _giftImageView.contentMode = UIViewContentModeScaleAspectFit;
//        _giftImageView.image = [UIImage imageNamed:@"checkin_receipt_alert_zijue"];
    }
    return _giftImageView;
}

- (UILabel *)giftNameLabel {
    if (_giftNameLabel == nil) {
        _giftNameLabel = [[UILabel alloc] init];
        _giftNameLabel.text = @"获得 XX x 0";
        _giftNameLabel.textColor = UIColor.whiteColor;
        _giftNameLabel.font = [UIFont systemFontOfSize:21];
        _giftNameLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _giftNameLabel;
}

- (UIButton *)shareButton {
    if (_shareButton == nil) {
        _shareButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_shareButton setBackgroundImage:[UIImage imageNamed:@"checkin_receipt_alert_btn"] forState:UIControlStateNormal];
        [_shareButton setTitle:@"分享好友" forState:UIControlStateNormal];
        _shareButton.titleLabel.font = [UIFont systemFontOfSize:14];
        [_shareButton addTarget:self action:@selector(shareButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _shareButton;
}

@end
