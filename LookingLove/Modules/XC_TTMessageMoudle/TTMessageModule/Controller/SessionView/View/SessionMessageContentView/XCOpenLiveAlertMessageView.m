//
//  XCOpenLiveAlertMessageView.m
//  XChat
//
//  Created by 卫明何 on 2017/10/16.
//  Copyright © 2017年 XC. All rights reserved.
//

#import "XCOpenLiveAlertMessageView.h"
#import <Masonry.h>
#import "XCTheme.h"

@implementation XCOpenLiveAlertMessageView

#pragma mark - life cycle
- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]){
        [self initView];
        [self initContrations];
    }
    return self;
}


#pragma mark - private method
- (void)initView
{
    [self addSubview:self.avatar];
    [self addSubview:self.titleLabel];
    [self addSubview:self.subTitle];
}
- (void)initContrations
{
    [self.avatar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(47);
        make.centerY.mas_equalTo(self);
        make.left.mas_equalTo(self).offset(10);
    }];
     
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.avatar);
        make.left.mas_equalTo(self.avatar.mas_right).offset(10);
    }];
     
     [self.subTitle mas_makeConstraints:^(MASConstraintMaker *make) {
         make.left.mas_equalTo(self.titleLabel);
         make.top.mas_equalTo(self.titleLabel.mas_bottom).offset(9);
     }];
}

#pragma mark - setters and getters
- (UIImageView *)avatar
{
    if (!_avatar){
        _avatar = [[UIImageView alloc] init];
    }
    return _avatar;
}

- (UILabel *)subTitle
{
    if (!_subTitle){
        _subTitle = [[UILabel alloc] init];
        _subTitle.font  =[UIFont systemFontOfSize:13];
        _subTitle.textAlignment =  NSTextAlignmentLeft;
        _subTitle.textColor = UIColorFromRGB(0x999999);
    }
    return _subTitle;
}

- (UILabel *)titleLabel
{
    if (!_titleLabel){
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont systemFontOfSize:17];
        _titleLabel.text = @"你关注的TA";
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        _titleLabel.textColor = UIColorFromRGB(0x333333);
    }
    return _titleLabel;
}



@end
