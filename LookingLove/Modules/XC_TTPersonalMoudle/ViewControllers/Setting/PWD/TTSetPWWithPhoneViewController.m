//
//  TTSetPWWithPhoneViewController.m
//  TuTu
//
//  Created by Macx on 2018/11/5.
//  Copyright © 2018年 YiZhuan. All rights reserved.
//

#import "TTSetPWWithPhoneViewController.h"
#import "TTSetPWViewController.h"
//view
#import "TTPWEnterView.h"
//model
#import "UserInfo.h"
//core
#import "PurseCore.h"
#import "PurseCoreClient.h"
#import "UserCore.h"
#import "AuthCore.h"
//t
#import "XCTheme.h"
#import "XCKeyWordTool.h"
#import <Masonry/Masonry.h>
//cate
#import "XCHUDTool.h"

#define verifyCodeLength 5 // 短信验证码 长度

@interface TTSetPWWithPhoneViewController ()<PurseCoreClient>
@property (nonatomic, strong) UserInfo  *info;//
@property (nonatomic, strong) TTPWEnterView  *phoneView;//手机号
@property (nonatomic, strong) TTPWEnterView  *verificationCodeView;//验证码
@property (nonatomic, strong) UIButton  *submitBtn;//
@end

@implementation TTSetPWWithPhoneViewController
- (void)dealloc {
    RemoveCoreClient(PurseCoreClient, self);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"验证身份";
    [[GetCore(UserCore) getUserInfoByRac:GetCore(AuthCore).getUid.longLongValue refresh:NO] subscribeNext:^(id x) {
        self.info = (UserInfo *)x;
    }];
    [self addClient];
    [self initSubviews];
}

- (void)addClient {
    AddCoreClient(PurseCoreClient, self);
}


- (void)initSubviews {
    [self.view addSubview:self.phoneView];
    [self.view addSubview:self.verificationCodeView];
    [self.view addSubview:self.submitBtn];
    [self makeConstriants];
}

- (void)makeConstriants {
    [self.phoneView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.view);
        make.top.mas_equalTo(self.mas_topLayoutGuide).offset(35);
        make.height.mas_equalTo(73);
    }];
    [self.verificationCodeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.view);
        make.top.mas_equalTo(self.phoneView.mas_bottom).offset(10);
        make.height.mas_equalTo(73);
    }];
    [self.submitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.verificationCodeView.mas_bottom).offset(45);
        make.right.mas_equalTo(self.phoneView).offset(-32);
        make.left.mas_equalTo(self.phoneView).offset(32);
        make.height.mas_equalTo(45);
    }];
}

#pragma mark - event

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

- (void)onClickSubmitBtn {

    NSString *verifyCode = [self.verificationCodeView getContentText];
    if (verifyCode.length != verifyCodeLength) {
        [XCHUDTool showErrorWithMessage:@"验证码不正确" inView:self.view];
        return;
    }
    [GetCore(PurseCore) checkMoblieCodeWithMoblie:[self.phoneView getContentText] code:verifyCode];
}

- (void)onGetCode {
    NSString *phonenumber = [self.phoneView getContentText];
    if (phonenumber.length){
        // 业务类型，必填，1注册，2登录，3重设密码，4绑定手机，5绑定支付宝，6重设支付密码，7解绑手机(验证已绑定手机)
        [GetCore(PurseCore) getCodeWithPhoneNum:phonenumber type:7];
    }
}

//获取验证码成功
- (void)getSmsSuccessWithMessage:(NSString *)message {
    [XCHUDTool showSuccessWithMessage:@"验证码发送成功" inView:self.view];
    [GetCore(AuthCore) openCountdown];
}

//获取验证码失败
- (void)getSmsFaildWithMessage:(NSString *)message {
    
}

//验证码校验成功
- (void)checkSmsSuccess {
    [XCHUDTool hideHUDInView:self.view];
    TTSetPWViewController *vc = [[TTSetPWViewController alloc] init];
    vc.isPayment = self.isPayment;
    vc.isResetPay = self.isResetPay;
    [self.navigationController pushViewController:vc animated:YES];
}

//验证码校验失败
- (void)checkSmsFail:(NSString *)message {
}


#pragma -mark - Setter && Getter

- (void)setInfo:(UserInfo *)info {
    _info = info;
    self.phoneView.contentString = _info.phone;
}

- (TTPWEnterView *)phoneView {
    if (!_phoneView) {
        _phoneView = [[TTPWEnterView alloc] init];
        _phoneView.title = @"手机号";
        _phoneView.placeholder = @"请输入您的手机号码";
        _phoneView.limitLeght = 11;
        @weakify(self)
        _phoneView.onClickCodeBtn = ^{
            @strongify(self)
            [self onGetCode];
        };
    }
    return _phoneView;
}

- (TTPWEnterView *)verificationCodeView {
    if(!_verificationCodeView){
        _verificationCodeView = [[TTPWEnterView alloc] init];
        _verificationCodeView.title = @"验证码";
        _verificationCodeView.placeholder = @"请输入您收到的验证码";
        _verificationCodeView.btnTitle = @"发送验证码";
        _verificationCodeView.limitLeght = verifyCodeLength;
        _verificationCodeView.keyboardType = UIKeyboardTypeNumberPad;
        @weakify(self)
        _verificationCodeView.onClickCodeBtn = ^{
             @strongify(self)
            [self onGetCode];
        };
    }
    return _verificationCodeView;
}

- (UIButton *)submitBtn {
    if (!_submitBtn) {
        _submitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_submitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_submitBtn setTitle:@"下一步" forState:UIControlStateNormal];
        _submitBtn.backgroundColor = [XCTheme getTTMainColor];
        _submitBtn.titleLabel.font = [UIFont systemFontOfSize:18];
        _submitBtn.layer.masksToBounds = YES;
        _submitBtn.layer.cornerRadius = 45/2;
        [_submitBtn addTarget:self action:@selector(onClickSubmitBtn) forControlEvents:UIControlEventTouchUpInside];
    }
    return _submitBtn;
}

@end
