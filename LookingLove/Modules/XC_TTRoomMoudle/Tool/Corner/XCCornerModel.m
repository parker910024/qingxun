//
//  XCCornerModel.m
//  XCChatViewKit
//
//  Created by KevinWang on 2019/6/19.
//  Copyright © 2019 WUJIE INTERACTIVE. All rights reserved.


#import "XCCornerModel.h"

@implementation XCGradualChangingColor

- (instancetype)initWithColorFrom:(UIColor *)from to:(UIColor *)to type:(XCGradualChangeType)type {
    if (self = [super init]) {
        _fromColor = from;
        _toColor = to;
        _type = type;
    }
    return self;
}

+ (instancetype)gradualChangingColorFrom:(UIColor *)from to:(UIColor *)to {
    return [[self alloc] initWithColorFrom:from to:to type:XCGradualChangeTypeUpLeftToDownRight];
}

+ (instancetype)gradualChangingColorFrom:(UIColor *)from to:(UIColor *)to type:(XCGradualChangeType)type {
    return [[self alloc] initWithColorFrom:from to:to type:type];
}

@end


@implementation XCCorner

- (instancetype)initWithRadius:(XCRadius)radius fillColor:(UIColor *)fillColor borderColor:(UIColor *)borderColor borderWidth:(CGFloat)borderWidth {
    if (self = [super init]) {
        _radius = radius;
        _fillColor = fillColor;
        _borderColor = borderColor;
        _borderWidth = borderWidth;
    }
    return self;
}

+ (instancetype)cornerWithRadius:(XCRadius)radius fillColor:(UIColor *)fillColor {
    return [[self alloc] initWithRadius:radius fillColor:fillColor borderColor:nil borderWidth:0];
}

+ (instancetype)cornerWithRadius:(XCRadius)radius fillColor:(UIColor *)fillColor borderColor:(UIColor *)borderColor borderWidth:(CGFloat)borderWidth {
    return [[self alloc] initWithRadius:radius fillColor:fillColor borderColor:borderColor borderWidth:borderWidth];
}

@end
