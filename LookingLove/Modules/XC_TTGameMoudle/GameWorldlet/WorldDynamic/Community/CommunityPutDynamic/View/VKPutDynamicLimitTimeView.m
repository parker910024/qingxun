//
//  VKPutDynamicLimitTimeView.m
//  UKiss
//
//  Created by apple on 2019/2/21.
//  Copyright © 2019 yizhuan. All rights reserved.
//

#import "VKPutDynamicLimitTimeView.h"
#import "UIView+NTES.h"
#import "XCMacros.h"
#import "XCTheme.h"

@interface VKPutDynamicLimitTimeView ()

///内容view
@property (nonatomic, strong) UIView *contentBgView;
///勾搭方式、发红包
@property (nonatomic, strong) UIButton *titleBtn;

@end

@implementation VKPutDynamicLimitTimeView

#pragma mark - life cycle

- (instancetype)initWithFrame:(CGRect)frame type:(VKPutDynamicLimitTimeType)type {
    if (self = [super initWithFrame:frame]) {
        self.type = type;
        [self initView];
        [self initConstrations];
    }
    return self;
}

#pragma mark - public methods

#pragma mark - [系统控件的Protocol]

#pragma mark - [自定义控件的Protocol]

#pragma mark - [core相关的Protocol] 

#pragma mark - event response

- (void)tapAction:(UITapGestureRecognizer *)tap {
    if (self.delegate && [self.delegate respondsToSelector:@selector(clickLimitTimeWithLimitTimeType:)]) {
        [self.delegate clickLimitTimeWithLimitTimeType:self.type];
    }
}

#pragma mark - private method

- (void)initView {
    [self addSubview:self.contentBgView];
    [self.contentBgView addSubview:self.titleBtn];
}

- (void)initConstrations {
    self.titleBtn.left = 10;
    self.titleBtn.centerY = self.contentBgView.height/2.0;
    
}

#pragma mark - getters and setters

- (void)setDetailsStr:(NSString *)detailsStr {
    _detailsStr = detailsStr;
    
}

- (void)setImgName:(NSString *)imgName {
    _imgName = imgName;
    [self.titleBtn setImage:[UIImage imageNamed:imgName] forState:UIControlStateNormal];
}

- (UIView *)contentBgView {
    if (!_contentBgView) {
        _contentBgView = [[UIView alloc]initWithFrame:CGRectMake(15, 0, KScreenWidth - 30, 68)];
        _contentBgView.backgroundColor = UIColorRGBAlpha(0xA49EFE, 0.2);
        _contentBgView.layer.cornerRadius = 5;
        _contentBgView.layer.masksToBounds = YES;
        _contentBgView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction:)];
        [_contentBgView addGestureRecognizer:tap];
    }
    return _contentBgView;
}

- (UIButton *)titleBtn {
    if (!_titleBtn) {
        _titleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _titleBtn.userInteractionEnabled = NO;
        [_titleBtn setTitleColor:UIColorFromRGB(0xC1BEE3) forState:UIControlStateNormal];
        _titleBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        _titleBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 15, 0, 0);
        NSString *title = self.type == VKPutDynamicLimitTimeTypeSeduce ? @"勾搭方式" :@"发红包";
        NSString *imgName = self.type == VKPutDynamicLimitTimeTypeSeduce ? @"community_time_Text" :@"community_time_red";
        [_titleBtn setImage:[UIImage imageNamed:imgName] forState:UIControlStateNormal];
        [_titleBtn setTitle:title forState:UIControlStateNormal];
        [_titleBtn sizeToFit];
        _titleBtn.width += 15;
    }
    return _titleBtn;
}

@end
