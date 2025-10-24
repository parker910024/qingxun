//
//  VKCircleProgressView.m
//  UKiss
//
//  Created by apple on 2019/2/19.
//  Copyright © 2019 yizhuan. All rights reserved.
//

#import "VKCircleProgressView.h"
#import "XCTheme.h"

@implementation VKCircleProgressView

- (void)drawRect:(CGRect)rect {
    CGContextRef ctx = UIGraphicsGetCurrentContext();//获取上下文
    CGPoint center = CGPointMake(rect.size.width/2, rect.size.height/2);  //设置圆心位置
    CGFloat radius = MIN(rect.size.width, rect.size.height)/2 - 2;  //设置半径
    CGFloat startA = - M_PI_2;  //圆起点位置
    CGFloat endA = -M_PI_2 + M_PI * 2 * _progress;  //圆终点位置
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:center radius:radius startAngle:startA endAngle:endA clockwise:YES];
    CGContextSetLineWidth(ctx, 4); //设置线条宽度
    [UIColorRGBAlpha(0xEF6EAC, 0.5) setStroke]; //设置描边颜色
    CGContextAddPath(ctx, path.CGPath); //把路径添加到上下文
    CGContextStrokePath(ctx);  //渲染
}

#pragma mark - life cycle

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initView];
        [self initConstrations];
    }
    return self;
}

#pragma mark - public methods

#pragma mark - [系统控件的Protocol]

#pragma mark - [自定义控件的Protocol]

#pragma mark - [core相关的Protocol] 

#pragma mark - event response

#pragma mark - private method

- (void)initView {
    
}

- (void)initConstrations {
    
}

#pragma mark - getters and setters

- (void)setProgress:(CGFloat)progress {
    _progress = progress;
    [self setNeedsDisplay];
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
