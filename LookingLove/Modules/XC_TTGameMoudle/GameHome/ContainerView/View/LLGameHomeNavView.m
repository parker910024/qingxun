//
//  LLGameHomeNavView.m
//  XC_TTGameMoudle
//
//  Created by lvjunhang on 2019/7/25.
//  Copyright © 2019 YiZhuan. All rights reserved.
//

#import "LLGameHomeNavView.h"

#import <Masonry/Masonry.h>
#import "XCTheme.h"
#import "XCMacros.h"
#import "UIButton+EnlargeTouchArea.h"

@interface LLGameHomeNavView ()<UITextFieldDelegate>
@property (nonatomic, strong) UITextField *searchTextField;//搜索框
@property (nonatomic, strong) UIControl *searchActionControl;//搜索触发

@property (nonatomic, strong) UIButton *roomButton;//我的房间
@property (nonatomic, strong) UIButton *checkinButton; // 签到
@end

@implementation LLGameHomeNavView

#pragma mark - life cycle

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initView];
        [self initConstraints];
    }
    return self;
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    return NO;
}

#pragma mark - event response
- (void)didClickMyRoomButton:(UIButton *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(navViewDidClickCreateRoom:)]) {
        [self.delegate navViewDidClickCreateRoom:self];
    }
}

- (void)didClickCheckinButton:(UIButton *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(navViewDidClickCheckin:)]) {
        [self.delegate navViewDidClickCheckin:self];
    }
}

- (void)didClickSearchActionControl {
    if (self.delegate && [self.delegate respondsToSelector:@selector(navViewDidClickSearch:)]) {
        [self.delegate navViewDidClickSearch:self];
    }
}

#pragma mark - private method

- (void)initView {
    [self addSubview:self.searchTextField];
    [self addSubview:self.searchActionControl];
    [self addSubview:self.roomButton];
    [self addSubview:self.checkinButton];
}

- (void)initConstraints {
    
    [self.searchTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.right.mas_equalTo(self.checkinButton.mas_left).offset(-26);
        make.height.mas_equalTo(30);
        make.centerY.mas_equalTo(self.roomButton);
    }];
    
    [self.searchActionControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.searchTextField);
    }];
    
    [self.roomButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-20);
        make.width.height.mas_equalTo(22);
        make.top.mas_equalTo(statusbarHeight + 10);
    }];
    
    [self.checkinButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.roomButton.mas_left).offset(-20);
        make.width.height.mas_equalTo(22);
        make.centerY.mas_equalTo(self.roomButton);
    }];
}

#pragma mark - getters and setters
- (UIButton *)roomButton {
    if (!_roomButton) {
        _roomButton = [[UIButton alloc] init];
        [_roomButton setImage:[UIImage imageNamed:@"home_room_add"] forState:UIControlStateNormal];
        [_roomButton addTarget:self action:@selector(didClickMyRoomButton:) forControlEvents:UIControlEventTouchUpInside];
        
        [_roomButton setEnlargeEdgeWithTop:8 right:8 bottom:8 left:8];
    }
    return _roomButton;
}

- (UIButton *)checkinButton {
    if (!_checkinButton) {
        _checkinButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_checkinButton setImage:[UIImage imageNamed:@"nav_home_checkin"] forState:UIControlStateNormal];
        [_checkinButton addTarget:self action:@selector(didClickCheckinButton:) forControlEvents:UIControlEventTouchUpInside];
        
        [_checkinButton setEnlargeEdgeWithTop:8 right:8 bottom:8 left:8];
    }
    return _checkinButton;
}

#pragma mark - Getter & Setter
- (UITextField *)searchTextField {
    if (!_searchTextField) {
        _searchTextField = [[UITextField alloc] init];
        _searchTextField.delegate = self;
        _searchTextField.layer.cornerRadius = 15;
        _searchTextField.layer.masksToBounds = YES;
        _searchTextField.tintColor = [XCTheme getTTMainColor];
        _searchTextField.backgroundColor = UIColorFromRGB(0xffffff);
        _searchTextField.font = [UIFont systemFontOfSize:13];
        
        _searchTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"搜索昵称、ID、房间名" attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:13], NSForegroundColorAttributeName : UIColorFromRGB(0xb3b3b3)}];
        
        UIImageView *searchIcon = [[UIImageView alloc] init];
        searchIcon.image = [UIImage imageNamed:@"game_home_nav_search"];
        searchIcon.frame = CGRectMake(11, 7, 16, 16);
        searchIcon.contentMode = UIViewContentModeCenter;
        UIView *searchIconView = [[UIView alloc] init];
        [searchIconView addSubview:searchIcon];
        searchIconView.frame = CGRectMake(0, 0, 34, 30);
        
        _searchTextField.leftView = searchIconView;
        _searchTextField.leftViewMode = UITextFieldViewModeAlways;
        _searchTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _searchTextField.returnKeyType = UIReturnKeySearch;
        _searchTextField.enablesReturnKeyAutomatically = YES;
    }
    return _searchTextField;
}

- (UIControl *)searchActionControl {
    if (_searchActionControl == nil) {
        _searchActionControl = [[UIControl alloc] init];
        [_searchActionControl addTarget:self action:@selector(didClickSearchActionControl) forControlEvents:UIControlEventTouchUpInside];
    }
    return _searchActionControl;
}

@end

