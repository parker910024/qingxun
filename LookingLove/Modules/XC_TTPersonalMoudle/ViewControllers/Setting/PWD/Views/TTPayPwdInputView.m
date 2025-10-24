//
//  TTPayPwdInputView.m
//  XC_TTPersonalMoudle
//
//  Created by lvjunhang on 2020/3/18.
//  Copyright © 2020 WUJIE INTERACTIVE. All rights reserved.
//

#import "TTPayPwdInputView.h"

#import "XCTheme.h"
#import "UIButton+EnlargeTouchArea.h"
#import "XCKeyWordTool.h"

#import <Masonry/Masonry.h>

@interface TTPayPwdInputView()

@property (nonatomic, strong) UIView *lineView;//分割线
@property (nonatomic, strong) UITextField *contentTextField;//输入框
@property (nonatomic, strong) UIButton *statusButton;//状态按钮（隐藏显示密码、获取验证码、倒计时）

@property (nonatomic, assign) BOOL isSecurity;//是否密文显示
@property (nonatomic, assign) int contentLimit;//内容长度限制
@property (nonatomic, assign) UIKeyboardType keyboardType;//键盘类型
@property (nonatomic, strong) NSString *placeholder;//提示文本

@end


@implementation TTPayPwdInputView

- (instancetype)init {
    if (self = [super init]) {
        [self initSubviews];
    }
    return self;
}

- (void)initSubviews {
    [self addSubview:self.contentTextField];
    [self addSubview:self.statusButton];
    [self addSubview:self.lineView];
    [self makeConstriants];
}

- (void)makeConstriants {
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self).inset(25);
        make.bottom.mas_equalTo(0);
        make.height.mas_equalTo(0.5);
    }];
    
    [self.statusButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.lineView);
        make.bottom.mas_equalTo(-10);
    }];
    
    [self.contentTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.statusButton);
        make.left.mas_equalTo(self.lineView);
        make.right.mas_equalTo(self.statusButton.mas_left).offset(-10);
        make.height.mas_equalTo(44);
    }];
}

#pragma mark - Event
- (void)editingDidBegin {
    self.lineView.backgroundColor = UIColorFromRGB(0xCCCCCC);
}

- (void)editingDidEnd {
    self.lineView.backgroundColor = UIColorFromRGB(0xCCCCCC);
}

- (void)edingtingChange {
    if (self.contentLimit && self.contentTextField.text.length > self.contentLimit) {
        self.contentTextField.text = [self.contentTextField.text substringToIndex:self.contentLimit];
    }
}

- (void)onClickStatusButton:(UIButton *)sender {
    if (self.type == TTPayPwdInputViewTypeVerification) {
        !self.fetchVerificationHandler ?: self.fetchVerificationHandler();
        return;
    }
    
    sender.selected = !sender.selected;
    self.isSecurity = !sender.selected;
}

#pragma mark - Public
- (NSString *)contentText {
    return self.contentTextField.text;
}

/// 验证码倒计时更新
/// @param seconds 秒数
- (void)verificationCountdownUpdate:(NSInteger)seconds {
    if (self.type == TTPayPwdInputViewTypeVerification) {
        [self.statusButton setTitle:[NSString stringWithFormat:@"%ld后重试", (long)seconds] forState:UIControlStateNormal];
        [self.statusButton setEnabled:NO];
        [self.statusButton setTitleColor:UIColorFromRGB(0xB2B2B2) forState:UIControlStateNormal];
    }
}

/// 验证码倒计时结束
- (void)verificationCountdownFinish {
    if (self.type == TTPayPwdInputViewTypeVerification) {
        [self.statusButton setTitle:@"重新发送" forState:UIControlStateNormal];
        [self.statusButton setEnabled:YES];
        [self.statusButton setTitleColor:UIColorFromRGB(0xFE4C62) forState:UIControlStateNormal];
    }
}

#pragma mark - Private
/// 支付
- (NSString *)payKeyword {
    NSString *const pay = [XCKeyWordTool sharedInstance].xcz;
    return pay;
}

#pragma mark - Getter && Setter
- (void)setType:(TTPayPwdInputViewType)type {
    _type = type;
    
    switch (type) {
        case TTPayPwdInputViewTypePwd:
        {
            self.contentLimit = 6;
            self.isSecurity = YES;
            self.keyboardType = UIKeyboardTypeNumberPad;
            self.placeholder = [NSString stringWithFormat:@"设置%@密码", [self payKeyword]];
        }
            break;
        case TTPayPwdInputViewTypeRepeatPwd:
        {
            self.contentLimit = 6;
            self.isSecurity = YES;
            self.keyboardType = UIKeyboardTypeNumberPad;
            self.placeholder = [NSString stringWithFormat:@"再次输入%@密码", [self payKeyword]];
        }
            break;
        case TTPayPwdInputViewTypeVerification:
        {
            self.contentLimit = 5;
            self.isSecurity = NO;
            self.keyboardType = UIKeyboardTypeNumberPad;
            self.placeholder = @"请输入验证码";

            [self.statusButton setTitle:@"获取验证码" forState:UIControlStateNormal];
            [self.statusButton setTitleColor:UIColorFromRGB(0xFE4C62) forState:UIControlStateNormal];
            [self.statusButton setImage:nil forState:UIControlStateNormal];
            [self.statusButton setImage:nil forState:UIControlStateSelected];
        }
            break;
        default:
            break;
    }
}

- (void)setIsSecurity:(BOOL)isSecurity {
    _isSecurity = isSecurity;
    
    self.statusButton.selected = !isSecurity;
    self.contentTextField.secureTextEntry = isSecurity;
}

- (void)setPlaceholder:(NSString *)placeholder {
    _placeholder = placeholder;
    
    self.contentTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:placeholder attributes:@{NSFontAttributeName : self.contentTextField.font, NSForegroundColorAttributeName : UIColorFromRGB(0xb3b3b3)}];
}

- (void)setKeyboardType:(UIKeyboardType)keyboardType {
    _keyboardType = keyboardType;
    self.contentTextField.keyboardType = keyboardType;
}

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = UIColorFromRGB(0xCCCCCC);
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

- (UIButton *)statusButton {
    if (!_statusButton) {
        _statusButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_statusButton addTarget:self action:@selector(onClickStatusButton:) forControlEvents:UIControlEventTouchUpInside];
        [_statusButton setImage:[UIImage imageNamed:@"setting_pwd_pay_hidden"] forState:UIControlStateNormal];
        [_statusButton setImage:[UIImage imageNamed:@"setting_pwd_pay_show"] forState:UIControlStateSelected];
        _statusButton.titleLabel.font = [UIFont systemFontOfSize:15];
        [_statusButton setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
        [_statusButton setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];

        [_statusButton setEnlargeEdgeWithTop:8 right:8 bottom:8 left:8];
    }
    return _statusButton;
}

@end
