//
//  TTInputPwdView.m
//  TuTu
//
//  Created by KevinWang on 2018/10/30.
//  Copyright © 2018年 YiZhuan. All rights reserved.
//

#import "TTInputPwdView.h"
//t
#import "XCHUDTool.h"
#import "XCTheme.h"
#import <Masonry/Masonry.h>
#import "LittleWorldCore.h"

#import "XCMacros.h" // 约束的宏定义

typedef enum : NSUInteger {
    TTInputPwdViewButtonType_Confrm = 1, //确定
    TTInputPwdViewButtonType_Cancel = 2, //取消
} TTInputPwdViewButtonType;

@interface TTInputPwdView()

@property (strong, nonatomic) RoomInfo *roomInfo;

@property (strong, nonatomic) UILabel *titleLabel;//标题标签
@property (strong, nonatomic) UITextField *passwordTextField;//密码输入框
@property (strong, nonatomic) UIView *passwordTestFieldBackground;//密码输入框背景
@property (strong, nonatomic) UIButton *cancelButton;//取消按钮（左侧）
@property (strong, nonatomic) UIButton *confirmButton;//确定按钮（右侧）

@property (strong, nonatomic) NSString *title;//标题
@property (strong, nonatomic) NSString *leftTitle;//左侧按钮标题
@property (strong, nonatomic) NSString *rightTitle;//右侧按钮标题

@end

@implementation TTInputPwdView


- (instancetype)initWithFrame:(CGRect)frame roomInfo:(RoomInfo *)roomInfo title:(NSString *)title leftAction:(NSString *)leftAction rightAction:(NSString *)rightAction{
    
    if (self = [super initWithFrame:frame]) {
        self.roomInfo = roomInfo;
        self.title = title;
        self.leftTitle = leftAction;
        self.rightTitle = rightAction;
        
        [self initView];
        [self initConstrations];
        [self addNotification];
    }
    return self;
}

- (void)addNotification {
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


#pragma mark - event response
- (void)onButtonDidClick:(UIButton *)sender {
    switch (sender.tag) {
        case TTInputPwdViewButtonType_Confrm:
        {
            if (![self.passwordTextField.text isEqualToString:self.roomInfo.roomPwd]) {
                [XCHUDTool showErrorWithMessage:@"密码错误,请重试"];
                return;
            }
            if ([_delegate respondsToSelector:@selector(inputPwdViewDidClose:closePwdViewAndNeedPresent:)]) {
                [XCHUDTool showGIFLoading];
                [_delegate inputPwdViewDidClose:self closePwdViewAndNeedPresent:self.roomInfo];
                [self.passwordTextField resignFirstResponder];
            }
        }
            break;
        case TTInputPwdViewButtonType_Cancel:
        {
            if ([_delegate respondsToSelector:@selector(inputPwdViewDidClose:)]) {
                [_delegate inputPwdViewDidClose:self];
            }
        }
            break;
        default:
            break;
    }
}

#pragma mark - private method
- (void)initView {
    
    NSAssert(self.roomInfo || self.roomInfo.roomPwd.length > 0, @"can't init \"XCEnterRoomWithPwdView\" without RoomInfo or RoomInfo's roomPwd property is nil");
    
    self.backgroundColor = UIColorFromRGB(0xffffff);
    self.layer.cornerRadius = 10.f;
    self.layer.masksToBounds = YES;
    
    [self addSubview:self.titleLabel];
    [self addSubview:self.passwordTestFieldBackground];
    [self.passwordTestFieldBackground addSubview:self.passwordTextField];
    [self addSubview:self.confirmButton];
    [self addSubview:self.cancelButton];
}

- (void)initConstrations {
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.mas_centerX);
        make.top.mas_equalTo(self.mas_top).offset(30.f);
    }];
    [self.passwordTestFieldBackground mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.titleLabel.mas_bottom).offset(15.f);
        make.centerX.mas_equalTo(self.mas_centerX);
        make.width.mas_equalTo(285.f);
        make.height.mas_equalTo(40.f);
    }];
    [self.passwordTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.passwordTestFieldBackground.mas_top);
        make.leading.mas_equalTo(self.passwordTestFieldBackground.mas_leading);
        make.trailing.mas_equalTo(self.passwordTestFieldBackground.mas_trailing);
        make.bottom.mas_equalTo(self.passwordTestFieldBackground.mas_bottom);
    }];
    [self.cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.mas_leading).offset(13.f);
        make.top.mas_equalTo(self.passwordTestFieldBackground.mas_bottom).offset(30.f);
        make.width.mas_equalTo(140.f);
        make.height.mas_equalTo(38.f);
    }];
    [self.confirmButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.mas_equalTo(self.mas_trailing).offset(-13.f);
        make.top.mas_equalTo(self.cancelButton.mas_top);
        make.width.mas_equalTo(self.cancelButton);
        make.height.mas_equalTo(self.cancelButton);
    }];
}


- (void)keyboardWillChangeFrame:(NSNotification *)notification {
    [[NSNotificationCenter defaultCenter] postNotificationName:KTTInputViewBecomeFirstResponder object:self.passwordTextField];
}

- (void)keyboardWillShow:(NSNotification*)notification {
    CGRect keyboardRect = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    CGRect rect = [self.superview convertRect:self.frame toView:[UIApplication sharedApplication].keyWindow];
    
    CGFloat top = KScreenHeight / 2 + rect.size.height / 2;
    
    CGFloat height = CGRectGetMinY(keyboardRect) - top;
    
    if (height < 0) {
        [UIView animateWithDuration:0.25 animations:^{
            self.superview.frame = CGRectMake(rect.origin.x, KScreenHeight / 2 - rect.size.height / 2 + (height - 10), rect.size.width, rect.size.height);
        }];
    }
}

- (void)keyboardWillHide:(NSNotification*)notification
{
    CGRect rect = [self.superview convertRect:self.frame toView:[UIApplication sharedApplication].keyWindow];
    
    [UIView animateWithDuration:0.25 animations:^{
        self.superview.frame = CGRectMake(rect.origin.x, KScreenHeight / 2 - rect.size.height / 2, rect.size.width, rect.size.height);
    }];
}

#pragma mark - Getter & Setter
#pragma mark - Getter

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc]init];
        _titleLabel.textColor = UIColorFromRGB(0x333333);
        _titleLabel.font = [UIFont systemFontOfSize:15.f];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.text = self.title;
    }
    return _titleLabel;
}

- (UITextField *)passwordTextField {
    if (!_passwordTextField) {
        _passwordTextField = [[UITextField alloc]init];
        _passwordTextField.placeholder = @"请输入密码";
        _passwordTextField.backgroundColor = UIColorFromRGB(0xf0f0f0);
        _passwordTextField.font = [UIFont systemFontOfSize:13.f];
        _passwordTextField.textAlignment = NSTextAlignmentCenter;
        _passwordTextField.borderStyle = UITextBorderStyleNone;
        _passwordTextField.keyboardType = UIKeyboardTypeASCIICapable;
    }
    return _passwordTextField;
}

- (UIView *)passwordTestFieldBackground {
    if (!_passwordTestFieldBackground) {
        _passwordTestFieldBackground = [[UIView alloc]init];
        
        _passwordTestFieldBackground.backgroundColor = UIColorFromRGB(0xf0f0f0);
        _passwordTestFieldBackground.layer.cornerRadius = 5.f;
        _passwordTestFieldBackground.layer.masksToBounds = YES;
    }
    return _passwordTestFieldBackground;
}

- (UIButton *)confirmButton {
    if (!_confirmButton) {
        _confirmButton = [[UIButton alloc]init];
        [_confirmButton setTitle:self.rightTitle.length > 0 ? self.rightTitle : @"确定" forState:UIControlStateNormal];
        [_confirmButton setTitleColor:UIColorFromRGB(0xffffff) forState:UIControlStateNormal];
        [_confirmButton setBackgroundColor:[XCTheme getTTMainColor]];
        _confirmButton.titleLabel.font = [UIFont systemFontOfSize:15.f];
        _confirmButton.tag = TTInputPwdViewButtonType_Confrm;
        [_confirmButton addTarget:self action:@selector(onButtonDidClick:) forControlEvents:UIControlEventTouchUpInside];
        _confirmButton.layer.cornerRadius = 19.f;
        _confirmButton.layer.masksToBounds = YES;
        
        if (projectType() == ProjectType_LookingLove) {
            [_confirmButton setTitleColor:UIColorFromRGB(0x000000) forState:UIControlStateNormal];
            _confirmButton.layer.borderWidth = 2;
            _confirmButton.layer.borderColor = UIColorFromRGB(0x000000).CGColor;
        }
    }
    return _confirmButton;
}

- (UIButton *)cancelButton {
    if (!_cancelButton) {
        _cancelButton = [[UIButton alloc]init];
        [_cancelButton setTitle:self.leftTitle.length > 0 ? self.leftTitle : @"取消" forState:UIControlStateNormal];
        [_cancelButton setTitleColor:[XCTheme getTTMainColor] forState:UIControlStateNormal];
        [_cancelButton setBackgroundColor:RGBCOLOR(254, 245, 237)];
        _cancelButton.titleLabel.font = [UIFont systemFontOfSize:15.f];
        _cancelButton.tag = TTInputPwdViewButtonType_Cancel;
        [_cancelButton addTarget:self action:@selector(onButtonDidClick:) forControlEvents:UIControlEventTouchUpInside];
        _cancelButton.layer.cornerRadius = 19.f;
        _cancelButton.layer.masksToBounds = YES;
        
        if (projectType() == ProjectType_LookingLove) {
            [_cancelButton setTitleColor:UIColorFromRGB(0x000000) forState:UIControlStateNormal];
            _cancelButton.backgroundColor = UIColorFromRGB(0xFFFFFF);
            _cancelButton.layer.borderWidth = 2;
            _cancelButton.layer.borderColor = UIColorFromRGB(0xB3B3B3).CGColor;
        }
    }
    return _cancelButton;
}


@end
