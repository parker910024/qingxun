//
//  TTFunctionMenuMoreStypeCell.m
//  TuTu
//
//  Created by KevinWang on 2018/11/7.
//  Copyright © 2018年 YiZhuan. All rights reserved.
//

#import "TTFunctionMenuMoreStypeCell.h"
#import "TTFunctionMenuItem.h"
#import <Masonry.h>


@interface TTFunctionMenuMoreStypeCell()

@property (nonatomic, strong) UILabel  *titleLabel;
@property (nonatomic, strong) UIImageView  *backgroundIcon;

@end

@implementation TTFunctionMenuMoreStypeCell

#pragma mark - Life Style

- (instancetype)initWithFrame:(CGRect)frame{
    if (self=[super initWithFrame:frame]) {
        [self setupSubviews];
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    [self setupSubviewsConstraints];
}

#pragma mark - puble method
- (void)configCell:(TTFunctionMenuItem *)item{
    
    self.backgroundIcon.image = [UIImage imageNamed:item.imageName];
    self.titleLabel.text = item.title;
}

#pragma mark - Private
- (void)setupSubviews{
    [self.contentView addSubview:self.backgroundIcon];
    [self.contentView addSubview:self.titleLabel];
}
- (void)setupSubviewsConstraints{
    [self.backgroundIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(@36);
        make.top.equalTo(self.contentView).offset(24);
        make.centerX.equalTo(self.contentView);
    }];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.backgroundIcon.mas_bottom).offset(8);
        make.centerX.equalTo(self.backgroundIcon);
    }];
}

#pragma mark - Getter
- (UIImageView *)backgroundIcon{
    if (!_backgroundIcon) {
        _backgroundIcon = [[UIImageView alloc] init];
    }
    return _backgroundIcon;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = [[UIColor whiteColor] colorWithAlphaComponent:0.5];
        _titleLabel.font = [UIFont systemFontOfSize:10];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLabel;
}
@end
