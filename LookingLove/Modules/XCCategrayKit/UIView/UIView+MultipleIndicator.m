//
//  UIView+MultipleIndicator.m
//  YY2
//
//  Created by graoke on 13-11-15.
//  Copyright (c) 2013年 YY Inc. All rights reserved.
//

#import "UIView+MultipleIndicator.h"
#import <objc/runtime.h>

@implementation UIView (MultipleIndicator)

static char kIndicatorLayerKeys;

- (void)addIndicatorWithKey:(id)key
{
//    CAShapeLayer *circle = [CAShapeLayer layer];
//    // Make a circular shape
//    circle.path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, 7, 7)
//                                             cornerRadius:3.5].CGPath;
//    
//    // Configure the apperence of the circle
//    circle.fillColor = RGBCOLOR(255, 84, 0).CGColor;
//    circle.strokeColor = [UIColor clearColor].CGColor;
    
    UIImage *redImg = [UIImage imageNamed:@"normal_red"];
    
    CALayer * circle = [CALayer layer];
    circle.contents = (id)redImg.CGImage;
    circle.frame = CGRectMake(0, 0, redImg.size.width, redImg.size.height);
    
    NSMutableDictionary *layers = self.indicatorLayers;
    if (layers == nil) {
        layers = [NSMutableDictionary dictionary];
        self.indicatorLayers = layers;
    }
    if([self.indicatorLayers objectForKey:key]) {
        return;
    }
    
    [self.layer addSublayer:circle];
    if(circle && key)
        [self.indicatorLayers setObject:circle forKey:key];
}

- (void)removeIndicatorWithKey:(id)key
{
    if(!key)
        return;
    
    id oldLayer = [self.indicatorLayers objectForKey:key];
    [oldLayer removeFromSuperlayer];
    [self.indicatorLayers removeObjectForKey:key];
}

- (void)setIndicatorLayers:(NSMutableDictionary *)indicatorLayers
{
    objc_setAssociatedObject(self, &kIndicatorLayerKeys, indicatorLayers, OBJC_ASSOCIATION_RETAIN);
}

- (NSMutableDictionary *)indicatorLayers
{
    return objc_getAssociatedObject(self, &kIndicatorLayerKeys);
}

- (void)resetIndicatorOrigin:(CGPoint)indicatorOrigin forkey:(id)key
{
    if (self.indicatorLayers && key)
    {
        CAShapeLayer *indicatorLayer = [self.indicatorLayers objectForKey:key];
        CGRect frame = indicatorLayer.frame;
        frame.origin = indicatorOrigin;
        indicatorLayer.frame = frame;
    }
}

- (CGPoint)getindicatorOriginForkey:(id)key
{
    if (self.indicatorLayers)
    {
        CAShapeLayer *indicatorLayer = [self.indicatorLayers objectForKey:key];
        return indicatorLayer.frame.origin;
    }
    return CGPointZero;
}


@end
