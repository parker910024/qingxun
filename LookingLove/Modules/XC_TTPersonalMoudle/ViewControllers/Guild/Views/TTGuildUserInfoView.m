//
//  TTGuildUserInfoView.m
//  TuTu
//
//  Created by lee on 2019/1/9.
//  Copyright © 2019 YiZhuan. All rights reserved.
//

#import "TTGuildUserInfoView.h"
#import <Masonry/Masonry.h>
#import "XCTheme.h"
#import "XCMacros.h"
#import "UIView+ZJFrame.h"
#import "UIImageView+QiNiu.h"
#import "UserInfo.h"

@interface TTGuildUserInfoView ()
@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UILabel *nameLabel;

@end

@implementation TTGuildUserInfoView

#pragma mark -
#pragma mark lifeCycle
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self initViews];
        [self initConstraints];
    }
    return self;
}

- (void)initViews {
    [self addSubview:self.iconImageView];
    [self addSubview:self.nameLabel];
}

- (void)initConstraints {
    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self).offset(18);
        make.left.mas_equalTo(self).offset(15);
        make.height.width.mas_equalTo(40);
    }];
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.iconImageView.mas_right).offset(10);
        make.centerY.mas_equalTo(self.iconImageView);
    }];

}

#pragma mark -
#pragma mark clients

#pragma mark -
#pragma mark private methods
- (void)setInfo:(UserInfo *)info {
    _info = info;
    [self.iconImageView qn_setImageImageWithUrl:info.avatar placeholderImage:[XCTheme defaultTheme].default_avatar type:ImageTypeUserIcon];
    self.nameLabel.text = info.nick;
}
#pragma mark -
#pragma mark button click events

#pragma mark -
#pragma mark getter & setter

- (UIImageView *)iconImageView
{
    if (!_iconImageView) {
        _iconImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[XCTheme defaultTheme].default_avatar]];
        _iconImageView.layer.cornerRadius = 20;
        _iconImageView.layer.masksToBounds = YES;
    }
    return _iconImageView;
}

- (UILabel *)nameLabel
{
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.text = @"欣欣爱大米";
        _nameLabel.textColor = [XCTheme getTTMainColor];
        _nameLabel.font = [UIFont systemFontOfSize:15.f];
        _nameLabel.adjustsFontSizeToFitWidth = YES;
    }
    return _nameLabel;
}
@end
