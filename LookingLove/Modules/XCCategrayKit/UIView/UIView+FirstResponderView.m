//
//  UIView+FirstResponderView.m
//  YYMobileFramework
//
//  Created by 武帮民 on 14-6-30.
//  Copyright (c) 2014年 YY Inc. All rights reserved.
//

#import "UIView+FirstResponderView.h"

@implementation UIView (FirstResponderView)

- (UIView *)firstResponderView {
    
    if ([self isFirstResponder]) {
        
        return self;
    }
    
    for (UIView *subview in self.subviews) {
        UIView *firstResponder = subview.firstResponderView;
        if (firstResponder) {
            return firstResponder;
        }
    }
    return nil;
}

@end
