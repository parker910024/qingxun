//
//  LLLoginViewController.h
//  XC_TTAuthMoudle
//
//  Created by apple on 2019/7/25.
//  Copyright © 2019 YiZhuan. All rights reserved.
//

#import "LLLoginViewController.h"

#import "LLQQLoginViewController.h"
#import "LLRegisterViewController.h"
#import "LLForgetPasswordViewController.h"
#import "TTPerfectUserViewController.h"
#import "TTPrivateViewController.h"
#import "BaseNavigationController.h"
#import "XCWKWebViewController.h"
#import "TTWKWebViewViewController.h"
#import "LLQQBindViewController.h"
#import "TTAuthEditView.h"
#import "TTUserProtocolView.h"
#import "LLAppleAuthView.h"
#import "HostUrlManager.h"
#import "YYUtility.h"
#import "UIImage+Utils.h"

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
#import <YYText.h>
//#import "BaiduMobStat.h"
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKExtension/ShareSDK+Extension.h>
#import "WXApi.h"

#import "XCMacros.h" // 约束的宏定义

//易盾注册保护
#import <Guardian/NTESCSGuardian.h>
//数美天网
#import "SmAntiFraud.h"
#import <AuthenticationServices/AuthenticationServices.h>
#import "ClientCore.h"

#define kScale(x) ((x) / 375.0 * KScreenWidth)

API_AVAILABLE(ios(13.0))
@interface LLLoginViewController ()<TTUserProtocolViewDelegate, AuthCoreClient, UITextFieldDelegate, VersionCoreClient, PurseCoreClient>
/** 登录 */
@property (nonatomic, strong) UILabel *titleLabel;
/** 提示可以使用erban登录 */
@property (nonatomic, strong) UILabel *loginGuideLabel;
/** 手机号输入框*/
@property (nonatomic, strong) TTAuthEditView *phoneEditView;
/** 手机号输入框下划线 */
@property (nonatomic, strong) UIView *phoneEditLineView;
/** password*/
@property (nonatomic, strong) TTAuthEditView *passwordEditView;
/** password输入框下划线 */
@property (nonatomic, strong) UIView *passwordEditLineView;
/** 验证码*/
@property (nonatomic, strong) TTAuthEditView *codeEditView;
/** 验证码  下划线*/
@property (nonatomic, strong) UIView *codeEditLineView;
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

/**
 * 是不是展示错误信息
 */
@property (nonatomic,assign) BOOL isShowErrorMessage;

/** 是超级管理员登录 */
@property (nonatomic, assign) BOOL currentUserIsSuperAdminLogin;

@property (copy, nonatomic) NSString *token;

@property (copy, nonatomic) NSString *accessToken;

@property (nonatomic, assign) BOOL shouldQL;

@property (nonatomic, assign) BOOL precheckSuccess;
@end

@implementation LLLoginViewController

#pragma mark - life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 默认为 NO
    self.currentUserIsSuperAdminLogin = NO;
    
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

/// 雅姿产品的要求，密码输入的时候关闭再次点击密码框输入的时候自动清空文本的功能。 2020年03月05日
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    if (textField == self.passwordEditView.textField) {
        if (textField.secureTextEntry) {
            [textField insertText:textField.text];
        }
    }
}

#pragma mark - TTUserProtocolViewDelegate
- (void)onSelectBtnClicked:(BOOL)select {
    [self updateLoginBtnState];
}

#pragma mark - VersionCoreClient
- (void)getVestBagLoginDescriptionDictSuccess:(VersionInfo *)model {
    
    if (![[model model2dictionary] isKindOfClass:NSDictionary.class]) {
        return;
    }
    
    NSString *description = model.tips;
    if (description.length > 0) {
        NSRange range = [description rangeOfString:@"如何登录"];
        NSMutableAttributedString * attribut = [[NSMutableAttributedString alloc] initWithString:description attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14], NSForegroundColorAttributeName:UIColorFromRGB(0x333333)}];
        if (range.location <= description.length - 4) {
            [attribut addAttribute:NSForegroundColorAttributeName value:UIColorFromRGB(0xFE4C62) range:NSMakeRange(range.location, 4)];
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
    self.codeEditLineView.hidden = NO;
    self.authMaskView.hidden = NO;
    [self setLoginButtonStatus:NO];
    
    [self.codeEditView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.height.mas_equalTo(self.phoneEditView);
        make.top.mas_equalTo(self.passwordEditView.mas_bottom).offset(kScale(26));
    }];
}

/// 当登录用户是超管身份时 需要短信验证 @fulong
- (void)onloginUserIsSuperAdminNeedVerifcial {
    self.currentUserIsSuperAdminLogin = YES;
    [GetCore(AuthCore) stopCountDown]; // 停止倒计时
    
    // 如果是已经显示了验证码页面
    if (!self.codeEditView.hidden) {
        [self.codeEditView.authCodeButton setTitle:@"获取验证码" forState:UIControlStateNormal];
        [self.codeEditView.authCodeButton setEnabled:YES];
        self.codeEditView.textField.text = @""; // 置空上次输入的验证码
    }
    
    // 显示验证码
    [self onloginImputFailNeedVerifcial];
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

// 超管登录发送验证码成功
- (void)onRequestSmsCodeSuccess:(NSNumber *)type {
    // 超管验证码短信
    if (type.integerValue == 10) {
        [self onLoginImputFailSendCodeSuccess:@""];
    }
}

// 失败
- (void)onRequestSmsCodeFailth:(NSString *)errorMsg {
    [self onLoginImputFailSendCodeFail:errorMsg];
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
    [self.navigationController popViewControllerAnimated:YES];
}

// 第三方登录成功, 但还未开始请求自己的服务器登录 时的回调
- (void)thirdPartLoginSuccess {
    [XCHUDTool showGIFLoadingInView:self.view];
}

- (void)onLoginFailth:(NSString *)errorMsg {
    [XCHUDTool showErrorWithMessage:errorMsg inView:self.view];
}

- (void)qqloginNotBindErBanInfor:(NSString *)qqOpenid{
    // 没有绑定，也需要隐藏 toastView
    [XCHUDTool hideHUDInView:self.view];
    LLQQBindViewController * bindVC = [[LLQQBindViewController alloc] init];
    bindVC.qqOpenid = qqOpenid;
    [self.navigationController pushViewController:bindVC animated:YES];
}

#pragma mark - event response
// 微信登陆按钮点击
- (void)wechatLoginBtnClick:(UIButton *)sender {
    [XCHUDTool showGIFLoadingInView:self.view];
    //避免没弹hud就去登陆了
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [GetCore(ClientCore) requestYDConfig:^(NSNumber *dict, NSNumber *errCode, NSString *msg) {
            if ([dict boolValue]) {
                [NTESCSGuardian getTokenWithBusinessID:LLRegisterViewYiDunLoginBusinessID completeHandler:^(NSString *token) {
                    
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
    //避免没弹hud就去登陆了
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [GetCore(ClientCore) requestYDConfig:^(NSNumber *dict, NSNumber *errCode, NSString *msg) {
            if ([dict boolValue]) {
                [NTESCSGuardian getTokenWithBusinessID:LLRegisterViewYiDunLoginBusinessID completeHandler:^(NSString *token) {
                    
                    [GetCore(AuthCore) thirdLoginPlatform:SSDKPlatformTypeQQ yiDunToken:token shuMeiDeviceId:[SmAntiFraud shareInstance].getDeviceId isNewUser:NO];
                }];
            }else{
                [GetCore(AuthCore) thirdLoginPlatform:SSDKPlatformTypeQQ yiDunToken:@"" shuMeiDeviceId:[SmAntiFraud shareInstance].getDeviceId isNewUser:NO];

            }
        }];
     
        
    });
}


- (void)onLoginBtnClicked:(UIButton *)sender {
    
    NSString *phone = self.phoneEditView.textField.text;
    NSString *password = self.passwordEditView.textField.text;
    NSString *code = self.codeEditView.textField.text;
    
    if (phone.length > 0 && password.length > 0) {
        
        [self.phoneEditView.textField resignFirstResponder];
        [self.passwordEditView.textField resignFirstResponder];
        [self.codeEditView.textField resignFirstResponder];
        
        [XCHUDTool showGIFLoadingInView:self.view];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            //易盾注册保护开关
            [GetCore(ClientCore) requestYDConfig:^(NSNumber *dict, NSNumber *errCode, NSString *msg) {
                if ([dict boolValue]) {
                    [NTESCSGuardian getTokenWithBusinessID:LLRegisterViewYiDunLoginBusinessID completeHandler:^(NSString *token) {
                        
                        [GetCore(AuthCore) login:phone
                                        password:password
                                            code:code
                                      yiDunToken:token
                                  shuMeiDeviceId:[SmAntiFraud shareInstance].getDeviceId];
                    }];
                }else{
                    [GetCore(AuthCore) login:phone
                                    password:password
                                        code:code
                                  yiDunToken:@""
                              shuMeiDeviceId:[SmAntiFraud shareInstance].getDeviceId];
                }
            }];
           
            
        });
    }
}

- (void)onRegisterBtnClicked:(UIButton *)sender {
    LLRegisterViewController * registVC = [[LLRegisterViewController alloc] init];
    [self.navigationController pushViewController:registVC animated:YES];
}

- (void)onForgetBtnClicked:(UIButton *)sender {
    LLForgetPasswordViewController * setPasswordVC = [[LLForgetPasswordViewController alloc] init];
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
    
    [self.view addSubview:self.titleLabel];
    [self.view addSubview:self.authMaskView];
    [self.view addSubview:self.loginGuideLabel];
    [self.view addSubview:self.phoneEditView];
    [self.view addSubview:self.phoneEditLineView];
    [self.view addSubview:self.passwordEditView];
    [self.view addSubview:self.passwordEditLineView];
    [self.view addSubview:self.codeEditView];
    [self.view addSubview:self.codeEditLineView];
    
    [self.view addSubview:self.protocolView];
    [self.view addSubview:self.loginButton];
    [self.view addSubview:self.registButton];
    [self.view addSubview:self.forgetPasswordButton];

    self.isShowErrorMessage = YES;
    @KWeakify(self);
    self.codeEditView.rightButtonDidClickBlcok = ^(UIButton *sender) {
        @KStrongify(self);
        if (self.currentUserIsSuperAdminLogin) { // 如果是超级管理员登录
            // type = 10 超管登录。获取的验证码类型
            [GetCore(AuthCore) requestSmsCode:self.phoneEditView.textField.text type:@(10)];
        } else {
            [GetCore(AuthCore) verificationSendCodeWithPhone:self.phoneEditView.textField.text];
        }
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
    
    [self.loginGuideLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(26);
        make.top.mas_equalTo(self.titleLabel.mas_bottom).offset(kScale(16));
        make.right.mas_equalTo(-26);
    }];
    
    [self.phoneEditView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(11);
        make.right.mas_equalTo(-26);
        make.top.mas_equalTo(self.titleLabel.mas_bottom).offset(kScale(78));
        make.height.mas_equalTo(45);
    }];
    
    [self.phoneEditLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.view).inset(26);
        make.top.mas_equalTo(self.phoneEditView.mas_bottom);
        make.height.mas_equalTo(1);
    }];
    
    [self.passwordEditView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(11);
        make.right.mas_equalTo(-26);
        make.top.mas_equalTo(self.phoneEditView.mas_bottom).offset(kScale(26));
        make.height.mas_equalTo(45);
    }];
    
    [self.passwordEditLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.view).inset(26);
        make.top.mas_equalTo(self.passwordEditView.mas_bottom);
        make.height.mas_equalTo(1);
    }];
    
    [self.codeEditView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.height.mas_equalTo(self.phoneEditView);
        make.top.mas_equalTo(self.passwordEditView.mas_top);
    }];
    
    [self.codeEditLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.view).inset(26);
        make.top.mas_equalTo(self.codeEditView.mas_bottom);
        make.height.mas_equalTo(1);
    }];
    
    [self.authMaskView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.height.mas_equalTo(self.phoneEditView);
        make.right.mas_equalTo(self.view).inset(140);
        make.top.mas_equalTo(self.codeEditView.mas_top);
    }];
    
    [self.registButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-26);
        make.top.mas_equalTo(self.codeEditView.mas_bottom).offset(kScale(23));
    }];
    
    [self.forgetPasswordButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(26);
        make.top.mas_equalTo(self.codeEditView.mas_bottom).offset(kScale(23));
    }];
    
    [self.loginButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.view).inset(38);
        make.top.mas_equalTo(self.forgetPasswordButton.mas_bottom).offset(kScale(45));
        make.height.mas_equalTo(44);
    }];
    
    CGFloat width = [self.protocolView getViewWidth];
    [self.protocolView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view);
        make.height.mas_equalTo(16);
        make.width.mas_equalTo(width);
        make.top.mas_equalTo(self.loginButton.mas_bottom).offset(20);
    }];
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
        self.loginButton.selected = YES;
        if (projectType() == ProjectType_Planet) {
            self.loginButton.backgroundColor = UIColorFromRGB(0x7754F6);
        } else {
            self.loginButton.layer.borderColor = UIColorFromRGB(0x333333).CGColor;
        }
    }else{
        [self.loginButton setEnabled:NO];
        self.loginButton.selected = NO;
        if (projectType() == ProjectType_Planet) {
            self.loginButton.backgroundColor = UIColorFromRGB(0xD0D0D0);
        } else {
            self.loginButton.layer.borderColor = UIColorFromRGB(0xB3B3B3).CGColor;
        }
    }
}

- (void)goToWebview:(NSString *)url {
    TTWKWebViewViewController *webView = [[TTWKWebViewViewController alloc] init];
    webView.urlString = url;
    webView.uid = GetCore(AuthCore).getUid.longLongValue;
    [self.navigationController pushViewController:webView animated:YES];
}

#pragma mark - getters and setters

- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont boldSystemFontOfSize:25];
        _titleLabel.text = @"账号登录";
        _titleLabel.textColor = UIColorFromRGB(0x333333);
    }
    return _titleLabel;
}

- (UILabel *)loginGuideLabel{
    if (!_loginGuideLabel) {
        _loginGuideLabel = [[UILabel alloc] init];
        _loginGuideLabel.font = [UIFont systemFontOfSize:13];
        _loginGuideLabel.hidden = YES;
        _loginGuideLabel.textColor = [XCTheme getTTMainTextColor];
        _loginGuideLabel.userInteractionEnabled = YES;
        _loginGuideLabel.numberOfLines = 0;
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
        _phoneEditView.backgroundColor = UIColorFromRGB(0xffffff);
    }
    return _phoneEditView;
}

- (UIView *)phoneEditLineView {
    if (!_phoneEditLineView) {
        _phoneEditLineView = [[UIView alloc] init];
        _phoneEditLineView.backgroundColor = UIColorFromRGB(0xcccccc);
    }
    return _phoneEditLineView;
}

- (TTAuthEditView *)passwordEditView{
    if (!_passwordEditView) {
        _passwordEditView = [[TTAuthEditView alloc] initWithPlaceholder:@"请输入密码"];
        [_passwordEditView.textField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
        _passwordEditView.textField.secureTextEntry = YES;
        _passwordEditView.type = TTAuthEditViewTypeNormal;
        _passwordEditView.textField.keyboardType = UIKeyboardTypeASCIICapable;
        _passwordEditView.textField.delegate = self;
        _passwordEditView.backgroundColor = UIColorFromRGB(0xffffff);
        _passwordEditView.textField.clearsOnBeginEditing = NO;
    }
    return _passwordEditView;
}

- (UIView *)passwordEditLineView {
    if (!_passwordEditLineView) {
        _passwordEditLineView = [[UIView alloc] init];
        _passwordEditLineView.backgroundColor = UIColorFromRGB(0xcccccc);
    }
    return _passwordEditLineView;
}

- (TTUserProtocolView *)protocolView{
    if (!_protocolView) {
        _protocolView =[[TTUserProtocolView alloc] init];
        _protocolView.delegate = self;
        _protocolView.isHiddenCheck = YES;
        _protocolView.nav = self.navigationController;
        
        NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] initWithString:@"登录即代表同意 "];
        attString.yy_color = [XCTheme getTTDeepGrayTextColor];
        
        NSString *protocolString = @"隐私政策";
        
        NSMutableAttributedString *privateString = [[NSMutableAttributedString alloc] initWithString:protocolString attributes:@{NSForegroundColorAttributeName:UIColorFromRGB(0xFE4C62)}];
        @weakify(self);
        [privateString yy_setTextHighlightRange:NSMakeRange(0, privateString.length) color:nil backgroundColor:nil userInfo:nil tapAction:^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
            @strongify(self);
            // 跳转隐私政策
            [self goToWebview:HtmlUrlKey(kPrivacyURL)];
        } longPressAction:nil];
        
        NSString *userString = @"用户协议";
        NSMutableAttributedString *userAttString = [[NSMutableAttributedString alloc] initWithString:userString attributes:@{NSForegroundColorAttributeName:UIColorFromRGB(0xFE4C62)}];
        [userAttString yy_setTextHighlightRange:NSMakeRange(0, userAttString.length) color:nil backgroundColor:nil userInfo:nil tapAction:^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
            @strongify(self);
            // 跳转用户协议
            [self goToWebview:HtmlUrlKey(kUserProtocalURL)];
        } longPressAction:nil];
        [attString appendAttributedString:privateString];
        [attString appendAttributedString:[[NSMutableAttributedString alloc] initWithString:@" 与 "]];
        [attString appendAttributedString:userAttString];
        
        _protocolView.agreementAttString = attString;
    }
    return _protocolView;
}

- (UIButton *)loginButton{
    if (!_loginButton) {
        _loginButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _loginButton.layer.masksToBounds = YES;
        _loginButton.layer.cornerRadius = 22;
        [_loginButton setTitle:@"立即登录" forState:UIControlStateNormal];
        [_loginButton setTitle:@"立即登录" forState:UIControlStateSelected];
        _loginButton.titleLabel.font = [UIFont systemFontOfSize:16];
        [_loginButton addTarget:self action:@selector(onLoginBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        if (projectType() == ProjectType_LookingLove) {
            [_loginButton setTitleColor:UIColorFromRGB(0xB3B3B3) forState:UIControlStateNormal];
            _loginButton.backgroundColor = UIColorRGBAlpha(0xffffff, 0);
            _loginButton.layer.borderWidth = 2;
            _loginButton.layer.borderColor = UIColorFromRGB(0xB3B3B3).CGColor;
            [_loginButton setTitleColor:UIColorFromRGB(0x333333) forState:UIControlStateSelected];
        } else {
            _loginButton.backgroundColor = UIColorFromRGB(0xD0D0D0);
            [_loginButton setTitleColor:UIColorFromRGB(0xffffff) forState:UIControlStateNormal];
        }
        
    }
    return _loginButton;
}

- (UIButton *)registButton{
    if (!_registButton) {
        _registButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_registButton setTitle:@"立即注册" forState:UIControlStateNormal];
        _registButton.titleLabel.font = [UIFont systemFontOfSize:13];
        [_registButton addTarget:self action:@selector(onRegisterBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [_registButton setTitleColor:UIColorFromRGB(0x333333) forState:UIControlStateNormal];
    }
    return _registButton;
}

- (UIButton *)forgetPasswordButton{
    if (!_forgetPasswordButton) {
        _forgetPasswordButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_forgetPasswordButton setTitle:@"忘记密码" forState:UIControlStateNormal];
        _forgetPasswordButton.titleLabel.font = [UIFont systemFontOfSize:13];
        [_forgetPasswordButton addTarget:self action:@selector(onForgetBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [_forgetPasswordButton setTitleColor:UIColorFromRGB(0x333333) forState:UIControlStateNormal];
    }
    return _forgetPasswordButton;
}

- (TTAuthEditView *)codeEditView {
    if (!_codeEditView) {
        _codeEditView = [[TTAuthEditView alloc] initWithPlaceholder:@"请输入验证码"];
        _codeEditView.type = TTAuthEditViewTypeSms;
        [_codeEditView.textField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
        _codeEditView.textField.keyboardType = UIKeyboardTypeNumberPad;
        _codeEditView.textField.delegate = self;
        [_codeEditView.authCodeButton setTitleColor:UIColorFromRGB(0xFE4C62) forState:UIControlStateNormal];
        _codeEditView.hidden = YES;
    }
    return _codeEditView;
}

- (UIView *)codeEditLineView {
    if (!_codeEditLineView) {
        _codeEditLineView = [[UIView alloc] init];
        _codeEditLineView.backgroundColor = UIColorFromRGB(0xcccccc);
        _codeEditLineView.hidden = YES;
    }
    return _codeEditLineView;
}

- (UIView *)authMaskView {
    if (!_authMaskView) {
        _authMaskView = [[UIView alloc] init];
        _authMaskView.backgroundColor = UIColorFromRGB(0xffffff);
        _authMaskView.hidden = YES;
    }
    return _authMaskView;
}

@end
