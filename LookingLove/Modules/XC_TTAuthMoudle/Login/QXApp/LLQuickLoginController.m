//
//  LLQuickLoginController.m
//  XC_TTAuthMoudle
//
//  Created by lee on 2020/3/23.
//  Copyright © 2020 YiZhuan. All rights reserved.
//

#import "LLQuickLoginController.h"

#import "LLQQLoginViewController.h"
#import "LLRegisterViewController.h"
#import "LLForgetPasswordViewController.h"
#import "TTPerfectUserViewController.h"
#import "TTPrivateViewController.h"
#import "LLLoginViewController.h"
#import "LLQuickLoginCTMobileController.h"

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
/// 一键登录
#import <NTESQuickPass/NTESQuickPass.h>
// 埋点
#import "TTStatisticsService.h"
#import "ClientCore.h"
#define kScale(x) ((x) / 375.0 * KScreenWidth)

#ifdef DEBUG
    NSString *businessID = @"4f7410a22ec8426281d4faf286835c3e";
#else
    NSString *businessID = @"398816ccd0094b3fa430dbad3c08c102";
#endif

API_AVAILABLE(ios(13.0))
@interface LLQuickLoginController ()<TTUserProtocolViewDelegate, AuthCoreClient, UITextFieldDelegate, VersionCoreClient, PurseCoreClient>
@property (nonatomic, strong) UIImageView *appIcon;
/** 登录 */
@property (nonatomic, strong) UILabel *titleLabel;
/// 其他账号登录
@property (nonatomic, strong) UIButton *otherLoginBtn;
/** 协议*/
@property (nonatomic, strong) TTUserProtocolView *protocolView;
/** 登录按钮*/
@property (nonatomic, strong) UIButton *loginButton;

@property (nonatomic, assign) BOOL otherLoginBool;
/**qq登录 */
@property (nonatomic, strong) UIButton *qqLoginButton;
/** 微信登录*/
@property (nonatomic, strong) UIButton *wxLoginButton;
/**
 * 是不是展示错误信息
 */
@property (nonatomic,assign) BOOL isShowErrorMessage;

@property (nonatomic, strong) ASAuthorizationAppleIDButton *authAppleIDButton;

@property (copy, nonatomic) NSString *token;

@property (copy, nonatomic) NSString *accessToken;

@property (nonatomic, assign) BOOL shouldQL;

@property (nonatomic, assign) BOOL precheckSuccess;
@end

@implementation LLQuickLoginController

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
    
    @weakify(self);
    
    self.shouldQL = [[NTESQuickLoginManager sharedInstance] shouldQuickLogin];
    
    if (self.shouldQL) {
        [[NTESQuickLoginManager sharedInstance] registerWithBusinessID:businessID timeout:3*1000 configURL:nil extData:nil completion:^(NSDictionary * _Nullable params, BOOL success) {
            
            @strongify(self);
        
            if (success) {
                self.token = [params objectForKey:@"token"];
                self.precheckSuccess = YES;
            } else {
                self.precheckSuccess = NO;
            }
        }];
    }
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

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self onLoginBtnClicked:self.loginButton];
    return YES;
}

#pragma mark - TTUserProtocolViewDelegate
- (void)onSelectBtnClicked:(BOOL)select {
}

#pragma mark - VersionCoreClient
- (void)getVestBagLoginDescriptionDictSuccess:(VersionInfo *)model {
    
    if (![[model model2dictionary] isKindOfClass:NSDictionary.class]) {
        return;
    }
    
    if (projectType() == ProjectType_Planet) { // hello处CP不要第三方登录
        return;
    }
    if (model.showWechat) {
        if (![ShareSDK isClientInstalled:(SSDKPlatformType)SSDKPlatformTypeWechat]) {
            self.wxLoginButton.hidden = YES;
        } else {
            self.wxLoginButton.hidden = NO;
        }
    } else {
        self.wxLoginButton.hidden = YES;
    }
    
    if (model.showQq) {
        if (![ShareSDK isClientInstalled:(SSDKPlatformType)SSDKPlatformTypeQQ]) {
            self.qqLoginButton.hidden = YES;
        } else {
            self.qqLoginButton.hidden = NO;
        }
    } else {
        self.qqLoginButton.hidden = YES;
    }
    
    if (model.showWechat && !model.showQq) {
        [self.wxLoginButton mas_updateConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self.view.mas_centerX).offset(16);
        }];
    } else if (!model.showWechat && model.showQq) {
        [self.qqLoginButton mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.view.mas_centerX).offset(-16);
        }];
    }
}

#pragma mark -
#pragma mark 易盾一键登录
- (void)getPhoneNumber {
    if (!self.shouldQL ||
        !self.precheckSuccess) {
        
        [TTStatisticsService trackEvent:@"one_click_login_failed" eventDescribe:@"一键登录不可用"];

        [XCHUDTool hideHUD];
        LLLoginViewController *vc = [[LLLoginViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
        return;
    }
    
    // 获取当前上网卡的运营商，0:未知 1:电信 2.移动 3.联通
    NSInteger currentCarrier = [[NTESQuickLoginManager sharedInstance] getCarrier];
    
    @weakify(self);
    [[NTESQuickLoginManager sharedInstance] getPhoneNumberCompletion:^(NSDictionary * _Nonnull resultDic) {        
        @strongify(self);
        
        [XCHUDTool hideHUD];

        NSNumber *boolNum = [resultDic objectForKey:@"success"];
        BOOL success = [boolNum boolValue];
        
        if (success) {
            if (currentCarrier == 1) {
                LLQuickLoginCTMobileController *vc = [[LLQuickLoginCTMobileController alloc] init];
                vc.token = self.token;
                vc.securityPhone = [resultDic objectForKey:@"securityPhone"];
                [self.navigationController pushViewController:vc animated:YES];
                return ;
            }
            
            if (currentCarrier == 2 || currentCarrier == 3) {
                
                [self setupCMCustomUI];
                [self setupCUCustomUI];
                
                [[NTESQuickLoginManager sharedInstance] CUCMAuthorizeLoginCompletion:^(NSDictionary * _Nonnull resultDic) {
                    @strongify(self);
                    
                    NSNumber *boolNum = [resultDic objectForKey:@"success"];
                    BOOL success = [boolNum boolValue];
                    if (success) {
                      
                        [TTStatisticsService trackEvent:@"one_click_login_succeed" eventDescribe:@"一键登录成功"];
                        
                        // 移动登录授权页面需要手动关闭
                        if (currentCarrier == 2) {
                            [self dismissViewControllerAnimated:YES completion:nil];
                        }
                        
                        [XCHUDTool showGIFLoading];
                        // 取号成功，获取acessToken
                        
                        [GetCore(ClientCore) requestYDConfig:^(NSNumber *dict, NSNumber *errCode, NSString *msg) {
                            if ([dict boolValue]) {
                                [NTESCSGuardian getTokenWithBusinessID:LLRegisterViewYiDunLoginBusinessID completeHandler:^(NSString *token) {
                                    [GetCore(AuthCore) quickLoginAccessToken:resultDic[@"accessToken"]
                                                                  yiDunToken:token
                                                              shuMeiDeviceId:[SmAntiFraud shareInstance].getDeviceId
                                                                       token:self.token];
                                }];
                            }else{
                                [GetCore(AuthCore) quickLoginAccessToken:resultDic[@"accessToken"]
                                                              yiDunToken:@""
                                                          shuMeiDeviceId:[SmAntiFraud shareInstance].getDeviceId
                                                                   token:self.token];
                            }
                        }];
                       
                    } else {
                        
                        NSString *resultCode = [resultDic objectForKey:@"resultCode"];
                        // 移动 && 联通 取消一键登录(点击了返回按钮)
                        if ([resultCode isEqualToString:@"200020"] ||
                            [resultCode isEqualToString:@"10104"]) {
                            /// 取消登录
                        } else {
                            // 取号失败
                            [XCHUDTool showErrorWithMessage:@"一键登录失败，请使用其他方式登录"];
                        }
                        
                        NSString *desc = [resultDic objectForKey:@"desc"];
                        [TTStatisticsService trackEvent:@"one_click_login_failed" eventDescribe:desc];
                    }
                }];
                
            }
        } else {
            LLLoginViewController *vc = [[LLLoginViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
            
            NSString *desc = [resultDic objectForKey:@"desc"];
            [TTStatisticsService trackEvent:@"one_click_login_failed" eventDescribe:desc ?: @"一键登录失败"];
        }
    }];
}

/// 移动自定义授权页面
- (void)setupCMCustomUI {
    NTESQuickLoginCMModel *CMModel = [[NTESQuickLoginCMModel alloc] init];
    CMModel.currentVC = self;
    CMModel.logoImg = [UIImage imageNamed:@"ChinaMobile_icon"];
    CMModel.logoWidth = 95;
    CMModel.logoHeight = 95;
    CMModel.logoOffsetY = @(-30);

    CMModel.navText = [[NSAttributedString alloc] initWithString:@"一键登录"
                                                      attributes:@{NSFontAttributeName : [UIFont boldSystemFontOfSize:17],
                                                                   NSForegroundColorAttributeName : [XCTheme getTTMainTextColor]}];
    CMModel.navReturnImg = [UIImage imageNamed:@"nav_bar_back"];
    CMModel.navColor = UIColor.whiteColor;

    CMModel.logBtnText = [[NSAttributedString alloc] initWithString:@"本机号码一键登录"
                                                         attributes:@{NSFontAttributeName : [UIFont boldSystemFontOfSize:16],
                                                                      NSForegroundColorAttributeName : UIColor.whiteColor}];
    CMModel.logBtnImgs = [self loginBtnImages];
    CMModel.logBtnHeight = 48;
    CMModel.logBtnOffsetY = @(260);
    
    CMModel.numberOffsetY = @(170);
    CMModel.numberText = [[NSAttributedString alloc] initWithString:@"设置文字内容无效随便设置"
                                                         attributes:@{NSFontAttributeName : [UIFont boldSystemFontOfSize:20],
                                                                      NSForegroundColorAttributeName : [XCTheme getTTMainTextColor]}];

    CMModel.switchAccText = [[NSAttributedString alloc] initWithString:@"其他账号登录"
                                                            attributes:@{NSFontAttributeName : [UIFont boldSystemFontOfSize:15],
                                                                         NSForegroundColorAttributeName : [XCTheme getTTSubTextColor]}];
    CMModel.swithAccHidden = YES; // 隐藏了该控件
    
    CMModel.uncheckedImg = [UIImage imageNamed:@"quickLogin_checkNormal"];
    CMModel.checkedImg = [UIImage imageNamed:@"quickLogin_checkSelect"];
    CMModel.checkboxWH = @20;
    CMModel.privacyColor = UIColorFromRGB(0xFE4C62);
    CMModel.appPrivacyDemo = [[NSAttributedString alloc] initWithString:@"登录即代表同意&&默认&&，轻寻隐私政策和用户协议并授权轻寻获取本机号码"
                                                             attributes:@{NSFontAttributeName : [UIFont boldSystemFontOfSize:13],
                                                                          NSForegroundColorAttributeName : [XCTheme getTTMainTextColor]}];
    CMModel.appPrivacy = [self protocols];
    CMModel.privacyState = YES;
    CMModel.privacyOffsetY = @20;
    
    CMModel.webNavReturnImg = [UIImage imageNamed:@"nav_bar_back"];
    
    [[NTESQuickLoginManager sharedInstance] setupCMModel:CMModel];
}

/// 联通自定义授权 UI
- (void)setupCUCustomUI {
    NTESQuickLoginCUModel *CUModel = [[NTESQuickLoginCUModel alloc] init];
    CUModel.currentVC = self;
    CUModel.controllerType = NTESCUPresentController;
    CUModel.checkBoxValue= YES;
    CUModel.navText = @"一键登录";
    CUModel.navReturnImg = [UIImage imageNamed:@"nav_bar_back"];
    CUModel.navBottomLineHidden = YES;
    
    CUModel.appNameColor = UIColorFromRGB(0xFE4C62);
    CUModel.numberColor = UIColorFromRGB(0x2C2C2E);
    CUModel.numberFont = [UIFont boldSystemFontOfSize:20];
    CUModel.numberOffsetY = 10;
    
    CUModel.brandFont = [UIFont systemFontOfSize:14];
    CUModel.brandColor = UIColorFromRGB(0xABAAB2);
    CUModel.brandOffsetY = 10;
    
    CUModel.logoWidth = 95;
    CUModel.logoHeight = 95;
    CUModel.logoOffsetY = -30;
    
    CUModel.logBtnText = @"本机号码一键登录";
    CUModel.logBtnHeight = 48;
    CUModel.logBtnRadius = 48/2;
    CUModel.logBtnLeading = 47.5;
    CUModel.logBtnTextFont = [UIFont boldSystemFontOfSize:16];
    CUModel.logBtnTextColor = [UIColor whiteColor];
    CUModel.logBtnUsableBGColor = [XCTheme getTTMainColor];
    CUModel.logBtnUnusableBGColor = UIColorFromRGB(0xEEEDF0);
    CUModel.logBtnOffsetY = 50;
    
    CUModel.switchText = @"其他账号登录";
    CUModel.swithAccTextFont = [UIFont systemFontOfSize:15];
    CUModel.swithAccTextColor = UIColorFromRGB(0x666666);
    CUModel.swithAccOffsetY = 30;
    CUModel.swithAccOffsetX = self.view.center.x - 45;
    CUModel.swithAccHidden = YES; // 隐藏了该控件。
    
    CUModel.checkBoxNormalImg = [UIImage imageNamed:@"quickLogin_checkNormal"];
    CUModel.checkBoxCheckedImg = [UIImage imageNamed:@"quickLogin_checkSelect"];
    CUModel.checkBoxWidth = 20;
    CUModel.privacyTextColor = [XCTheme getTTMainTextColor];
    CUModel.privacyColor = UIColorFromRGB(0xFE4C62);
    CUModel.stringBeforeAppFPrivacyText = @"，轻寻";
    CUModel.appFPrivacyText = @"隐私协议";
    CUModel.stringBeforeAppSPrivacyText = @"和";
    CUModel.appSPrivacyText = @"用户协议";
    CUModel.privacyMinimumGapToScreen = 25;
    CUModel.privacyTextAlignment = NSTextAlignmentLeft;
    CUModel.privacyOffsetY = 10;
    CUModel.checkBoxOffsetY = -5;
    
    CUModel.appFPrivacyURL = [NSURL URLWithString:[self fullURL:HtmlUrlKey(kPrivacyURL)]];         // 隐私协议
    CUModel.appSPrivacyURL = [NSURL URLWithString:[self fullURL:HtmlUrlKey(kUserProtocalURL)]];    // 用户协议
    
    [[NTESQuickLoginManager sharedInstance] setupCUModel:CUModel];
}

#pragma mark - AuthCoreClient
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
    [XCHUDTool showErrorWithMessage:errorMsg];
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
                    
                    [GetCore(AuthCore) thirdLoginPlatform:SSDKPlatformTypeWechat
                                               yiDunToken:token
                                           shuMeiDeviceId:[SmAntiFraud shareInstance].getDeviceId];
                }];
            }else{
                [GetCore(AuthCore) thirdLoginPlatform:SSDKPlatformTypeWechat
                                           yiDunToken:@""
                                       shuMeiDeviceId:[SmAntiFraud shareInstance].getDeviceId];
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
                    
                    [GetCore(AuthCore) thirdLoginPlatform:SSDKPlatformTypeQQ
                                               yiDunToken:token
                                           shuMeiDeviceId:[SmAntiFraud shareInstance].getDeviceId
                                                isNewUser:NO];
                }];
            }else{
                [GetCore(AuthCore) thirdLoginPlatform:SSDKPlatformTypeQQ
                                           yiDunToken:@""
                                       shuMeiDeviceId:[SmAntiFraud shareInstance].getDeviceId
                                            isNewUser:NO];
            }
        }];
       
        
    });
}


- (void)onLoginBtnClicked:(UIButton *)sender {
    [TTStatisticsService trackEvent:@"one_click_login" eventDescribe:@"一键登录"];
    [XCHUDTool showGIFLoading];
    [self getPhoneNumber];
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

/// 苹果id 登录按钮事件
- (void)handleAuthorizationAppleIDButtonPress API_AVAILABLE(ios(13.0)) {
    [XCHUDTool showGIFLoadingInView:self.view];
    [GetCore(ClientCore) requestYDConfig:^(NSNumber *dict, NSNumber *errCode, NSString *msg) {
        if ([dict boolValue]) {
            [NTESCSGuardian getTokenWithBusinessID:LLRegisterViewYiDunLoginBusinessID completeHandler:^(NSString *token) {
                [XCHUDTool hideHUD];
                [GetCore(AuthCore) thirdLoginPlatform:SSDKPlatformTypeAppleAccount
                                           yiDunToken:token
                                       shuMeiDeviceId:[SmAntiFraud shareInstance].getDeviceId
                                            isNewUser:NO];
            }];
        }else{
            [GetCore(AuthCore) thirdLoginPlatform:SSDKPlatformTypeAppleAccount
                                       yiDunToken:@""
                                   shuMeiDeviceId:[SmAntiFraud shareInstance].getDeviceId
                                        isNewUser:NO];

        }
    }];
   
}

- (void)onOtherLoginBtnClickAction:(UIButton *)btn {
    [TTStatisticsService trackEvent:@"one_click_login_change_id" eventDescribe:@"一键登录-切换账号"];
    
    LLLoginViewController *vc = [[LLLoginViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - private method

- (void)initView {
    
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
    
    [self.view addSubview:self.appIcon];
    [self.view addSubview:self.titleLabel];
    [self.view addSubview:self.protocolView];
    [self.view addSubview:self.loginButton];
    [self.view addSubview:self.wxLoginButton];
    [self.view addSubview:self.qqLoginButton];
    [self.view addSubview:self.authAppleIDButton];
    [self.view addSubview:self.otherLoginBtn];
   
    self.isShowErrorMessage = YES;
    self.hiddenNavBar = YES;
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)initConstrations {
    [self.appIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(kNavigationHeight + 20);
        make.centerX.mas_equalTo(self.view);
        make.width.mas_equalTo(90);
        make.height.mas_equalTo(108);
    }];

    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view);
        make.top.mas_equalTo(self.appIcon.mas_bottom).offset(10);
    }];
    
    [self.loginButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.view).inset(47.5);
        make.top.mas_equalTo(self.titleLabel.mas_bottom).offset(kScale(45));
        make.height.mas_equalTo(48);
    }];
    
    [self.otherLoginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        if (@available(iOS 13.0, *)) {
            make.top.mas_equalTo(self.authAppleIDButton.mas_bottom).offset(20);
        } else {
            make.top.mas_equalTo(self.loginButton.mas_bottom).offset(20);
        }
        make.centerX.mas_equalTo(self.view);
    }];
    
    CGFloat width = [self.protocolView getViewWidth];
    [self.protocolView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view);
        make.height.mas_equalTo(16);
        make.width.mas_equalTo(width);
        make.bottom.mas_equalTo(self.view).inset(kSafeAreaBottomHeight + 100);
    }];
    
    if (projectType() != ProjectType_Planet) { // hello处CP不要第三方登录
        [self.wxLoginButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.mas_equalTo(33);
            make.bottom.mas_equalTo(self.view).offset(-(kScale(46) + kSafeAreaBottomHeight));
            make.right.mas_equalTo(self.view.mas_centerX).offset(-25);
        }];
        
        [self.qqLoginButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.mas_equalTo(33);
            make.bottom.mas_equalTo(self.view).offset(-(kScale(46) + kSafeAreaBottomHeight));
            make.left.mas_equalTo(self.view.mas_centerX).offset(25);
        }];
    }
    
    [self.authAppleIDButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.loginButton.mas_bottom).offset(20);
        make.centerX.mas_equalTo(self.view);
        make.height.mas_equalTo(48);
        make.left.right.mas_equalTo(self.view).inset(47.5);
    }];
}

- (void)judgeIsAudting {
    
    if ([ShareSDK isClientInstalled:(SSDKPlatformType)SSDKPlatformTypeQQ] &&
        [ShareSDK isClientInstalled:(SSDKPlatformType)SSDKPlatformTypeWechat]) {
        self.otherLoginBool = NO;
        
    } else if (![ShareSDK isClientInstalled:(SSDKPlatformType)SSDKPlatformTypeQQ] &&
               ![ShareSDK isClientInstalled:(SSDKPlatformType)SSDKPlatformTypeWechat]) {
        self.otherLoginBool = YES;
    }
}

- (void)goToWebview:(NSString *)url {
    TTWKWebViewViewController *webView = [[TTWKWebViewViewController alloc] init];
    webView.urlString = url;
    webView.uid = GetCore(AuthCore).getUid.longLongValue;
    [self.navigationController pushViewController:webView animated:YES];
}

/// 拼接完整的 url
/// @param urlString url地址
- (NSString *)fullURL:(NSString *)urlString {
    
    if (![urlString hasPrefix:@"http"] &&
        ![urlString hasPrefix:@"https"]){
        
        urlString = [NSString stringWithFormat:@"%@/%@",[HostUrlManager shareInstance].hostUrl, urlString];
    }
    
    if (![urlString containsString:@"?"]) {
        urlString = [NSString stringWithFormat:@"%@?platform=%@", urlString, [YYUtility appName]];
    } else {
        urlString = [NSString stringWithFormat:@"%@&platform=%@", urlString, [YYUtility appName]];
    }
    
    return urlString;
}

/// 协议组
- (NSArray *)protocols {

    NSAttributedString *privacy = [[NSAttributedString alloc] initWithString:@"隐私政策"
                                                                 attributes:@{NSLinkAttributeName:[self fullURL:HtmlUrlKey(kPrivacyURL)]}];
    
    NSAttributedString *userProtocal = [[NSAttributedString alloc] initWithString:@"用户协议"
                                                                       attributes:@{NSLinkAttributeName:[self fullURL:HtmlUrlKey(kUserProtocalURL)]}];
    return @[privacy, userProtocal];
}

/// 图片组
- (NSArray *)loginBtnImages {
    
    CGSize size = CGSizeMake(KScreenWidth - 45 * 2, 48);
    UIImage *normalImage = [self imageAddCornerWithRadius:24
                                                  andSize:size
                                                 andImage:[UIImage imageWithColor:UIColorFromRGB(0xEEEDF0)]];
    
    UIImage *selectImage = [self imageAddCornerWithRadius:24
                                                  andSize:size
                                                 andImage:[UIImage imageWithColor:[XCTheme getTTMainColor]]];
    
    UIImage *heightLightImage = [self imageAddCornerWithRadius:24
                                                       andSize:size
                                                      andImage:[UIImage imageWithColor:UIColorFromRGB(0xEEEDF0)]];
    return @[selectImage, normalImage, heightLightImage];
}

/// 获取切了圆角后的图片
/// @param radius 圆角
/// @param size 尺寸
/// @param image 需要切圆角的image
- (UIImage*)imageAddCornerWithRadius:(CGFloat)radius
                             andSize:(CGSize)size
                            andImage:(UIImage *)image{
    
    CGRect rect = CGRectMake(0, 0, size.width, size.height); UIGraphicsBeginImageContextWithOptions(size, NO, [UIScreen mainScreen].scale);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    UIBezierPath * path = [UIBezierPath bezierPathWithRoundedRect:rect byRoundingCorners:UIRectCornerAllCorners cornerRadii:CGSizeMake(radius, radius)];
    CGContextAddPath(ctx,path.CGPath);
    CGContextClip(ctx);
    [image drawInRect:rect];
    CGContextDrawPath(ctx, kCGPathFillStroke);
    UIImage * newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

#pragma mark - getters and setters

- (BOOL)isHiddenNavBar {
    return YES;
}

- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont systemFontOfSize:16];
        _titleLabel.text = @"轻松寻觅对的TA";
        _titleLabel.textColor = UIColorFromRGB(0xB3B3B3);
    }
    return _titleLabel;
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
        _loginButton.layer.cornerRadius = 24;
        [_loginButton setTitle:@"本机号码一键登录" forState:UIControlStateNormal];
        [_loginButton setTitle:@"本机号码一键登录" forState:UIControlStateSelected];
        _loginButton.titleLabel.font = [UIFont boldSystemFontOfSize:16];
        [_loginButton addTarget:self action:@selector(onLoginBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        if (projectType() == ProjectType_LookingLove) {
            [_loginButton setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
            _loginButton.backgroundColor = [XCTheme getTTMainColor];
        } else {
            _loginButton.backgroundColor = UIColorFromRGB(0xD0D0D0);
            [_loginButton setTitleColor:UIColorFromRGB(0xffffff) forState:UIControlStateNormal];
        }
        
    }
    return _loginButton;
}

- (UIButton *)wxLoginButton{
    if (!_wxLoginButton) {
        _wxLoginButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_wxLoginButton setImage:[UIImage imageNamed:@"auth_login_wechat"] forState:UIControlStateNormal];
        [_wxLoginButton setImage:[UIImage imageNamed:@"auth_login_wechat"] forState:UIControlStateSelected];
        [_wxLoginButton addTarget:self action:@selector(wechatLoginBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        _wxLoginButton.hidden = YES;
    }
    return _wxLoginButton;
}

- (UIButton *)qqLoginButton{
    if (!_qqLoginButton) {
        _qqLoginButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_qqLoginButton setImage:[UIImage imageNamed:@"auth_login_qq"] forState:UIControlStateNormal];
        [_qqLoginButton setImage:[UIImage imageNamed:@"auth_login_qq"] forState:UIControlStateSelected];
        [_qqLoginButton addTarget:self action:@selector(qqLoginBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        _qqLoginButton.hidden = YES;
    }
    return _qqLoginButton;
}

- (ASAuthorizationAppleIDButton *)authAppleIDButton  API_AVAILABLE(ios(13.0)){
    if (!_authAppleIDButton) {
        _authAppleIDButton = [[ASAuthorizationAppleIDButton alloc] initWithAuthorizationButtonType:ASAuthorizationAppleIDButtonTypeDefault authorizationButtonStyle:ASAuthorizationAppleIDButtonStyleWhiteOutline];
        [_authAppleIDButton addTarget:self action:@selector(handleAuthorizationAppleIDButtonPress) forControlEvents:UIControlEventTouchUpInside];
        _authAppleIDButton.cornerRadius = 24;
    }
    return _authAppleIDButton;
}
- (UIImageView *)appIcon {
    if (!_appIcon) {
        _appIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"login_appIcon"]];
    }
    return _appIcon;
}

- (UIButton *)otherLoginBtn {
    if (!_otherLoginBtn) {
        _otherLoginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_otherLoginBtn setTitle:@"其他账号登录" forState:UIControlStateNormal];
        [_otherLoginBtn setTitleColor:[XCTheme getTTSubTextColor] forState:UIControlStateNormal];
        [_otherLoginBtn.titleLabel setFont:[UIFont systemFontOfSize:15]];
        [_otherLoginBtn setImage:[UIImage imageNamed:@"full_triangle_arrow"] forState:UIControlStateNormal];
        _otherLoginBtn.transform = CGAffineTransformMakeScale(-1.0, 1.0);
        _otherLoginBtn.titleLabel.transform = CGAffineTransformMakeScale(-1.0, 1.0);
        _otherLoginBtn.imageView.transform = CGAffineTransformMakeScale(-1.0, 1.0);
        _otherLoginBtn.imageEdgeInsets = UIEdgeInsetsMake(0, -6.5, 0, 0);
        [_otherLoginBtn addTarget:self action:@selector(onOtherLoginBtnClickAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _otherLoginBtn;
}
@end
