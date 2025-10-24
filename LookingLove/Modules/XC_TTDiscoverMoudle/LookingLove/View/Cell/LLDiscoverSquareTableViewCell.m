//
//  LLDiscoverSquareTableViewCell.m
//  XC_TTDiscoverMoudle
//
//  Created by fengshuo on 2019/7/26.
//  Copyright © 2019 fengshuo. All rights reserved.
//

#import "LLDiscoverSquareTableViewCell.h"
#import "XCTheme.h"
#import <Masonry/Masonry.h>
#import "XCMacros.h"
#import "UIImageView+QiNiu.h"

@interface LLDiscoverSquareTableViewCell ()
/** 容器*/
@property (nonatomic,strong) UIImageView *containerView;
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


@implementation LLDiscoverSquareTableViewCell

#pragma mark - life cycle
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initView];
        [self initConstrations];
    }
    return self;
}

#pragma mark - pulic method
/** 配置家族 客服 家族指南 家族广场*/
- (void)configDicoverSquareOrFamilyGuide:(NSDictionary *)modelDic{
    if (modelDic) {
        self.iconImageView.image = [UIImage imageNamed:modelDic[@"imageName"]];
        self.titleLabel.text = modelDic[@"title"];
        self.subTileLabel.text = modelDic[@"content"];
        self.iconImageView.layer.cornerRadius = 0;
    }
}
- (void)updateCellContainerViewLayerWithTotal:(NSInteger)total row:(NSInteger)row {
    if (total == 1) {
        self.containerView.layer.cornerRadius = 8;
    }else if(total == 2) {
        if (row == 0) {
            UIBezierPath * path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, KScreenWidth - 40, 75) byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(8, 8)];
            CAShapeLayer * layer = [[CAShapeLayer alloc] init];
            layer.frame = CGRectMake(0, 0, KScreenWidth - 40, 75);
            layer.path = path.CGPath;
            self.containerView.layer.mask  = layer;
            
        }else if (row ==1) {
            UIBezierPath * path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, KScreenWidth - 40, 75) byRoundingCorners:UIRectCornerBottomLeft | UIRectCornerBottomRight cornerRadii:CGSizeMake(8, 8)];
            CAShapeLayer * layer = [[CAShapeLayer alloc] init];
            layer.frame = CGRectMake(0, 0, KScreenWidth - 40, 75);
            layer.path = path.CGPath;
            self.containerView.layer.mask  = layer;
        }
    }
}

#pragma mark - private method
- (void)initView {
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:self.containerView];
    [self.containerView addSubview:self.iconImageView];
    [self.containerView addSubview:self.titleLabel];
    [self.containerView addSubview:self.subTileLabel];
    [self.containerView addSubview:self.arrowButton];
    [self.containerView addSubview:self.sepView];
}
- (void)initConstrations {
    [self.containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView).offset(20);
        make.right.mas_equalTo(self.contentView).offset(-20);
        make.top.bottom.mas_equalTo(self.contentView);
    }];
    
    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(28);
        make.centerY.mas_equalTo(self.containerView);
        make.left.mas_equalTo(self.containerView).offset(19);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.iconImageView.mas_right).offset(12);
        make.top.mas_equalTo(self.iconImageView.mas_top).offset(-4);
    }];
    
    [self.subTileLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.titleLabel);
        make.right.mas_equalTo(self.containerView).offset(-10);
        make.top.mas_equalTo(self.titleLabel.mas_bottom).offset(10);
    }];
    
    [self.arrowButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(7);
        make.height.mas_equalTo(11);
        make.centerY.mas_equalTo(self.containerView);
        make.right.mas_equalTo(self.containerView).offset(-15);
    }];
    
    [self.sepView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.iconImageView);
        make.bottom.mas_equalTo(self.containerView);
        make.right.mas_equalTo(self.containerView).offset(-15);
        make.height.mas_equalTo(0.5);
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

- (UIView *)sepView {
    if (!_sepView) {
        _sepView = [[UIView alloc] init];
        _sepView.backgroundColor = UIColorFromRGB(0xf5f5f5);
    }
    return _sepView;
}

- (UIImageView *)iconImageView {
    if (!_iconImageView) {
        _iconImageView = [[UIImageView alloc] init];
        _iconImageView.layer.masksToBounds = YES;
    }
    return _iconImageView;
}
- (UIImageView *)containerView {
    if (!_containerView) {
        _containerView = [[UIImageView alloc] init];
        _containerView.backgroundColor = [UIColor whiteColor];
    }
    return _containerView;
}

@end
