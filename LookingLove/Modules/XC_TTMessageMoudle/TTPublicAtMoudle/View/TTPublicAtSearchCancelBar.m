//
//  TTPublicAtSearchCancelBar.m
//  TuTu
//
//  Created by 卫明 on 2018/11/7.
//  Copyright © 2018 YiZhuan. All rights reserved.
//

#import "TTPublicAtSearchCancelBar.h"

//theme
#import "XCTheme.h"

//tool
#import <Masonry/Masonry.h>

@interface TTPublicAtSearchCancelBar ()
<
    UITextFieldDelegate
>
/**
 搜索框背景
 */
@property (strong, nonatomic) UIView *searchBarBg;

/**
 搜索icon
 */
@property (strong, nonatomic) UIImageView *searchIcon;

/**
 取消按钮
 */
@property (strong, nonatomic) UIButton *cancelButton;

@end

@implementation TTPublicAtSearchCancelBar

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initView];
        [self initConstrations];
    }
    return self;
}

- (void)initView {
    [self addSubview:self.searchBarBg];
    [self.searchBarBg addSubview:self.searchIcon];
    [self.searchBarBg addSubview:self.searchField];
    [self addSubview:self.cancelButton];
}

- (void)initConstrations {
    [self.searchBarBg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.mas_leading).offset(15);
        make.trailing.mas_equalTo(self.cancelButton.mas_leading).offset(-20);
        make.height.mas_equalTo(30);
        make.top.mas_equalTo(self.mas_top).offset(5);
    }];
    [self.searchIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.searchBarBg.mas_leading).offset(10);
        make.width.height.mas_equalTo(14);
        make.centerY.mas_equalTo(self.mas_centerY);
    }];
    [self.searchField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.searchIcon.mas_trailing).offset(5);
        make.top.mas_equalTo(self.mas_top);
        make.bottom.mas_equalTo(self.mas_bottom);
        make.trailing.mas_equalTo(self.mas_trailing).offset(-5);
    }];
    [self.cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.searchBarBg.mas_trailing).offset(20);
        make.trailing.mas_equalTo(self.mas_trailing).offset(-15);
        make.centerY.mas_equalTo(self.mas_centerY);
        make.height.mas_equalTo(20);
    }];
    
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if ([self.delegate respondsToSelector:@selector(onSearchCancelBar:searhWithKey:)]) {
        [self.delegate onSearchCancelBar:self searhWithKey:textField.text];
    }
    return YES;
}

#pragma mark - private method

- (void)onCancelButtonClick:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(onSearchCancelDidClickBar:)]) {
        [self.delegate onSearchCancelDidClickBar:self];
    }
}

#pragma mark - getter & setter

- (UIView *)searchBarBg {
    if (!_searchBarBg) {
        _searchBarBg = [[UIView alloc]init];
        _searchBarBg.layer.masksToBounds = YES;
        _searchBarBg.layer.cornerRadius = 15.f;
        _searchBarBg.backgroundColor = UIColorFromRGB(0xF2F2F5);
    }
    return _searchBarBg;
}

- (UIImageView *)searchIcon {
    if (!_searchIcon) {
        _searchIcon = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"home_search"]];
    }
    return _searchIcon;
}

- (UITextField *)searchField {
    if (!_searchField) {
        _searchField = [[UITextField alloc]init];
        _searchField.textColor = UIColorFromRGB(0x000000);
        _searchField.placeholder = @"搜索成员ID/昵称";
        _searchField.delegate = self;
        _searchField.font = [UIFont systemFontOfSize:13.f];
        _searchField.returnKeyType = UIReturnKeySearch;
    }
    return _searchField;
}

- (UIButton *)cancelButton {
    if (!_cancelButton) {
        _cancelButton = [[UIButton alloc]init];
        [_cancelButton setTitle:@"取消" forState:UIControlStateNormal];
        [_cancelButton setTitleColor:[XCTheme getTTMainColor] forState:UIControlStateNormal];
        _cancelButton.titleLabel.font = [UIFont systemFontOfSize:14.f];
        [_cancelButton addTarget:self action:@selector(onCancelButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancelButton;
}

@end
