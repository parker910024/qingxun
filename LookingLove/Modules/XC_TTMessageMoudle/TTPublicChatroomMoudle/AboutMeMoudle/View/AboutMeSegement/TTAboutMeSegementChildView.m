//
//  TTAboutMeSegementChildView.m
//  TuTu
//
//  Created by 卫明 on 2018/11/4.
//  Copyright © 2018 YiZhuan. All rights reserved.
//

#import "TTAboutMeSegementChildView.h"

//theme
#import "XCTheme.h"
//tool
#import <Masonry/Masonry.h>

@interface TTAboutMeSegementChildView ()

@property (strong, nonatomic) UILabel *titleLabel;

@end

@implementation TTAboutMeSegementChildView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initView];
        [self initConstrations];
    }
    return self;
}

- (void)initView {
    self.backgroundColor = [UIColor clearColor];
    [self addSubview:self.titleLabel];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(onSegementTap:)];
    [self addGestureRecognizer:tap];
}

- (void)initConstrations {
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.mas_leading);
        make.trailing.mas_equalTo(self.mas_trailing);
        make.width.height.mas_equalTo(self);
        make.center.mas_equalTo(self);
    }];
}

- (void)onSegementTap:(UITapGestureRecognizer *)ges {
    if ([self.delegate respondsToSelector:@selector(onAboutMeSegementChildView:wasClickWthType:)]) {
        [self.delegate onAboutMeSegementChildView:self wasClickWthType:self.type];
    }
}

#pragma mark - setter & getter

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc]init];
        _titleLabel.textColor = UIColorFromRGB(0x999999);
        _titleLabel.font = [UIFont systemFontOfSize:14.f];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLabel;
}

- (void)setTitle:(NSString *)title {
    _title = title;
    [self.titleLabel setText:title];
}

- (void)setTitleColor:(UIColor *)titleColor {
    _titleColor = titleColor;
    self.titleLabel.textColor = titleColor;
}

@end
