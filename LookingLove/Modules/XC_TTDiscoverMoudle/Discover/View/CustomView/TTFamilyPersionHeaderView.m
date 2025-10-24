//
//  TTFamilyPersionHeaderView.m
//  TuTu
//
//  Created by gzlx on 2018/11/2.
//  Copyright © 2018年 YiZhuan. All rights reserved.
//

#import "TTFamilyPersionHeaderView.h"
#import <YYLabel.h>
#import <Masonry/Masonry.h>
#import "XCTheme.h"
#import "UIImageView+QiNiu.h"
//view

#import "TTFamilyAttributedString.h"
#import "TTFamilyManagerViewController.h"

@interface TTFamilyPersionHeaderView ()
/** 背景图*/
@property (nonatomic, strong) UIImageView * backImageView;
/** 家族名称*/
@property (nonatomic, strong) UILabel * familyNameLabel;
/** 家族头像*/
@property (nonatomic, strong) UIImageView * familyImageView;
/** id*/
@property (nonatomic, strong) YYLabel * numbeLabel;

@property (nonatomic, strong) XCFamily * family;

@end

@implementation TTFamilyPersionHeaderView

#pragma mark - life cycle
- (id)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self initView];
        [self initConstrations];
    }
    return self;
}

#pragma mark - public methods
-(void)configTTFamilypersonHeaderViewWithFamily:(XCFamily *)family{
    self.family = family;
    [self.familyImageView qn_setImageImageWithUrl:family.familyIcon placeholderImage:[[XCTheme defaultTheme] default_avatar] type:ImageTypeHomePageItem];
    self.familyNameLabel.text = family.familyName;
    self.numbeLabel.attributedText = [TTFamilyAttributedString createFamilyPersonHeaderAttributstring:family];
    self.numbeLabel.textAlignment = NSTextAlignmentCenter;
    //如果是家族的成员并且 是族长的话
    if (family.enterStatus ==UserInFamilyYES && family.position == FamilyMemberPositionOwen) {
        self.managerView.hidden = NO;
    }else{
        self.managerView.hidden = YES;
    }
    if (family.background && family.background.length > 0) {
        [self.backImageView qn_setImageImageWithUrl:family.background placeholderImage:[[XCTheme defaultTheme] default_avatar] type:ImageTypeFamilyHeaderBack];
    }else{
        self.backImageView.image = [UIImage imageNamed:@"family_person_header"];
    }
}
#pragma mark - delegate
#pragma mark - event response
- (void)familyManagerRecognizer:(UITapGestureRecognizer *)tap{
    if (self.controtroller) {
        TTFamilyManagerViewController * managerView = [[TTFamilyManagerViewController alloc] init];
        managerView.familyInfor = self.family;
        [self.controtroller.navigationController pushViewController:managerView animated:YES];
    }
}

#pragma mark - private method
- (void)initView {
    [self addSubview:self.backImageView];
    [self addSubview:self.managerView];
    [self addSubview:self.familyImageView];
    [self addSubview:self.familyNameLabel];
    [self addSubview:self.numbeLabel];
}
- (void)initConstrations {
    [self.backImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self);
    }];
    
    [self.managerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(73);
        make.height.mas_equalTo(24);
        make.left.top.mas_equalTo(self).offset(15);
    }];
    
    [self.familyImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(70);
        make.centerX.mas_equalTo(self);
        make.top.mas_equalTo(self).offset(31);
    }];
    
    [self.familyNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self);
        make.top.mas_equalTo(self.familyImageView.mas_bottom).offset(13);
    }];
    
    [self.numbeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self);
        make.top.mas_equalTo(self.familyNameLabel.mas_bottom).offset(11);
    }];
}
#pragma mark - getters and setters
- (TTFamilyManagerView *)managerView{
    if (!_managerView) {
        _managerView = [[TTFamilyManagerView alloc] init];
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(familyManagerRecognizer:)];
        [_managerView addGestureRecognizer:tap];
    }
    return _managerView;
}

- (UILabel *)familyNameLabel{
    if (!_familyNameLabel) {
        _familyNameLabel = [[UILabel alloc] init];
        _familyNameLabel.textColor  =  UIColorFromRGB(0xffffff);
        _familyNameLabel.font = [UIFont systemFontOfSize:18];
        _familyNameLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _familyNameLabel;
}

- (UIImageView *)backImageView{
    if (!_backImageView) {
        _backImageView = [[UIImageView alloc] init];
    }
    return _backImageView;
}

- (UIImageView *)familyImageView{
    if (!_familyImageView) {
        _familyImageView = [[UIImageView alloc] init];
        _familyImageView.layer.masksToBounds = YES;
        _familyImageView.layer.cornerRadius = 5;
        _familyImageView.layer.borderColor = [UIColor whiteColor].CGColor;
        _familyImageView.layer.borderWidth = 2;
    }
    return _familyImageView;
}

- (YYLabel *)numbeLabel{
    if (!_numbeLabel) {
        _numbeLabel = [[YYLabel alloc] init];
    }
    return _numbeLabel;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
