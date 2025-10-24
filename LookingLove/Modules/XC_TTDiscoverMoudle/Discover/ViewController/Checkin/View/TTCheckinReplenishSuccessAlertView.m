//
//  TTCheckinReplenishSuccessAlertView.m
//  XC_TTDiscoverMoudle
//
//  Created by lvjunhang on 2019/5/8.
//  Copyright © 2019 fengshuo. All rights reserved.
//

#import "TTCheckinReplenishSuccessAlertView.h"

#import "XCMacros.h"
#import "XCTheme.h"
#import "XCCurrentVCStackManager.h"
#import "UIImageView+QiNiu.h"

#import <Masonry/Masonry.h>
#import <UICountingLabel/UICountingLabel.h>

#import <WebKit/WebKit.h>

@interface TTCheckinReplenishSuccessAlertView ()

@property (nonatomic, strong) UIView *bgView;//白色背景

@property (nonatomic, strong) UIImageView *checkmarkImageView;//成功钩子
@property (nonatomic, strong) UILabel *titleLabel;//补签成功
@property (nonatomic, strong) UILabel *giftNameLabel;//萝卜x30
@property (nonatomic, strong) UIButton *sureButton;//分享

@end

@implementation TTCheckinReplenishSuccessAlertView

#pragma mark - life cycle

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor.blackColor colorWithAlphaComponent:0.3];
        
        [self initView];
        [self initConstraints];
        
        UITapGestureRecognizer *tapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapViewAciton)];
        [self addGestureRecognizer:tapGR];
    }
    return self;
}

#pragma mark - public method
/**
 显示弹窗
 
 @param rewardName 奖品名称
 */
- (void)configRerard:(NSString *)rewardName {
    
    NSString *reward = [NSString stringWithFormat:@"获得 %@", rewardName];
    NSRange gainRange = [reward rangeOfString:@"获得"];
    
    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:reward];
    [attr addAttribute:NSForegroundColorAttributeName value:[XCTheme getTTMainTextColor] range:gainRange];
    self.giftNameLabel.attributedText = attr;
}

#pragma mark - custom protocols
#pragma mark - core protocols
#pragma mark - event response
- (void)sureButtonTapped:(UIButton *)sender {
    !self.sureBlock ?: self.sureBlock();
    
    [self tapViewAciton];
}

- (void)tapViewAciton {
    [self removeFromSuperview];
}

#pragma mark - private method
- (void)initView {
    [self addSubview:self.bgView];
    [self.bgView addSubview:self.checkmarkImageView];
    [self.bgView addSubview:self.titleLabel];
    [self.bgView addSubview:self.giftNameLabel];
    [self.bgView addSubview:self.sureButton];
}

- (void)initConstraints {
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(0);
        make.left.right.mas_equalTo(self).inset(40);
        make.height.mas_equalTo(220);
    }];
    
    [self.checkmarkImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(18);
        make.width.height.mas_equalTo(74);
        make.centerX.mas_equalTo(self);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.checkmarkImageView.mas_bottom).offset(8);
        make.centerX.mas_equalTo(0);
    }];
    
    [self.giftNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.titleLabel.mas_bottom).offset(14);
        make.left.right.mas_equalTo(self.bgView).inset(10);
    }];
    
    [self.sureButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.giftNameLabel.mas_bottom).offset(22);
        make.centerX.mas_equalTo(self);
        make.width.mas_equalTo(120);
        make.height.mas_equalTo(38);
    }];
}

#pragma mark - Getter Setter
- (UIView *)bgView {
    if (_bgView == nil) {
        _bgView = [[UIView alloc] init];
        _bgView.backgroundColor = UIColor.whiteColor;
        _bgView.layer.masksToBounds = YES;
        _bgView.layer.cornerRadius = 14;
    }
    return _bgView;
}

- (UIImageView *)checkmarkImageView {
    if (_checkmarkImageView == nil) {
        _checkmarkImageView = [[UIImageView alloc] init];
        _checkmarkImageView.image = [UIImage imageNamed:@"checkin_replenish_success"];
    }
    return _checkmarkImageView;
}

- (UILabel *)titleLabel {
    if (_titleLabel == nil) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.text = @"补签成功";
        _titleLabel.textColor = [XCTheme getTTMainTextColor];
        _titleLabel.font = [UIFont systemFontOfSize:16];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLabel;
}

- (UILabel *)giftNameLabel {
    if (_giftNameLabel == nil) {
        _giftNameLabel = [[UILabel alloc] init];
        _giftNameLabel.textColor = [XCTheme getTTMainColor];
        _giftNameLabel.font = [UIFont systemFontOfSize:14];
        _giftNameLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _giftNameLabel;
}

- (UIButton *)sureButton {
    if (_sureButton == nil) {
        _sureButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_sureButton setTitle:@"确定" forState:UIControlStateNormal];
        _sureButton.titleLabel.font = [UIFont systemFontOfSize:15];
        _sureButton.backgroundColor = UIColorFromRGB(0xFFB606);
        [_sureButton addTarget:self action:@selector(sureButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
        
        _sureButton.layer.masksToBounds = YES;
        _sureButton.layer.cornerRadius = 19;
    }
    return _sureButton;
}

@end

