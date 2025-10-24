//
//  TTPayPwdViewController.m
//  XC_TTPersonalMoudle
//
//  Created by lvjunhang on 2020/3/18.
//  Copyright © 2020 WUJIE INTERACTIVE. All rights reserved.
//

#import "TTPayPwdViewController.h"
#import "TTPayPwdInputView.h"

#import "UserInfo.h"
#import "UserCore.h"
#import "AuthCore.h"
#import "AuthCoreClient.h"
#import "PurseCore.h"
#import "PurseCoreClient.h"

#import "XCTheme.h"
#import "XCKeyWordTool.h"
#import "XCHUDTool.h"
#import "NSString+Auth.h"
#import "XCKeyWordTool.h"

#import <Masonry/Masonry.h>

@interface TTPayPwdViewController ()<AuthCoreClient, PurseCoreClient>
@property (nonatomic, strong) TTPayPwdInputView *pwdInputView;//设置支付密码
@property (nonatomic, strong) TTPayPwdInputView *repeatPwdInputView;//再次输入支付密码
@property (nonatomic, strong) TTPayPwdInputView *verificationCodeInputView;//请输入验证码
@property (nonatomic, strong) UIButton *submitButton;//提交按钮
@property (nonatomic, strong) UILabel *tipsLabel;
@end

@implementation TTPayPwdViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initSubviews];
    
    self.title = [NSString stringWithFormat:@"设置%@密码", [self payKeyword]];
    
    AddCoreClient(AuthCoreClient, self);
    AddCoreClient(PurseCoreClient, self);
    
    //获取验证码
    @weakify(self)
    [self.verificationCodeInputView setFetchVerificationHandler:^{
        @strongify(self)
        if ([[self phoneNumber] length] == 0) {
            [XCHUDTool showErrorWithMessage:@"获取手机号失败" inView:self.view];
            return;
        }
        
        self.tipsLabel.hidden = YES;
        
        //请求验证码
        [GetCore(PurseCore) getCodeWithPhoneNum:[self phoneNumber] type:6];
    }];
}

- (void)initSubviews {
    [self.view addSubview:self.pwdInputView];
    [self.view addSubview:self.repeatPwdInputView];
    [self.view addSubview:self.verificationCodeInputView];
    [self.view addSubview:self.tipsLabel];
    [self.view addSubview:self.submitButton];
    [self makeConstriants];
}

- (void)makeConstriants {
    [self.pwdInputView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_topLayoutGuide);
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(70);
    }];
    
    [self.repeatPwdInputView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.pwdInputView.mas_bottom);
        make.left.right.height.mas_equalTo(self.pwdInputView);
    }];
    
    [self.verificationCodeInputView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.repeatPwdInputView.mas_bottom);
        make.left.right.height.mas_equalTo(self.pwdInputView);
    }];
    
    [self.submitButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.verificationCodeInputView.mas_bottom).offset(86);
        make.left.right.mas_equalTo(self.view).inset(36);
        make.height.mas_equalTo(44);
    }];
    
    [self.tipsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.verificationCodeInputView.mas_bottom).offset(20);
        make.left.right.mas_equalTo(self.view).inset(25);
    }];
}

#pragma mark - AuthCoreClient
- (void)onCutdownOpen:(NSNumber *)number {
    [self.verificationCodeInputView verificationCountdownUpdate:number.integerValue];
}

- (void)onCutdownFinish {
    [self.verificationCodeInputView verificationCountdownFinish];
}

//设置支付密码
- (void)onSetPayPwd:(BOOL)success errorCode:(NSNumber *)code msg:(NSString *)msg {
        
    if (!success) {
        [XCHUDTool showErrorWithMessage:msg];
        return;
    }
    
    NSString *message = [NSString stringWithFormat:@"设置%@密码成功",[self payKeyword]];
    [XCHUDTool showSuccessWithMessage:message];
    
    @weakify(self)
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        @strongify(self)
        [self.navigationController popViewControllerAnimated:YES];
    });
}

#pragma mark - PurseCoreClient
//获取验证码成功
- (void)getSmsSuccessWithMessage:(NSString *)message {
    self.tipsLabel.hidden = NO;
    [XCHUDTool showSuccessWithMessage:@"验证码发送成功"];
    [GetCore(AuthCore) openCountdown];
}

//获取验证码失败
- (void)getSmsFaildWithMessage:(NSString *)message {
    self.tipsLabel.hidden = YES;
    [XCHUDTool showErrorWithMessage:message];
}

#pragma mark - event
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

- (void)onClickSubmitButton {
    [self.view endEditing:YES];
    
    NSString *pwd = [self.pwdInputView contentText];
    NSString *repeatPwd = [self.repeatPwdInputView contentText];
    NSString *code = [self.verificationCodeInputView contentText];

    // 位数校验
    if (pwd.length != 6) {
        NSString *msg = [NSString stringWithFormat:@"%@密码必须为6位的纯数字哦～",[self payKeyword]];
        [XCHUDTool showErrorWithMessage:msg];
        return;
    }
    
    // 纯数字校验
    if (![self isPureNum:pwd]) {
        NSString *msg = [NSString stringWithFormat:@"%@密码必须为纯数字",[self payKeyword]];
        [XCHUDTool showErrorWithMessage:msg];
        return;
    }
    
    // 重复密码校验
    if (![pwd isEqualToString:repeatPwd]) {
        [XCHUDTool showErrorWithMessage:@"两次输入密码不一致"];
        return;
    }
    
    if (code.length == 0) {
        [XCHUDTool showErrorWithMessage:@"请输入验证码"];
        return;
    }
    
    //设置密码
    [GetCore(AuthCore) requestSetPayPwd:pwd phone:[self phoneNumber] verifyCode:code];
}

#pragma mark - Private
/** 判断一个字符串是纯数字 */
- (BOOL)isPureNum:(NSString *)text {
    if (!text) {
        return NO;
    }
    
    NSScanner *scan = [NSScanner scannerWithString:text];
    int val;
    return [scan scanInt:&val] && [scan isAtEnd];
}

/// 支付
- (NSString *)payKeyword {
    NSString *const pay = [XCKeyWordTool sharedInstance].xcz;
    return pay;
}

- (NSString *)phoneNumber {
    UserInfo *info = [GetCore(UserCore) getUserInfoInDB:[GetCore(AuthCore) getUid].userIDValue];
    return info.phone;
}

#pragma mark - Getter && Setter

- (TTPayPwdInputView *)pwdInputView {
    if (!_pwdInputView) {
        _pwdInputView = [[TTPayPwdInputView alloc] init];
        _pwdInputView.type = TTPayPwdInputViewTypePwd;
    }
    return _pwdInputView;
}

- (TTPayPwdInputView *)repeatPwdInputView {
    if (!_repeatPwdInputView) {
        _repeatPwdInputView = [[TTPayPwdInputView alloc] init];
        _repeatPwdInputView.type = TTPayPwdInputViewTypeRepeatPwd;

    }
    return _repeatPwdInputView;
}

- (TTPayPwdInputView *)verificationCodeInputView {
    if (!_verificationCodeInputView) {
        _verificationCodeInputView = [[TTPayPwdInputView alloc] init];
        _verificationCodeInputView.type = TTPayPwdInputViewTypeVerification;
    }
    return _verificationCodeInputView;
}

- (UIButton *)submitButton {
    if (!_submitButton) {
        _submitButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_submitButton setTitleColor:[XCTheme getTTMainTextColor] forState:UIControlStateNormal];
        [_submitButton setTitle:@"确定" forState:UIControlStateNormal];
        _submitButton.titleLabel.font = [UIFont systemFontOfSize:15];
        _submitButton.layer.masksToBounds = YES;
        _submitButton.layer.cornerRadius = 44/2;
        _submitButton.layer.borderColor = [XCTheme getTTMainTextColor].CGColor;
        _submitButton.layer.borderWidth = 2;
        [_submitButton addTarget:self action:@selector(onClickSubmitButton) forControlEvents:UIControlEventTouchUpInside];
    }
    return _submitButton;
}

- (UILabel *)tipsLabel {
    if (!_tipsLabel) {
        _tipsLabel = [[UILabel alloc] init];
        _tipsLabel.textColor = UIColorFromRGB(0xFE4C62);
        _tipsLabel.font = [UIFont systemFontOfSize:13];
        _tipsLabel.numberOfLines = 0;
        _tipsLabel.hidden = YES;
        
        NSString *phonePrefix = [[self phoneNumber] substringToIndex:3];
        NSString *phoneSuffix = [[self phoneNumber] substringFromIndex:7];
        _tipsLabel.text = [NSString stringWithFormat:@"验证码已发送至您绑定的手机%@****%@", phonePrefix, phoneSuffix];
    }
    return _tipsLabel;
}

@end
