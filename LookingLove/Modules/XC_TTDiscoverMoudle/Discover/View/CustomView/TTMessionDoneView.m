//
// Created by lee on 2019-03-21.
// Copyright (c) 2019 YiZhuan. All rights reserved.
//

#import "TTMessionDoneView.h"
#import <Masonry/Masonry.h>
#import "XCTheme.h"
#import "XCMacros.h"
#import "UIView+ZJFrame.h"
#import "UIView+NTES.h"
#import "UIImageView+QiNiu.h"

// model
#import "MissionInfo.h"
@interface TTMessionDoneView()

@property (nonatomic, strong) UIImageView *imageView;           // 领取成功显示的图片
@property (nonatomic, strong) UILabel *carrotCountLabel;         // 领取的萝卜数量
@property (nonatomic, strong) UILabel *textLabel;               // 文案显示
@property (nonatomic, strong) UILabel *prizeName;               // 奖励名称
@property (nonatomic, strong) UIImageView *effectImageView;     // 带动效的图
@end

@implementation TTMessionDoneView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initViews];
        [self initConstraints];
        self.userInteractionEnabled = NO;
    }
    return self;
}

#pragma mark -
#pragma mark lifeCycle
- (void)initViews {
    [self addSubview:self.effectImageView];
    [self addSubview:self.imageView];
    [self addSubview:self.carrotCountLabel];
    [self addSubview:self.textLabel];
    [self addSubview:self.prizeName];
}

- (void)initConstraints {
    [self.effectImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(0);
        make.height.width.mas_equalTo(204);
    }];
    
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(self.effectImageView);
        make.height.width.mas_equalTo(80);
    }];
    
    [self.prizeName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.mas_centerX).offset(-5);
        make.centerY.mas_equalTo(self.effectImageView.mas_bottom);
    }];
    
    [self.carrotCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_centerX).offset(15);
        make.centerY.mas_equalTo(self.prizeName);
    }];
    
    [self.textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.prizeName.mas_bottom).offset(22);
        make.centerX.mas_equalTo(self);
    }];
}

#pragma mark -
#pragma mark clients

#pragma mark -
#pragma mark private methods
- (void)clickSelfAction {
    !_dismissHandler ?: _dismissHandler();
}

- (void)startAnimation {
    
    self.effectImageView.hidden = NO;
    
    CAKeyframeAnimation *keyAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
    keyAnimation.values = @[@0.0, @1.1, @1.0];
    keyAnimation.duration = 0.5;
    keyAnimation.fillMode = kCAFillModeForwards;
    keyAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    [self.effectImageView.layer addAnimation:keyAnimation forKey:keyAnimation.keyPath];
}

- (void)setInfo:(MissionInfo *)info {
    _info = info;
    self.textLabel.text = info.tips;
    self.carrotCountLabel.text = [NSString stringWithFormat:@"x %@", info.prizeNum];
    self.prizeName.text = info.prizeName;
    [self.imageView qn_setImageImageWithUrl:info.prizePic placeholderImage:nil type:ImageTypeUserLibary success:^(UIImage *image) {
    }];
}

#pragma mark -
#pragma mark button click events

#pragma mark -
#pragma mark getter & setter
- (UILabel *)textLabel
{
    if (!_textLabel) {
        _textLabel = [[UILabel alloc] init];
        _textLabel.textColor = [UIColor whiteColor];
        _textLabel.font = [UIFont systemFontOfSize:15.f];
        _textLabel.adjustsFontSizeToFitWidth = YES;
    }
    return _textLabel;
}

- (UILabel *)carrotCountLabel {
    if (!_carrotCountLabel) {
        _carrotCountLabel = [[UILabel alloc] init];
        _carrotCountLabel.font = [UIFont systemFontOfSize:25];
        _carrotCountLabel.textColor = UIColor.whiteColor;
    }
    return _carrotCountLabel;
}

- (UILabel *)prizeName {
    if (!_prizeName) {
        _prizeName = [[UILabel alloc] init];
        _prizeName.textColor = [UIColor whiteColor];
        _prizeName.font = [UIFont systemFontOfSize:21];
        _prizeName.adjustsFontSizeToFitWidth = YES;
        _prizeName.numberOfLines = 0;
    }
    return _prizeName;
}

- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"carrot_done_icon"]];
    }
    return _imageView;
}

- (UIImageView *)effectImageView {
    if (!_effectImageView) {
        _effectImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"checkin_receipt_alert_decorate"]];
        _effectImageView.hidden = YES;
    }
    return _effectImageView;
}

@end
