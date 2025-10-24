//
//  LLRegisterViewController.h
//  XC_TTAuthMoudle
//
//  Created by apple on 2019/7/25.
//  Copyright © 2019 YiZhuan. All rights reserved.
//


#import "LLRegisterViewController.h"

#import "TTUserProtocolView.h"
#import "TTAuthEditView.h"

// core
#import "AuthCore.h"
#import "AuthCoreClient.h"
#import "PurseCore.h"
#import "PurseCoreClient.h"
#import "ClientCore.h"
#import "NSString+Auth.h"

#import "XCTheme.h"
#import <Masonry/Masonry.h>
#import "XCHUDTool.h"
#import "XCHtmlUrl.h"
#import "XCMacros.h" // 约束的宏定义
//易盾注册保护
#import <Guardian/NTESCSGuardian.h>
//数美天网
#import "SmAntiFraud.h"

#define kScale(x) ((x) / 375.0 * KScreenWidth)

@interface LLRegisterViewController ()<AuthCoreClient, TTUserProtocolViewDelegate, UITextFieldDelegate, PurseCoreClient>
/** 标题 */
@property (nonatomic, strong) UILabel * titleLabel;
/** 手机号 */
@property (nonatomic, strong) TTAuthEditView *phoneEditView;
/** 手机号 下划线 */
@property (nonatomic, strong) UIView *phoneLineView;
/** 图片验证码 */
@property (nonatomic, strong) TTAuthEditView *captchaImageEditView;
/** 图片验证码 下划线 */
@property (nonatomic, strong) UIView *captchaLineView;
/** code */
@property (nonatomic, strong) TTAuthEditView *codeEditView;
/** code 下划线 */
@property (nonatomic, strong) UIView *codeLineView;
/** 密码 */
@property (nonatomic, strong) TTAuthEditView *passwordEditView;
/** 密码  下划线 */
@property (nonatomic, strong) UIView *passwordLineView;
/** 注册 */
@property (nonatomic, strong) UIButton *registButton;
/** 用户协议 */
@property (nonatomic, strong) TTUserProtocolView *protocolView;
@property (nonatomic, strong) UIView *authMaskView;
@property (nonatomic, strong) UIView *captchaImageMaskView;
@property (nonatomic, strong) UILabel *passwordtipsLabel;
@end

@implementation LLRegisterViewController

#pragma mark - life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
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

- (void)dealloc {
    RemoveCoreClientAll(self);
}

#pragma mark - public methods

#pragma mark - UITextFieldDelegate
- (void)textFieldDidChange:(UITextField *)theTextField{
    NSUInteger subStr = 0;
    if (theTextField == self.phoneEditView.textField) {
        subStr = 11;
    } else if (theTextField == self.codeEditView.textField) {
        subStr = 5;
    } else if (theTextField == self.passwordEditView.textField) {
        subStr = 16;
    } else if (theTextField == self.captchaImageEditView.textField) {
        subStr = 10;
    }
    
    if (theTextField.text.length >subStr) {
        theTextField.text = [theTextField.text substringToIndex:subStr];
    }
    
    BOOL hasCaptchaImage = NO;
    if (GetCore(ClientCore).captchaSwitch) {
        if (self.captchaImageEditView.textField.text.length > 0) {
            hasCaptchaImage = YES;
        } else {
            hasCaptchaImage = NO;
        }
    } else {
        hasCaptchaImage = YES;
    }
    
    if (self.phoneEditView.textField.text.length == 11 && self.codeEditView.textField.text.length == 5 && self.passwordEditView.textField.text.length >= 6 && hasCaptchaImage) {
        [self setRegisterButtonStatus:YES];
    } else {
        [self setRegisterButtonStatus:NO];
    }
}

/// 雅姿产品的要求，密码输入的时候关闭再次点击密码框输入的时候自动清空文本的功能。 2020年03月05日
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    if (textField == self.passwordEditView.textField) {
        if (textField.secureTextEntry) {
            [textField insertText:textField.text];
        }
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
- (void)onRegistSuccess {
    [GetCore(AuthCore) login:self.phoneEditView.textField.text password:self.passwordEditView.textField.text];
}

- (void)onRegistFailth:(NSString *)errorMsg errorCode:(NSInteger)errorCode {
    [XCHUDTool showErrorWithMessage:errorMsg inView:self.view];
    if (errorCode == 3002) { //图形验证码错误
        // 刷新图片验证码
        [GetCore(AuthCore) requestCaptchaImageDataWithPhone:self.phoneEditView.textField.text];
        self.captchaImageEditView.textField.text = @"";
    }
}

- (void)onLoginSuccess{
    [XCHUDTool hideHUDInView:self.view];
}

- (void)onLoginFailth:(NSString *)errorMsg{
    [XCHUDTool showErrorWithMessage:errorMsg inView:self.view];
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

// 获取注册的图片验证码
- (void)getCaptchaImageDataSuccess:(UIImage *)image {
    [self.captchaImageEditView updateCaptchaImage:image];
}

- (void)getCaptchaImageDataFailth:(NSString *)errorMsg {
    [XCHUDTool showErrorWithMessage:errorMsg inView:self.view];
}

#pragma mark - event response

- (void)onRegisterBtnClicked:(UIButton *)sender {
    NSString *phone = self.phoneEditView.textField.text;
    NSString *password = self.passwordEditView.textField.text;
    NSString *smsCode = self.codeEditView.textField.text;
    NSString *captchaImage = _captchaImageEditView.textField.text ? _captchaImageEditView.textField.text : @"";
    
    if (![password isLengthInRange:6 max:16]) {
        [XCHUDTool showErrorWithMessage:@"登录密码长度必须6-16位" inView:self.view];
        return;
    }
    
    if (![password isPasswordStrong]) {
        [XCHUDTool showErrorWithMessage:@"密码必须使用6-16个字符内的数字和英文字母组合" inView:self.view];
        return;
    }
    
    [self keyboardHide:nil];
    
    [GetCore(ClientCore) requestYDConfig:^(NSNumber *dict, NSNumber *errCode, NSString *msg) {
        if ([dict boolValue]) {
            [NTESCSGuardian getTokenWithBusinessID:LLRegisterViewYiDunRegisterBusinessID completeHandler:^(NSString *token) {
                [GetCore(AuthCore) regist:phone password:password smsCode:smsCode verifyCode:captchaImage token:token shuMeiDeviceId:[SmAntiFraud shareInstance].getDeviceId];
            }];
        }else{
            [GetCore(AuthCore) regist:phone password:password smsCode:smsCode verifyCode:captchaImage token:@"" shuMeiDeviceId:[SmAntiFraud shareInstance].getDeviceId];

        }
    }];
   
    
    
    [XCHUDTool showGIFLoadingInView:self.view];
}

- (void)keyboardHide:(UITapGestureRecognizer*)tap{
    [self.phoneEditView.textField resignFirstResponder];
    [self.codeEditView.textField resignFirstResponder];
    [self.passwordEditView.textField resignFirstResponder];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (textField == self.phoneEditView.textField || textField == self.codeEditView.textField || textField == self.captchaImageEditView.textField) {
        NSString *regex =@"[0-9]*";
        NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
        if ([pred evaluateWithObject:string]) {
            return YES;
        }
        return NO;
    }else if (textField == self.passwordEditView.textField){
        if ([string isEqualToString:@" "]) {
            return NO;
        }
    }
    return YES;
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
    [self.view addSubview:self.protocolView];
    
    if (GetCore(ClientCore).captchaSwitch) {
        [self.view addSubview:self.captchaImageMaskView];
        [self.view addSubview:self.captchaImageEditView];
        [self.view addSubview:self.captchaLineView];
        
        @KWeakify(self);
        self.captchaImageEditView.rightButtonDidClickBlcok = ^(UIButton *button) {
            @KStrongify(self);
            if (self.phoneEditView.textField.text.length != 11) {
                [XCHUDTool showErrorWithMessage:@"请输入正确的手机号" inView:self.view];
                return;
            }
            
            [GetCore(AuthCore) requestCaptchaImageDataWithPhone:self.phoneEditView.textField.text];
        };
    }
    
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
        
        if (GetCore(ClientCore).captchaSwitch) {
            if (self.captchaImageEditView.textField.text.length == 0) {
                [XCHUDTool showErrorWithMessage:@"请输入图片验证码结果" inView:self.view];
                return;
            }
        }
        
        [GetCore(PurseCore) getCodeWithPhoneNum:self.phoneEditView.textField.text type:1];
    };
}

- (void)initConstrations {
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(26);
        if (KScreenWidth > 320) {//适配 iPhone 5 文字重叠
            make.top.mas_equalTo(kNavigationHeight + 21);
        } else {
            make.top.mas_equalTo(kNavigationHeight);
        }
    }];
    
    [self.phoneEditView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(11);
        make.right.mas_equalTo(-26);
        make.top.mas_equalTo(self.titleLabel.mas_bottom).mas_equalTo(kScale(38));
        make.height.mas_equalTo(44);
    }];
    
    [self.phoneLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.view).inset(26);
        make.height.mas_equalTo(1);
        make.top.mas_equalTo(self.phoneEditView.mas_bottom);
    }];
    
    if (GetCore(ClientCore).captchaSwitch) {
        
        [self.captchaImageEditView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.height.mas_equalTo(self.phoneEditView);
            make.top.mas_equalTo(self.phoneEditView.mas_bottom).offset(kScale(26));
        }];
        
        [self.captchaLineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(26);
            make.right.mas_equalTo(-196);
            make.top.mas_equalTo(self.captchaImageEditView.mas_bottom);
            make.height.mas_equalTo(1);
        }];
        
        [self.captchaImageMaskView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.height.mas_equalTo(self.phoneEditView);
            make.right.mas_equalTo(self.view).offset(-196);
            make.top.mas_equalTo(self.captchaImageEditView);
        }];
        
        [self.authMaskView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.height.mas_equalTo(self.phoneEditView);
            make.right.mas_equalTo(self.view).inset(140);
            make.top.mas_equalTo(self.codeEditView);
        }];
        
        [self.codeEditView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.height.mas_equalTo(self.phoneEditView);
            make.top.mas_equalTo(self.self.captchaImageEditView.mas_bottom).offset(kScale(26));
        }];
        
        [self.codeLineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(self.view).inset(26);
            make.height.mas_equalTo(1);
            make.top.mas_equalTo(self.codeEditView.mas_bottom);
        }];
    } else {
        [self.authMaskView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.height.mas_equalTo(self.phoneEditView);
            make.right.mas_equalTo(self.view).inset(140);
            make.top.mas_equalTo(self.phoneEditView.mas_bottom).offset(kScale(26));
        }];
        [self.codeEditView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.height.mas_equalTo(self.phoneEditView);
            make.top.mas_equalTo(self.phoneEditView.mas_bottom).offset(kScale(26));
        }];
        
        [self.codeLineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(self.view).inset(26);
            make.height.mas_equalTo(1);
            make.top.mas_equalTo(self.codeEditView.mas_bottom);
        }];
    }
    
    [self.passwordEditView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.height.mas_equalTo(self.phoneEditView);
        make.top.mas_equalTo(self.codeEditView.mas_bottom).offset(kScale(26));
    }];
    
    [self.passwordLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.view).inset(26);
        make.height.mas_equalTo(1);
        make.top.mas_equalTo(self.passwordEditView.mas_bottom);
    }];
    
    [self.passwordtipsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.passwordLineView);
        make.top.mas_equalTo(self.passwordEditView.mas_bottom).offset(kScale(21));
    }];
    
    [self.registButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.view).inset(38);
        make.top.mas_equalTo(self.passwordtipsLabel.mas_bottom).offset(kScale(53));
        make.height.mas_equalTo(44);
    }];
    
    CGFloat width = [self.protocolView getViewWidth];
    [self.protocolView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view);
        make.height.mas_equalTo(16);
        make.width.mas_equalTo(width);
        make.bottom.mas_equalTo(-(kScale(30) + kSafeAreaBottomHeight));
    }];
}

- (void)setRegisterButtonStatus:(BOOL)status{
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

- (void)updateRegisterButtonState
{
    if (self.phoneEditView.textField.text.length == 11 && self.codeEditView.textField.text.length == 5 && self.passwordEditView.textField.text.length >= 6 && self.protocolView.isSelect) {
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
        [_registButton setTitle:@"立即注册" forState:UIControlStateNormal];
        [_registButton setTitle:@"立即注册" forState:UIControlStateSelected];
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

- (TTUserProtocolView *)protocolView{
    if (!_protocolView) {
        _protocolView =[[TTUserProtocolView alloc] init];
        _protocolView.delegate = self;
        _protocolView.isHiddenCheck = YES;
        _protocolView.nav = self.navigationController;
        _protocolView.agreementString = @"注册即代表同意";
        _protocolView.protocolString = [NSString stringWithFormat:@"《%@用户协议》",MyAppName];
        _protocolView.protocolColor = UIColorFromRGB(0xFE4C62);
        _protocolView.protocolUrl = HtmlUrlKey(kUserProtocalURL);
    }
    return _protocolView;
}

- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont boldSystemFontOfSize:25];
        _titleLabel.text = @"注册";
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

- (TTAuthEditView *)captchaImageEditView {
    if (!_captchaImageEditView) {
        _captchaImageEditView = [[TTAuthEditView alloc] initWithPlaceholder:@"请输入结果"];
        _captchaImageEditView.type = TTAuthEditViewTypeCaptchaImage;
        [_captchaImageEditView.textField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
        _captchaImageEditView.textField.keyboardType = UIKeyboardTypeNumberPad;
        _captchaImageEditView.textField.delegate = self;
    }
    return _captchaImageEditView;
}

- (UIView *)captchaLineView {
    if (!_captchaLineView) {
        _captchaLineView = [[UIView alloc] init];
        _captchaLineView.backgroundColor = UIColorFromRGB(0xcccccc);
    }
    return _captchaLineView;
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
        _passwordEditView.textField.clearsOnBeginEditing = NO;
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

- (UIView *)captchaImageMaskView {
    if (!_captchaImageMaskView) {
        _captchaImageMaskView = [[UIView alloc] init];
        _captchaImageMaskView.backgroundColor = UIColorFromRGB(0xffffff);
    }
    return _captchaImageMaskView;
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
