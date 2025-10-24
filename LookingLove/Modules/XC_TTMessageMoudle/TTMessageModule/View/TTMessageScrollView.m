//
//  TTMessageScrollView.m
//  XC_TTMessageMoudle
//
//  Created by KevinWang on 2019/4/28.
//  Copyright © 2019 WJHD. All rights reserved.
//

#import "TTMessageScrollView.h"

@implementation TTMessageScrollView

-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    
    if (gestureRecognizer.state != 0) {
        return YES;
    } else {
        return NO;
    }
}

@end
