//
//  TTNewUserGiftAlertView.m
//  XC_TTChatViewKit
//
//  Created by lee on 2019/7/3.
//  Copyright © 2019 YiZhuan. All rights reserved.
//

#import "TTNewUserGiftAlertView.h"
#import <Masonry/Masonry.h>
#import "XCTheme.h"
#import "XCMacros.h"

@interface TTNewUserGiftAlertView ()

@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UIImageView *carrotImageView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *carrotCountLabel;
@property (nonatomic, strong) UIButton *confirmButton;
@property (nonatomic, strong) UILabel *tipsLabel;

@end

@implementation TTNewUserGiftAlertView

#pragma mark -
#pragma mark lifeCycle
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initViews];
        [self initConstraints];
    }
    return self;
}

- (void)initViews {
    [self addSubview:self.bgView];
    [self addSubview:self.carrotImageView];
    [self addSubview:self.titleLabel];
    [self addSubview:self.carrotCountLabel];
    [self addSubview:self.confirmButton];
    [self addSubview:self.tipsLabel];
}

- (void)initConstraints {
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self);
    }];
    
    [self.carrotImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self);
        make.top.mas_equalTo(-82);
        make.height.width.mas_equalTo(171);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self);
        make.top.mas_equalTo(self.carrotImageView.mas_bottom).offset(0);
    }];
    
    [self.carrotCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self);
        make.top.mas_equalTo(self.titleLabel.mas_bottom).offset(8);
    }];
    
    [self.confirmButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self);
        make.height.mas_equalTo(38);
        make.width.mas_equalTo(136);
        make.top.mas_equalTo(self.carrotCountLabel.mas_bottom).offset(26);
    }];
    
    [self.tipsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(-20);
        make.centerX.mas_equalTo(self);
    }];
}

#pragma mark -
#pragma mark SystemApi Delegate

#pragma mark -
#pragma mark CustomView Delegate

#pragma mark -
#pragma mark CoreClients

#pragma mark -
#pragma mark Event Response
- (void)onClickConfirmButtonAction:(UIButton *)confirmButton {
    !_finishHandler ?: _finishHandler();
}
#pragma mark -
#pragma mark Public Methods
/** 改变按钮状态 */
- (void)changeConfirmButtonState {
    [_confirmButton setTitle:@"已领取" forState:UIControlStateNormal];
    [_confirmButton setTitleColor:[XCTheme getTTDeepGrayTextColor] forState:UIControlStateNormal];
    [_confirmButton setBackgroundColor:UIColorFromRGB(0xF0F0F0)];
}

#pragma mark -
#pragma mark Private Methods

#pragma mark -
#pragma mark Getters and Setters
- (UIImageView *)carrotImageView {
    if (!_carrotImageView) {
        _carrotImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"room_newUserGiftAlert"]];
    }
    return _carrotImageView;
}

- (UILabel *)carrotCountLabel {
    if (!_carrotCountLabel) {
        _carrotCountLabel = [[UILabel alloc] init];
        _carrotCountLabel.text = @"萝卜X20";
        _carrotCountLabel.textColor = [XCTheme getTTMainColor];
        _carrotCountLabel.font = [UIFont systemFontOfSize:15];
        _carrotCountLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _carrotCountLabel;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.text = @"新人有礼";
        _titleLabel.textColor = [XCTheme getTTMainTextColor];
        _titleLabel.font = [UIFont boldSystemFontOfSize:22];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLabel;
}

- (UIButton *)confirmButton {
    if (!_confirmButton) {
        _confirmButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_confirmButton setTitle:@"领取奖励" forState:UIControlStateNormal];
        [_confirmButton setBackgroundColor:[XCTheme getTTMainColor]];
        [_confirmButton.titleLabel setFont:[UIFont systemFontOfSize:15]];
        _confirmButton.layer.cornerRadius = 19.f;
        _confirmButton.layer.masksToBounds = YES;
        [_confirmButton addTarget:self action:@selector(onClickConfirmButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _confirmButton;
}

- (UILabel *)tipsLabel {
    if (!_tipsLabel) {
        _tipsLabel = [[UILabel alloc] init];
        _tipsLabel.text = @"萝卜可用于送礼物、购买头饰座驾哦~";
        _tipsLabel.font = [UIFont systemFontOfSize:12];
        _tipsLabel.textColor = [XCTheme getMSDeepGrayColor];
        _tipsLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _tipsLabel;
}

- (UIView *)bgView {
    if (!_bgView) {
        _bgView = [[UIView alloc] init];
        _bgView.backgroundColor = [UIColor whiteColor];
        _bgView.layer.cornerRadius = 14.f;
        _bgView.layer.masksToBounds = YES;
    }
    return _bgView;
}

@end
