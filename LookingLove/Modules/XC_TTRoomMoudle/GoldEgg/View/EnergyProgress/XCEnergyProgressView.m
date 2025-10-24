//
//  XCEnergyProgressView.m
//  XCRoomMoudle
//
//  Created by JarvisZeng on 2019/5/8.
//  Copyright © 2019 YiZhuan. All rights reserved.
//

#import "XCEnergyProgressView.h"
#import <Masonry.h>
#import <YYText/YYLabel.h>
#import "XCTheme.h"
#import "YLProgressBar.h"

@interface XCEnergyProgressView ()
@property (nonatomic, strong) UIButton *questionView; // 问号
@property (nonatomic, strong) UIImageView *luckyValueView; // 图片 label
@property (nonatomic, strong) YYLabel *luckyValueLabel; // 幸运值，通过暴露的 luckyValue 设值
@property (nonatomic, strong) YYLabel *progressEndValueLabel;  // progress 的幸运值
@property (nonatomic, strong) UIImageView *progressBg; // progress bg
@property (nonatomic, strong) UIImageView *starView; // progress 上的图标
@property (nonatomic, strong) YLProgressBar *progressBar; // progress bar
@property (nonatomic, strong) UIImageView *diamondBoxView; // progress 上的终点箱子图标
@property (nonatomic, strong) NSMutableDictionary *progressBoxDictioary;// progress上的箱子imageView
@property (nonatomic, strong) NSNumber *maxValue;//最大进度

@end
@implementation XCEnergyProgressView

#pragma mark - Life Style

- (instancetype)initWithFrame:(CGRect)frame{
    if (self=[super initWithFrame:frame]) {
        [self setupSubviews];
    }
    return self;
}
- (void)layoutSubviews{
    [super layoutSubviews];
    [self setupSubviewsConstraints];
}

- (void)dealloc{
    NSLog(@"XCEnergyProgressView dealloc");
}

#pragma mark - Event Respond

- (void)questionClicked:(UIButton *)button {
    if (self.delegate && [self.delegate respondsToSelector:@selector(onEnergyProgressViewLuckyValueQuestionCliked)]) {
        [self.delegate onEnergyProgressViewLuckyValueQuestionCliked];
    }
}

#pragma mark - Public Method

- (void)updateProgressWithRanges:(NSArray<NSNumber *> *)ranges {
    if (ranges == nil || ranges.count == 0) {
        return;
    }
    NSNumber *max = ranges[ranges.count - 1];
    self.maxValue = max;
    for (int i = 0; i < ranges.count - 1; i++) {
        NSNumber *range = ranges[i];
        CGFloat percentage = range.floatValue / max.floatValue;
        [self addBoxToProgressWithPercentage:percentage andValue:range];
    }
   
    [self.progressEndValueLabel setText:[NSString stringWithFormat:@"%@", max]];
}

- (void)removeBoxView {
    UIView *removeView;
    while((removeView = [self viewWithTag:999]) != nil) {
        [removeView removeFromSuperview];
    }
}

#pragma mark - Private Method

- (void)setupSubviews {
    [self addSubview:self.questionView];
    [self addSubview:self.luckyValueView];
    [self addSubview:self.luckyValueLabel];
    [self addSubview:self.progressBg];
    
    [self.progressBg addSubview:self.starView];
    [self.progressBg addSubview:self.diamondBoxView];
    [self.progressBg addSubview:self.progressBar];

    [self addSubview:self.progressEndValueLabel];
}

- (void)setupSubviewsConstraints {
    [self.questionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(9);
        make.top.equalTo(self.mas_top);
        make.width.left.equalTo(@15);
    }];
    [self.luckyValueView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.questionView);
        make.left.equalTo(self.questionView.mas_right).offset(3);
    }];
    
    [self.luckyValueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.luckyValueView.mas_right).offset(3);
        make.centerY.equalTo(self.questionView);
    }];
    
    [self.progressBg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(self.luckyValueView.mas_bottom).offset(15);
        make.right.equalTo(self.mas_right);
        make.left.equalTo(self.mas_left);
        make.width.equalTo(@40);
    }];
    [self.progressBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.progressBg);
        make.centerY.equalTo(self.progressBg).offset(1);
        make.left.equalTo(self.progressBg.mas_left).offset(26);
        make.right.equalTo(self.progressBg.mas_right).offset(-26);
        make.height.equalTo(@6);
    }];
    
    [self.starView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.progressBg.mas_left).offset(9);
        make.centerY.equalTo(self.progressBg);
    }];

    [self.diamondBoxView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.progressBg.mas_right).offset(-7);;
        make.centerY.equalTo(self.progressBg);
    }];
  
    [self.progressEndValueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.diamondBoxView);
        make.top.equalTo(self.progressBg.mas_bottom).offset(10);
    }];
}

- (void)addBoxToProgressWithPercentage:(CGFloat)percentage andValue:(NSNumber *)value {
    UIImageView *boxView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"room_box_progress_normalBox"]];
    boxView.tag = 999;
    [self.progressBoxDictioary setObject:boxView forKey:[NSString stringWithFormat:@"%d",value.intValue]];
    [self.progressBar addSubview:boxView];
    UILabel *valueLabel = [self createValueLabel:value];
    valueLabel.tag = 999;
    [self addSubview:valueLabel];

    // 箱子宽度 / 2
    CGFloat offset = boxView.bounds.size.width / 2;
    CGFloat loc = self.progressBar.frame.size.width * percentage - offset;

    [boxView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.progressBar);
        make.left.equalTo([NSNumber numberWithFloat:loc]);
    }];
    [valueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.progressBg.mas_bottom).offset(10);
        make.centerX.equalTo(boxView.mas_centerX);
    }];
  
}

- (UILabel *)createValueLabel:(NSNumber *)value {
    UILabel *label = [[YYLabel alloc] init];
    label.text = [NSString stringWithFormat:@"%@", value];
    label.textColor = UIColorFromRGB(0xFFC909);
    label.font = [UIFont systemFontOfSize:12];
    return label;
}

#pragma mark - Getter

- (UIButton *)questionView {
    if (!_questionView) {
        _questionView = [[UIButton alloc] init];
        [_questionView setImage:[UIImage imageNamed:@"room_box_diamond_question"] forState:UIControlStateNormal];
        [_questionView addTarget:self action:@selector(questionClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _questionView;
}

- (UIImageView *)luckyValueView {
    if (!_luckyValueView) {
        _luckyValueView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"room_box_diamond_lucky_value_label"]];
    }
    return _luckyValueView;
}

- (YYLabel *)luckyValueLabel {
    if (!_luckyValueLabel) {
        _luckyValueLabel = [[YYLabel alloc] init];
        _luckyValueLabel.text = @"达到一定幸运值，必出豪礼!";
        _luckyValueLabel.textColor = [UIColor whiteColor];
        _luckyValueLabel.backgroundColor = [UIColor clearColor];
        _luckyValueLabel.font = [UIFont systemFontOfSize:12];
    }
    return _luckyValueLabel;
}

- (UIImageView *)progressBg {
    if (!_progressBg) {
//        _progressBg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"room_box_progress_bg"]];
        _progressBg = [[UIImageView alloc] initWithImage:nil];
    }
    return _progressBg;
}

- (UIImageView *)starView {
    if (!_starView) {
        _starView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"room_box_progress_star"]];
    }
    return _starView;
}

- (UIImageView *)diamondBoxView {
    if (!_diamondBoxView) {
        _diamondBoxView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"room_box_progress_diamondBox"]];
    }
    return _diamondBoxView;
}

- (YLProgressBar *)progressBar {
    if (!_progressBar) {
        _progressBar = [[YLProgressBar alloc] init];
        _progressBar.progressTintColor = UIColorFromRGB(0xFEC046);
        _progressBar.stripesColor = [UIColor colorWithRed:255.0 green:255.0 blue:255.0 alpha:0.76f];
        _progressBar.uniformTintColor = YES;
        _progressBar.stripesWidth = 4;
        _progressBar.indicatorTextDisplayMode = YLProgressBarIndicatorTextDisplayModeNone;
        _progressBar.trackTintColor =  [UIColor colorWithRed:255.0 green:255.0 blue:255.0 alpha:0.1f];
        _progressBar.hideGloss = YES;
        _progressBar.hideInnerWhiteShadow = YES;
        _progressBar.stripesDelta = 4;
        [_progressBar setProgress:0.0f];
    }
    return _progressBar;
}

- (YYLabel *)progressEndValueLabel {
    if (!_progressEndValueLabel) {
        _progressEndValueLabel = [[YYLabel alloc] init];
        _progressEndValueLabel.textColor = UIColorFromRGB(0xFFC909);
        _progressEndValueLabel.font = [UIFont systemFontOfSize:12];
    }
    return _progressEndValueLabel;
}

- (NSMutableDictionary *)progressBoxDictioary {
    if (!_progressBoxDictioary) {
        _progressBoxDictioary = [NSMutableDictionary dictionary];
    }
    return _progressBoxDictioary;
}

#pragma mark - Setter

- (void)setProgressValue:(CGFloat)progressValue {
    
    [self.progressBar setProgress:progressValue];
    
    //处理箱子是否打开
    for (NSString *boxKey in self.progressBoxDictioary.allKeys) {
        UIImageView *imageView = self.progressBoxDictioary[boxKey];
        NSString *imageName = boxKey.intValue <= progressValue*self.maxValue.intValue ? @"room_box_progress_normalBox_open" : @"room_box_progress_normalBox";
        imageView.image = [UIImage imageNamed:imageName];
    }
    
    if (progressValue >= 100.0) {
        self.diamondBoxView.image = [UIImage imageNamed:@"room_box_progress_diamondBox_open"];
    } else {
        self.diamondBoxView.image = [UIImage imageNamed:@"room_box_progress_diamondBox"];
    }
}

@end
