//
//  XC_MSRoomContributionCell.m
//  XCRoomMoudle
//
//  Created by KevinWang on 2018/10/16.
//  Copyright © 2018年 YiZhuan. All rights reserved.
//

#import "TTRoomContributionCell.h"

//t
#import <Masonry.h>
#import "XCTheme.h"
#import <YYLabel.h>

#import "UIImageView+QiNiu.h"
#import "NSString+SpecialClean.h"
#import "BaseAttrbutedStringHandler.h"

@interface TTRoomContributionCell ()

@property (nonatomic, strong) UIImageView *rankImageView;
@property (nonatomic, strong) UIImageView *avatarImageView;
@property (nonatomic, strong) UIImageView *genderImageView;
@property (nonatomic, strong) UILabel *nickNameLabel;
@property (nonatomic, strong) UIStackView *nickStckView;
@property (nonatomic, strong) UILabel *uidLabel;

@property (nonatomic, strong) UILabel *coinNumberLabel;
@property (nonatomic, strong) UILabel *farBeforeTipsLabel;//距离上一名

@end

@implementation TTRoomContributionCell

#pragma mark - Life Style
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.autoresizingMask = UIViewAutoresizingNone;
        self.selectionStyle = UITableViewCellSelectionStyleNone;//被选中的样式
        [self setupSubView];
        [self setupConstraints];
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
}

#pragma mark - public
+ (instancetype)cellWithTableView:(UITableView *)tableView {
    
    static NSString *ID = @"TTRoomContributionCell";
    TTRoomContributionCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[TTRoomContributionCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    return cell;
}

#pragma mark - Private
- (void)setupSubView {
    
    [self.contentView addSubview:self.rankImageView];
    [self.contentView addSubview:self.avatarImageView];
    [self.contentView addSubview:self.nickStckView];
    [self.contentView addSubview:self.uidLabel];
    [self.contentView addSubview:self.coinNumberLabel];
    [self.contentView addSubview:self.farBeforeTipsLabel];
}
- (void)setupConstraints{
    
    [self.rankImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo((50-20)/2.0);
        make.centerY.mas_equalTo(0);
        make.width.height.mas_equalTo(20);
    }];
    [self.avatarImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(@48);
        make.left.equalTo(self.contentView).offset(50);
        make.centerY.equalTo(self.contentView);
    }];
    
    [self.nickStckView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.avatarImageView).offset(8);
        make.left.mas_equalTo(self.avatarImageView.mas_right).offset(16);
        make.right.mas_lessThanOrEqualTo(self.coinNumberLabel.mas_left).offset(-40);
    }];
    
    [self.genderImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(13);
    }];
    
    [self.uidLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.nickStckView.mas_baseline).offset(8);
        make.left.mas_equalTo(self.nickStckView);
        make.right.mas_lessThanOrEqualTo(self.farBeforeTipsLabel.mas_left).offset(-40);
    }];
    
    [self.coinNumberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(0);
        make.right.mas_equalTo(-28);
    }];
    
    [self.farBeforeTipsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.uidLabel);
        make.right.mas_equalTo(-28);
    }];
}

#pragma mark - Getter

- (void)setInRoomData:(RoomBounsListInfo *)rankData {
    _inRoomData = rankData;
    
    self.uidLabel.text = [NSString stringWithFormat:@"ID:%lld", rankData.erbanNo];

    self.farBeforeTipsLabel.hidden = YES;
    [self.coinNumberLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(0);
        make.right.mas_equalTo(-28);
    }];
    [self.contentView layoutIfNeeded];

    NSString *rankImage = [NSString stringWithFormat:@"room_contribution_rank_%d", _inRoomData.ranking.intValue];
    self.rankImageView.image = [UIImage imageNamed:rankImage];
    
    NSString *numStr = [NSString stringWithFormat:@"%@",rankData.goldAmount];
    if ([rankData.goldAmount doubleValue] > 10000) {
        CGFloat numF = [rankData.goldAmount doubleValue] / 10000.0;
        numStr = [NSString stringWithFormat:@"%.1f万",numF];
        numStr = [numStr stringByReplacingOccurrencesOfString:@".0" withString:@""];
    }
    
    if (self.rankType == RankType_Send) {
        self.coinNumberLabel.text = [NSString stringWithFormat:@"%@%@",numStr,@""];
    }else{
        self.coinNumberLabel.text = [NSString stringWithFormat:@"%@%@",numStr,@""];
    }
    
    [self.avatarImageView qn_setImageImageWithUrl:rankData.avatar placeholderImage:[XCTheme defaultTheme].default_background type:ImageTypeUserIcon];
    
    self.nickNameLabel.text = [rankData.nick cleanSpecialText];;
    self.genderImageView.hidden = NO;
    self.genderImageView.image = [UIImage imageNamed:rankData.gender == UserInfo_Male ? @"common_sex_male" : @"common_sex_female"];
}

- (void)setHalfhourData:(RankData *)rankModel {
    _halfhourData = rankModel;
    
    self.uidLabel.text = [NSString stringWithFormat:@"ID:%@", rankModel.erbanNo];

    self.farBeforeTipsLabel.hidden = NO;
    self.genderImageView.hidden = YES;
    [self.coinNumberLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.nickNameLabel);
        make.right.mas_equalTo(-28);
    }];
    [self.contentView layoutIfNeeded];
    
    NSString *rankImage = [NSString stringWithFormat:@"room_contribution_rank_%d", rankModel.seqNo];
    self.rankImageView.image = [UIImage imageNamed:rankImage];
    
    NSString *numStr = [NSString stringWithFormat:@"%@",_halfhourData.totalNum];
    if ([_halfhourData.totalNum doubleValue] > 10000) {
        CGFloat numF = [_halfhourData.totalNum doubleValue] / 10000.0;
        numStr = [NSString stringWithFormat:@"%.1f万",numF];
        numStr = [numStr stringByReplacingOccurrencesOfString:@".0" withString:@""];
    }
    self.coinNumberLabel.text = numStr;
    
    [self.avatarImageView qn_setImageImageWithUrl:rankModel.avatar placeholderImage:[XCTheme defaultTheme].default_background type:ImageTypeUserIcon];
    self.nickNameLabel.text = [rankModel.roomTitle cleanSpecialText];
}

- (UIImageView *)avatarImageView {
    if (!_avatarImageView) {
        _avatarImageView = [[UIImageView alloc] init];
        _avatarImageView.layer.masksToBounds = YES;
        _avatarImageView.layer.cornerRadius = 24;
    }
    return _avatarImageView;
}

- (UIImageView *)rankImageView {
    if (!_rankImageView) {
        _rankImageView = [[UIImageView alloc] init];
    }
    return _rankImageView;
}

- (UIImageView *)genderImageView {
    if (!_genderImageView) {
        _genderImageView = [[UIImageView alloc] init];
        _genderImageView.image = [UIImage imageNamed:@"common_sex_female"];
        _genderImageView.hidden = YES;
        
        [_genderImageView setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    }
    return _genderImageView;
}

- (UILabel *)nickNameLabel {
    if (!_nickNameLabel) {
        _nickNameLabel = [[UILabel alloc] init];
        _nickNameLabel.font = [UIFont systemFontOfSize:14];
        _nickNameLabel.textColor = [XCTheme getMSMainTextColor];
    }
    return _nickNameLabel;
}

- (UIStackView *)nickStckView {
    if (_nickStckView == nil) {
        _nickStckView = [[UIStackView alloc] initWithArrangedSubviews:@[self.nickNameLabel, self.genderImageView]];
        _nickStckView.spacing = 4;
    }
    return _nickStckView;
}

- (UILabel *)uidLabel {
    if (!_uidLabel) {
        UILabel *label = [[UILabel alloc] init];
        label.font = [UIFont systemFontOfSize:12];
        label.textColor = [XCTheme getTTDeepGrayTextColor];
        label.textAlignment = NSTextAlignmentRight;
        
        _uidLabel = label;
    }
    return _uidLabel;
}

- (UILabel *)coinNumberLabel{
    if (!_coinNumberLabel) {
        _coinNumberLabel = [[UILabel alloc] init];
        _coinNumberLabel.font = [UIFont systemFontOfSize:16];
        _coinNumberLabel.textColor = [XCTheme getSecondaryRedColor];
        _coinNumberLabel.textAlignment = NSTextAlignmentRight;
        [_coinNumberLabel setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    }
    return _coinNumberLabel;
}

- (UILabel *)farBeforeTipsLabel {
    if (!_farBeforeTipsLabel) {
        UILabel *label = [[UILabel alloc] init];
        label.font = [UIFont systemFontOfSize:12];
        label.textColor = [XCTheme getTTDeepGrayTextColor];
        label.textAlignment = NSTextAlignmentRight;
        label.hidden = YES;
        label.text = @"距离上一名";
        [label setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];

        _farBeforeTipsLabel = label;
    }
    return _farBeforeTipsLabel;
}

@end
