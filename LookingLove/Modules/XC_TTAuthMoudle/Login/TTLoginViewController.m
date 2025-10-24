//
//  TTLoginViewController.m
//  TuTu
//
//  Created by Macx on 2018/10/29.
//  Copyright © 2018 YiZhuan. All rights reserved.
//

#import "TTLoginViewController.h"

#import "TTQQLoginViewController.h"
#import "TTRegisterViewController.h"
#import "TTForgetPasswordViewController.h"
#import "TTPerfectUserViewController.h"
#import "TTPrivateViewController.h"
#import "BaseNavigationController.h"
#import "XCWKWebViewController.h"

#import "TTAuthEditView.h"
#import "TTUserProtocolView.h"

// core
#import "AuthCore.h"
#import "AuthCoreClient.h"
#import "VersionCoreClient.h"
#import "VersionCore.h"
#import "UserCore.h"
#import "PurseCore.h"
#import "PurseCoreClient.h"

#import "XCTheme.h"
#import "XCHUDTool.h"
#import "CommonFileUtils.h"
#import <Masonry/Masonry.h>
#import "XCHtmlUrl.h"
#import "XCKeyWordTool.h"

//#import "BaiduMobStat.h"
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKExtension/ShareSDK+Extension.h>
#import "WXApi.h"

//易盾注册保护
#import <Guardian/NTESCSGuardian.h>
//数美天网
#import "SmAntiFraud.h"
#import "ClientCore.h"
@interface TTLoginViewController ()<TTUserProtocolViewDelegate, AuthCoreClient, UITextFieldDelegate, VersionCoreClient, PurseCoreClient>
/** 登录 */
@property (nonatomic, strong) UILabel *titleLabel;
/** logo */
@property (nonatomic, strong) UIImageView *logoImage;
/** 提示可以使用erban登录 */
@property (nonatomic, strong) UILabel *loginGuideLabel;
/** 手机号输入框*/
@property (nonatomic, strong) TTAuthEditView *phoneEditView;
/** password*/
@property (nonatomic, strong) TTAuthEditView *passwordEditView;

/** 验证码*/
@property (nonatomic, strong) TTAuthEditView *codeEditView;

/**验证码的阴影*/
@property (nonatomic, strong) UIView *authMaskView;

/** 协议*/
@property (nonatomic, strong) TTUserProtocolView *protocolView;
/** 登录按钮*/
@property (nonatomic, strong) UIButton *loginButton;
/** 注册*/
@property (nonatomic, strong) UIButton *registButton;
/** 忘记密码*/
@property (nonatomic, strong) UIButton *forgetPasswordButton;
/** 其他登录方式*/
@property (nonatomic, strong) UILabel *otherLoginLabel;
/**qq登录 */
@property (nonatomic, strong) UIButton *qqLoginButton;
/** 微信登录*/
@property (nonatomic, strong) UIButton *wxLoginButton;

/**
 * 是不是展示错误信息
 */
@property (nonatomic,assign) BOOL isShowErrorMessage;
@end

@implementation TTLoginViewController

#pragma mark - life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if (![defaults objectForKey:@"kTuTuPrivateKey"]) {
        BaseNavigationController *navVC = [[BaseNavigationController alloc] initWithRootViewController:[TTPrivateViewController new]];
        navVC.modalPresentationStyle = UIModalPresentationOverCurrentContext;
        [self presentViewController:navVC animated:NO completion:nil];
    }

    [self initView];
    [self initConstrations];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)dealloc {
    NotifyCoreClient(AuthCoreClient, @selector(loginViewControllerDismiss), loginViewControllerDismiss);
    RemoveCoreClientAll(self);
}

#pragma mark - public methods

#pragma mark - UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (textField == self.phoneEditView.textField) {
        NSString *regex =@"[0-9]*";
        NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
        if ([pred evaluateWithObject:string]) {
            return YES;
        }
        return NO;
    } else if (textField == self.passwordEditView.textField){
        if ([string isEqualToString:@" "]) {
            return NO;
        }
    }
    return YES;
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self onLoginBtnClicked:self.loginButton];
    return YES;
}

- (void)textFieldDidChange:(UITextField *)theTextField{
    NSUInteger subStr = 0;
    if (theTextField == self.phoneEditView.textField) {
        subStr = 11;
    } else if (theTextField == self.passwordEditView.textField) {
        subStr = 16;
    }else if (theTextField == self.codeEditView.textField){
        subStr = 5;
    }
    
    if (theTextField.text.length >subStr) {
        theTextField.text = [theTextField.text substringToIndex:subStr];
    }
    
    if (self.isShowErrorMessage) {
        if (self.phoneEditView.textField.text.length >= 1 && self.passwordEditView.textField.text.length >= 6 && self.protocolView.isSelect) {
            [self setLoginButtonStatus:YES];
        } else {
            [self setLoginButtonStatus:NO];
        }
    }else{
        if (self.phoneEditView.textField.text.length >= 1 && self.passwordEditView.textField.text.length >= 6 && self.codeEditView.textField.text.length >= 5 && self.protocolView.isSelect) {
            [self setLoginButtonStatus:YES];
        } else {
            [self setLoginButtonStatus:NO];
        }
    }
    
}

#pragma mark - TTUserProtocolViewDelegate
- (void)onSelectBtnClicked:(BOOL)select {
    [self updateLoginBtnState];
}

#pragma mark - VersionCoreClient
- (void)getVestBagLoginDescriptionSuccess:(NSString *)description{
    if (![description isKindOfClass:NSString.class]) {
        self.loginGuideLabel.hidden = YES;
        return;
    }
    if (description.length > 0) {
        NSRange range = [description rangeOfString:@"如何登录"];
        NSMutableAttributedString * attribut = [[NSMutableAttributedString alloc] initWithString:description attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14], NSForegroundColorAttributeName:UIColorFromRGB(0x333333)}];
        if (range.location <= description.length - 5) {
            [attribut addAttribute:NSForegroundColorAttributeName value:UIColorFromRGB(0x589DE7) range:NSMakeRange(range.location, 5)];
        }
        self.loginGuideLabel.attributedText = attribut;
        self.loginGuideLabel.hidden = NO;
    }else{
        self.loginGuideLabel.hidden = YES;
    }
}

#pragma mark - AuthCoreClient
//登录的时候 如果输入三次密码失败 就提示他需要验证 @fengshuo
- (void)onloginImputFailNeedVerifcial {
    self.isShowErrorMessage = NO;
    self.codeEditView.hidden = NO;
    self.authMaskView.hidden = NO;
    [self setLoginButtonStatus:NO];
    [self.codeEditView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.phoneEditView.mas_bottom).offset(84);
    }];
}

- (void)onCutdownOpen:(NSNumber *)number {
    //如果是在倒计时的话 就显示重新获取+秒
    if (number > 0) {
        [self.codeEditView.authCodeButton setTitle:[NSString stringWithFormat:@"%ds后重试", number.intValue] forState:UIControlStateNormal];
    }
}

- (void)onCutdownFinish {
    [self.codeEditView.authCodeButton setTitle:@"重新发送" forState:UIControlStateNormal];
    [self.codeEditView.authCodeButton setEnabled:YES];
}

//发送验证码 成功|失败
- (void)onLoginImputFailSendCodeFail:(NSString *)message {
    self.codeEditView.authCodeButton.enabled = YES;
}

- (void)onLoginImputFailSendCodeSuccess:(NSString *)messsage {
    [XCHUDTool showErrorWithMessage:messsage inView:self.view];
    self.codeEditView.authCodeButton.enabled = YES;
}


- (void)thirdPartLoginFailth {
    [XCHUDTool showErrorWithMessage:@"登录失败，请重试" inView:self.view];
}

- (void)thirdPartLoginCancel {
    [XCHUDTool showErrorWithMessage:@"用户取消操作" inView:self.view];
}

- (void)onLoginSuccess {
    [XCHUDTool hideHUDInView:self.view];
    [GetCore(AuthCore) stopCountDown];
    // 登录成功后发送通知，刷新用户数据(获取地理位置信息)
    [[NSNotificationCenter defaultCenter] postNotificationName:@"kUserLoginSuccessRefreshUserInfoNoti" object:nil];
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

// 第三方登录成功, 但还未开始请求自己的服务器登录 时的回调
- (void)thirdPartLoginSuccess {
    [XCHUDTool showGIFLoadingInView:self.view];
}

- (void)onLoginFailth:(NSString *)errorMsg {
    [XCHUDTool showErrorWithMessage:errorMsg inView:self.view];
}

#pragma mark - event response
// 微信登陆按钮点击
- (void)wechatLoginBtnClick:(UIButton *)sender {
    [XCHUDTool showGIFLoadingInView:self.view];
    //避免没弹hud就去登陆了
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [GetCore(ClientCore) requestYDConfig:^(NSNumber *dict, NSNumber *errCode, NSString *msg) {
            if ([dict boolValue]) {
                [NTESCSGuardian getTokenWithBusinessID:kYiDunBusinessID completeHandler:^(NSString *token) {
                    
                    [GetCore(AuthCore) thirdLoginPlatform:SSDKPlatformTypeWechat yiDunToken:token shuMeiDeviceId:[SmAntiFraud shareInstance].getDeviceId];
                }];
            }else{
                [GetCore(AuthCore) thirdLoginPlatform:SSDKPlatformTypeWechat yiDunToken:@"" shuMeiDeviceId:[SmAntiFraud shareInstance].getDeviceId];

            }
        }];
       
        
    });
    
}

- (void)qqLoginBtnClick:(UIButton *)sender {

    [XCHUDTool showGIFLoadingInView:self.view];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [GetCore(ClientCore) requestYDConfig:^(NSNumber *dict, NSNumber *errCode, NSString *msg) {
            if ([dict boolValue]) {
                [NTESCSGuardian getTokenWithBusinessID:kYiDunBusinessID completeHandler:^(NSString *token) {
                    
                    [GetCore(AuthCore) thirdLoginPlatform:SSDKPlatformTypeQQ yiDunToken:token shuMeiDeviceId:[SmAntiFraud shareInstance].getDeviceId];
                }];
            }else{
                [GetCore(AuthCore) thirdLoginPlatform:SSDKPlatformTypeQQ yiDunToken:@"" shuMeiDeviceId:[SmAntiFraud shareInstance].getDeviceId];

            }
        }];
     
        
    });
}


- (void)onLoginBtnClicked:(UIButton *)sender {

    NSString *phone = self.phoneEditView.textField.text;
    NSString *password = self.passwordEditView.textField.text;
    NSString * code = self.codeEditView.textField.text;
    if (phone.length > 0 && password.length > 0) {
        
        [XCHUDTool showGIFLoadingInView:self.view];
        [GetCore(AuthCore) login:phone password:password code:code];
        [self.phoneEditView.textField resignFirstResponder];
        [self.passwordEditView.textField resignFirstResponder];
       [self.codeEditView.textField resignFirstResponder];
    }
}

- (void)onRegisterBtnClicked:(UIButton *)sender {
    TTRegisterViewController * registVC = [[TTRegisterViewController alloc] init];
    [self.navigationController pushViewController:registVC animated:YES];
}

- (void)onForgetBtnClicked:(UIButton *)sender {
    TTForgetPasswordViewController * setPasswordVC = [[TTForgetPasswordViewController alloc] init];
    [self.navigationController pushViewController:setPasswordVC animated:YES];
}

- (void)loginTipLabelRecognizer:(UITapGestureRecognizer *)sender {
    XCWKWebViewController *vc = [[XCWKWebViewController alloc]init];
    vc.urlString = HtmlUrlKey(kQQloginGuideURL); //kQQloginGuideURL
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - private method

- (void)initView {
    self.isShowErrorMessage = YES;
    AddCoreClient(AuthCoreClient, self);
    AddCoreClient(VersionCoreClient, self);
    AddCoreClient(PurseCoreClient, self);

    [GetCore(VersionCore) getVestBagShowErBanLogin];
    if (![ShareSDK isClientInstalled:SSDKPlatformTypeWechat]) {
        [self.wxLoginButton setImage:[UIImage imageNamed:@"wechat_login_disable"] forState:UIControlStateNormal];
        [self.wxLoginButton setEnabled:NO];
    }
    
    if (![ShareSDK isClientInstalled:SSDKPlatformTypeQQ]) {
        [self.qqLoginButton setImage:[UIImage imageNamed:@"qq_login_disable"] forState:UIControlStateNormal];
        [self.qqLoginButton setEnabled:NO];
    }
    
    [self judgeIsAudting];
    
    [self.view addSubview:self.logoImage];
    [self.view addSubview:self.titleLabel];
    [self.view addSubview:self.authMaskView];
    [self.view addSubview:self.loginGuideLabel];
    [self.view addSubview:self.phoneEditView];
    [self.view addSubview:self.passwordEditView];
    [self.view addSubview:self.codeEditView];
    
    [self.view addSubview:self.protocolView];
    [self.view addSubview:self.loginButton];
    [self.view addSubview:self.registButton];
    [self.view addSubview:self.forgetPasswordButton];
    [self.view addSubview:self.otherLoginLabel];
    [self.view addSubview:self.wxLoginButton];
    [self.view addSubview:self.qqLoginButton];
    
    self.isShowErrorMessage = YES;
    @KWeakify(self);
    self.codeEditView.rightButtonDidClickBlcok = ^(UIButton *sender) {
        @KStrongify(self);
        [GetCore(AuthCore) verificationSendCodeWithPhone:self.phoneEditView.textField.text];
    };
}

- (void)initConstrations {
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        if (KScreenWidth <= 320) {
            make.top.mas_equalTo(self.view).offset(75);
        }else{
            make.top.mas_equalTo(self.view).offset(75 + statusbarHeight);
        }
        make.left.mas_equalTo(self.view).offset(35);
    }];
    
    [self.logoImage mas_makeConstraints:^(MASConstraintMaker *make) {
        if (@available(iOS 11, *)) {
            make.top.mas_equalTo(self.view.mas_safeAreaLayoutGuideTop).offset(60);
        } else {
            make.top.mas_equalTo(self.view.mas_top).offset(60);
        }
        make.centerX.mas_equalTo(0);
        make.width.height.mas_equalTo(87);
    }];
    
    [self.loginGuideLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.mas_equalTo(self.titleLabel.mas_right).offset(8);
//        make.bottom.mas_equalTo(self.titleLabel);
        make.left.right.mas_equalTo(self.view);
        make.bottom.mas_equalTo(self.wxLoginButton.mas_top).offset(-15);
        make.centerX.mas_equalTo(self.view);
    }];
    
    [self.phoneEditView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.view).inset(48);
        make.top.mas_equalTo(self.logoImage.mas_bottom).offset(67);
        make.height.mas_equalTo(44);
    }];
    
    [self.passwordEditView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.view).inset(48);
        make.top.mas_equalTo(self.phoneEditView.mas_bottom).offset(20);
        make.height.mas_equalTo(44);
    }];
    
    [self.codeEditView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.view).inset(48);
        make.top.mas_equalTo(self.phoneEditView.mas_bottom).offset(20);
        make.height.mas_equalTo(44);
    }];
    
    [self.authMaskView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.height.mas_equalTo(self.phoneEditView);
        make.right.mas_equalTo(self.view).inset(140);
        make.top.mas_equalTo(self.codeEditView.mas_top);
    }];
    
    CGFloat width = [self.protocolView getViewWidth];
    [self.protocolView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view);
        make.height.mas_equalTo(16);
        make.width.mas_equalTo(width);
        if (@available(iOS 11.0, *)) {
            make.bottom.mas_equalTo(self.view.mas_safeAreaLayoutGuideBottom).inset(16);
        } else {
            make.bottom.mas_equalTo(self.view.mas_bottom).inset(24);
        }
    }];
    
    [self.loginButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.view).inset(48);
        make.top.mas_equalTo(self.codeEditView.mas_bottom).offset(20);
        make.height.mas_equalTo(44);
    }];
    
    [self.registButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.loginButton).offset(20);
        make.top.mas_equalTo(self.loginButton.mas_bottom).offset(12);
    }];
    
    [self.forgetPasswordButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.loginButton).offset(-20);
        make.top.mas_equalTo(self.loginButton.mas_bottom).offset(12);
    }];
    
    [self.qqLoginButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(44);
        make.bottom.mas_equalTo(self.view).offset(-(49 + kSafeAreaBottomHeight));
        make.left.mas_equalTo(self.view.mas_centerX).offset(25);
    }];
    
    [self.wxLoginButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(44);
        make.bottom.mas_equalTo(self.view).offset(-(49 + kSafeAreaBottomHeight));
        make.right.mas_equalTo(self.view.mas_centerX).offset(-25);
    }];
    
//    [self.otherLoginLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.right.mas_equalTo(self.view);
//        make.bottom.mas_equalTo(self.wxLoginButton.mas_top).offset(-15);
//    }];

    
    
}

- (void)judgeIsAudting {
    
    if (![ShareSDK isClientInstalled:(SSDKPlatformType)SSDKPlatformTypeWechat]) {
        self.wxLoginButton.hidden = YES;
    } else {
        self.wxLoginButton.hidden = NO;
    }
    
    if (![ShareSDK isClientInstalled:(SSDKPlatformType)SSDKPlatformTypeQQ]) {
        self.qqLoginButton.hidden = YES;
    } else {
        self.qqLoginButton.hidden = NO;
        
    }
    if ([ShareSDK isClientInstalled:(SSDKPlatformType)SSDKPlatformTypeQQ] && [ShareSDK isClientInstalled:(SSDKPlatformType)SSDKPlatformTypeWechat]) {
        self.otherLoginLabel.hidden = NO;
    } else if (![ShareSDK isClientInstalled:(SSDKPlatformType)SSDKPlatformTypeQQ] && ![ShareSDK isClientInstalled:(SSDKPlatformType)SSDKPlatformTypeWechat]) {
        self.otherLoginLabel.hidden = YES;
    }
}

- (void)updateLoginBtnState {
    if (self.isShowErrorMessage) {
        if (self.phoneEditView.textField.text.length >= 1 && self.passwordEditView.textField.text.length >= 6 && self.protocolView.isSelect) {
            [self setLoginButtonStatus:YES];
        } else {
            [self setLoginButtonStatus:NO];
        }
    }else{
        if (self.phoneEditView.textField.text.length >= 1 && self.passwordEditView.textField.text.length >= 6 &&
            self.codeEditView.textField.text.length >= 5 && self.protocolView.isSelect) {
            [self setLoginButtonStatus:YES];
        } else {
            [self setLoginButtonStatus:NO];
        }
    }
    
}

- (void)setLoginButtonStatus:(BOOL)status{
    if (status) {
        [self.loginButton setEnabled:YES];
        [self.loginButton setBackgroundColor:[XCTheme getTTMainColor]];
    }else{
        [self.loginButton setEnabled:NO];
        [self.loginButton setBackgroundColor:UIColorFromRGB(0xdbdbdb)];
    }
}


#pragma mark - getters and setters

- (BOOL)isHiddenNavBar {
    return YES;
}

- (UIImageView *)logoImage {
    if (!_logoImage) {
        _logoImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"puding_logo"]];
    }
    return _logoImage;
}
- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont systemFontOfSize:22];
        _titleLabel.text = @"";
        _titleLabel.textColor = [XCTheme getTTMainTextColor];
    }
    return _titleLabel;
}

- (UILabel *)loginGuideLabel{
    if (!_loginGuideLabel) {
        _loginGuideLabel = [[UILabel alloc] init];
        _loginGuideLabel.font = [UIFont systemFontOfSize:14];
        _loginGuideLabel.hidden = YES;
        _loginGuideLabel.textAlignment = NSTextAlignmentCenter;
        _loginGuideLabel.textColor = [XCTheme getTTMainTextColor];
        _loginGuideLabel.userInteractionEnabled = YES;
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(loginTipLabelRecognizer:)];
        [_loginGuideLabel addGestureRecognizer:tap];
    }
    return _loginGuideLabel;
}

- (TTAuthEditView *)phoneEditView{
    if (!_phoneEditView) {
        _phoneEditView = [[TTAuthEditView alloc] initWithPlaceholder:@"请输入手机号/ID"];
        _phoneEditView.type = TTAuthEditViewTypeNormal;
        [_phoneEditView.textField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
        _phoneEditView.textField.keyboardType = UIKeyboardTypeNumberPad;
        _phoneEditView.textField.delegate = self;
        _phoneEditView.layer.cornerRadius = 22.f;
        _phoneEditView.backgroundColor = UIColorFromRGB(0xf0f0f0);
    }
    return _phoneEditView;
}

- (TTAuthEditView *)passwordEditView{
    if (!_passwordEditView) {
        _passwordEditView = [[TTAuthEditView alloc] initWithPlaceholder:@"请输入密码"];
        [_passwordEditView.textField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
        _passwordEditView.textField.secureTextEntry = YES;
        _passwordEditView.type = TTAuthEditViewTypeNormal;
        _passwordEditView.textField.keyboardType = UIKeyboardTypeASCIICapable;
        _passwordEditView.textField.delegate = self;
        _passwordEditView.layer.cornerRadius = 22.f;
        _passwordEditView.backgroundColor = UIColorFromRGB(0xf0f0f0);
    }
    return _passwordEditView;
}

- (TTUserProtocolView *)protocolView{
    if (!_protocolView) {
        _protocolView =[[TTUserProtocolView alloc] init];
        _protocolView.delegate = self;
        _protocolView.isHiddenCheck = YES;
        _protocolView.nav = self.navigationController;
        _protocolView.agreementString = @"继续即代表同意";
        _protocolView.protocolString = [NSString stringWithFormat:@"《%@用户协议》", [XCKeyWordTool sharedInstance].myAppName];
        _protocolView.protocolUrl = HtmlUrlKey(kUserProtocalURL);
    }
    return _protocolView;
}

- (UIButton *)loginButton{
    if (!_loginButton) {
        _loginButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _loginButton.layer.masksToBounds = YES;
        _loginButton.layer.cornerRadius = 22;
        [_loginButton setBackgroundColor:UIColorFromRGB(0xdbdbdb)];
        [_loginButton setTitle:@"登录" forState:UIControlStateNormal];
        [_loginButton setTitle:@"登录" forState:UIControlStateSelected];
        _loginButton.titleLabel.font = [UIFont systemFontOfSize:16];
        [_loginButton addTarget:self action:@selector(onLoginBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [_loginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_loginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    }
    return _loginButton;
}

- (UIButton *)registButton{
    if (!_registButton) {
        _registButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_registButton setTitle:@"立即注册" forState:UIControlStateNormal];
        [_registButton setTitle:@"立即注册" forState:UIControlStateSelected];
        _registButton.titleLabel.font = [UIFont systemFontOfSize:14];
        [_registButton addTarget:self action:@selector(onRegisterBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [_registButton setTitleColor:UIColorFromRGB(0x1a1a1a) forState:UIControlStateNormal];
        [_registButton setTitleColor:UIColorFromRGB(0x1a1a1a) forState:UIControlStateSelected];
    }
    return _registButton;
}

- (UIButton *)forgetPasswordButton{
    if (!_forgetPasswordButton) {
        _forgetPasswordButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_forgetPasswordButton setTitle:@"忘记密码？" forState:UIControlStateNormal];
        [_forgetPasswordButton setTitle:@"忘记密码？" forState:UIControlStateSelected];
        _forgetPasswordButton.titleLabel.font = [UIFont systemFontOfSize:14];
        [_forgetPasswordButton addTarget:self action:@selector(onForgetBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [_forgetPasswordButton setTitleColor:UIColorFromRGB(0x589DE7) forState:UIControlStateNormal];
        [_forgetPasswordButton setTitleColor:UIColorFromRGB(0x589DE7) forState:UIControlStateSelected];
    }
    return _forgetPasswordButton;
}

- (TTAuthEditView *)codeEditView{
    if (!_codeEditView) {
        _codeEditView = [[TTAuthEditView alloc] initWithPlaceholder:@"请输入验证码"];
        _codeEditView.type = TTAuthEditViewTypeSms;
        [_codeEditView.textField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
        _codeEditView.textField.keyboardType = UIKeyboardTypeNumberPad;
        _codeEditView.textField.delegate = self;
        _codeEditView.hidden = YES;
    }
    return _codeEditView;
}

- (UIView *)authMaskView {
    if (!_authMaskView) {
        _authMaskView = [[UIView alloc] init];
        _authMaskView.backgroundColor = UIColorFromRGB(0xF0F0F0);
        _authMaskView.layer.cornerRadius = 22.f;
        _authMaskView.hidden = YES;
    }
    return _authMaskView;
}

- (UIButton *)wxLoginButton{
    if (!_wxLoginButton) {
        _wxLoginButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_wxLoginButton setImage:[UIImage imageNamed:@"auth_login_wechat"] forState:UIControlStateNormal];
        [_wxLoginButton setImage:[UIImage imageNamed:@"auth_login_wechat"] forState:UIControlStateSelected];
        [_wxLoginButton addTarget:self action:@selector(wechatLoginBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _wxLoginButton;
}

- (UIButton *)qqLoginButton{
    if (!_qqLoginButton) {
        _qqLoginButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_qqLoginButton setImage:[UIImage imageNamed:@"auth_login_qq"] forState:UIControlStateNormal];
        [_qqLoginButton setImage:[UIImage imageNamed:@"auth_login_qq"] forState:UIControlStateSelected];
        [_qqLoginButton addTarget:self action:@selector(qqLoginBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _qqLoginButton;
}

- (UILabel *)otherLoginLabel{
    if (!_otherLoginLabel) {
        _otherLoginLabel = [[UILabel alloc] init];
        _otherLoginLabel.font = [UIFont systemFontOfSize:14];
        _otherLoginLabel.text = @"—— 其他登录方式 ——";
        _otherLoginLabel.hidden = YES;
        _otherLoginLabel.textAlignment = NSTextAlignmentCenter;
        _otherLoginLabel.textColor = [XCTheme getTTDeepGrayTextColor];
    }
    return _otherLoginLabel;
}

@end
