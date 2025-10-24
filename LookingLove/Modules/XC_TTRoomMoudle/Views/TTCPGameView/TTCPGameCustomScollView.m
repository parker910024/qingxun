//
//  TTCPGameCustomScollView.m
//  TuTu
//
//  Created by new on 2019/1/23.
//  Copyright © 2019 YiZhuan. All rights reserved.
//

#import "TTCPGameCustomScollView.h"

@implementation TTCPGameCustomScollView


-(UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event

{
    UIView *view = [super hitTest:point withEvent:event];
    
    if (view == nil) {
        for (UIView *subView in self.subviews) {
            CGPoint myPoint = [subView convertPoint:point fromView:self];
            if (CGRectContainsPoint(subView.bounds, myPoint)) {
                return subView;
            }
        }
    }
    return view;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
