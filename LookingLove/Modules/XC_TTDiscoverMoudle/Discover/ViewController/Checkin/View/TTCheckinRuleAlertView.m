//
//  TTCheckinRuleAlertView.m
//  TTPlay
//
//  Created by lvjunhang on 2019/3/21.
//  Copyright © 2019 YiZhuan. All rights reserved.
//

#import "TTCheckinRuleAlertView.h"

#import "XCMacros.h"
#import "XCTheme.h"
#import "TTPopup.h"
#import "XCCurrentVCStackManager.h"
#import "HostUrlManager.h"
#import "XCHtmlUrl.h"
#import <WebKit/WebKit.h>

#import <Masonry/Masonry.h>

@interface TTCheckinRuleAlertView ()<UITextFieldDelegate>
@property (nonatomic, strong) WKWebView *webView;
@property (nonatomic, strong) UIButton *cancelButton;

@end

@implementation TTCheckinRuleAlertView

#pragma mark - life cycle

- (instancetype)initWithFrame:(CGRect)frame {
    
    /// 设置默认宽高
    if (CGRectEqualToRect(frame, CGRectZero)) {
        frame = CGRectMake(0, 0, KScreenWidth-43*2, 370);
    }
    
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = UIColor.whiteColor;
        self.layer.cornerRadius = 14;
        self.layer.masksToBounds = YES;
        
        [self initView];
        [self initConstraints];
        
        NSString *rulePath = HtmlUrlKey(kCheckinRuleURL);
        NSString *ruleURL = [NSString stringWithFormat:@"%@/%@", [HostUrlManager shareInstance].hostUrl, rulePath];
        NSURLRequest *req = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:ruleURL]];
        [self.webView loadRequest:req];
    }
    return self;
}

#pragma mark - public method
- (void)showAlert {
    
    UIViewController *currentVC = [[XCCurrentVCStackManager shareManager] getCurrentVC];
    if (currentVC != nil) {
        
        TTPopupService *service = [[TTPopupService alloc] init];
        service.contentView = self;
    
        [TTPopup popupWithConfig:service];
    }
}

#pragma mark - custom protocols
#pragma mark - core protocols
#pragma mark - event response
- (void)cancelButtonTapped:(UIButton *)sender {
    [TTPopup dismiss];
}

#pragma mark - private method
- (void)initView {
    [self addSubview:self.webView];
    [self addSubview:self.cancelButton];
}

- (void)initConstraints {
    [self.cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.mas_equalTo(self).inset(9);
        make.width.height.mas_equalTo(30);
    }];
    [self.webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(30);
        make.left.right.mas_equalTo(self).inset(14);
        make.bottom.mas_equalTo(-14);
    }];
}

#pragma mark - Getter Setter
- (WKWebView *)webView {
    if (_webView == nil) {
        WKWebViewConfiguration *conf = [[WKWebViewConfiguration alloc] init];
        WKWebView *webview = [[WKWebView alloc] initWithFrame:CGRectZero configuration:conf];
        webview.scrollView.showsVerticalScrollIndicator = NO;
        
        _webView = webview;
    }
    return _webView;
}

- (UIButton *)cancelButton {
    if (_cancelButton == nil) {
        _cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_cancelButton setImage:[UIImage imageNamed:@"checkin_rule_cancel"] forState:UIControlStateNormal];
        [_cancelButton addTarget:self action:@selector(cancelButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancelButton;
}

@end

