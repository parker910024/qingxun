//
//  XCGoldHandlerView.m
//  XCRoomMoudle
//
//  Created by KevinWang on 2018/8/22.
//  Copyright © 2018年 YiZhuan. All rights reserved.
//

#import "XCBoxGoldView.h"
#import <Masonry.h>
#import "XCTheme.h"


@interface XCBoxGoldView()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *goldLabel;//gold
@property (nonatomic, strong) UIButton *chargeButton;//充值

@end

@implementation XCBoxGoldView

#pragma mark - Life Style
- (instancetype)initWithFrame:(CGRect)frame{
    if (self=[super initWithFrame:frame]) {
        [self setupSubviews];
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}
- (void)layoutSubviews{
    [super layoutSubviews];
    [self setupSubviewsConstraints];
}
#pragma mark - event response
- (void)buttonDidClick:(UIButton *)button{
    if (self.rechargeButtonClickBlock) {
        self.rechargeButtonClickBlock();
    }
}

#pragma mark - Public

- (void)setIsDiamondBox:(BOOL)isDiamondBox {
    _isDiamondBox = isDiamondBox;
    if (self.isDiamondBox) {
        [self.titleLabel setTextColor:UIColorFromRGB(0xFFDD09)];
        
        [self.chargeButton setImage:nil forState:UIControlStateNormal];
        [self.chargeButton setBackgroundImage:[UIImage imageNamed:@"room_diamond_box_recharge"] forState:UIControlStateNormal];
        [self.chargeButton setTitleColor:UIColorFromRGB(0xC94E0E) forState:UIControlStateNormal];
        [self.chargeButton.titleLabel setFont:[UIFont systemFontOfSize:14]];

        [self.chargeButton mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@55);
            make.height.equalTo(@30);
        }];
    } else {
        [self.titleLabel setTextColor:[UIColor whiteColor]];
        [self.chargeButton setImage:[UIImage imageNamed:@"room_box_recharge"] forState:UIControlStateNormal];
    }
}


#pragma mark - Private
- (void)setupSubviews{
    [self addSubview:self.titleLabel];
    [self addSubview:self.goldLabel];
    [self addSubview:self.chargeButton];
}
- (void)setupSubviewsConstraints{
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(17.5);
        make.centerY.equalTo(self);
    }];
    [self.goldLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLabel.mas_right).offset(8);
        make.centerY.equalTo(self.titleLabel);
    }];
    [self.chargeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(-17.5);
        make.centerY.equalTo(self.titleLabel);
        make.width.equalTo(@60);
        make.height.equalTo(@28);
    }];
}

#pragma mark - Getter
- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = UIColorFromRGB(0xFF8D50);
        _titleLabel.text = @"金币:";
        _titleLabel.font = [UIFont systemFontOfSize:15];
    }
    return _titleLabel;
}
- (UILabel *)goldLabel{
    if (!_goldLabel) {
        _goldLabel = [[UILabel alloc] init];
        _goldLabel.textColor = [UIColor whiteColor];
        _goldLabel.text = @"0.00";
        _goldLabel.font = [UIFont boldSystemFontOfSize:15.0];
    }
    return _goldLabel;
}
- (UIButton *)chargeButton{
    if (!_chargeButton) {
        _chargeButton = [[UIButton alloc] init];
        [_chargeButton setBackgroundImage:[UIImage imageNamed:@"room_box_recharge"] forState:UIControlStateNormal];
        [_chargeButton setTitle:@"充值" forState:UIControlStateNormal];
        _chargeButton.layer.cornerRadius = 15.0;
        [_chargeButton addTarget:self action:@selector(buttonDidClick:) forControlEvents:UIControlEventTouchUpInside];
        _chargeButton.titleLabel.font = [UIFont systemFontOfSize:14];
    }
    return _chargeButton;
}

@end
