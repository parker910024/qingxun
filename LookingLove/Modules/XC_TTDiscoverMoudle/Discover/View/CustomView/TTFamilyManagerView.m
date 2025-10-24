//
//  TTFamilyManagerView.m
//  TuTu
//
//  Created by gzlx on 2018/11/2.
//  Copyright © 2018年 YiZhuan. All rights reserved.
//

#import "TTFamilyManagerView.h"
#import "XCTheme.h"
#import <Masonry/Masonry.h>

@interface TTFamilyManagerView ()
/** 管理家族*/
@property (nonatomic, strong) UILabel * titleLabel;
/** 管理家族的图片*/
@property (nonatomic, strong) UIImageView * iconImageView;
@end

@implementation TTFamilyManagerView
#pragma mark - life cycle
- (id)initWithFrame:(CGRect)frame{
    if (self =[super initWithFrame:frame]) {
        [self initView];
        [self initConstrations];
    }
    return self;
}

#pragma mark - private method
- (void)initView {
    [self addSubview:self.iconImageView];
    [self addSubview:self.titleLabel];
    self.backgroundColor = UIColorRGBAlpha(0xffffff, 0.2);
    self.layer.masksToBounds= YES;
    self.layer.cornerRadius = 24/2;
}
- (void)initConstrations {
    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(11);
        make.centerY.mas_equalTo(self);
        make.left.mas_equalTo(self).offset(8);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.iconImageView.mas_right).offset(3);
        make.centerY.mas_equalTo(self.iconImageView);
    }];
}
#pragma mark - getters and setters
- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor  =  UIColorFromRGB(0xffffff);
        _titleLabel.font = [UIFont systemFontOfSize:11];
        _titleLabel.text = @"管理家族";
    }
    return _titleLabel;
}

- (UIImageView *)iconImageView{
    if (!_iconImageView) {
        _iconImageView = [[UIImageView alloc] init];
        _iconImageView.image = [UIImage imageNamed:@"family_person_manager"];
    }
    return _iconImageView;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
