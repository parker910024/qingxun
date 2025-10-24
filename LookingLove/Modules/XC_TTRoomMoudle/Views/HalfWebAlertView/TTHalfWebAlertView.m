//
//  TTHalfWebAlertView.m
//  XC_TTRoomMoudle
//
//  Created by lvjunhang on 2019/12/4.
//  Copyright © 2019 WUJIE INTERACTIVE. All rights reserved.
//

#import "TTHalfWebAlertView.h"

#import "TTWKWebViewViewController.h"

#import "UIButton+EnlargeTouchArea.h"

#import <Masonry/Masonry.h>

#import "XCMacros.h"

static CGFloat const kContentAspectRatio = 4/3.f;

@interface TTHalfWebAlertView ()

@property (nonatomic, strong) TTWKWebViewViewController *webVC;

@property (nonatomic, strong) UIButton *closeButton;

@end

@implementation TTHalfWebAlertView

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (CGRectEqualToRect(frame, CGRectZero)) {
        frame = UIScreen.mainScreen.bounds;
    }
    
    self = [super initWithFrame:frame];
    if (self) {
        self.layer.masksToBounds = YES;
        self.backgroundColor = [UIColor.blackColor colorWithAlphaComponent:0.2];
        [self addSubview:self.webVC.view];
        [self.webVC.view mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(self).inset(20);
            make.centerY.mas_equalTo(self);
            make.height.mas_equalTo(self.webVC.view.mas_width).multipliedBy(kContentAspectRatio);
        }];
        _webVC.view.layer.cornerRadius = 12;
        [self addSubview:self.closeButton];
        [self.closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.webVC.view.mas_top).offset(10);
            make.right.mas_equalTo(self.webVC.view.mas_right).offset(-15);
        }];
        
    }
    return self;
}

- (void)dealloc {
    
}

#pragma mark - Action
- (void)didClickCloseButton {
    !self.dismissRequestHandler ?: self.dismissRequestHandler();
}

#pragma mark - Lazy Load
//- (void)setType:(TTHalfWebAlertViewType)type {
//    _type = type;
//    if (_type == TTHalfWebAlertViewTypeMiddle) {
//
//    } else if (_type == TTHalfWebAlertViewTypeBottomToTop) {
//
//        [self addSubview:self.webVC.view];
//        [self.webVC.view mas_remakeConstraints:^(MASConstraintMaker *make) {
//            make.bottom.left.right.mas_equalTo(self);
//            make.height.mas_equalTo(self.webVC.view.mas_width).multipliedBy(iPhoneXSeries ? 7/5.f : kContentAspectRatio);
//        }];
//        self.webVC.view.layer.cornerRadius = 20;
//        [self addSubview:self.closeButton];
//        [self.closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.mas_equalTo(self.webVC.view.mas_top).offset(10);
//            make.right.mas_equalTo(self.webVC.view.mas_right).offset(-15);
//        }];
//
//    }
//}

- (void)setWebVCBgColor:(UIColor *)webVCBgColor {
    _webVCBgColor = webVCBgColor;
    self.webVC.webview.backgroundColor = webVCBgColor;
}

- (void)setUrl:(NSURL *)url {
    _url = url;
    
    self.webVC.url = url;
}

- (void)setUrlString:(NSString *)urlString {
    _urlString = urlString;
    
    self.webVC.urlString = urlString;
}

- (TTWKWebViewViewController *)webVC {
    if (_webVC == nil) {
        _webVC = [[TTWKWebViewViewController alloc] init];
        _webVC.view.layer.cornerRadius = 12;
        _webVC.view.layer.masksToBounds = YES;
        _webVC.view.backgroundColor = UIColor.clearColor;
        _webVC.webview.opaque = NO;
        _webVC.webview.backgroundColor = UIColor.whiteColor;
        _webVC.webview.scrollView.backgroundColor = UIColor.clearColor;
        _webVC.webview.scrollView.bounces = NO;
        __weak typeof(self) weakSelf = self;
        _webVC.notifyRefreshHandler = ^(WebViewNotifyAppActionStatusType statusType) {
            !weakSelf.gameDismissRequestHandler ?: weakSelf.gameDismissRequestHandler();
        };
        _webVC.dismissRequestHandler = ^{
            
            !weakSelf.dismissRequestHandler ?: weakSelf.dismissRequestHandler();
        };
        
        _webVC.urlLoadCompletedHandler = ^(BOOL result, NSError *error) {
            
            UIColor *aimColor = result ? UIColor.clearColor : UIColor.whiteColor;
            if (weakSelf.webVC.webview.backgroundColor != aimColor) {
                weakSelf.webVC.webview.backgroundColor = aimColor;
            }
        };
    }
    return _webVC;
}

- (UIButton *)closeButton {
    if (_closeButton == nil) {
        _closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_closeButton setImage:[UIImage imageNamed:@"room_half_web_close"] forState:UIControlStateNormal];
        [_closeButton addTarget:self action:@selector(didClickCloseButton) forControlEvents:UIControlEventTouchUpInside];
        
        [_closeButton enlargeTouchArea:UIEdgeInsetsMake(10, 10, 10, 10)];
    }
    return _closeButton;
}

- (void)setCloseButtonImage:(UIImage *)closeButtonImage {
    _closeButtonImage = closeButtonImage;
    [self.closeButton setImage:closeButtonImage forState:UIControlStateNormal];
}
@end
