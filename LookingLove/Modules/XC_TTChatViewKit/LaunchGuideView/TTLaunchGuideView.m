//
//  TTLaunchGuideView.m
//  XC_TTChatViewKit
//
//  Created by lvjunhang on 2019/5/10.
//  Copyright © 2019 YiZhuan. All rights reserved.
//

#import "TTLaunchGuideView.h"

#import "XCMacros.h"

// APP version e.g. 1.01
#define CURRENT_APP_VERSION [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]
// APP build e.g. 1
#define CURRENT_APP_BUILD [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"]

static NSString *const kLaunchGuideVersionStoreKey = @"kLaunchGuideVersionStoreKey";

@interface TTLaunchGuideView () <UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIPageControl *pageControl;

@property (nonatomic, strong) UIButton *enterButton;

@property (nonatomic, strong) NSArray *imageArray;

@property (nonatomic, copy) TTLaunchGuideViewCompletion completion;

@property (nonatomic, strong) UIWindow *window;

@end

@implementation TTLaunchGuideView

- (void)dealloc {
}

- (instancetype)initWithImages:(NSArray<NSString *> *)images {
    self = [super initWithFrame:UIScreen.mainScreen.bounds];
    if (self) {
        self.imageArray = images;
    }
    return self;
}

- (void)showWithCompletion:(nullable TTLaunchGuideViewCompletion)completion {
    self.completion = completion;

    if (![self shouldShowLaunchGuide] || !self.imageArray.count) {
        return;
    }
    
    [self addSubview:self.scrollView];
    
    if (!self.hidenPageControl) {
        [self addSubview:self.pageControl];
    }
    
    for (int i = 0; i < self.imageArray.count; i++) {
        
        NSString *imageName = self.imageArray[i];
        UIImage *image = [UIImage imageNamed:imageName];
        if (image == nil) {
            continue;
        }
        
        UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
        imageView.userInteractionEnabled = YES;
        imageView.frame = CGRectMake(KScreenWidth * i, 0, KScreenWidth, KScreenHeight);
        [self.scrollView addSubview:imageView];
        
        if (i == self.imageArray.count - 1) {
            if (!self.hidenEnterButton) {
                [imageView addSubview:self.enterButton];
            }
            
            if (self.wholeFinalPageInteractionEnabled || self.hidenEnterButton) {
                UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(completionAction)];
                [imageView addGestureRecognizer:tapGesture];
            }
        }
    }
    
    if (self.scrollView.subviews.count == 0) {
        return;
    }
        
    [self.window.rootViewController.view addSubview:self];
    [self.window makeKeyAndVisible];
}

#pragma mark - Actions
- (void)completionAction {
    
    !self.completion ?: self.completion();
    
    [[NSUserDefaults standardUserDefaults] setObject:CURRENT_APP_VERSION forKey:kLaunchGuideVersionStoreKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    @KWeakify(self)
    [UIView animateWithDuration:0.6f animations:^{
        @KStrongify(self)
        self.window.hidden = YES;

    } completion:^(BOOL finished) {
        @KStrongify(self)

        [self removeFromSuperview];
        self.window = nil;
    }];
}

#pragma mark - Private Methods
- (BOOL)shouldShowLaunchGuide {
    
#ifndef DEBUG
    self.openDebugMode = NO;
#endif
    
    if (self.openDebugMode) {
        return YES;
    }
    
    NSString *version = [[NSUserDefaults standardUserDefaults]stringForKey:kLaunchGuideVersionStoreKey];
    if (!version) {
        return YES;
    }
    
    if ([version isEqualToString:CURRENT_APP_VERSION]) {
        return NO;
    }
    
    return YES;
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView; {
    self.pageControl.currentPage = (self.scrollView.contentOffset.x + KScreenWidth / 2) / KScreenWidth;
}

#pragma mark - Lazy Load
- (void)setWholeFinalPageInteractionEnabled:(BOOL)wholeFinalPageInteractionEnabled {
    _wholeFinalPageInteractionEnabled = wholeFinalPageInteractionEnabled;
}

- (void)setHidenEnterButton:(BOOL)hidenEnterButton {
    _hidenEnterButton = hidenEnterButton;
}

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.delegate = self;
        _scrollView.frame = UIScreen.mainScreen.bounds;
        _scrollView.backgroundColor = [UIColor clearColor];
        _scrollView.bounces = NO;
        _scrollView.pagingEnabled = YES;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.contentSize = CGSizeMake(KScreenWidth * self.imageArray.count, KScreenHeight);
    }
    return _scrollView;
}

- (UIPageControl *)pageControl {
    if (!_pageControl) {
        _pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, KScreenHeight - 30, KScreenWidth, 10)];
        _pageControl.currentPage = 0;
        _pageControl.hidesForSinglePage = YES;
        _pageControl.pageIndicatorTintColor = [UIColor grayColor];
        _pageControl.currentPageIndicatorTintColor = [UIColor whiteColor];
        _pageControl.numberOfPages = self.imageArray.count;
    }
    return _pageControl;
}

- (UIButton *)enterButton {
    if (!_enterButton) {
        
        //由于设计稿给图分为 1080*1920 和 1242*2688，所以需要单独计算点
        CGFloat width = 0;
        CGFloat height = 0;
        CGFloat factor = iPhoneXSeries ? 2/3.f : 2/3.f;
        if (iPhoneXSeries) {
            width = 260.f * factor;
            height = 75.f * factor;
        } else {
            width = 226.f * factor;
            height = 65.f * factor;
        }
        
        CGFloat x = (KScreenWidth - width) / 2;
        CGFloat y = KScreenHeight - height - 100 * factor - (iPhoneXSeries ? 14 * factor : 0);
        
        _enterButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _enterButton.frame = CGRectMake(x, y, width, height);
        [_enterButton setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
        [_enterButton addTarget:self action:@selector(completionAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _enterButton;
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

@end
