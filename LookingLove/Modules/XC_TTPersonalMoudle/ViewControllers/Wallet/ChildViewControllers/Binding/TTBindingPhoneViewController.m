//
//  TTBindingPhoneViewController.m
//  TuTu
//
//  Created by lee on 2018/11/6.
//  Copyright © 2018 YiZhuan. All rights reserved.
//
// 绑定手机号

#import "TTBindingPhoneViewController.h"
#import "TTSettingViewController.h"
#import "TTWalletEnumConst.h"

#import <Masonry/Masonry.h>
#import "XCTheme.h"
#import "XCMacros.h"
#import "UIView+ZJFrame.h"
#import "XCHUDTool.h"
#import "TTBindSuccessView.h"
#import "UIImage+Utils.h"

// core
#import "AuthCore.h"
#import "AuthCoreClient.h"
#import "PurseCore.h"
#import "PurseCoreClient.h"
#import "UserCore.h"
#import "UserCoreClient.h"

#import "UserCache.h"
#import "UserInfo.h"

@interface TTBindingPhoneViewController ()<AuthCoreClient, PurseCoreClient>

@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, strong) UILabel *areaLabel;
@property (nonatomic, strong) UIButton *countryBtn;
@property (nonatomic, strong) UIView *areaLineView;

@property (nonatomic, strong) UIView *phoneLineView;
@property (nonatomic, strong) UIView *authLineView;
@property (nonatomic, strong) UILabel *areaCodeLabel;

@property (nonatomic, strong) UIButton *authCodeBtn;
@property (nonatomic, strong) UITextField *phoneNumTextField;
@property (nonatomic, strong) UITextField *authCodeTextField;

@property (nonatomic, strong) UIButton *confirmBtn; // 确认按钮

@property (nonatomic, strong) UILabel *tipsLabel;  // 手机号丢失
@property (nonatomic, assign) BOOL isResetPhone; // 重新绑定手机
@end

@implementation TTBindingPhoneViewController

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [GetCore(AuthCore) stopCountDown];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.authCodeBtn.enabled = YES;
}

- (void)dealloc {
    RemoveCoreClientAll(self);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    AddCoreClient(AuthCoreClient, self);
    AddCoreClient(PurseCoreClient, self);
    
    @weakify(self);
    [[GetCore(UserCore) getUserInfoByUid:[GetCore(AuthCore).getUid longLongValue] refresh:YES] subscribeNext:^(id x) {
        @strongify(self);
        if ([x isKindOfClass:[UserInfo class]]) {
            UserInfo *info = (UserInfo *)x;
            self.userInfo = info;
        }
    }];
    
    [self initViews];
    [self initConstraints];
    [self baseUI];
}

#pragma mark -
#pragma mark lifeCycle
- (void)baseUI {
    
    switch (self.bindingPhoneNumType) {
        case TTBindingPhoneNumTypeEdit:
        {
            self.navigationItem.title = @"更改绑定手机";
            if (self.userInfo.isBindPhone) {
                self.phoneNumTextField.text = self.userInfo.phone;
            }
        }
            break;
        case TTBindingPhoneNumTypeNormal:
        {
            self.navigationItem.title = @"绑定手机号";
        }
            break;
        case TTBindingPhoneNumTypeUndefined:
        {
            NSAssert(NO, @"type must not be undefined! 'edit' or 'normal'");
        }
            break;
        case TTBindingPhoneNumTypeConfirm:
        {
            self.tipsLabel.hidden = NO;
            self.navigationItem.title = @"验证已绑定的手机号码";
            [self.confirmBtn setTitle:@"验证" forState:UIControlStateNormal];
            if (self.userInfo.isBindPhone) {
                _phoneNumTextField.enabled = NO;
                _phoneNumTextField.text = _userInfo.phone;
            }
        }
            break;
        default:
            break;
    }
}

- (void)initViews {
    [self.view addSubview:self.containerView];
    [self.containerView addSubview:self.areaLabel];
    [self.containerView addSubview:self.countryBtn];
    
    [self.containerView addSubview:self.areaLineView];
    [self.containerView addSubview:self.areaCodeLabel];
    [self.containerView addSubview:self.phoneNumTextField];
    [self.containerView addSubview:self.phoneLineView];
    
    [self.containerView addSubview:self.authCodeBtn];
    [self.containerView addSubview:self.authCodeTextField];
    [self.containerView addSubview:self.authLineView];
    
    [self.containerView addSubview:self.confirmBtn];
    [self.containerView addSubview:self.tipsLabel];
}

- (void)initConstraints {
    [self.containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        if (@available(iOS 11, *)) {
            make.edges.equalTo(self.view.mas_safeAreaLayoutGuide);
        } else {
            make.edges.equalTo(self.view).insets(UIEdgeInsetsMake(kSafeTopBarHeight, 0, 0, 0));
        }
    }];
    
    [self.areaLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(32);
        make.top.mas_equalTo(20);
    }];
    
    [self.countryBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-32);
        make.centerY.mas_equalTo(self.areaLabel);
    }];
    
    [self.areaLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.areaLabel.mas_bottom).offset(18);
        make.left.right.mas_equalTo(0).inset(32);
        make.height.mas_equalTo(1);
    }];
    
    [self.areaCodeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.areaLineView.mas_bottom).offset(18);
        make.left.mas_equalTo(self.areaLabel);
    }];
    
    [self.phoneNumTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(80);
        make.centerY.mas_equalTo(self.areaCodeLabel);
        make.right.mas_equalTo(self.authCodeBtn.mas_left).offset(-20);
    }];
    
    [self.authCodeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-32);
        make.centerY.mas_equalTo(self.areaCodeLabel);
    }];
    
    [self.phoneLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.height.mas_equalTo(self.areaLineView);
        make.top.mas_equalTo(self.areaCodeLabel.mas_bottom).offset(18);
    }];
    
    [self.authCodeTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0).inset(32);
        make.height.mas_equalTo(48);
        make.top.mas_equalTo(self.phoneLineView.mas_bottom);
    }];
    
    [self.authLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.left.right.mas_equalTo(self.areaLineView);
        make.top.mas_equalTo(self.authCodeTextField.mas_bottom);
    }];
    
    [self.confirmBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0).inset(32);
        make.top.mas_equalTo(self.authLineView.mas_bottom).offset(70);
        make.height.mas_equalTo(45);
    }];
    
    [self.tipsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.confirmBtn.mas_bottom).offset(36);
        make.centerX.mas_equalTo(0);
    }];
}


#pragma mark -
#pragma mark TextField delegate
-(void)textFieldDidChange :(UITextField *)theTextField{
    NSUInteger subStr = 0;
    if (theTextField == self.phoneNumTextField) {
        subStr = 11;
    } else if (theTextField == self.authCodeTextField) {
        subStr = 5;
    }
    
    if (theTextField.text.length >subStr) {
        theTextField.text = [theTextField.text substringToIndex:subStr];
    }
    
    if (self.phoneNumTextField.text.length == 11 && self.authCodeTextField.text.length == 5) {
        [self.confirmBtn setEnabled:YES];
    } else {
        [self.confirmBtn setEnabled:NO];
    }
}

#pragma mark -
#pragma mark button click events
- (void)countryBtnClickAction:(UIButton *)btn {
    // 跳转去选择国家区号
    
}

- (void)confirmBtnClickAction:(UIButton *)btn {
    // 确认绑定手机号
    if (_phoneNumTextField.text.length == 0) {
        [XCHUDTool showErrorWithMessage:@"手机号不能为空" inView:self.view];
        return;
    }
    
    if (_authCodeTextField.text.length == 0) {
        [XCHUDTool showErrorWithMessage:@"验证码不能为空" inView:self.view];
        return;
    }
    
    NSString *phoneNum = _phoneNumTextField.text;
    NSString *smsCode = _authCodeTextField.text;
    
    if (_bindingPhoneNumType == TTBindingPhoneNumTypeConfirm) {
        [GetCore(PurseCore) checkMoblieCodeWithMoblie:phoneNum code:smsCode];
    } else {
        [GetCore(PurseCore) bindingPhoneNum:phoneNum verifyCode:smsCode];
    }
    // 防止多次点击
    btn.enabled = NO;
}

- (void)authCodeBtnClickAction:(UIButton *)btn {
    // 获取验证码
    if (self.phoneNumTextField.text.length == 0) {
        [XCHUDTool showErrorWithMessage:@"手机号码不能为空" inView:self.view];
        return;
    }
    
    if (self.phoneNumTextField.text.length < 11) {
        [XCHUDTool showErrorWithMessage:@"请输入正确手机号码" inView:self.view];
        return;
    }
    
    [GetCore(AuthCore) openCountdown];
    
     // 业务类型，必填，1注册，2登录，3重设密码，4绑定手机，5绑定支付宝，6重设支付密码，7解绑手机(验证已绑定手机)
    
    if (_bindingPhoneNumType == TTBindingPhoneNumTypeConfirm) {
        //验证绑定手机号码
        [GetCore(PurseCore) getCodeWithPhoneNum:_phoneNumTextField.text type:7];
        
    } else {
        //更改绑定手机号码 or 绑定手机号码
        [GetCore(PurseCore) getCodeWithPhoneNum:_phoneNumTextField.text type:4];
    }
}

#pragma mark -
#pragma mark AuthCoreClient
- (void)onCutdownOpen:(NSNumber *)number{
    [self.authCodeBtn setTitle:[NSString stringWithFormat:@"%ds后重试", number.intValue] forState:UIControlStateDisabled];
    self.authCodeBtn.enabled = NO;
}

- (void)onCutdownFinish{
    //设置按钮的样式
    [self.authCodeBtn setTitle:@"重新发送" forState:UIControlStateNormal];
    self.authCodeBtn.enabled = YES;
}

#pragma mark -
#pragma mark PurseCoreClient
// 绑定手机号
- (void)bindingPhoneNumberSuccess {
    // 修改绑定信息
    if (self.bindingPhoneNumType == TTBindingPhoneNumTypeEdit) {
        @weakify(self);
        [TTBindSuccessView showBindSuccessViewWithHandler:^{
            @strongify(self);
    
            // 返回设置页面
           __block __kindof UIViewController *vc;
            [self.navigationController.childViewControllers enumerateObjectsUsingBlock:^(__kindof UIViewController * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if ([obj isKindOfClass:[TTSettingViewController class]]) {
                    vc = obj; // 导航控制器中有设置VC
                }
            }];
    
            if ([self.navigationController.childViewControllers containsObject:vc]) {
                [self.navigationController popToViewController:vc animated:YES];
            } else {
                [self.navigationController popViewControllerAnimated:YES];
            }
        }];
    } else if (self.bindingPhoneNumType == TTBindingPhoneNumTypeNormal) {
        @weakify(self);
        [TTBindSuccessView showBindSuccessViewWithHandler:^{
            @strongify(self);
            [self.navigationController popViewControllerAnimated:YES];
        }];
    }
    self.confirmBtn.enabled = YES; // 打开交互
}

- (void)bindingPhoneNumberFailth:(NSString *)message {
    self.confirmBtn.enabled = YES; // 打开交互
}

// 验证当前绑定手机号
- (void)checkSmsSuccess {
    [XCHUDTool showSuccessWithMessage:@"验证成功" inView:self.view];
    
    TTBindingPhoneViewController *vc = [[TTBindingPhoneViewController alloc] init];
    vc.bindingPhoneNumType = TTBindingPhoneNumTypeEdit;
    vc.userInfo = _userInfo;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)checkSmsFail:(NSString *)message {
//    [UIView showToastInKeyWindow:message duration:2.0];
    self.confirmBtn.enabled = YES;
}

// getCodeWithPhoneNum 根据手机号码获取验证码
- (void)getSmsSuccessWithMessage:(NSString *)message {
    [XCHUDTool showSuccessWithMessage:@"验证码发送成功" inView:self.view];
}

- (void)getSmsFaildWithMessage:(NSString *)message {
//    [UIView showToastInKeyWindow:message duration:2.0];
    // 不能再写，会重复提示
}


#pragma mark -
#pragma mark getter & setter
- (UIView *)containerView
{
    if (!_containerView) {
        _containerView = [[UIView alloc] init];
        _containerView.backgroundColor = [UIColor whiteColor];
    }
    return _containerView;
}

- (UILabel *)areaLabel
{
    if (!_areaLabel) {
        _areaLabel = [[UILabel alloc] init];
        _areaLabel.text = @"国家和地区";
        _areaLabel.textColor = [XCTheme getTTDeepGrayTextColor];
        _areaLabel.font = [UIFont systemFontOfSize:14.f];
        _areaLabel.adjustsFontSizeToFitWidth = YES;
    }
    return _areaLabel;
}

- (UILabel *)areaCodeLabel
{
    if (!_areaCodeLabel) {
        _areaCodeLabel = [[UILabel alloc] init];
        _areaCodeLabel.text = @"+86";
        _areaCodeLabel.textColor = [XCTheme getTTDeepGrayTextColor];
        _areaCodeLabel.font = [UIFont systemFontOfSize:14.f];
        _areaCodeLabel.adjustsFontSizeToFitWidth = YES;
    }
    return _areaCodeLabel;
}

- (UIButton *)countryBtn {
    if (!_countryBtn) {
        _countryBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_countryBtn setTitle:@"中国" forState:UIControlStateNormal];
        [_countryBtn setImage:[UIImage imageNamed:@"person_arrow"] forState:UIControlStateNormal];
        _countryBtn.transform = CGAffineTransformMakeScale(-1.0, 1.0);
        _countryBtn.titleLabel.transform = CGAffineTransformMakeScale(-1.0, 1.0);
        _countryBtn.imageView.transform = CGAffineTransformMakeScale(-1.0, 1.0);
        _countryBtn.imageEdgeInsets = UIEdgeInsetsMake(0, -10, 0, 0);
        [_countryBtn setTitleColor:[XCTheme getTTDeepGrayTextColor] forState:UIControlStateNormal];
        [_countryBtn.titleLabel setFont:[UIFont systemFontOfSize:14.f]];
        [_countryBtn addTarget:self action:@selector(countryBtnClickAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _countryBtn;
}

- (UIButton *)confirmBtn {
    if (!_confirmBtn) {
        _confirmBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_confirmBtn setTitle:@"绑定" forState:UIControlStateNormal];
        UIImage *normalImg = [UIImage imageWithColor:[XCTheme getTTMainColor]];
        UIImage *disabledImg = [UIImage imageWithColor:UIColorFromRGB(0xE5E5E5)];
        [_confirmBtn setBackgroundImage:normalImg forState:UIControlStateNormal];
        [_confirmBtn setBackgroundImage:disabledImg forState:UIControlStateDisabled];
        [_confirmBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        [_confirmBtn.titleLabel setFont:[UIFont systemFontOfSize:18.f]];
        _confirmBtn.layer.cornerRadius = 22.5f;
        _confirmBtn.layer.masksToBounds = YES;
        _confirmBtn.enabled = NO;
        [_confirmBtn addTarget:self action:@selector(confirmBtnClickAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _confirmBtn;
}

- (UIButton *)authCodeBtn {
    if (!_authCodeBtn) {
        _authCodeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_authCodeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
        [_authCodeBtn setTitleColor:[XCTheme getTTMainColor] forState:UIControlStateNormal];
        [_authCodeBtn setTitleColor:[XCTheme getTTMainColor] forState:UIControlStateDisabled];
        [_authCodeBtn.titleLabel setFont:[UIFont systemFontOfSize:12.f]];
        [_authCodeBtn addTarget:self action:@selector(authCodeBtnClickAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _authCodeBtn;
}

- (UITextField *)phoneNumTextField {
    if (!_phoneNumTextField) {
        _phoneNumTextField = [[UITextField alloc] init];
        _phoneNumTextField.textColor = [XCTheme getTTMainTextColor];
        _phoneNumTextField.font = [UIFont systemFontOfSize:14.f];
//        _phoneNumTextField.placeholder = @"输入手机号";
        _phoneNumTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"输入手机号"attributes:@{NSForegroundColorAttributeName: [XCTheme getTTDeepGrayTextColor]}];
        _phoneNumTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _phoneNumTextField.borderStyle = UITextBorderStyleNone;
        _phoneNumTextField.keyboardType = UIKeyboardTypeNumberPad;
        _phoneNumTextField.tintColor = [XCTheme getTTMainColor];
        [_phoneNumTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];

    }
    return _phoneNumTextField;
}

- (UITextField *)authCodeTextField {
    if (!_authCodeTextField) {
        _authCodeTextField = [[UITextField alloc] init];
        _authCodeTextField.textColor = [XCTheme getTTMainTextColor];
        _authCodeTextField.font = [UIFont systemFontOfSize:14.f];
//        _authCodeTextField.placeholder = @"输入验证码";
        _authCodeTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"输入验证码"attributes:@{NSForegroundColorAttributeName: [XCTheme getTTDeepGrayTextColor]}];
        _authCodeTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _authCodeTextField.borderStyle = UITextBorderStyleNone;
        _authCodeTextField.keyboardType = UIKeyboardTypeNumberPad;
        _authCodeTextField.tintColor = [XCTheme getTTMainColor];
        [_authCodeTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];

    }
    return _authCodeTextField;
}

- (UIView *)areaLineView {
    if (!_areaLineView) {
        _areaLineView = [[UIView alloc] init];
        _areaLineView.backgroundColor = UIColorFromRGB(0xFAFAFA);
    }
    return _areaLineView;
}

- (UIView *)phoneLineView {
    if (!_phoneLineView) {
        _phoneLineView = [[UIView alloc] init];
        _phoneLineView.backgroundColor = UIColorFromRGB(0xFAFAFA);
    }
    return _phoneLineView;
}

- (UIView *)authLineView {
    if (!_authLineView) {
        _authLineView = [[UIView alloc] init];
        _authLineView.backgroundColor = UIColorFromRGB(0xFAFAFA);
    }
    return _authLineView;
}

- (UILabel *)tipsLabel
{
    if (!_tipsLabel) {
        _tipsLabel = [[UILabel alloc] init];
        _tipsLabel.text = @"如果您的手机号已丢失\n请联系客服微信：qingxun2019";
        _tipsLabel.textColor = [XCTheme getTTDeepGrayTextColor];
        _tipsLabel.font = [UIFont systemFontOfSize:14.f];
        _tipsLabel.adjustsFontSizeToFitWidth = YES;
        _tipsLabel.numberOfLines = 0;
        _tipsLabel.hidden = YES;
    }
    return _tipsLabel;
}

@end
