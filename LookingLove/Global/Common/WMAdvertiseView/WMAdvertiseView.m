//
//  AdvertiseView.m
//  JinSeShiJi
//
//  Created by zn on 16/8/10.
//
//

#import "WMAdvertiseView.h"

#import "XCMacros.h"
#import "UIImage+Resize.h"
//core
#import "ImLoginCore.h"

//tool
#import "XCCurrentVCStackManager.h"
#import "XCAlertControllerCenter.h"
#import <sys/sysctl.h>
#import <sys/utsname.h>

//bridge
#import "XCMediator+TTRoomMoudleBridge.h"

#import "TTWKWebViewViewController.h"
#import "TTPopup.h"

@interface WMAdvertiseView()

@property (nonatomic, strong) UIImageView *adView;//广告图片

@property (nonatomic, strong) UIButton *countdownButton;//倒计时、跳过按钮

@property (nonatomic, strong) NSTimer *countTimer;

@property (nonatomic, assign) int count;

@property (nonatomic, strong) UIWindow *window;

@end

// 广告显示的时间
static int const showtime = 3;

@implementation WMAdvertiseView

- (void)dealloc {
    
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        _adView = [[UIImageView alloc] initWithFrame:frame];
        _adView.userInteractionEnabled = YES;
        _adView.contentMode = UIViewContentModeScaleAspectFill;
        _adView.clipsToBounds = YES;
        [self addSubview:_adView];

        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTapAdViewAction)];
        [_adView addGestureRecognizer:tap];
        
        // 因为倒数跳秒问题，导致无法及时响应事件，经测试提案说无法接受此结果。所以就做成和安卓一样，去掉倒计时和跳过
        if ([self needCountDownBtn]) {
            [self addSubview:self.countdownButton];
        }
    }
    return self;
}

#pragma mark - Public Methods
- (void)show {
    // 倒计时方法1：GCD
    [self gcdCoundownHander];
    
    // 倒计时方法2：定时器
//    [self startTimer];
    
    [self.window.rootViewController.view addSubview:self];
    [self.window makeKeyAndVisible];
}

#pragma mark - Timer Methods
// 定时器倒计时
- (void)startTimer {
    _count = showtime;
    
    self.countTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerCountdownHandler) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:self.countTimer forMode:NSRunLoopCommonModes];
}

/// 定时器倒计时
- (void)timerCountdownHandler {
    _count--;
    
    NSString *title = [NSString stringWithFormat:@"跳过"];
    [_countdownButton setTitle:title forState:UIControlStateNormal];
    
    if (_count == 0) {
        [self dismissWithJumpHandle:NO];
    }
}

// GCD倒计时方法
- (void)gcdCoundownHander {
    __block int timeout = showtime;
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    dispatch_source_set_timer(_timer, DISPATCH_TIME_NOW, 1.0 * NSEC_PER_SEC, 0); //每秒执行

    dispatch_source_set_event_handler(_timer, ^{
        
        if (timeout <= 0) { //倒计时结束，关闭
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                [self dismissWithJumpHandle:NO];
            });
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (self.countdownButton) {
                    [self.countdownButton setTitle:@"跳过" forState:UIControlStateNormal];
                }
            });
            timeout--;
        }
    });
    dispatch_resume(_timer);
}

#pragma mark - Actions
/// 点击闪屏操作
- (void)onTapAdViewAction {
    [self dismissWithJumpHandle:YES];
}

/// 点击跳过按钮
- (void)onClickSkipButton:(UIButton *)sender {
    [self dismissWithJumpHandle:NO];
}

#pragma mark - Ad Hander
// 移除广告页面
- (void)dismissWithJumpHandle:(BOOL)shouldJump {
    
    if (self.countTimer) {
        [self.countTimer invalidate];
        self.countTimer = nil;
    }
    
    @weakify(self)
    [UIView animateWithDuration:0.5f animations:^{
        @strongify(self)
        self.window.hidden = YES;

    } completion:^(BOOL finished) {
        @strongify(self)
        
        [self removeFromSuperview];
        self.window = nil;
        
        !self.dismissHandler ?: self.dismissHandler(shouldJump);
    }];
}

#pragma mark - Privite Method
- (NSString *)deviceName {
    // Gets a string with the device model
    size_t size;
    int nR = sysctlbyname("hw.machine", NULL, &size, NULL, 0);
    char *machine = (char *)malloc(size);
    nR = sysctlbyname("hw.machine", machine, &size, NULL, 0);
    NSString *platform = [NSString stringWithCString:machine encoding:NSUTF8StringEncoding];
    free(machine);
    return platform;
}

- (BOOL)needCountDownBtn {
    NSString *platform = [self deviceName];
    BOOL needBtn = YES;
    if ([platform isEqualToString:@"iPhone6,1"]) {
//        return @"iPhone 5S";
        needBtn = NO;
    }
    if ([platform isEqualToString:@"iPhone6,2"]) {
//        return @"iPhone 5S";
        needBtn = NO;
    }

    if ([platform isEqualToString:@"iPhone7,1"]) {
//        return @"iPhone 6";
        needBtn = NO;
    }

    if ([platform isEqualToString:@"iPhone7,2"]) {
//        return @"iPhone 6 Plus";
        needBtn = NO;
    }

    if ([platform isEqualToString:@"iPhone8,1"]) {
//        return @"iPhone 6s";
        needBtn = NO;
    }

    if ([platform isEqualToString:@"iPhone8,2"]) {
//        return @"iPhone 6s Plus";
        needBtn = NO;
    }

    if ([platform isEqualToString:@"iPhone8,4"]) {
//        return @"iPhone SE";
        needBtn = NO;
    }
    return needBtn;
}

#pragma mark - Lazy Load
- (void)setFilePath:(NSString *)filePath {
    _filePath = filePath;
    UIImage *image = [UIImage imageWithContentsOfFile:filePath];
    _adView.image =  [image cutImage:[UIScreen mainScreen].bounds.size];
}

- (void)setAdImage:(UIImage *)adImage {
    _adImage = adImage;
    _adView.image = [adImage cutImage:[UIScreen mainScreen].bounds.size];
}

- (UIWindow *)window {
    if (_window == nil) {
        _window = [[UIWindow alloc] initWithFrame:UIScreen.mainScreen.bounds];
        _window.windowLevel = UIWindowLevelAlert;
        _window.userInteractionEnabled = YES;
        _window.rootViewController = [[UIViewController alloc] init];
    }
    return _window;
}

- (UIButton *)countdownButton {
    if (_countdownButton == nil) {
        CGFloat btnW = 60;
        CGFloat btnH = 30;
        _countdownButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _countdownButton.frame = CGRectMake(KScreenWidth - btnW - 24, btnH + 10, btnW, btnH);
        [_countdownButton addTarget:self action:@selector(onClickSkipButton:) forControlEvents:UIControlEventTouchUpInside];
        [_countdownButton setTitle:@"跳过" forState:UIControlStateNormal];
        _countdownButton.titleLabel.font = [UIFont systemFontOfSize:15];
        [_countdownButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _countdownButton.backgroundColor = [UIColor colorWithRed:38 /255.0 green:38 /255.0 blue:38 /255.0 alpha:0.6];
        _countdownButton.layer.cornerRadius = 4;
    }
    return _countdownButton;
}

@end
