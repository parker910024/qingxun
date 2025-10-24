//
//  UIImage+RoundedCorner.m
//  YYMobile
//
//  Created by LevinYan on 16/1/17.
//  Copyright © 2016年 YY.inc. All rights reserved.
//

#import "UIImage+RoundedCorner.h"


@implementation UIImage (RoundedCorner)



- (UIImage*)changeToRoundedCorner
{
    CGFloat w = self.size.width;
    CGFloat h = self.size.height;
    
    CGFloat radius = MIN(w, h) / 2.;
    CGRect frame = CGRectMake(0, 0, 2*radius, 2*radius);

    UIImage *image = nil;
    UIGraphicsBeginImageContext(frame.size);
    [[UIBezierPath bezierPathWithRoundedRect:frame cornerRadius:radius] addClip];
    [self drawInRect:frame];
    image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

@end
