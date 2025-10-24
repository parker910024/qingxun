//
//  TTCarDressUpEmptyCell.m
//  TuTu
//
//  Created by lee on 2018/11/20.
//  Copyright © 2018 YiZhuan. All rights reserved.
//

#import "TTCarDressUpEmptyCell.h"
#import <Masonry/Masonry.h>
#import "XCTheme.h"
#import "XCMacros.h"
#import "UIView+ZJFrame.h"


@interface TTCarDressUpEmptyCell ()

@property (nonatomic, strong) UIImageView *carImageView;
@property (nonatomic, strong) UIButton *carShopBtn;

@end

@implementation TTCarDressUpEmptyCell

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
    [self.contentView addSubview:self.carImageView];
    [self.contentView addSubview:self.carShopBtn];
}

- (void)initConstraints {
    [self.carImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(185, 145));
        make.top.mas_equalTo(10);
        make.centerX.mas_equalTo(0);
    }];
    
    [self.carShopBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.top.mas_equalTo(self.carImageView.mas_bottom).offset(4);
        make.height.mas_equalTo(40);
        make.left.right.mas_equalTo(0).inset(90);
    }];
}

#pragma mark -
#pragma mark clients

#pragma mark -
#pragma mark private methods

#pragma mark -
#pragma mark button click events
- (void)gotoCarShopBtnClick:(UIButton *)btn {
    if ([self.delegate respondsToSelector:@selector(onCellBtnClickAction:)] && self.delegate) {
        [self.delegate onCellBtnClickAction:btn];
    }
}
#pragma mark -
#pragma mark getter & setter
- (void)setEmptyStyle:(TTMineInfoViewStyle)emptyStyle {
    _emptyStyle = emptyStyle;
    
    if (emptyStyle == TTMineInfoViewStyleOhter) {
        self.carShopBtn.selected = YES;
    } else {
        self.carShopBtn.selected = NO;
    }
}

- (UIImageView *)carImageView
{
    if (!_carImageView) {
        _carImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"common_noData_empty"]];
    }
    return _carImageView;
}

- (UIButton *)carShopBtn {
    if (!_carShopBtn) {
        _carShopBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_carShopBtn setTitle:@"前往商城购买" forState:UIControlStateNormal];
        [_carShopBtn setTitle:@"送TA一部" forState:UIControlStateSelected];
        [_carShopBtn setTitle:_carShopBtn.titleLabel.text forState:UIControlStateHighlighted];
        [_carShopBtn setTitleColor:[XCTheme getTTMainColor] forState:UIControlStateNormal];
        [_carShopBtn.titleLabel setFont:[UIFont systemFontOfSize:16.f]];
        _carShopBtn.layer.borderColor = [XCTheme getTTMainColor].CGColor;
        _carShopBtn.layer.borderWidth = 1.f;
        _carShopBtn.layer.masksToBounds = YES;
        _carShopBtn.layer.cornerRadius = 20;
        [_carShopBtn addTarget:self action:@selector(gotoCarShopBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _carShopBtn;
}


@end
