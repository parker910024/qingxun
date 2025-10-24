//
//  TTVoiceMatchingNavView.m
//  XC_TTGameMoudle
//
//  Created by Macx on 2019/5/30.
//  Copyright © 2019 YiZhuan. All rights reserved.
//

#import "TTVoiceMatchingNavView.h"

#import <Masonry/Masonry.h>
#import "XCMacros.h"
#import "XCTheme.h"

@interface TTVoiceMatchingNavView ()
/** back */
@property (nonatomic, strong) UIButton *backButton;
/** title */
@property (nonatomic, strong) UILabel *titleLabel;
/** 选择性别按钮 */
@property (nonatomic, strong) UIButton *selectSexButton;
@end

@implementation TTVoiceMatchingNavView

#pragma mark - life cycle

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initView];
        [self initConstrations];
    }
    return self;
}

#pragma mark - public methods

#pragma mark - [系统控件的Protocol]   //注意要把名字改掉，这个MARK只做功能划分，不是一个真正的MARK，每个不一样的Protocol，需要一个新的MARK”

#pragma mark - [自定义控件的Protocol] //注意要把名字改掉，这个MARK只做功能划分，不是一个真正的MARK，每个不一样的Protocol，需要一个新的MARK”

#pragma mark - [core相关的Protocol]  //注意要把名字改掉，这个MARK只做功能划分，不是一个真正的MARK，每个不一样的Protocol，需要一个新的MARK”

#pragma mark - event response
- (void)didClickBackButton:(UIButton *)button {
    if (self.backButtonDidClickAction) {
        self.backButtonDidClickAction();
    }
}

- (void)didClickSelectSexButton:(UIButton *)button {
    if (self.selectSexButtonDidClickAction) {
        self.selectSexButtonDidClickAction();
    }
}

#pragma mark - private method

- (void)initView {
    [self addSubview:self.backButton];
    [self addSubview:self.titleLabel];
    [self addSubview:self.selectSexButton];
}

- (void)initConstrations {
    [self.backButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(3);
        make.width.mas_equalTo(9 + 22 + 4);
        make.height.mas_equalTo(17 + 10);
        make.bottom.mas_equalTo(-8);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.backButton);
        make.centerX.mas_equalTo(self);
    }];
    
    [self.selectSexButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-5);
        make.width.height.mas_equalTo(18 + 8 + 10);
        make.bottom.mas_equalTo(-9);
    }];
}

#pragma mark - getters and setters

- (UIButton *)backButton {
    if (!_backButton) {
        _backButton = [[UIButton alloc] init];
        [_backButton setImage:[UIImage imageNamed:@"nav_bar_back_white"] forState:UIControlStateNormal];
        [_backButton addTarget:self action:@selector(didClickBackButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _backButton;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.text = @"";
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.font = [UIFont boldSystemFontOfSize:18];
    }
    return _titleLabel;
}

- (UIButton *)selectSexButton {
    if (!_selectSexButton) {
        _selectSexButton = [[UIButton alloc] init];
        [_selectSexButton setImage:[UIImage imageNamed:@"voice_select_sex_btn"] forState:UIControlStateNormal];
        [_selectSexButton addTarget:self action:@selector(didClickSelectSexButton:) forControlEvents:UIControlEventTouchUpInside];
        _selectSexButton.hidden = YES;
    }
    return _selectSexButton;
}
@end
