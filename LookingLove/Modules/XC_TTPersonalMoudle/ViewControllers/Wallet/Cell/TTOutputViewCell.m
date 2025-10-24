//
//  TTOutputViewCell.m
//  TuTu
//
//  Created by lee on 2018/11/6.
//  Copyright © 2018 YiZhuan. All rights reserved.
//

#import "TTOutputViewCell.h"

#import <Masonry/Masonry.h>
#import "XCTheme.h"
#import "XCMacros.h"
#import "UIView+ZJFrame.h"
#import "WithDrawalInfo.h"
#import "RedWithdrawalsListInfo.h"

@interface TTOutputViewCell ()

@property (nonatomic, strong) UIButton *diamondBtn;
@property (nonatomic, strong) UIButton *priceBtn;
@property (nonatomic, strong) UIButton *cashBtn;
@end

@implementation TTOutputViewCell

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
    [self addSubview:self.diamondBtn];
    [self addSubview:self.priceBtn];
    [self addSubview:self.cashBtn];
}

- (void)initConstraints {
    [self.diamondBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.top.mas_equalTo(15);
        make.height.mas_equalTo(16);
    }];
    
    [self.priceBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.top.mas_equalTo(self.diamondBtn.mas_bottom).offset(9);
        make.height.mas_equalTo(10);
    }];
    
    [self.cashBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(0);
    }];
}

- (void)setSelected:(BOOL)selected {
    [super setSelected:selected];
    
    if (selected) {
        self.backgroundColor = UIColorFromRGB(0xFFE3D1);
        self.layer.borderColor = UIColorFromRGB(0xFFE3D1).CGColor;
    } else {
        self.backgroundColor = [UIColor whiteColor];
        self.layer.borderWidth = 1.f;
        self.layer.borderColor = [XCTheme getTTDeepGrayTextColor].CGColor;
    }
    
    self.diamondBtn.selected = selected;
    self.priceBtn.selected = selected;
    self.cashBtn.selected = selected;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.layer.cornerRadius = 30.f;
    self.layer.masksToBounds = YES;
    self.backgroundColor = [UIColor whiteColor];
    self.layer.borderWidth = 1.f;
    self.layer.borderColor = [XCTheme getTTDeepGrayTextColor].CGColor;
}

#pragma mark -
#pragma mark getter & stter
- (void)setcodeRedInfo:(WithDrawalInfo *)codeRedInfo {
    if (_codeRedInfo == codeRedInfo) {
        return;
    }
    _codeRedInfo = codeRedInfo;
    self.cashBtn.hidden = YES;
    [self.diamondBtn setTitle:[NSString stringWithFormat:@"%@钻", codeRedInfo.diamondNum] forState:UIControlStateNormal];
    [self.priceBtn setTitle:codeRedInfo.cashNum forState:UIControlStateNormal];
}

- (void)setRedDrawInfo:(RedWithdrawalsListInfo *)redDrawInfo {
    if (_redDrawInfo == redDrawInfo) {
        return;
    }
    _redDrawInfo = redDrawInfo;
    self.priceBtn.hidden = self.diamondBtn.hidden = YES;
    [self.cashBtn setTitle:[NSString stringWithFormat:@"￥%ld", (long)redDrawInfo.packetNum] forState:UIControlStateNormal];
}

- (UIButton *)diamondBtn {
    if (!_diamondBtn) {
        _diamondBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_diamondBtn setTitleColor:[XCTheme getTTDeepGrayTextColor] forState:UIControlStateNormal];
        [_diamondBtn setTitleColor:[XCTheme getTTMainColor] forState:UIControlStateSelected];
        _diamondBtn.imageEdgeInsets = UIEdgeInsetsMake(0, -6, 0, 0);
        [_diamondBtn.titleLabel setFont:[UIFont systemFontOfSize:15.f]];
        _diamondBtn.userInteractionEnabled = NO;
    }
    return _diamondBtn;
}

- (UIButton *)priceBtn {
    if (!_priceBtn) {
        _priceBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_priceBtn setTitleColor:[XCTheme getTTDeepGrayTextColor] forState:UIControlStateNormal];
        [_priceBtn setTitleColor:[XCTheme getTTMainColor] forState:UIControlStateSelected];
        [_priceBtn.titleLabel setFont:[UIFont systemFontOfSize:12.f]];
        _priceBtn.userInteractionEnabled = NO;
    }
    return _priceBtn;
}

- (UIButton *)cashBtn {
    if (!_cashBtn) {
        _cashBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_cashBtn setTitleColor:[XCTheme getTTMainTextColor] forState:UIControlStateNormal];
        [_cashBtn.titleLabel setFont:[UIFont systemFontOfSize:17.f]];
        [_cashBtn setTitleColor:[XCTheme getTTMainColor] forState:UIControlStateSelected];
        _cashBtn.userInteractionEnabled = NO;
    }
    return _cashBtn;
}

@end
