//
//  TTDatePickView.m
//  TuTu
//
//  Created by Macx on 2018/11/7.
//  Copyright © 2018年 YiZhuan. All rights reserved.
//

#import "TTDatePickView.h"

#import <Masonry/Masonry.h>
#import "XCTheme.h"
#import "XCMacros.h"

@interface TTDatePickView()
@property (nonatomic, strong) UIButton  *cancelBtn;//
@property (nonatomic, strong) UIButton  *ensureBtn;//
@property (nonatomic, strong) UIDatePicker  *datePicker;//
@property (nonatomic, strong) NSDateFormatter  *dateFormatter;//
// week
@property (nonatomic, strong) UILabel *startLabel;
@property (nonatomic, strong) UILabel *endLabel;
@property (nonatomic, strong) UILabel *textLabel;

@end

@implementation TTDatePickView

- (instancetype)init {
    if (self = [super init]) {
        [self initSubViews];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initSubViews];
    }
    return self;
}


- (void)initSubViews {
    self.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.datePicker];
    [self addSubview:self.cancelBtn];
    [self addSubview:self.ensureBtn];
    [self addSubview:self.startLabel];
    [self addSubview:self.endLabel];
    [self addSubview:self.textLabel];
    
    [self.datePicker mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self);
        make.bottom.mas_equalTo(self).offset(kSafeAreaBottomHeight);
        make.top.mas_equalTo(self.cancelBtn.mas_bottom);
    }];
    [self.cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.mas_equalTo(self);
        make.height.mas_equalTo(30);
        make.width.mas_equalTo(50);
    }];
    [self.ensureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.top.mas_equalTo(self);
        make.height.mas_equalTo(30);
        make.width.mas_equalTo(50);
    }];
    
    [self.textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self);
        make.top.mas_equalTo(self.cancelBtn.mas_bottom).offset(-5);
    }];
    
    [self.startLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.textLabel.mas_left).offset(-10);
        make.centerY.mas_equalTo(self.textLabel);
    }];
    
    [self.endLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.textLabel.mas_right).offset(10);
        make.centerY.mas_equalTo(self.textLabel);
    }];
}

#pragma mark - Event
- (void)onClickCancelBtn:(UIButton *)btn {
    if (self.delegate && [self.delegate respondsToSelector:@selector(ttDatePickCancelAction)]) {
        [self.delegate ttDatePickCancelAction];
    }
}

- (void)onClickEnsureBtn:(UIButton *)btn {
    
    if (self.isWeek) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(ttDatePickEnsureActionStartTime:endTime:date:)]) {
            [self.delegate ttDatePickEnsureActionStartTime:self.startLabel.text endTime:self.endLabel.text date:self.datePicker.date];
            [self onClickCancelBtn:self.cancelBtn];
            return;
        }
    }
    
    NSDate * date = self.datePicker.date;
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSCalendarUnit unit =  NSCalendarUnitYear | NSCalendarUnitMonth
    | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    NSDate * nowDate = [NSDate date];
    NSDateComponents *dateCom = [calendar components:unit fromDate:date toDate:nowDate options:0];
    
    if (self.limitAge) {
        if (dateCom.year < self.limitAge) {
            if(self.delegate && [self.delegate respondsToSelector:@selector(ttDatePickLimitAction)]){
                [self.delegate ttDatePickLimitAction];
                return;
            }
        }
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(ttDatePickEnsureAction:date:)]) {
        NSTimeZone *timeZone= [NSTimeZone systemTimeZone];
        NSInteger seconds= [timeZone secondsFromGMTForDate:date];
        NSDate *newDate= [date dateByAddingTimeInterval:seconds];
        NSString *dateStr = [self.dateFormatter stringFromDate:newDate];
        [self.delegate ttDatePickEnsureAction:dateStr date:newDate];
        [self onClickCancelBtn:self.cancelBtn];
    }
}



#pragma mark -
#pragma mark methods
- (void)dateChange:(UIDatePicker *)datePicker {
    //设置时间格式
    if (self.isWeek) {
        // 正常模式下不需要计算，不然耗费性能
        [self getweekDayWithDate:datePicker.date];
    }
}

- (void)getweekDayWithDate:(NSDate *) date
{
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
    
    //获取周末日期
    [baseDayComp setDay:day + lastDiff];
    NSDate *lastDayOfWeek = [calendar dateFromComponents:baseDayComp];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSString *firstDay = [formatter stringFromDate:firstDayOfWeek];
    NSString *lastDay = [formatter stringFromDate:lastDayOfWeek];
    
    self.startLabel.text = firstDay;
    self.endLabel.text = lastDay;
}

#pragma mark - Getter && Setter

- (void)setIsWeek:(BOOL)isWeek {
    _isWeek = isWeek;
    self.textLabel.hidden = !isWeek;
    self.startLabel.hidden = !isWeek;
    self.endLabel.hidden = !isWeek;
    
    if (isWeek) {
        [self getweekDayWithDate:self.datePicker.date];
    }
}

- (void)setAtTime:(NSString *)atTime {
    _atTime = atTime;
    NSDate *date = [self.dateFormatter dateFromString:atTime];
    self.datePicker.date = date;
    
    if (self.isWeek) {
        [self getweekDayWithDate:self.datePicker.date];
    }
}

- (void)setTime:(NSTimeInterval)time {
    _time = time;
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:time];
    self.datePicker.date = date;
    
    if (self.isWeek) {
        [self getweekDayWithDate:self.datePicker.date];
    }
}

- (void)setDateFormat:(NSString *)dateFormat {
    _dateFormat = dateFormat;
    self.dateFormatter.dateFormat = dateFormat;
}

- (void)setMaximumDate:(NSDate *)maximumDate {
    _maximumDate = maximumDate;
    self.datePicker.maximumDate = _maximumDate;
}

- (void)setMinimumDate:(NSDate *)minimumDate {
    _minimumDate = minimumDate;
    self.datePicker.minimumDate = _minimumDate;
}

- (UIButton *)cancelBtn {
    if (!_cancelBtn) {
        _cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
        [_cancelBtn addTarget:self action:@selector(onClickCancelBtn:) forControlEvents:UIControlEventTouchUpInside];
        _cancelBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [_cancelBtn setTitleColor:[XCTheme getTTDeepGrayTextColor] forState:UIControlStateNormal];
    }
    return _cancelBtn;
}

- (UIButton *)ensureBtn {
    if (!_ensureBtn) {
        _ensureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_ensureBtn setTitle:@"确定" forState:UIControlStateNormal];
        [_ensureBtn addTarget:self action:@selector(onClickEnsureBtn:) forControlEvents:UIControlEventTouchUpInside];
        _ensureBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [_ensureBtn setTitleColor:[XCTheme getTTMainColor] forState:UIControlStateNormal];
    }
    return _ensureBtn;
}

- (NSDateFormatter *)dateFormatter {
    if (!_dateFormatter) {
        _dateFormatter = [[NSDateFormatter alloc] init];
        _dateFormatter.dateFormat = @"YYYY-MM-dd";
    }
    return _dateFormatter;
}

- (UIDatePicker *)datePicker {
    if (!_datePicker){
        _datePicker = [[UIDatePicker alloc] init];
        _datePicker.datePickerMode = UIDatePickerModeDate;
        NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
        _datePicker.locale = locale;
        _datePicker.layer.cornerRadius = 5;
        _datePicker.layer.masksToBounds = YES;
        NSDate *date = [self.dateFormatter dateFromString:@"2000-07-01"];
        _datePicker.date = date;
        _datePicker.backgroundColor = [UIColor whiteColor];
        [_datePicker addTarget:self action:@selector(dateChange:) forControlEvents:UIControlEventValueChanged];
        
        if (@available(iOS 13.4, *)) {
            _datePicker.preferredDatePickerStyle = UIDatePickerStyleWheels;
        }
    }
    return _datePicker;
}

- (UILabel *)startLabel
{
    if (!_startLabel) {
        _startLabel = [[UILabel alloc] init];
        _startLabel.text = @"2019-01-22";
        _startLabel.textColor = [XCTheme getMSMainTextColor];
        _startLabel.font = [UIFont boldSystemFontOfSize:15.f];
        _startLabel.adjustsFontSizeToFitWidth = YES;
        _startLabel.hidden = YES;
    }
    return _startLabel;
}

- (UILabel *)endLabel
{
    if (!_endLabel) {
        _endLabel = [[UILabel alloc] init];
        _endLabel.text = @"2019-01-22";
        _endLabel.textColor = [XCTheme getMSMainTextColor];
        _endLabel.font = [UIFont boldSystemFontOfSize:15.f];
        _endLabel.adjustsFontSizeToFitWidth = YES;
        _endLabel.hidden = YES;
    }
    return _endLabel;
}

- (UILabel *)textLabel
{
    if (!_textLabel) {
        _textLabel = [[UILabel alloc] init];
        _textLabel.text = @"至";
        _textLabel.textColor = [XCTheme getTTDeepGrayTextColor];
        _textLabel.font = [UIFont systemFontOfSize:15.f];
        _textLabel.adjustsFontSizeToFitWidth = YES;
        _textLabel.hidden = YES;
    }
    return _textLabel;
}

@end
