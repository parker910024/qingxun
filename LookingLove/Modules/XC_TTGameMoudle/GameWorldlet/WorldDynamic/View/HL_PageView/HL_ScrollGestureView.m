//
//  MyTableView.m
//  HL_PageView
//
//  Created by apple on 2018/12/1.
//  Copyright © 2018 黄清华. All rights reserved.
//

#import "HL_ScrollGestureView.h"
#import "UIScrollView+Gesture.h"

@implementation HL_ScrollGestureView

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return [gestureRecognizer.view isKindOfClass:[HL_ScrollGestureView class]] &&([otherGestureRecognizer.view isKindOfClass:[UIScrollView class]] && [[otherGestureRecognizer.view valueForKeyPath:@"isMultiGesture"] boolValue]) && [gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]] && [otherGestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]];
}
@end
