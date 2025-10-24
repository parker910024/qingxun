//
//  TTUpGradeView.m
//  TuTu
//
//  Created by gzlx on 2018/11/24.
//  Copyright © 2018年 YiZhuan. All rights reserved.
//

#import "TTUpGradeView.h"
#import "XCTheme.h"
#import <Masonry/Masonry.h>
#import "UIImage+Utils.h"

@interface TTUpGradeView ()
/** 上面的头*/
@property (nonatomic, strong) UIImageView * logoImageView;
/** 当前用户等级*/
@property (nonatomic, strong) UILabel * titleLabel;
/** 左侧的线*/
@property (nonatomic, strong) UIImageView * lifeImageView;
/** 等级的*/
@property (nonatomic, strong) UILabel * levelLabel;
/** 右侧的线*/
@property (nonatomic, strong) UIImageView * rightImageView;
/**内容*/
@property (nonatomic, strong) UILabel * contetnLabel;
/**知道了 */
@property (nonatomic, strong) UIButton *knowButton;

@end


@implementation TTUpGradeView

- (id)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self initView];
        [self initContrations];
    }
    return self;
}

#pragma mark - response
- (void)sureButtonClick:(UIButton *)sender{
    if (self.gradeWindow) {
        self.gradeWindow.windowLevel = UIWindowLevelNormal -1;
        [self removeFromSuperview];
    }
}

#pragma mark - public method
- (void)configttUpgradeView:(UserUpGradeInfo *)gradeInfor type:(UserUpgradeViewType)type{
    //魅力值
    NSString * topBackImageStr;
    NSString * leftImageStr;
    NSString * rightImageStr;
    NSString * titleStr;
    if (type == UserUpgradeViewTypeCharmLevel) {
        topBackImageStr = @"tt_upgrade_level";
        leftImageStr = @"tt_grade_left_level";
        rightImageStr = @"tt_grade_right_level";
        titleStr = @"当前魅力等级";
        self.levelLabel.textColor = [XCTheme getTTMainColor];
        [self.knowButton setBackgroundImage:[UIImage gradientColorImageFromColors:@[UIColorFromRGB(0xFF9451), UIColorFromRGB(0xFF6147)] gradientType:GradientTypeUpleftToLowright imgSize:CGSizeMake(160, 38)] forState:UIControlStateNormal];
    }else{
        topBackImageStr = @"tt_upgrade_charm";
        leftImageStr = @"tt_grade_left_charm";
        rightImageStr = @"tt_grade_right_charm";
        titleStr = @"当前用户等级";
        self.levelLabel.textColor = UIColorFromRGB(0xFF467A);
        [self.knowButton setBackgroundImage:[UIImage gradientColorImageFromColors:@[UIColorFromRGB(0xFF467A), UIColorFromRGB(0xFF467A)] gradientType:GradientTypeUpleftToLowright imgSize:CGSizeMake(160, 38)] forState:UIControlStateNormal];
    }
    self.titleLabel.text = titleStr;
    self.logoImageView.image = [UIImage imageNamed:topBackImageStr];
    self.lifeImageView.image = [UIImage imageNamed:leftImageStr];
    self.rightImageView.image = [UIImage imageNamed:rightImageStr];
    self.levelLabel.text = gradeInfor.levelName;
}


#pragma mark - private method
- (void)initView{
    self.backgroundColor = [UIColor whiteColor];
    self.layer.cornerRadius = 10;
    self.layer.masksToBounds = YES;
    [self addSubview:self.logoImageView];
    [self addSubview:self.titleLabel];
    [self addSubview:self.lifeImageView];
    [self addSubview:self.rightImageView];
    [self addSubview:self.levelLabel];
    [self addSubview:self.contetnLabel];
    [self addSubview:self.knowButton];
}

- (void)initContrations{
    [self.logoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.mas_equalTo(self);
        make.height.mas_equalTo(117);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self);
        make.top.mas_equalTo(self.logoImageView.mas_bottom).offset(6);
    }];
    
    [self.lifeImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(30);
        make.height.mas_equalTo(2);
        make.left.mas_equalTo(self).offset(54);
        make.centerY.mas_equalTo(self.levelLabel);
    }];
    
    [self.levelLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self);
        make.top.mas_equalTo(self.titleLabel.mas_bottom).offset(8);
    }];
    
    [self.rightImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.centerY.mas_equalTo(self.lifeImageView);
        make.right.mas_equalTo(self).offset(-54);
    }];
    
    [self.contetnLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self);
        make.top.mas_equalTo(self.levelLabel.mas_bottom).offset(14);
    }];
    
    [self.knowButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(160);
        make.height.mas_equalTo(38);
        make.centerX.mas_equalTo(self);
        make.bottom.mas_equalTo(self).offset(-21);
    }];
}

#pragma mark - setters and getters
- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor  =  UIColorFromRGB(0x333333);
        _titleLabel.font = [UIFont systemFontOfSize:14];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.text = @"当前用户等级";
    }
    return _titleLabel;
}

- (UILabel *)contetnLabel{
    if (!_contetnLabel) {
        _contetnLabel = [[UILabel alloc] init];
        _contetnLabel.textColor  =  UIColorFromRGB(0x808080);
        _contetnLabel.font = [UIFont systemFontOfSize:12];
        _contetnLabel.text = @"等级越高等级特权越多哦";
        _contetnLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _contetnLabel;
}

- (UILabel *)levelLabel{
    if (!_levelLabel) {
        _levelLabel = [[UILabel alloc] init];
        _levelLabel.textColor  =  UIColorFromRGB(0x333333);
        _levelLabel.font = [UIFont systemFontOfSize:15];
    }
    return _levelLabel;
}

- (UIImageView *)logoImageView{
    if (!_logoImageView) {
        _logoImageView = [[UIImageView alloc] init];
        _logoImageView.image = [UIImage imageNamed:@"tt_upgrade"];
    }
    return _logoImageView;
}

- (UIImageView *)lifeImageView{
    if (!_lifeImageView) {
        _lifeImageView = [[UIImageView alloc] init];
        _lifeImageView.image = [UIImage imageNamed:@"tt_grade_left"];
    }
    return _lifeImageView;
}

- (UIImageView *)rightImageView{
    if (!_rightImageView) {
        _rightImageView = [[UIImageView alloc] init];
        _rightImageView.image = [UIImage imageNamed:@"tt_grade_right"];
    }
    return _rightImageView;
}

- (UIButton *)knowButton{
    if (!_knowButton) {
        _knowButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_knowButton setTitle:@"我知道了" forState:UIControlStateNormal];
        _knowButton.titleLabel.font = [UIFont systemFontOfSize:14];
        _knowButton.layer.masksToBounds = YES;
        _knowButton.layer.cornerRadius = 19;
        [_knowButton addTarget:self action:@selector(sureButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _knowButton;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
