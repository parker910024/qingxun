//
//  TTPWEnterView.m
//  TuTu
//
//  Created by Macx on 2018/11/5.
//  Copyright © 2018年 YiZhuan. All rights reserved.
//

#import "TTPWEnterView.h"

//t
#import "XCTheme.h"
#import "CoreManager.h"
#import <Masonry/Masonry.h>
//core
#import "AuthCore.h"
#import "AuthCoreClient.h"
//cate
#import "UIButton+EnlargeTouchArea.h"

@interface TTPWEnterView()
@property (nonatomic, strong) UIView  *lineView;//
@property (nonatomic, strong) UILabel  *titleLabel;//
@property (nonatomic, strong) UITextField  *contentTextField;//
@property (nonatomic, strong) UIButton  *hiddenBtn;

@end


@implementation TTPWEnterView

- (void)dealloc {
    RemoveCoreClient(AuthCoreClient, self);
}

- (instancetype)init {
    if (self = [super init]) {
        [self addClient];
        [self initSubviews];
    }
    return self;
}

- (void)addClient {
    AddCoreClient(AuthCoreClient, self);
}


- (void)initSubviews {
    [self addSubview:self.titleLabel];
    [self addSubview:self.contentTextField];
    [self addSubview:self.hiddenBtn];
    [self addSubview:self.lineView];
    [self makeConstriants];
}

- (void)makeConstriants {
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self).offset(32);
        make.height.mas_equalTo(14);
        make.top.mas_equalTo(self);
    }];
    [self.contentTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.titleLabel.mas_bottom).offset(10);
        make.bottom.mas_equalTo(self);
        make.left.mas_equalTo(self.titleLabel);
        make.right.mas_equalTo(self).offset(-95);
    }];
    [self.hiddenBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self).offset(-32);
        make.centerY.mas_equalTo(self.contentTextField);
    }];
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.titleLabel);
        make.right.mas_equalTo(self).offset(-32);
        make.bottom.mas_equalTo(self);
        make.height.mas_equalTo(1);
    }];
}

#pragma mark - Client

- (void)onCutdownOpen:(NSNumber *)number
{
    if (self.btnTitle.length) {
        [self.hiddenBtn setTitle:[NSString stringWithFormat:@"%ds", number.intValue] forState:UIControlStateNormal];
        [self.hiddenBtn setEnabled:NO];
    }
    
}

- (void)onCutdownFinish
{
    //设置按钮的样式
    if (self.btnTitle.length) {
        [self.hiddenBtn setTitle:@"重新发送" forState:UIControlStateNormal];
        [self.hiddenBtn setEnabled:YES];
    }
}

#pragma mark - Event
- (void)editingDidBegin {
    self.lineView.backgroundColor = [XCTheme getTTMainColor];
}

- (void)editingDidEnd {
    self.lineView.backgroundColor = UIColorFromRGB(0xE6E6E6);
}

- (void)edingtingChange {
    if (self.limitLeght) {
        if (self.contentTextField.text.length > self.limitLeght) {
            self.contentTextField.text = [self.contentTextField.text substringToIndex:self.limitLeght];
        }
    }
}

- (void)onClickHiddenBtn:(UIButton *)btn {
    if (self.btnTitle.length) {
        !self.onClickCodeBtn?:self.onClickCodeBtn();
        return;
    }
    btn.selected = !btn.selected;
    self.contentTextField.secureTextEntry = !self.contentTextField.secureTextEntry;
}

#pragma mark - public
- (NSString *)getContentText {
    return self.contentTextField.text;
}

#pragma mark - Getter && Setter

- (void)setIsSecurity:(BOOL)isSecurity {
    _isSecurity = isSecurity;
    self.contentTextField.secureTextEntry = isSecurity;
}

- (void)setTitle:(NSString *)title {
    self.titleLabel.text = title;
}

- (void)setBtnTitle:(NSString *)btnTitle {
    _btnTitle = btnTitle;
    self.contentTextField.secureTextEntry = NO;
    [self.hiddenBtn setImage:nil forState:UIControlStateNormal];
    [self.hiddenBtn setImage:nil forState:UIControlStateSelected];
    [self.hiddenBtn setTitle:_btnTitle forState:UIControlStateNormal];
    [self.hiddenBtn setTitleColor:[XCTheme getTTMainColor] forState:UIControlStateNormal];
}

- (void)setPlaceholder:(NSString *)placeholder {
    _placeholder = placeholder;
    self.contentTextField.placeholder = _placeholder;
}

- (void)setContentString:(NSString *)contentString {
    _contentString = contentString;
    self.contentTextField.text = _contentString;
    self.contentTextField.enabled = NO;
    self.contentTextField.secureTextEntry = NO;
    self.hiddenBtn.hidden = YES;
}

- (void)setKeyboardType:(UIKeyboardType)keyboardType {
    _keyboardType = keyboardType;
    self.contentTextField.keyboardType = keyboardType;
}

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = UIColorFromRGB(0xE6E6E6);
    }
    return _lineView;
}

- (UITextField *)contentTextField {
    if (!_contentTextField) {
        _contentTextField = [[UITextField alloc] init];
        _contentTextField.secureTextEntry = YES;
        _contentTextField.font = [UIFont systemFontOfSize:13];
        _contentTextField.textColor = [XCTheme getTTMainTextColor];
        [_contentTextField addTarget:self action:@selector(editingDidBegin) forControlEvents:UIControlEventEditingDidBegin];
        [_contentTextField addTarget:self action:@selector(editingDidEnd) forControlEvents:UIControlEventEditingDidEnd];
        [_contentTextField addTarget:self action:@selector(edingtingChange) forControlEvents:UIControlEventEditingChanged];
    }
    return _contentTextField;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont systemFontOfSize:12];
        _titleLabel.textColor = UIColorFromRGB(0xcccccc);
    }
    return _titleLabel;
}

- (UIButton *)hiddenBtn {
    if (!_hiddenBtn) {
        _hiddenBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_hiddenBtn setEnlargeEdgeWithTop:20 right:20 bottom:20 left:20];
        [_hiddenBtn addTarget:self action:@selector(onClickHiddenBtn:) forControlEvents:UIControlEventTouchUpInside];
        [_hiddenBtn setImage:[UIImage imageNamed:@"setting_pw_hidden"] forState:UIControlStateNormal];
        [_hiddenBtn setImage:[UIImage imageNamed:@"setting_pw_show"] forState:UIControlStateSelected];
        _hiddenBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    }
    return _hiddenBtn;
}

@end
