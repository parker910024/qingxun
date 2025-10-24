//
//  TTFamilyShareAlertView.m
//  TuTu
//
//  Created by gzlx on 2018/11/10.
//  Copyright © 2018年 YiZhuan. All rights reserved.
//

#import "TTFamilyShareAlertView.h"
#import "TTFamilyAlertBottomView.h"
#import <Masonry/Masonry.h>
#import "XCTheme.h"
#import "UIImageView+QiNiu.h"
#import "XCKeyWordTool.h"

@interface TTFamilyShareAlertView ()
/** 发送给*/
@property (nonatomic, strong) UILabel * titleLabel;
/** 头像*/
@property (nonatomic, strong) UIImageView * iconImageView;
/** 名字*/
@property (nonatomic, strong) UILabel * nameLabel;
/** 文案*/
@property (nonatomic, strong) UILabel * subTitleLabel;
/** 底部的View*/
@property (nonatomic, strong) TTFamilyAlertBottomView * bottomView;
/** 配置*/
@property (nonatomic, strong) TTFamilyAlertModel * config;
@end

@implementation TTFamilyShareAlertView

#pragma mark - life cycle
- (id)initWithFrame:(CGRect)frame config:(TTFamilyAlertModel *)config{
    if (self = [super initWithFrame:frame]) {
        [self initView];
        [self initConstrations];
        [self configViewWithModel:config];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame{
    if (self= [super initWithFrame:frame]) {
        [self initView];
        [self initConstrations];
    }
    return self;
}

#pragma mark - public methods
#pragma mark - delegate
#pragma mark - event response
- (void)cancleButtonAction:(UIButton *)sender{
    if (self.delegate && [self.delegate respondsToSelector:@selector(cancleActionDismissAlertView:)]) {
        [self.delegate cancleActionDismissAlertView:sender];
    }
}

- (void)sureButtonAction:(UIButton *)sender{
    if (self.delegate && [self.delegate respondsToSelector:@selector(sureButtonActionWith:)]) {
        [self.delegate sureButtonActionWith:sender];
    }
}

#pragma mark - private method
- (void)configViewWithModel:(TTFamilyAlertModel *)config{
    if (config) {
        [self.iconImageView qn_setImageImageWithUrl:config.familyMemberIcon placeholderImage:[[XCTheme defaultTheme] default_avatar] type:ImageTypeUserIcon];
        self.nameLabel.text = config.familyMemberName;
    }
}

- (void)initView {
    self.backgroundColor = [UIColor whiteColor];
    self.layer.cornerRadius = 5;
    self.layer.masksToBounds = YES;
    [self addSubview:self.titleLabel];
    [self addSubview:self.iconImageView];
    [self addSubview:self.nameLabel];
    [self addSubview:self.subTitleLabel];
    [self addSubview:self.bottomView];
    [self.bottomView.cancleButton addTarget:self action:@selector(cancleButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.bottomView.sureButton addTarget:self action:@selector(sureButtonAction:) forControlEvents:UIControlEventTouchUpInside];

}
- (void)initConstrations {
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self).offset(15);
        make.top.mas_equalTo(self).offset(26);
    }];
    
    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self).offset(15);
        make.top.mas_equalTo(self.titleLabel.mas_bottom).offset(14);
        make.width.height.mas_equalTo(50);
    }];
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.iconImageView.mas_right).offset(11);
        make.centerY.mas_equalTo(self.iconImageView);
        make.right.mas_equalTo(self);
    }];
    
    [self.subTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self).offset(5);
        make.right.mas_equalTo(self);
        make.top.mas_equalTo(self.iconImageView.mas_bottom).offset(16);
    }];
    
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self);
        make.height.mas_equalTo(38);
        make.bottom.mas_equalTo(self).offset(-15);
    }];
}
#pragma mark - getters and setters
- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor  = [XCTheme getTTMainTextColor];
        _titleLabel.font = [UIFont systemFontOfSize:16];
        _titleLabel.text = @"发送给:";
    }
    return _titleLabel;
}



- (UILabel *)subTitleLabel{
    if (!_subTitleLabel) {
        _subTitleLabel = [[UILabel alloc] init];
        _subTitleLabel.textColor  = [XCTheme getTTDeepGrayTextColor];
        _subTitleLabel.font = [UIFont systemFontOfSize:14];
        _subTitleLabel.text = [NSString stringWithFormat:@"【%@】用声音表达心情，用家族传承微笑。", [XCKeyWordTool sharedInstance].myAppName];
    }
    return _subTitleLabel;
}


- (UILabel *)nameLabel{
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.textColor  = [XCTheme getTTMainTextColor];
        _nameLabel.font = [UIFont systemFontOfSize:14];
    }
    return _nameLabel;
}

- (TTFamilyAlertBottomView *)bottomView{
    if (!_bottomView) {
        _bottomView = [[TTFamilyAlertBottomView alloc] init];
    }
    return _bottomView;
}

- (UIImageView *)iconImageView{
    if (!_iconImageView) {
        _iconImageView = [[UIImageView alloc] init];
        _iconImageView.layer.masksToBounds = YES;
        _iconImageView.layer.cornerRadius = 25;
    }
    return _iconImageView;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
