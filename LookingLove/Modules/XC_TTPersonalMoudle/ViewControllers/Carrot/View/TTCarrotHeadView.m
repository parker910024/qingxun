//
//  TTCarrotHeadView.m
//  TTPlay
//
//  Created by lee on 2019/3/15.
//  Copyright © 2019 YiZhuan. All rights reserved.
//

#import "TTCarrotHeadView.h"
#import <Masonry/Masonry.h>
#import "XCTheme.h"
#import "XCMacros.h"
#import "UIView+ZJFrame.h"

// model
#import "CarrotWallet.h"

@interface TTCarrotHeadView ()
@property (nonatomic, strong) UIImageView *bgImageView;
@property (nonatomic, strong) UILabel *carrotNumLabel;
@property (nonatomic, strong) UILabel *textLabel;
@property (nonatomic, strong) UIButton *carrotInBtn;
@property (nonatomic, strong) UIButton *carrotOutBtn;
@property (nonatomic, strong) UIView *lineView;
@end

@implementation TTCarrotHeadView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initViews];
        [self initConstraints];
    }
    return self;
}

#pragma mark -
#pragma mark lifeCycle
- (void)initViews {
    [self addSubview:self.bgImageView];
    [self addSubview:self.carrotNumLabel];
    [self addSubview:self.textLabel];
    [self addSubview:self.carrotInBtn];
    [self addSubview:self.carrotOutBtn];
    [self addSubview:self.lineView];
}

- (void)initConstraints {
    [self.bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self);
    }];
    
    [self.carrotNumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(self);
    }];
    
    [self.textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self);
        make.top.mas_equalTo(self.carrotNumLabel.mas_bottom).offset(12);
    }];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self);
        make.height.mas_equalTo(16);
        make.width.mas_equalTo(1);
        make.bottom.mas_equalTo(self).inset(18);
    }];
    
    [self.carrotInBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(self).multipliedBy(0.5).offset(-1);
        make.left.mas_equalTo(self);
        make.centerY.mas_equalTo(self.lineView);
    }];
    
    [self.carrotOutBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(self).multipliedBy(0.5).offset(-1);
        make.right.mas_equalTo(self);
        make.centerY.mas_equalTo(self.lineView);
    }];
}

#pragma mark -
#pragma mark clients

#pragma mark -
#pragma mark private methods
- (void)setCarrotWalletInfo:(CarrotWallet *)carrotWalletInfo {
    _carrotWalletInfo = carrotWalletInfo;
    self.carrotNumLabel.text = carrotWalletInfo.amount;
}
#pragma mark -
#pragma mark button click events
// 点击收入
- (void)onClickCarrotInBtnAction:(UIButton *)carrotInBtn {
    [carrotInBtn.titleLabel setFont:[UIFont boldSystemFontOfSize:17]];
    [carrotInBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    [_carrotOutBtn.titleLabel setFont:[UIFont systemFontOfSize:16]];
    [_carrotOutBtn setTitleColor:UIColorRGBAlpha(0xffffff, 0.75) forState:UIControlStateNormal];
    !_selectHandler ? : _selectHandler(carrotInBtn.tag);
}
// 点击支出
- (void)onClickCarrotOutBtnAction:(UIButton *)carrotOutBtn {
    [carrotOutBtn.titleLabel setFont:[UIFont boldSystemFontOfSize:17]];
    [carrotOutBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    [_carrotInBtn setTitleColor:UIColorRGBAlpha(0xffffff, 0.75) forState:UIControlStateNormal];
    [_carrotInBtn.titleLabel setFont:[UIFont systemFontOfSize:16]];
    !_selectHandler ? : _selectHandler(carrotOutBtn.tag);
}

#pragma mark -
#pragma mark getter & setter
- (UIImageView *)bgImageView {
    if (!_bgImageView) {
        _bgImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"radish_bg_n"]];
    }
    return _bgImageView;
}

- (UILabel *)carrotNumLabel {
    if (!_carrotNumLabel) {
        _carrotNumLabel = [[UILabel alloc] init];
        _carrotNumLabel.text = @"0";
        _carrotNumLabel.textColor = UIColor.whiteColor;
        _carrotNumLabel.font = [UIFont boldSystemFontOfSize:47];
        _carrotNumLabel.adjustsFontSizeToFitWidth = YES;
    }
    return _carrotNumLabel;
}

- (UILabel *)textLabel
{
    if (!_textLabel) {
        _textLabel = [[UILabel alloc] init];
        _textLabel.text = @"我的萝卜总额";
        _textLabel.textColor = UIColorRGBAlpha(0xFFFFFF, 0.7);
        _textLabel.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:14.f];
        _textLabel.adjustsFontSizeToFitWidth = YES;
    }
    return _textLabel;
}

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = UIColor.whiteColor;
    }
    return _lineView;
}

- (UIButton *)carrotInBtn {
    if (!_carrotInBtn) {
        _carrotInBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_carrotInBtn setTitle:@"收入" forState:UIControlStateNormal];
        [_carrotInBtn.titleLabel setFont:[UIFont boldSystemFontOfSize:17.f]];
        [_carrotInBtn addTarget:self action:@selector(onClickCarrotInBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        _carrotInBtn.tag = 0;
    }
    return _carrotInBtn;
}

- (UIButton *)carrotOutBtn {
    if (!_carrotOutBtn) {
        _carrotOutBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_carrotOutBtn setTitle:@"支出" forState:UIControlStateNormal];
        [_carrotOutBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        [_carrotOutBtn.titleLabel setFont:[UIFont systemFontOfSize:16.f]];
        [_carrotOutBtn addTarget:self action:@selector(onClickCarrotOutBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        _carrotOutBtn.tag = 1;
    }
    return _carrotOutBtn;
}


@end
