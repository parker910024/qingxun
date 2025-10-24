//
//  TTLittleWorldSessionGuideView.m
//  XC_TTMessageMoudle
//
//  Created by lvjunhang on 2019/7/15.
//  Copyright © 2019 WJHD. All rights reserved.
//

#import "TTLittleWorldSessionGuideView.h"

#import "UIView+NTES.h"
#import "XCMacros.h"
#import "UIImageView+QiNiu.h"
#import "XCTheme.h"

@interface TTLittleWorldSessionGuideView ()
@property (nonatomic, strong) UIImageView *imageView;//显示图片
@property (nonatomic, strong) UIButton *skipButton;//跳过指引
@property (nonatomic, assign) NSInteger currentShowIndex;//当前索引
@end

@implementation TTLittleWorldSessionGuideView

#pragma mark - Life Cycle
- (instancetype)initWithFrame:(CGRect)frame {
    
    //setting default frame
    if (CGRectEqualToRect(frame, CGRectZero)) {
        frame = UIScreen.mainScreen.bounds;
    }
    
    self = [super initWithFrame:frame];
    if (self) {
        [self initViews];
        [self initConstraints];
        
        self.currentShowIndex = 0;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureRecognizer)];
        [self.imageView addGestureRecognizer:tap];
    }
    return self;
}

- (void)dealloc {
    
}

#pragma mark - Public Methods
#pragma mark - System Protocols
#pragma mark - Custom Protocols
#pragma mark - Event Responses
- (void)tapGestureRecognizer {
    
    if (self.currentShowIndex == 0) {
        
        self.currentShowIndex ++;
        
        self.skipButton.hidden = YES;
        
        NSString *imageName = iPhoneXSeries ? @"world_guide_2_x" : @"world_guide_2";
        self.imageView.image = [UIImage imageNamed:imageName];
        return;
    }
    
    if (self.currentShowIndex == 1) {
        [self removeFromSuperview];
    }
}

- (void)didClickskipButton {
    [self removeFromSuperview];
}

#pragma mark - Private Methods
#pragma mark layout
- (void)initViews {
    [self addSubview:self.imageView];
    [self addSubview:self.skipButton];
}

- (void)initConstraints {
}

#pragma mark - Getters and Setters
- (UIImageView *)imageView {
    if (_imageView == nil) {
        _imageView = [[UIImageView alloc] init];
        _imageView.userInteractionEnabled = YES;
        _imageView.frame = self.bounds;
        
        NSString *imageName = iPhoneXSeries ? @"world_guide_1_x" : @"world_guide_1";
        _imageView.image = [UIImage imageNamed:imageName];
    }
    return _imageView;
}

- (UIButton *)skipButton {
    if (_skipButton == nil) {
        _skipButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_skipButton setTitle:@"跳过指引" forState:UIControlStateNormal];
        [_skipButton setTitleColor:UIColorRGBAlpha(0xffffff, 0.3) forState:UIControlStateNormal];
        _skipButton.titleLabel.font = [UIFont systemFontOfSize:13];
        [_skipButton addTarget:self action:@selector(didClickskipButton) forControlEvents:UIControlEventTouchUpInside];
        [_skipButton sizeToFit];
        _skipButton.centerX = self.centerX;
        _skipButton.bottom = KScreenHeight - 60 - kSafeAreaBottomHeight;
    }
    return _skipButton;
}

@end
