//
//  TTDiscoverCharmCollectionViewCell.m
//  TuTu
//
//  Created by gzlx on 2018/10/29.
//  Copyright © 2018年 YiZhuan. All rights reserved.
//

#import "TTDiscoverCharmCollectionViewCell.h"
#import <Masonry/Masonry.h>
#import "XCTheme.h"
#import "UIImageView+QiNiu.h"

@interface TTDiscoverCharmCollectionViewCell ()
/** 家族名称*/
@property (nonatomic, strong) UILabel * titleLabel;
/** 家族头像*/
@property (nonatomic, strong) UIImageView * iconImageView;
@end

@implementation TTDiscoverCharmCollectionViewCell

#pragma mark - life cycle
- (id)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self initView];
        [self initConstrations];
    }
    return self;
}
#pragma mark - public methods
- (void)configDiscoverCharmWith:(XCFamilyModel *)familyModel{
    if (familyModel) {
        [self.iconImageView qn_setImageImageWithUrl:familyModel.icon placeholderImage:[[XCTheme defaultTheme] default_avatar] type:ImageTypeHomePageItem];
        if (familyModel.name.length > 0) {
            self.titleLabel.text = familyModel.name;
        }else{
            self.titleLabel.text = @"";
        }
    }
}

#pragma mark - private method
- (void)initView {
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.iconImageView];
}
- (void)initConstrations {
    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(70);
        make.left.top.mas_equalTo(self.contentView);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.iconImageView);
        make.top.mas_equalTo(self.iconImageView.mas_bottom).offset(6);
    }];
}
#pragma mark - getters and setters
- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor  = [XCTheme getTTMainTextColor];
        _titleLabel.font = [UIFont systemFontOfSize:13];
    }
    return _titleLabel;
}

- (UIImageView *)iconImageView{
    if (!_iconImageView) {
        _iconImageView = [[UIImageView alloc] init];
        _iconImageView.layer.masksToBounds = YES;
        _iconImageView.layer.cornerRadius = 5;
    }
    return _iconImageView;
}


@end
