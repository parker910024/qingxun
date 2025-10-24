//
//  TTQQBindViewController.m
//  TuTu
//
//  Created by Macx on 2018/10/30.
//  Copyright © 2018 YiZhuan. All rights reserved.
//

#import "TTQQBindViewController.h"

#import "XCWKWebViewController.h"

#import "TTAuthEditView.h"

#import "AuthCore.h"
#import "AuthCoreClient.h"
#import "HomeCore.h"

#import "XCTheme.h"
#import "XCHUDTool.h"
#import <Masonry/Masonry.h>
#import "XCHtmlUrl.h"
#import "XCKeyWordTool.h"

@interface TTQQBindViewController ()<UITextFieldDelegate, AuthCoreClient>
/** 标题*/
@property (nonatomic, strong) UILabel * titleLabel;
/** 手机号输入框*/
@property (nonatomic, strong) TTAuthEditView *erbanIdEditView;
/** password*/
@property (nonatomic, strong) TTAuthEditView *passwordEditView;
/** 登录提示*/
@property (nonatomic, strong) UILabel *loginTipLabel;
@property (nonatomic, strong) UIButton *loginTipButton;
/** 绑定*/
@property (nonatomic, strong) UIButton *bindButton;
@property (nonatomic, copy) NSString *erbanId;
@property (nonatomic, copy) NSString *password;
@end

@implementation TTQQBindViewController

#pragma mark - life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"登录";
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    RemoveCoreClientAll(self);
}

#pragma mark - public methods

#pragma mark - UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (textField == self.passwordEditView.textField){
        if ([string isEqualToString:@" "]) {
            return NO;
        }
    }
    return YES;
}

- (void)textFieldDidChange:(UITextField *)textFiled{
    if (textFiled.text.length >16) {
        textFiled.text = [textFiled.text substringToIndex:16];
    }
    if (textFiled == self.erbanIdEditView.textField) {
        self.erbanId = textFiled.text;
    }else if (textFiled == self.passwordEditView.textField){
        self.password = textFiled.text;
    }
    
    if (self.password.length > 0 && self.erbanId.length > 0) {
        [self.bindButton setBackgroundColor:[XCTheme getTTMainColor]];
    } else {
        [self.bindButton setBackgroundColor:UIColorFromRGB(0xdbdbdb)];
    }
}

#pragma mark - AuthCoreClient
- (void)onLoginSuccess{
    [XCHUDTool hideHUDInView:self.view];
    if (GetCore(AuthCore).getUid.userIDValue>0) {
        [GetCore(HomeCore) requestHomeTag];
    }
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    
}

- (void)onLoginFailth:(NSString *)errorMsg{
    [XCHUDTool showErrorWithMessage:errorMsg inView:self.view];
}

#pragma mark - [core相关的Protocol]  //注意要把名字改掉，这个MARK只做功能划分，不是一个真正的MARK，每个不一样的Protocol，需要一个新的MARK”

#pragma mark - event response
- (void)bindErBanAccountAction:(UIButton *)sender{
    if (self.erbanId.length > 0 && self.password.length > 0) {
        [XCHUDTool showGIFLoadingInView:self.view];
        [GetCore(AuthCore) loginWithErbanAccount:self.erbanId password:self.password qqOpenid:self.qqOpenid];
    }
}

- (void)loginTipButtonAction:(UIButton *)sender {
    XCWKWebViewController *vc = [[XCWKWebViewController alloc]init];
    vc.urlString = HtmlUrlKey(kQQloginGuideURL); //kQQloginGuideURL
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - private method

- (void)initView {
    [self.view addSubview:self.titleLabel];
    [self.view addSubview:self.erbanIdEditView];
    [self.view addSubview:self.passwordEditView];
    [self.view addSubview:self.loginTipLabel];
    [self.view addSubview:self.loginTipButton];
    [self.view addSubview:self.bindButton];
}

- (void)initConstrations {
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        if (@available(iOS 11, *)) {
            make.top.mas_equalTo(self.view.mas_safeAreaLayoutGuideTop).offset(13 + statusbarHeight);
        }else{
            make.top.mas_equalTo(self.view).offset(13 + statusbarHeight);
        }
        make.centerX.mas_equalTo(self.view);
    }];
    
    [self.erbanIdEditView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.view).inset(48);
        make.top.mas_equalTo(self.titleLabel.mas_bottom).offset(16);
        make.height.mas_equalTo(44);
    }];
    
    [self.passwordEditView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.view).inset(48);
        make.top.mas_equalTo(self.erbanIdEditView.mas_bottom).offset(20);
        make.height.mas_equalTo(44);
    }];
    
    [self.bindButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.view).inset(48);
        make.top.mas_equalTo(self.passwordEditView.mas_bottom).offset(20);
        make.height.mas_equalTo(43);
    }];
    
    [self.loginTipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.view).inset(48);
        make.top.mas_equalTo(self.bindButton.mas_bottom).offset(20);
    }];
    
    [self.loginTipButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.loginTipLabel);
        make.top.mas_equalTo(self.loginTipLabel.mas_bottom).offset(5);
    }];
}

#pragma mark - getters and setters
- (UILabel *)titleLabel{
    if (!_titleLabel){
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.text = @"登录";
        _titleLabel.hidden = YES;
        _titleLabel.textColor = [XCTheme getTTMainTextColor];
        _titleLabel.font = [UIFont systemFontOfSize:22];
    }
    return _titleLabel;
}

- (TTAuthEditView *)erbanIdEditView {
    if (!_erbanIdEditView) {
        _erbanIdEditView = [[TTAuthEditView alloc] initWithPlaceholder:[NSString stringWithFormat:@"请输入您%@绑定QQ的ID", [XCKeyWordTool sharedInstance].xcRabbit]];
        [_erbanIdEditView.textField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
        _erbanIdEditView.type = TTAuthEditViewTypeNormal;
        _erbanIdEditView.textField.keyboardType = UIKeyboardTypeNumberPad;
        _erbanIdEditView.backgroundColor = UIColorFromRGB(0xF0F0F0);
        _erbanIdEditView.layer.cornerRadius = 22.f;
    }
    return _erbanIdEditView;
}

- (TTAuthEditView *)passwordEditView{
    if (!_passwordEditView) {
        _passwordEditView = [[TTAuthEditView alloc] initWithPlaceholder:@"请输入密码"];
        [_passwordEditView.textField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
        _passwordEditView.textField.secureTextEntry = YES;
        _passwordEditView.textField.delegate = self;
        _passwordEditView.type = TTAuthEditViewTypeNormal;
        _passwordEditView.textField.keyboardType = UIKeyboardTypeASCIICapable;
        _passwordEditView.backgroundColor = UIColorFromRGB(0xF0F0F0);
        _passwordEditView.layer.cornerRadius = 22.f;
    }
    return _passwordEditView;
}

- (UILabel *)loginTipLabel{
    if (!_loginTipLabel) {
        _loginTipLabel = [[UILabel alloc] init];
        _loginTipLabel.font = [UIFont systemFontOfSize:13];
        _loginTipLabel.textColor = UIColorFromRGB(0x808080);
        _loginTipLabel.text = [NSString stringWithFormat:@"未设置密码的用户记得前往%@设置密码后登录哦", [XCKeyWordTool sharedInstance].xcRabbit];
        _loginTipLabel.numberOfLines = 2;
    }
    return _loginTipLabel;
}

- (UIButton *)loginTipButton{
    if (!_loginTipButton) {
        _loginTipButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_loginTipButton setTitle:@"如何设置密码？" forState:UIControlStateNormal];
        [_loginTipButton setTitleColor:UIColorFromRGB(0x589DE7) forState:UIControlStateNormal];
        _loginTipButton.titleLabel.font = [UIFont systemFontOfSize:13];
        [_loginTipButton addTarget:self action:@selector(loginTipButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _loginTipButton;
}

- (UIButton *)bindButton{
    if (!_bindButton) {
        _bindButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_bindButton setTitle:@"绑定并登录" forState:UIControlStateNormal];
        [_bindButton setTitleColor:UIColorFromRGB(0xffffff) forState:UIControlStateNormal];
        _bindButton.titleLabel.font = [UIFont systemFontOfSize:16];
        _bindButton.backgroundColor = UIColorFromRGB(0xdbdbdb);
        _bindButton.layer.masksToBounds = YES;
        _bindButton.layer.cornerRadius = 43 / 2;
        [_bindButton addTarget:self action:@selector(bindErBanAccountAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _bindButton;
}

@end
