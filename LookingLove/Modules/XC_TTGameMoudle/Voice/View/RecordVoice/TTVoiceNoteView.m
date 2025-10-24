//
//  TTVoiceNoteView.m
//  XC_TTGameMoudle
//
//  Created by fengshuo on 2019/5/31.
//  Copyright © 2019 YiZhuan. All rights reserved.
//

#import "TTVoiceNoteView.h"
#import "TTVoiceVolumeQueue.h"
#import "XCTheme.h"
#import "XCMacros.h"

@interface TTVoiceNoteView ()
@property (nonatomic, strong) CADisplayLink *displayLink;
@property (nonatomic, strong) TTVoiceVolumeQueue *volumeQueue;
@property (nonatomic, assign) NSInteger waveNumber;
@end

static const NSInteger defaultWaveNumber = 1;
static NSRunLoop *_voiceWaveRunLoop;

@implementation TTVoiceNoteView
{
    CGFloat _idleAmplitude;//最小振幅
    CGFloat _amplitude;//归一化 振幅系数，与音量正相关
    CGFloat _density;//x轴粒度
    
    CGFloat _waveHeight;//波纹高
    CGFloat _waveWidth;//波纹宽
    CGFloat _waveMid;//波纹高
    CGFloat _maxAmplitude;//最大振幅
    CGFloat _mainWaveWidth;//主波纹线宽，其他波纹是它的一半，也可自定义
    
    CGFloat _phase;// (firstLine)相位
    CGFloat _phaseShift;//相位移动
    CGFloat _frequency;//频率
    CGPoint _lineCenter;
    
    CGFloat _currentVolume;
    CGFloat _lastVolume;
    CGFloat _middleVolume;
    
    CGFloat _maxWidth;//波纹显示最大宽度
    CGFloat _beginX;//波纹开始坐标
    
    CGFloat _stopAnimationRatio;//松手后避免音量过大，波纹振幅大，乘以衰减系数
    
    NSMutableArray<UIBezierPath *> *_waveLinePathArray;
    NSLock *_lock;

}


- (instancetype)init{
    self = [super init];
    if (self) {
        [self startVoiceWaveThread];
    }
    return self;
}

- (void)dealloc{
    [_displayLink invalidate];
    [self.volumeQueue cleanQueue];
}



#pragma mark - puble method

- (void)startVoiceWave{
    @KWeakify(self);
    [self setup];
    if (_voiceWaveRunLoop) {
        [self.displayLink invalidate];
        self.displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(invokeWaveCallback)];
        [self.displayLink addToRunLoop:_voiceWaveRunLoop forMode:NSRunLoopCommonModes];
    } else {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if (_voiceWaveRunLoop) {
                @KStrongify(self);
                [self.displayLink invalidate];
                self.displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(invokeWaveCallback)];
                [self.displayLink addToRunLoop:_voiceWaveRunLoop forMode:NSRunLoopCommonModes];
            }
        });
    }
}

- (void)removeFromParent{
    [_displayLink invalidate];
    [self removeFromSuperview];
}

- (void)showInParentView:(UIView *)parentView{
    if (![self.superview isKindOfClass:[parentView class]]) {
        [parentView addSubview:self];
    } else {
        [self.layer removeAllAnimations];
        return;
    }
    self.backgroundColor = [UIColor clearColor];
    
    self.frame = CGRectMake(0, parentView.bounds.size.height * 0.2+self.tag*10, parentView.bounds.size.width, parentView.bounds.size.height * 0.5);
    
    [self setup];
    [self updateMeters];
}


- (void)setVoiceWaveNumber:(NSInteger)waveNumber{
    _waveNumber = waveNumber;
}


- (void)changeVolume:(CGFloat)volume{
    @KWeakify(self);
    @synchronized (self) {
        _lastVolume = _currentVolume;
        _currentVolume = volume;
        @KStrongify(self);
        NSArray *volumeArray = [self generatePointsOfSize:6 withPowFactor:1 fromStartY:_lastVolume toEndY:_currentVolume];
        [self.volumeQueue pushVolumeWithArray:volumeArray];
    }
}


#pragma mark - private method

- (void)invokeWaveCallback{
    [self updateMeters];
}


- (void)setup{
    _frequency = 2.0f;
    _amplitude = 1.0f;
    _idleAmplitude = 0.05f;
    
    _phase = 0.0f;
    _phaseShift = -0.22f;
    _density = 1.f;
    
    _waveHeight = CGRectGetHeight(self.bounds);
    _waveWidth  = CGRectGetWidth(self.bounds);
    _waveMid    = _waveWidth / 2.0f;
    _maxAmplitude = _waveHeight * 0.3;
    
    NSInteger centerX = _waveWidth / 2;
    _lineCenter = CGPointMake(centerX, 0);
    
    _maxWidth = _waveWidth + _density;
    _beginX = 0.0;
    
    _lastVolume = 0.0;
    _currentVolume = 0.0;
    _middleVolume = 0.05;
    _stopAnimationRatio = 1.0;
    
    [_volumeQueue cleanQueue];
    _mainWaveWidth = 2;
    _waveNumber = _waveNumber > 0 ? _waveNumber : defaultWaveNumber;
    _waveLinePathArray = [NSMutableArray array];
    _lock = [[NSLock alloc] init];
}

- (void)updateMeters{
    CGFloat volume = [self.volumeQueue popVolume];
    if (volume > 0) {
        _middleVolume = volume;
    }
    _phase += _phaseShift; // Move the wave
    _amplitude = fmax(_middleVolume, _idleAmplitude);
    
    [_lock lock];
    [_waveLinePathArray removeAllObjects];
    __block CGFloat waveWidth = _mainWaveWidth;
    __block CGFloat progress = 1.0f;
    __block CGFloat amplitudeFactor = 1.0f;
    @KWeakify(self);
    dispatch_async(dispatch_get_main_queue(), ^{
        @KStrongify(self);
        int i = 0;
        if (self.tag==1) {
            i = 2;
        }
        waveWidth = i==0 ? _mainWaveWidth : _mainWaveWidth / 2.0;
        progress = 1.0f - (CGFloat)i / _waveNumber;
        amplitudeFactor = 1.5f * progress - 0.5f;
        UIBezierPath *linePath = [self generateGradientPathWithFrequency:_frequency maxAmplitude:_maxAmplitude * amplitudeFactor phase:_phase lineCenter:&_lineCenter yOffset:waveWidth / 2.0];
        [_waveLinePathArray addObject:linePath];
    });
    
    
    [_lock unlock];
    [self performSelectorOnMainThread:@selector(setNeedsDisplay) withObject:nil waitUntilDone:NO];
}

- (NSThread *)startVoiceWaveThread{
    static NSThread *_voiceWaveThread = nil;
    static dispatch_once_t oncePredicate;
    @KWeakify(self);
    dispatch_once(&oncePredicate, ^{
        @KStrongify(self);
        _voiceWaveThread =
        [[NSThread alloc] initWithTarget:self
                                selector:@selector(voiceWaveThreadEntryPoint:)
                                  object:nil];
        [_voiceWaveThread start];
    });
    return _voiceWaveThread;
}


- (void)voiceWaveThreadEntryPoint:(id)__unused object{
    @autoreleasepool {
        [[NSThread currentThread] setName:@"com.yz.VoiceWave"];
        _voiceWaveRunLoop = [NSRunLoop currentRunLoop];
        [_voiceWaveRunLoop addPort:[NSMachPort port] forMode:NSDefaultRunLoopMode];
        [_voiceWaveRunLoop run];
    }
}


- (void)drawRect:(CGRect)rect{
    CGContextRef context = UIGraphicsGetCurrentContext();
    static NSInteger offset = 0;
    CGFloat colorOffset = sin(M_PI * fmod(offset++, 255.0) / 255.0);
    
    UIColor *startColor = [UIColor colorWithRed:colorOffset green:0.0/255.0 blue:0.0/255.0 alpha:1.0];
    UIColor *endColor = [UIColor colorWithRed:0.0/255.0 green:1 - colorOffset blue:0.0/255.0 alpha:1.0];
    
    //绘制渐变
    [_lock lock];
    CGFloat progress = 1.0f;
    if (_waveLinePathArray.count == _waveNumber && _waveNumber > 0) {
        for (NSInteger i = 0; i < _waveNumber; i++) {
            
            [self drawRadialGradient:context path:_waveLinePathArray[i].CGPath startColor:UIColorFromRGB(0xffffff).CGColor endColor:UIColorRGBAlpha(0xffffff, 0.5).CGColor];
        }
    }
    [_lock unlock];
}

- (void)drawRadialGradient:(CGContextRef)context
                      path:(CGPathRef)path
                startColor:(CGColorRef)startColor
                  endColor:(CGColorRef)endColor
{
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGFloat locations[] = { 0.0, 1.0 };
    NSArray *colors = @[(__bridge id) startColor, (__bridge id) endColor];
    CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, (__bridge CFArrayRef) colors, locations);
    
    
    CGRect pathRect = CGPathGetBoundingBox(path);
    CGPoint center = CGPointMake(CGRectGetMidX(pathRect), CGRectGetMidY(pathRect));
    CGFloat radius = MAX(pathRect.size.width / 2.0, pathRect.size.height / 2.0);
    
    CGContextSaveGState(context);
    CGContextAddPath(context, path);
    CGContextEOClip(context);
    
    CGContextDrawRadialGradient(context, gradient, center, 0, center, radius, 0);
    CGContextRestoreGState(context);
    CGGradientRelease(gradient);
    CGColorSpaceRelease(colorSpace);
}

- (UIBezierPath *)generateGradientPathWithFrequency:(CGFloat)frequency maxAmplitude:(CGFloat)maxAmplitude phase:(CGFloat)phase lineCenter:(CGPoint *)lineCenter yOffset:(CGFloat)yOffset{
    UIBezierPath *wavelinePath = [UIBezierPath bezierPath];
    
    // (-(2x-1)^2+1)sin (2pi*f*x)
    // (-(2x-1)^2+1)sin (2pi*f*x + 3.0)
    
    CGFloat normedAmplitude = fmin(_amplitude, 1.0);
    if (_maxWidth < _density || _waveMid <= 0) {
        return nil;
    }
    CGFloat x = _beginX;
    CGFloat y = 0;
    for(; x<_maxWidth; x += _density) {
        CGFloat scaling = -pow(x / _waveMid  - 1, 2) + 1; // make center bigger
        
        y = scaling * maxAmplitude * normedAmplitude * _stopAnimationRatio * sinf(2 * M_PI *(x / _waveWidth) * frequency + phase) + (_waveHeight * 0.5 - yOffset);
        
        if (_beginX == x) {
            [wavelinePath moveToPoint:CGPointMake(x, y)];
        }
        else {
            [wavelinePath addLineToPoint:CGPointMake(x, y)];
        }
        if (fabs(lineCenter->x - x) < 0.01) {
            lineCenter->y = y;
        }
    }
    x = x - _density;
    [wavelinePath addLineToPoint:CGPointMake(x, y + 2 * yOffset)];
    
    for(; x>=_beginX; x -= _density) {
        CGFloat scaling = -pow(x / _waveMid  - 1, 2) + 1; // make center bigger
        
        y = scaling * maxAmplitude * normedAmplitude * _stopAnimationRatio * sinf(2 * M_PI *(x / _waveWidth) * frequency + phase) + (_waveHeight * 0.5 + yOffset);
        
        [wavelinePath addLineToPoint:CGPointMake(x, y)];
    }
    x = x + _density;
    [wavelinePath addLineToPoint:CGPointMake(x, y - 2 * yOffset)];
    
    return wavelinePath;
}

/**
 *  音量插值
 *
 *  @param size   插值返回音量个数(包含起始点、不包含末尾节点)
 *  @param factor 插值系数，(0~1 : 变化率从大到小  1~2 : 变化率从小到大)
 参考
 http://zh.numberempire.com/graphingcalculator.php
 pow(x,0.2),pow(x,0.3),pow(x,0.4),pow(x,0.5),pow(x,0.6),pow(x,0.7),pow(x,0.8),pow(x,0.9)
 *  @param y1     起始插值音量，取值范围0~1
 *  @param y2     终止插值音量，取值范围0~1
 *
 *  @return 插值后音量数组
 */
- (NSArray *)generatePointsOfSize:(NSInteger)size
                    withPowFactor:(CGFloat)factor
                       fromStartY:(CGFloat)y1
                           toEndY:(CGFloat)y2
{
    BOOL factorValid = factor < 2 && factor > 0 && factor != 0;
    BOOL y1Valid = 0 <= y1 && y1 <= 1;
    BOOL y2Valid = 0 <= y2 && y2 <= 1;
    if (!(factorValid && y1Valid && y2Valid)) {
        return nil;
    }
    
    NSMutableArray *mArray = [NSMutableArray arrayWithCapacity:size];
    
    CGFloat x1,x2;
    x1 = pow(y1,1/factor);
    x2 = pow(y2,1/factor);
    
    CGFloat pieceOfX = (x2 - x1) / size;
    CGFloat x,y;
    
    [mArray addObject:[NSNumber numberWithFloat:y1]];
    
    for (int i = 1; i < size; ++i) {
        x = x1 + pieceOfX * i;
        y = pow(x, factor);
        
        [mArray addObject:[NSNumber numberWithFloat:y]];
    }
    
    return [mArray copy];
}

#pragma mark - getters

- (TTVoiceVolumeQueue *)volumeQueue{
    if (!_volumeQueue) {
        self.volumeQueue = [[TTVoiceVolumeQueue alloc] init];
    }
    return _volumeQueue;
}


@end
