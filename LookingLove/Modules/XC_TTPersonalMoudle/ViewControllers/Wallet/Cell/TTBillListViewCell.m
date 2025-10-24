//
//  TTBillListViewCell.m
//  TuTu
//
//  Created by lee on 2018/11/12.
//  Copyright © 2018 YiZhuan. All rights reserved.
//

#import "TTBillListViewCell.h"

#import <Masonry/Masonry.h>
#import "XCTheme.h"
#import "XCMacros.h"
#import "UIView+ZJFrame.h"
#import "WithDrawlBillInfo.h"
#import "RechargeBillInfo.h"
#import "PLTimeUtil.h"
#import "RedBillInfo.h"
#import "XCKeyWordTool.h"

@interface TTBillListViewCell ()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UILabel *countLabel;

@end

@implementation TTBillListViewCell

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
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.timeLabel];
    [self.contentView addSubview:self.countLabel];
}

- (void)initConstraints {
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.top.mas_equalTo(15);
    }];
    
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.bottom.mas_equalTo(-20);
    }];
    
    [self.countLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-15);
        make.top.mas_equalTo(15);
    }];
}

#pragma mark -
#pragma mark private methods
- (void)configModel:(__kindof BaseObject *)baseObject {
    
    // 提现数据
    if ([baseObject isKindOfClass:[WithDrawlBillInfo class]] &&
        _billType == TTBillListViewTypeCodeRed)
    {
        WithDrawlBillInfo *codeRedInfo = (WithDrawlBillInfo *)baseObject;
        
        _titleLabel.text = [NSString stringWithFormat:@"%@%ld%@",[XCKeyWordTool sharedInstance].xcGetCF, labs(codeRedInfo.diamondNum), [XCKeyWordTool sharedInstance].xcCF];
        _timeLabel.text = [PLTimeUtil getDateWithTotalTimeWith:[NSString stringWithFormat:@"%ld", (long)codeRedInfo.recordTime]];
        _countLabel.text = [NSString stringWithFormat:@"%@元", codeRedInfo.money];
    }
    
    // 充值数据
    if ([baseObject isKindOfClass:[RechargeBillInfo class]] &&
        _billType == TTBillListViewTypeRecharge)
    {
        RechargeBillInfo *rechargeInfo = (RechargeBillInfo *)baseObject;
        if (rechargeInfo.objType.integerValue == 54 || rechargeInfo.objType.integerValue == 55) {
            _titleLabel.text = [NSString stringWithFormat:@"%@金币", rechargeInfo.goldNum];
        } else {
            _titleLabel.text = [NSString stringWithFormat:@"充值%@金币", rechargeInfo.goldNum];
        }
        _timeLabel.text = [PLTimeUtil getDateWithTotalTimeWith:[NSString stringWithFormat:@"%ld", (long)rechargeInfo.recordTime]];
        _countLabel.text = rechargeInfo.showStr;
    }
    
    // 红包
    if ([baseObject isKindOfClass:[RedBillInfo class]] &&
        _billType == TTBillListViewTypeRedColor)
    {
        RedBillInfo *redBillInfo = (RedBillInfo *)baseObject;
        _titleLabel.text = redBillInfo.typeStr;
        _timeLabel.text = [PLTimeUtil getDateWithTotalTimeWith:[NSString stringWithFormat:@"%ld", (long)redBillInfo.recordTime]];
        _countLabel.text = [NSString stringWithFormat:@"%@米", redBillInfo.packetNum];   
    }
    
    if ([baseObject isKindOfClass:[RedBillInfo class]] &&
        _billType == TTBillListViewTypeRedBalance)
    {
        RedBillInfo *redBillInfo = (RedBillInfo *)baseObject;
        _titleLabel.text = redBillInfo.typeStr;
        _timeLabel.text = [PLTimeUtil getDateWithTotalTimeWith:[NSString stringWithFormat:@"%ld", (long)redBillInfo.recordTime]];
        _countLabel.text = [NSString stringWithFormat:@"%@米", redBillInfo.packetNum];
    }
}

#pragma mark -
#pragma mark getter & setter
- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = [XCTheme getTTMainTextColor];
        _titleLabel.font = [UIFont systemFontOfSize:15.f];
        _titleLabel.adjustsFontSizeToFitWidth = YES;
    }
    return _titleLabel;
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
        _countLabel.font = [UIFont systemFontOfSize:16];
        _countLabel.adjustsFontSizeToFitWidth = YES;
    }
    return _countLabel;
}

@end
