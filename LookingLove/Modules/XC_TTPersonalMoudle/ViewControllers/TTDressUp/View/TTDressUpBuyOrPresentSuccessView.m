//
//  TTDressUpBuyOrPresentSuccessView.m
//  TuTu
//
//  Created by Macx on 2018/11/2.
//  Copyright © 2018年 YiZhuan. All rights reserved.
//

#import "TTDressUpBuyOrPresentSuccessView.h"
//t
#import <Masonry/Masonry.h>
#import "XCTheme.h"
#import "XCMacros.h"
//c
#import "UIImage+Utils.h"

@interface TTDressUpBuyOrPresentSuccessView()
@property (nonatomic, strong) UIButton  *ensureBtn;//
@property (nonatomic, strong) UIImageView  *iconImageView;//图标
@property (nonatomic, strong) UIView  *contentView;//
@end

@implementation TTDressUpBuyOrPresentSuccessView


- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initSubViews];
    }
    return self;
}

- (instancetype)init {
    if (self = [super init]) {
        self.frame = CGRectMake(0, 0, 260, 188+81/2);
        [self initSubViews];
    }
    return self;
}

- (void)initSubViews {
    self.contentView.layer.masksToBounds = YES;
    self.contentView.layer.cornerRadius = 8;
    [self addSubview:self.contentView];
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.ensureBtn];
    [self addSubview:self.iconImageView];
    [self makeConstriants];
}

- (void)makeConstriants {
    
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.mas_equalTo(self);
        make.top.mas_equalTo(self).offset(81/2);
    }];
    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentView).offset(19);
        make.centerX.mas_equalTo(self);
        make.height.mas_equalTo(76);
        make.width.mas_equalTo(76);
    }];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.iconImageView.mas_bottom).offset(7);
        make.centerX.mas_equalTo(self.contentView);
    }];
    [self.ensureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.contentView).offset(-16);
        make.centerX.mas_equalTo(self.contentView);
        make.height.mas_equalTo(38);
        make.width.mas_equalTo(124);
    }];
}

#pragma mark - Action
- (void)ensureBtnAction {
    !self.ensureBlock?:self.ensureBlock();
}

#pragma mark - Getter && Setter

- (void)setTitleString:(NSString *)titleString {
    _titleLabel.text = titleString;
}

- (void)setImageString:(NSString *)imageString {
    _iconImageView.image = [UIImage imageNamed:imageString];
}

- (void)setBtnSize:(CGSize)btnSize {
    [self.ensureBtn mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(btnSize.width);
        make.height.mas_equalTo(btnSize.height);
    }];
    
    _ensureBtn.layer.cornerRadius = btnSize.height / 2;
}

- (void)setBtnColor:(UIColor *)btnColor {
    _ensureBtn.backgroundColor = btnColor;
    [_ensureBtn setTitleColor:XCTheme.getTTMainColor forState:UIControlStateNormal];
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.text = @"恭喜您！购买成功";
        _titleLabel.textColor = UIColorFromRGB(0x333333);
        _titleLabel.font = [UIFont systemFontOfSize:17];
    }
    return _titleLabel;
}

- (UIButton *)ensureBtn {
    if (!_ensureBtn) {
        _ensureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_ensureBtn addTarget:self action:@selector(ensureBtnAction) forControlEvents:UIControlEventTouchUpInside];
        [_ensureBtn setTitle:@"关闭" forState:UIControlStateNormal];
        _ensureBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        _ensureBtn.backgroundColor = UIColorFromRGB(0xF0F0F0);
        [_ensureBtn setTitleColor:[XCTheme getTTMainColor] forState:UIControlStateNormal];
        _ensureBtn.layer.masksToBounds = YES;
        _ensureBtn.layer.cornerRadius = 19;
        
        _ensureBtn.layer.borderWidth = 2;
        _ensureBtn.layer.borderColor = UIColorFromRGB(0xB3B3B3).CGColor;
        [_ensureBtn setBackgroundColor:UIColor.whiteColor];
        [_ensureBtn setTitleColor:[XCTheme getTTMainTextColor] forState:UIControlStateNormal];
    }
    return _ensureBtn;
}

- (UIImageView *)iconImageView {
    if (!_iconImageView) {
        _iconImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"preson_DressUp_buySuccess"]];
    }
    return _iconImageView;
}

- (UIView *)contentView {
    if (!_contentView) {
        _contentView = [[UIView alloc] init];
        _contentView.backgroundColor = [UIColor whiteColor];
    }
    return _contentView;
}

@end
