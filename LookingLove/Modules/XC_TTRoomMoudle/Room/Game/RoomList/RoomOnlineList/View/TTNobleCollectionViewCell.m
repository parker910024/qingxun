//
//  TuTuNobleCollectionViewCell.m
//  XChat
//
//  Created by Mac on 2018/1/16.
//  Copyright © 2018年 XC. All rights reserved.
//

#import "TTNobleCollectionViewCell.h"
//core
#import "UserCore.h"
#import "AuthCore.h"
#import "NobleCore.h"
#import "ImRoomCoreV2.h"
#import "RoomQueueCoreV2.h"
//t
#import "TTNobleSourceHandler.h"
#import "UIImageView+QiNiu.h"
#import "XCTheme.h"

//sdk
#import <NIMSDK/NIMSDK.h>
#import <Masonry/Masonry.h>


/**
 自定义边距的 Label
 */
@interface TTNobleCollectionViewCellNameLabel : UILabel

@end

@implementation TTNobleCollectionViewCellNameLabel

///设置内边距
- (void)drawTextInRect:(CGRect)rect {
    UIEdgeInsets insets = {0, 6, 0, 6};
    [super drawTextInRect:UIEdgeInsetsInsetRect(rect, insets)];
}

@end

@interface TTNobleCollectionViewCell()

@property (nonatomic, strong) UIImageView *iconImagView;
@property (nonatomic, strong) UIImageView *headerWareImageView;
@property (nonatomic, strong) UIImageView *nobleImageView;
@property (nonatomic, strong) TTNobleCollectionViewCellNameLabel *nameLabel;
@property (nonatomic, strong) UIImageView *sexImageView;
@property (nonatomic, strong) OnLineNobleInfo *userInfo;

@end

@implementation TTNobleCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.sexImageView.hidden = YES;

        [self setupSubViews];
        [self setupConstraints];
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

#pragma mark - puble method
- (void)configCellWithUserModel:(OnLineNobleInfo *)userInfo{
    _userInfo = userInfo;
    
    if (userInfo == nil) {
        self.iconImagView.image = [UIImage imageNamed:@"room_game_position_normal"];
        self.nameLabel.text = @"贵族专属";
        self.nameLabel.backgroundColor = [UIColor.whiteColor colorWithAlphaComponent:0.12];
        self.headerWareImageView.hidden = YES;
        self.nobleImageView.hidden = YES;
        return;
    }
    if (userInfo.nobleUsers.enterHide) {
        self.nameLabel.text = @"神秘人";
        [self.iconImagView qn_setImageImageWithUrl:RankHideAvatarUrl placeholderImage:@"common_default_avatar" type:ImageTypeUserIcon];
    }else{
        self.nameLabel.text = userInfo.nick;
        [self.iconImagView qn_setImageImageWithUrl:userInfo.avatar placeholderImage:@"common_default_avatar" type:ImageTypeUserIcon];
    }
   
    
    if (userInfo.gender == UserInfo_Male) {
        self.sexImageView.image = [UIImage imageNamed:[XCTheme defaultTheme].common_sex_male];
        self.nameLabel.backgroundColor = [UIColorFromRGB(0x16AEFD) colorWithAlphaComponent:0.5];
    } else {
        self.sexImageView.image = [UIImage imageNamed:[XCTheme defaultTheme].common_sex_female];
        self.nameLabel.backgroundColor = [UIColorFromRGB(0xFE3F77) colorWithAlphaComponent:0.5];
    }

    //noble
    if (userInfo.nobleUsers.headwear) {
        self.headerWareImageView.hidden = NO;
        self.nobleImageView.hidden = YES;
        [TTNobleSourceHandler handlerImageView:self.headerWareImageView soure:userInfo.nobleUsers.headwear imageType:ImageTypeUserIcon];
    }else{
        self.headerWareImageView.hidden = YES;
        self.nobleImageView.hidden = NO;
        [TTNobleSourceHandler handlerImageView:self.nobleImageView soure:userInfo.nobleUsers.badge imageType:ImageTypeUserIcon];
    }
}

#pragma mark - private method
- (void)setupSubViews{
    [self.contentView addSubview:self.iconImagView];
    [self.contentView addSubview:self.headerWareImageView];
    [self.contentView addSubview:self.nobleImageView];
    [self.contentView addSubview:self.nameLabel];
    [self.contentView addSubview:self.sexImageView];
}

- (void)setupConstraints{
    [self.iconImagView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(@55);
        make.centerY.centerX.equalTo(self.headerWareImageView);
    }];
    [self.headerWareImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(@80);
        make.centerX.top.equalTo(self.contentView);
    }];
    [self.nobleImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(@19);
        make.right.bottom.equalTo(self.iconImagView);
    }];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconImagView);
        make.top.equalTo(self.iconImagView.mas_bottom).offset(8);
        make.width.equalTo(@55);
        make.height.equalTo(@14);
    }];
    [self.sexImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nameLabel.mas_right).offset(3);
        make.centerY.equalTo(self.nameLabel);
        make.height.width.equalTo(@13);
    }];

}

#pragma mark - Getter
- (UIImageView *)iconImagView{
    if (!_iconImagView) {
        _iconImagView = [[UIImageView alloc] init];
        _iconImagView.layer.cornerRadius = 27.5;
        _iconImagView.layer.masksToBounds = YES;
    }
    return _iconImagView;
}
- (UIImageView *)headerWareImageView{
    if (!_headerWareImageView) {
        _headerWareImageView = [[UIImageView alloc] init];
        _headerWareImageView.hidden = YES;
    }
    return _headerWareImageView;
}
- (UIImageView *)nobleImageView{
    if (!_nobleImageView) {
        _nobleImageView = [[UIImageView alloc] init];
        _nobleImageView.hidden = YES;
    }
    return _nobleImageView;
}
- (TTNobleCollectionViewCellNameLabel *)nameLabel{
    if (!_nameLabel) {
        _nameLabel = [[TTNobleCollectionViewCellNameLabel alloc] init];
        _nameLabel.textColor = [UIColor whiteColor];
        _nameLabel.backgroundColor = [UIColor.whiteColor colorWithAlphaComponent:0.12];
        _nameLabel.font = [UIFont systemFontOfSize:10];
        _nameLabel.textAlignment = NSTextAlignmentCenter;
        
        _nameLabel.layer.cornerRadius = 7;
        _nameLabel.layer.masksToBounds = YES;
    }
    return _nameLabel;
}
- (UIImageView *)sexImageView{
    if (!_sexImageView) {
        _sexImageView = [[UIImageView alloc] init];
    }
    return _sexImageView;
}
 
@end

