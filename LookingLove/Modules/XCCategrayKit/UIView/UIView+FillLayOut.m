//
//  UIView+IMLayOut.m
//  YYMobile
//
//  Created by James Pend on 14-8-20.
//  Copyright (c) 2014年 YY.inc. All rights reserved.
//

#import "UIView+FillLayOut.h"

@implementation UIView (FillLayOut)

- (void)pinSubview:(UIView *)subview toEdge:(NSLayoutAttribute)attribute
{
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self
                                                     attribute:attribute
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:subview
                                                     attribute:attribute
                                                    multiplier:1.0f
                                                      constant:0.0f]];

}


- (void)pinAllEdgesOfSubview:(UIView *)subview
{
    [self pinSubview:subview toEdge:NSLayoutAttributeBottom];
    [self pinSubview:subview toEdge:NSLayoutAttributeTop];
    [self pinSubview:subview toEdge:NSLayoutAttributeLeading];
    [self pinSubview:subview toEdge:NSLayoutAttributeTrailing];
}


@end
