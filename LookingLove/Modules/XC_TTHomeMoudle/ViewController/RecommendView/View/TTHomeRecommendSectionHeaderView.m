//
//  TTHomeRecommendTableHeaderView.m
//  TuTu
//
//  Created by lvjunhang on 2018/10/30.
//  Copyright © 2018年 YiZhuan. All rights reserved.
//

#import "TTHomeRecommendSectionHeaderView.h"

#import <Masonry/Masonry.h>
#import "XCTheme.h"

@interface TTHomeRecommendSectionHeaderView ()
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *subTitleLabel;
@property (nonatomic, strong) UIButton *actionButton;
@property (nonatomic, strong) UIView *separateLineView;
@end

@implementation TTHomeRecommendSectionHeaderView

#pragma mark - life cycle
- (instancetype)initWithReuseIdentifier:(nullable NSString *)reuseIdentifier {
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self) {
        [self initView];
        [self initConstraints];
    }
    return self;
}

#pragma mark - public method
#pragma mark - system protocols
#pragma mark - custom protocols
#pragma mark - core protocols
#pragma mark - event response
- (void)actionButtonTapped:(UIButton *)sender {
    !self.clickHandle ?: self.clickHandle();
}

#pragma mark - private method
- (void)initView {
    self.clipsToBounds = YES;
    self.contentView.backgroundColor = UIColor.whiteColor;

    /// 此句解决约束报错：width == 0 的问题
    self.translatesAutoresizingMaskIntoConstraints = NO;

    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.subTitleLabel];
    [self.contentView addSubview:self.actionButton];
    [self.contentView addSubview:self.separateLineView];
}

- (void)initConstraints {
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(0);
        make.left.mas_equalTo(15);
    }];
    
    [self.separateLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.titleLabel.mas_right).offset(10);
        make.centerY.mas_equalTo(0);
        make.width.mas_equalTo(1);
        make.height.mas_equalTo(12);
    }];
    
    [self.subTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.separateLineView.mas_right).offset(10);
        make.centerY.mas_equalTo(0);
        make.right.mas_lessThanOrEqualTo(self.actionButton.mas_left).offset(-12);
    }];
    
    [self.actionButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-8);
        make.centerY.mas_equalTo(0);
        make.width.mas_equalTo(60);
        make.height.mas_equalTo(30);
    }];
}

#pragma mark - getters and setters
- (void)setConfig:(TTHomeRecommendSectionHeaderViewConfig *)config {
    _config = config;
    
    self.titleLabel.text = config.title;
    
    self.subTitleLabel.text = config.subtitle;
    self.separateLineView.hidden = config.subtitle.length == 0;
    
    self.actionButton.hidden = config.actionTitle.length == 0;
    [self.actionButton setTitle:config.actionTitle forState:UIControlStateNormal];
    [self.actionButton setImage:[UIImage imageNamed:config.actionImage] forState:UIControlStateNormal];
}

- (UILabel *)titleLabel {
    if (_titleLabel == nil) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont boldSystemFontOfSize:20];
        _titleLabel.textColor = [XCTheme getMSMainTextColor];
    }
    return _titleLabel;
}

- (UILabel *)subTitleLabel {
    if (_subTitleLabel == nil) {
        _subTitleLabel = [[UILabel alloc] init];
        _subTitleLabel.font = [UIFont systemFontOfSize:13];
        _subTitleLabel.textColor = [XCTheme getMSThirdTextColor];
    }
    return _subTitleLabel;
}

- (UIButton *)actionButton {
    if (_actionButton == nil) {
        _actionButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _actionButton.titleLabel.font = [UIFont systemFontOfSize:13];
        [_actionButton setTitleColor:[XCTheme getMSThirdTextColor] forState:UIControlStateNormal];
        [_actionButton setImage:[UIImage imageNamed:@"home_arrow_more"] forState:UIControlStateNormal];
        [_actionButton addTarget:self action:@selector(actionButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
        
        _actionButton.transform = CGAffineTransformMakeScale(-1.0, 1.0);
        _actionButton.titleLabel.transform = CGAffineTransformMakeScale(-1.0, 1.0);
        _actionButton.imageView.transform = CGAffineTransformMakeScale(-1.0, 1.0);
        _actionButton.imageEdgeInsets = UIEdgeInsetsMake(0, -5, 0, 0);
    }
    return _actionButton;
}

- (UIView *)separateLineView {
    if (_separateLineView == nil) {
        _separateLineView = [[UIView alloc] init];
        _separateLineView.backgroundColor = [XCTheme getLineDefaultGrayColor];
    }
    return _separateLineView;
}

@end

@implementation TTHomeRecommendSectionHeaderViewConfig

@end
