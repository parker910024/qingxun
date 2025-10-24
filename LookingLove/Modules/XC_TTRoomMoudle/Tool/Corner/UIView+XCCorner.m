//
//  UIView+XCCorner.m
//  XCChatViewKit
//
//  Created by KevinWang on 2019/6/19.
//  Copyright © 2019 WUJIE INTERACTIVE. All rights reserved.


#import "UIView+XCCorner.h"
#import "CALayer+XCCorner.h"
#import "XCCornerModel.h"

@implementation UIView (XCCorner)

- (void)updateCornerRadius:(void (^)(XCCorner *))handler {
    if (handler) {
        handler(self.layer.XC_corner);
    }
    if (!self.layer.XC_corner.fillColor || CGColorEqualToColor(self.layer.XC_corner.fillColor.CGColor, [UIColor clearColor].CGColor)) {
        if (CGColorEqualToColor(self.backgroundColor.CGColor, [UIColor clearColor].CGColor)) {
            if (!self.layer.XC_corner.borderColor || CGColorEqualToColor(self.layer.XC_corner.borderColor.CGColor, [UIColor clearColor].CGColor)) {
                return;
            }
        }
        self.layer.XC_corner.fillColor = self.backgroundColor;
        self.backgroundColor = [UIColor clearColor];
    }
    [self.layer updateCornerRadius:handler];
}

@end
