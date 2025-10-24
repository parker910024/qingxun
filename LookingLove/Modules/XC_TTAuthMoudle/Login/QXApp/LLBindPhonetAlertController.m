//
//  LLBindPhonetAlertController.h
//  XC_TTAuthMoudle
//
//  Created by apple on 2019/7/29.
//  Copyright © 2019 YiZhuan. All rights reserved.
//

#import "LLBindPhonetAlertController.h"

#import "TTUserProtocolView.h"
#import "TTAuthEditView.h"

// core
#import "AuthCore.h"
#import "AuthCoreClient.h"
#import "PurseCore.h"
#import "PurseCoreClient.h"
#import "NSString+Auth.h"

#import "XCTheme.h"
#import <Masonry/Masonry.h>
#import "XCHUDTool.h"
#import "TTBindSuccessView.h"
#import "XCHtmlUrl.h"

@interface LLBindPhonetAlertController ()<AuthCoreClient, TTUserProtocolViewDelegate, UITextFieldDelegate, PurseCoreClient, UIGestureRecognizerDelegate>
/** 标题 */
@property (nonatomic, strong) UILabel * titleLabel;
/** 手机号 */
@property (nonatomic, strong) TTAuthEditView *phoneEditView;
/** 手机号 下划线 */
@property (nonatomic, strong) UIView *phoneEditLineView;
/** code */
@property (nonatomic, strong) TTAuthEditView *codeEditView;
/** code  下划线*/
@property (nonatomic, strong) UIView *codeEditLineView;
/** 注册 */
@property (nonatomic, strong) UIButton *registButton;
@property (nonatomic, strong) UIView *authMaskView;
@property (nonatomic, strong) UILabel *passwordtipsLabel;
@property (nonatomic, strong) UIButton *skipBtn;
@property (nonatomic, assign) BOOL isBindPhoneSuccess; // 主要用于埋点
@property (nonatomic, weak) id<UIGestureRecognizerDelegate> savedGestureRecognizerDelegate;
@property (nonatomic, strong) UIButton *backBtn;

@end

@implementation LLBindPhonetAlertController

#pragma mark - life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initView];
    [self initConstrations];
//    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"nav_bar_back"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(goBack)];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.backBtn];
    
    self.view.backgroundColor = UIColor.whiteColor;
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    self.navigationController.interactivePopGestureRecognizer.delegate = self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.codeEditView.authCodeButton.enabled = YES;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [GetCore(AuthCore) stopCountDown];
}

- (void)dealloc {
    if (!self.isBindPhoneSuccess) {
        [[BaiduMobStat defaultStat] logEvent:@"binding_phone_skip" eventLabel:@"绑定手机--跳过"];
    }
    if (self.dismissBlcok) {
        self.dismissBlcok();
    }
    RemoveCoreClientAll(self);
}

// 点击返回按钮
- (void)goBack {
    // 如果是可以发布状态，说明是有填写内容
    [GetCore(AuthCore) logout];
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    if (gestureRecognizer == self.navigationController.interactivePopGestureRecognizer &&
        [self isKindOfClass:[LLBindPhonetAlertController class]]) {
        [GetCore(AuthCore) logout];
        return NO;
    }
    return YES;
}

#pragma mark - public methods

#pragma mark - UITextFieldDelegate
- (void)textFieldDidChange :(UITextField *)theTextField{
    NSUInteger subStr = 0;
    if (theTextField == self.phoneEditView.textField) {
        subStr = 11;
    } else if (theTextField == self.codeEditView.textField) {
        subStr = 5;
    }
    
    if (theTextField.text.length >subStr) {
        theTextField.text = [theTextField.text substringToIndex:subStr];
    }
    
    if (self.phoneEditView.textField.text.length == 11 && self.codeEditView.textField.text.length == 5) {
        [self setRegisterButtonStatus:YES];
    } else {
        [self setRegisterButtonStatus:NO];
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
- (void)bindingPhoneNumberSuccess {
    self.isBindPhoneSuccess = YES;
    [XCHUDTool hideHUDInView:self.view];
    @weakify(self);
    [TTBindSuccessView showBindSuccessViewWithHandler:^{
        @strongify(self);
        [self dismissController];
    }];
}

- (void)bindingPhoneNumberFailth:(NSString *)message {
    [XCHUDTool showErrorWithMessage:message inView:self.view];
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

#pragma mark - event response

- (void)onRegisterBtnClicked:(UIButton *)sender {
    if (self.phoneEditView.textField.text.length == 0) {
        return;
    }
    NSString *phone = self.phoneEditView.textField.text;
    NSString *smsCode = self.codeEditView.textField.text;
    [self keyboardHide:nil];
    [GetCore(PurseCore) bindingPhoneNum:phone verifyCode:smsCode];
    [XCHUDTool showGIFLoadingInView:self.view];
}

- (void)keyboardHide:(UITapGestureRecognizer*)tap{
    [self.phoneEditView.textField resignFirstResponder];
    [self.codeEditView.textField resignFirstResponder];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (textField == self.phoneEditView.textField || textField == self.codeEditView.textField) {
        NSString *regex =@"[0-9]*";
        NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
        if ([pred evaluateWithObject:string]) {
            return YES;
        }
        return NO;
    }
    return YES;
}

- (void)onSkipBtnClicked:(UIButton *)sender {
    [self dismissController];
}

#pragma mark - private method

- (void)dismissController {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)initView {
    [self.view addSubview:self.titleLabel];
    [self.view addSubview:self.phoneEditView];
    [self.view addSubview:self.phoneEditLineView];
    [self.view addSubview:self.authMaskView];
    [self.view addSubview:self.codeEditView];
    [self.view addSubview:self.codeEditLineView];
    [self.view addSubview:self.passwordtipsLabel];
    [self.view addSubview:self.registButton];
    [self.view addSubview:self.skipBtn];
    
//    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(keyboardHide:)];
//    //设置成NO表示当前控件响应后会传播到其他控件上，默认为YES。
//    tapGestureRecognizer.cancelsTouchesInView = NO;
//    //将触摸事件添加到当前view
//    [self.view addGestureRecognizer:tapGestureRecognizer];
    
    AddCoreClient(AuthCoreClient, self);
    AddCoreClient(PurseCoreClient, self);
    
    @KWeakify(self);
    self.codeEditView.rightButtonDidClickBlcok = ^(UIButton *button) {
        @KStrongify(self);
        if (self.phoneEditView.textField.text.length != 11) {
            [XCHUDTool showErrorWithMessage:@"请输入正确的手机号" inView:self.view];
            return;
        }
        
        //        [GetCore(PurseCore) getCodeWithMobileNum:self.phoneEditView.textField.text type:1];
        [GetCore(PurseCore) getCodeWithPhoneNum:self.phoneEditView.textField.text type:4];
        //        [GetCore(AuthCore) requestRegistSmsCode:self.phoneEditView.textField.text];
    };
}

- (void)initConstrations {
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(kNavigationHeight + 21);
        make.left.mas_equalTo(26);
    }];
    
    [self.phoneEditView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(11);
        make.right.mas_equalTo(-26);
        make.top.mas_equalTo(self.titleLabel.mas_bottom).offset(38);
        make.height.mas_equalTo(45);
    }];
    
    [self.phoneEditLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.view).inset(26);
        make.top.mas_equalTo(self.phoneEditView.mas_bottom);
        make.height.mas_equalTo(1);
    }];
    
    [self.codeEditView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.height.mas_equalTo(self.phoneEditView);
        make.top.mas_equalTo(self.phoneEditView.mas_bottom).offset(26);
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
        make.left.right.mas_equalTo(self.view).inset(38);
        make.top.mas_equalTo(self.codeEditView.mas_bottom).offset(59);
        make.height.mas_equalTo(44);
    }];
    
    [self.skipBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.registButton);
        make.bottom.mas_equalTo(self.view).offset(-50);
        make.height.mas_equalTo(44);
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
    if (self.phoneEditView.textField.text.length == 11 && self.codeEditView.textField.text.length == 5) {
        [self setRegisterButtonStatus:YES];
    } else {
        [self setRegisterButtonStatus:NO];
    }
}

#pragma mark - getters and setters
- (UIButton *)registButton {
    if (!_registButton) {
        _registButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _registButton.layer.masksToBounds = YES;
        _registButton.layer.cornerRadius = 22;
        [_registButton setTitle:@"绑定" forState:UIControlStateNormal];
        [_registButton setTitle:@"绑定" forState:UIControlStateSelected];
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

- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont boldSystemFontOfSize:25];
        _titleLabel.text = @"绑定手机号";
        _titleLabel.textColor = [XCTheme getTTMainTextColor];
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

- (UIView *)phoneEditLineView {
    if (!_phoneEditLineView) {
        _phoneEditLineView = [[UIView alloc] init];
        _phoneEditLineView.backgroundColor = UIColorFromRGB(0xcccccc);
    }
    return _phoneEditLineView;
}

- (TTAuthEditView *)codeEditView {
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

- (UIView *)codeEditLineView {
    if (!_codeEditLineView) {
        _codeEditLineView = [[UIView alloc] init];
        _codeEditLineView.backgroundColor = UIColorFromRGB(0xcccccc);
    }
    return _codeEditLineView;
}

- (UIView *)authMaskView {
    if (!_authMaskView) {
        _authMaskView = [[UIView alloc] init];
        _authMaskView.backgroundColor = UIColorFromRGB(0xffffff);
    }
    return _authMaskView;
}

- (UIButton *)skipBtn {
    if (!_skipBtn) {
        _skipBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_skipBtn setBackgroundColor:[UIColor clearColor]];
        [_skipBtn setTitle:@"跳过" forState:UIControlStateNormal];
        [_skipBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [_skipBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateSelected];
        _skipBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [_skipBtn addTarget:self action:@selector(onSkipBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        _skipBtn.hidden = YES;
    }
    return _skipBtn;
}

- (UIButton *)backBtn {
    if (!_backBtn) {
        _backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _backBtn.frame = CGRectMake(0, 0, 100, 44);
        [_backBtn setImage:[UIImage imageNamed:@"nav_bar_back"] forState:UIControlStateNormal];
        [_backBtn setTitle:@"返回登录页" forState:UIControlStateNormal];
        [_backBtn setTitleColor:[XCTheme getTTMainTextColor] forState:UIControlStateNormal];
        [_backBtn.titleLabel setFont:[UIFont systemFontOfSize:14]];
        [_backBtn addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
    }
    return _backBtn;
}

@end
