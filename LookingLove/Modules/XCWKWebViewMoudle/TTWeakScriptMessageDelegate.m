//
//  TTWeakScriptMessageDelegate.m
//  TTPlay
//
//  Created by new on 2019/2/13.
//  Copyright © 2019 YiZhuan. All rights reserved.
//

#import "TTWeakScriptMessageDelegate.h"

@implementation TTWeakScriptMessageDelegate

- (instancetype)initWithDelegate:(id<WKScriptMessageHandler>)scriptDelegate {
    self = [super init];
    if (self) {
        _scriptDelegate = scriptDelegate;
    }
    return self;
}

- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message {
    [self.scriptDelegate userContentController:userContentController didReceiveScriptMessage:message];
}

@end
