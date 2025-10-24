//
//  TTMissionGuildView.m
//  TTPlay
//
//  Created by lee on 2019/3/29.
//  Copyright © 2019 YiZhuan. All rights reserved.
//

#import "TTMissionGuildView.h"
#import <Masonry/Masonry.h>
#import "XCTheme.h"
#import "XCMacros.h"
#import "UIView+ZJFrame.h"
#define is_iPhoneXSerious @available(iOS 11.0, *) && UIApplication.sharedApplication.keyWindow.safeAreaInsets.bottom > 0.0
@interface TTMissionGuildView ()

@property (nonatomic, strong) UIImageView *guildImageView;
@property (nonatomic, assign) NSInteger index;
@property (nonatomic, strong) UIButton *skipButton;

@end

@implementation TTMissionGuildView

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
    [self addSubview:self.guildImageView];
    [self addSubview:self.skipButton];
}

- (void)initConstraints {
    [self.guildImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self);
    }];
    
    [self.skipButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(-60 - kSafeAreaBottomHeight);
        make.centerX.mas_equalTo(self);
    }];
}

- (void)addTapGesture {
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClickAction:)];
    [self.guildImageView addGestureRecognizer:tap];
}

- (void)skipBtnAction:(UIButton *)sender {
    [self removeFromSuperview];
}

#pragma mark -
#pragma mark private methods
- (void)tapClickAction:(UITapGestureRecognizer *)tap {
    self.index += 1;
    if (_index == 1) {
        self.guildImageView.image = [UIImage imageNamed:is_iPhoneXSerious ? @"mission_guild_x_1" : @"mission_guild_1"];
    } else if (_index == 2) {
        self.guildImageView.image = [UIImage imageNamed:is_iPhoneXSerious ? @"mission_guild_x_2" : @"mission_guild_2"];
    } else if (_index == 3) {
        self.skipButton.hidden = YES;
        self.guildImageView.image = [UIImage imageNamed:is_iPhoneXSerious ? @"mission_guild_x_3" : @"mission_guild_3"];
    } else {
        [self removeFromSuperview];
    }
}

#pragma mark -
#pragma mark button click events

#pragma mark -
#pragma mark getter & setter
- (UIImageView *)guildImageView {
    if (!_guildImageView) {
        _guildImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:is_iPhoneXSerious ? @"mission_guild_x_0" : @"mission_guild_0"]];
        _guildImageView.userInteractionEnabled = YES;
        _guildImageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _guildImageView;
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
