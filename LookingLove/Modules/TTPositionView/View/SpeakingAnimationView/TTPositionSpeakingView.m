//
//  TTPositionSpeakingView.m
//  TTPositionView
//
//  Created by fengshuo on 2019/5/20.
//  Copyright © 2019 fengshuo. All rights reserved.
//

#import "TTPositionSpeakingView.h"
#import <POP.h>
#import <ReactiveObjC/ReactiveObjC.h>

@interface TTPositionSpeakingView ()
@property (nonatomic,weak)CALayer * animationLayer;//动画图层

@end

@implementation TTPositionSpeakingView

-(instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.repeatCount = 1;
        
    }
    return self;
}
- (void)creatAnimation:(CGRect)rect {
    if (!self.isAnimate && ![self.layer animationForKey:@"animation4"]) {
        
        if (_borderColor==nil || _circleColor == nil) {
            self.layer.borderColor = [UIColor whiteColor].CGColor;
            self.layer.backgroundColor = [UIColor whiteColor].CGColor;
            
        }else{
            self.layer.borderColor = _borderColor.CGColor;
            self.layer.backgroundColor = _circleColor.CGColor;
        }
        
        POPBasicAnimation *animation1 = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerScaleXY];
        animation1.duration = 0.2 * _animationDuration;
        animation1.fromValue = [NSValue valueWithCGSize:CGSizeMake(1.f, 1.f)];
        animation1.toValue = [NSValue valueWithCGSize:CGSizeMake(1.f, 1.f)];
        animation1.beginTime = CACurrentMediaTime();
        animation1.repeatCount = 1;
        
        @weakify(self);
        [animation1 setAnimationDidStartBlock:^(POPAnimation *anim) {
            @strongify(self);
            self.isAnimate = YES;
        }];
        
        POPBasicAnimation *animation2 = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerScaleXY];
        animation2.beginTime = CACurrentMediaTime();
        animation2.duration = 2;
        animation2.fromValue = [NSValue valueWithCGSize:CGSizeMake(1.f, 1.f)];
        animation2.toValue = [NSValue valueWithCGSize:CGSizeMake(1.6f, 1.6f)];
        animation2.removedOnCompletion = YES;
        animation2.repeatCount = 1;
        
        POPBasicAnimation *animation3 = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerOpacity];
        animation3.duration = 0.2 * _animationDuration;
        animation3.beginTime = CACurrentMediaTime();
        animation3.fromValue = @1.0;
        animation3.toValue = @0.8;
        animation3.repeatCount = 1;
        animation3.removedOnCompletion = YES;
        
        POPBasicAnimation *animation4 = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerOpacity];
        animation4.duration = 0.8 * _animationDuration;
        animation4.beginTime = CACurrentMediaTime() + 0.2 * _animationDuration;
        animation4.fromValue = @0.8;
        animation4.toValue = @0.0;
        animation4.repeatCount = 1;
        animation4.removedOnCompletion = YES;
        
        [animation4 setCompletionBlock:^(POPAnimation *anim, BOOL finished) {
            @strongify(self);
            self.animationLayer = nil;
            self.isAnimate = NO;
        }];
        
        [self.layer pop_addAnimation:animation2 forKey:@"animation2"];
        [self.layer pop_addAnimation:animation3 forKey:@"animation3"];
        [self.layer pop_addAnimation:animation4 forKey:@"animation4"];
    }
    
}

- (void)start:(int)tag{
    
    if (!self.isAnimate && ![self.layer animationForKey:@"animation4"]) {
        [self creatAnimation:self.layer.bounds];
        
    }
}


- (void)remove:(int)tag{
    
    [self.layer removeAllAnimations];
}

@end
