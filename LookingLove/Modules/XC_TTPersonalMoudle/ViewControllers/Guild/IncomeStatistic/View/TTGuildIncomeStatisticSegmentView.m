//
//  TTGuildIncomeStatisticSegmentView.m
//  TuTu
//
//  Created by lvjunhang on 2019/1/19.
//  Copyright © 2019 YiZhuan. All rights reserved.
//

#import "TTGuildIncomeStatisticSegmentView.h"

#import "XCTheme.h"
#import "XCMacros.h"

#import <Masonry/Masonry.h>

@interface TTGuildIncomeStatisticSegmentView()
/** 每日 */
@property (nonatomic, strong) UIButton *dayButton;
/** 每周 */
@property (nonatomic, strong) UIButton *weekButton;
/** line */
@property (nonatomic, strong) UIView *lineView;
@end

@implementation TTGuildIncomeStatisticSegmentView

#pragma mark - life cycle

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initView];
        [self initConstrations];
    }
    return self;
}

#pragma mark - event response
- (void)didClickButton:(UIButton *)button {
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(guildIncomeStatisticSegmentViewDidSelectIndex:)]) {
        [self.delegate guildIncomeStatisticSegmentViewDidSelectIndex:button.tag];
    }
    
    [self updateButtonWithIndex:button.tag];
}

#pragma mark - private method

- (void)initView {
    [self addSubview:self.dayButton];
    [self addSubview:self.weekButton];
    [self addSubview:self.lineView];
    
    self.dayButton.selected = YES;
    self.dayButton.titleLabel.font = [UIFont boldSystemFontOfSize:16];
}

- (void)initConstrations {
    [self.dayButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self);
        make.centerX.mas_equalTo(self.mas_left).offset(KScreenWidth * 0.25);
    }];
    
    [self.weekButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self);
        make.centerX.mas_equalTo(self.mas_right).offset(-KScreenWidth * 0.25);
    }];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(-7);
        make.width.mas_equalTo(25);
        make.height.mas_equalTo(3);
        make.centerX.mas_equalTo(self.dayButton);
    }];
}

- (void)updateButtonWithIndex:(NSInteger)index {
    if (index == 0) {
        self.dayButton.selected = YES;
        self.weekButton.selected = NO;
        
        self.dayButton.titleLabel.font = [UIFont boldSystemFontOfSize:16];
        self.weekButton.titleLabel.font = [UIFont systemFontOfSize:16];

        [self.lineView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(-7);
            make.width.mas_equalTo(25);
            make.height.mas_equalTo(4);
            make.centerX.mas_equalTo(self.dayButton);
        }];
    } else {
        self.dayButton.selected = NO;
        self.weekButton.selected = YES;
        
        self.dayButton.titleLabel.font = [UIFont systemFontOfSize:16];
        self.weekButton.titleLabel.font = [UIFont boldSystemFontOfSize:16];
        
        [self.lineView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(-7);
            make.width.mas_equalTo(25);
            make.height.mas_equalTo(3);
            make.centerX.mas_equalTo(self.weekButton);
        }];
    }
    
    [UIView animateWithDuration:0.25 animations:^{
        [self layoutIfNeeded];
    }];
}

#pragma mark - getters and setters

- (UIButton *)dayButton {
    if (!_dayButton) {
        _dayButton = [[UIButton alloc] init];
        [_dayButton setTitle:@"每日统计" forState:UIControlStateNormal];
        [_dayButton setTitleColor:[XCTheme getTTDeepGrayTextColor] forState:UIControlStateNormal];
        [_dayButton setTitleColor:UIColorFromRGB(0x1a1a1a) forState:UIControlStateSelected];
        _dayButton.titleLabel.font = [UIFont systemFontOfSize:16];
        [_dayButton addTarget:self action:@selector(didClickButton:) forControlEvents:UIControlEventTouchUpInside];
        _dayButton.tag = 0;
    }
    return _dayButton;
}

- (UIButton *)weekButton {
    if (!_weekButton) {
        _weekButton = [[UIButton alloc] init];
        [_weekButton setTitle:@"每周统计" forState:UIControlStateNormal];
        [_weekButton setTitleColor:[XCTheme getTTDeepGrayTextColor] forState:UIControlStateNormal];
        [_weekButton setTitleColor:UIColorFromRGB(0x1a1a1a) forState:UIControlStateSelected];
        _weekButton.titleLabel.font = [UIFont systemFontOfSize:16];
        [_weekButton addTarget:self action:@selector(didClickButton:) forControlEvents:UIControlEventTouchUpInside];
        _weekButton.tag = 1;
    }
    return _weekButton;
}

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = [XCTheme getTTMainColor];
        _lineView.layer.cornerRadius = 2;
        _lineView.layer.masksToBounds = YES;
    }
    return _lineView;
}

@end

