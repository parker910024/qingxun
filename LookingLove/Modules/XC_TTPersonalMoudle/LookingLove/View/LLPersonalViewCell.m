//
//  LLPersonalViewCell.m
//  XC_TTPersonalMoudle
//
//  Created by lee on 2019/7/25.
//  Copyright © 2019 YiZhuan. All rights reserved.
//

#import "LLPersonalViewCell.h"
#import <Masonry/Masonry.h>
#import "XCTheme.h"
#import "XCMacros.h"
#import "UIView+ZJFrame.h"
#import "UIView+XCToast.h"
#import "TTPersonalCellModel.h"

@interface LLPersonalViewCell ()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *textLabel;
@property (nonatomic, strong) UIImageView *iconImageView;

@end

@implementation LLPersonalViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = UIColor.whiteColor;
        [self initViews];
        [self initConstraints];
    }
    return self;
}

#pragma mark -
#pragma mark lifeCycle

- (void)initViews {
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.textLabel];
    [self.contentView addSubview:self.iconImageView];
}

- (void)initConstraints {
    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(18);
        make.centerX.mas_equalTo(self.contentView);
        make.width.height.mas_equalTo(28);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.contentView);
        make.top.mas_equalTo(self.iconImageView.mas_bottom).offset(10);
        make.left.right.mas_equalTo(self.contentView).inset(3);
        make.height.mas_equalTo(13);
    }];
    
    [self.textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.contentView);
        make.left.right.mas_equalTo(self.contentView);
        make.top.mas_equalTo(self.titleLabel.mas_bottom).offset(7);
        make.height.mas_equalTo(12);
    }];
}

#pragma mark -
#pragma mark SystemApi Delegate

#pragma mark -
#pragma mark CustomView Delegate

#pragma mark -
#pragma mark CoreClients

#pragma mark -
#pragma mark Event Response

#pragma mark -
#pragma mark Public Methods

#pragma mark -
#pragma mark Private Methods

#pragma mark -
#pragma mark Getters and Setters
- (void)setModel:(TTPersonalCellModel *)model {
    _model = model;
    
    self.titleLabel.text = model.title;
    self.textLabel.text = model.detail;
    self.iconImageView.image = [UIImage imageNamed:model.imageName];

    if (model.cornerType) {
        [self applyRoundCorners:model.cornerType radius:8];
    } else {
        [self applyRoundCorners:model.cornerType radius:0];
    }
}

- (void)applyRoundCorners:(UIRectCorner)corners radius:(CGFloat)radius
{
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:corners cornerRadii:CGSizeMake(radius, radius)];
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.path = path.CGPath;
    self.layer.mask = maskLayer;
}

- (UIImageView *)iconImageView {
    if (!_iconImageView) {
        _iconImageView = [[UIImageView alloc] init];
    }
    return _iconImageView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel .font = [UIFont systemFontOfSize:13];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel .textColor = [XCTheme getTTMainTextColor];
    }
    return _titleLabel ;
}

- (UILabel *)textLabel {
    if (!_textLabel) {
        _textLabel = [[UILabel alloc] init];
        _textLabel .font = [UIFont systemFontOfSize:12];
        _textLabel.textAlignment = NSTextAlignmentCenter;
        _textLabel .textColor = UIColorFromRGB(0xB3B3B3);
    }
    return _textLabel ;
}
@end
