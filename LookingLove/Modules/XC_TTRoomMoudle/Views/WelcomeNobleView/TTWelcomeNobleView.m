//
//  TTWelcomeNobleView.m
//  TuTu
//
//  Created by KevinWang on 2018/11/26.
//  Copyright © 2018年 YiZhuan. All rights reserved.
//

#import "TTWelcomeNobleView.h"
#import <Masonry.h>

@interface TTWelcomeNobleView()

@property (nonatomic, strong) UIView *contentView;

@end

@implementation TTWelcomeNobleView


#pragma mark - Life Style
- (instancetype)initWithFrame:(CGRect)frame{
    if (self=[super initWithFrame:frame]) {
        [self setupSubviews];
        [self setupSubviewsConstraints];
    }
    return self;
}


#pragma mark - puble method
- (void)setTitle:(NSAttributedString *)title{
    _title = title;
    self.contentLabel.attributedText = title;
}

#pragma mark - Private
- (void)setupSubviews{
    
    [self addSubview:self.welcomeBgView];
    [self addSubview:self.badgeImageView];
    [self addSubview:self.contentView];
    [self.contentView addSubview:self.contentLabel];
    
    
    
}
- (void)setupSubviewsConstraints{
    
    [self.welcomeBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@25);
        make.left.right.centerY.equalTo(self);
    }];
    
    [self.badgeImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(@40);
        make.centerY.equalTo(self);
        make.left.equalTo(self.welcomeBgView).offset(10);
    }];
    
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.badgeImageView.mas_right).offset(3);
        make.top.bottom.equalTo(self);
        make.width.equalTo(@190);
    }];
    
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView);
        make.centerY.equalTo(self);
    }];
}

#pragma mark - Getter

- (UIImageView *)welcomeBgView{
    if (!_welcomeBgView) {
        _welcomeBgView = [[UIImageView alloc] init];
    }
    return _welcomeBgView;
}
- (UIImageView *)badgeImageView{
    if (!_badgeImageView) {
        _badgeImageView = [[UIImageView alloc] init];
    }
    return _badgeImageView;
}

- (UIView *)contentView{
    if (!_contentView) {
        _contentView = [[UIView alloc] init];
        _contentView.backgroundColor = [UIColor clearColor];
        _contentView.layer.masksToBounds = YES;
    }
    return _contentView;
}

- (UILabel *)contentLabel{
    if (!_contentLabel) {
        _contentLabel = [[UILabel alloc] init];
        _contentLabel.textColor = [UIColor whiteColor];
    }
    return _contentLabel;
}

@end
