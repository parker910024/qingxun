//
//  YYLoadingToastView.m
//  YYMobile
//
//  Created by 武帮民 on 14-8-13.
//  Copyright (c) 2014年 YY.inc. All rights reserved.
//

#import "YYLoadingToastView.h"
#import "XCTheme.h"
#import "XCMacros.h"

const NSInteger interval = 1.5f;

@interface YYLoadingToastView ()

@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, strong) UIView * animationView;

@property (nonatomic, strong) NSString *loadingMsg;

/** 兔兔自定义loading 图片数组 */
@property (nonatomic, strong) NSArray *ttLoadingImages;
/** 兔兔自定义loading 白色bg */
@property (nonatomic, strong) UIView *ttLoadingBGView;
/** 兔兔自定义loading imageView */
@property (nonatomic, strong) UIImageView *ttLoadingImageView;
/** 兔兔自定义loading title */
@property (nonatomic, strong) UILabel *ttLoadingTitleLabel;
@end

@implementation YYLoadingToastView

+ (instancetype)instantiateLoadingToast {
    YYLoadingToastView *view = [self instantiateLoadingToastWithText:nil];
    return view;
}

+ (instancetype)instantiateLoadingToastWithText:(NSString *)msg {
    YYLoadingToastView *view;
    
    if (projectType() == ProjectType_Pudding) { // tutu专用loading
        view = [[YYLoadingToastView alloc] initTTCustomLoading];
    } else {
        view = [[YYLoadingToastView alloc] initWithLoadingView:msg];
    }
    
    return view;
}

- (instancetype)initWithLoadingView:(NSString *)msg {
    self = [super init];
    
    if (self) {
        
        self.loadingMsg = msg;
        
        [self loadLoadingView];
        [self animationWithView:self.animationView];
        
        _timer = [NSTimer scheduledTimerWithTimeInterval:interval target:self selector:@selector(timerFireMethod:) userInfo:nil repeats:YES];
        
    }
    
    return self;
}

- (void)loadLoadingView {
    
    UIView *wrapperView = [[UIView alloc] init];
    wrapperView.backgroundColor = [UIColor clearColor];

    UIImageView *circleImag = [[UIImageView alloc] init];
    circleImag.image = [UIImage imageNamed:@"icon_loading_circle"];
    [circleImag sizeToFit];
    
    wrapperView.frame = CGRectMake(0.0, 0.0, 200, 200);
    
    CGPoint viewCenter = wrapperView.center;
    
    circleImag.center = viewCenter;
    
    [wrapperView addSubview:circleImag];
    
    if (self.loadingMsg && self.loadingMsg.length) {
        UILabel *label = [UILabel new];
        label.backgroundColor = [UIColor clearColor];
        label.text = self.loadingMsg;
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = [UIColor whiteColor];
        label.font = [UIFont systemFontOfSize:13 weight:UIFontWeightBold];
        label.frame = CGRectMake(0, viewCenter.y + 30, 200, 20);
        [wrapperView addSubview:label];
    }
    
    self.animationView = circleImag;
    // 动画
    //[self animationWithView:circleImag];
    
    self.frame = wrapperView.frame;
    
    wrapperView.frame = self.bounds;
    wrapperView.backgroundColor = UIColorRGBAlpha(0x000000, 0.6);
    wrapperView.layer.cornerRadius = 10;
    wrapperView.layer.masksToBounds = YES;
    [self addSubview:wrapperView];
}

- (void)animationWithView:(UIView *)view {
    
    CABasicAnimation* rotationAnimation;
    rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.toValue = [NSNumber numberWithFloat:M_PI * 2.0];
    rotationAnimation.duration = interval;
    rotationAnimation.cumulative = YES;
    rotationAnimation.repeatCount = 1;
    
    [view.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
    
}

- (void)timerFireMethod:(id)sender {
    
    if (self.superview == nil) {
        [self.timer invalidate];
    } else {
        [self animationWithView:self.animationView];
    }
    
}

- (void)dealloc {

    [_timer invalidate];
    _timer = nil;
}

#pragma mark -
- (void)viewContrller:(UIViewController *)viewContrller orientation:(UIInterfaceOrientation)fromInterfaceOrientation {
    
    self.center = [[[UIApplication sharedApplication] keyWindow] center];
}

#pragma mark - --------------tutu自定义loading--------------------
- (instancetype)initTTCustomLoading {
    self = [super init];
    if (self) {
        [self ttInitView];
    }
    return self;
}

#pragma mark - private
- (void)ttInitView {
    // 灰色蒙层
    UIView *bgView = [[UIView alloc] init];
    bgView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.35];
    bgView.frame = CGRectMake(-450, -700, 1000, 1800);
    [self addSubview:bgView];
    
    self.backgroundColor = [UIColor clearColor];
    [self addSubview:self.ttLoadingBGView];
    [self.ttLoadingBGView addSubview:self.ttLoadingImageView];
    [self.ttLoadingBGView addSubview:self.ttLoadingTitleLabel];
    
    self.ttLoadingBGView.frame = CGRectMake(0, 0, 168, 133);
    self.frame = self.ttLoadingBGView.frame;
    self.ttLoadingImageView.frame = CGRectMake(66, 18, 37, 70);
    self.ttLoadingTitleLabel.frame = CGRectMake(0, 100, self.frame.size.width, 15);
    
    self.ttLoadingImageView.animationImages = self.ttLoadingImages;
    self.ttLoadingImageView.animationDuration = 1.0;
    self.ttLoadingImageView.animationRepeatCount = 0;
    [self.ttLoadingImageView startAnimating];
}

#pragma mark - getter
- (NSArray *)ttLoadingImages {
    if (!_ttLoadingImages) {
        _ttLoadingImages = @[[UIImage imageNamed:@"loading_custom_0"],
                           [UIImage imageNamed:@"loading_custom_1"],
                           [UIImage imageNamed:@"loading_custom_2"],
                           [UIImage imageNamed:@"loading_custom_3"],
                           [UIImage imageNamed:@"loading_custom_4"],
                           [UIImage imageNamed:@"loading_custom_5"],
                           [UIImage imageNamed:@"loading_custom_6"],
                           [UIImage imageNamed:@"loading_custom_7"],
                           [UIImage imageNamed:@"loading_custom_8"],
                           [UIImage imageNamed:@"loading_custom_9"],
                           [UIImage imageNamed:@"loading_custom_10"],
                           [UIImage imageNamed:@"loading_custom_11"],
                           [UIImage imageNamed:@"loading_custom_12"],
                           [UIImage imageNamed:@"loading_custom_13"]];
    }
    return _ttLoadingImages;
}

- (UIView *)ttLoadingBGView {
    if (!_ttLoadingBGView) {
        _ttLoadingBGView = [[UIView alloc] init];
        _ttLoadingBGView.layer.cornerRadius = 20;
        _ttLoadingBGView.backgroundColor = [UIColor whiteColor];
    }
    return _ttLoadingBGView;
}

- (UIImageView *)ttLoadingImageView {
    if (!_ttLoadingImageView) {
        _ttLoadingImageView = [[UIImageView alloc] init];
    }
    return _ttLoadingImageView;
}

- (UILabel *)ttLoadingTitleLabel {
    if (!_ttLoadingTitleLabel) {
        _ttLoadingTitleLabel = [[UILabel alloc] init];
        _ttLoadingTitleLabel.textColor = [UIColor colorWithRed:(153.0)/255.0f green:(153.0)/255.0f blue:(153.0)/255.0f alpha:1];
        _ttLoadingTitleLabel.font = [UIFont systemFontOfSize:14];
        _ttLoadingTitleLabel.text = @" loading...";
        _ttLoadingTitleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _ttLoadingTitleLabel;
}

@end
