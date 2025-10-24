//
//  TTGuildIncomeStatisticCell.m
//  TuTu
//
//  Created by lvjunhang on 2019/1/19.
//  Copyright © 2019 YiZhuan. All rights reserved.
//

#import "TTGuildIncomeStatisticCell.h"

#import "XCTheme.h"
#import "XCMacros.h"
#import "GuildIncomeTotal.h"
#import "UIImageView+QiNiu.h"

#import <Masonry/Masonry.h>

#define SCREEN_WIDTH_RATE KScreenWidth/375.0f

@interface TTGuildIncomeStatisticCell ()
@property (nonatomic, strong) UILabel *rankLabel;
@property (nonatomic, strong) UIImageView *avatarImageView;
@property (nonatomic, strong) UILabel *nickLabel;
@property (nonatomic, strong) UILabel *uidLabel;
@property (nonatomic, strong) UILabel *incomeLabel;
@property (nonatomic, strong) UIImageView *arrowImageView;
@end

@implementation TTGuildIncomeStatisticCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.backgroundColor = UIColor.whiteColor;
        
        [self initView];
        [self initConstraints];
    }
    return self;
}

#pragma mark - Private Methods
- (void)initView {
    
    [self.contentView addSubview:self.rankLabel];
    [self.contentView addSubview:self.nickLabel];
    [self.contentView addSubview:self.uidLabel];
    [self.contentView addSubview:self.incomeLabel];
    
    [self.contentView addSubview:self.avatarImageView];
    [self.contentView addSubview:self.arrowImageView];
}

- (void)initConstraints {
    [self.rankLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(8);
        make.centerY.mas_equalTo(0);
        make.width.mas_equalTo(48*SCREEN_WIDTH_RATE);
    }];
    [self.avatarImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.rankLabel.mas_right).mas_offset(12+2);
        make.centerY.mas_equalTo(0);
        make.width.height.mas_equalTo(44*SCREEN_WIDTH_RATE);
    }];
    [self.nickLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.avatarImageView.mas_right).mas_offset(12+4);
        make.top.mas_equalTo(self.avatarImageView).mas_offset(8);
        make.width.mas_equalTo(70*SCREEN_WIDTH_RATE);
    }];
    [self.uidLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.avatarImageView);
        make.left.width.mas_equalTo(self.nickLabel);
    }];
    
    [self.incomeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.nickLabel.mas_right).mas_offset(12);
        make.centerY.mas_equalTo(self.nickLabel);
        make.width.mas_equalTo(84*SCREEN_WIDTH_RATE);
    }];
    
    [self.arrowImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(0);
        make.right.mas_equalTo(-15);
    }];
}

- (void)setupTotalNumber:(NSInteger)number {
    NSString *numberStr = @(number).stringValue;
    NSString *unit = @"";
    if (number > 10000) {
        unit = @"万";
        numberStr = [NSString stringWithFormat:@"%.2f", number/10000.0f];
    }
    
    NSString *content = [NSString stringWithFormat:@"%@%@", numberStr, unit];
    
    self.incomeLabel.text = content;
}

#pragma mark - Setter Getter
- (void)setModel:(GuildIncomeTotalVos *)model {
    _model = model;
    
    self.nickLabel.text = model.nick;
    self.uidLabel.text = [NSString stringWithFormat:@"ID:%@", model.erbanNo];
    self.rankLabel.text = @(model.rowNum).stringValue;
    [self.avatarImageView qn_setImageImageWithUrl:model.avatar placeholderImage:[XCTheme defaultTheme].default_avatar type:ImageTypeCornerAvatar];
    
    [self setupTotalNumber:model.totalGoldNum];
}

- (UILabel *)rankLabel {
    if (_rankLabel == nil) {
        UILabel *label = [[UILabel alloc] init];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont boldSystemFontOfSize:18];
        label.textColor = [XCTheme getTTDeepGrayTextColor];
        
        _rankLabel = label;
    }
    return _rankLabel;
}

- (UILabel *)nickLabel {
    if (_nickLabel == nil) {
        UILabel *label = [[UILabel alloc] init];
        label.textAlignment = NSTextAlignmentLeft;
        label.font = [UIFont systemFontOfSize:14];
        label.textColor = [XCTheme getTTMainTextColor];
        
        _nickLabel = label;
    }
    return _nickLabel;
}

- (UILabel *)uidLabel {
    if (_uidLabel == nil) {
        UILabel *label = [[UILabel alloc] init];
        label.textAlignment = NSTextAlignmentLeft;
        label.font = [UIFont systemFontOfSize:12];
        label.textColor = [XCTheme getTTDeepGrayTextColor];
        
        _uidLabel = label;
    }
    return _uidLabel;
}

- (UILabel *)incomeLabel {
    if (_incomeLabel == nil) {
        UILabel *label = [[UILabel alloc] init];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont boldSystemFontOfSize:16];
        label.textColor = [XCTheme getTTMainColor];
        
        _incomeLabel = label;
    }
    return _incomeLabel;
}

- (UIImageView *)avatarImageView {
    if (_avatarImageView == nil) {
        _avatarImageView = [[UIImageView alloc] init];
        _avatarImageView.image = [UIImage imageNamed:[XCTheme defaultTheme].default_avatar];
        _avatarImageView.layer.cornerRadius = 44*SCREEN_WIDTH_RATE/2;
        _avatarImageView.layer.masksToBounds = YES;
    }
    return _avatarImageView;
}

- (UIImageView *)arrowImageView {
    if (_arrowImageView == nil) {
        _arrowImageView = [[UIImageView alloc] init];
        _arrowImageView.image = [UIImage imageNamed:@"guild_group_arrow"];
    }
    return _arrowImageView;
}

@end
