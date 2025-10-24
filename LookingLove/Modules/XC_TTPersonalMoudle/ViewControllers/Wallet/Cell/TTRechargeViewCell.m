//
//  TTRechargeViewCell.m
//  TuTu
//
//  Created by lee on 2018/11/5.
//  Copyright © 2018 YiZhuan. All rights reserved.
//

#import "TTRechargeViewCell.h"

#import <Masonry/Masonry.h>
#import "XCTheme.h"
#import "XCMacros.h"
#import "UIView+ZJFrame.h"
#import "RechargeInfo.h"

@interface TTRechargeViewCell ()

@property (nonatomic, strong) UIButton *coinBtn; // 金币按钮
@property (nonatomic, strong) UIButton *priceBtn; // 价格
@property (nonatomic, strong) UIImageView *firstIcon; // 首冲icon

@end

@implementation TTRechargeViewCell

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
    [self addSubview:self.coinBtn];
    [self addSubview:self.priceBtn];
    [self addSubview:self.firstIcon];
}

- (void)initConstraints {
    [self.coinBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.centerY.mas_equalTo(self);
    }];
    
    [self.priceBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-23);
        make.centerY.mas_equalTo(self);
    }];
    
    [self.firstIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.priceBtn.mas_left).offset(-5);
        make.centerY.mas_equalTo(self.priceBtn);
    }];
}

- (void)setIsSelected:(BOOL)isSelected {
    
    // 如果是轻寻项目
    if (isSelected) {
        self.layer.borderColor = [UIColor blackColor].CGColor;
    } else {
        self.layer.borderColor = [XCTheme getTTDeepGrayTextColor].CGColor;
    }
    
    self.layer.borderWidth = 2;
    
    self.coinBtn.selected = isSelected;
    self.priceBtn.selected = isSelected;
}

- (void)setSelected:(BOOL)selected {
    [super setSelected:selected];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.layer.cornerRadius = 25.5;
    self.layer.masksToBounds = YES;
}

#pragma mark -
#pragma mark getter & stter
- (void)setRechargeInfo:(RechargeInfo *)rechargeInfo {
    if (_rechargeInfo == rechargeInfo) {
        return;
    }
    _rechargeInfo = rechargeInfo;
    [_coinBtn setTitle:rechargeInfo.prodName forState:UIControlStateNormal];
    [_priceBtn setTitle:[NSString stringWithFormat:@"￥%@元", rechargeInfo.money.stringValue] forState:UIControlStateNormal];
    
    self.firstIcon.hidden = ![rechargeInfo.money isEqualToNumber:@1];
}

- (UIButton *)coinBtn {
    if (!_coinBtn) {
        _coinBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_coinBtn setImage:[UIImage imageNamed:@"rechargeCoin_gary"] forState:UIControlStateNormal];
        [_coinBtn setImage:[UIImage imageNamed:@"rechargeCoin_orange"] forState:UIControlStateSelected];
        [_coinBtn setTitleColor:[XCTheme getTTDeepGrayTextColor] forState:UIControlStateNormal];
        [_coinBtn setTitleColor:[XCTheme getTTMainColor] forState:UIControlStateSelected];
        [_coinBtn.titleLabel setFont:[UIFont systemFontOfSize:15.f]];

        [_coinBtn setImage:[UIImage imageNamed:@"rechargeCoin_normal"] forState:UIControlStateNormal];
        [_coinBtn setImage:[UIImage imageNamed:@"rechargeCoin_selected"] forState:UIControlStateSelected];
        [_coinBtn setTitleColor:[XCTheme getTTMainTextColor] forState:UIControlStateSelected];
        [_coinBtn.titleLabel setFont:[UIFont systemFontOfSize:16.f]];
        _coinBtn.imageEdgeInsets = UIEdgeInsetsMake(0, -6, 0, 0);
        _coinBtn.userInteractionEnabled = NO;
    }
    return _coinBtn;
}

- (UIButton *)priceBtn {
    if (!_priceBtn) {
        _priceBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_priceBtn setTitleColor:[XCTheme getTTDeepGrayTextColor] forState:UIControlStateNormal];
        [_priceBtn setTitleColor:[XCTheme getTTMainColor] forState:UIControlStateSelected];
        [_priceBtn.titleLabel setFont:[UIFont systemFontOfSize:12.f]];
        _priceBtn.userInteractionEnabled = NO;
        [_priceBtn setTitleColor:[XCTheme getTTMainTextColor] forState:UIControlStateSelected];
        [_priceBtn.titleLabel setFont:[UIFont systemFontOfSize:13.f]];
    }
    return _priceBtn;
}

- (UIImageView *)firstIcon {
    if (!_firstIcon) {
        _firstIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"firstRecharge_icon"]];
        _firstIcon.hidden = YES;
    }
    return _firstIcon;
}

@end
