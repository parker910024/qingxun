//
//  XCOpenURLHelper.m
//  XCToolKit
//
//  Created by lvjunhang on 2019/9/18.
//  Copyright © 2019 YiZhuan. All rights reserved.
//

#import "XCOpenURLHelper.h"

@implementation XCOpenURLHelper

+ (void)openSetttings {
    NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
    [self openURL:url];
}

+ (void)call:(NSString *)phoneNumber {
    NSString *urlString = [NSString stringWithFormat:@"tel://%@", phoneNumber];
    NSURL *url = [NSURL URLWithString:urlString];
    [self openURL:url];
}

+ (void)mailto:(NSString *)mailAddress {
    NSString *mailUrl = [NSString stringWithFormat:@"mailto:%@?", mailAddress];
    mailUrl = [mailUrl stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]];
    NSURL *url = [NSURL URLWithString:mailUrl];
    [self openURL:url];
}

+ (void)openURL:(NSURL *)url {
    [self openURL:url options:@{} completionHandler:nil];
}

+ (void)openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenExternalURLOptionsKey, id> *)options completionHandler:(void(^ __nullable)(BOOL success))completionHandler {
    
    if (![[UIApplication sharedApplication] canOpenURL:url]) {
        
        NSString *errorMsg = [NSString stringWithFormat:@"can't open url:%@", url];
        NSAssert(NO, errorMsg);
        !completionHandler ?: completionHandler(NO);
        return;
    }
    
    if (@available(iOS 10.0, *)) {
        [[UIApplication sharedApplication] openURL:url options:options completionHandler:^(BOOL success) {
            !completionHandler ?: completionHandler(success);
        }];
    } else {
        BOOL success = [[UIApplication sharedApplication] openURL:url];
        !completionHandler ?: completionHandler(success);
    }
}

@end
