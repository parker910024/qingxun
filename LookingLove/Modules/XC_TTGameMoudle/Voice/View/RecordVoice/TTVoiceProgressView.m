//
//  TTVoiceProgressView.m
//  XC_TTGameMoudle
//
//  Created by fengshuo on 2019/5/31.
//  Copyright © 2019 YiZhuan. All rights reserved.
//

#import "TTVoiceProgressView.h"
#import "XCTheme.h"

@interface TTVoiceProgressView  ()
@property (nonatomic, strong) CAShapeLayer *outLayer;
@property (nonatomic, strong) CAShapeLayer *progressLayer;

/** 宽度 */
@property (nonatomic, assign) CGFloat lineWidth;
@end

@implementation TTVoiceProgressView

#pragma mark - Life Style
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
    }
    return self;
}

- (instancetype)initWithLineWidth:(CGFloat)lineWidth {
    if (self = [self initWithFrame:CGRectZero]) {
        self.lineWidth = lineWidth;
        [self setupSubviews];
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    CGRect rect = CGRectMake(self.lineWidth / 2, self.lineWidth / 2, self.frame.size.width - self.lineWidth, self.frame.size.height - self.lineWidth);
    UIBezierPath *path = [UIBezierPath bezierPathWithOvalInRect:rect];
    self.outLayer.path = path.CGPath;
    self.progressLayer.path = path.CGPath;
}

#pragma mark - puble method

/** 更新进度 0-1 */
- (void)updateProgress:(CGFloat)progress {
    [CATransaction begin];
    [CATransaction setAnimationTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn]];
    [CATransaction setAnimationDuration:0.5];
    self.progressLayer.strokeEnd = progress;
    [CATransaction commit];
}

#pragma mark - Private
- (void)setupSubviews {
    self.transform = CGAffineTransformMakeRotation(-M_PI_2);
    
    [self.layer addSublayer:self.outLayer];
    [self.layer addSublayer:self.progressLayer];
}

#pragma mark - Getter
- (CAShapeLayer *)progressLayer{
    if (!_progressLayer) {
        _progressLayer = [CAShapeLayer layer];
        _progressLayer.fillColor = [UIColor clearColor].CGColor;
        _progressLayer.strokeColor = [UIColor whiteColor].CGColor;
        _progressLayer.lineWidth = self.lineWidth;
        _progressLayer.lineCap = kCALineCapRound;
    }
    return _progressLayer;
}

- (CAShapeLayer *)outLayer {
    if (!_outLayer) {
        _outLayer = [CAShapeLayer layer];
        _outLayer.strokeColor = UIColorRGBAlpha(0x6C62F5, 0.1).CGColor;
        _outLayer.lineWidth = self.lineWidth;
        _outLayer.fillColor =  [UIColor clearColor].CGColor;
        _outLayer.lineCap = kCALineCapRound;
    }
    return _outLayer;
}

@end
