//
//  TTRedEntranceView.m
//  XC_TTRoomMoudle
//
//  Created by lvjunhang on 2020/5/11.
//  Copyright © 2020 WUJIE INTERACTIVE. All rights reserved.
//

#import "TTRedEntranceView.h"

#import "RoomRedListItem.h"

#import "XCTheme.h"
#import "XCMacros.h"
#import "SVGAImageView.h"
#import "SVGAParserManager.h"

#import <Masonry/Masonry.h>
#import <MZTimerLabel/MZTimerLabel.h>

NSString *const TTRedEntranceViewDrawCountdownNotify = @"TTRedEntranceViewDrawCountdownNotify";

@interface TTRedEntranceView ()<MZTimerLabelDelegate>
@property (nonatomic, strong) UIImageView *bgImageView;
@property (nonatomic, strong) UIImageView *circleImageView;
@property (nonatomic, strong) UIImageView *logoImageView;
@property (nonatomic, strong) UIImageView *countdownBgImageView;//倒计时背景
@property (nonatomic, strong) MZTimerLabel *countdownLabel;//可抢红包倒计时

/// 抢红包的定时器
@property (nonatomic, strong) NSTimer *drawTimer;

/// 倒计时
@property (nonatomic, assign) NSInteger countdown;

/// 当前红包
@property (nonatomic, strong, nullable) RoomRedListItem *redItem;

@property (nonatomic, strong) SVGAParserManager *parserManager;
@property (nonatomic, strong) SVGAImageView *drawSVGAImageView;//”抢“动画

@end

@implementation TTRedEntranceView
- (void)dealloc {
    self.delegate = nil;
    [self removeDrawTimer];
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = UIColor.clearColor;
        [self layoutUI];
        [self setupDrawIconAnimation];
        
        UITapGestureRecognizer *tapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapView)];
        [self addGestureRecognizer:tapGR];
        
        UIPanGestureRecognizer *panGR = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(changeLocation:)];
        // 这里的delaysTouchesBegan属性很明显就是对touchBegin方法是否进行延迟,
        // YES表示延迟,即在系统未识别出来手势为什么手势时先不要调用touchesBegan方法;
        // NO表示不延迟,即在系统未识别出来手势为什么手势时会先调用touchesBegan方法;
        panGR.delaysTouchesBegan = YES;
        [self addGestureRecognizer:panGR];
    }
    return self;
}

- (void)layoutUI {
    [self addSubview:self.bgImageView];
    [self.bgImageView addSubview:self.circleImageView];
    [self.bgImageView addSubview:self.logoImageView];
    [self.bgImageView addSubview:self.countdownBgImageView];
    [self.countdownBgImageView addSubview:self.countdownLabel];
    [self.bgImageView addSubview:self.drawSVGAImageView];
    
    [self.bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];
    
    [self.circleImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(10);
        make.centerX.mas_equalTo(0);
        make.width.height.mas_equalTo(22);
    }];
    
    [self.logoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(self.circleImageView);
    }];
    
    [self.countdownBgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.bottom.mas_equalTo(-5);
    }];
    
    [self.countdownLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.countdownBgImageView);
    }];
    
    [self.drawSVGAImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];
}

/// 抢，动画
- (void)setupDrawIconAnimation {
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"room_red_entrance_draw" ofType:@"svga"];
    if (!path) {
        return;
    }
    NSURL *url = [NSURL fileURLWithPath:path];
    
    @weakify(self)
    [self.parserManager loadSvgaWithURL:url completionBlock:^(SVGAVideoEntity * _Nullable videoItem) {
        
        @strongify(self)
        if (videoItem.images.count > 0) {
            self.drawSVGAImageView.videoItem = videoItem;
            [self.drawSVGAImageView startAnimation];
        }
        
    } failureBlock:^(NSError * _Nullable error) {
        
    }];
}

/// 抢，SVGA动画显示隐藏
/// @param show 显示/隐藏
- (void)drawIconAnimationShow:(BOOL)show {
    
    if (show) {
        
        //如果本来就是显示的，不再执行
        if (!self.drawSVGAImageView.hidden) {
            return;
        }
        
        @weakify(self)
        [UIView animateWithDuration:0.3 animations:^{
            @strongify(self)
            self.circleImageView.transform = CGAffineTransformMakeScale(0.01, 0.01);
        } completion:^(BOOL finished) {
            @strongify(self)
            self.drawSVGAImageView.hidden = NO;
        }];
    } else {
        
        //如果本来就是隐藏的，不再执行
        if (self.drawSVGAImageView.hidden) {
            return;
        }
        
        @weakify(self)
        self.drawSVGAImageView.hidden = YES;
        [UIView animateWithDuration:0.3 animations:^{
            @strongify(self)
            self.circleImageView.transform = CGAffineTransformMakeScale(1, 1);
        } completion:^(BOOL finished) {
        }];
    }
}

#pragma mark - Public
/// 更新倒计时
/// @param redItem 红包模型
- (void)updateCountdownWithRedItem:(RoomRedListItem *)redItem {
    
    self.redItem = redItem;
    
    [self.countdownLabel pause];
    [self.countdownLabel reset];
    self.countdownLabel.text = nil;
    self.countdownBgImageView.hidden = !redItem;

    if (!redItem) {
        [self drawIconAnimationShow:NO];
        return;
    }
    
    if (redItem.openStatus) {
        
        self.countdownLabel.text = @"抢夺中";

        if (redItem.alreadyOpen) {
            //已抢过不再弹出抢红包页面
            [self drawIconAnimationShow:YES];
            return;
        }
        
        //抢夺中
        [self startDraw];
        return;
    }
    
    [self drawIconAnimationShow:NO];
    
    NSInteger seconds = redItem.openSecond;
    if (seconds > 0) {
        self.redItem.overSecond -= seconds;
        [self.countdownLabel setCountDownTime:seconds];
        [self.countdownLabel start];
    }
}

/// 显示动画
- (void)showAnimation {
    //位移动画
    CASpringAnimation *posAni = [CASpringAnimation animationWithKeyPath:@"position"];
    posAni.fromValue = [NSValue valueWithCGPoint:CGPointMake(self.center.x+43+10, self.center.y)];
    posAni.toValue = [NSValue valueWithCGPoint:self.center];
    posAni.stiffness = 70;
    posAni.damping = 7;
    posAni.initialVelocity = 5;
    
    //旋转动画
    CASpringAnimation *transAni = [CASpringAnimation animationWithKeyPath:@"transform.rotation.z"];
    transAni.fromValue = @((45)/180.0*M_PI);
    transAni.toValue = @0;
    transAni.stiffness = 70;
    transAni.damping = 7;
    transAni.initialVelocity = 5;
    
    CAAnimationGroup *aniGroup = [CAAnimationGroup animation];
    aniGroup.animations = @[posAni, transAni];
    aniGroup.duration = 2;
    
    [self.layer addAnimation:aniGroup forKey:nil];
}

#pragma mark - Red Event
/// 开始抢
- (void)startDraw {

    self.countdownLabel.text = @"抢夺中";
    [self drawIconAnimationShow:YES];
    
    //抢夺时间倒计时
    [self addDrawTimer];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(entranceView:startDraw:)]) {
        [self.delegate entranceView:self startDraw:self.redItem];
    }
}

/// 结束抢
- (void)endDraw {
    
    self.countdownLabel.text = nil;
    self.countdownBgImageView.hidden = YES;
    [self drawIconAnimationShow:NO];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(entranceView:endDraw:)]) {
        [self.delegate entranceView:self endDraw:self.redItem];
    }
}

#pragma mark - Timer
/// 执行定时器
- (void)timerCountdownHandler {
    
    self.redItem.overSecond -= 1;
    if (self.redItem.overSecond <= 0) {
        [self removeDrawTimer];
        
        [self endDraw];
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:TTRedEntranceViewDrawCountdownNotify object:@(self.redItem.overSecond)];
}

/// 添加定时器
- (void)addDrawTimer {
    if (self.redItem.overSecond <= 0) {
        [self timerCountdownHandler];
        return;
    }
    
    [self removeDrawTimer];
    
    self.drawTimer = [NSTimer timerWithTimeInterval:1 target:self selector:@selector(timerCountdownHandler) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:self.drawTimer forMode:NSRunLoopCommonModes];
}

/// 移除定时器
- (void)removeDrawTimer {
    if (self.drawTimer) {
        [self.drawTimer invalidate];
        self.drawTimer = nil;
    }
}

#pragma mark - MZTimerLabelDelegate
- (void)timerLabel:(MZTimerLabel*)timerLabel finshedCountDownTimerWithTime:(NSTimeInterval)countTime {
    //红包预热倒计时结束，开始抢夺红包
    [self startDraw];
}

- (NSString *)timerLabel:(MZTimerLabel*)timerLabel customTextToDisplayAtTime:(NSTimeInterval)time {
    
    if (time == NAN || time < 0) {
        return nil;
    }
    
    int min = (int)time/60;
    int sec = (int)time%60;
    NSString *timeForm = [NSString stringWithFormat:@"%2d:%02d", min, sec];
    if (min > 99) {
        timeForm = [NSString stringWithFormat:@"%d:%02d", min, sec];
    }
    
    return timeForm;
}

#pragma mark - Event
- (void)didTapView {
    if (self.delegate && [self.delegate respondsToSelector:@selector(didSelectedEntranceView:)]) {
        [self.delegate didSelectedEntranceView:self];
    }
}

- (void)changeLocation:(UIPanGestureRecognizer*)p {
    // 就是悬浮小球底下的那个的window,就是APPdelegete里面的那个window属性
    // 获取正在显示的那个界面的Window,http://www.jianshu.com/p/d23763e60e94
    UIWindow *appWindow = [UIApplication sharedApplication].delegate.window;
    
    CGPoint panPoint = [p locationInView:appWindow];
    
    if (p.state == UIGestureRecognizerStateBegan) {
        self.alpha = 1;
    } else if(p.state == UIGestureRecognizerStateChanged) {
        self.center = CGPointMake(panPoint.x, panPoint.y);
    } else if(p.state == UIGestureRecognizerStateEnded
             || p.state == UIGestureRecognizerStateCancelled) {
        
        self.alpha = 1;
        CGFloat touchWidth = self.frame.size.width;
        CGFloat touchHeight = self.frame.size.height;
        CGFloat screenWidth = [[UIScreen mainScreen] bounds].size.width;
        CGFloat screenHeight = [[UIScreen mainScreen] bounds].size.height;
        // fabs 是取绝对值的意思
        CGFloat left = fabs(panPoint.x);
        CGFloat right = fabs(screenWidth - left);
        CGFloat top = fabs(panPoint.y);
        CGFloat minSpace = MIN(left, right);
        CGPoint newCenter;
        CGFloat targetY = 0;
        
        //校正Y
        if (panPoint.y < 15 + touchHeight / 2.0) {
            targetY = 15 + touchHeight / 2.0;
        } else if (panPoint.y > (screenHeight - touchHeight / 2.0 - 15)) {
            targetY = screenHeight - touchHeight / 2.0 - 15;
        } else {
            targetY = panPoint.y;
        }
        
        if (minSpace == left) {
            newCenter = CGPointMake(15+touchHeight/2.0, targetY);
        } else if (minSpace == right) {
            newCenter = CGPointMake(screenWidth - touchHeight/2.0 - 15, targetY);
        } else if (minSpace == top) {
            newCenter = CGPointMake(panPoint.x, touchWidth / 3);
        } else {
            newCenter = CGPointMake(panPoint.x, screenHeight - touchWidth / 3);
        }
        
        [UIView animateWithDuration:0.25 animations:^{
            if (newCenter.y + self.frame.size.height / 2 > KScreenHeight - kSafeAreaBottomHeight - 44) {
                self.center = CGPointMake(newCenter.x, KScreenHeight - self.frame.size.height / 2 - kSafeAreaBottomHeight - 44);
            } else {
                self.center = newCenter;
            }
        }];
        
    } else {
        NSLog(@"pan state : %zd", p.state);
    }
}

#pragma mark - Lazy Load
- (UIImageView *)bgImageView {
    if (_bgImageView == nil) {
        _bgImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"room_red_entrance_bg"]];
    }
    return _bgImageView;
}

- (UIImageView *)circleImageView {
    if (_circleImageView == nil) {
        _circleImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"room_red_entrance_circle"]];
    }
    return _circleImageView;
}

- (UIImageView *)logoImageView {
    if (_logoImageView == nil) {
        _logoImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"room_red_entrance_logo"]];
        _logoImageView.hidden = YES;
    }
    return _logoImageView;
}

- (UIImageView *)countdownBgImageView {
    if (_countdownBgImageView == nil) {
        _countdownBgImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"room_red_entrance_box"]];
        _countdownBgImageView.hidden = YES;
    }
    return _countdownBgImageView;
}

- (MZTimerLabel *)countdownLabel {
    if (_countdownLabel == nil) {
        _countdownLabel = [[MZTimerLabel alloc] init];
        _countdownLabel.delegate = self;
        _countdownLabel.timerType = MZTimerLabelTypeTimer;
        _countdownLabel.font = [UIFont boldSystemFontOfSize:8];
        _countdownLabel.textColor = UIColorFromRGB(0xF55151);
        _countdownLabel.textAlignment = NSTextAlignmentCenter;
        _countdownLabel.text = @"00:00";
    }
    return _countdownLabel;
}

- (SVGAParserManager *)parserManager {
    if (_parserManager == nil) {
        _parserManager = [[SVGAParserManager alloc] init];
    }
    return _parserManager;
}

- (SVGAImageView *)drawSVGAImageView {
    if (_drawSVGAImageView == nil) {
        _drawSVGAImageView = [[SVGAImageView alloc] init];
        _drawSVGAImageView.autoPlay = YES;
        _drawSVGAImageView.loops = INT_MAX;
        _drawSVGAImageView.clearsAfterStop = NO;
        _drawSVGAImageView.hidden = YES;
    }
    return _drawSVGAImageView;
}

@end
