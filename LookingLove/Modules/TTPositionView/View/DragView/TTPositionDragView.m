//
//  TTPositionDragView.m
//  TTPositionView
//
//  Created by fengshuo on 2019/5/20.
//  Copyright © 2019 fengshuo. All rights reserved.
//

#import "TTPositionDragView.h"

@implementation TTPositionDragView

#pragma mark - life cycle
- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initView];
        [self initContrations];
    }
    return self;
}
#pragma mark - private method
- (void)initView {
    [self addSubview:self.flanimationView];
}

- (void)initContrations {
    self.flanimationView.center = self.center;
}
#pragma mark - setters and getters
- (FLAnimatedImageView *)flanimationView {
    if (!_flanimationView) {
        _flanimationView = [[FLAnimatedImageView alloc] initWithFrame:CGRectMake(0, 0, 80, 80)];
        _flanimationView.contentMode = UIViewContentModeScaleAspectFit;
        _flanimationView.userInteractionEnabled = YES;
    }
    return _flanimationView;
}

@end
