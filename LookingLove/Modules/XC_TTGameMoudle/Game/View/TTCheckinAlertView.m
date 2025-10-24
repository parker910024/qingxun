//
//  TTCheckinAlertView.m
//  TTPlay
//
//  Created by lvjunhang on 2019/3/22.
//  Copyright © 2019 YiZhuan. All rights reserved.
//  首页签到弹窗

#import "TTCheckinAlertView.h"

#import "XCMacros.h"
#import "XCTheme.h"
#import "XCCurrentVCStackManager.h"
#import "CheckinSignDetail.h"

#import <Masonry/Masonry.h>
#import <UICountingLabel/UICountingLabel.h>

#import <WebKit/WebKit.h>

@interface TTCheckinAlertView ()

@property (nonatomic, strong) UIImageView *bgImageView;//背景
@property (nonatomic, strong) UILabel *totalCoinDesLabel;//当前奖池累计金币
@property (nonatomic, strong) UIImageView *lineLeft;//线
@property (nonatomic, strong) UIImageView *lineRight;//线
@property (nonatomic, strong) UILabel *gainPrizeLabel;//获得 萝卜x30
@property (nonatomic, strong) UICountingLabel *totalCoinLabel;//金币个数

@property (nonatomic, strong) UIButton *cancelButton;//取消
@property (nonatomic, strong) UIView *bgView;
@end

@implementation TTCheckinAlertView

#pragma mark - life cycle

- (instancetype)initWithFrame:(CGRect)frame {
    
    /// 设置默认宽高
    if (CGRectEqualToRect(frame, CGRectZero)) {
        frame = [UIScreen mainScreen].bounds;
    }
    
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0];
        
        [self initView];
        [self initConstraints];
    }
    return self;
}

#pragma mark - public method
- (void)addCoin:(NSUInteger)coinNumber {
    [self.totalCoinLabel countFromCurrentValueTo:self.signDetail.showGoldNum + coinNumber];
}

#pragma mark - custom protocols
#pragma mark - core protocols
#pragma mark - event response
- (void)cancelButtonTapped:(UIButton *)sender {
    !self.dismissBlock ?: self.dismissBlock();
}

- (void)checkinButtonTapped:(UIButton *)sender {
    !self.checkinBlock ?: self.checkinBlock();
}

- (void)bonusActionTapped {
    !self.bonusBlock ?: self.bonusBlock();
}

#pragma mark - private method
- (void)initView {
    
    [self addSubview:self.bgView];
    
    [self.bgView addSubview:self.bgImageView];
    
    [self.bgImageView addSubview:self.totalCoinDesLabel];
    [self.bgImageView addSubview:self.lineLeft];
    [self.bgImageView addSubview:self.lineRight];
    [self.bgImageView addSubview:self.totalCoinLabel];
    [self.bgImageView addSubview:self.gainPrizeLabel];
    [self.bgImageView addSubview:self.checkinButton];
    
    [self.bgView addSubview:self.cancelButton];
    
    UITapGestureRecognizer *tapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(bonusActionTapped)];
    [self.totalCoinLabel addGestureRecognizer:tapGR];
}

- (void)initConstraints {
    
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(self);
        make.left.right.mas_equalTo(self).inset(52);
        make.height.mas_equalTo(408);
    }];
    
    [self.cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.centerX.mas_equalTo(0);
        make.width.height.mas_equalTo(35);
    }];
    
    [self.bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(0);
    }];
    
    [self.checkinButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.bgImageView).inset(28);
        make.bottom.mas_equalTo(-12);
    }];
    
    [self.gainPrizeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.bgImageView).inset(10);
        make.bottom.mas_equalTo(self.checkinButton.mas_top).offset(-4);
    }];
    
    [self.totalCoinLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.bgImageView).inset(10);
        make.bottom.mas_equalTo(self.checkinButton.mas_top).offset(-21);
    }];
    
    [self.totalCoinDesLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.checkinButton.mas_top).offset(-64);
        make.centerX.mas_equalTo(0);
    }];
    [self.lineLeft mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.totalCoinDesLabel.mas_left).offset(-10);
        make.centerY.mas_equalTo(self.totalCoinDesLabel);
    }];
    [self.lineRight mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.totalCoinDesLabel.mas_right).offset(10);
        make.centerY.mas_equalTo(self.totalCoinDesLabel);
    }];
}

#pragma mark - Getter Setter
- (void)setSignDetail:(CheckinSignDetail *)model {
    if (![model isKindOfClass:CheckinSignDetail.class]) {
        return;
    }
    
    _signDetail = model;
    
    [self.totalCoinLabel countFromCurrentValueTo:model.showGoldNum withDuration:1];
    
    self.checkinButton.userInteractionEnabled = NO;
    self.gainPrizeLabel.hidden = YES;
    
    if (model.isSign) {
        [self.checkinButton setBackgroundImage:[UIImage imageNamed:@"checkin_btn_checkin_done"] forState:UIControlStateNormal];
        
        NSString *tips = [NSString stringWithFormat:@"已累计签到%ld天", (long)model.totalDay];
        [self.checkinButton setTitle:tips forState:UIControlStateNormal];
        self.gainPrizeLabel.hidden = NO;
        self.gainPrizeLabel.text = model.showText;
        
    } else {
        [self.checkinButton setBackgroundImage:[UIImage imageNamed:@"checkin_btn_checkin_normal"] forState:UIControlStateNormal];
        [self.checkinButton setTitle:@"点我签到" forState:UIControlStateNormal];
        self.checkinButton.userInteractionEnabled = YES;
    }
}

- (UIImageView *)bgImageView {
    if (_bgImageView == nil) {
        _bgImageView = [[UIImageView alloc] init];
        _bgImageView.image = [UIImage imageNamed:@"checkin_alert_bg"];
        _bgImageView.userInteractionEnabled = YES;
    }
    return _bgImageView;
}

- (UILabel *)totalCoinDesLabel {
    if (_totalCoinDesLabel == nil) {
        _totalCoinDesLabel = [[UILabel alloc] init];
        _totalCoinDesLabel.text = @"当前奖池累计金币";
        _totalCoinDesLabel.textColor = [XCTheme getTTDeepGrayTextColor];
        _totalCoinDesLabel.font = [UIFont systemFontOfSize:13];
        _totalCoinDesLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _totalCoinDesLabel;
}

- (UIImageView *)lineLeft {
    if (_lineLeft == nil) {
        _lineLeft = [[UIImageView alloc] init];
        _lineLeft.image = [UIImage imageNamed:@"checkin_alert_line"];
    }
    return _lineLeft;
}

- (UIImageView *)lineRight {
    if (_lineRight == nil) {
        _lineRight = [[UIImageView alloc] init];
        _lineRight.image = [UIImage imageNamed:@"checkin_alert_line"];
    }
    return _lineRight;
}

- (UICountingLabel *)totalCoinLabel {
    if (_totalCoinLabel == nil) {
        _totalCoinLabel = [[UICountingLabel alloc] init];
        _totalCoinLabel.text = @"0";
        _totalCoinLabel.textColor = UIColorFromRGB(0xFF3B6E);
        _totalCoinLabel.font = [UIFont systemFontOfSize:37];
        _totalCoinLabel.textAlignment = NSTextAlignmentCenter;
        _totalCoinLabel.userInteractionEnabled = YES;
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
        _gainPrizeLabel = [[UILabel alloc] init];
        _gainPrizeLabel.text = @"获得 萝卜x30";
        _gainPrizeLabel.textColor = UIColorFromRGB(0x9236F6);
        _gainPrizeLabel.font = [UIFont systemFontOfSize:12];
        _gainPrizeLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _gainPrizeLabel;
}

- (UIButton *)checkinButton {
    if (_checkinButton == nil) {
        _checkinButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_checkinButton setBackgroundImage:[UIImage imageNamed:@"checkin_alert_btn_normal"] forState:UIControlStateNormal];
        [_checkinButton setBackgroundImage:[UIImage imageNamed:@"checkin_alert_btn_disable"] forState:UIControlStateDisabled];
        [_checkinButton setTitle:@"点我签到" forState:UIControlStateNormal];
        _checkinButton.titleLabel.font = [UIFont boldSystemFontOfSize:18];
        [_checkinButton addTarget:self action:@selector(checkinButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _checkinButton;
}

- (UIButton *)cancelButton {
    if (_cancelButton == nil) {
        _cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_cancelButton setImage:[UIImage imageNamed:@"checkin_alert_cancel"] forState:UIControlStateNormal];
        [_cancelButton addTarget:self action:@selector(cancelButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancelButton;
}

- (UIView *)bgView {
    if (!_bgView) {
        //        frame = CGRectMake(0, 0, KScreenWidth-54*2, 408);

        _bgView = [[UIView alloc] init];
        
    }
    return _bgView;
}
@end

