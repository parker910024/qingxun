//
//  TTCheckinAccumulatePrizeCell.m
//  TTPlay
//
//  Created by lvjunhang on 2019/3/20.
//  Copyright © 2019 YiZhuan. All rights reserved.
//

#import "TTCheckinAccumulatePrizeCell.h"

#import "XCTheme.h"
#import "XCMacros.h"
#import "UIButton+EnlargeTouchArea.h"

#import <Masonry/Masonry.h>

@implementation TTCheckinAccumulatePrizeCell

#pragma mark - Life Cycle
- (instancetype)initWithCellType:(TTCheckinAccumulatePrizeCellType)cellType {
    self = [super initWithFrame:CGRectZero];
    if (self) {
        [self initViews];
        [self initConstraints];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initViews];
        [self initConstraints];
    }
    return self;
}

- (void)dealloc {
    
}

#pragma mark - Public Methods
#pragma mark - System Protocols
#pragma mark - Custom Protocols
#pragma mark - Core Protocols
#pragma mark - Event Responses
- (void)prizeButtonTapped:(UIButton *)sender {
    
}

#pragma mark - Private Methods
- (void)initViews {
    [self addSubview:self.prizeButton];
    [self addSubview:self.titleLabel];
    [self addSubview:self.dayLabel];
}

- (void)initConstraints {
//    [self.prizeButton mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.mas_equalTo(self.connectLine);
//        make.centerY.mas_equalTo(self.connectLine);
//        make.width.height.mas_equalTo(firstButtonWidth);
//    }];
//    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.mas_equalTo(self.connectLine.mas_bottom).offset(28);
//        make.centerX.mas_equalTo(self.prizeButton);
//        make.width.mas_equalTo(self.mas_width).dividedBy(4);
//    }];
//    [self.dayLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.mas_equalTo(self.firstTitleLabel.mas_bottom).offset(8);
//        make.centerX.mas_equalTo(self.firstButton);
//        make.width.mas_equalTo(self.firstTitleLabel);
//    }];
}

#pragma mark - Getters and Setters
- (UIButton *)prizeButton {
    if (_prizeButton == nil) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setBackgroundImage:[UIImage imageNamed:@"checkin_accumulate_gift"] forState:UIControlStateNormal];
        [button setBackgroundImage:[UIImage imageNamed:@"checkin_accumulate_gift_wait_get"] forState:UIControlStateSelected];
        [button setBackgroundImage:[UIImage imageNamed:@"checkin_accumulate_checkmark"] forState:UIControlStateDisabled];
        [button addTarget:self action:@selector(prizeButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
        
        [button setEnlargeEdgeWithTop:11 right:11 bottom:11 left:11];
        
        _prizeButton = button;
    }
    return _prizeButton;
}

- (UILabel *)titleLabel {
    if (_titleLabel == nil) {
        UILabel *label = [[UILabel alloc] init];
        label.font = [UIFont systemFontOfSize:13];
        label.textColor = UIColorFromRGB(0xfefefe);
        label.textAlignment = NSTextAlignmentCenter;
        
        _titleLabel = label;
    }
    return _titleLabel;
}

- (UILabel *)dayLabel {
    if (_dayLabel == nil) {
        UILabel *label = [[UILabel alloc] init];
        label.font = [UIFont systemFontOfSize:12];
        label.textColor = UIColorFromRGB(0xfefefe);
        label.textAlignment = NSTextAlignmentCenter;
        
        _dayLabel = label;
    }
    return _dayLabel;
}
@end
