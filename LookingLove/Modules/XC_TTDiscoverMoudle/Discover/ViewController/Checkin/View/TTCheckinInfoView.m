//
//  TTCheckinInfoView.m
//  TTPlay
//
//  Created by lvjunhang on 2019/3/19.
//  Copyright © 2019 YiZhuan. All rights reserved.
//

#import "TTCheckinInfoView.h"

#import "TTCheckinConst.h"

#import "XCTheme.h"
#import "XCMacros.h"
#import "CheckinSignDetail.h"

#import <Masonry/Masonry.h>
#import <UICountingLabel/UICountingLabel.h>

@interface TTCheckinInfoView ()

@property (nonatomic, strong) UILabel *totalCoinDesLabel;//当前奖池累计金币
@property (nonatomic, strong) UIView *totalCoinDesLeftLine;//左边线
@property (nonatomic, strong) UIView *totalCoinDesRightLine;//右边线

@property (nonatomic, strong) UIImageView *bgImageView;//背景

@property (nonatomic, strong) UICountingLabel *totalCoinLabel;//奖池金币个数

@property (nonatomic, strong) UILabel *gainPrizeLabel;//获得奖品提示（获得萝卜x30）

@property (nonatomic, strong) UILabel *checkinDrawCoinLabel;//本次瓜分获得

@property (nonatomic, strong) UILabel *checkinStatusLabel;//本轮累计已签到12天  2019.10.10瓜分

@end

@implementation TTCheckinInfoView

#pragma mark - Life Cycle
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
- (void)appendCoin:(NSInteger)coinNum {
    [self.totalCoinLabel countFromCurrentValueTo:self.signDetail.showGoldNum + coinNum];
}

#pragma mark - System Protocols
#pragma mark - Custom Protocols
#pragma mark - Core Protocols
#pragma mark - Event Responses
- (void)checkinButtonTapped:(UIButton *)sender {
    if (self.signDetail.isDrawGold) {
        !self.partitionCoinActionBlock ?: self.partitionCoinActionBlock();
    } else if (!self.signDetail.isSign) {
        !self.signActionBlock ?: self.signActionBlock();
    }
}

#pragma mark - Private Methods
- (void)initViews {
    [self addSubview:self.bgImageView];
    
    [self.bgImageView addSubview:self.totalCoinDesLabel];
    [self.bgImageView addSubview:self.totalCoinDesLeftLine];
    [self.bgImageView addSubview:self.totalCoinDesRightLine];
    
    [self.bgImageView addSubview:self.totalCoinLabel];
    [self.bgImageView addSubview:self.gainPrizeLabel];
    [self.bgImageView addSubview:self.checkinButton];
    [self.bgImageView addSubview:self.checkinDrawCoinLabel];
    [self.bgImageView addSubview:self.checkinStatusLabel];
}

- (void)initConstraints {
    [self.bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];
    
    [self.totalCoinDesLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.baseline.mas_equalTo(self.bgImageView.mas_top).offset(34+13);
        make.centerX.mas_equalTo(0);
    }];
    [self.totalCoinDesLeftLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.totalCoinDesLabel.mas_left).offset(-10);
        make.centerY.mas_equalTo(self.totalCoinDesLabel);
        make.width.mas_equalTo(20);
        make.height.mas_equalTo(1);
    }];
    [self.totalCoinDesRightLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.totalCoinDesLabel.mas_right).offset(10);
        make.centerY.mas_equalTo(self.totalCoinDesLabel);
        make.width.height.mas_equalTo(self.totalCoinDesLeftLine);
    }];
    
    [self.totalCoinLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.totalCoinDesLabel.mas_lastBaseline).offset(10);
        make.centerX.mas_equalTo(0);
    }];
    
    [self.gainPrizeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.baseline.mas_equalTo(self.totalCoinLabel.mas_baseline).offset(6+12);
        make.centerX.mas_equalTo(0);
    }];
    
    [self.checkinButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.totalCoinLabel.mas_lastBaseline).offset(20);
        make.centerX.mas_equalTo(0);
    }];
    
    [self.checkinDrawCoinLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.checkinButton).inset(30);
        make.centerY.mas_equalTo(self.checkinButton);
    }];
    
    [self.checkinStatusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.checkinButton.mas_bottom).offset(3);
        make.centerX.mas_equalTo(0);
        make.left.mas_greaterThanOrEqualTo(8);
        make.right.mas_lessThanOrEqualTo(-8);
    }];
}

#pragma mark - Getters and Setters
- (void)setSignDetail:(CheckinSignDetail *)model {
    
    if (![model isKindOfClass:CheckinSignDetail.class]) {
        return;
    }
    
    _signDetail = model;
    
    [self.totalCoinLabel countFromCurrentValueTo:model.showGoldNum withDuration:1];
    
    NSString *days = [NSString stringWithFormat:@"%ld天", model.totalDay];
    
    NSString *date = [NSString stringWithFormat:@" %@", model.drawGoldDate];
    date = model.drawGoldDate == nil ? @"" : date;//第一轮未签到时没有没有预计瓜分时间
    
    NSString *drawTag = model.drawGoldDate == nil ? @"" : @"瓜分";
    NSRange drawTagRange = NSMakeRange(0, 0);
    
    NSString *sign = [NSString stringWithFormat:@"本轮累计已签到%@%@%@", days, date, drawTag];
    if (model.totalDay == 28) {
        drawTag = @" 获得瓜分资格";
        sign = [NSString stringWithFormat:@"本轮累计已签到%@%@", days, drawTag];
        drawTagRange = [sign rangeOfString:drawTag];
    }
    
    NSRange daysRange = [sign rangeOfString:days];
    NSRange dateRange = [sign rangeOfString:date];
    
    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:sign];
    [attr addAttribute:NSForegroundColorAttributeName value:UIColorFromRGB(0xFE3E53) range:daysRange];
    [attr addAttribute:NSForegroundColorAttributeName value:UIColorFromRGB(0xFE3E53) range:dateRange];
    [attr addAttribute:NSForegroundColorAttributeName value:UIColorFromRGB(0xFE3E53) range:drawTagRange];
    self.checkinStatusLabel.attributedText = attr;
    
    self.checkinButton.userInteractionEnabled = NO;
    self.gainPrizeLabel.hidden = YES;
    self.checkinDrawCoinLabel.hidden = YES;
    
    if (model.isDrawGold == 1) {
        [self.checkinButton setBackgroundImage:[UIImage imageNamed:@"checkin_btn_checkin_open"] forState:UIControlStateNormal];
        [self.checkinButton setTitle:@"瓜分金币" forState:UIControlStateNormal];
        self.checkinButton.userInteractionEnabled = YES;
        
        if (model.showText) {
            self.gainPrizeLabel.hidden = NO;
            self.gainPrizeLabel.text = [NSString stringWithFormat:@"今日获得%@", model.showText];
        }
        
    } else if (model.isDrawGold == 2) {
        [self.checkinButton setBackgroundImage:[UIImage imageNamed:@"checkin_btn_checkin_prize"] forState:UIControlStateNormal];
        [self.checkinButton setTitle:@"" forState:UIControlStateNormal];
        
        NSString *coin = [NSString stringWithFormat:@"%ld金币", model.drawGoldNum];
        NSString *des = @"本次瓜分获得";
        NSString *partition = [NSString stringWithFormat:@"%@%@", des, coin];
        NSRange coinRange = [partition rangeOfString:coin];
        NSRange desRange = [partition rangeOfString:des];
        
        NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:partition];
        [attr addAttribute:NSForegroundColorAttributeName value:UIColorFromRGB(0x9B40FC) range:desRange];
        [attr addAttribute:NSForegroundColorAttributeName value:UIColorFromRGB(0xFE3E53) range:coinRange];
        self.checkinDrawCoinLabel.hidden = NO;
        self.checkinDrawCoinLabel.attributedText = attr;
        
        if (model.showText) {
            self.gainPrizeLabel.hidden = NO;
            self.gainPrizeLabel.text = [NSString stringWithFormat:@"今日获得%@", model.showText];
        }
        
    } else if (model.isSign) {
        [self.checkinButton setBackgroundImage:[UIImage imageNamed:@"checkin_btn_checkin_done"] forState:UIControlStateNormal];
        [self.checkinButton setTitle:@"今日已签到" forState:UIControlStateNormal];
        
        self.gainPrizeLabel.hidden = NO;
        self.gainPrizeLabel.text = [NSString stringWithFormat:@"今日获得%@", model.showText];
        
    } else {
        [self.checkinButton setBackgroundImage:[UIImage imageNamed:@"checkin_btn_checkin_normal"] forState:UIControlStateNormal];
        [self.checkinButton setTitle:@"点我签到" forState:UIControlStateNormal];
        self.checkinButton.userInteractionEnabled = YES;
    }
}

- (UIImageView *)bgImageView {
    if (_bgImageView == nil) {
        _bgImageView = [[UIImageView alloc] init];
        _bgImageView.userInteractionEnabled = YES;
        _bgImageView.image = [UIImage imageNamed:@"checkin_bg_info"];
    }
    return _bgImageView;
}

- (UILabel *)totalCoinDesLabel {
    if (_totalCoinDesLabel == nil) {
        UILabel *label = [[UILabel alloc] init];
        label.text = @"当前奖池累计金币";
        label.font = [UIFont systemFontOfSize:13];
        label.textColor = [XCTheme getTTDeepGrayTextColor];
        label.textAlignment = NSTextAlignmentCenter;
        
        _totalCoinDesLabel = label;
    }
    return _totalCoinDesLabel;
}

- (UIView *)totalCoinDesLeftLine {
    if (_totalCoinDesLeftLine == nil) {
        _totalCoinDesLeftLine = [[UIView alloc] init];
        _totalCoinDesLeftLine.backgroundColor = [XCTheme getTTDeepGrayTextColor];
    }
    return _totalCoinDesLeftLine;
}

- (UIView *)totalCoinDesRightLine {
    if (_totalCoinDesRightLine == nil) {
        _totalCoinDesRightLine = [[UIView alloc] init];
        _totalCoinDesRightLine.backgroundColor = [XCTheme getTTDeepGrayTextColor];
    }
    return _totalCoinDesRightLine;
}

- (UICountingLabel *)totalCoinLabel {
    if (_totalCoinLabel == nil) {
        _totalCoinLabel = [[UICountingLabel alloc] init];
        _totalCoinLabel.text = @"0";
        _totalCoinLabel.textColor = UIColorFromRGB(0xFF3B6E);
        _totalCoinLabel.font = [UIFont systemFontOfSize:37];
        _totalCoinLabel.textAlignment = NSTextAlignmentCenter;
        _totalCoinLabel.method = UILabelCountingMethodEaseOut;
        
        NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
        formatter.numberStyle = kCFNumberFormatterDecimalStyle;
        _totalCoinLabel.formatBlock = ^NSString *(float value) {
            NSString *formatted = [formatter stringFromNumber:@((int)value)];
            return [NSString stringWithFormat:@"%@", formatted];
        };
    }
    return _totalCoinLabel;
}

- (UILabel *)gainPrizeLabel {
    if (_gainPrizeLabel == nil) {
        UILabel *label = [[UILabel alloc] init];
        label.font = [UIFont systemFontOfSize:12];
        label.textColor = [self gainPrizeColor];
        label.textAlignment = NSTextAlignmentCenter;
        
        _gainPrizeLabel = label;
    }
    return _gainPrizeLabel;
}

- (UIColor *)gainPrizeColor {
    if (projectType() == ProjectType_LookingLove || projectType() == ProjectType_Planet) {
        return TTCheckinMainColor();
    }
    return UIColorFromRGB(0x9236F6);
}

- (UIButton *)checkinButton {
    if (_checkinButton == nil) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setTitle:@"点我签到" forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont boldSystemFontOfSize:18];
        [button setBackgroundImage:[UIImage imageNamed:@"checkin_btn_checkin_normal"] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(checkinButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
        
        _checkinButton = button;
    }
    return _checkinButton;
}

- (UILabel *)checkinDrawCoinLabel {
    if (_checkinDrawCoinLabel == nil) {
        UILabel *label = [[UILabel alloc] init];
        label.font = [UIFont boldSystemFontOfSize:15];
        label.textColor = UIColorFromRGB(0x9B40FC);
        label.textAlignment = NSTextAlignmentCenter;
        
        _checkinDrawCoinLabel = label;
    }
    return _checkinDrawCoinLabel;
}

- (UILabel *)checkinStatusLabel {
    if (_checkinStatusLabel == nil) {
        UILabel *label = [[UILabel alloc] init];
        label.font = [UIFont systemFontOfSize:12];
        label.textColor = UIColorFromRGB(0x979797);
        label.textAlignment = NSTextAlignmentCenter;
        label.text = @"本轮累计已签到";
        
        _checkinStatusLabel = label;
    }
    return _checkinStatusLabel;
}

@end
