//
//  TTMyFamilyMoneyTableViewCell.m
//  TuTu
//
//  Created by gzlx on 2018/11/3.
//  Copyright © 2018年 YiZhuan. All rights reserved.
//

#import "TTMyFamilyMoneyTableViewCell.h"
#import <Masonry/Masonry.h>
#import "XCTheme.h"
#import "NSString+Utils.h"


@interface TTMyFamilyMoneyTableViewCell()
/** 标题*/
@property (nonatomic, strong) UILabel * titleLabel;
/** 家族*/
@property (nonatomic, strong) UILabel * moneyLabel;
/** 箭头*/
@property (nonatomic, strong) UIImageView * arrowImageView;
@end

@implementation TTMyFamilyMoneyTableViewCell
#pragma mark - life cycle
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initView];
        [self initContrations];
    }
    return self;
}

#pragma mark - public method
- (void)configTTMyFamilyMoneyTableViewCellWithFamilyModel:(XCFamily *)family{
    NSString * money = [NSString changeAsset:[NSString stringWithFormat:@"%.2f", family.familyMoney]];
    self.moneyLabel.text = [NSString stringWithFormat:@"%@%@",money, family.moneyName];
}

#pragma mark - private method
- (void)initView{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.moneyLabel];
    [self.contentView addSubview:self.arrowImageView];
}

- (void)initContrations{
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView).offset(15);
        make.centerY.mas_equalTo(self.contentView);
    }];
    
    [self.arrowImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(7);
        make.height.mas_equalTo(11);
        make.right.mas_equalTo(self.contentView).offset(-15);
        make.centerY.mas_equalTo(self.contentView);
    }];
    
    [self.moneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.arrowImageView.mas_left).offset(-6);
        make.centerY.mas_equalTo(self.contentView);
    }];
}

#pragma mark - setters and getters
- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor  =  UIColorFromRGB(0x1a1a1a);
        _titleLabel.font = [UIFont systemFontOfSize:15];
        _titleLabel.text = @"我的家族币";
    }
    return _titleLabel;
}

- (UILabel *)moneyLabel{
    if (!_moneyLabel) {
        _moneyLabel = [[UILabel alloc] init];
        _moneyLabel.textColor  =  [XCTheme getTTMainColor];
        _moneyLabel.font = [UIFont systemFontOfSize:13];
    }
    return _moneyLabel;
}

- (UIImageView *)arrowImageView{
    if (!_arrowImageView) {
        _arrowImageView = [[UIImageView alloc] init];
        _arrowImageView.image = [UIImage imageNamed:@"discover_family_arrow"];
    }
    return _arrowImageView;
}


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
