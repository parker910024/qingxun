//
//  TTQQLoginViewController.m
//  TuTu
//
//  Created by Macx on 2018/10/30.
//  Copyright © 2018 YiZhuan. All rights reserved.
//

#import "TTQQLoginViewController.h"

#import "TTQQBindViewController.h"

#import "AuthCore.h"
#import "AuthCoreClient.h"

//#import "BaiduMobStat.h"
#import "XCTheme.h"
#import <Masonry/Masonry.h>
#import "XCHUDTool.h"
#import "XCKeyWordTool.h"

@interface TTQQLoginViewController ()<AuthCoreClient>
/** logo */
@property (nonatomic, strong) UIImageView * logoImageView;
/** 老用户*/
@property (nonatomic, strong) UIButton * oldUserButton;
/** 新用户*/
@property (nonatomic, strong) UIButton * newsUserButton;
@end

@implementation TTQQLoginViewController

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

#pragma mark - AuthCoreClient
- (void)onLoginSuccess{
    [XCHUDTool hideHUDInView:self.view];
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (void)qqloginNotBindErBanInfor:(NSString *)qqOpenid{
    // 没有绑定，也需要隐藏 toastView
    [XCHUDTool hideHUDInView:self.view];
    TTQQBindViewController * bindVC = [[TTQQBindViewController alloc] init];
    bindVC.qqOpenid = qqOpenid;
    [self.navigationController pushViewController:bindVC animated:YES];
}

- (void)onLoginFailth:(NSString *)errorMsg{
    [XCHUDTool hideHUDInView:self.view];
}

#pragma mark - event response
- (void)chooseUserTypeAction:(UIButton *)sender{
    if (sender == self.newsUserButton) {
        [XCHUDTool showGIFLoadingInView:self.view];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [GetCore(AuthCore) qqLoginPlatform:SSDKPlatformTypeQQ isNewUser:NO];
        });
//        [[BaiduMobStat defaultStat] logEvent:@"login" eventLabel:@"[QQ登录]" attributes:@{@"loginType": @"[qq]"}];
    } else {
        [XCHUDTool showGIFLoadingInView:self.view];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [GetCore(AuthCore) qqLoginPlatform:SSDKPlatformTypeQQ isNewUser:YES];
        });
//        [[BaiduMobStat defaultStat] logEvent:@"login" eventLabel:@"[QQ登录]" attributes:@{@"loginType": @"[qq]"}];
    }
}

#pragma mark - private method

- (void)initView {
    [self.view addSubview:self.logoImageView];
    [self.view addSubview:self.newsUserButton];
    [self.view addSubview:self.oldUserButton];
}

- (void)initConstrations {
    [self.logoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(100);
        make.centerX.mas_equalTo(self.view);
        if (@available(iOS 11, *)) {
            make.top.mas_equalTo(self.view.mas_safeAreaLayoutGuideTop).offset(100);
        }else{
            make.top.mas_equalTo(self.view).offset(100);
        }
    }];
    
    [self.oldUserButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view).offset(58);
        make.right.mas_equalTo(self.view).offset(-58);
        make.height.mas_equalTo(40);
        make.top.mas_equalTo(self.logoImageView.mas_bottom).offset(81);
    }];
    
    [self.newsUserButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.left.right.mas_equalTo(self.oldUserButton);
        make.top.mas_equalTo(self.oldUserButton.mas_bottom).offset(22);
    }];
}

#pragma mark - getters and setters
- (UIImageView *)logoImageView{
    if (!_logoImageView) {
        _logoImageView =[[UIImageView alloc] init];
        _logoImageView.image = [UIImage imageNamed:@"auth_login_qq"];
    }
    return _logoImageView;
}

- (UIButton *)oldUserButton{
    if (!_oldUserButton) {
        _oldUserButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_oldUserButton setTitle:[NSString stringWithFormat:@"我是%@老用户", [XCKeyWordTool sharedInstance].xcRabbit] forState:UIControlStateNormal];
        [_oldUserButton setBackgroundColor:[XCTheme getTTMainColor]];
        _oldUserButton.layer.masksToBounds = YES;
        _oldUserButton.layer.cornerRadius = 20;
        [_oldUserButton addTarget:self action:@selector(chooseUserTypeAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _oldUserButton;
}

- (UIButton *)newsUserButton{
    if (!_newsUserButton) {
        _newsUserButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_newsUserButton setTitle:[NSString stringWithFormat:@"我是%@新用户", [XCKeyWordTool sharedInstance].myAppName] forState:UIControlStateNormal];
        [_newsUserButton setBackgroundColor:[XCTheme getTTMainColor]];
        _newsUserButton.layer.masksToBounds = YES;
        _newsUserButton.layer.cornerRadius = 20;
        [_newsUserButton addTarget:self action:@selector(chooseUserTypeAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _newsUserButton;
}

@end
