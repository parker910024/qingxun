//
//  TTSetPWViewController.m
//  TuTu
//
//  Created by Macx on 2018/11/5.
//  Copyright © 2018年 YiZhuan. All rights reserved.
//

#import "TTSetPWViewController.h"
#import "TTSettingViewController.h"
#import "TTWKWebViewViewController.h"
#import "TTCodeBlueViewController.h"
//view
#import "TTPWEnterView.h"
//model
#import "UserInfo.h"
//core
#import "UserCore.h"
#import "AuthCore.h"
#import "AuthCoreClient.h"
#import "NSString+Auth.h"

//t
#import "XCTheme.h"
#import "XCKeyWordTool.h"
#import <Masonry/Masonry.h>
//cate
#import "XCHUDTool.h"

@interface TTSetPWViewController ()<AuthCoreClient>
@property (nonatomic, strong) TTPWEnterView  *pwView;//
@property (nonatomic, strong) TTPWEnterView  *againpwView;//
@property (nonatomic, strong) UIButton  *submitBtn;//
@property (nonatomic, strong) UILabel *passwordtipsLabel;
@end

@implementation TTSetPWViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initSubviews];
    
    AddCoreClient(AuthCoreClient, self);
}

- (void)initSubviews {
    [self.view addSubview:self.pwView];
    [self.view addSubview:self.againpwView];
    [self.view addSubview:self.passwordtipsLabel];
    [self.view addSubview:self.submitBtn];
    [self makeConstriants];
}

- (void)makeConstriants {
    [self.pwView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.view);
        make.top.mas_equalTo(self.mas_topLayoutGuide).offset(35);
        make.height.mas_equalTo(73);
    }];
    [self.againpwView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.view);
        make.top.mas_equalTo(self.pwView.mas_bottom).offset(10);
        make.height.mas_equalTo(73);
    }];
    
    if (self.isPayment) { // 设置支付密码木有密码强度的提示
           [self.submitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.againpwView.mas_bottom).offset(45);
            make.right.mas_equalTo(self.pwView).offset(-32);
            make.left.mas_equalTo(self.pwView).offset(32);
            make.height.mas_equalTo(45);
        }];
    } else { // 这是设置登录密码
        [self.passwordtipsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self.pwView).offset(-32);
            make.left.mas_equalTo(self.pwView).offset(32);
            make.top.mas_equalTo(self.againpwView.mas_bottom).offset(20);
        }];
        [self.submitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.passwordtipsLabel.mas_bottom).offset(45);
            make.right.mas_equalTo(self.pwView).offset(-32);
            make.left.mas_equalTo(self.pwView).offset(32);
            make.height.mas_equalTo(45);
        }];
    }
  
}

#pragma mark - AuthCoreClient
- (void)onResetPwdSuccess {
    [self doSuccess];
}

- (void)onResetPwdFailth:(NSString *)errorMsg {
    [XCHUDTool showErrorWithMessage:errorMsg];
}

- (void)onResetPaymentPwdSuccess {
    [self doSuccess];
}

- (void)onResetPaymentPwdFailth:(NSString *)errorMsg {
    [XCHUDTool showErrorWithMessage:errorMsg];
}


- (void)doSuccess {
    [XCHUDTool hideHUDInView:self.view];
    NSString *titile;
    if (self.isResetPay) {
        titile = [NSString stringWithFormat:@"重置%@密码成功",[XCKeyWordTool sharedInstance].xcz];
    }else {
       titile = self.isPayment?[NSString stringWithFormat:@"设置%@密码成功",[XCKeyWordTool sharedInstance].xcz]:@"设置登录密码成功";
    }
    [XCHUDTool showSuccessWithMessage:titile];
    for (UIViewController *VC in self.navigationController.viewControllers) {
        if ([VC isKindOfClass:[TTSettingViewController class]] ||  [VC isKindOfClass:[TTWKWebViewViewController class]]) {
            [self.navigationController popToViewController:VC animated:YES];
            return;
        }
    }
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - event
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

- (void)onClickSubmitBtn {
    
    if ([[self.pwView getContentText] isEqualToString:[self.againpwView getContentText]]) {
        if (self.isPayment){
            if ([self.pwView getContentText].length == 6) {
                // 判断是否是纯数字
                if (![self isPureNum:[self.pwView getContentText]]) {
                    [XCHUDTool showErrorWithMessage:[NSString stringWithFormat:@"新%@密码必须为纯数字",[XCKeyWordTool sharedInstance].xcz] inView:self.view];
                    return;
                }
                //支付
                [GetCore(AuthCore) resetPaymentPasswordWithPwd:[self.pwView getContentText]];
            }else {
                [XCHUDTool showErrorWithMessage:@"支付密码必须为6位的纯数字哦～" inView:self.view];
            }
            
        }else {
            //登录
            NSString *pw = [self.pwView getContentText];

            if (![pw isLengthInRange:6 max:16]) {
                [XCHUDTool showErrorWithMessage:@"登录密码长度必须6-16位" inView:self.view];
                return;
            }
            
            if (![pw isPasswordStrong]) {
                [XCHUDTool showErrorWithMessage:@"密码必须使用6-16个字符内的数字和英文字母组合" inView:self.view];
                return;
            }
            
            [GetCore(AuthCore) requestSetPwd:self.info.phone newPwd:[self.pwView getContentText]];
        }
    }else {
        [XCHUDTool showErrorWithMessage:@"两次输入的密码不一致哦" inView:self.view];
    }
    
}

/** 判断一个字符串是纯数字 */
- (BOOL)isPureNum:(NSString *)text {
    if (!text) {
        return NO;
    }
    NSScanner *scan = [NSScanner scannerWithString:text];
    int val;
    return [scan scanInt:&val] && [scan isAtEnd];
}


#pragma mark - Getter && Setter
- (void)setIsPayment:(BOOL)isPayment {
    _isPayment = isPayment;
    NSString *pwPlaceHolder;
    NSString *againPlaceHolder;
    if (_isPayment) {
        self.title = [NSString stringWithFormat:@"设置%@密码",[XCKeyWordTool sharedInstance].xcz];
        pwPlaceHolder = @"输入支付密码";
        againPlaceHolder = @"再次输入支付密码";
        self.pwView.keyboardType = UIKeyboardTypeNumberPad;
        self.againpwView.keyboardType = UIKeyboardTypeNumberPad;
        self.pwView.limitLeght = self.againpwView.limitLeght = 6;
    }else {
        self.title = @"设置登录密码";
        pwPlaceHolder = @"输入登录密码";
        againPlaceHolder = @"再次输入登录密码";
        self.pwView.keyboardType = UIKeyboardTypeASCIICapable;
        self.againpwView.keyboardType = UIKeyboardTypeASCIICapable;
        self.pwView.limitLeght = self.againpwView.limitLeght = 16;

    }
    self.pwView.placeholder = pwPlaceHolder;
    self.againpwView.placeholder = againPlaceHolder;
}

- (void)setIsResetPay:(BOOL)isResetPay {
    _isResetPay = isResetPay;
    if (_isResetPay) {
        self.title = [NSString stringWithFormat:@"重置%@密码",[XCKeyWordTool sharedInstance].xcz];
    }
}

- (TTPWEnterView *)pwView {
    if (!_pwView) {
        _pwView = [[TTPWEnterView alloc] init];
        _pwView.title = @"设置密码";
    }
    return _pwView;
}

- (TTPWEnterView *)againpwView {
    if(!_againpwView){
        _againpwView = [[TTPWEnterView alloc] init];
        _againpwView.title = @"确认密码";
    }
    return _againpwView;
}

- (UIButton *)submitBtn {
    if (!_submitBtn) {
        _submitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_submitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_submitBtn setTitle:@"确定" forState:UIControlStateNormal];
        _submitBtn.backgroundColor = [XCTheme getTTMainColor];
        _submitBtn.titleLabel.font = [UIFont systemFontOfSize:18];
        _submitBtn.layer.masksToBounds = YES;
        _submitBtn.layer.cornerRadius = 45/2;
        [_submitBtn addTarget:self action:@selector(onClickSubmitBtn) forControlEvents:UIControlEventTouchUpInside];
    }
    return _submitBtn;
}

- (UILabel *)passwordtipsLabel{
    if (!_passwordtipsLabel) {
        _passwordtipsLabel = [[UILabel alloc] init];
        _passwordtipsLabel.text = @"密码必须使用6-16个字符内的数字和英文字母组合哦！";
        _passwordtipsLabel.textColor = [UIColor lightGrayColor];
        _passwordtipsLabel.numberOfLines = 0;
    }
    return _passwordtipsLabel;
}

@end
