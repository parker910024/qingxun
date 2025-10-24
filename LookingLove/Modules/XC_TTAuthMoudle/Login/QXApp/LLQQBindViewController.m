//
//  LLQQBindViewController.h
//  XC_TTAuthMoudle
//
//  Created by apple on 2019/7/26.
//  Copyright © 2019 YiZhuan. All rights reserved.
//

#import "LLQQBindViewController.h"

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
#import <YYLabel.h>
#import <YYText.h>

@interface LLQQBindViewController ()<UITextFieldDelegate, AuthCoreClient>
/** 标题*/
@property (nonatomic, strong) UILabel * titleLabel;
/** 手机号输入框*/
@property (nonatomic, strong) TTAuthEditView *erbanIdEditView;
/** 手机号输入框 下划线*/
@property (nonatomic, strong) UIView *erbanIdEditLineView;
/** password*/
@property (nonatomic, strong) TTAuthEditView *passwordEditView;
/** password 下划线*/
@property (nonatomic, strong) UIView *passwordEditLineView;
/** 登录提示*/
@property (nonatomic, strong) YYLabel *loginTipLabel;
@property (nonatomic, strong) UIButton *loginTipButton;
/** 绑定*/
@property (nonatomic, strong) UIButton *bindButton;
@property (nonatomic, copy) NSString *erbanId;
@property (nonatomic, copy) NSString *password;
@end

@implementation LLQQBindViewController

#pragma mark - life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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
        self.bindButton.selected = YES;
        if (projectType() == ProjectType_Planet) {
            self.bindButton.backgroundColor = XCTheme.getTTMainColor;
        } else {
            self.bindButton.layer.borderColor = [XCTheme getTTMainTextColor].CGColor;
        }
    } else {
        self.bindButton.selected = NO;
        if (projectType() == ProjectType_Planet) {
            self.bindButton.backgroundColor = UIColorFromRGB(0xD0D0D0);
        } else {
            self.bindButton.layer.borderColor = UIColorFromRGB(0xB3B3B3).CGColor;
        }
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

- (void)goToWebView {
    XCWKWebViewController *vc = [[XCWKWebViewController alloc]init];
    vc.urlString = HtmlUrlKey(kQQloginGuideURL); //kQQloginGuideURL
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - private method

- (void)initView {
    [self.view addSubview:self.titleLabel];
    [self.view addSubview:self.loginTipLabel];
    //    [self.view addSubview:self.loginTipButton];
    [self.view addSubview:self.erbanIdEditView];
    [self.view addSubview:self.erbanIdEditLineView];
    [self.view addSubview:self.passwordEditView];
    [self.view addSubview:self.passwordEditLineView];
    [self.view addSubview:self.bindButton];
}

- (void)initConstrations {
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(kNavigationHeight + 21);
        make.left.mas_equalTo(26);
    }];
    
    [self.loginTipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(26);
        make.top.mas_equalTo(self.titleLabel.mas_bottom).offset(16);
    }];
    
    //    [self.loginTipButton mas_makeConstraints:^(MASConstraintMaker *make) {
    //        make.right.mas_equalTo(self.loginTipLabel);
    //        make.top.mas_equalTo(self.loginTipLabel.mas_bottom).offset(5);
    //    }];
    
    [self.erbanIdEditView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-26);
        make.left.mas_equalTo(11);
        make.top.mas_equalTo(self.loginTipLabel.mas_bottom).offset(35);
        make.height.mas_equalTo(44);
    }];
    
    [self.erbanIdEditLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.view).inset(26);
        make.top.mas_equalTo(self.erbanIdEditView.mas_bottom);
        make.height.mas_equalTo(1);
    }];
    
    [self.passwordEditView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.height.mas_equalTo(self.erbanIdEditView);
        make.top.mas_equalTo(self.erbanIdEditView.mas_bottom).offset(26);
    }];
    
    [self.passwordEditLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.view).inset(26);
        make.top.mas_equalTo(self.passwordEditView.mas_bottom);
        make.height.mas_equalTo(1);
    }];
    
    [self.bindButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.view).inset(38);
        make.top.mas_equalTo(self.passwordEditView.mas_bottom).offset(70);
        make.height.mas_equalTo(43);
    }];
}

#pragma mark - getters and setters
- (UILabel *)titleLabel{
    if (!_titleLabel){
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.text = @"登录";
        _titleLabel.textColor = [XCTheme getTTMainTextColor];
        _titleLabel.font = [UIFont boldSystemFontOfSize:25];
    }
    return _titleLabel;
}

- (TTAuthEditView *)erbanIdEditView {
    if (!_erbanIdEditView) {
        _erbanIdEditView = [[TTAuthEditView alloc] initWithPlaceholder:[NSString stringWithFormat:@"请输入您%@绑定QQ的ID", [XCKeyWordTool sharedInstance].xcForLight]];
        [_erbanIdEditView.textField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
        _erbanIdEditView.type = TTAuthEditViewTypeNormal;
        _erbanIdEditView.textField.keyboardType = UIKeyboardTypeNumberPad;
        _erbanIdEditView.backgroundColor = UIColorFromRGB(0xffffff);
    }
    return _erbanIdEditView;
}

- (UIView *)erbanIdEditLineView {
    if (!_erbanIdEditLineView) {
        _erbanIdEditLineView = [[UIView alloc] init];
        _erbanIdEditLineView.backgroundColor = UIColorFromRGB(0xcccccc);
    }
    return _erbanIdEditLineView;
}

- (TTAuthEditView *)passwordEditView{
    if (!_passwordEditView) {
        _passwordEditView = [[TTAuthEditView alloc] initWithPlaceholder:@"请输入密码"];
        [_passwordEditView.textField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
        _passwordEditView.textField.secureTextEntry = YES;
        _passwordEditView.textField.delegate = self;
        _passwordEditView.type = TTAuthEditViewTypeNormal;
        _passwordEditView.textField.keyboardType = UIKeyboardTypeASCIICapable;
        _passwordEditView.backgroundColor = UIColorFromRGB(0xffffff);
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

- (YYLabel *)loginTipLabel{
    if (!_loginTipLabel) {
        _loginTipLabel = [[YYLabel alloc] init];
        _loginTipLabel.font = [UIFont systemFontOfSize:13];
        _loginTipLabel.textColor = XCTheme.getTTMainTextColor;
        _loginTipLabel.preferredMaxLayoutWidth = 300;
        _loginTipLabel.numberOfLines = 0;
        
        NSString *tipString = [NSString stringWithFormat:@"未设置%@密码的用户记得前往\n%@设置密码哦 ", [XCKeyWordTool sharedInstance].xcForLight,[XCKeyWordTool sharedInstance].xcForLight];
        
        NSMutableAttributedString *tipAttString = [[NSMutableAttributedString alloc] initWithString:tipString];
        
        NSMutableAttributedString *loginAttStr = [[NSMutableAttributedString alloc] initWithString:@"如何登录?" attributes:@{NSForegroundColorAttributeName:UIColorFromRGB(0xFE4C62)}];;
        
        [loginAttStr yy_setTextHighlightRange:NSMakeRange(0, loginAttStr.length) color:nil backgroundColor:nil userInfo:nil tapAction:^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
            [self goToWebView];
        } longPressAction:nil];
        
        [tipAttString appendAttributedString:loginAttStr];
        
        _loginTipLabel.attributedText = tipAttString;
    }
    return _loginTipLabel;
}

- (UIButton *)loginTipButton{
    if (!_loginTipButton) {
        _loginTipButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_loginTipButton setTitle:@"如何登录？" forState:UIControlStateNormal];
        [_loginTipButton setTitleColor:UIColorFromRGB(0xFE4C62) forState:UIControlStateNormal];
        _loginTipButton.titleLabel.font = [UIFont systemFontOfSize:13];
        [_loginTipButton addTarget:self action:@selector(loginTipButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _loginTipButton;
}

- (UIButton *)bindButton{
    if (!_bindButton) {
        _bindButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_bindButton setTitle:@"登录并绑定" forState:UIControlStateNormal];
        _bindButton.titleLabel.font = [UIFont systemFontOfSize:16];
        _bindButton.layer.masksToBounds = YES;
        _bindButton.layer.cornerRadius = 43 / 2;
        [_bindButton addTarget:self action:@selector(bindErBanAccountAction:) forControlEvents:UIControlEventTouchUpInside];
        if (projectType() == ProjectType_LookingLove) {
            [_bindButton setTitleColor:UIColorFromRGB(0xB3B3B3) forState:UIControlStateNormal];
            [_bindButton setTitleColor:UIColorFromRGB(0x333333) forState:UIControlStateSelected];
            _bindButton.backgroundColor = UIColorRGBAlpha(0xffffff, 0);
            _bindButton.layer.borderWidth = 2;
            _bindButton.layer.borderColor = UIColorFromRGB(0xB3B3B3).CGColor;
        } else {
            _bindButton.backgroundColor = UIColorFromRGB(0xD0D0D0);
            [_bindButton setTitleColor:UIColorFromRGB(0xffffff) forState:UIControlStateNormal];
        }
    }
    return _bindButton;
}

@end
