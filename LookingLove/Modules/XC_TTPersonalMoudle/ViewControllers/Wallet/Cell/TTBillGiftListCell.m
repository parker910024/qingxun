//
//  TTBillGiftListCell.m
//  TuTu
//
//  Created by lee on 2018/11/12.
//  Copyright © 2018 YiZhuan. All rights reserved.
//

#import "TTBillGiftListCell.h"

#import <Masonry/Masonry.h>
#import "XCTheme.h"
#import "XCMacros.h"
#import "UIView+ZJFrame.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "PLTimeUtil.h"

// model
#import "GiftBillInfo.h"
#import "CarrotGiftInfo.h"

@interface TTBillGiftListCell ()

@property (nonatomic, strong) UIImageView *giftIcon;
@property (nonatomic, strong) UILabel *giftTitleLabel;  // 送的礼物
@property (nonatomic, strong) UILabel *timeLabel; // 时间
@property (nonatomic, strong) UILabel *presenterLabel; // 送礼人
@property (nonatomic, strong) UILabel *countLabel;
@property (nonatomic, strong) UILabel *giftTypeLabel;

@end

@implementation TTBillGiftListCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self initViews];
        [self initConstraints];
    }
    return self;
}

#pragma mark -
#pragma mark lifeCycle
- (void)initViews {
    [self.contentView addSubview:self.giftIcon];
    [self.contentView addSubview:self.giftTitleLabel];
    [self.contentView addSubview:self.timeLabel];
    [self.contentView addSubview:self.presenterLabel];
    [self.contentView addSubview:self.countLabel];
    [self.contentView addSubview:self.giftTypeLabel];
}

- (void)initConstraints {
    [self.giftIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.centerY.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(40, 40));
    }];
    
    [self.giftTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.giftIcon.mas_right).offset(15);
        make.top.mas_equalTo(self.giftIcon);
    }];
    
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.giftTitleLabel.mas_right).offset(10);
        make.right.mas_lessThanOrEqualTo(-15);
        make.centerY.mas_equalTo(self.giftTitleLabel);
    }];
    
    [self.presenterLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.giftTitleLabel);
        make.bottom.mas_equalTo(self.giftIcon);
    }];
    
    [self.countLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-15);
        make.centerY.mas_equalTo(self.giftTitleLabel);
    }];
    
    [self.giftTypeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-15);
        make.bottom.mas_equalTo(self.giftIcon);
    }];
}

#pragma mark -
#pragma mark private methods
- (void)configModel:(__kindof BaseObject *)baseObject {
    if (!baseObject) {
        return;
    }
    
    if ([baseObject isKindOfClass:[GiftBillInfo class]]) {
        GiftBillInfo *giftInfo = (GiftBillInfo*)baseObject;
        // 普通礼物
        [self setGiftInfo:giftInfo];
    }
    
    if ([baseObject isKindOfClass:[CarrotGiftInfo class]]) {
        CarrotGiftInfo *carrotInfo = (CarrotGiftInfo *)baseObject;
        // 萝卜礼物
        [self setCarrotInfo:carrotInfo];
    }
}
#pragma mark -
#pragma mark getter & setter
- (void)setGiftInfo:(GiftBillInfo *)giftInfo {
    if (![giftInfo isKindOfClass:[GiftBillInfo class]]) {
        return;
    }
    _giftInfo = giftInfo;
    
    
    [_giftIcon sd_setImageWithURL:[NSURL URLWithString:giftInfo.giftPict]];
    _giftTitleLabel.text = [NSString stringWithFormat:@"%@",giftInfo.giftName];
    _timeLabel.text = [PLTimeUtil getDateWithHHMMSS:[NSString stringWithFormat:@"%f",giftInfo.recordTime]];
    
    if (_giftType == TTBillListViewTypeGiftIn) {
        _presenterLabel.text = [NSString stringWithFormat:@"送礼人: %@",giftInfo.targetNick];
        _countLabel.text = [NSString stringWithFormat:@"+%@",giftInfo.diamondNum];
        
    } else if (_giftType == TTBillListViewTypeGiftOut) {
        _presenterLabel.text = [NSString stringWithFormat:@"收礼人: %@",giftInfo.targetNick];
        _countLabel.text = [NSString stringWithFormat:@"-%@",giftInfo.goldNum];
        _giftTypeLabel.text = @"金币";
    }
    _countLabel.textColor = [XCTheme getTTMainTextColor];
}

- (void)setCarrotInfo:(CarrotGiftInfo *)carrotInfo {
    _carrotInfo = carrotInfo;
    
    [_giftIcon sd_setImageWithURL:[NSURL URLWithString:carrotInfo.giftPicUrl]];
    _giftTitleLabel.text = [NSString stringWithFormat:@"%@",carrotInfo.giftName];
    _timeLabel.text = [PLTimeUtil getDateWithHHMMSS:carrotInfo.createTime];
    _presenterLabel.text = carrotInfo.describeStr;
    _countLabel.text = carrotInfo.amountStr;
    if (_giftType == TTBillListViewTypeGiftOutCarrot) {
        _giftTypeLabel.text = @"萝卜";
    } else if (_giftType == TTBillListViewTypeGiftInCarrot) {
        _countLabel.textColor = [XCTheme getTTMainColor];
        _countLabel.text = [NSString stringWithFormat:@"x%@", carrotInfo.giftNum.stringValue];
    }
}

- (UIImageView *)giftIcon
{
    if (!_giftIcon) {
        _giftIcon = [[UIImageView alloc] init];
    }
    return _giftIcon;
}

- (UILabel *)giftTitleLabel
{
    if (!_giftTitleLabel) {
        _giftTitleLabel = [[UILabel alloc] init];
        _giftTitleLabel.textColor = [XCTheme getTTMainTextColor];
        _giftTitleLabel.font = [UIFont systemFontOfSize:15.f];
        _giftTitleLabel.adjustsFontSizeToFitWidth = YES;
    }
    return _giftTitleLabel;
}

- (UILabel *)presenterLabel
{
    if (!_presenterLabel) {
        _presenterLabel = [[UILabel alloc] init];
        _presenterLabel.textColor = [XCTheme getTTDeepGrayTextColor];
        _presenterLabel.font = [UIFont systemFontOfSize:13.f];
        _presenterLabel.adjustsFontSizeToFitWidth = YES;
    }
    return _presenterLabel;
}

- (UILabel *)timeLabel
{
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.textColor = [XCTheme getTTDeepGrayTextColor];
        _timeLabel.font = [UIFont systemFontOfSize:13.f];
        _timeLabel.adjustsFontSizeToFitWidth = YES;
    }
    return _timeLabel;
}

- (UILabel *)countLabel
{
    if (!_countLabel) {
        _countLabel = [[UILabel alloc] init];
        _countLabel.textColor = [XCTheme getTTMainTextColor];
        _countLabel.font = [UIFont boldSystemFontOfSize:18.f];
        _countLabel.adjustsFontSizeToFitWidth = YES;
        _countLabel.textAlignment = NSTextAlignmentRight;
    }
    return _countLabel;
}

- (UILabel *)giftTypeLabel
{
    if (!_giftTypeLabel) {
        _giftTypeLabel = [[UILabel alloc] init];
        _giftTypeLabel.textColor = [XCTheme getTTDeepGrayTextColor];
        _giftTypeLabel.font = [UIFont systemFontOfSize:13.f];
        _giftTypeLabel.adjustsFontSizeToFitWidth = YES;
        _giftTitleLabel.textAlignment = NSTextAlignmentRight;
    }
    return _giftTypeLabel;
}
@end
