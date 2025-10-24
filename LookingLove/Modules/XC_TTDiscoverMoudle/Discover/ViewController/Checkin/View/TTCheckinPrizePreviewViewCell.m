//
//  TTCheckinPrizePreviewViewCell.m
//  TTPlay
//
//  Created by lvjunhang on 2019/3/20.
//  Copyright © 2019 YiZhuan. All rights reserved.
//

#import "TTCheckinPrizePreviewViewCell.h"

#import "TTCheckinConst.h"

#import "XCTheme.h"
#import "CheckinRewardTodayNotice.h"
#import "UIImageView+QiNiu.h"
#import "XCTheme.h"

#import <Masonry/Masonry.h>

@interface TTCheckinPrizePreviewViewCell ()

@property (nonatomic, strong) UIImageView *hasSignBgImageView;//已签背景
@property (nonatomic, strong) UIView *hasSignMaskView;//已签蒙层
@property (nonatomic, strong) UILabel *hasReplenishLabel;//已补签
@property (nonatomic, strong) UIImageView *checkmarkImageView;//已签勾勾
@property (nonatomic, strong) UIImageView *replenishImageView;//补签标签

@property (nonatomic, strong) UILabel *nameLabel;//名称
@property (nonatomic, strong) UIImageView *prizeImageView;//礼物图片
@property (nonatomic, strong) UILabel *dayLabel;//天数
@property (nonatomic, strong) UIView *dayBGView;//天数背景
@end

@implementation TTCheckinPrizePreviewViewCell

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
#pragma mark - Private Methods
- (void)initViews {
    
    [self.contentView addSubview:self.hasSignBgImageView];
    
    [self.contentView addSubview:self.nameLabel];
    [self.contentView addSubview:self.prizeImageView];
    [self.contentView addSubview:self.dayBGView];
    [self.contentView addSubview:self.dayLabel];
    
    [self.contentView addSubview:self.hasSignMaskView];
    
    [self.contentView addSubview:self.checkmarkImageView];
    [self.contentView addSubview:self.hasReplenishLabel];
    [self.hasSignMaskView addSubview:self.replenishImageView];
}

- (void)initConstraints {
    [self.hasSignBgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.right.mas_equalTo(self.contentView).inset(10);
        make.height.mas_equalTo(self.hasSignMaskView.mas_width);
    }];
    [self.hasSignMaskView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.right.mas_equalTo(self.contentView).inset(10);
        make.height.mas_equalTo(self.hasSignMaskView.mas_width);
    }];
    
    [self.prizeImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.right.mas_equalTo(self.hasSignMaskView).inset(5);
    }];
    
    [self.checkmarkImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.hasSignMaskView).offset(14);
        make.centerX.mas_equalTo(self.hasSignMaskView);
    }];
    
    [self.dayBGView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.mas_equalTo(self.hasSignMaskView).offset(4);
        make.height.mas_equalTo(14);
        make.width.mas_greaterThanOrEqualTo(14);
    }];
    
    [self.dayLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.dayBGView).inset(3);
        make.centerY.mas_equalTo(self.dayBGView);
    }];
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.hasSignMaskView.mas_bottom).offset(10);
        make.left.right.mas_equalTo(self.contentView).inset(4);
    }];
    
    [self.hasReplenishLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.checkmarkImageView.mas_bottom).offset(4);
        make.centerX.mas_equalTo(0);
    }];
    
    [self.replenishImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(self.hasSignBgImageView);
        make.height.mas_equalTo(18);
    }];
}

#pragma mark - Getters and Setters
- (void)setModel:(CheckinRewardTodayNotice *)model {
    _model = model;
    
    [self.prizeImageView qn_setImageImageWithUrl:model.icon placeholderImage:[XCTheme defaultTheme].placeholder_image_square type:ImageTypeUserIcon];
    
    UIColor *nameColor = (projectType()==ProjectType_LookingLove || projectType() == ProjectType_Planet) ? UIColorFromRGB(0x6A98FF) : UIColorFromRGB(0xB48EFF);
    
    self.nameLabel.text = model.signRewardName;
    self.nameLabel.textColor = model.isReceive ? nameColor : UIColorFromRGB(0xA4A4A6);
    
    self.hasSignBgImageView.image = model.isReceive ? [UIImage imageNamed:@"checkin_preview_bg"] : nil;
    
    self.hasSignMaskView.backgroundColor = model.isReceive ? [UIColor.blackColor colorWithAlphaComponent:0.25] : UIColor.clearColor;
    
    self.dayLabel.text = @(model.signDays).stringValue;
    self.dayLabel.hidden = model.isReceive;
    self.dayBGView.hidden = model.isReceive;
    
    UIColor *dayColor = projectType()==ProjectType_LookingLove ? UIColorFromRGB(0x6A98FF) : UIColorFromRGB(0xA67AFE);

    self.dayBGView.backgroundColor = model.canReplenishSign ? UIColorFromRGB(0xD7D7D9) : dayColor;
    
    self.checkmarkImageView.hidden = !model.isReceive;
    
    self.hasReplenishLabel.hidden = model.signType != 2;
    self.replenishImageView.hidden = !model.canReplenishSign;
    
    if (model.canReplenishSign) {
        NSString *image = self.canReplenishSign ? @"checkin_preview_replenish" : @"checkin_preview_replenish_dis";
        self.replenishImageView.image = [UIImage imageNamed:image];
    }
}

- (void)setCanReplenishSign:(BOOL)canReplenishSign {
    _canReplenishSign = canReplenishSign;
    
    if (self.model.canReplenishSign) {
        NSString *image = canReplenishSign ? @"checkin_preview_replenish" : @"checkin_preview_replenish_dis";
        self.replenishImageView.image = [UIImage imageNamed:image];
    }
}

- (UIImageView *)prizeImageView {
    if (_prizeImageView == nil) {
        _prizeImageView = [[UIImageView alloc] init];
        _prizeImageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _prizeImageView;
}

- (UIImageView *)checkmarkImageView {
    if (_checkmarkImageView == nil) {
        _checkmarkImageView = [[UIImageView alloc] init];
        _checkmarkImageView.image = [UIImage imageNamed:@"checkin_ico_checkmark"];
    }
    return _checkmarkImageView;
}

- (UIImageView *)hasSignBgImageView {
    if (_hasSignBgImageView == nil) {
        _hasSignBgImageView = [[UIImageView alloc] init];
        _hasSignBgImageView.image = [UIImage imageNamed:@"checkin_preview_bg"];
        _hasSignBgImageView.backgroundColor = [XCTheme getTTSimpleGrayColor];

        _hasSignBgImageView.layer.cornerRadius = 10;
        _hasSignBgImageView.layer.masksToBounds = YES;
    }
    return _hasSignBgImageView;
}

- (UIView *)hasSignMaskView {
    if (_hasSignMaskView == nil) {
        _hasSignMaskView = [[UIView alloc] init];
        _hasSignMaskView.backgroundColor = [UIColor.blackColor colorWithAlphaComponent:0.25];
        
        _hasSignMaskView.layer.cornerRadius = 10;
        _hasSignMaskView.layer.masksToBounds = YES;
    }
    return _hasSignMaskView;
}

- (UIImageView *)replenishImageView {
    if (_replenishImageView == nil) {
        _replenishImageView = [[UIImageView alloc] init];
        _replenishImageView.image = [UIImage imageNamed:@"checkin_preview_replenish"];
    }
    return _replenishImageView;
}

- (UILabel *)dayLabel {
    if (_dayLabel == nil) {
        UILabel *label = [[UILabel alloc] init];
        label.text = @"0";
        label.textColor = UIColor.whiteColor;
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont systemFontOfSize:11];
        
        _dayLabel = label;
    }
    return _dayLabel;
}

- (UIView *)dayBGView {
    if (_dayBGView == nil) {
        _dayBGView = [[UIView alloc] init];
        _dayBGView.backgroundColor = UIColorFromRGB(0xB48EFF);
        _dayBGView.layer.cornerRadius = 7;
        _dayBGView.layer.masksToBounds = YES;
    }
    return _dayBGView;
}

- (UILabel *)nameLabel {
    if (_nameLabel == nil) {
        UILabel *label = [[UILabel alloc] init];
        label.text = @"已签到";
        label.textColor = UIColorFromRGB(0xA4A4A6);
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont systemFontOfSize:12];
        
        _nameLabel = label;
    }
    return _nameLabel;
}

- (UILabel *)hasReplenishLabel {
    if (_hasReplenishLabel == nil) {
        UILabel *label = [[UILabel alloc] init];
        label.text = @"已补签";
        label.textColor = UIColorFromRGB(0xFFFFFF);
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont boldSystemFontOfSize:11];
        
        _hasReplenishLabel = label;
    }
    return _hasReplenishLabel;
}

@end
