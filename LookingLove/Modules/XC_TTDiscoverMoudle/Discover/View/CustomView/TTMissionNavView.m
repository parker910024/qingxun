//
//  TTMissionNavView.m
//  TTPlay
//
//  Created by lvjunhang on 2019/4/9.
//  Copyright © 2019 YiZhuan. All rights reserved.
//

#import "TTMissionNavView.h"
#import <Masonry/Masonry.h>

@interface TTMissionNavView ()
@property (nonatomic, strong) UIButton *leftButton;
@property (nonatomic, strong) UILabel *titleLabel;
@end

@implementation TTMissionNavView

- (instancetype)init {
    if (self = [super init]) {
        [self initSubViews];
    }
    return self;
}

- (void)initSubViews {
    
    [self addSubview:self.leftButton];
    [self addSubview:self.titleLabel];
    
    [self makeConstriants];
}

- (void)makeConstriants {
    [self.leftButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(8);
        make.bottom.mas_equalTo(0);
        make.height.mas_equalTo(44);
        make.width.mas_equalTo(44);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self);
        make.centerY.mas_equalTo(self.leftButton);
    }];
}

#pragma mark - Actions
- (void)leftButtonTapped {
    if (self.delegate && [self.delegate respondsToSelector:@selector(didClickBackButtonInMissionNavView:)]) {
        [self.delegate didClickBackButtonInMissionNavView:self];
    }
}

#pragma mark - Setter Getter
- (UIButton *)leftButton {
    if (!_leftButton) {
        _leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_leftButton setImage:[UIImage imageNamed:@"nav_bar_back_white"] forState:UIControlStateNormal];
        [_leftButton addTarget:self action:@selector(leftButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    }
    return _leftButton;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.text = @"任务中心";
        _titleLabel.font = [UIFont systemFontOfSize:18];
    }
    return _titleLabel;
}

@end
