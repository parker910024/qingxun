//
//  TTWKWebCrashConfig.m
//  TuTu
//
//  Created by 卫明 on 2018/12/3.
//  Copyright © 2018 YiZhuan. All rights reserved.
//

#import "TTWKWebCrashConfig.h"
#import <objc/runtime.h>
#import <UIKit/UIKit.h>


@implementation TTWKWebCrashConfig


+ (void)handleWKWebViewCrash  {
    if (([[[UIDevice currentDevice] systemVersion] doubleValue] >= 8.0)) {
        const char *className = @"WKContentView".UTF8String;
        Class WKContentViewClass = objc_getClass(className);
        SEL isSecureTextEntry = NSSelectorFromString(@"isSecureTextEntry");
        SEL secureTextEntry = NSSelectorFromString(@"secureTextEntry");
        BOOL addIsSecureTextEntry = class_addMethod(WKContentViewClass, isSecureTextEntry, (IMP)isSecureTextEntryHandleIMP, "B@:");
        BOOL addSecureTextEntry = class_addMethod(WKContentViewClass, secureTextEntry, (IMP)secureTextEntryHandleIMP, "B@:");
        if (!addIsSecureTextEntry || !addSecureTextEntry) {
            
        }
    }
}

/**
 实现WKContentView对象isSecureTextEntry方法
 @return NO
 */
BOOL isSecureTextEntryHandleIMP(id sender, SEL cmd) {
    return NO;
}

/**
 实现WKContentView对象secureTextEntry方法
 @return NO
 */
BOOL secureTextEntryHandleIMP(id sender, SEL cmd) {
    return NO;
}


@end
