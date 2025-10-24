//
//  TTDiscoverSquareTableViewCell.m
//  TuTu
//
//  Created by gzlx on 2018/10/29.
//  Copyright © 2018年 YiZhuan. All rights reserved.
//

#import "TTDiscoverSquareTableViewCell.h"
#import "XCTheme.h"
#import <Masonry/Masonry.h>
#import "XCMacros.h"
#import "UIImageView+QiNiu.h"

@interface TTDiscoverSquareTableViewCell ()
/** 标题*/
@property (nonatomic, strong) UILabel * titleLabel;
/** 副标题*/
@property (nonatomic, strong) UILabel * subTileLabel;
/** 图片*/
@property (nonatomic, strong) UIImageView * iconImageView;
/** 箭头*/
@property (nonatomic, strong) UIButton * arrowButton;
/** 箭头*/
@property (nonatomic, strong) UIView * sepView;
@end


@implementation TTDiscoverSquareTableViewCell

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
- (void)configTTDiscoverSquareTableViewCell:(XCFamily *)family{
    if (family) {
        [self.iconImageView qn_setImageImageWithUrl:family.familyIcon placeholderImage:[[XCTheme defaultTheme] default_avatar] type:ImageTypeHomePageItem];
        NSString * familyStr = [NSString stringWithFormat:@"家族ID：%@  成员：%@", family.familyId,family.memberCount];
        self.titleLabel.text = family.familyName;
        self.subTileLabel.text = familyStr;
        self.iconImageView.layer.cornerRadius = 5;
        [self.iconImageView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.width.mas_equalTo(50);
        }];
        
        [self.titleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.iconImageView.mas_top).offset(5);
        }];
    }
}

/** 配置家族 客服 家族指南 家族广场*/
- (void)configDicoverSquareOrFamilyGuide:(NSDictionary *)modelDic{
    if (modelDic) {
        self.iconImageView.image = [UIImage imageNamed:modelDic[@"imageName"]];
        self.titleLabel.text = modelDic[@"title"];
        self.subTileLabel.text = modelDic[@"content"];
        self.iconImageView.layer.cornerRadius = 0;
        [self.iconImageView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.width.mas_equalTo(40);
        }];
        
        [self.titleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.iconImageView.mas_top).offset(2);
        }];
    }
}


#pragma mark - private method
- (void)initView {
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [self.contentView addSubview:self.iconImageView];
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.subTileLabel];
    [self.contentView addSubview:self.arrowButton];
    [self.contentView addSubview:self.sepView];
}
- (void)initConstrations {
    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(40);
        make.centerY.mas_equalTo(self.contentView);
        make.left.mas_equalTo(self.contentView).offset(15);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.iconImageView.mas_right).offset(11);
        make.top.mas_equalTo(self.iconImageView.mas_top).offset(2);
    }];
    
    [self.subTileLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.titleLabel);
        make.top.mas_equalTo(self.titleLabel.mas_bottom).offset(7);
    }];
    
    [self.arrowButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(7);
        make.height.mas_equalTo(11);
        make.centerY.mas_equalTo(self.contentView);
        make.right.mas_equalTo(self.contentView).offset(-15);
    }];
    
    [self.sepView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.iconImageView);
        make.bottom.mas_equalTo(self.contentView);
        make.right.mas_equalTo(self.contentView).offset(-15);
        make.height.mas_equalTo(0.5);
    }];
}
#pragma mark - getters and setters
- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor  = [XCTheme getTTMainTextColor];
        _titleLabel.font = [UIFont systemFontOfSize:15];
    }
    return _titleLabel;
}
- (UILabel *)subTileLabel{
    if (!_subTileLabel) {
        _subTileLabel = [[UILabel alloc] init];
        _subTileLabel.textColor  =  UIColorFromRGB(0x999999);
        _subTileLabel.font = [UIFont systemFontOfSize:12];
    }
    return _subTileLabel;
}

- (UIButton *)arrowButton{
    if (!_arrowButton) {
        _arrowButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_arrowButton setImage:[UIImage imageNamed:@"discover_family_arrow"] forState:UIControlStateNormal];
    }
    return _arrowButton;
}

- (UIView *)sepView{
    if (!_sepView) {
        _sepView = [[UIView alloc] init];
        _sepView.backgroundColor = UIColorFromRGB(0xf5f5f5);
    }
    return _sepView;
}

- (UIImageView *)iconImageView{
    if (!_iconImageView) {
        _iconImageView = [[UIImageView alloc] init];
        _iconImageView.layer.masksToBounds = YES;
    }
    return _iconImageView;
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
