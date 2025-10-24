//
//  TTFamilySearchView.m
//  TuTu
//
//  Created by gzlx on 2018/11/9.
//  Copyright © 2018年 YiZhuan. All rights reserved.
//

#import "TTFamilySearchView.h"
#import <Masonry/Masonry.h>
#import "XCTheme.h"
#import "XCMacros.h"
#import "XCKeyWordTool.h"

@interface TTFamilySearchView()<UITextFieldDelegate>
/** 背景图*/
@property (nonatomic, strong) UIView * backView;
/** 搜索图片*/
@property (nonatomic, strong) UIImageView * searchImageView;

/** 取消按钮*/
@property (nonatomic, strong) UIButton * cancleButton;
@end

@implementation TTFamilySearchView

#pragma Mark - life cycle
- (id)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self initView];
        [self initContrations];
    }
    return self;
}

#pragma mark - response
- (void)cancleButtonAction:(UIButton *)sender{
    if (self.delegate && [self.delegate respondsToSelector:@selector(touchCancleDismissSearch)]) {
        [self.delegate touchCancleDismissSearch];
    }
}

#pragma mark - UITextFildDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if ([textField.text isEqualToString:@" "]) {
        return NO;
    }
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    if (self.delegate && [self.delegate respondsToSelector:@selector(searchViewTextFileTextChange:)]) {
        [self.delegate searchViewTextFileTextChange:textField];
    }
    return YES;
}

#pragma mark - private method
- (void)initView{
    [self addSubview:self.backView];
    [self.backView addSubview:self.searchImageView];
    [self.backView addSubview:self.textFiled];
    [self addSubview:self.cancleButton];
}

- (void)initContrations{
    [self.backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self).offset(15);
        make.top.mas_equalTo(self).offset(25+ kSafeAreaTopHeight);
        make.height.mas_equalTo(30);
        make.right.mas_equalTo(self).offset(-62);
    }];
    
    [self.searchImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(16);
        make.height.mas_equalTo(16);
        make.centerY.mas_equalTo(self.backView);
        make.left.mas_equalTo(self.backView).offset(11);
    }];
    
    [self.textFiled mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.right.mas_equalTo(self.backView);
        make.left.mas_equalTo(self.searchImageView.mas_right).offset(4);
    }];
    
    [self.cancleButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.backView.mas_right);
        make.height.mas_equalTo(self.backView);
        make.right.mas_equalTo(self);
        make.centerY.mas_equalTo(self.backView);
    }];
}

#pragma mark - setters and getters
- (UIView *)backView{
    if (!_backView) {
        _backView = [[UIView alloc] init];
        _backView.layer.masksToBounds = YES;
        _backView.layer.cornerRadius = 15;
        _backView.backgroundColor = UIColorFromRGB(0xF2F2F5);
    }
    return _backView;
}

- (UIImageView *)searchImageView{
    if (!_searchImageView) {
        _searchImageView = [[UIImageView alloc] init];
        _searchImageView.image = [UIImage imageNamed:@"family_mon_search"];
    }
    return _searchImageView;
}

- (UITextField *)textFiled{
    if (!_textFiled) {
        _textFiled = [[UITextField alloc] init];
        _textFiled.placeholder = [NSString stringWithFormat:@"搜索昵称/%@ID", [XCKeyWordTool sharedInstance].myAppName];
        _textFiled.textColor = [XCTheme getTTMainTextColor];
        _textFiled.delegate = self;
        _textFiled.font = [UIFont systemFontOfSize:15];
        _textFiled.returnKeyType = UIReturnKeySearch;
        _textFiled.clearButtonMode = UITextFieldViewModeWhileEditing;
        _textFiled.returnKeyType = UIReturnKeySearch;
        _textFiled.enablesReturnKeyAutomatically = YES;
    }
    return _textFiled;
}

- (UIButton *)cancleButton{
    if (!_cancleButton) {
        _cancleButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_cancleButton setTitle:@"取消" forState:UIControlStateNormal];
        [_cancleButton setTitle:@"取消" forState:UIControlStateSelected];
        [_cancleButton setTitleColor:[XCTheme getTTMainColor] forState:UIControlStateNormal];
        [_cancleButton setTitleColor:[XCTheme getTTMainColor] forState:UIControlStateSelected];
        [_cancleButton.titleLabel setFont:[UIFont systemFontOfSize:15]];
        [_cancleButton addTarget:self action:@selector(cancleButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancleButton;
}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
