//
//  TTEnterFamilyView.m
//  TuTu
//
//  Created by gzlx on 2018/11/3.
//  Copyright © 2018年 YiZhuan. All rights reserved.
//

#import "TTEnterFamilyView.h"
#import "XCTheme.h"
#import <Masonry/Masonry.h>

@interface TTEnterFamilyView()
@property (nonatomic, strong) UIView *backView;
@property (nonatomic, strong) UIImageView * enterImageView;
@property (nonatomic, strong) UILabel * titleLabel;
@end


@implementation TTEnterFamilyView

#pragma mark - life cycle
- (id)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor =[XCTheme getTTSimpleGrayColor];
        [self initView];
        [self initContration];
    }
    return self;
}

- (void)initView{
    [self addSubview:self.backView];
    [self addSubview:self.enterImageView];
    [self addSubview:self.titleLabel];
}

- (void)initContration{
    [self.backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(196);
        make.height.mas_equalTo(40);
        make.centerX.mas_equalTo(self);
        make.top.mas_equalTo(self).offset(15);
    }];
    
    [self.enterImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(14);
        make.centerY.mas_equalTo(self.backView);
        make.right.mas_equalTo(self.titleLabel.mas_left).offset(-7);;
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.backView);
        make.centerX.mas_equalTo(self.backView).offset(19);
    }];
}

#pragma mark - getters
- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor  =  [UIColor whiteColor];
        _titleLabel.font = [UIFont systemFontOfSize:15];
        _titleLabel.text = @"加入家族";
    }
    return _titleLabel;
}

- (UIImageView *)enterImageView{
    if (!_enterImageView) {
        _enterImageView = [[UIImageView alloc] init];
        _enterImageView.image = [UIImage imageNamed:@"family_bottom_enter"];
    }
    return _enterImageView;
}

- (UIView *)backView{
    if (!_backView) {
        _backView = [[UIView alloc] init];
        _backView.backgroundColor = [XCTheme getTTMainColor];
        _backView.layer.masksToBounds = YES;
        _backView.layer.cornerRadius = 20;
    }
    return _backView;
}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
