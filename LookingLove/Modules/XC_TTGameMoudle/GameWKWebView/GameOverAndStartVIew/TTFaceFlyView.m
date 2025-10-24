//
//  TTFaceFlyView.m
//  AFNetworking
//
//  Created by new on 2019/4/19.
//

#import "TTFaceFlyView.h"
#import <Masonry/Masonry.h> // 约束
#import "XCMacros.h" // 约束的宏定义
#import "UIImageView+QiNiu.h"  // 加载图片
#import "XCTheme.h" // 颜色设置的宏定义

@implementation TTFaceFlyView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = UIColorRGBAlpha(0xffffff, 0);
        self.layer.anchorPoint = CGPointMake(0.5, 1);
    }
    return self;
}


- (void)animateInView:(UIView *)view withDirection:(BOOL )directionType {
    
    NSTimeInterval totalAnimationDuration = 1.5;
    
    CGFloat heartSize = CGRectGetWidth(self.bounds);
    CGFloat viewHeight = CGRectGetHeight(view.bounds);
    CGFloat viewWidth = CGRectGetWidth(view.bounds);
    //Pre-Animation setup
    self.transform = CGAffineTransformMakeScale(0, 0);
    self.alpha = 0;
    
    //Bloom
    [UIView animateWithDuration:0.5 delay:0.0 usingSpringWithDamping:0.6 initialSpringVelocity:0.8 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.transform = CGAffineTransformIdentity;
        self.alpha = 1;
    } completion:NULL];
    
    UIBezierPath *heartTravelPath = [UIBezierPath bezierPath];
    [heartTravelPath moveToPoint:self.center];
    
    //random end point
    CGPoint endPoint = CGPointZero;
    
    if (directionType) {
        
        CGPoint pointCenter = CGPointMake(viewWidth / 2 - heartSize / 2 + arc4random_uniform(viewWidth / 2),  heartSize / 2 + arc4random_uniform((viewHeight -  heartSize / 2)));
        if (pointCenter.y < viewHeight / 2) {
            endPoint = CGPointMake(viewWidth, pointCenter.y);
        }else{
            endPoint = CGPointMake(pointCenter.x, viewHeight);
        }
    }else {
        endPoint = CGPointMake(arc4random_uniform(viewWidth / 2), heartSize / 2 + arc4random_uniform((viewHeight -  heartSize / 2)));
    }
    //randomize x and y for control point
    [heartTravelPath addLineToPoint:endPoint];
    
    CAKeyframeAnimation *keyFrameAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    keyFrameAnimation.path = heartTravelPath.CGPath;
    keyFrameAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    keyFrameAnimation.duration = totalAnimationDuration;
    keyFrameAnimation.removedOnCompletion = NO;
    keyFrameAnimation.fillMode = kCAFillModeForwards;
    
    [self.layer addAnimation:keyFrameAnimation forKey:@"positionOnPath"];
    
    //Alpha & remove from superview
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:totalAnimationDuration - 1 animations:^{
            self.alpha = 0.0;
        } completion:^(BOOL finished) {
            [self removeFromSuperview];
        }];
    });
    
}


- (void)drawRect:(CGRect)rect {
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    //保存初始状态（压栈操作，保存一份当前图形上下文）
    CGContextSaveGState(context);
    //需要绘制的图片
    NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:self.imageString]];
    //需要绘制的图片
    UIImage *image = [UIImage imageWithData:imageData];
    
    CGRect rectImage = CGRectMake(0.0, 0.0, rect.size.width, (rect.size.width*image.size.height/image.size.width));
    //三种方式绘制图片
    // 1、在rect范围内完整显示图片-正常使用
    [image drawInRect:rectImage];
    
    //恢复到初始状态（出栈操作，恢复一份当前图形上下文）
    CGContextRestoreGState(context);
}

@end
