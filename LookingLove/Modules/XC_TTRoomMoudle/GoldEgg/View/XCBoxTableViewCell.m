//
//  XCBoxTableViewCell.m
//  XCRoomMoudle
//
//  Created by KevinWang on 2018/8/22.
//  Copyright © 2018年 YiZhuan. All rights reserved.
//

#import "XCBoxTableViewCell.h"
#import "BoxPrizeModel.h"
#import <Masonry.h>
#import "XCTheme.h"
#import "UIImageView+QiNiu.h"
#import "BaseAttrbutedStringHandler.h"
#import "UIView+NTES.h"

@interface XCBoxTableViewCell()

@property (nonatomic, strong) UIImageView  *iconImageView;//奖品图标
@property (nonatomic, strong) UILabel  *nameLabel;//奖品名称
@property (nonatomic, strong) UILabel *possibility
;
@property (nonatomic, strong) UILabel  *timeLabel;//奖品时间
@property (nonatomic, strong) UIView  *lineView;//线
@property (nonatomic, strong) UIView *bgView; // 背景view
@end

@implementation XCBoxTableViewCell

#pragma mark - life cycle

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self =  [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        //        self.backgroundColor = UIColorRGBAlpha(0x000000, 0.8);
        //        self.contentView.backgroundColor = UIColorRGBAlpha(0x000000, 0.8);
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0];
        self.contentView.backgroundColor = [UIColor colorWithWhite:0 alpha:0];
        [self initSubViews];
        [self makeConstraints];
    }
    return self;
}

#pragma mark - puble method
- (void)setModel:(BoxPrizeModel *)model {
    _model = model;
    
    
    [self.iconImageView qn_setImageImageWithUrl:_model.prizeImgUrl placeholderImage:nil type:ImageTypeUserIcon];

    // 中奖几率
    self.possibility.hidden = !model.isJackpot;
    self.possibility.text = model.showRate;
    
    self.timeLabel.text = model.recodeTimeStr;
    if (model.isJackpot) {
        self.timeLabel.text = [NSString stringWithFormat:@"%.2f金币",model.platformValue];
        [self.possibility sizeToFit];
        self.possibility.width += 5;
        self.possibility.textColor = UIColorFromRGB(0xFFE823);
    }
    
    if (!self.isTimeList) {
        self.timeLabel.text = [NSString stringWithFormat:@"%.2f金币",model.platformValue];
        self.timeLabel.textColor = UIColorFromRGB(0xFFE823);
    } else {
        self.timeLabel.textColor = UIColor.whiteColor;
    }
    
    if (model.prizeNum <= 1) {
        self.nameLabel.text = model.prizeName;
    }else{
        NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] init];
        [attr appendAttributedString:[BaseAttrbutedStringHandler creatStrAttrByStr:model.prizeName attributed:@{NSFontAttributeName:[UIFont systemFontOfSize:14],NSForegroundColorAttributeName:[UIColor whiteColor]}]];
        [attr appendAttributedString:[BaseAttrbutedStringHandler creatStrAttrByStr:[NSString stringWithFormat:@" x%d",model.prizeNum] attributed:@{NSFontAttributeName:[UIFont systemFontOfSize:14],NSForegroundColorAttributeName:UIColorFromRGB(0xFFE823)}]];
        self.nameLabel.attributedText = attr;
    }
}


#pragma mark - private method

- (void)initSubViews {
    
    [self.contentView addSubview:self.bgView];
    [self.contentView addSubview:self.iconImageView];
    [self.contentView addSubview:self.nameLabel];
    [self.contentView addSubview:self.possibility];
    [self.contentView addSubview:self.timeLabel];
}

- (void)makeConstraints{
    
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.contentView).insets(UIEdgeInsetsMake(15, 15, 0, 15));
    }];
    
    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView).offset(7);
        make.left.mas_equalTo(self.bgView).offset(12);
        make.height.width.mas_equalTo(45);
    }];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.iconImageView);
        make.left.equalTo(self.iconImageView.mas_right).offset(13);
    }];
    [self.possibility mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.iconImageView);
        make.left.equalTo(self.nameLabel.mas_right).offset(5);
    }];
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.iconImageView);
        make.right.equalTo(self.contentView).offset(-25);
    }];
}


#pragma mark - Getter && Setter

- (UIImageView *)iconImageView {
    if (!_iconImageView) {
        _iconImageView = [[UIImageView alloc] init];
        _iconImageView.layer.masksToBounds = YES;
        _iconImageView.layer.cornerRadius = 15;
    }
    return _iconImageView;
}

- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.font = [UIFont systemFontOfSize:13];
        _nameLabel.textColor = [UIColor whiteColor];
    }
    return _nameLabel;
}
- (UILabel *)possibility {
    if (!_possibility) {
        _possibility = [[UILabel alloc] init];
        _possibility.font = [UIFont systemFontOfSize:10];
        _possibility.textColor = [UIColor whiteColor];
        _possibility.backgroundColor = UIColorFromRGB(0x7247ED);
        _possibility.layer.cornerRadius = 7;
        _possibility.layer.masksToBounds = YES;
        _possibility.textAlignment = NSTextAlignmentCenter;
        _possibility.hidden = YES;
    }
    return _possibility;
}

- (UILabel *)timeLabel {
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.font = [UIFont systemFontOfSize:14];
        _timeLabel.textColor = [UIColor whiteColor];
    }
    return _timeLabel;
}

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = UIColorRGBAlpha(0xFFFFFF, 0.3);
    }
    return _lineView;
}

- (UIView *)bgView {
    if (!_bgView) {
        _bgView = [[UIView alloc] init];
        _bgView.backgroundColor = UIColorRGBAlpha(0x8820E0, 0.3);
        _bgView.layer.cornerRadius = 10;
        _bgView.layer.masksToBounds = YES;
    }
    return _bgView;
}

@end
