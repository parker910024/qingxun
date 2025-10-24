//
//  TTForgetPasswordViewController.m
//  TuTu
//
//  Created by Macx on 2018/10/29.
//  Copyright © 2018 YiZhuan. All rights reserved.
//

#import "TTForgetPasswordViewController.h"

#import "TTAuthEditView.h"

#import "UserCore.h"
#import "AuthCore.h"
#import "AuthCoreClient.h"
#import "PurseCore.h"
#import "PurseCoreClient.h"
#import "NSString+Auth.h"

#import "XCTheme.h"
#import "XCHUDTool.h"
#import <Masonry/Masonry.h>

@interface TTForgetPasswordViewController ()<AuthCoreClient, UITextFieldDelegate, PurseCoreClient>
/** 标题*/
@property (nonatomic, strong) UILabel * titleLabel;
/** 手机号*/
@property (nonatomic, strong) TTAuthEditView *phoneEditView;
/** code*/
@property (nonatomic, strong) TTAuthEditView *codeEditView;
/** 密码*/
@property (nonatomic, strong) TTAuthEditView *passwordEditView;
/** 注册*/
@property (nonatomic, strong) UIButton *registButton;
@property (nonatomic, strong) UIView *authMaskView;
@property (nonatomic, strong) UILabel *passwordtipsLabel;
@end

@implementation TTForgetPasswordViewController

#pragma mark - life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"重置密码";
    [self initView];
    [self initConstrations];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.codeEditView.authCodeButton.enabled = YES;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [GetCore(AuthCore)stopCountDown];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    RemoveCoreClientAll(self);
}

#pragma mark - public methods

#pragma mark - UITextFieldDelegate
- (void)textFieldDidChange :(UITextField *)theTextField {
    NSUInteger subStr = 0;
    if (theTextField == self.phoneEditView.textField) {
        subStr = 11;
    } else if (theTextField == self.codeEditView.textField) {
        subStr = 5;
    } else if (theTextField == self.passwordEditView.textField) {
        subStr = 16;
    }
    
    if (theTextField.text.length >subStr) {
        theTextField.text = [theTextField.text substringToIndex:subStr];
    }
    
    if (self.phoneEditView.textField.text.length == 11 && self.codeEditView.textField.text.length == 5 && self.passwordEditView.textField.text.length >= 6) {
        [self setRegisterButtonStatus:YES];
    } else {
        [self setRegisterButtonStatus:NO];
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSString *text = [textField.text stringByReplacingCharactersInRange:range withString:string];
    if (textField == self.phoneEditView.textField || textField == self.codeEditView.textField) {
        NSString *regex =@"[0-9]*";
        NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
        if ([pred evaluateWithObject:string]) {
            return YES;
        }
        return NO;
    }else if (textField == self.passwordEditView.textField){
        if (text.length > 16) {
            return NO;
        }
        if ([string isEqualToString:@" "]) {
            return NO;
        }
    }
    return YES;
}

#pragma mark - [自定义控件的Protocol] //注意要把名字改掉，这个MARK只做功能划分，不是一个真正的MARK，每个不一样的Protocol，需要一个新的MARK”

#pragma mark - PurseCoreClient
- (void)getSmsSuccessWithMessage:(NSString *)message{
    [GetCore(AuthCore) openCountdown];
    [XCHUDTool showSuccessWithMessage:@"发送验证成功" inView:self.view];
}

- (void)getSmsFaildWithMessage:(NSString *)message{
    
}

#pragma mark - AuthCoreClient
- (void)onResetPwdSuccess {
    [XCHUDTool hideHUDInView:self.view];
    [XCHUDTool showSuccessWithMessage:@"重置密码成功"];
    if(self.isSetting && self.navigationController.viewControllers.count > 2){
        [self.navigationController popToViewController:self.navigationController.viewControllers[2] animated:YES];
    }else {
        [self.navigationController popViewControllerAnimated:YES];
    }}

- (void)onResetPwdFailth:(NSString *)errorMsg {
    [XCHUDTool showErrorWithMessage:errorMsg inView:self.view];
}

- (void)onRequestSmsCodeSuccess:(NSNumber *)type{
    
}

- (void)onRequestSmsCodeFailth:(NSString *)errorMsg{
    
}

- (void)onCutdownOpen:(NSNumber *)number{
    [self.codeEditView.authCodeButton setTitle:[NSString stringWithFormat:@"%ds后重试", number.intValue] forState:UIControlStateNormal];
    [self.codeEditView.authCodeButton setEnabled:NO];
}

- (void)onCutdownFinish{
    //设置按钮的样式
    [self.codeEditView.authCodeButton setTitle:@"重新发送" forState:UIControlStateNormal];
    [self.codeEditView.authCodeButton setEnabled:YES];
}

#pragma mark - event response

- (void)onRegisterBtnClicked:(UIButton *)sender {
    NSString *phone = self.phoneEditView.textField.text;
    NSString *password = self.passwordEditView.textField.text;
    NSString *smsCode = self.codeEditView.textField.text;
    
    if (![password isLengthInRange:6 max:16]) {
        [XCHUDTool showErrorWithMessage:@"登录密码长度必须6-16位" inView:self.view];
        return;
    }
    
    if (![password isPasswordStrong]) {
        [XCHUDTool showErrorWithMessage:@"密码必须使用6-16个字符内的数字和英文字母组合" inView:self.view];
        return;
    }
    
    [self keyboardHide:nil];
    [GetCore(AuthCore) requestResetPwd:phone newPwd:password smsCode:smsCode];
    [XCHUDTool showGIFLoadingInView:self.view];
}

- (void)keyboardHide:(UITapGestureRecognizer*)tap {
    [self.phoneEditView.textField resignFirstResponder];
    [self.passwordEditView.textField resignFirstResponder];
    [self.codeEditView.textField resignFirstResponder];
}

#pragma mark - private method

- (void)initView {
    
    [self.view addSubview:self.titleLabel];
    [self.view addSubview:self.phoneEditView];
    [self.view addSubview:self.authMaskView];
    [self.view addSubview:self.codeEditView];
    [self.view addSubview:self.passwordEditView];
    [self.view addSubview:self.passwordtipsLabel];
    [self.view addSubview:self.registButton];
    
    AddCoreClient(AuthCoreClient, self);
    AddCoreClient(PurseCoreClient, self);
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(keyboardHide:)];
    //设置成NO表示当前控件响应后会传播到其他控件上，默认为YES。
    tapGestureRecognizer.cancelsTouchesInView = NO;
    //将触摸事件添加到当前view
    [self.view addGestureRecognizer:tapGestureRecognizer];
    
    if (self.isSetting) {
        UserInfo *info = [GetCore(UserCore) getUserInfoInDB:GetCore(AuthCore).getUid.longLongValue];
        if (info.phone.length) {
            self.phoneEditView.textField.enabled = NO;
            self.phoneEditView.textField.text = info.phone;
        }
    }
    
    @KWeakify(self);
    self.codeEditView.rightButtonDidClickBlcok = ^(UIButton *button) {
        @KStrongify(self);
        if (self.phoneEditView.textField.text.length != 11) {
            [XCHUDTool showErrorWithMessage:@"请输入正确的手机号" inView:self.view];
            return;
        }
//        [GetCore(PurseCore) getCodeWithPhoneNum:self.phoneEditView.textField.text type:3];
        [GetCore(PurseCore) getCodeWithPhoneNum:self.phoneEditView.textField.text type:3];
//        [GetCore(AuthCore) requestResetSmsCode:self.phoneEditView.textField.text];
    };
}

- (void)initConstrations {
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view).offset(75 + statusbarHeight);
        make.left.mas_equalTo(self.view).offset(35);
    }];
    
    [self.phoneEditView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.view).inset(48);
        make.top.mas_equalTo(self.titleLabel.mas_bottom).offset(35);
        make.height.mas_equalTo(44);
    }];
    
    [self.authMaskView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.height.mas_equalTo(self.phoneEditView);
        make.right.mas_equalTo(self.view).inset(140);
        make.top.mas_equalTo(self.phoneEditView.mas_bottom).offset(20);
    }];
    
    [self.codeEditView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.height.mas_equalTo(self.phoneEditView);
        make.top.mas_equalTo(self.phoneEditView.mas_bottom).offset(20);
    }];
    
    [self.passwordEditView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.height.mas_equalTo(self.phoneEditView);
        make.top.mas_equalTo(self.codeEditView.mas_bottom).offset(20);
    }];
    
    [self.passwordtipsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.passwordEditView);
        make.top.mas_equalTo(self.passwordEditView.mas_bottom).offset(10);
    }];
    
    [self.registButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.passwordtipsLabel);
        make.top.mas_equalTo(self.passwordtipsLabel.mas_bottom).offset(36);
        make.height.mas_equalTo(43);
    }];
}

- (void)setRegisterButtonStatus:(BOOL)status{
    if (status) {
        [self.registButton setEnabled:YES];
        [self.registButton setBackgroundColor:[XCTheme getTTMainColor]];
    } else {
        [self.registButton setEnabled:NO];
        [self.registButton setBackgroundColor:UIColorFromRGB(0xdbdbdb)];
    }
}

#pragma mark - getters and setters

- (UIButton *)registButton{
    if (!_registButton) {
        _registButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _registButton.layer.masksToBounds = YES;
        _registButton.layer.cornerRadius = 22;
        [_registButton setBackgroundColor:UIColorFromRGB(0xdbdbdb)];
        [_registButton setTitle:@"重置" forState:UIControlStateNormal];
        [_registButton setTitle:@"重置" forState:UIControlStateSelected];
        _registButton.titleLabel.font = [UIFont systemFontOfSize:15];
        [_registButton addTarget:self action:@selector(onRegisterBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [_registButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_registButton setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    }
    return _registButton;
}

- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont systemFontOfSize:22];
        _titleLabel.text = @"重置密码";
        _titleLabel.hidden = YES;
        _titleLabel.textColor = [XCTheme getTTMainTextColor];
    }
    return _titleLabel;
}

- (TTAuthEditView *)phoneEditView{
    if (!_phoneEditView) {
        _phoneEditView = [[TTAuthEditView alloc] initWithPlaceholder:@"请输入手机号"];
        _phoneEditView.type = TTAuthEditViewTypeNormal;
        [_phoneEditView.textField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
        _phoneEditView.textField.keyboardType = UIKeyboardTypeNumberPad;
        _phoneEditView.textField.delegate = self;
        _phoneEditView.backgroundColor = UIColorFromRGB(0xF0F0F0);
        _phoneEditView.layer.cornerRadius = 22.f;
    }
    return _phoneEditView;
}

- (TTAuthEditView *)codeEditView{
    if (!_codeEditView) {
        _codeEditView = [[TTAuthEditView alloc] initWithPlaceholder:@"请输入验证码"];
        _codeEditView.type = TTAuthEditViewTypeSms;
        [_codeEditView.textField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
        _codeEditView.textField.keyboardType = UIKeyboardTypeNumberPad;
        _codeEditView.textField.delegate = self;
    }
    return _codeEditView;
}

- (TTAuthEditView *)passwordEditView{
    if (!_passwordEditView) {
        _passwordEditView = [[TTAuthEditView alloc] initWithPlaceholder:@"请输入密码"];
        _passwordEditView.type = TTAuthEditViewTypeNormal;
        [_passwordEditView.textField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
        _passwordEditView.textField.secureTextEntry = YES;
        _passwordEditView.textField.keyboardType = UIKeyboardTypeASCIICapable;
        _passwordEditView.textField.delegate = self;
        _passwordEditView.backgroundColor = UIColorFromRGB(0xF0F0F0);
        _passwordEditView.layer.cornerRadius = 22.f;
    }
    return _passwordEditView;
}

- (UIView *)authMaskView {
    if (!_authMaskView) {
        _authMaskView = [[UIView alloc] init];
        _authMaskView.backgroundColor = UIColorFromRGB(0xF0F0F0);
        _authMaskView.layer.cornerRadius = 22.f;
    }
    return _authMaskView;
}

- (UILabel *)passwordtipsLabel{
    if (!_passwordtipsLabel) {
        _passwordtipsLabel = [[UILabel alloc] init];
        _passwordtipsLabel.text = @"密码必须使用6-16个字符内的数字和英文字母组合哦!";
        _passwordtipsLabel.textColor = [XCTheme getTTDeepGrayTextColor];
        _passwordtipsLabel.font = [UIFont systemFontOfSize:11];
        _passwordtipsLabel.textAlignment = NSTextAlignmentCenter;
        _passwordtipsLabel.numberOfLines = 0;
    }
    return _passwordtipsLabel;
}

@end
