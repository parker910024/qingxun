//
//  TTRoomGiftValueGuideView.m
//  AFNetworking
//
//  Created by lvjunhang on 2019/4/28.
//

#import "TTRoomGiftValueGuideView.h"

#import <Masonry/Masonry.h>
#import "XCTheme.h"
#import "XCMacros.h"
#import "UIView+ZJFrame.h"

@interface TTRoomGiftValueGuideView ()
@property (nonatomic, strong) UIImageView *guideImageView;
@property (nonatomic, assign) NSInteger index;
@property (nonatomic, strong) UIButton *skipButton;
@end

@implementation TTRoomGiftValueGuideView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initViews];
        [self initConstraints];
        [self addTapGesture];
    }
    return self;
}

#pragma mark -
#pragma mark - lifeCycle
- (void)initViews {
    [self addSubview:self.guideImageView];
    [self addSubview:self.skipButton];
}

- (void)initConstraints {
    [self.guideImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self);
    }];
    
    [self.skipButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(-60 - kSafeAreaBottomHeight);
        make.centerX.mas_equalTo(self);
    }];
}

- (void)addTapGesture {
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClickAction:)];
    [self.guideImageView addGestureRecognizer:tap];
}

- (void)skipBtnAction:(UIButton *)sender {
    [self removeFromSuperview];
    !self.didFinishGuide ?: self.didFinishGuide();
}


#pragma mark -
#pragma mark private methods
- (void)tapClickAction:(UITapGestureRecognizer *)tap {
    self.index += 1;
    if (_index == 1) {
        self.guideImageView.image = [UIImage imageNamed:iPhoneXSeries ? @"room_gift_value_1_x" : @"room_gift_value_1"];
    } else if (_index == 2) {
        self.skipButton.hidden = YES;
        self.guideImageView.image = [UIImage imageNamed:iPhoneXSeries ? @"room_gift_value_2_x" : @"room_gift_value_2"];
    } else {
        [self removeFromSuperview];
        !self.didFinishGuide ?: self.didFinishGuide();
    }
}

#pragma mark -
#pragma mark button click events

#pragma mark -
#pragma mark getter & setter
- (UIImageView *)guideImageView {
    if (!_guideImageView) {
        _guideImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:iPhoneXSeries ? @"room_gift_value_0_x" : @"room_gift_value_0"]];
        _guideImageView.userInteractionEnabled = YES;
        _guideImageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _guideImageView;
}

- (UIButton *)skipButton {
    if (!_skipButton) {
        _skipButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_skipButton setTitle:@"跳过指引" forState:UIControlStateNormal];
        [_skipButton setTitleColor:UIColorRGBAlpha(0xffffff, 0.3) forState:UIControlStateNormal];
        _skipButton.titleLabel.font = [UIFont systemFontOfSize:13];
        [_skipButton addTarget:self action:@selector(skipBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _skipButton;
}
@end

