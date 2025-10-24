//
//  AppDelegate+Config.m
//  TuTu
//
//  Created by 卫明 on 2018/11/8.
//  Copyright © 2018 YiZhuan. All rights reserved.
//

#import "AppDelegate+Config.h"

//config
#import "TTSessionCellLayoutConfig.h"
#import "XCCustomAttachmentDecoder.h"
#import "NIMKit.h"
//provider
#import "TTPublicChatroomMessageProvider.h"
#import "XCHtmlUrl.h"

static NSString *const kWebViewJavaScript = @"navigator.userAgent";
static NSString *const kTuTuUserAgent = @"tutuAppIos erbanAppIos";
static NSString *const kWebViewUserAgentKey = @"UserAgent";

@implementation AppDelegate (Config)

- (void)configPublicChatroom {
    [TTPublicChatroomMessageProvider shareProvider];
    [self setCustomUserAgent];
}

/**
 设置 webView 自定义 UA
 */
- (void)setCustomUserAgent
{
    //get the original user-agent of webview
    WKWebView *webView = [[WKWebView alloc] initWithFrame:CGRectZero];
    [webView evaluateJavaScript:kWebViewJavaScript completionHandler:^(id _Nullable userAgent, NSError * _Nullable error) {
        //add my info to the new agent
        NSString *oldAgent = userAgent;
        if (![userAgent containsString:kTuTuUserAgent]){
            NSString *newUserAgent = [userAgent stringByAppendingString:kTuTuUserAgent];
            NSDictionary *dictionary = [NSDictionary dictionaryWithObjectsAndKeys:newUserAgent, kWebViewUserAgentKey, nil];
            [[NSUserDefaults standardUserDefaults] registerDefaults:dictionary];
            [[NSUserDefaults standardUserDefaults] synchronize];
            [webView setCustomUserAgent:newUserAgent];
        }
    }];
}


@end
