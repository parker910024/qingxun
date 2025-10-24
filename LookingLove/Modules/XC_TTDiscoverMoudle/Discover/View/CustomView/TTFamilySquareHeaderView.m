//
//  TTFamilySquareHeaderView.m
//  TuTu
//
//  Created by gzlx on 2018/11/1.
//  Copyright © 2018年 YiZhuan. All rights reserved.
//

#import "TTFamilySquareHeaderView.h"
#import <Masonry/Masonry.h>
#import "XCTheme.h"

@interface TTFamilySquareHeaderView()
/** 顶部的图片*/
@property (nonatomic, strong) UIImageView * topBackImageView;
/** 标题*/
@property (nonatomic, strong) UILabel * titleLabel;
/** 分割线*/
@property (nonatomic, strong)UIView * sepView;
@end

@implementation TTFamilySquareHeaderView

- (id)initWithFrame:(CGRect)frame{
    if (self= [super initWithFrame:frame]) {
        [self initView];
        [self initContrations];
    }
    return self;
}

#pragma mark- life cycle
- (void)initView{
    self.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.topBackImageView];
    [self addSubview:self.titleLabel];
    [self addSubview:self.sepView];
}

- (void)initContrations{
    [self.topBackImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.mas_equalTo(self);
        make.height.mas_equalTo(215);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.top.mas_equalTo(self.topBackImageView.mas_bottom).offset(14);
    }];
    
    [self.sepView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self).offset(15);
        make.right.mas_equalTo(self).offset(-15);
        make.height.mas_equalTo(0.5);
        make.top.mas_equalTo(self.titleLabel.mas_bottom).offset(13);
    }];
}

#pragma mark - setters and getters
- (UIImageView *)topBackImageView{
    if (!_topBackImageView) {
        _topBackImageView = [[UIImageView alloc] init];
        _topBackImageView.image = [UIImage imageNamed:@"discover_square_top"];
    }
    return _topBackImageView;
}

- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor  =  UIColorFromRGB(0x1a1a1a);
        _titleLabel.font = [UIFont systemFontOfSize:16];
        _titleLabel.text = @"家族魅力周榜";
    }
    return _titleLabel;
}

- (UIView *)sepView{
    if (!_sepView) {
        _sepView = [[UIView alloc] init];
        _sepView.backgroundColor = [XCTheme getTTSimpleGrayColor];
    }
    return _sepView;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
