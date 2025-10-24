//
//  TTFamilyManagerTableViewCell.m
//  TuTu
//
//  Created by gzlx on 2018/11/3.
//  Copyright © 2018年 YiZhuan. All rights reserved.
//

#import "TTFamilyManagerTableViewCell.h"
#import <Masonry/Masonry.h>
#import "XCTheme.h"

@interface TTFamilyManagerTableViewCell ()
/** 背景*/
@property (nonatomic, strong) UIView * backView;
/** 图片*/
@property (nonatomic, strong) UIImageView * logoImageView;
/** 名字*/
@property (nonatomic, strong) UILabel * titleLabel;
/** 箭头*/
@property (nonatomic, strong) UIImageView * arrowImageView;
@end

@implementation TTFamilyManagerTableViewCell
#pragma Mark- life cycle
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initView];
        [self initContrations];
    }
    return self;
}

#pragma mark - public method
- (void)configFamilyManagerTableViewWith:(NSDictionary *)dic{
    self.logoImageView.image = [UIImage imageNamed:dic[@"imageName"]];
    self.titleLabel.text = dic[@"titile"];
}

#pragma mark - private method
- (void)initView{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.backgroundColor = [XCTheme getTTSimpleGrayColor];
     [self.contentView addSubview:self.backView];
    [self.backView addSubview:self.logoImageView];
    [self.backView addSubview:self.titleLabel];
    [self.backView addSubview:self.arrowImageView];
}

- (void)initContrations{
    [self.backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentView).offset(10);
        make.left.mas_equalTo(self.contentView).offset(15);
        make.right.mas_equalTo(self.contentView).offset(-15);
        make.height.mas_equalTo(60);
    }];
    
    [self.logoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.backView).offset(10);
        make.centerY.mas_equalTo(self.backView);
        make.width.height.mas_equalTo(30);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.logoImageView);
        make.left.mas_equalTo(self.logoImageView.mas_right).offset(10);
    }];
    
    [self.arrowImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(7);
        make.height.mas_equalTo(11);
        make.centerY.mas_equalTo(self.backView);
        make.right.mas_equalTo(self.backView).offset(-11);
    }];
}

#pragma mark - setters and getters
- (void)setTitleString:(NSString *)titleString{
    self.titleLabel.text = titleString;
}

- (void)setImageNameString:(NSString *)imageNameString{
    self.logoImageView.image = [UIImage imageNamed:imageNameString];
}

- (UIView *)backView{
    if (!_backView) {
        _backView = [[UIView alloc] init];
        _backView.backgroundColor = [UIColor whiteColor];
        _backView.layer.masksToBounds = YES;
        _backView.layer.cornerRadius = 5;
    }
    return _backView;
}

- (UIImageView *)logoImageView{
    if (!_logoImageView) {
        _logoImageView = [[UIImageView alloc] init];
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

- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor  =  [XCTheme getTTMainTextColor];
        _titleLabel.font = [UIFont systemFontOfSize:15];
    }
    return _titleLabel;
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
