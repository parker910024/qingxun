//
//  UIScrollView+Gesture.m
//  LTChat
//
//  Created by apple on 2019/7/31.
//  Copyright © 2019 wujie. All rights reserved.
//

#import "UIScrollView+Gesture.h"
#import <objc/runtime.h>

@implementation UIScrollView (Gesture)

- (void)setIsMultiGesture:(BOOL)isMultiGesture {
    objc_setAssociatedObject(self, @selector(isMultiGesture), @(isMultiGesture), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)isMultiGesture {
    return [objc_getAssociatedObject(self, _cmd) boolValue];
}

@end
