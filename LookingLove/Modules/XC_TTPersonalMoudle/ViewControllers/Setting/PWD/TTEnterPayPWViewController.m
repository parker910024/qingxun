//
//  TTEnterPayPWViewController.m
//  TuTu
//
//  Created by Macx on 2018/11/8.
//  Copyright © 2018年 YiZhuan. All rights reserved.
//

#import "TTEnterPayPWViewController.h"
#import "TTEnterPaymentPWView.h"

#import <Masonry/Masonry.h>
#import <IQKeyboardManager/IQKeyboardManager.h>
#import "XCTheme.h"

@interface TTEnterPayPWViewController ()<TTEnterPaymentPWViewDelegate>
//密码
@property (nonatomic, strong) UIView  *passwordBGView;//
@property (nonatomic, strong) UITextField  *passwordTextField;//用于承载密码
@property (nonatomic, strong) TTEnterPaymentPWView  *passwordView;//
@end

@implementation TTEnterPayPWViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.passwordBGView];
    [self.view addSubview:self.passwordTextField];
    [self.passwordBGView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view);
    }];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [IQKeyboardManager sharedManager].enableAutoToolbar = NO;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [UIView animateWithDuration:0.1 animations:^{
        self.passwordBGView.alpha = 1;
    } completion:^(BOOL finished) {
        [self startInput];
    }];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [IQKeyboardManager sharedManager].enableAutoToolbar = YES;
    
}



#pragma mark - System Delegate

#pragma mark - Custom Delegate
#pragma mark - XCPasswordViewDelegate

- (void)closePassword {
    [self dismiss];
}

- (void)forgetPassword {
    if (self.delegate && [self.delegate respondsToSelector:@selector(gotoForgetPasswordVC)]) {
        [UIView animateWithDuration:0.1 animations:^{
            self.passwordBGView.alpha = 0;
        } completion:^(BOOL finished) {
            [self dismissViewControllerAnimated:NO completion:^{
                [self.delegate gotoForgetPasswordVC];
            }];
        }];
    }
}

#pragma mark - Core Client

#pragma mark - Event

- (void)passwordInputing:(UITextField *)textField {
    if (textField.text.length > 6) {
        textField.text = [textField.text substringToIndex:6];
        return;
    }
    self.passwordView.inputLength = textField.text.length;
    
    if (textField.text.length == 6) {
        [self verificationPassword];
    }
}
#pragma mark - Public Method

#pragma mark - Priavte Method
- (void)startInput {
    [IQKeyboardManager sharedManager].enableAutoToolbar = NO;
    self.passwordTextField.inputAccessoryView = self.passwordView;
    [self.passwordTextField becomeFirstResponder];
}

- (void)verificationPassword {
    if (self.delegate && [self.delegate respondsToSelector:@selector(inputPasswordEnd:)]) {
        [UIView animateWithDuration:0.1 animations:^{
            self.passwordBGView.alpha = 0;
        } completion:^(BOOL finished) {
            [self dismissViewControllerAnimated:NO completion:^{
                [self.delegate inputPasswordEnd:self.passwordTextField.text];
            }];
        }];
    }
}

- (void)dismiss {
    [UIView animateWithDuration:0.1 animations:^{
        self.passwordBGView.alpha = 0;
    } completion:^(BOOL finished) {
        [self dismissViewControllerAnimated:NO completion:^{
            
        }];
    }];
}

#pragma makr - Getters and Setters


- (TTEnterPaymentPWView *)passwordView {
    if (!_passwordView) {
        _passwordView = [[TTEnterPaymentPWView alloc] init];
        _passwordView.delegate = self;
    }
    return _passwordView;
}

- (UITextField *)passwordTextField {
    if (!_passwordTextField) {
        _passwordTextField = [[UITextField alloc] init];
        _passwordTextField.keyboardType = UIKeyboardTypeNumberPad;
        [_passwordTextField addTarget:self action:@selector(passwordInputing:) forControlEvents:UIControlEventEditingChanged];
    }
    return _passwordTextField;
}

- (UIView *)passwordBGView {
    if (!_passwordBGView) {
        _passwordBGView = [[UIView alloc] init];
        _passwordBGView.backgroundColor = UIColorRGBAlpha(0x000000, 0.8);
        _passwordBGView.alpha = 0;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss)];
        [_passwordBGView addGestureRecognizer:tap];
    }
    return _passwordBGView;
}


@end
