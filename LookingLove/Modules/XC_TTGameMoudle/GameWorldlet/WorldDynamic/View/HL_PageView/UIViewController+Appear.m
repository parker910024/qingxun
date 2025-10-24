//
//  UIViewController+Appear.m
//  LTChat
//
//  Created by apple on 2019/9/18.
//  Copyright © 2019 wujie. All rights reserved.
//

#import "UIViewController+Appear.h"
#import <objc/runtime.h>

@implementation UIViewController (Appear)


+ (void)load {
    Method originalAppearM = class_getInstanceMethod([self class], @selector(viewWillAppear:));
    Method newAppearM = class_getInstanceMethod([self class], @selector(LT_ViewWillAppear:));
    method_exchangeImplementations(originalAppearM, newAppearM);
    Method originalDisappearM = class_getInstanceMethod([self class], @selector(viewWillDisappear:));
    Method newDisappearM = class_getInstanceMethod([self class], @selector(LT_ViewWillDisappear:));
    method_exchangeImplementations(originalDisappearM, newDisappearM);
}

- (void)LT_ViewWillAppear:(BOOL)animated {
    [self LT_ViewWillAppear:animated];
    self.isAppear = YES;
}

- (void)LT_ViewWillDisappear:(BOOL)animated {
    [self LT_ViewWillDisappear:animated];
    self.isAppear = NO;
}

- (void)setIsAppear:(BOOL)isAppear {
    objc_setAssociatedObject(self, @selector(isAppear), @(isAppear), OBJC_ASSOCIATION_ASSIGN);
}

- (BOOL)isAppear {
    return [objc_getAssociatedObject(self, _cmd) boolValue];
}



@end
