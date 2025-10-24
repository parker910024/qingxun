//
//  TTSelectDateView.m
//  TTPlay
//
//  Created by lee on 2019/3/15.
//  Copyright © 2019 YiZhuan. All rights reserved.
//

#import "TTSelectDateView.h"
#import <Masonry/Masonry.h>
#import "XCTheme.h"
#import "XCMacros.h"
#import "UIView+ZJFrame.h"

// tool
#import "PLTimeUtil.h"
@interface TTSelectDateView ()
@property (nonatomic, strong) UILabel *dateLabel;
@property (nonatomic, strong) UIButton *todayBtn;
@property (nonatomic, strong) UIButton *selectDayBtn;
@end

@implementation TTSelectDateView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initViews];
        [self initConstraints];
    }
    return self;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self initViews];
        [self initConstraints];
    }
    return self;
}
#pragma mark -
#pragma mark lifeCycle
- (void)initViews {
    [self addSubview:self.dateLabel];
    [self addSubview:self.todayBtn];
    [self addSubview:self.selectDayBtn];
}

- (void)initConstraints {
    [self.dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.centerY.mas_equalTo(self);
    }];
    
    [self.selectDayBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-15);
        make.centerY.mas_equalTo(self);
    }];
    
    [self.todayBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.selectDayBtn.mas_left).offset(-5);
        make.centerY.mas_equalTo(self);
    }];
}

#pragma mark -
#pragma mark clients

#pragma mark -
#pragma mark private methods

#pragma mark -
#pragma mark button click events
// 选择当天
- (void)onClickTodayBtnAction:(UIButton *)todayBtn {
    self.dateLabel.text = [PLTimeUtil getYYMMDDWithDate:[NSDate date]];
    !_selecteDayHandler ? : _selecteDayHandler(selectDateTypeToady);
}
// 选择一个日期
- (void)onClickSelectDayBtnAction:(UIButton *)selectDayBtn {
    !_selecteDayHandler ? : _selecteDayHandler(selectDateTypeChooseDay);
}
#pragma mark -
#pragma mark getter & setter
- (void)setTodayText:(NSString *)todayText {
    _todayText = todayText;
    self.dateLabel.text = todayText;
}

- (UILabel *)dateLabel
{
    if (!_dateLabel) {
        _dateLabel = [[UILabel alloc] init];
        _dateLabel.text = [PLTimeUtil getYYMMDDWithDate:[NSDate date]];
        _dateLabel.textColor = [XCTheme getTTDeepGrayTextColor];
        _dateLabel.font = [UIFont systemFontOfSize:18.f];
        _dateLabel.adjustsFontSizeToFitWidth = YES;
    }
    return _dateLabel;
}

- (UIButton *)todayBtn {
    if (!_todayBtn) {
        _todayBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_todayBtn setImage:[UIImage imageNamed:@"Bill_todayIcon"] forState:UIControlStateNormal];
        [_todayBtn addTarget:self action:@selector(onClickTodayBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _todayBtn;
}

- (UIButton *)selectDayBtn {
    if (!_selectDayBtn) {
        _selectDayBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_selectDayBtn setImage:[UIImage imageNamed:@"BillList_calendarIcon"] forState:UIControlStateNormal];
        [_selectDayBtn addTarget:self action:@selector(onClickSelectDayBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _selectDayBtn;
}

@end
