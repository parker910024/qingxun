//
//  TTCarDressReusableViewFooter.m
//  TuTu
//
//  Created by lee on 2018/11/23.
//  Copyright © 2018 YiZhuan. All rights reserved.
//

#import "TTCarDressReusableViewFooter.h"

#import <Masonry/Masonry.h>
#import "XCTheme.h"
#import "XCMacros.h"
#import "UIView+ZJFrame.h"


@interface TTCarDressReusableViewFooter ()

@property (nonatomic, strong) UIButton *gotoCarDressShopBtn;

@end

@implementation TTCarDressReusableViewFooter

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
    [self addSubview:self.gotoCarDressShopBtn];
}

- (void)initConstraints {
    [self.gotoCarDressShopBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0).inset(90);
        make.top.mas_equalTo(10);
        make.height.mas_equalTo(40);
    }];
}

#pragma mark -
#pragma mark clients

#pragma mark -
#pragma mark private methods

#pragma mark -
#pragma mark button click events
- (void)onGotoCarDressShopBtnClickAction:(UIButton *)gotoCarDressShopBtn {
    if (self.delegate && [self.delegate respondsToSelector:@selector(gotoCarDressShopClick:)]) {
        [self.delegate gotoCarDressShopClick:gotoCarDressShopBtn];
    }
}

#pragma mark -
#pragma mark getter & setter
- (UIButton *)gotoCarDressShopBtn {
    if (!_gotoCarDressShopBtn) {
        _gotoCarDressShopBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_gotoCarDressShopBtn setTitle:@"送他一部" forState:UIControlStateNormal];
        [_gotoCarDressShopBtn setTitleColor:[XCTheme getTTMainColor] forState:UIControlStateNormal];
        [_gotoCarDressShopBtn.titleLabel setFont:[UIFont systemFontOfSize:16.f]];
        [_gotoCarDressShopBtn setBackgroundColor:[UIColor whiteColor]];
        _gotoCarDressShopBtn.layer.masksToBounds = YES;
        _gotoCarDressShopBtn.layer.cornerRadius = 20;
        _gotoCarDressShopBtn.layer.borderColor = [XCTheme getTTMainColor].CGColor;
        _gotoCarDressShopBtn.layer.borderWidth = 1.f;
        [_gotoCarDressShopBtn addTarget:self action:@selector(onGotoCarDressShopBtnClickAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _gotoCarDressShopBtn;
}

@end
