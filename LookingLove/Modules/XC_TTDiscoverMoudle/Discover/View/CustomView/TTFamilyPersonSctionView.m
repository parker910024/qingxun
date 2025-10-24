//
//  TTFamilyPersonSctionView.m
//  TuTu
//
//  Created by gzlx on 2018/11/2.
//  Copyright © 2018年 YiZhuan. All rights reserved.
//

#import "TTFamilyPersonSctionView.h"
#import "XCTheme.h"
#import <Masonry/Masonry.h>
#import <YYText/YYText.h>
#import "TTFamilyAttributedString.h"

@interface TTFamilyPersonSctionView ()
/** 分割线*/
@property (nonatomic, strong) UIView * sepView;
/** 底部的分割线*/
@property (nonatomic, strong) UIView * bottomSepView;

@property(nonatomic, strong ) UIButton * actionButton;

@end

@implementation TTFamilyPersonSctionView
#pragma mark - life cycle
- (id)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self initView];
        [self initConstrations];
    }
    return self;
}

#pragma mark - public methods
- (void)actionButtonAction:(UIButton *)sender{
    if (self.delegate && [self.delegate respondsToSelector:@selector(touchViewPushMoreOrCreateGroupAction:)]) {
        [self.delegate touchViewPushMoreOrCreateGroupAction:self.type];
    }
}
#pragma mark - delegate
#pragma mark - event response
#pragma mark - private method
- (void)initView {
    self.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.sepView];
    [self addSubview:self.titleLabel];
    [self addSubview:self.subTitleLabel];
    [self addSubview:self.bottomSepView];
    [self addSubview:self.actionButton];
}
- (void)initConstrations {
    [self.sepView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.mas_equalTo(self);
        make.height.mas_equalTo(10);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self).offset(15);
        make.top.mas_equalTo(self).offset(25);
    }];
    
    
    [self.subTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self).offset(-15);
        make.centerY.mas_equalTo(self.titleLabel);
    }];
    
    
    [self.bottomSepView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self).offset(15);
        make.right.mas_equalTo(self).offset(-15);
        make.bottom.mas_equalTo(self);
        make.height.mas_equalTo(0.5);
    }];
    
    [self.actionButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self);
        make.top.bottom.mas_equalTo(self);
        make.width.mas_equalTo(300);
    }];
}
#pragma mark - getters and setters
- (void)setType:(TTFamilyPersonSctionViewType)type{
    _type = type;
    if (_type== TTFamilyPersonSctionView_hidden) {
               self.subTitleLabel.hidden = YES;
    }else{
        self.subTitleLabel.hidden = NO;
        self.subTitleLabel.attributedText = [TTFamilyAttributedString createFamilyPersonSectionViewAttributstring:_type];
    }
}

- (UIView *)sepView{
    if (!_sepView) {
        _sepView = [[UIView alloc] init];
        _sepView.backgroundColor = [XCTheme getTTSimpleGrayColor];
    }
    return _sepView;
}

- (UIView *)bottomSepView{
    if (!_bottomSepView) {
        _bottomSepView = [[UIView alloc] init];
        _bottomSepView.backgroundColor = [XCTheme getTTSimpleGrayColor];
    }
    return _bottomSepView;
}

- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor  =  UIColorFromRGB(0x333333);
        _titleLabel.font = [UIFont systemFontOfSize:15];
    }
    return _titleLabel;
}

- (YYLabel *)subTitleLabel{
    if (!_subTitleLabel) {
        _subTitleLabel = [[YYLabel alloc] init];
    }
    return _subTitleLabel;
}

- (UIButton *)actionButton{
    if (!_actionButton) {
        _actionButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_actionButton addTarget:self action:@selector(actionButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _actionButton;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
