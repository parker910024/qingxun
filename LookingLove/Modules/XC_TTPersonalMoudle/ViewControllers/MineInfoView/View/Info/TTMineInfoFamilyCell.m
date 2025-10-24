//
//  TTMineInfoFamilyCell.m
//  TuTu
//
//  Created by lee on 2018/10/31.
//  Copyright © 2018 YiZhuan. All rights reserved.
//

#import "TTMineInfoFamilyCell.h"

//model
#import "XCFamily.h"
//c
#import "UIImageView+QiNiu.h"
//t
#import "XCTheme.h"
#import <Masonry/Masonry.h>

@interface TTMineInfoFamilyCell()

@property (nonatomic, strong) UIView  *headView;//
@property (nonatomic, strong) UILabel  *titleLabel;//
@property (nonatomic, strong) UIView  *lineView;//

@property (nonatomic, strong) UIView  *dataContiantView;//
@property (nonatomic, strong) UILabel  *noFamilyLabel;//
@property (nonatomic, strong) UIImageView  *familyLogoImageView;//
@property (nonatomic, strong) UIImageView  *arrowImageView;//
@property (nonatomic, strong) UILabel  *familyNameLabel;//家族名称
@property (nonatomic, strong) UILabel  *familyIDLabel;//家族id

@end

@implementation TTMineInfoFamilyCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initSubViews];
        self.accessoryType = UITableViewCellAccessoryNone;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

- (void)initSubViews {
    [self.contentView addSubview:self.headView];
    [self.contentView addSubview:self.dataContiantView];
    [self.contentView addSubview:self.arrowImageView];
    [self.headView addSubview:self.titleLabel];
    [self.headView addSubview:self.lineView];
    
    [self.dataContiantView addSubview:self.familyLogoImageView];
    [self.dataContiantView addSubview:self.familyNameLabel];
    [self.dataContiantView addSubview:self.familyIDLabel];
    [self.dataContiantView addSubview:self.noFamilyLabel];
    
    [self makeConstriants];
}

- (void)makeConstriants {
    [self.headView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.mas_equalTo(self.contentView);
        make.height.mas_equalTo(42);
    }];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.headView).offset(15);
        make.centerY.mas_equalTo(self.headView);
    }];
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.headView).offset(15);
        make.right.mas_equalTo(self.headView).offset(-15);
        make.height.mas_equalTo(0.5);
        make.bottom.mas_equalTo(self.headView);
    }];
    
    [self.dataContiantView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(self.contentView);
        make.top.mas_equalTo(self.headView.mas_bottom);
    }];
    
    [self.noFamilyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.dataContiantView);
    }];
    
    [self.familyLogoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.dataContiantView);
        make.left.mas_equalTo(self.dataContiantView).offset(15);
        make.height.width.mas_equalTo(50);
    }];
    [self.familyNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.familyLogoImageView.mas_right).offset(10);
        make.top.mas_equalTo(self.familyLogoImageView).offset(9);
    }];
    [self.familyIDLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.familyNameLabel);
        make.top.mas_equalTo(self.familyNameLabel.mas_bottom).offset(9);
    }];
    
    [self.arrowImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.familyLogoImageView);
        make.right.mas_equalTo(-15);
    }];
}

#pragma mark - Getter && Setter

- (void)setFamily:(XCFamily *)family {
    _family = family;
    if (!_family) {
        self.noFamilyLabel.hidden = NO;
        return;
    }
    self.noFamilyLabel.hidden = YES;
    [self.familyLogoImageView qn_setImageImageWithUrl:_family.familyIcon placeholderImage:[XCTheme defaultTheme].default_avatar type:ImageTypeUserIcon];
    self.familyIDLabel.text = [NSString stringWithFormat:@"家族ID:%@  成员:%@",self.family.familyId, self.family.memberCount];
    self.familyNameLabel.text = _family.familyName;
}

- (UIView *)headView {
    if (!_headView) {
        _headView = [[UIView alloc] init];
    }
    return _headView;
}

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = [UIColor whiteColor];
    }
    return _lineView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont systemFontOfSize:15];
        _titleLabel.textColor = [XCTheme getMSMainTextColor];
        _titleLabel.text = @"家族";
    }
    return _titleLabel;
}

- (UIView *)dataContiantView {
    if (!_dataContiantView) {
        _dataContiantView = [[UIView alloc] init];
    }
    return _dataContiantView;
}

- (UILabel *)noFamilyLabel {
    if (!_noFamilyLabel) {
        _noFamilyLabel = [[UILabel alloc] init];
        _noFamilyLabel.text = @"还未加入任何家族哦~";
        _noFamilyLabel.textAlignment = NSTextAlignmentCenter;
        _noFamilyLabel.backgroundColor = [UIColor whiteColor];
        _noFamilyLabel.textColor = [XCTheme getMSThirdTextColor];
        _noFamilyLabel.font = [UIFont systemFontOfSize:14];
    }
    return _noFamilyLabel;
}

- (UIImageView *)arrowImageView {
    if (!_arrowImageView) {
        _arrowImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"person_arrow"]];
    }
    return _arrowImageView;
}

- (UIImageView *)familyLogoImageView {
    if (!_familyLogoImageView) {
        _familyLogoImageView = [[UIImageView alloc] init];
        _familyLogoImageView.layer.masksToBounds = YES;
        _familyLogoImageView.layer.cornerRadius = 5;
    }
    return _familyLogoImageView;
}

- (UILabel *)familyNameLabel {
    if (!_familyNameLabel) {
        _familyNameLabel = [[UILabel alloc] init];
        _familyNameLabel.textColor = [XCTheme getTTMainTextColor];
        _familyNameLabel.font = [UIFont systemFontOfSize:16];
    }
    return _familyNameLabel;
}

- (UILabel *)familyIDLabel {
    if (!_familyIDLabel) {
        _familyIDLabel = [[UILabel alloc] init];
        _familyIDLabel.textColor = [XCTheme getTTDeepGrayTextColor];
        _familyIDLabel.font = [UIFont systemFontOfSize:14];
    }
    return _familyIDLabel;
}


@end
