//
//  TTBindingXCZViewController.m
//  TuTu
//
//  Created by lee on 2018/11/6.
//  Copyright © 2018 YiZhuan. All rights reserved.
//

#import "TTBindingXCZViewController.h"

#import "TTWalletEnumConst.h"
#import <Masonry/Masonry.h>
#import "XCTheme.h"
#import "XCMacros.h"
#import "UIView+ZJFrame.h"
#import "XCHUDTool.h"
#import "XCKeyWordTool.h"

// core
#import "AuthCore.h"
#import "AuthCoreClient.h"
#import "PurseCore.h"
#import "PurseCoreClient.h"
#import "UserInfo.h"
#import "UserCore.h"

@interface TTBindingXCZViewController ()<AuthCoreClient, PurseCoreClient>

@property (nonatomic, strong) UIView *containerView;

@property (nonatomic, strong) UILabel *accountLabel;
@property (nonatomic, strong) UITextField *accountTextField;
@property (nonatomic, strong) UIView *accountLineView;

@property (nonatomic, strong) UILabel *realNameLabel;
@property (nonatomic, strong) UITextField *realNameTextField;
@property (nonatomic, strong) UIView *realNameLineView;

@property (nonatomic, strong) UITextField *authCodeTextField;
@property (nonatomic, strong) UIButton *authCodeBtn;
@property (nonatomic, strong) UIView *authCodeLineView;

@property (nonatomic, strong) UIButton *confirmBtn;

@end

@implementation TTBindingXCZViewController

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
    
    [GetCore(PurseCore) requestZXCInfo];
    @weakify(self);
    [[GetCore(UserCore) getUserInfoByUid:[GetCore(AuthCore).getUid longLongValue] refresh:YES] subscribeNext:^(id x) {
        @strongify(self);
        if ([x isKindOfClass:[UserInfo class]]) {
            UserInfo *info = (UserInfo *)x;
            self.userInfo = info;
        }
    }];
    
    [self baseUI];
    [self initViews];
    [self initConstraints];
}

#pragma mark -
#pragma mark lifeCycle
- (void)baseUI {
    if (_bindXCZAccountType == TTBindXCZAccountTypeEdit) {
        self.navigationItem.title = [NSString stringWithFormat:@"修改%@", [XCKeyWordTool sharedInstance].xczAccount];
    } else {
        self.navigationItem.title = [NSString stringWithFormat:@"绑定%@", [XCKeyWordTool sharedInstance].xczAccount];
    }
}
- (void)initViews {
    [self.view addSubview:self.containerView];
    [self.containerView addSubview:self.accountLabel];
    [self.containerView addSubview:self.accountTextField];
    [self.containerView addSubview:self.accountLineView];
    [self.containerView addSubview:self.realNameLabel];
    [self.containerView addSubview:self.realNameTextField];
    [self.containerView addSubview:self.realNameLineView];
    [self.containerView addSubview:self.authCodeTextField];
    [self.containerView addSubview:self.authCodeBtn];
    [self.containerView addSubview:self.authCodeLineView];
    [self.containerView addSubview:self.confirmBtn];
}

- (void)initConstraints {
    [self.containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        if (@available(iOS 11, *)) {
            make.left.equalTo(self.view.mas_safeAreaLayoutGuideLeft);
            make.right.equalTo(self.view.mas_safeAreaLayoutGuideRight);
            make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop);
            make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom);
        } else {
            make.edges.equalTo(self.view).insets(UIEdgeInsetsMake(kSafeTopBarHeight, 0, 0, 0));
        }
    }];
    
    [self.accountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(32);
        make.top.mas_equalTo(60);
    }];
    
    [self.accountTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(120);
        make.right.mas_equalTo(-32);
        make.bottom.mas_equalTo(self.accountLabel);
    }];
    
    [self.accountLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0).inset(32);
        make.height.mas_equalTo(1);
        make.top.mas_equalTo(self.accountLabel.mas_bottom).offset(10);
    }];
    
    [self.realNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(32);
        make.top.mas_equalTo(self.accountLineView.mas_bottom).offset(45);
    }];
    
    [self.realNameTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(120);
        make.right.mas_equalTo(-32);
        make.bottom.mas_equalTo(self.realNameLabel);
    }];
    
    [self.realNameLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.height.mas_equalTo(self.accountLineView);
        make.top.equalTo(self.realNameLabel.mas_bottom).offset(10);
    }];
    
    [self.authCodeTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(32);
        make.top.mas_equalTo(self.realNameLineView.mas_bottom).offset(45);
    }];
    
    [self.authCodeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-32);
        make.bottom.mas_equalTo(self.authCodeTextField);
        make.width.mas_equalTo(80);
        make.left.mas_equalTo(self.authCodeTextField.mas_right).offset(30);
    }];
    
    [self.authCodeLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.height.right.mas_equalTo(self.accountLineView);
        make.top.mas_equalTo(self.authCodeTextField.mas_bottom).offset(10);
    }];
    
    [self.confirmBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.authCodeLineView.mas_bottom).offset(60);
        make.height.mas_equalTo(45);
        make.left.right.mas_equalTo(0).inset(32);
    }];
}

#pragma mark -
#pragma mark TextField delegate
-(void)textFieldDidChange :(UITextField *)theTextField{
    NSUInteger subStr = 5;
    
    if (theTextField.text.length >subStr) {
        theTextField.text = [theTextField.text substringToIndex:subStr];
    }
}

#pragma mark -
#pragma mark button click events
- (void)confirmBtnClickAction:(UIButton *)btn {
    // 确认绑定
    if (self.accountTextField.text.length == 0) {
        [XCHUDTool showErrorWithMessage:@"账号不能为空" inView:self.view];
        return;
    }
    
    if (self.realNameTextField.text.length == 0) {
        [XCHUDTool showErrorWithMessage:@"真实姓名不能为空" inView:self.view];
        return;
    }
    
    if (self.authCodeTextField.text.length == 0) {
        [XCHUDTool showErrorWithMessage:@"验证码不能为空" inView:self.view];
        return;
    }
    
    [GetCore(PurseCore) bindingZXCWithAccount:_accountTextField.text accountName:_realNameTextField.text verifyCode:_authCodeTextField.text];
}

- (void)authCodeBtnClickAction:(UIButton *)btn {
    // 获取验证码
    // 保险起见，还是要判断是否已经绑定手机号码
    if (_userInfo.phone.length == 0) {
        NSAssert(NO, @"can't load user bind phoneNum or user not bind a phoneNum");
        return;
    }
    
//    type 短信类型(1、注册短信 2、登录短信 3、找回/修改密码 4、绑定手机 5、绑定xczAccount 6、验证绑定手机 7、xcz密码验证手机)
    [GetCore(PurseCore) getCodeWithPhoneNum:_userInfo.phone type:5];
    [GetCore(AuthCore) openCountdown];
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
// getSmsCode  获取短信验证码
- (void)getSmsSuccessWithMessage:(NSString *)message {
    [XCHUDTool showSuccessWithMessage:@"验证码发送成功" inView:self.view];
}

// bindXCZAccount 绑定 xcz 账号
- (void)bindingZXCStatus:(BOOL)status {
    if (status) {
        [XCHUDTool showSuccessWithMessage:@"操作成功" inView:self.view];
        
        _userInfo.isBindXCZAccount = YES;
        [GetCore(UserCore) cacheUserInfo:_userInfo complete:nil];
        
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        // 要干啥 ？

    }
}

- (void)bindingZXCFailWithMessage:(NSString *)message {
//    [UIView showError:message];
}

#pragma mark -
#pragma mark zxcAccountClient
- (void)requestZXCInfo:(ZXCInfo *)zxcInfo {
    self.zxcInfo = zxcInfo;
}
- (void)requestZXCInfoFail:(NSString *)message {
    
}

#pragma mark -
#pragma mark getter & setter
- (void)setZxcInfo:(ZXCInfo *)zxcInfo {
    _zxcInfo = zxcInfo;
    if (_zxcInfo.zxcAccountName.length && _zxcInfo.zxcAccount.length) {
        self.accountTextField.text = _zxcInfo.zxcAccount;
        self.realNameTextField.text = _zxcInfo.zxcAccountName;
//        self.accountTextField.enabled = _realNameTextField.enabled = NO;
    }

    [self.confirmBtn setTitle:@"确认修改" forState:UIControlStateNormal];
}

- (UIView *)containerView
{
    if (!_containerView) {
        _containerView = [[UIView alloc] init];
        _containerView.backgroundColor = [UIColor whiteColor];
    }
    return _containerView;
}

- (UILabel *)accountLabel
{
    if (!_accountLabel) {
        _accountLabel = [[UILabel alloc] init];
        _accountLabel.text = [NSString stringWithFormat:@"%@账号", [XCKeyWordTool sharedInstance].xczAccount];
        _accountLabel.textColor = [XCTheme getMSMainTextColor];
        _accountLabel.font = [UIFont systemFontOfSize:14.f];
        _accountLabel.adjustsFontSizeToFitWidth = YES;
    }
    return _accountLabel;
}

- (UILabel *)realNameLabel
{
    if (!_realNameLabel) {
        _realNameLabel = [[UILabel alloc] init];
        _realNameLabel.text = @"真实姓名";
        _realNameLabel.textColor = [XCTheme getMSMainTextColor];
        _realNameLabel.font = [UIFont systemFontOfSize:14.f];
        _realNameLabel.adjustsFontSizeToFitWidth = YES;
    }
    return _realNameLabel;
}

- (UIView *)accountLineView {
    if (!_accountLineView) {
        _accountLineView = [[UIView alloc] init];
        _accountLineView.backgroundColor = [XCTheme getTTSimpleGrayColor];
    }
    return _accountLineView;
}

- (UIView *)realNameLineView {
    if (!_realNameLineView) {
        _realNameLineView = [[UIView alloc] init];
        _realNameLineView.backgroundColor = [XCTheme getTTSimpleGrayColor];
    }
    return _realNameLineView;
}

- (UIView *)authCodeLineView {
    if (!_authCodeLineView) {
        _authCodeLineView = [[UIView alloc] init];
        _authCodeLineView.backgroundColor = [XCTheme getTTMainColor];
    }
    return _authCodeLineView;
}

- (UITextField *)accountTextField {
    if (!_accountTextField) {
        _accountTextField = [[UITextField alloc] init];
        _accountTextField.textColor = [XCTheme getTTMainTextColor];
        _accountTextField.font = [UIFont systemFontOfSize:14.f];
        _accountTextField.placeholder = [NSString stringWithFormat:@"输入%@账号", [XCKeyWordTool sharedInstance].xczAccount];
        _accountTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _accountTextField.borderStyle = UITextBorderStyleNone;
        _accountTextField.keyboardType = UIKeyboardTypeEmailAddress;
        _accountTextField.tintColor = [XCTheme getTTMainColor];
    }
    return _accountTextField;
}

- (UITextField *)realNameTextField {
    if (!_realNameTextField) {
        _realNameTextField = [[UITextField alloc] init];
        _realNameTextField.textColor = [XCTheme getTTMainTextColor];
        _realNameTextField.font = [UIFont systemFontOfSize:14.f];
        _realNameTextField.placeholder = @"输入实名认证的真实姓名";
        _realNameTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _realNameTextField.borderStyle = UITextBorderStyleNone;
        _realNameTextField.keyboardType = UIKeyboardTypeDefault;
        _realNameTextField.tintColor = [XCTheme getTTMainColor];
    }
    return _realNameTextField;
}

- (UITextField *)authCodeTextField {
    if (!_authCodeTextField) {
        _authCodeTextField = [[UITextField alloc] init];
        _authCodeTextField.textColor = [XCTheme getTTMainColor];
        _authCodeTextField.font = [UIFont systemFontOfSize:14.f];
        _authCodeTextField.placeholder = @"请输入验证码";
        _authCodeTextField.tintColor = [XCTheme getTTMainColor];
        _authCodeTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _authCodeTextField.borderStyle = UITextBorderStyleNone;
        _authCodeTextField.keyboardType = UIKeyboardTypeNumberPad;
        _accountTextField.tintColor = [XCTheme getTTMainColor];
        [_authCodeTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    }
    return _authCodeTextField;
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

- (UIButton *)confirmBtn {
    if (!_confirmBtn) {
        _confirmBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_confirmBtn setTitle:@"确认绑定" forState:UIControlStateNormal];
        [_confirmBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        [_confirmBtn.titleLabel setFont:[UIFont systemFontOfSize:18.f]];
        [_confirmBtn setBackgroundColor:[XCTheme getTTMainColor]];
        _confirmBtn.layer.masksToBounds = YES;
        _confirmBtn.layer.cornerRadius = 22.5f;
        [_confirmBtn addTarget:self action:@selector(confirmBtnClickAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _confirmBtn;
}


@end
