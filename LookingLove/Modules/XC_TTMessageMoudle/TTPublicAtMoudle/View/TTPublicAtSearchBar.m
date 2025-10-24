//
//  TTPublicAtSearchBar.m
//  TuTu
//
//  Created by 卫明 on 2018/11/7.
//  Copyright © 2018 YiZhuan. All rights reserved.
//

#import "TTPublicAtSearchBar.h"

//theme
#import "XCTheme.h"

//tool
#import <Masonry/Masonry.h>

//core
#import "PublicChatroomCore.h"

//client
#import "PublicChatroomCoreClient.h"

@interface TTPublicAtSearchBar()
<
    UITextFieldDelegate
>

@property (strong, nonatomic) UIView *searhBarBg;

@property (strong, nonatomic) UIImageView *searchIcon;

@property (strong, nonatomic) UITextField *searchBar;

@end

@implementation TTPublicAtSearchBar

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initView];
        [self initConstrations];
    }
    return self;
}

- (void)initView {
    self.layer.cornerRadius = 5.f;
    self.layer.masksToBounds = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(onSearchBarDidClick:)];
    [self.searhBarBg addGestureRecognizer:tap];
    [self addSubview:self.searhBarBg];
    [self.searhBarBg addSubview:self.searchBar];
    [self.searhBarBg addSubview:self.searchIcon];
}

- (void)initConstrations {
    [self.searhBarBg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.mas_leading).offset(15);
        make.trailing.mas_equalTo(self.mas_trailing).offset(-15);
        make.top.mas_equalTo(self.mas_top).offset(10);
        make.bottom.mas_equalTo(self.mas_bottom).offset(-10);
    }];
    [self.searchIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.searhBarBg.mas_leading).offset(10);
        make.width.height.mas_equalTo(14);
        make.centerY.mas_equalTo(self.mas_centerY);
    }];
    [self.searchBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.searchIcon.mas_trailing).offset(10);
        make.centerY.mas_equalTo(self.searchIcon.mas_centerY);
        make.top.mas_equalTo(self.searhBarBg.mas_top);
        make.bottom.mas_equalTo(self.searhBarBg.mas_bottom);
        make.trailing.mas_equalTo(self.searhBarBg.mas_trailing);
    }];
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if ([self.delegate respondsToSelector:@selector(onSearchBar:searhWithKey:)]) {
        [self.delegate onSearchBar:self searhWithKey:textField.text];
    }
    return YES;
}

- (void)onSearchBarDidClick:(UITapGestureRecognizer *)tap {
    if ([self.delegate respondsToSelector:@selector(onSearchBarClick:)]) {
        [self.delegate onSearchBarClick:self];
    }
}

#pragma mark - setter & getter

- (UIView *)searhBarBg {
    if (!_searhBarBg) {
        _searhBarBg = [[UIView alloc]init];
        _searhBarBg.layer.cornerRadius = 5.f;
        _searhBarBg.backgroundColor = UIColorFromRGB(0xf5f5f5);
    }
    return _searhBarBg;
}

- (UITextField *)searchBar {
    if (!_searchBar) {
        _searchBar = [[UITextField alloc]init];
        _searchBar.textColor = UIColorFromRGB(0x000000);
        _searchBar.placeholder = @"搜索成员ID/昵称";
        _searchBar.delegate = self;
        _searchBar.font = [UIFont systemFontOfSize:13.f];
        _searchBar.returnKeyType = UIReturnKeySearch;
        _searchBar.enabled = NO;
    }
    return _searchBar;
}

- (UIImageView *)searchIcon {
    if (!_searchIcon) {
        _searchIcon = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"home_search"]];
        _searchIcon.tintColor = UIColorFromRGB(0x999999);
    }
    return _searchIcon;
}

@end
