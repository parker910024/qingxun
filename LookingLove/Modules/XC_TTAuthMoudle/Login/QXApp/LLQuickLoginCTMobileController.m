//
//  LLQuickLoginCTMobileController.m
//  XC_TTAuthMoudle
//
//  Created by lee on 2020/3/24.
//  Copyright © 2020 YiZhuan. All rights reserved.
//

#import "LLQuickLoginCTMobileController.h"
#import "XCTheme.h"
#import "XCHUDTool.h"
#import "CommonFileUtils.h"
#import <Masonry/Masonry.h>
#import "XCHtmlUrl.h"
#import <YYText/YYText.h>

// core
#import "AuthCore.h"
#import "AuthCoreClient.h"
#import "VersionCoreClient.h"
#import "VersionCore.h"
#import "UserCore.h"
#import "PurseCore.h"
#import "PurseCoreClient.h"

#import "TTWKWebViewViewController.h"
#import "LLRegisterViewController.h"
//易盾注册保护
#import <Guardian/NTESCSGuardian.h>
//数美天网
#import "SmAntiFraud.h"
#import <AuthenticationServices/AuthenticationServices.h>
/// 一键登录
#import <NTESQuickPass/NTESQuickPass.h>

@interface LLQuickLoginCTMobileController ()

@property (nonatomic, strong) UIImageView *iconImage;
@property (nonatomic, strong) UILabel *phoneLabel;
@property (nonatomic, strong) UILabel *tipsLabel;
@property (nonatomic, strong) UIButton *quickLoginBtn;
@property (nonatomic, strong) YYLabel *protoolLabel;

@end

@implementation LLQuickLoginCTMobileController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    self.navigationItem.title = @"一键登录";
    
    [self.view addSubview:self.iconImage];
    [self.view addSubview:self.phoneLabel];
    [self.view addSubview:self.tipsLabel];
    [self.view addSubview:self.quickLoginBtn];
    [self.view addSubview:self.protoolLabel];
    
    [self.iconImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(kNavigationHeight + 20);
        make.centerX.mas_equalTo(self.view);
        make.width.height.mas_equalTo(95);
    }];
    
    [self.phoneLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.iconImage.mas_bottom).offset(10);
        make.centerX.mas_equalTo(self.view);
    }];
    
    [self.tipsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.phoneLabel.mas_bottom).offset(16);
        make.centerX.mas_equalTo(self.view);
    }];
    
    [self.quickLoginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.tipsLabel.mas_bottom).offset(48);
        make.height.mas_equalTo(48);
        make.left.right.mas_equalTo(self.view).inset(47.5);
    }];
    
    [self.protoolLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.view).inset(kSafeAreaBottomHeight + 20);
        make.left.right.mas_equalTo(self.view).inset(47.5);
    }];
    
    [XCHUDTool hideHUD];
}

- (void)onClickQuickLoginAction:(UIButton *)btn {
    
    [[NTESQuickLoginManager sharedInstance] CTAuthorizeLoginCompletion:^(NSDictionary * _Nonnull resultDic) {
        
        [XCHUDTool showGIFLoading];
        
        NSNumber *boolNum = [resultDic objectForKey:@"success"];
        BOOL success = [boolNum boolValue];
        if (success) {
            // 取号成功，获取acessToken
            [NTESCSGuardian getTokenWithBusinessID:LLRegisterViewYiDunLoginBusinessID completeHandler:^(NSString *token) {
                [GetCore(AuthCore) quickLoginAccessToken:resultDic[@"accessToken"]
                                              yiDunToken:token
                                          shuMeiDeviceId:[SmAntiFraud shareInstance].getDeviceId
                                                   token:self.token];
            }];
            
        } else {
            NSString *resultCode = [resultDic objectForKey:@"resultCode"];
            if ([resultCode isEqualToString:@"200020"]) {
               NSLog(@"取消登录");
            }
            [XCHUDTool showErrorWithMessage:@"一键登录失败，请使用其他方式登录"];
        }
    }];
}

- (void)goToWebview:(NSString *)url {
    TTWKWebViewViewController *webView = [[TTWKWebViewViewController alloc] init];
    webView.urlString = url;
    webView.uid = GetCore(AuthCore).getUid.longLongValue;
    [self.navigationController pushViewController:webView animated:YES];
}

- (void)setSecurityPhone:(NSString *)securityPhone {
    _securityPhone = securityPhone;
    
    self.phoneLabel.text = securityPhone;
}

- (UIImageView *)iconImage {
    if (!_iconImage) {
        _iconImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ctmobile_icon"]];
    }
    return _iconImage;
}

- (UILabel *)phoneLabel {
    if (!_phoneLabel) {
        _phoneLabel = [[UILabel alloc] init];
        _phoneLabel.textColor = [XCTheme getTTMainTextColor];
        _phoneLabel.font = [UIFont boldSystemFontOfSize:20];
        _phoneLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _phoneLabel;
}

- (UILabel *)tipsLabel {
    if (!_tipsLabel) {
        _tipsLabel = [[UILabel alloc] init];
        _tipsLabel.textColor = UIColorFromRGB(0xABAAB2);
        _tipsLabel.font = [UIFont systemFontOfSize:14];
        _tipsLabel.textAlignment = NSTextAlignmentCenter;
        _tipsLabel.text = @"天翼账号提供认证服务";
    }
    return _tipsLabel;
}

- (UIButton *)quickLoginBtn {
    if (!_quickLoginBtn) {
        _quickLoginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_quickLoginBtn setTitle:@"本机号码一键登录" forState:UIControlStateNormal];
        [_quickLoginBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        _quickLoginBtn.titleLabel.font = [UIFont boldSystemFontOfSize:16];
        [_quickLoginBtn setBackgroundColor:[XCTheme getTTMainColor]];
        _quickLoginBtn.layer.cornerRadius = 24;
        _quickLoginBtn.layer.masksToBounds = YES;
        [_quickLoginBtn addTarget:self action:@selector(onClickQuickLoginAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _quickLoginBtn;
}

- (YYLabel *)protoolLabel {
    if (!_protoolLabel) {
        _protoolLabel = [[YYLabel alloc] init];
        _protoolLabel.numberOfLines = 0;
        _protoolLabel.userInteractionEnabled = YES;
        _protoolLabel.preferredMaxLayoutWidth = KScreenWidth - 47.5*2;
        
        UIColor *highlightColor = UIColorFromRGB(0xFE4C62);
        NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:@"登录即代表同意天翼账号服务与隐私协议轻寻隐私政策和用户协议并授权轻寻获取本机号码" attributes:@{NSFontAttributeName: [UIFont systemFontOfSize: 13],NSForegroundColorAttributeName: [XCTheme getTTMainTextColor]}];
        NSRange CTrange = [attStr.mutableString rangeOfString:@"天翼账号服务与隐私协议"];
        NSRange praviterange = [attStr.mutableString rangeOfString:@"隐私政策"];
        NSRange userrange = [attStr.mutableString rangeOfString:@"用户协议"];
        [attStr yy_setColor:highlightColor range:CTrange];
        [attStr yy_setColor:highlightColor range:praviterange];
        [attStr yy_setColor:highlightColor range:userrange];
        
        @weakify(self);
        
        [attStr yy_setTextHighlightRange:CTrange color:nil backgroundColor:nil tapAction:^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
            @strongify(self);
            TTWKWebViewViewController *web = [[TTWKWebViewViewController alloc] init];
            web.url = [NSURL URLWithString:@"https://e.189.cn/sdk/agreement/content.do?type=main&appKey=&hidetop=true"];
            [self.navigationController pushViewController:web animated:YES];
        }];
        
        [attStr yy_setTextHighlightRange:praviterange color:nil backgroundColor:nil tapAction:^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
            @strongify(self);
            // 跳转隐私政策
            [self goToWebview:HtmlUrlKey(kPrivacyURL)];
        }];
        
        [attStr yy_setTextHighlightRange:userrange color:nil backgroundColor:nil tapAction:^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
            @strongify(self);
            // 跳转用户协议
            [self goToWebview:HtmlUrlKey(kUserProtocalURL)];
        }];
    
        _protoolLabel.attributedText = attStr;
    }
    return _protoolLabel;
}
@end
