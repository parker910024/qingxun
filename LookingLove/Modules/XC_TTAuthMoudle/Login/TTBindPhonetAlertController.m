//
//  TTBindPhonetAlertController.m
//  XC_TTAuthMoudle
//
//  Created by JarvisZeng on 2019/4/16.
//  Copyright © 2019 YiZhuan. All rights reserved.
//

#import "TTBindPhonetAlertController.h"

#import "TTUserProtocolView.h"
#import "TTAuthEditView.h"

// core
#import "AuthCore.h"
#import "AuthCoreClient.h"
#import "PurseCore.h"
#import "PurseCoreClient.h"
#import "NSString+Auth.h"

#import "XCTheme.h"
#import <Masonry/Masonry.h>
#import "XCHUDTool.h"
#import "TTBindSuccessView.h"
#import "XCHtmlUrl.h"

@interface TTBindPhonetAlertController ()<AuthCoreClient, TTUserProtocolViewDelegate, UITextFieldDelegate, PurseCoreClient>
/** 标题 */
@property (nonatomic, strong) UILabel * titleLabel;
/** 手机号 */
@property (nonatomic, strong) TTAuthEditView *phoneEditView;
/** code */
@property (nonatomic, strong) TTAuthEditView *codeEditView;
/** 注册 */
@property (nonatomic, strong) UIButton *registButton;
@property (nonatomic, strong) UIView *authMaskView;
@property (nonatomic, strong) UILabel *passwordtipsLabel;
@property (nonatomic, strong) UIButton *skipBtn;
@property (nonatomic, assign) BOOL isBindPhoneSuccess; // 主要用于埋点
@end

@implementation TTBindPhonetAlertController

#pragma mark - life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"绑定手机号码";
    [self initView];
    [self initConstrations];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.codeEditView.authCodeButton.enabled = YES;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [GetCore(AuthCore) stopCountDown];
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
    if (!self.isBindPhoneSuccess) {
        [[BaiduMobStat defaultStat] eventEnd:@"binding_phone_skip" eventLabel:@"跳过绑定手机"];
    }
    if (self.dismissBlcok) {
        self.dismissBlcok();
    }
    RemoveCoreClientAll(self);
}

#pragma mark - public methods

#pragma mark - UITextFieldDelegate
- (void)textFieldDidChange :(UITextField *)theTextField{
    NSUInteger subStr = 0;
    if (theTextField == self.phoneEditView.textField) {
        subStr = 11;
    } else if (theTextField == self.codeEditView.textField) {
        subStr = 5;
    }
    
    if (theTextField.text.length >subStr) {
        theTextField.text = [theTextField.text substringToIndex:subStr];
    }
    
    if (self.phoneEditView.textField.text.length == 11 && self.codeEditView.textField.text.length == 5) {
        [self setRegisterButtonStatus:YES];
    } else {
        [self setRegisterButtonStatus:NO];
    }
}

#pragma mark - TTUserProtocolViewDelegate
- (void)onSelectBtnClicked:(BOOL)select
{
    [self updateRegisterButtonState];
}

#pragma mark - PurseCoreClient
- (void)getSmsSuccessWithMessage:(NSString *)message{
    [GetCore(AuthCore) openCountdown];
    [XCHUDTool showSuccessWithMessage:@"发送验证成功" inView:self.view];
}

- (void)getSmsFaildWithMessage:(NSString *)message{
    
}

#pragma mark - AuthCoreClient
- (void)bindingPhoneNumberSuccess {
    self.isBindPhoneSuccess = YES;
    [XCHUDTool hideHUDInView:self.view];
    @weakify(self);
    [TTBindSuccessView showBindSuccessViewWithHandler:^{
        @strongify(self);
        [self dismissController];
    }];
}

- (void)bindingPhoneNumberFailth:(NSString *)message {
    [XCHUDTool showErrorWithMessage:message inView:self.view];
}

- (void)onRequestSmsCodeSuccess:(NSNumber *)type {
}

- (void)onRequestSmsCodeFailth:(NSString *)errorMsg {
    [XCHUDTool showErrorWithMessage:errorMsg inView:self.view];
    [self onCutdownFinish];
}

- (void)onCutdownOpen:(NSNumber *)number{
    [self.codeEditView.authCodeButton setTitle:[NSString stringWithFormat:@"%ds后重试", number.intValue] forState:UIControlStateDisabled];
    self.codeEditView.authCodeButton.enabled = NO;
}

- (void)onCutdownFinish{
    //设置按钮的样式
    [self.codeEditView.authCodeButton setTitle:@"重新发送" forState:UIControlStateNormal];
    self.codeEditView.authCodeButton.enabled = YES;
}

#pragma mark - event response

- (void)onRegisterBtnClicked:(UIButton *)sender {
    NSString *phone = self.phoneEditView.textField.text;
    NSString *smsCode = self.codeEditView.textField.text;
    [self keyboardHide:nil];
    [GetCore(PurseCore) bindingPhoneNum:phone verifyCode:smsCode];
    [XCHUDTool showGIFLoadingInView:self.view];
}

- (void)keyboardHide:(UITapGestureRecognizer*)tap{
    [self.phoneEditView.textField resignFirstResponder];
    [self.codeEditView.textField resignFirstResponder];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (textField == self.phoneEditView.textField || textField == self.codeEditView.textField) {
        NSString *regex =@"[0-9]*";
        NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
        if ([pred evaluateWithObject:string]) {
            return YES;
        }
        return NO;
    }
    return YES;
}

- (void)onSkipBtnClicked:(UIButton *)sender {
    [self dismissController];
}

#pragma mark - private method

- (void)dismissController {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)initView {
    [self.view addSubview:self.titleLabel];
    [self.view addSubview:self.phoneEditView];
    [self.view addSubview:self.authMaskView];
    [self.view addSubview:self.codeEditView];
    [self.view addSubview:self.passwordtipsLabel];
    [self.view addSubview:self.registButton];
    [self.view addSubview:self.skipBtn];
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(keyboardHide:)];
    //设置成NO表示当前控件响应后会传播到其他控件上，默认为YES。
    tapGestureRecognizer.cancelsTouchesInView = NO;
    //将触摸事件添加到当前view
    [self.view addGestureRecognizer:tapGestureRecognizer];
    
    AddCoreClient(AuthCoreClient, self);
    AddCoreClient(PurseCoreClient, self);
    
    @KWeakify(self);
    self.codeEditView.rightButtonDidClickBlcok = ^(UIButton *button) {
        @KStrongify(self);
        if (self.phoneEditView.textField.text.length != 11) {
            [XCHUDTool showErrorWithMessage:@"请输入正确的手机号" inView:self.view];
            return;
        }
        
        //        [GetCore(PurseCore) getCodeWithMobileNum:self.phoneEditView.textField.text type:1];
        [GetCore(PurseCore) getCodeWithPhoneNum:self.phoneEditView.textField.text type:4];
        //        [GetCore(AuthCore) requestRegistSmsCode:self.phoneEditView.textField.text];
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
    
    [self.registButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.phoneEditView);
        make.top.mas_equalTo(self.codeEditView.mas_bottom).offset(20);
        make.height.mas_equalTo(44);
    }];
    
    [self.skipBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.registButton);
        make.bottom.mas_equalTo(self.view).offset(-50);
        make.height.mas_equalTo(44);
    }];
    
}

- (void)setRegisterButtonStatus:(BOOL)status{
    if (status) {
        [self.registButton setEnabled:YES];
        [self.registButton setBackgroundColor:[XCTheme getTTMainColor]];
    }else{
        [self.registButton setEnabled:NO];
        [self.registButton setBackgroundColor:UIColorFromRGB(0xdbdbdb)];
    }
}

- (void)updateRegisterButtonState
{
    if (self.phoneEditView.textField.text.length == 11 && self.codeEditView.textField.text.length == 5) {
        [self setRegisterButtonStatus:YES];
    } else {
        [self setRegisterButtonStatus:NO];
    }
}

#pragma mark - getters and setters
- (UIButton *)registButton{
    if (!_registButton) {
        _registButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _registButton.layer.masksToBounds = YES;
        _registButton.layer.cornerRadius = 22;
        [_registButton setBackgroundColor:UIColorFromRGB(0xdbdbdb)];
        [_registButton setTitle:@"绑定手机号" forState:UIControlStateNormal];
        [_registButton setTitle:@"绑定手机号" forState:UIControlStateSelected];
        _registButton.titleLabel.font = [UIFont systemFontOfSize:16];
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
        _titleLabel.text = @"绑定手机号";
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

- (UIView *)authMaskView {
    if (!_authMaskView) {
        _authMaskView = [[UIView alloc] init];
        _authMaskView.backgroundColor = UIColorFromRGB(0xF0F0F0);
        _authMaskView.layer.cornerRadius = 22.f;
    }
    return _authMaskView;
}

- (UIButton *)skipBtn {
    if (!_skipBtn) {
        _skipBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_skipBtn setBackgroundColor:[UIColor clearColor]];
        [_skipBtn setTitle:@"跳过" forState:UIControlStateNormal];
        [_skipBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [_skipBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateSelected];
        _skipBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [_skipBtn addTarget:self action:@selector(onSkipBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _skipBtn;
}

@end
