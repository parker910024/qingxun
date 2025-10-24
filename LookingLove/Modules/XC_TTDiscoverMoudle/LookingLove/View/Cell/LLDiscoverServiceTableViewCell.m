//
//  LLDiscoverServiceTableViewCell.m
//  XC_TTDiscoverMoudle
//
//  Created by fengshuo on 2019/7/26.
//  Copyright © 2019 fengshuo. All rights reserved.
//

#import "LLDiscoverServiceTableViewCell.h"
#import "XCTheme.h"
#import <Masonry/Masonry.h>

@interface LLDiscoverServiceTableViewCell ()
/** 标题*/
@property (nonatomic, strong) UILabel * titleLabel;
/** 副标题*/
@property (nonatomic, strong) UILabel * subTileLabel;
/** 图片*/
@property (nonatomic, strong) UIImageView * iconImageView;
/** 箭头*/
@property (nonatomic, strong) UIButton * arrowButton;
/** 箭头*/
@end

@implementation LLDiscoverServiceTableViewCell

#pragma mark - life cycle
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initView];
        [self initConstrations];
    }
    return self;
}
#pragma mark - public method
/**客服 家族指南*/
- (void)configDicoverSquareOrFamilyGuide:(NSDictionary *)modelDic{
    if (modelDic) {
        self.iconImageView.image = [UIImage imageNamed:modelDic[@"imageName"]];
        self.titleLabel.text = modelDic[@"title"];
        self.subTileLabel.text = modelDic[@"content"];
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
        make.width.height.mas_equalTo(28);
        make.centerY.mas_equalTo(self.contentView);
        make.left.mas_equalTo(self.contentView).offset(20);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.iconImageView.mas_right).offset(9);
        make.centerY.mas_equalTo(self.iconImageView);
    }];
    
    [self.subTileLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.arrowButton.mas_left).offset(-9);
        make.centerY.mas_equalTo(self.titleLabel);
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
        _titleLabel.font = [UIFont systemFontOfSize:15];
    }
    return _titleLabel;
}
- (UILabel *)subTileLabel {
    if (!_subTileLabel) {
        _subTileLabel = [[UILabel alloc] init];
        _subTileLabel.textColor  =  UIColorFromRGB(0x999999);
        _subTileLabel.font = [UIFont systemFontOfSize:12];
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
    }
    return _iconImageView;
}

@end
