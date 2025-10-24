//
//  TTCustomBaseNavView.m
//  TTPlay
//
//  Created by lee on 2019/4/11.
//  Copyright © 2019 YiZhuan. All rights reserved.
//

#import "TTCustomBaseNavView.h"
#import <Masonry/Masonry.h>
#import "XCTheme.h"
#import "XCMacros.h"
#import "UIView+ZJFrame.h"

@interface TTCustomBaseNavView ()
@property (nonatomic, strong) UIButton *leftButton;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIButton *rightBtn;
@end

@implementation TTCustomBaseNavView
#pragma mark -
#pragma mark - lifeCycle

- (instancetype)init {
    if (self = [super init]) {
        [self initViews];
    }
    return self;
}


- (void)initViews {
    
    [self addSubview:self.leftButton];
    [self addSubview:self.titleLabel];
    [self addSubview:self.rightBtn];
    
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
    
    [self.rightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-14);
        make.bottom.mas_equalTo(0);
        make.height.mas_equalTo(44);
        make.width.mas_equalTo(44);
    }];
}
#pragma mark -
#pragma mark clients

#pragma mark -
#pragma mark private methods

#pragma mark -
#pragma mark button click events

#pragma mark -
#pragma mark getter & setter
#pragma mark - Actions
- (void)leftButtonTapped {
    if (self.delegate && [self.delegate respondsToSelector:@selector(didClickBackButtonInMissionNavView:)]) {
        [self.delegate didClickBackButtonInMissionNavView:self];
    }
}

- (void)rightBtnClickAction {
    if (self.delegate && [self.delegate respondsToSelector:@selector(didClickRightBtn:)]) {
        [self.delegate didClickRightBtn:self];
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
        _titleLabel.text = @"萝卜记录";
        _titleLabel.font = [UIFont systemFontOfSize:18];
    }
    return _titleLabel;
}

- (UIButton *)rightBtn {
    if (!_rightBtn) {
        _rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_rightBtn setImage:[UIImage imageNamed:@"carrot_nav_item_help_white"] forState:UIControlStateNormal];
        [_rightBtn addTarget:self action:@selector(rightBtnClickAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _rightBtn;
}
@end
