//
//  TTDiscoverSectionView.m
//  TuTu
//
//  Created by gzlx on 2018/10/29.
//  Copyright © 2018年 YiZhuan. All rights reserved.
//

#import "TTDiscoverSectionView.h"
#import <Masonry/Masonry.h>
#import "XCTheme.h"


@interface TTDiscoverSectionView ()
@property (nonatomic, strong) UIView * sepView;
/**家族星推荐 */
@property (nonatomic, strong) UILabel * nameLabel;
/** 显示hot*/
@property (nonatomic, strong) UILabel * typeLabel;
@property (nonatomic, strong) UIImageView *tagImageView;

@end

@implementation TTDiscoverSectionView

#pragma mark - life cycle
- (id)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        [self initView];
        [self initConstrations];
    }
    return self;
}
#pragma mark - public methods

#pragma mark - private method
- (void)initView {
    [self addSubview:self.sepView];
    [self addSubview:self.nameLabel];
    [self addSubview:self.typeLabel];
    [self addSubview:self.tagImageView];
}
- (void)initConstrations {
    [self.sepView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.mas_equalTo(self);
        make.height.mas_equalTo(10);
    }];
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self).offset(15);
        make.top.mas_equalTo(self.sepView.mas_bottom).offset(16);
    }];
    
    [self.typeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.nameLabel.mas_right).offset(4);
        make.centerY.mas_equalTo(self.nameLabel);
        make.width.mas_equalTo(36);
        make.height.mas_equalTo(17);
    }];
    
    [self.tagImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.nameLabel.mas_right).offset(4);
        make.centerY.mas_equalTo(self.nameLabel);
        make.width.mas_equalTo(36);
        make.height.mas_equalTo(17);
    }];
}
#pragma mark - getters and setters
- (void)setSection:(NSInteger)section{
    _section = section;
    if (_section == 1) {
        self.tagImageView.hidden = NO;
        self.nameLabel.text = @"家族星推荐";
    }else{
        self.tagImageView.hidden = YES;
        self.nameLabel.text = @"我的家族";
    }
}

- (UIView *)sepView{
    if (!_sepView) {
        _sepView = [[UIView alloc] init];
        _sepView.backgroundColor = [XCTheme getMSSimpleGrayColor];
    }
    return _sepView;
}

- (UILabel *)nameLabel{
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.textColor  =  [XCTheme getTTMainTextColor];
        _nameLabel.font = [UIFont boldSystemFontOfSize:18];
    }
    return _nameLabel;
}

- (UILabel *)typeLabel{
    if (!_typeLabel) {
        _typeLabel = [[UILabel alloc] init];
        _typeLabel.textColor  =  UIColorFromRGB(0xffffff);
        _typeLabel.font = [UIFont systemFontOfSize:12];
        _typeLabel.text = @"HOT";
        _typeLabel.textAlignment = NSTextAlignmentCenter;
        _typeLabel.backgroundColor = UIColorFromRGB(0xFF5400);
        _typeLabel.hidden = YES;
    }
    return _typeLabel;
}

- (UIImageView *)tagImageView {
    if (!_tagImageView) {
        _tagImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"discover_invite_friend_PD_hotTag"]];
    }
    return _tagImageView;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
