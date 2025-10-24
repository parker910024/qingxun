//
//  TTChangePWViewController.m
//  TuTu
//
//  Created by Macx on 2018/11/5.
//  Copyright © 2018年 YiZhuan. All rights reserved.
//

#import "TTChangePWViewController.h"
#import "TTSettingViewController.h"
#import "TTSetPWWithPhoneViewController.h"
#import "TTCodeBlueViewController.h"
#import "TTWKWebViewViewController.h"
//view
#import "TTPWEnterView.h"
//model
#import "UserInfo.h"
//core
#import "AuthCore.h"
#import "AuthCoreClient.h"
#import "UserCore.h"
//cate
#import "XCHUDTool.h"
#import "UIButton+EnlargeTouchArea.h"
//t
#import "XCTheme.h"
#import <Masonry/Masonry.h>
#import "XCKeyWordTool.h"
#import "NSString+Auth.h"

//bri
#import "XCMediator+TTAuthModule.h"

@interface TTChangePWViewController ()<AuthCoreClient>
@property (nonatomic, strong) TTPWEnterView  *oldpwView;//
@property (nonatomic, strong) TTPWEnterView  *pwView;//
@property (nonatomic, strong) TTPWEnterView  *againpwView;//
@property (nonatomic, strong) UIButton  *forgetBtn;//
@property (nonatomic, strong) UIButton  *submitBtn;//
@property (nonatomic, strong) UILabel *passwordtipsLabel;

@property (nonatomic, strong) UserInfo  *info;//

@end

@implementation TTChangePWViewController

- (void)dealloc {
    RemoveCoreClient(AuthCoreClient, self);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    @weakify(self)
    [[GetCore(UserCore) getUserInfoByRac:GetCore(AuthCore).getUid.longLongValue refresh:NO] subscribeNext:^(UserInfo *x) {
        @strongify(self)
        self.info = x;
    }];
    AddCoreClient(AuthCoreClient, self);
    [self initSubviews];
}

- (void)initSubviews {
    [self.view addSubview:self.oldpwView];
    [self.view addSubview:self.pwView];
    [self.view addSubview:self.againpwView];
    [self.view addSubview:self.passwordtipsLabel];
    [self.view addSubview:self.submitBtn];
    [self.view addSubview:self.forgetBtn];
    [self makeConstriants];
}

- (void)makeConstriants {
    
    [self.oldpwView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.view);
        make.top.mas_equalTo(self.mas_topLayoutGuide).offset(35);
        make.height.mas_equalTo(73);
    }];
    [self.pwView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.view);
        make.top.mas_equalTo(self.oldpwView.mas_bottom).offset(10);
        make.height.mas_equalTo(73);
    }];
    [self.againpwView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.view);
        make.top.mas_equalTo(self.pwView.mas_bottom).offset(10);
        make.height.mas_equalTo(73);
    }];
    if (self.isPayment) { // 设置支付密码木有密码强度的提示
        [self.forgetBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self.view).offset(-32);
            make.top.mas_equalTo(self.againpwView.mas_bottom).offset(8);
        }];
        [self.submitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.againpwView.mas_bottom).offset(45);
            make.right.mas_equalTo(self.pwView).offset(-32);
            make.left.mas_equalTo(self.pwView).offset(32);
            make.height.mas_equalTo(45);
        }];
    } else { // 这是设置登录密码
        [self.passwordtipsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.againpwView.mas_bottom).offset(10);
            make.right.mas_equalTo(self.pwView).offset(-32);
            make.left.mas_equalTo(self.pwView).offset(32);
        }];
        [self.forgetBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self.view).offset(-32);
            make.top.mas_equalTo(self.passwordtipsLabel.mas_bottom).offset(8);
        }];
        [self.submitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.passwordtipsLabel.mas_bottom).offset(45);
            make.right.mas_equalTo(self.pwView).offset(-32);
            make.left.mas_equalTo(self.pwView).offset(32);
            make.height.mas_equalTo(45);
        }];
    }


}

#pragma mark - Client

- (void)onResetPaymentPwdSuccess {
    [self doSuccess];
}

- (void)onResetPaymentPwdFailth:(NSString *)errorMsg {
    [XCHUDTool hideHUDInView:self.view];
    [XCHUDTool showErrorWithMessage:errorMsg];
}

- (void)onResetPwdSuccess {
    [self doSuccess];
}

- (void)onResetPwdFailth:(NSString *)errorMsg {
    [XCHUDTool hideHUDInView:self.view];
    [XCHUDTool showErrorWithMessage:errorMsg];
}

- (void)doSuccess {
    [XCHUDTool hideHUDInView:self.view];
    NSString *titile = self.isPayment?[NSString stringWithFormat:@"修改%@密码成功",[XCKeyWordTool sharedInstance].xcz]:@"修改登录密码成功";
    [XCHUDTool showSuccessWithMessage:titile];
    for (UIViewController *VC in self.navigationController.viewControllers) {
        if ([VC isKindOfClass:[TTSettingViewController class]] || [VC isKindOfClass:[TTWKWebViewViewController class]]) {
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

- (void)onClickForgetBtn {
    if (self.isPayment) {
        TTSetPWWithPhoneViewController *pw = [[TTSetPWWithPhoneViewController alloc] init];
        pw.isPayment = YES;
        pw.isResetPay = YES;
        [self.navigationController pushViewController:pw animated:YES];
    }else {
       UIViewController *vc = [[XCMediator sharedInstance] ttAuthMoudle_forgetPasswordViewController:YES];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (void)onClickSubmitBtn {
    NSString *oldPW = [self.oldpwView getContentText];
    NSString *pw = [self.pwView getContentText];
    NSString *apw = [self.againpwView getContentText];
    
    if (![pw isEqualToString:apw]) {
        [XCHUDTool showErrorWithMessage:@"两次输入的新密码不一致哦" inView:self.view];
        return;
    }
    
    if (self.isPayment) {
        if (oldPW.length != 6) {
            [XCHUDTool showErrorWithMessage:[NSString stringWithFormat:@"当前%@密码不正确",[XCKeyWordTool sharedInstance].xcz] inView:self.view];
            return;
        }
        
        if (pw.length != 6) {
            [XCHUDTool showErrorWithMessage:[NSString stringWithFormat:@"新%@必须为6位纯数字",[XCKeyWordTool sharedInstance].xcz] inView:self.view];
            return;
        }
        
        if (![self isPureNum:pw]) {
            [XCHUDTool showErrorWithMessage:[NSString stringWithFormat:@"新%@密码必须为纯数字",[XCKeyWordTool sharedInstance].xcz] inView:self.view];
            return;
        }
        
    } else {
        if (![oldPW isLengthInRange:6 max:16]) {
            [XCHUDTool showErrorWithMessage:@"当前登录密码不正确" inView:self.view];
            return;
        }
        
        if (![pw isLengthInRange:6 max:16]) {
            [XCHUDTool showErrorWithMessage:@"新登录密码长度必须6-16位" inView:self.view];
            return;
        }
        
        if (![pw isPasswordStrong]) {
            [XCHUDTool showErrorWithMessage:@"密码必须使用6-16个字符内的数字和英文字母组合" inView:self.view];
            return;
        }
    }
    
    if ([pw isEqualToString:apw]) {
        if (self.isPayment) {
            //支付
            [GetCore(AuthCore) modifyPaymentPasswordWitholdPassword:oldPW newPassword:pw];
        } else {
            //登录
            [GetCore(AuthCore) requestModifyPwd:self.info.phone pwd:oldPW newPwd:pw];
        }
    } else {
        [XCHUDTool showErrorWithMessage:@"两次输入的新密码不一致哦" inView:self.view];
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
    NSString *oldpwPlaceHolder;
    NSString *againPlaceHolder;
    
    if (_isPayment) {
        NSString *cxz = [XCKeyWordTool sharedInstance].xcz;
        self.title = [NSString stringWithFormat:@"修改%@密码",cxz];
        oldpwPlaceHolder = [NSString stringWithFormat:@"请输入当前%@密码",cxz];
        pwPlaceHolder = [NSString stringWithFormat:@"输入%@密码",cxz];
        againPlaceHolder = [NSString stringWithFormat:@"再次输入%@密码",cxz];
        self.pwView.keyboardType = UIKeyboardTypeNumberPad;
        self.oldpwView.keyboardType = UIKeyboardTypeNumberPad;
        self.againpwView.keyboardType = UIKeyboardTypeNumberPad;
        self.pwView.limitLeght = 6;
        self.againpwView.limitLeght = 6;
        self.oldpwView.limitLeght = 6;
    }else {
        self.title = @"修改登录密码";
        oldpwPlaceHolder = @"请输入当前登录密码";
        pwPlaceHolder = @"输入登录密码";
        againPlaceHolder = @"再次输入登录密码";
        self.pwView.limitLeght = 16;
        self.againpwView.limitLeght = 16;
        self.oldpwView.limitLeght = 16;
    }
    self.oldpwView.placeholder = oldpwPlaceHolder;
    self.pwView.placeholder = pwPlaceHolder;
    self.againpwView.placeholder = againPlaceHolder;
    
}

- (TTPWEnterView *)oldpwView {
    if (!_oldpwView) {
        _oldpwView = [[TTPWEnterView alloc] init];
        _oldpwView.title = @"原密码";
    }
    return _oldpwView;
}

- (TTPWEnterView *)pwView {
    if (!_pwView) {
        _pwView = [[TTPWEnterView alloc] init];
        _pwView.title = @"新密码";
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

- (UIButton *)forgetBtn {
    if (!_forgetBtn) {
        _forgetBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_forgetBtn setEnlargeEdgeWithTop:5 right:5 bottom:5 left:5];
        [_forgetBtn setTitleColor:UIColorFromRGB(0xD1D1D2) forState:UIControlStateNormal];
        [_forgetBtn setTitle:@"忘记密码？" forState:UIControlStateNormal];
        _forgetBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        [_forgetBtn addTarget:self action:@selector(onClickForgetBtn) forControlEvents:UIControlEventTouchUpInside];
    }
    return _forgetBtn;
}

- (UILabel *)passwordtipsLabel{
    if (!_passwordtipsLabel) {
        _passwordtipsLabel = [[UILabel alloc] init];
        _passwordtipsLabel.text = @"密码必须使用6-16个字符内的数字和英文字母组合哦！";
        _passwordtipsLabel.textColor = [UIColor lightGrayColor];
        _passwordtipsLabel.numberOfLines = 0;
        _passwordtipsLabel.font = [UIFont systemFontOfSize:13];
    }
    return _passwordtipsLabel;
}


@end
