//
//  TTCarrotBillCell.m
//  TTPlay
//
//  Created by lee on 2019/3/27.
//  Copyright © 2019 YiZhuan. All rights reserved.
//

#import "TTCarrotBillCell.h"
#import <Masonry/Masonry.h>
#import "XCTheme.h"
#import "XCMacros.h"
#import "UIView+ZJFrame.h"
#import "CarrotGiftInfo.h"
#import "PLTimeUtil.h"

@interface TTCarrotBillCell ()
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UILabel *priceLabel;
@property (nonatomic, strong) UILabel *carrotLabel;
@end

@implementation TTCarrotBillCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initViews];
        [self initConstraints];
    }
    return self;
}

#pragma mark -
#pragma mark - lifeCycle
- (void)initViews {
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.timeLabel];
    [self.contentView addSubview:self.priceLabel];
    [self.contentView addSubview:self.carrotLabel];
}

- (void)initConstraints {
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(20);
        make.left.mas_equalTo(15);
    }];
    
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.top.mas_equalTo(self.titleLabel.mas_bottom).offset(15);
    }];
    
    [self.priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-15);
        make.top.mas_equalTo(20);
    }];
    
    [self.carrotLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-15);
        make.top.mas_equalTo(self.timeLabel);
    }];
}

#pragma mark -
#pragma mark clients

#pragma mark -
#pragma mark private methods
- (void)setCarrotInfo:(CarrotGiftInfo *)carrotInfo {
    _carrotInfo = carrotInfo;
    self.titleLabel.text = carrotInfo.describeStr;
    self.timeLabel.text = [self configTimeString:carrotInfo.date];
    self.priceLabel.text = carrotInfo.amountStr;
    self.carrotLabel.text = carrotInfo.currencyStr;
}

- (NSString *)configTimeString:(NSString *)time {
    return [PLTimeUtil getDateWithYYMMDD:time];
}
#pragma mark -
#pragma mark button click events

#pragma mark -
#pragma mark getter & setter

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.text = @"签到奖励";
        _titleLabel.textColor = [XCTheme getTTMainTextColor];
        _titleLabel.font = [UIFont systemFontOfSize:15];
        _titleLabel.adjustsFontSizeToFitWidth = YES;
        _titleLabel.numberOfLines = 0;
    }
    return _titleLabel;
}

- (UILabel *)timeLabel {
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.text = @"2019年03月27日";
        _timeLabel.textColor = [XCTheme getTTDeepGrayTextColor];
        _timeLabel.font = [UIFont systemFontOfSize:13];
        _timeLabel.adjustsFontSizeToFitWidth = YES;
        _timeLabel.numberOfLines = 0;
    }
    return _timeLabel;
}

- (UILabel *)priceLabel {
    if (!_priceLabel) {
        _priceLabel = [[UILabel alloc] init];
        _priceLabel.text = @"9999";
        _priceLabel.textColor = [XCTheme getTTMainColor];
        _priceLabel.font = [UIFont systemFontOfSize:18];
        _priceLabel.adjustsFontSizeToFitWidth = YES;
        _priceLabel.numberOfLines = 0;
    }
    return _priceLabel;
}

- (UILabel *)carrotLabel {
    if (!_carrotLabel) {
        _carrotLabel = [[UILabel alloc] init];
        _carrotLabel.text = @"萝卜";
        _carrotLabel.textColor = [XCTheme getTTDeepGrayTextColor];
        _carrotLabel.font = [UIFont systemFontOfSize:13];
        _carrotLabel.adjustsFontSizeToFitWidth = YES;
        _carrotLabel.numberOfLines = 0;
    }
    return _carrotLabel;
}

@end

