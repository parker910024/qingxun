//
//  TTRoomContributionNavView.m
//  TTPlay
//
//  Created by lvjunhang on 2019/3/14.
//  Copyright © 2019 YiZhuan. All rights reserved.
//

#import "TTRoomContributionNavView.h"

#import <Masonry/Masonry.h>
#import "XCTheme.h"

#import "XCMacros.h"

@interface TTRoomContributionNavView()

@property (nonatomic, strong) UIButton *halfhourRankButton;//半小时榜
@property (nonatomic, strong) UIButton *roomRankButton;//房间榜

@property (nonatomic, strong) UIView *indicatorLineView;//下划线指示

@end

@implementation TTRoomContributionNavView

#pragma mark - life cycle

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initView];
        [self initConstraints];
    }
    return self;
}

#pragma mark - public methods
- (void)updateButtonWithIndex:(NSInteger)index {
    if (index == 0) {
        [self halfhourRankButtonDidTapped:self.halfhourRankButton];
    } else if (index == 1) {
         [self halfhourRankButtonDidTapped:self.roomRankButton];
    }
}
#pragma mark - event response
- (void)halfhourRankButtonDidTapped:(UIButton *)sender {
    
    self.halfhourRankButton.titleLabel.font = [UIFont systemFontOfSize:18];
    self.roomRankButton.titleLabel.font = [UIFont systemFontOfSize:14];
    
    [self updateIndicatorLineViewLayoutForSelectControl:sender];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(didClickHalfhourRankInNavView:)]) {
        [self.delegate didClickHalfhourRankInNavView:self];
    }
}

- (void)roomRankButtonDidTapped:(UIButton *)sender {
    
    self.halfhourRankButton.titleLabel.font = [UIFont systemFontOfSize:14];
    self.roomRankButton.titleLabel.font = [UIFont systemFontOfSize:18];
    
    [self updateIndicatorLineViewLayoutForSelectControl:sender];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(didClickRoomRankInNavView:)]) {
        [self.delegate didClickRoomRankInNavView:self];
    }
}

#pragma mark - private method

- (void)initView {
    [self.halfhourRankButton setTitle:self.titleArray.firstObject
                             forState:UIControlStateNormal];
    [self.roomRankButton setTitle:self.titleArray.lastObject
                         forState:UIControlStateNormal];
    
    [self addSubview:self.halfhourRankButton];
    [self addSubview:self.roomRankButton];
    [self addSubview:self.indicatorLineView];
}

- (void)initConstraints {
    [self.halfhourRankButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.mas_equalTo(20);
        make.baseline.mas_equalTo(-17);
    }];
    
    [self.roomRankButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.mas_equalTo(self.halfhourRankButton.mas_right).offset(20);
        make.baseline.mas_equalTo(self.halfhourRankButton);
    }];
    
    [self.indicatorLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(10);
        make.height.mas_equalTo(4);
        make.centerX.mas_equalTo(self.halfhourRankButton);
        make.baseline.mas_equalTo(self.halfhourRankButton).offset(6+4);
    }];
}

//根据选中控件更新指示器约束
- (void)updateIndicatorLineViewLayoutForSelectControl:(UIButton *)control {
    if (control == nil) {
        return;
    }
    
    [self.indicatorLineView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(10);
        make.height.mas_equalTo(4);
        make.centerX.mas_equalTo(control);
        make.baseline.mas_equalTo(self.halfhourRankButton).offset(6+4);
    }];
    
    [UIView animateWithDuration:0.5 animations:^{
        [self layoutIfNeeded];
    }];
}

#pragma mark - getters and setters
- (NSArray<NSString *> *)titleArray {
    if (_titleArray == nil) {
        _titleArray = @[@"半小时榜", @"房内榜"];
    }
    return _titleArray;
}

- (UIButton *)halfhourRankButton {
    if (!_halfhourRankButton) {
        _halfhourRankButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_halfhourRankButton addTarget:self action:@selector(halfhourRankButtonDidTapped:) forControlEvents:UIControlEventTouchUpInside];
        _halfhourRankButton.titleLabel.font = [UIFont systemFontOfSize:18];
    }
    return _halfhourRankButton;
}

- (UIButton *)roomRankButton {
    if (!_roomRankButton) {
        _roomRankButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_roomRankButton addTarget:self action:@selector(roomRankButtonDidTapped:) forControlEvents:UIControlEventTouchUpInside];
        _roomRankButton.titleLabel.font = [UIFont systemFontOfSize:14];
    }
    return _roomRankButton;
}

- (UIView *)indicatorLineView {
    if (_indicatorLineView == nil) {
        _indicatorLineView = [[UIView alloc] init];
        _indicatorLineView.backgroundColor = UIColor.whiteColor;
        _indicatorLineView.layer.cornerRadius = 2;
        _indicatorLineView.layer.masksToBounds = YES;
    }
    return _indicatorLineView;
}
@end
