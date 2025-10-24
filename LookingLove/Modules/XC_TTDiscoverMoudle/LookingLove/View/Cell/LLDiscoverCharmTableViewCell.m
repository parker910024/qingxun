//
//  LLDiscoverCharmTableViewCell.m
//  XC_TTDiscoverMoudle
//
//  Created by fengshuo on 2019/7/26.
//  Copyright © 2019 fengshuo. All rights reserved.
//

#import "LLDiscoverCharmTableViewCell.h"

#import <Masonry/Masonry.h>
#import "XCTheme.h"
#import "UIImageView+QiNiu.h"

@interface LLDiscoverCharmTableViewCell ()
/** 标题*/
@property (nonatomic, strong) UILabel * titleLabel;
/** 副标题*/
@property (nonatomic, strong) UILabel * subTileLabel;
/** 图片*/
@property (nonatomic, strong) UIImageView * iconImageView;
/** 箭头*/
@property (nonatomic, strong) UIButton * arrowButton;
@end

@implementation LLDiscoverCharmTableViewCell
#pragma mark - life cycle
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initView];
        [self initConstrations];
    }
    return self;
}

#pragma mark - pulic method

/** 配置我的家族*/
- (void)configTTDiscoverSquareTableViewCell:(XCFamily *)family {
    if (family) {
        [self.iconImageView qn_setImageImageWithUrl:family.familyIcon placeholderImage:[[XCTheme defaultTheme] default_avatar] type:ImageTypeHomePageItem];
        NSString * familyStr = [NSString stringWithFormat:@"家族ID：%@  成员：%@", family.familyId,family.memberCount];
        self.titleLabel.text = family.familyName;
        self.subTileLabel.text = familyStr;
    }
}

/** 星推荐*/
- (void)configDiscoverCharmWith:(XCFamilyModel *)familyModel {
    if (familyModel) {
        [self.iconImageView qn_setImageImageWithUrl:familyModel.icon placeholderImage:[[XCTheme defaultTheme] default_avatar] type:ImageTypeHomePageItem];
        NSString * familyStr = [NSString stringWithFormat:@"家族ID：%@  成员：%d", familyModel.id,familyModel.memberCount];
        self.titleLabel.text = familyModel.name;
        self.subTileLabel.text = familyStr;
    }
}

#pragma mark - private method
- (void)initView {
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:self.iconImageView];
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.subTileLabel];
    [self.contentView addSubview:self.arrowButton];
}
- (void)initConstrations {
    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(60);
        make.centerY.mas_equalTo(self.contentView);
        make.left.mas_equalTo(self.contentView).offset(20);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.iconImageView.mas_right).offset(12);
        make.top.mas_equalTo(self.iconImageView.mas_top).offset(10);
    }];
    
    [self.subTileLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.titleLabel);
        make.top.mas_equalTo(self.titleLabel.mas_bottom).offset(10);
    }];
    
    [self.arrowButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(7);
        make.height.mas_equalTo(11);
        make.centerY.mas_equalTo(self.contentView);
        make.right.mas_equalTo(self.contentView).offset(-20);
    }];
}
#pragma mark - getters and setters
- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor  = [XCTheme getTTMainTextColor];
        _titleLabel.font = [UIFont systemFontOfSize:16];
    }
    return _titleLabel;
}
- (UILabel *)subTileLabel {
    if (!_subTileLabel) {
        _subTileLabel = [[UILabel alloc] init];
        _subTileLabel.textColor  =  UIColorFromRGB(0x999999);
        _subTileLabel.font = [UIFont systemFontOfSize:11];
    }
    return _subTileLabel;
}

- (UIButton *)arrowButton {
    if (!_arrowButton) {
        _arrowButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_arrowButton setImage:[UIImage imageNamed:@"discover_family_arrow"] forState:UIControlStateNormal];
    }
    return _arrowButton;
}

- (UIImageView *)iconImageView {
    if (!_iconImageView) {
        _iconImageView = [[UIImageView alloc] init];
        _iconImageView.layer.masksToBounds = YES;
        _iconImageView.layer.cornerRadius = 5;
    }
    return _iconImageView;
}


@end
