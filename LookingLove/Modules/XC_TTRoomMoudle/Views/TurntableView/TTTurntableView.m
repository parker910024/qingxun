//
//  TTTurntableView.m
//  TuTu
//
//  Created by KevinWang on 2018/11/20.
//  Copyright © 2018年 YiZhuan. All rights reserved.
//

#import "TTTurntableView.h"

//t
#import "TTRoomModuleCenter.h"
#import "TTPopup.h"
#import "XCCurrentVCStackManager.h"
#import <Masonry/Masonry.h>
#import "XCTheme.h"
#import "XCMacros.h"
#import "XCHtmlUrl.h"
#import "XCWKWebViewController.h"
#import "TTWKWebViewViewController.h"

@interface TTTurntableView()

@property (nonatomic, strong) UIImageView *bgImageView;
@property (nonatomic, strong) UIButton *closeButton;
@property (nonatomic, strong) UIButton *goButton;

@end

@implementation TTTurntableView

#pragma mark - Life Style
- (instancetype)initWithFrame:(CGRect)frame{
    if (self=[super initWithFrame:frame]) {
        [self setupSubviews];
        [self setupSubviewsConstraints];
    }
    return self;
}

#pragma mark - event response
- (void)goButtonDidClick:(UIButton *)button{
    
    [TTPopup dismiss];
    
    if ([TTRoomModuleCenter defaultCenter].currentNav) { //当前界面在房间内
        
        [self findTheWkWebViewInNav:[TTRoomModuleCenter defaultCenter].currentNav];
        
    }else { //当前界面不在房间内
        UIViewController *rootViewController = [UIApplication sharedApplication].keyWindow.rootViewController;
        if ([rootViewController isKindOfClass:NSClassFromString(@"MMDrawerController")]) {
            rootViewController = (UIViewController *)[rootViewController valueForKey:@"centerViewController"];
        }
        
        if ([rootViewController isKindOfClass:[UITabBarController class]]) {
            UITabBarController *vc = (UITabBarController *)rootViewController;
            UINavigationController *nav = vc.selectedViewController;
            [self findTheWkWebViewInNav:nav];
        }
    }
}

- (void)onCloseButtonClick:(UIButton *)button{
    [TTPopup dismiss];
}

#pragma mark - Private
- (void)findTheWkWebViewInNav:(UINavigationController *)nav {
    
    for (UIViewController *item in nav.viewControllers) {
        if ([item isKindOfClass:[TTWKWebViewViewController class]] && ![[[XCCurrentVCStackManager shareManager] getCurrentVC] isKindOfClass:[TTWKWebViewViewController class]]) { //在导航堆栈里面找到这个控制器并且不是当前控制器
            TTWKWebViewViewController *webView = (TTWKWebViewViewController *)item;
            if (![[webView.webview.URL absoluteString]containsString:HtmlUrlKey(kTurntableURL)]) {
                webView.urlString = HtmlUrlKey(kTurntableURL);
                //                webView.banRefresh = YES;
            }
            
            [nav popToViewController:item animated:YES];
            return;
        }
    }
    TTWKWebViewViewController *webView = [[TTWKWebViewViewController alloc] init];
    webView.urlString = HtmlUrlKey(kTurntableURL);
    [nav pushViewController:webView animated:YES];
    
}

- (void)setupSubviews{
    
    [self addSubview:self.bgImageView];
    [self addSubview:self.closeButton];
    [self addSubview:self.goButton];
}

- (void)setupSubviewsConstraints{
    [self.bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    [self.closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(@25);
        make.top.equalTo(self);
        make.right.equalTo(self);
    }];
    
    [self.goButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self).offset(-22);
        make.width.equalTo(@200);
        make.height.equalTo(@38);
        make.centerX.equalTo(self);
    }];
}

#pragma mark - Getter
- (UIImageView *)bgImageView{
    if (!_bgImageView) {
        _bgImageView = [[UIImageView alloc] init];
        _bgImageView.image = [UIImage imageNamed:@"room_turntable_bg"];
    }
    return _bgImageView;
}
- (UIButton *)closeButton{
    if (!_closeButton) {
        _closeButton = [[UIButton alloc] init];
        [_closeButton setBackgroundImage:[UIImage imageNamed:@"room_turntable_close"] forState:UIControlStateNormal];
        [_closeButton addTarget:self action:@selector(onCloseButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _closeButton;
}

- (UIButton *)goButton{
    if (!_goButton) {
        _goButton = [[UIButton alloc] init];
        [_goButton setBackgroundImage:[UIImage imageNamed:@"room_turntable_go"] forState:UIControlStateNormal];
        [_goButton addTarget:self action:@selector(goButtonDidClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _goButton;
}

@end
