//
//  TTRoomeMessageNavView.m
//  TTPlay
//
//  Created by Jenkins on 2019/3/8.
//  Copyright © 2019年 YiZhuan. All rights reserved.
//

#import "TTRoomeMessageNavView.h"
#import <Masonry/Masonry.h>
#import "XCTheme.h"
#import "XCMacros.h"

@interface TTRoomeMessageNavView ()
/** 返回按钮*/
@property (nonatomic, strong) UIButton * backButton;

/** 分割线*/
@property (nonatomic, strong) UIView * lineView;
@end

@implementation TTRoomeMessageNavView

- (id)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self initView];
        [self initContrations];
    }
    return self;
}

#pragma mark - response
- (void)backButtonAction:(UIButton *)sender{
    if (self.delegate && [self.delegate respondsToSelector:@selector(backButtonClick:)]) {
        [self.delegate backButtonClick:sender];
    }
}

#pragma mark - private method
- (void)initView{
    self.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.backButton];
    [self addSubview:self.titleLabel];
    [self addSubview:self.lineView];
}

- (void)initContrations{
    [self.backButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self);
        make.left.mas_equalTo(self).offset(15);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.centerY.mas_equalTo(self);
        make.width.mas_greaterThanOrEqualTo(KScreenWidth - 100);
    }];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(self);
        make.height.mas_equalTo(0.5);
    }];
}

#pragma mark - setters and getters

- (UIView *)lineView{
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = [XCTheme getMSSimpleGrayColor];
    }
    return _lineView;
}

- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor  =  UIColorFromRGB(0x333333);
        _titleLabel.font = [UIFont systemFontOfSize:16];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.backgroundColor = [UIColor whiteColor];
    }
    return _titleLabel;
}

- (UIButton *)backButton{
    if (!_backButton) {
        _backButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_backButton setImage:[UIImage imageNamed:@"nav_bar_back"] forState:UIControlStateNormal];
        [_backButton setImage:[UIImage imageNamed:@"nav_bar_back"] forState:UIControlStateSelected];
        [_backButton addTarget:self action:@selector(backButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _backButton;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
