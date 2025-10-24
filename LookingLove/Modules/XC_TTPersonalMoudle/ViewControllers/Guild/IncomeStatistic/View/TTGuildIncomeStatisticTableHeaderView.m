//
//  TTGuildIncomeStatisticTableHeaderView.m
//  TuTu
//
//  Created by lvjunhang on 2019/1/19.
//  Copyright © 2019 YiZhuan. All rights reserved.
//

#import "TTGuildIncomeStatisticTableHeaderView.h"

#import "XCTheme.h"
#import "XCMacros.h"

#import <Masonry/Masonry.h>
#import "PLTimeUtil.h"
#import "NSDate+Util.h"
#import "NSDate+TimeCategory.h"
#import <YYText/YYText.h>

@interface TTGuildIncomeStatisticTableHeaderView()
@property (nonatomic, strong) UIImageView *bgImageView;//背景
@property (nonatomic, strong) UILabel *yearLabel;//年
@property (nonatomic, strong) UILabel *fromDayLabel;//开始天
@property (nonatomic, strong) UILabel *toDayLabel;//结束天，如过隐藏，自动居中
@property (nonatomic, strong) UIStackView *dayStackView;//开始天-结束天 绑定
@property (nonatomic, strong) UIImageView *arrowImageView;//箭头
@property (nonatomic, strong) UILabel *totalDesLabel;//总收入
@property (nonatomic, strong) UILabel *totalLabel;//金币
@property (nonatomic, strong) UIView *lineView;//分割线
@property (nonatomic, strong) UIButton *selectDayButton;//选择日期
@end

@implementation TTGuildIncomeStatisticTableHeaderView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = UIColor.whiteColor;
        
        [self initView];
        [self initConstraints];
        [self setupDefaultDate];
        [self setupTotalNumber:0];
    }
    return self;
}

#pragma mark - Public Methods
- (void)setupTotalNumber:(NSInteger)number {
    NSString *numberStr = @(number).stringValue;
    NSString *unit = @"金币";
    if (number > 10000) {
        unit = @"万金币";
        numberStr = [NSString stringWithFormat:@"%.2f", number/10000.0f];
    }
    
    NSString *content = [NSString stringWithFormat:@"%@%@", numberStr, unit];
    NSRange unitRange = [content rangeOfString:unit];
    
    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:content];
    [attr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12] range:unitRange];
    
    self.totalLabel.attributedText = attr;
}

- (void)configDateStartTime:(NSString *)start endTime:(NSString *)endTime {
    
}

- (void)setupDefaultDate {
    [self setSelectDate:[NSDate date]];
}

#pragma mark - Even Response
- (void)selectDayButtonTapped {
    if (self.selectDayActionBlock) {
        self.selectDayActionBlock();
    }
}

#pragma mark - Private Methods
- (void)initView {
    
    [self addSubview:self.bgImageView];
    [self.bgImageView addSubview:self.yearLabel];
    [self.bgImageView addSubview:self.arrowImageView];
    [self.bgImageView addSubview:self.selectDayButton];
    [self.bgImageView addSubview:self.dayStackView];
    [self.bgImageView addSubview:self.lineView];
    [self.bgImageView addSubview:self.totalDesLabel];
    [self.bgImageView addSubview:self.totalLabel];
}

- (void)initConstraints {
    [self.bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.right.mas_equalTo(self).inset(15);
        make.height.mas_equalTo(self.bgImageView.mas_width).multipliedBy(BGIMAGE_ASPECT_RATIO);
    }];
    
    [self.yearLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(16);
        make.left.mas_equalTo(15);
    }];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(115);
        make.width.mas_equalTo(0.5);
        make.height.mas_equalTo(40);
        make.bottom.mas_equalTo(-8);
    }];
    
    [self.selectDayButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.mas_equalTo(0);
        make.top.mas_equalTo(self.lineView);
        make.right.mas_equalTo(self.lineView.mas_left);
    }];
    
    [self.dayStackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.lineView);
        make.left.mas_equalTo(self.yearLabel);
    }];
    
    [self.arrowImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.lineView);
        make.right.mas_equalTo(self.lineView.mas_left).offset(-16);
    }];
    
    [self.totalDesLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.yearLabel);
        make.left.mas_equalTo(self.lineView.mas_right).offset(18);
    }];
    
    [self.totalLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.lineView).offset(4);
        make.left.mas_equalTo(self.totalDesLabel);
    }];
}

#pragma mark -
#pragma mark methods
- (NSMutableAttributedString *)configAttributedMonth:(NSString *)month day:(NSString *)day {
    
    NSString *string = [NSString stringWithFormat:@"%@月%@日", month, day];
    
    NSRange monthRange = [string rangeOfString:month];
    NSRange dayRange = [string rangeOfString:day];
    
    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:string];
    attStr.yy_font = [UIFont systemFontOfSize:10];
    [attStr yy_setFont:[UIFont systemFontOfSize:15] range:monthRange];
    [attStr yy_setFont:[UIFont systemFontOfSize:15] range:dayRange];
    return attStr;
}

- (void)weekDayWithDate:(NSDate *)date {
    NSCalendar * calendar = [NSCalendar currentCalendar]; // 指定日历的算法
    NSDateComponents *comps = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitWeekday | NSCalendarUnitDay fromDate:date];
    // 获取今天是周几
    // 1 是周日，2是周一 3.以此类推
    NSInteger weekDay = [comps weekday];
    // 获取几天是几号
    NSInteger day = [comps day];
    NSLog(@"周%ld----%ld日",(long)weekDay,(long)day);
    // 计算当前日期和本周的星期一和星期天相差天数
    long firstDiff,lastDiff;
    //    weekDay = 1; weekDay == 1 == 周日
    if (weekDay == 1)
    {
        firstDiff = -6;
        lastDiff = 0;
    }
    else
    {
        firstDiff = [calendar firstWeekday] - weekDay + 1;
        lastDiff = 8 - weekDay;
    }
    // 在当前日期(去掉时分秒)基础上加上差的天数
    NSDateComponents *baseDayComp = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:date];
    
    //获取周一日期
    [baseDayComp setDay:day + firstDiff];
    NSDate *firstDayOfWeek = [calendar dateFromComponents:baseDayComp];
    self.startDate = firstDayOfWeek;
    
    //获取周末日期
    [baseDayComp setDay:day + lastDiff];
    NSDate *lastDayOfWeek = [calendar dateFromComponents:baseDayComp];
    self.endDate = lastDayOfWeek;
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSString *firstDay = [formatter stringFromDate:firstDayOfWeek];
    NSString *lastDay = [formatter stringFromDate:lastDayOfWeek];
    
//    self.st.text = firstDay;
//    self.endLabel.text = lastDay;
}

#pragma mark - Setter Getter
- (void)setSelectDate:(NSDate *)selectDate {
    _selectDate = selectDate;
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy年"];
    NSString *currentYear = [formatter stringFromDate:selectDate];
    [formatter setDateFormat:@"MM"];
    NSInteger currentMonth = [[formatter stringFromDate:selectDate] integerValue];
    [formatter setDateFormat:@"dd"];
    NSInteger currentDay = [[formatter stringFromDate:selectDate] integerValue];

    self.yearLabel.text = currentYear;
    self.fromDayLabel.attributedText = [self configAttributedMonth:@(currentMonth).stringValue day:@(currentDay).stringValue];
}

- (void)setStartDate:(NSDate *)startDate {
    _startDate = startDate;
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy年"];
    NSString *currentYear = [formatter stringFromDate:startDate];
    [formatter setDateFormat:@"MM"];
    NSInteger currentMonth = [[formatter stringFromDate:startDate] integerValue];
    [formatter setDateFormat:@"dd"];
    NSInteger currentDay = [[formatter stringFromDate:startDate] integerValue];
    
    self.fromDayLabel.attributedText = [self configAttributedMonth:@(currentMonth).stringValue day:@(currentDay).stringValue];
}

- (void)setEndDate:(NSDate *)endDate {
    _endDate = endDate;
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy年"];
    NSString *currentYear = [formatter stringFromDate:endDate];
    [formatter setDateFormat:@"MM"];
    NSInteger currentMonth = [[formatter stringFromDate:endDate] integerValue];
    [formatter setDateFormat:@"dd"];
    NSInteger currentDay = [[formatter stringFromDate:endDate] integerValue];
    
    self.toDayLabel.attributedText = [self configAttributedMonth:@(currentMonth).stringValue day:@(currentDay).stringValue];
}

- (void)setIsWeek:(BOOL)isWeek {
    _isWeek = isWeek;
    self.toDayLabel.hidden = !isWeek;
    
    if (isWeek) {
        NSDate *date = self.selectDate ?: [NSDate date];
        [self weekDayWithDate:date];
    }
}

- (UIImageView *)bgImageView {
    if (_bgImageView == nil) {
        _bgImageView = [[UIImageView alloc] init];
        _bgImageView.image = [UIImage imageNamed:@"guild_statistic_header"];
        _bgImageView.userInteractionEnabled = YES;
    }
    return _bgImageView;
}

- (UILabel *)yearLabel {
    if (_yearLabel == nil) {
        UILabel *label = [[UILabel alloc] init];
        label.font = [UIFont systemFontOfSize:12];
        label.textColor = [UIColor.whiteColor colorWithAlphaComponent:0.8];
        
        _yearLabel = label;
    }
    return _yearLabel;
}

- (UILabel *)fromDayLabel {
    if (_fromDayLabel == nil) {
        UILabel *label = [[UILabel alloc] init];
        label.font = [UIFont systemFontOfSize:14];
        label.textColor = UIColor.whiteColor;
        
        _fromDayLabel = label;
    }
    return _fromDayLabel;
}

- (UILabel *)toDayLabel {
    if (_toDayLabel == nil) {
        UILabel *label = [[UILabel alloc] init];
        label.font = [UIFont systemFontOfSize:14];
        label.textColor = UIColor.whiteColor;
        label.hidden = YES;
        _toDayLabel = label;
    }
    return _toDayLabel;
}

- (UIStackView *)dayStackView {
    if (_dayStackView == nil) {
        _dayStackView = [[UIStackView alloc] initWithArrangedSubviews:@[self.fromDayLabel, self.toDayLabel]];
        _dayStackView.axis = UILayoutConstraintAxisVertical;
        _dayStackView.spacing = 0;
        _dayStackView.userInteractionEnabled = NO;
    }
    return _dayStackView;
}

- (UIImageView *)arrowImageView {
    if (_arrowImageView == nil) {
        _arrowImageView = [[UIImageView alloc] init];
        _arrowImageView.image = [UIImage imageNamed:@"guild_statistic_arrow_more"];
    }
    return _arrowImageView;
}

- (UILabel *)totalDesLabel {
    if (_totalDesLabel == nil) {
        UILabel *label = [[UILabel alloc] init];
        label.font = [UIFont systemFontOfSize:12];
        label.textColor = [UIColor.whiteColor colorWithAlphaComponent:0.8];
        label.text = @"总收入";
        
        _totalDesLabel = label;
    }
    return _totalDesLabel;
}

- (UILabel *)totalLabel {
    if (_totalLabel == nil) {
        UILabel *label = [[UILabel alloc] init];
        label.font = [UIFont boldSystemFontOfSize:24];
        label.textColor = UIColor.whiteColor;
        
        _totalLabel = label;
    }
    return _totalLabel;
}

- (UIView *)lineView {
    if (_lineView == nil) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = UIColor.whiteColor;
    }
    return _lineView;
}

- (UIButton *)selectDayButton {
    if (_selectDayButton == nil) {
        _selectDayButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_selectDayButton addTarget:self action:@selector(selectDayButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    }
    return _selectDayButton;
}

@end

