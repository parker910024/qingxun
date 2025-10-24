//
//  LLForgetPasswordViewController.h
//  XC_TTAuthMoudle
//
//  Created by apple on 2019/7/25.
//  Copyright © 2019 YiZhuan. All rights reserved.
//

#import "LLForgetPasswordViewController.h"

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

@interface LLForgetPasswordViewController ()<AuthCoreClient, UITextFieldDelegate, PurseCoreClient>

/** 标题 */
@property (nonatomic, strong) UILabel * titleLabel;
/** 手机号 */
@property (nonatomic, strong) TTAuthEditView *phoneEditView;
/** 手机号 下划线 */
@property (nonatomic, strong) UIView *phoneLineView;
/** code */
@property (nonatomic, strong) TTAuthEditView *codeEditView;
/** code 下划线 */
@property (nonatomic, strong) UIView *codeLineView;
/** 密码 */
@property (nonatomic, strong) TTAuthEditView *passwordEditView;
/** 密码  下划线 */
@property (nonatomic, strong) UIView *passwordLineView;
/** 注册*/
@property (nonatomic, strong) UIButton *registButton;
@property (nonatomic, strong) UIView *authMaskView;
@property (nonatomic, strong) UILabel *passwordtipsLabel;
@end

@implementation LLForgetPasswordViewController

#pragma mark - life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
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

/// 雅姿产品的要求，密码输入的时候关闭再次点击密码框输入的时候自动清空文本的功能。 2020年03月05日
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    if (textField == self.passwordEditView.textField) {
        if (textField.secureTextEntry) {
            [textField insertText:textField.text];
        }
    }
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
    [self.view addSubview:self.phoneLineView];
    [self.view addSubview:self.authMaskView];
    [self.view addSubview:self.codeEditView];
    [self.view addSubview:self.codeLineView];
    [self.view addSubview:self.passwordEditView];
    [self.view addSubview:self.passwordLineView];
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
        make.top.mas_equalTo(self.view).offset(21 + kNavigationHeight);
        make.left.mas_equalTo(self.view).offset(26);
    }];
    
    [self.phoneEditView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(11);
        make.right.mas_equalTo(-26);
        make.top.mas_equalTo(self.titleLabel.mas_bottom).mas_equalTo(38);
        make.height.mas_equalTo(44);
    }];
    
    [self.phoneLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.view).inset(26);
        make.height.mas_equalTo(1);
        make.top.mas_equalTo(self.phoneEditView.mas_bottom);
    }];
    
    [self.authMaskView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.height.mas_equalTo(self.phoneEditView);
        make.right.mas_equalTo(self.view).inset(140);
        make.top.mas_equalTo(self.phoneEditView.mas_bottom).offset(26);
    }];
    
    [self.codeEditView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.height.mas_equalTo(self.phoneEditView);
        make.top.mas_equalTo(self.phoneEditView.mas_bottom).offset(26);
    }];
    
    [self.codeLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.view).inset(26);
        make.height.mas_equalTo(1);
        make.top.mas_equalTo(self.codeEditView.mas_bottom);
    }];
    
    [self.passwordEditView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.height.mas_equalTo(self.phoneEditView);
        make.top.mas_equalTo(self.codeEditView.mas_bottom).offset(26);
    }];
    
    [self.passwordLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.view).inset(26);
        make.height.mas_equalTo(1);
        make.top.mas_equalTo(self.passwordEditView.mas_bottom);
    }];
    
    [self.passwordtipsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.passwordLineView);
        make.top.mas_equalTo(self.passwordEditView.mas_bottom).offset(21);
    }];
    
    [self.registButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.view).inset(38);
        make.top.mas_equalTo(self.passwordtipsLabel.mas_bottom).offset(53);
        make.height.mas_equalTo(44);
    }];
}

- (void)setRegisterButtonStatus:(BOOL)status {
    if (status) {
        [self.registButton setEnabled:YES];
        self.registButton.selected = YES;
        if (projectType() == ProjectType_Planet) {
            self.registButton.backgroundColor = XCTheme.getTTMainColor;
        } else {
            self.registButton.layer.borderColor = UIColorFromRGB(0x333333).CGColor;
        }
    }else{
        [self.registButton setEnabled:NO];
        self.registButton.selected = NO;
        if (projectType() == ProjectType_Planet) {
            self.registButton.backgroundColor = UIColorFromRGB(0xD0D0D0);
        } else {
            self.registButton.layer.borderColor = UIColorFromRGB(0xB3B3B3).CGColor;
        }
    }
}

#pragma mark - getters and setters

- (UIButton *)registButton{
    if (!_registButton) {
        _registButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _registButton.layer.masksToBounds = YES;
        _registButton.layer.cornerRadius = 22;
        [_registButton setTitle:@"重置" forState:UIControlStateNormal];
        [_registButton setTitle:@"重置" forState:UIControlStateSelected];
        _registButton.titleLabel.font = [UIFont systemFontOfSize:16];
        [_registButton addTarget:self action:@selector(onRegisterBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        if (projectType() == ProjectType_LookingLove) {
            [_registButton setTitleColor:UIColorFromRGB(0xB3B3B3) forState:UIControlStateNormal];
            [_registButton setTitleColor:UIColorFromRGB(0x333333) forState:UIControlStateSelected];
            _registButton.backgroundColor = UIColorRGBAlpha(0xffffff, 0);
            _registButton.layer.borderWidth = 2;
            _registButton.layer.borderColor = UIColorFromRGB(0xB3B3B3).CGColor;
        } else {
            _registButton.backgroundColor = UIColorFromRGB(0xD0D0D0);
            [_registButton setTitleColor:UIColorFromRGB(0xffffff) forState:UIControlStateNormal];
        }
    }
    return _registButton;
}

- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.text = @"重置密码";
        _titleLabel.font = [UIFont boldSystemFontOfSize:25];
        _titleLabel.textColor = UIColorFromRGB(0x333333);
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
        _phoneEditView.backgroundColor = UIColorFromRGB(0xffffff);
    }
    return _phoneEditView;
}

- (UIView *)phoneLineView {
    if (!_phoneLineView) {
        _phoneLineView = [[UIView alloc] init];
        _phoneLineView.backgroundColor = UIColorFromRGB(0xcccccc);
    }
    return _phoneLineView;
}

- (TTAuthEditView *)codeEditView{
    if (!_codeEditView) {
        _codeEditView = [[TTAuthEditView alloc] initWithPlaceholder:@"请输入验证码"];
        _codeEditView.type = TTAuthEditViewTypeSms;
        [_codeEditView.textField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
        _codeEditView.textField.keyboardType = UIKeyboardTypeNumberPad;
        _codeEditView.textField.delegate = self;
        [_codeEditView.authCodeButton setTitleColor:UIColorFromRGB(0xFE4C62) forState:UIControlStateNormal];
    }
    return _codeEditView;
}

- (UIView *)codeLineView {
    if (!_codeLineView) {
        _codeLineView = [[UIView alloc] init];
        _codeLineView.backgroundColor = UIColorFromRGB(0xcccccc);
    }
    return _codeLineView;
}

- (TTAuthEditView *)passwordEditView {
    if (!_passwordEditView) {
        _passwordEditView = [[TTAuthEditView alloc] initWithPlaceholder:@"请输入密码"];
        _passwordEditView.type = TTAuthEditViewTypeNormal;
        [_passwordEditView.textField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
        _passwordEditView.textField.keyboardType = UIKeyboardTypeASCIICapable;
        _passwordEditView.textField.secureTextEntry = YES;
        _passwordEditView.textField.delegate = self;
        _passwordEditView.backgroundColor = UIColorFromRGB(0xffffff);
    }
    return _passwordEditView;
}

- (UIView *)passwordLineView {
    if (!_passwordLineView) {
        _passwordLineView = [[UIView alloc] init];
        _passwordLineView.backgroundColor = UIColorFromRGB(0xcccccc);
    }
    return _passwordLineView;
}

- (UIView *)authMaskView {
    if (!_authMaskView) {
        _authMaskView = [[UIView alloc] init];
        _authMaskView.backgroundColor = UIColorFromRGB(0xffffff);
    }
    return _authMaskView;
}

- (UILabel *)passwordtipsLabel{
    if (!_passwordtipsLabel) {
        _passwordtipsLabel = [[UILabel alloc] init];
        _passwordtipsLabel.text = @"密码必须6-16字符内数字英文组合哦!";
        _passwordtipsLabel.textColor = [XCTheme getTTMainTextColor];
        _passwordtipsLabel.font = [UIFont systemFontOfSize:13];
        _passwordtipsLabel.numberOfLines = 0;
    }
    return _passwordtipsLabel;
}

@end
