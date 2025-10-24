//
//  CALayer+XCCorner.m
//  XCChatViewKit
//
//  Created by KevinWang on 2019/6/19.
//  Copyright © 2019 WUJIE INTERACTIVE. All rights reserved.


#import "CALayer+XCCorner.h"
#import "XCCornerModel.h"
#import <objc/runtime.h>

@implementation CALayer (XCCorner)

static const char *XC_layer_key = "XC_layer_key";
static const char *XC_corner_key = "XC_corner_key";

- (CAShapeLayer *)XC_layer {
    CAShapeLayer *layer = objc_getAssociatedObject(self, &XC_layer_key);
    if (!layer) {
        layer = [CAShapeLayer layer];
        layer.frame = self.bounds;
        [self insertSublayer:layer atIndex:0];
        self.XC_layer = layer;
    }
    return layer;
}

- (void)setXC_layer:(CAShapeLayer *)XC_layer {
    objc_setAssociatedObject(self, &XC_layer_key, XC_layer, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (XCCorner *)XC_corner {
    XCCorner *corner = objc_getAssociatedObject(self, &XC_corner_key);
    if (!corner) {
        corner = [[XCCorner alloc] init];
        self.XC_corner = corner;
    }
    return corner;
}

- (void)setXC_corner:(XCCorner *)XC_corner {
    objc_setAssociatedObject(self, &XC_corner_key, XC_corner, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)updateCornerRadius:(void (^)(XCCorner *))handler {
    if (handler) {
        handler(self.XC_corner);
    }
    CGColorRef fill = self.XC_corner.fillColor.CGColor;
    if (!fill || CGColorEqualToColor(fill, [UIColor clearColor].CGColor)) {
        if (!self.backgroundColor || CGColorEqualToColor(self.backgroundColor, [UIColor clearColor].CGColor)) {
            if (!self.XC_corner.borderColor || CGColorEqualToColor(self.XC_corner.borderColor.CGColor, [UIColor clearColor].CGColor)) {
                return;
            }
        }
        fill = self.backgroundColor;
        self.backgroundColor = [UIColor clearColor].CGColor;
    }
    
    XCRadius radius = self.XC_corner.radius;
    if (radius.upLeft < 0) {
        radius.upLeft = 0;
    }
    if (radius.upRight < 0) {
        radius.upRight = 0;
    }
    if (radius.downLeft < 0) {
        radius.downLeft = 0;
    }
    if (radius.downRight < 0) {
        radius.downRight = 0;
    }
    if (self.XC_corner.borderWidth <= 0) {
        self.XC_corner.borderWidth = 1;
    }
    UIBezierPath *path = [UIBezierPath bezierPath];
    CGFloat height = self.bounds.size.height;
    CGFloat width = self.bounds.size.width;
    //左下
    [path moveToPoint:CGPointMake(radius.upLeft, 0)];
    [path addQuadCurveToPoint:CGPointMake(0, radius.upLeft) controlPoint:CGPointZero];
    //左上
    [path addLineToPoint:CGPointMake(0, height - radius.downLeft)];
    [path addQuadCurveToPoint:CGPointMake(radius.downLeft, height) controlPoint:CGPointMake(0, height)];
    //右上
    [path addLineToPoint:CGPointMake(width - radius.downRight, height)];
    [path addQuadCurveToPoint:CGPointMake(width, height - radius.downRight) controlPoint:CGPointMake(width, height)];
    //右下
    [path addLineToPoint:CGPointMake(width, radius.upRight)];
    [path addQuadCurveToPoint:CGPointMake(width - radius.upRight, 0) controlPoint:CGPointMake(width, 0)];
    [path closePath];
    [path addClip];
    
    self.XC_layer.fillColor = fill;
    self.XC_layer.strokeColor = self.XC_corner.borderColor.CGColor;
    self.XC_layer.lineWidth = self.XC_corner.borderWidth;
    self.XC_layer.path = path.CGPath;
}

@end
