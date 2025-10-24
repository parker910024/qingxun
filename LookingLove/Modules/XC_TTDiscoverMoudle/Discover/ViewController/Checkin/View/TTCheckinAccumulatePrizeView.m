//
//  TTCheckinAccumulatePrizeView.m
//  TTPlay
//
//  Created by lvjunhang on 2019/3/19.
//  Copyright © 2019 YiZhuan. All rights reserved.
//

#import "TTCheckinAccumulatePrizeView.h"

#import "XCTheme.h"
#import "XCMacros.h"
#import "UIButton+EnlargeTouchArea.h"
#import "CheckinRewardTotalNotice.h"
#import "CheckinSignDetail.h"
#import "NSArray+Safe.h"

#import <Masonry/Masonry.h>

@interface TTCheckinAccumulatePrizeView ()

@property (nonatomic, strong) UIImageView *bigPrizeImageView;//大奖

@property (nonatomic, strong) UIView *connectLine;//底部连接线
@property (nonatomic, strong) UIView *pointView;//指示点
@property (nonatomic, strong) UIView *whiteLine;//白色连接线

@property (nonatomic, strong) UIButton *firstButton;
@property (nonatomic, strong) UILabel *firstTitleLabel;
@property (nonatomic, strong) UILabel *firstDayLabel;
@property (nonatomic, strong) UIView *firstbgCycle;//背景圆圈

@property (nonatomic, strong) UIButton *secondButton;
@property (nonatomic, strong) UILabel *secondTitleLabel;
@property (nonatomic, strong) UILabel *secondDayLabel;
@property (nonatomic, strong) UIView *secondbgCycle;//背景圆圈

@property (nonatomic, strong) UIButton *thirdButton;
@property (nonatomic, strong) UILabel *thirdTitleLabel;
@property (nonatomic, strong) UILabel *thirdDayLabel;
@property (nonatomic, strong) UIView *thirdbgCycle;//背景圆圈

@property (nonatomic, strong) UIButton *fourthButton;
@property (nonatomic, strong) UILabel *fourthTitleLabel;
@property (nonatomic, strong) UILabel *fourthDayLabel;
@property (nonatomic, strong) UIView *fourthbgCycle;//背景圆圈

@end

@implementation TTCheckinAccumulatePrizeView

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
#pragma mark - System Protocols
#pragma mark - Custom Protocols
#pragma mark - Core Protocols
#pragma mark - Event Responses
- (void)firstButtonTapped:(UIButton *)sender {
    CheckinRewardTotalNotice *item = [self.modelArray safeObjectAtIndex:0];
    if (!item.isReceive && self.signDetail.totalDay>=item.signDays) {
        !self.selectPrizeBlock ?: self.selectPrizeBlock(item);
    }
}

- (void)secondButtonTapped:(UIButton *)sender {
    CheckinRewardTotalNotice *item = [self.modelArray safeObjectAtIndex:1];
    if (!item.isReceive && self.signDetail.totalDay>=item.signDays) {
        !self.selectPrizeBlock ?: self.selectPrizeBlock(item);
    }
}

- (void)thirdButtonTapped:(UIButton *)sender {
    CheckinRewardTotalNotice *item = [self.modelArray safeObjectAtIndex:2];
    if (!item.isReceive && self.signDetail.totalDay>=item.signDays) {
        !self.selectPrizeBlock ?: self.selectPrizeBlock(item);
    }
}

- (void)fourthButtonTapped:(UIButton *)sender {
    //准备瓜分
    if (self.signDetail.isDrawGold == 1 && self.signDetail.totalDay >= 28) {
        !self.drawCoinBlock ?: self.drawCoinBlock();
    }
}

#pragma mark - Private Methods
- (void)initViews {
    [self addSubview:self.firstbgCycle];
    [self addSubview:self.secondbgCycle];
    [self addSubview:self.thirdbgCycle];
    [self addSubview:self.fourthbgCycle];
    
    [self addSubview:self.connectLine];
    [self addSubview:self.pointView];
    [self addSubview:self.whiteLine];
    
    [self addSubview:self.firstButton];
    [self addSubview:self.firstTitleLabel];
    [self addSubview:self.firstDayLabel];
    
    [self addSubview:self.secondButton];
    [self addSubview:self.secondTitleLabel];
    [self addSubview:self.secondDayLabel];
    
    [self addSubview:self.thirdButton];
    [self addSubview:self.thirdTitleLabel];
    [self addSubview:self.thirdDayLabel];
    
    [self addSubview:self.fourthButton];
    [self addSubview:self.fourthTitleLabel];
    [self addSubview:self.fourthDayLabel];
    
    [self addSubview:self.bigPrizeImageView];
}

- (void)initConstraints {
    
    CGFloat lineWidth = KScreenWidth - 30*2;
    CGFloat firstButtonWidth = 23;
    CGFloat secondButtonWidth = 32;
    CGFloat thirdButtonWidth = 37;
    CGFloat fourthButtonWidth = 45;
    CGFloat lineSpace = (lineWidth - firstButtonWidth - secondButtonWidth - thirdButtonWidth - fourthButtonWidth)/3.0;
    
    [self.connectLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(32);
        make.left.right.mas_equalTo(self).inset(30);
        make.height.mas_equalTo(5);
    }];
    [self.whiteLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.mas_equalTo(self.connectLine);
    }];
    [self.pointView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.whiteLine);
        make.centerX.mas_equalTo(self.whiteLine.mas_right).offset(-3);
        make.width.height.mas_equalTo(9);
    }];
    
    [self.firstButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.connectLine);
        make.centerY.mas_equalTo(self.connectLine);
        make.width.height.mas_equalTo(firstButtonWidth);
    }];
    [self.firstTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.connectLine.mas_bottom).offset(28);
        make.centerX.mas_equalTo(self.firstButton);
        make.width.mas_equalTo(lineSpace+firstButtonWidth-4);
    }];
    [self.firstDayLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.firstTitleLabel.mas_bottom).offset(8);
        make.centerX.mas_equalTo(self.firstButton);
        make.width.mas_equalTo(self.firstTitleLabel);
    }];
    [self.firstbgCycle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(self.firstButton);
        make.width.height.mas_equalTo(firstButtonWidth+10);
    }];
    
    [self.secondButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.firstButton.mas_right).offset(lineSpace);
        make.centerY.mas_equalTo(self.connectLine);
        make.width.height.mas_equalTo(secondButtonWidth);
    }];
    [self.secondTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.firstTitleLabel);
        make.centerX.mas_equalTo(self.secondButton);
        make.width.mas_equalTo(lineSpace+secondButtonWidth-4);
    }];
    [self.secondDayLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.firstDayLabel);
        make.centerX.mas_equalTo(self.secondButton);
        make.width.mas_equalTo(self.firstTitleLabel);
    }];
    [self.secondbgCycle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(self.secondButton);
        make.width.height.mas_equalTo(secondButtonWidth+10);
    }];
    
    [self.thirdButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.secondButton.mas_right).offset(lineSpace);
        make.centerY.mas_equalTo(self.connectLine);
        make.width.height.mas_equalTo(thirdButtonWidth);
    }];
    [self.thirdTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.firstTitleLabel);
        make.centerX.mas_equalTo(self.thirdButton);
        make.width.mas_equalTo(lineSpace+thirdButtonWidth-4);
    }];
    [self.thirdDayLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.firstDayLabel);
        make.centerX.mas_equalTo(self.thirdButton);
        make.width.mas_equalTo(self.firstTitleLabel);
    }];
    [self.thirdbgCycle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(self.thirdButton);
        make.width.height.mas_equalTo(thirdButtonWidth+10);
    }];
    
    [self.fourthButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.connectLine);
        make.centerY.mas_equalTo(self.connectLine);
        make.width.height.mas_equalTo(fourthButtonWidth);
    }];
    [self.fourthTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.firstTitleLabel);
        make.centerX.mas_equalTo(self.fourthButton);
        make.width.mas_equalTo(lineSpace+fourthButtonWidth-4);
    }];
    [self.fourthDayLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.firstDayLabel);
        make.centerX.mas_equalTo(self.fourthButton);
        make.width.mas_equalTo(self.firstTitleLabel);
    }];
    [self.fourthbgCycle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(self.fourthButton);
        make.width.height.mas_equalTo(fourthButtonWidth+10);
    }];
    
    [self.bigPrizeImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.fourthButton).offset(-6);
        make.right.mas_equalTo(self.fourthButton).offset(10);
    }];
}

- (void)setupFirstData {
    CheckinRewardTotalNotice *firstItem = self.modelArray.firstObject;
    if (firstItem) {
        self.firstDayLabel.text = [NSString stringWithFormat:@"%ld天", firstItem.signDays];
        self.firstTitleLabel.text = firstItem.signRewardName;
        self.firstButton.enabled = !firstItem.isReceive;
        
        BOOL enoughDays = self.signDetail.totalDay >= firstItem.signDays;
        BOOL canGainGift = enoughDays && !firstItem.isReceive;
        self.firstbgCycle.hidden = !canGainGift;
        self.firstButton.selected = canGainGift;
        self.firstButton.userInteractionEnabled = canGainGift;
        
        UIColor *textColor = firstItem.isReceive ? UIColorFromRGB(0xFEE900) : UIColorFromRGB(0xFEFEFE);
        self.firstDayLabel.textColor = textColor;
        self.firstTitleLabel.textColor = textColor;
        self.firstTitleLabel.text = firstItem.isReceive ? @"已领取" : firstItem.signRewardName;
    }
}

- (void)setupSecondData {
    CheckinRewardTotalNotice *secondItem = [self.modelArray safeObjectAtIndex:1];
    if (secondItem) {
        self.secondDayLabel.text = [NSString stringWithFormat:@"%ld天", secondItem.signDays];
        self.secondTitleLabel.text = secondItem.signRewardName;
        self.secondButton.enabled = !secondItem.isReceive;
        
        BOOL enoughDays = self.signDetail.totalDay >= secondItem.signDays;
        BOOL canGainGift = enoughDays && !secondItem.isReceive;
        self.secondbgCycle.hidden = !canGainGift;
        self.secondButton.selected = canGainGift;
        self.secondButton.userInteractionEnabled = canGainGift;
        
        UIColor *textColor = secondItem.isReceive ? UIColorFromRGB(0xFEE900) : UIColorFromRGB(0xFEFEFE);
        self.secondDayLabel.textColor = textColor;
        self.secondTitleLabel.textColor = textColor;
        self.secondTitleLabel.text = secondItem.isReceive ? @"已领取" : secondItem.signRewardName;
    }
}

- (void)setupThirdData {
    CheckinRewardTotalNotice *thirdItem = [self.modelArray safeObjectAtIndex:2];
    if (thirdItem) {
        self.thirdDayLabel.text = [NSString stringWithFormat:@"%ld天", thirdItem.signDays];
        self.thirdTitleLabel.text = thirdItem.signRewardName;
        self.thirdButton.enabled = !thirdItem.isReceive;
        
        BOOL enoughDays = self.signDetail.totalDay >= thirdItem.signDays;
        BOOL canGainGift = enoughDays && !thirdItem.isReceive;
        self.thirdbgCycle.hidden = !canGainGift;
        self.thirdButton.selected = canGainGift;
        self.thirdButton.userInteractionEnabled = canGainGift;
        
        UIColor *textColor = thirdItem.isReceive ? UIColorFromRGB(0xFEE900) : UIColorFromRGB(0xFEFEFE);
        self.thirdDayLabel.textColor = textColor;
        self.thirdTitleLabel.textColor = textColor;
        self.thirdTitleLabel.text = thirdItem.isReceive ? @"已领取" : thirdItem.signRewardName;
    }
}

- (void)setupFourthData {
    BOOL enoughDays = self.signDetail.totalDay >= 28;
    BOOL canGainGift = enoughDays && self.signDetail.isDrawGold == 1;
    self.fourthbgCycle.hidden = !canGainGift;
    self.fourthButton.selected = canGainGift;
    self.fourthButton.userInteractionEnabled = canGainGift;
    self.fourthButton.enabled = !(enoughDays && self.signDetail.isDrawGold == 2);
    
    UIColor *textColor = self.signDetail.isDrawGold == 2 ? UIColorFromRGB(0xFEE900) : UIColorFromRGB(0xFEFEFE);
    self.fourthDayLabel.textColor = textColor;
    self.fourthTitleLabel.textColor = textColor;
    self.fourthTitleLabel.text = self.signDetail.isDrawGold == 2 ? @"已领取" : @"瓜分金币";
}

- (void)setupWhiteLine {
    if (self.signDetail == nil) {
        return;
    }
    
    if (self.modelArray == nil || self.modelArray.count != 3) {
        return;
    }
    
    NSInteger currentSignDays = self.signDetail.totalDay;
    CheckinRewardTotalNotice *first = [self.modelArray safeObjectAtIndex:0];
    CheckinRewardTotalNotice *second = [self.modelArray safeObjectAtIndex:1];
    CheckinRewardTotalNotice *third = [self.modelArray safeObjectAtIndex:2];
    
    CGFloat lineWidth = KScreenWidth - 30*2;
    CGFloat firstButtonWidth = 23;
    CGFloat secondButtonWidth = 32;
    CGFloat thirdButtonWidth = 37;
    CGFloat fourthButtonWidth = 45;
    CGFloat lineSpace = (lineWidth - firstButtonWidth - secondButtonWidth - thirdButtonWidth - fourthButtonWidth)/3.0;
    
    BOOL showWhiteDot = NO;
    if (currentSignDays >= first.signDays && currentSignDays < second.signDays) {
        [self.whiteLine mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.left.bottom.mas_equalTo(self.connectLine);
            make.right.mas_equalTo(self.firstButton.mas_right).offset(lineSpace/2);
        }];
        showWhiteDot = YES;
        
        //    } else if (currentSignDays == second.signDays) {
        //        [self.whiteLine mas_remakeConstraints:^(MASConstraintMaker *make) {
        //            make.top.left.bottom.mas_equalTo(self.connectLine);
        //            make.right.mas_equalTo(self.secondButton.mas_left);
        //        }];
    } else if (currentSignDays >= second.signDays && currentSignDays < third.signDays) {
        [self.whiteLine mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.left.bottom.mas_equalTo(self.connectLine);
            make.right.mas_equalTo(self.secondButton.mas_right).offset(lineSpace/2);
        }];
        showWhiteDot = YES;
        
        //    } else if (currentSignDays == third.signDays) {
        //        [self.whiteLine mas_remakeConstraints:^(MASConstraintMaker *make) {
        //            make.top.left.bottom.mas_equalTo(self.connectLine);
        //            make.right.mas_equalTo(self.thirdButton.mas_left);
        //        }];
    } else if (currentSignDays >= third.signDays && currentSignDays < 28) {
        [self.whiteLine mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.left.bottom.mas_equalTo(self.connectLine);
            make.right.mas_equalTo(self.thirdButton.mas_right).offset(lineSpace/2);
        }];
        showWhiteDot = YES;
        
    } else if (currentSignDays >= 28) {
        [self.whiteLine mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.left.bottom.mas_equalTo(self.connectLine);
            make.right.mas_equalTo(self.fourthButton.mas_left);
        }];
    }
    
    self.pointView.hidden = !showWhiteDot;
    
    [UIView animateWithDuration:0.2 animations:^{
        [self layoutIfNeeded];
    }];
}

#pragma mark - Getters and Setters
- (void)setModelArray:(NSArray<CheckinRewardTotalNotice *> *)modelArray {
    if (modelArray == nil) {
        return;
    }
    
    _modelArray = modelArray;
    
    [self setupFirstData];
    [self setupSecondData];
    [self setupThirdData];
    [self setupFourthData];
    
    [self setupWhiteLine];
}

- (void)setSignDetail:(CheckinSignDetail *)signDetail {
    if (![signDetail isKindOfClass:CheckinSignDetail.class]) {
        return;
    }
    
    _signDetail = signDetail;
    
    if (self.modelArray == nil || self.modelArray.count == 0) {
        return;
    }
    
    [self setupFirstData];
    [self setupSecondData];
    [self setupThirdData];
    [self setupFourthData];
    
    [self setupWhiteLine];
}

- (UIImageView *)bigPrizeImageView {
    if (_bigPrizeImageView == nil) {
        _bigPrizeImageView = [[UIImageView alloc] init];
        _bigPrizeImageView.image = [UIImage imageNamed:@"checkin_accumulate_big_reward"];
    }
    return _bigPrizeImageView;
}

- (UIView *)connectLine {
    if (_connectLine == nil) {
        _connectLine = [[UIView alloc] init];
        _connectLine.backgroundColor = [self connectLineColor];
    }
    return _connectLine;
}

- (UIColor *)connectLineColor {
    if (projectType() == ProjectType_LookingLove || projectType() == ProjectType_Planet) {
        return UIColorFromRGB(0x7E7EFF);
    }
    return UIColorFromRGB(0xA98AFF);
}

- (UIView *)pointView {
    if (_pointView == nil) {
        _pointView = [[UIView alloc] init];
        _pointView.backgroundColor = UIColor.whiteColor;
        _pointView.layer.cornerRadius = 4.5;
        _pointView.layer.masksToBounds = YES;
        _pointView.hidden = YES;
    }
    return _pointView;
}

- (UIView *)whiteLine {
    if (_whiteLine == nil) {
        _whiteLine = [[UIView alloc] init];
        _whiteLine.backgroundColor = UIColor.whiteColor;
    }
    return _whiteLine;
}

- (UIButton *)firstButton {
    if (_firstButton == nil) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setBackgroundImage:[UIImage imageNamed:@"checkin_accumulate_gift"] forState:UIControlStateNormal];
        [button setBackgroundImage:[UIImage imageNamed:@"checkin_accumulate_gift_wait_get"] forState:UIControlStateSelected];
        [button setBackgroundImage:[UIImage imageNamed:@"checkin_accumulate_checkmark"] forState:UIControlStateDisabled];
        [button addTarget:self action:@selector(firstButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
        
        [button setEnlargeEdgeWithTop:11 right:11 bottom:11 left:11];
        
        _firstButton = button;
    }
    return _firstButton;
}

- (UIButton *)secondButton {
    if (_secondButton == nil) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setBackgroundImage:[UIImage imageNamed:@"checkin_accumulate_gift"] forState:UIControlStateNormal];
        [button setBackgroundImage:[UIImage imageNamed:@"checkin_accumulate_gift_wait_get"] forState:UIControlStateSelected];
        [button setBackgroundImage:[UIImage imageNamed:@"checkin_accumulate_checkmark"] forState:UIControlStateDisabled];
        [button addTarget:self action:@selector(secondButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
        
        [button setEnlargeEdgeWithTop:6 right:6 bottom:6 left:6];
        
        _secondButton = button;
    }
    return _secondButton;
}

- (UIButton *)thirdButton {
    if (_thirdButton == nil) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setBackgroundImage:[UIImage imageNamed:@"checkin_accumulate_gift"] forState:UIControlStateNormal];
        [button setBackgroundImage:[UIImage imageNamed:@"checkin_accumulate_gift_wait_get"] forState:UIControlStateSelected];
        [button setBackgroundImage:[UIImage imageNamed:@"checkin_accumulate_checkmark"] forState:UIControlStateDisabled];
        [button addTarget:self action:@selector(thirdButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
        
        [button setEnlargeEdgeWithTop:4 right:4 bottom:4 left:4];
        
        _thirdButton = button;
    }
    return _thirdButton;
}

- (UIButton *)fourthButton {
    if (_fourthButton == nil) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setBackgroundImage:[UIImage imageNamed:@"checkin_accumulate_gift"] forState:UIControlStateNormal];
        [button setBackgroundImage:[UIImage imageNamed:@"checkin_accumulate_gift_wait_get"] forState:UIControlStateSelected];
        [button setBackgroundImage:[UIImage imageNamed:@"checkin_accumulate_checkmark"] forState:UIControlStateDisabled];
        [button addTarget:self action:@selector(fourthButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
        
        _fourthButton = button;
    }
    return _fourthButton;
}

- (UILabel *)firstTitleLabel {
    if (_firstTitleLabel == nil) {
        UILabel *label = [[UILabel alloc] init];
        label.font = [UIFont systemFontOfSize:13];
        label.textColor = UIColorFromRGB(0xfefefe);
        label.textAlignment = NSTextAlignmentCenter;
        label.text = @"🎁1";
        
        _firstTitleLabel = label;
    }
    return _firstTitleLabel;
}

- (UILabel *)secondTitleLabel {
    if (_secondTitleLabel == nil) {
        UILabel *label = [[UILabel alloc] init];
        label.font = [UIFont systemFontOfSize:13];
        label.textColor = UIColorFromRGB(0xfefefe);
        label.textAlignment = NSTextAlignmentCenter;
        label.text = @"🎁2";
        
        _secondTitleLabel = label;
    }
    return _secondTitleLabel;
}

- (UILabel *)thirdTitleLabel {
    if (_thirdTitleLabel == nil) {
        UILabel *label = [[UILabel alloc] init];
        label.font = [UIFont systemFontOfSize:13];
        label.textColor = UIColorFromRGB(0xfefefe);
        label.textAlignment = NSTextAlignmentCenter;
        label.text = @"🎁3";
        
        _thirdTitleLabel = label;
    }
    return _thirdTitleLabel;
}

- (UILabel *)fourthTitleLabel {
    if (_fourthTitleLabel == nil) {
        UILabel *label = [[UILabel alloc] init];
        label.font = [UIFont systemFontOfSize:13];
        label.textColor = UIColorFromRGB(0xfefefe);
        label.textAlignment = NSTextAlignmentCenter;
        label.text = @"瓜分金币";
        
        _fourthTitleLabel = label;
    }
    return _fourthTitleLabel;
}

- (UILabel *)firstDayLabel {
    if (_firstDayLabel == nil) {
        UILabel *label = [[UILabel alloc] init];
        label.font = [UIFont systemFontOfSize:12];
        label.textColor = UIColorFromRGB(0xfefefe);
        label.textAlignment = NSTextAlignmentCenter;
        label.text = @"7天";
        
        _firstDayLabel = label;
    }
    return _firstDayLabel;
}

- (UILabel *)secondDayLabel {
    if (_secondDayLabel == nil) {
        UILabel *label = [[UILabel alloc] init];
        label.font = [UIFont systemFontOfSize:12];
        label.textColor = UIColorFromRGB(0xfefefe);
        label.textAlignment = NSTextAlignmentCenter;
        label.text = @"14天";
        
        _secondDayLabel = label;
    }
    return _secondDayLabel;
}

- (UILabel *)thirdDayLabel {
    if (_thirdDayLabel == nil) {
        UILabel *label = [[UILabel alloc] init];
        label.font = [UIFont systemFontOfSize:12];
        label.textColor = UIColorFromRGB(0xfefefe);
        label.textAlignment = NSTextAlignmentCenter;
        label.text = @"21天";
        
        _thirdDayLabel = label;
    }
    return _thirdDayLabel;
}

- (UILabel *)fourthDayLabel {
    if (_fourthDayLabel == nil) {
        UILabel *label = [[UILabel alloc] init];
        label.font = [UIFont systemFontOfSize:12];
        label.textColor = UIColorFromRGB(0xfefefe);
        label.textAlignment = NSTextAlignmentCenter;
        label.text = @"28天";
        
        _fourthDayLabel = label;
    }
    return _fourthDayLabel;
}

- (UIView *)firstbgCycle {
    if (_firstbgCycle == nil) {
        _firstbgCycle = [[UIView alloc] init];
        _firstbgCycle.backgroundColor = [UIColor.whiteColor colorWithAlphaComponent:0.3];
        
        _firstbgCycle.layer.cornerRadius = 33/2.0;
        _firstbgCycle.layer.masksToBounds = YES;
    }
    return _firstbgCycle;
}

- (UIView *)secondbgCycle {
    if (_secondbgCycle == nil) {
        _secondbgCycle = [[UIView alloc] init];
        _secondbgCycle.backgroundColor = [UIColor.whiteColor colorWithAlphaComponent:0.3];
        
        _secondbgCycle.layer.cornerRadius = 42/2.0;
        _secondbgCycle.layer.masksToBounds = YES;
    }
    return _secondbgCycle;
}

- (UIView *)thirdbgCycle {
    if (_thirdbgCycle == nil) {
        _thirdbgCycle = [[UIView alloc] init];
        _thirdbgCycle.backgroundColor = [UIColor.whiteColor colorWithAlphaComponent:0.3];
        
        _thirdbgCycle.layer.cornerRadius = 47/2.0;
        _thirdbgCycle.layer.masksToBounds = YES;
    }
    return _thirdbgCycle;
}

- (UIView *)fourthbgCycle {
    if (_fourthbgCycle == nil) {
        _fourthbgCycle = [[UIView alloc] init];
        _fourthbgCycle.backgroundColor = [UIColor.whiteColor colorWithAlphaComponent:0.3];
        
        _fourthbgCycle.layer.cornerRadius = 55/2.0;
        _fourthbgCycle.layer.masksToBounds = YES;
    }
    return _fourthbgCycle;
}
@end
