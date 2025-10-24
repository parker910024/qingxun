//
//  TTRoomOnlineNavBar.m
//  TuTu
//
//  Created by lvjunhang on 2018/11/9.
//  Copyright © 2018年 YiZhuan. All rights reserved.
//

#import "TTRoomOnlineNavBar.h"

#import <Masonry/Masonry.h>

#import "XCMacros.h"

@interface TTRoomOnlineNavBar ()
@property (nonatomic, strong) UIButton *backButton;
@property (nonatomic, strong) UILabel *titleLabel;
@end

@implementation TTRoomOnlineNavBar

#pragma mark - Life Cycle
- (instancetype)initWithFrame:(CGRect)frame {
    if (CGRectEqualToRect(frame, CGRectZero)) {
        frame = CGRectMake(0, 0, KScreenWidth, statusbarHeight+44);
    }
    
    self = [super initWithFrame:frame];
    if (self) {
        [self initViews];
        [self initConstraints];
    }
    return self;
}

#pragma mark - Public Methods
#pragma mark - System Protocols
#pragma mark - Custom Protocols
#pragma mark - Core Protocols
#pragma mark - Event Responses
- (void)backButtonTapped:(UIButton *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(navBarDidNavBack)]) {
        [self.delegate navBarDidNavBack];
    }
}

#pragma mark - Private Methods
- (void)initViews {
    self.backgroundColor = UIColor.clearColor;
    
    [self addSubview:self.backButton];
    [self addSubview:self.titleLabel];
}

- (void)initConstraints {
    [self.backButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.mas_equalTo(0);
        make.width.mas_equalTo(39);
        make.height.mas_equalTo(42);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.backButton);
        make.centerX.mas_equalTo(0);
    }];
}

#pragma mark - Getters and Setters
- (UIButton *)backButton {
    if (_backButton == nil) {
        _backButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_backButton setImage:[UIImage imageNamed:@"nav_bar_back_white"] forState:UIControlStateNormal];
        [_backButton addTarget:self action:@selector(backButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _backButton;
}

- (UILabel *)titleLabel {
    if (_titleLabel == nil) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.text = @"在线列表";
        _titleLabel.textColor = UIColor.whiteColor;
        _titleLabel.font = [UIFont systemFontOfSize:18];
    }
    return _titleLabel;
}
@end
