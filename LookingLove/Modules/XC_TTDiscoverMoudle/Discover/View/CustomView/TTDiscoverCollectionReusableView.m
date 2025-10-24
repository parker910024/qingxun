//
//  TTDiscoverCollectionReusableView.m
//  TuTu
//
//  Created by gzlx on 2018/11/1.
//  Copyright © 2018年 YiZhuan. All rights reserved.
//

#import "TTDiscoverCollectionReusableView.h"
#import "XCTheme.h"
#import <Masonry/Masonry.h>

@interface TTDiscoverCollectionReusableView()
@property (nonatomic, strong) UIView * sepView;
/** 新人驾到*/
@property (nonatomic,strong) UILabel * titleLabel;
/** New*/
@property (nonatomic, strong) UILabel * newTypeLabel;
/** arrow*/
@property (nonatomic, strong) UIButton * arrowButton;
@end

@implementation TTDiscoverCollectionReusableView

#pragma mark - life cycle
- (id)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self initView];
        [self initContrations];
    }
    return self;
}

#pragma mark - private method
- (void)initView{
    [self addSubview:self.sepView];
    [self addSubview:self.titleLabel];
    [self addSubview:self.newTypeLabel];
    [self addSubview:self.arrowButton];
}

- (void)initContrations{
    [self.sepView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.mas_equalTo(self);
        make.height.mas_equalTo(10);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self).offset(17);
        make.top.mas_equalTo(self).offset(20);
        
    }];
    [self.newTypeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.titleLabel.mas_right).offset(5);
        make.centerY.mas_equalTo(self.titleLabel);
        make.height.mas_equalTo(17);
        make.width.mas_equalTo(36);
    }];
    
    [self.arrowButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(7);
        make.height.mas_equalTo(11);
        make.right.mas_equalTo(self).offset(-17);
        make.centerY.mas_equalTo(self.titleLabel);
    }];
}

#pragma mark - setters and getters
- (UIView *)sepView{
    if (!_sepView) {
        _sepView = [[UIView alloc] init];
        _sepView.backgroundColor = [XCTheme getTTSimpleGrayColor];
    }
    return _sepView;
}
- (UIButton *)arrowButton{
    if (!_arrowButton) {
        _arrowButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_arrowButton setImage:[UIImage imageNamed:@"discover_family_arrow"] forState:UIControlStateNormal];
    }
    return _arrowButton;
}

- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = [XCTheme getTTMainTextColor];
        _titleLabel.font = [UIFont systemFontOfSize:18];
        _titleLabel.text = @"新人驾到";
    }
    return _titleLabel;
}

- (UILabel *)newTypeLabel{
    if (!_newTypeLabel) {
        _newTypeLabel = [[UILabel alloc] init];
        _newTypeLabel.textColor  =  UIColorFromRGB(0xffffff);
        _newTypeLabel.font = [UIFont systemFontOfSize:12];
        _newTypeLabel.text = @"NEW";
        _newTypeLabel.layer.cornerRadius = 2;
        _newTypeLabel.textAlignment = NSTextAlignmentCenter;
        _newTypeLabel.layer.masksToBounds = YES;
        _newTypeLabel.backgroundColor = UIColorFromRGB(0x61DDCD);
    }
    return _newTypeLabel;
}




@end
