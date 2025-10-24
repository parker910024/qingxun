//
//  TTFamilyPatriaTableViewCell.m
//  TuTu
//
//  Created by gzlx on 2018/11/3.
//  Copyright © 2018年 YiZhuan. All rights reserved.
//族长的家族币

#import "TTFamilyPatriaTableViewCell.h"
#import <Masonry/Masonry.h>
#import "XCTheme.h"
#import "UIImageView+QiNiu.h"

@interface TTFamilyPatriaTableViewCell ()
/** 族长的标签*/
@property (nonatomic, strong) UIImageView * patriaImageView;
/** 族长的名字*/
@property (nonatomic, strong) UILabel * titleLabel;
/** 族长的头像*/
@property (nonatomic, strong) UIImageView * logoImageView;
/** 箭头*/
@property (nonatomic, strong) UIImageView * arrowImageView;
@end

@implementation TTFamilyPatriaTableViewCell

#pragma mark - life cycle
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initView];
        [self initConstrations];
    }
    return self;
}

#pragma mark - public methods
- (void)configTTFamilyPatriaTableViewCellWithFamily:(XCFamily *)family{
    if (family) {
        [self.logoImageView qn_setImageImageWithUrl:family.leader.icon placeholderImage:[[XCTheme defaultTheme] default_avatar] type:ImageTypeUserIcon];
        self.titleLabel.text  = family.leader.name.length > 0 ? family.leader.name : @"--";
    }
}
#pragma mark - delegate
#pragma mark - event response
#pragma mark - private method
- (void)initView {
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [self.contentView addSubview:self.logoImageView];
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.patriaImageView];
    [self.contentView addSubview:self.arrowImageView];
}
- (void)initConstrations {
    [self.logoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(50);
        make.centerY.mas_equalTo(self.contentView);
        make.left.mas_equalTo(self.contentView).offset(15);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.logoImageView.mas_right).offset(13);
        make.centerY.mas_equalTo(self.logoImageView);
        make.width.mas_lessThanOrEqualTo(50);
    }];
    
    [self.patriaImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(36);
        make.height.mas_equalTo(15);
        make.left.mas_equalTo(self.titleLabel.mas_right).offset(4);
        make.centerY.mas_equalTo(self.logoImageView);
    }];
    
    [self.arrowImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(7);
        make.height.mas_equalTo(11);
        make.centerY.mas_equalTo(self.logoImageView);
        make.right.mas_equalTo(self.contentView).offset(-15);
    }];
}
#pragma mark - getters and setters
- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor  =  UIColorFromRGB(0x1a1a1a);
        _titleLabel.font = [UIFont systemFontOfSize:15];
    }
    return _titleLabel;
}

- (UIImageView *)logoImageView{
    if (!_logoImageView) {
        _logoImageView = [[UIImageView alloc] init];
        _logoImageView.layer.masksToBounds = YES;
        _logoImageView.layer.cornerRadius = 25;
    }
    return _logoImageView;
}

- (UIImageView *)arrowImageView{
    if (!_arrowImageView) {
        _arrowImageView = [[UIImageView alloc] init];
        _arrowImageView.image = [UIImage imageNamed:@"discover_family_arrow"];
    }
    return _arrowImageView;
}

- (UIImageView *)patriaImageView{
    if (!_patriaImageView) {
        _patriaImageView = [[UIImageView alloc] init];
        _patriaImageView.image = [UIImage imageNamed:@"family_person_patria"];
    }
    return _patriaImageView;
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
