//
//  LLDynamicAnchorOrderAlertView.m
//  XC_TTGameMoudle
//
//  Created by lvjunhang on 2020/4/30.
//  Copyright © 2020 WUJIE INTERACTIVE. All rights reserved.
//

#import "LLDynamicAnchorOrderAlertView.h"

#import "XCMacros.h"
#import "XCTheme.h"
#import "TTPopup.h"
#import "XCCurrentVCStackManager.h"
#import "HostUrlManager.h"
#import "XCHtmlUrl.h"
#import <WebKit/WebKit.h>
#import "UIButton+EnlargeTouchArea.h"

#import <Masonry/Masonry.h>

@interface LLDynamicAnchorOrderAlertView ()<UITextFieldDelegate>
@property (nonatomic, strong) WKWebView *webView;
@property (nonatomic, strong) UIButton *cancelButton;

@end

@implementation LLDynamicAnchorOrderAlertView

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
        
        NSString *rulePath = HtmlUrlKey(kAnchorOrderRuleURL);
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
        [TTPopup popupView:self style:TTPopupStyleAlert];
    }
}

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
        make.top.right.mas_equalTo(self).inset(14);
        make.width.height.mas_equalTo(24);
    }];
    [self.webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(20);
        make.left.right.mas_equalTo(self).inset(20);
        make.bottom.mas_equalTo(-30);
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
        [_cancelButton setImage:[UIImage imageNamed:@"openroom_close"] forState:UIControlStateNormal];
        [_cancelButton addTarget:self action:@selector(cancelButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
        
        [_cancelButton enlargeTouchArea:UIEdgeInsetsMake(6, 6, 6, 6)];
    }
    return _cancelButton;
}

@end
