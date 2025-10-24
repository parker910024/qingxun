//
//  TTMasterHintView.m
//  TTPlay
//
//  Created by Macx on 2019/4/12.
//  Copyright © 2019 YiZhuan. All rights reserved.
//

#import "TTMasterHintView.h"

#import "AppDelegate.h"

#import "UserInfo.h"

#import "XCTheme.h"
#import "XCMacros.h"
#import <Masonry/Masonry.h>
#import "XCKeyWordTool.h"

// 窗口的高度
#define kWindowHeight (53 + kSafeAreaTopHeight)
// 动画的执行时间
#define kDuration 0.5
// 窗口的停留时间
#define kDelay 3

@interface TTMasterHintView ()
/** logo */
@property (nonatomic, strong) UIImageView *logoImageView;
/** title */
@property (nonatomic, strong) UILabel *titleLabel;
/** arrow */
@property (nonatomic, strong) UIImageView *arrowImageView;
/** bg */
@property (nonatomic, strong) UIImageView *bgImageView;
/** tapView */
@property (nonatomic, strong) UIView *tapView;

/** window */
@property (nonatomic, strong) UIWindow *window;
@end

@implementation TTMasterHintView

#pragma mark - life cycle
+ (instancetype)shareMasterHintView
{
    static dispatch_once_t onceToken = 0;
    static id instance;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initView];
        [self initConstrations];
    }
    return self;
}

#pragma mark - public methods
- (void)show {
    if (_window) {
        return;
    }
    
    self.window = [[UIWindow alloc] initWithFrame:CGRectMake(0, -kWindowHeight, [UIScreen mainScreen].bounds.size.width, kWindowHeight)];
    self.window.backgroundColor = [UIColor clearColor];
    self.window.windowLevel = UIWindowLevelStatusBar + 50.f;;
    self.window.rootViewController = [UIViewController new];
    self.window.userInteractionEnabled = YES;
    [self.window.rootViewController.view addSubview:self];
    
    [self.window makeKeyAndVisible];
    
    AppDelegate *deleage = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [deleage.window makeKeyWindow];
    
    // 状态栏 也是一个window
    // UIWindowLevelAlert > UIWindowLevelStatusBar > UIWindowLevelNormal
    
    [UIView animateWithDuration:kDuration animations:^{
        CGRect frame = self.window.frame;
        frame.origin.y = 0;
        self.window.frame = frame;
    }completion:^(BOOL finished) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(kDelay * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self dismiss];
        });
    }];
}

- (void)dismiss {
    [UIView animateWithDuration:kDuration animations:^{
        CGRect frame = self.window.frame;
        frame.origin.y = -kWindowHeight;
        self.window.frame = frame;
    } completion:^(BOOL finished) {
        self.window = nil;
    }];
}

#pragma mark - [系统控件的Protocol]   //注意要把名字改掉，这个MARK只做功能划分，不是一个真正的MARK，每个不一样的Protocol，需要一个新的MARK”

#pragma mark - [自定义控件的Protocol] //注意要把名字改掉，这个MARK只做功能划分，不是一个真正的MARK，每个不一样的Protocol，需要一个新的MARK”

#pragma mark - [core相关的Protocol]  //注意要把名字改掉，这个MARK只做功能划分，不是一个真正的MARK，每个不一样的Protocol，需要一个新的MARK”

#pragma mark - event response
- (void)didClickTapView:(UITapGestureRecognizer *)tap {
    if (self.delegate && [self.delegate respondsToSelector:@selector(masterHintView:didTapActionView:)]) {
        [self.delegate masterHintView:self didTapActionView:tap.view];
    }
}

#pragma mark - private method

- (void)initView {
    self.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, kWindowHeight);
    self.userInteractionEnabled = YES;
    [self addSubview:self.bgImageView];
    [self.bgImageView addSubview:self.logoImageView];
    [self.bgImageView addSubview:self.titleLabel];
    [self.bgImageView addSubview:self.arrowImageView];
    [self.bgImageView addSubview:self.tapView];
}

- (void)initConstrations {
    
    CGFloat top = kSafeAreaTopHeight;
    // 状态栏高度 > 普通状态栏高度
    if (statusbarHeight > 20) {
        UIView *whiteView = [[UIView alloc] init];
        whiteView.backgroundColor = [UIColor whiteColor];
        [self addSubview:whiteView];
        [whiteView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self);
            make.width.mas_equalTo(KScreenWidth);
            make.top.mas_equalTo(self);
            make.height.mas_equalTo(statusbarHeight - 20);
        }];
    }
    
    [self.bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self);
        make.width.mas_equalTo(KScreenWidth);
        make.top.mas_equalTo(top);
        make.height.mas_equalTo(53);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.bgImageView.mas_centerX).offset(9);
        make.centerY.mas_equalTo(self.logoImageView);
    }];
    
    [self.logoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.titleLabel.mas_left).offset(-5);
        make.top.mas_equalTo(9);
        make.width.height.mas_equalTo(16);
    }];
    
    [self.arrowImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.titleLabel.mas_right).offset(5);
        make.centerY.mas_equalTo(self.logoImageView);
        make.width.mas_equalTo(4);
        make.height.mas_equalTo(6);
    }];
    
    [self.tapView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.width.top.mas_equalTo(self.bgImageView);
        make.height.mas_equalTo(16 + 18);
    }];
}

#pragma mark - getters and setters

- (UIImageView *)logoImageView {
    if (!_logoImageView) {
        _logoImageView = [[UIImageView alloc] init];
        _logoImageView.image = [UIImage imageNamed:@"puding_logo"];
        _logoImageView.layer.cornerRadius = 8;
        _logoImageView.layer.masksToBounds = YES;
    }
    return _logoImageView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.text = [NSString stringWithFormat:@"%@：您收到一条收徒消息哦！", [XCKeyWordTool sharedInstance].myAppName];
        _titleLabel.font = [UIFont systemFontOfSize:13];
        _titleLabel.textColor = [XCTheme getTTMainTextColor];
    }
    return _titleLabel;
}

- (UIImageView *)arrowImageView {
    if (!_arrowImageView) {
        _arrowImageView = [[UIImageView alloc] init];
        _arrowImageView.image = [UIImage imageNamed:@"master_hint_arrow"];
    }
    return _arrowImageView;
}

- (UIImageView *)bgImageView {
    if (!_bgImageView) {
        _bgImageView = [[UIImageView alloc] init];
        _bgImageView.image = [UIImage imageNamed:@"master_hint_bg"];
        _bgImageView.userInteractionEnabled = YES;
    }
    return _bgImageView;
}

- (UIView *)tapView {
    if (!_tapView) {
        _tapView = [[UIView alloc] init];
        _tapView.backgroundColor = [UIColor clearColor];
        _tapView.userInteractionEnabled = YES;
        [_tapView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didClickTapView:)]];
    }
    return _tapView;
}

@end
