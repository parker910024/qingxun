//
//  LLQQLoginViewController.h
//  XC_TTAuthMoudle
//
//  Created by apple on 2019/7/25.
//  Copyright © 2019 YiZhuan. All rights reserved.
//

#import "LLQQLoginViewController.h"

#import "TTQQBindViewController.h"
#import "LLQQBindViewController.h"
#import "AuthCore.h"
#import "AuthCoreClient.h"

//#import "BaiduMobStat.h"
#import "XCTheme.h"
#import <Masonry/Masonry.h>
#import "XCHUDTool.h"
#import "XCKeyWordTool.h"

#import "LLRegisterViewController.h"
//易盾注册保护
#import <Guardian/NTESCSGuardian.h>
//数美天网
#import "SmAntiFraud.h"
@interface LLQQLoginViewController ()<AuthCoreClient>
/** 标题 */
@property (nonatomic, strong) UILabel * titleLabel;
/** 老用户*/
@property (nonatomic, strong) UIButton * oldUserButton;
/** 新用户*/
@property (nonatomic, strong) UIButton * newsUserButton;

@end

@implementation LLQQLoginViewController

#pragma mark - life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    AddCoreClient(AuthCoreClient, self);
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

#pragma mark - [系统控件的Protocol]   //注意要把名字改掉，这个MARK只做功能划分，不是一个真正的MARK，每个不一样的Protocol，需要一个新的MARK”

#pragma mark - [自定义控件的Protocol] //注意要把名字改掉，这个MARK只做功能划分，不是一个真正的MARK，每个不一样的Protocol，需要一个新的MARK”

- (void)thirdPartLoginFailth {
    [XCHUDTool showErrorWithMessage:@"登录失败，请重试" inView:self.view];
}

- (void)thirdPartLoginCancel {
    [XCHUDTool showErrorWithMessage:@"用户取消操作" inView:self.view];
}

#pragma mark - AuthCoreClient
- (void)onLoginSuccess {
    [XCHUDTool hideHUDInView:self.view];
    [GetCore(AuthCore) stopCountDown];
    // 登录成功后发送通知，刷新用户数据(获取地理位置信息)
    [[NSNotificationCenter defaultCenter] postNotificationName:@"kUserLoginSuccessRefreshUserInfoNoti" object:nil];
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}


- (void)qqloginNotBindErBanInfor:(NSString *)qqOpenid{
    // 没有绑定，也需要隐藏 toastView
    [XCHUDTool hideHUDInView:self.view];
    LLQQBindViewController * bindVC = [[LLQQBindViewController alloc] init];
    bindVC.qqOpenid = qqOpenid;
    [self.navigationController pushViewController:bindVC animated:YES];
}

- (void)onLoginFailth:(NSString *)errorMsg {
    [XCHUDTool showErrorWithMessage:errorMsg inView:self.view];
}

#pragma mark - event response
- (void)chooseUserTypeAction:(UIButton *)sender{
    if (sender == self.newsUserButton) {
        [XCHUDTool showGIFLoadingInView:self.view];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [NTESCSGuardian getTokenWithBusinessID:LLRegisterViewYiDunLoginBusinessID completeHandler:^(NSString *token) {
                
                [GetCore(AuthCore) thirdLoginPlatform:SSDKPlatformTypeQQ yiDunToken:token shuMeiDeviceId:[SmAntiFraud shareInstance].getDeviceId isNewUser:NO];
            }];
        });
    } else {
        [XCHUDTool showGIFLoadingInView:self.view];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            [NTESCSGuardian getTokenWithBusinessID:LLRegisterViewYiDunLoginBusinessID completeHandler:^(NSString *token) {
                
                [GetCore(AuthCore) thirdLoginPlatform:SSDKPlatformTypeQQ yiDunToken:token shuMeiDeviceId:[SmAntiFraud shareInstance].getDeviceId isNewUser:YES];
            }];
        });
    }
}

#pragma mark - private method

- (void)initView {
    [self.view addSubview:self.titleLabel];
    [self.view addSubview:self.newsUserButton];
    [self.view addSubview:self.oldUserButton];
}

- (void)initConstrations {
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.view).inset(26);
        make.centerX.mas_equalTo(self.view);
        make.top.mas_equalTo(44 + kNavigationHeight);
    }];
    
    [self.oldUserButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view).offset(38);
        make.right.mas_equalTo(self.view).offset(-38);
        make.height.mas_equalTo(43);
        make.top.mas_equalTo(self.titleLabel.mas_bottom).offset(86);
    }];
    
    [self.newsUserButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.left.right.mas_equalTo(self.oldUserButton);
        make.top.mas_equalTo(self.oldUserButton.mas_bottom).offset(31);
    }];
}

#pragma mark - getters and setters
- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.text = @"QQ登录";
        _titleLabel.font = [UIFont boldSystemFontOfSize:25];
        _titleLabel.textColor = [XCTheme getTTMainTextColor];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLabel;
}

- (UIButton *)oldUserButton{
    if (!_oldUserButton) {
        _oldUserButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_oldUserButton setTitle:[NSString stringWithFormat:@"我是%@老用户", [XCKeyWordTool sharedInstance].xcForLight] forState:UIControlStateNormal];
        _oldUserButton.layer.borderWidth = 2;
        _oldUserButton.layer.borderColor = [XCTheme getTTMainTextColor].CGColor;
        _oldUserButton.layer.masksToBounds = YES;
        _oldUserButton.layer.cornerRadius = 22;
        [_oldUserButton setTitleColor:[XCTheme getTTMainTextColor] forState:UIControlStateNormal];
        [_oldUserButton addTarget:self action:@selector(chooseUserTypeAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _oldUserButton;
}

- (UIButton *)newsUserButton{
    if (!_newsUserButton) {
        _newsUserButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_newsUserButton setTitle:@"我是轻寻新用户" forState:UIControlStateNormal];
        _newsUserButton.layer.borderWidth = 2;
        _newsUserButton.layer.borderColor = [XCTheme getTTMainTextColor].CGColor;
        _newsUserButton.layer.masksToBounds = YES;
        _newsUserButton.layer.cornerRadius = 22;
        [_newsUserButton setTitleColor:[XCTheme getTTMainTextColor] forState:UIControlStateNormal];
        [_newsUserButton addTarget:self action:@selector(chooseUserTypeAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _newsUserButton;
}

@end
