//
//  LLAppleAuthView.m
//  XC_TTAuthMoudle
//
//  Created by Lee on 2019/12/20.
//  Copyright © 2019 YiZhuan. All rights reserved.
//

#import "LLAppleAuthView.h"
#import <Masonry/Masonry.h>
#import "XCTheme.h"
#import "XCMacros.h"
#import "UIView+ZJFrame.h"
#import "UIView+XCToast.h"

@interface LLAppleAuthView ()

@property (nonatomic, strong) UIImageView *appleIcon;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIImageView *arrowIcon;

@end

@implementation LLAppleAuthView

#pragma mark - lifeCyle
- (instancetype)init
{
    self = [super init];
    if (self) {
        [self initViews];
        [self initConstraints];
    }
    return self;
}

- (void)initViews {
    [self addSubview:self.appleIcon];
    [self addSubview:self.titleLabel];
    [self addSubview:self.arrowIcon];
}

- (void)initConstraints {
    [self.appleIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.width.mas_equalTo(22);
        make.top.left.bottom.mas_equalTo(self);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.appleIcon.mas_right).offset(3.5);
        make.centerY.mas_equalTo(self.appleIcon);
    }];
    
    [self.arrowIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.titleLabel.mas_right).offset(8.5);
        make.right.mas_equalTo(self);
        make.width.mas_equalTo(6);
        make.height.mas_equalTo(10);
    }];
}

- (UIImageView *)appleIcon {
    if (!_appleIcon) {
        _appleIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@""]];
    }
    return _appleIcon;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = [XCTheme getTTMainTextColor];
        _titleLabel.font = [UIFont systemFontOfSize:15];
        _titleLabel.text = @"通过Apple登录";
    }
    return _titleLabel;
}

- (UIImageView *)arrowIcon {
    if (!_arrowIcon) {
        _arrowIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@""]];
    }
    return _arrowIcon;
}

@end
