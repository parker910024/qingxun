//
//  TTLittleWorldSearchView.m
//  XC_TTMessageMoudle
//
//  Created by fengshuo on 2019/6/28.
//  Copyright © 2019 WJHD. All rights reserved.
//

#import "TTLittleWorldSearchView.h"
#import "XCTheme.h"
#import <Masonry/Masonry.h>

@interface TTLittleWorldSearchView ()

/** 背景的view*/
@property (nonatomic,strong) UIView *containerView;

/** 搜索的图片*/
@property (nonatomic,strong) UIButton *searchButton;

/** 显示内容*/
@property (nonatomic,strong) UILabel *titleLabel;

@end


@implementation TTLittleWorldSearchView

#pragma mark - life cycle
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        [self initView];
        [self initContrations];
    }
    return self;
}
#pragma mark - response
- (void)tapSearchViewRecognzier:(UITapGestureRecognizer *)tap {
    if (self.delegate && [self.delegate respondsToSelector:@selector(tapTTLittleWorldSearchView:)]) {
        [self.delegate tapTTLittleWorldSearchView:self];
    }
}

#pragma mark - private method
- (void)initView {
    [self addSubview:self.containerView];
    [self.containerView addSubview:self.searchButton];
    [self.containerView addSubview:self.titleLabel];
    
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapSearchViewRecognzier:)];
    [self.containerView addGestureRecognizer:tap];
}

- (void)initContrations {
    [self.containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self).offset(15);
        make.right.mas_equalTo(self).offset(-15);
        make.centerY.mas_equalTo(self);
        make.height.mas_equalTo(30);
    }];
    
    [self.searchButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(18);
        make.centerY.mas_equalTo(self.containerView);
        make.left.mas_equalTo(self.containerView).offset(15);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.searchButton.mas_right).offset(7);
        make.centerY.mas_equalTo(self.searchButton);
    }];
}

#pragma mark - setters and getters
- (UIView *)containerView {
    if (!_containerView) {
        _containerView = [[UIView alloc] init];
        _containerView.layer.masksToBounds = YES;
        _containerView.layer.cornerRadius = 15;
        _containerView.backgroundColor = [XCTheme getTTSimpleGrayColor];
    }
    return _containerView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.text = @"搜索用户名称/ID";
        _titleLabel.font = [UIFont systemFontOfSize:14];
        _titleLabel.textColor = UIColorFromRGB(0xb2b2b2);
    }
    return _titleLabel;
}

- (UIButton *)searchButton {
    if (!_searchButton) {
        _searchButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_searchButton setBackgroundImage:[UIImage imageNamed:@"family_mon_search"] forState:UIControlStateNormal];
        [_searchButton setBackgroundImage:[UIImage imageNamed:@"family_mon_search"] forState:UIControlStateSelected];
    }
    return _searchButton;
}

@end
