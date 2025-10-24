//
//  TTRoomRoleListCell.m
//  TuTu
//
//  Created by lvjunhang on 2018/11/7.
//  Copyright © 2018年 YiZhuan. All rights reserved.
//

#import "TTRoomRoleListCell.h"
#import "BaseAttrbutedStringHandler+TTRoomModule.h"

#import "XCTheme.h"
#import "XCMacros.h"
#import "NSBundle+Source.h"
#import "ImRoomCoreV2.h"
#import "UIImageView+QiNiu.h"
#import "NSString+JsonToDic.h"

#import <ReactiveObjC/ReactiveObjC.h>
#import <YYText/YYText.h>
#import <Masonry/Masonry.h>

@interface TTRoomRoleListCell ()

/**
 头像
 */
@property (strong, nonatomic) UIImageView *avatar;

/**
 用户名label |昵称|性别|经验等级|魅力等级
 */
@property (strong, nonatomic) YYLabel *usernameLabel;

/**
 号码label |是否是靓号|ID|
 */
@property (strong, nonatomic) YYLabel *idLabel;

/**
 移除按钮
 */
@property (strong, nonatomic) UIButton *removeButton;

@end

@implementation TTRoomRoleListCell



- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initView];
        [self initConstrations];
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

- (void)initView {
    [self.contentView addSubview:self.avatar];
    [self.contentView addSubview:self.usernameLabel];
    //    [self.contentView addSubview:self.idLabel];
    [self.contentView addSubview:self.removeButton];
}

- (void)initConstrations {
    [self.avatar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.contentView.mas_leading).offset(15);
        make.width.height.mas_equalTo(40);
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
    }];
    [self.usernameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self);
        make.leading.mas_equalTo(self.avatar.mas_trailing).offset(10);
    }];
    
    [self.removeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
        make.trailing.mas_equalTo(self.contentView.mas_trailing).offset(-15);
        make.width.mas_equalTo(65);
        make.height.mas_equalTo(30);
    }];
}

#pragma mark - event respone

- (void)onRemoveButtonClick:(UIButton *)sender {
    if (self.removeMemberBlock) {
        self.removeMemberBlock();
    }
}

#pragma mark - setter & getter

- (void)setMember:(NIMChatroomMember *)member {
    _member = member;
    
    [self.avatar qn_setImageImageWithUrl:member.roomAvatar placeholderImage:[XCTheme defaultTheme].default_avatar type:(ImageType)ImageTypeUserIcon];
    
    @weakify(self);
    [[[GetCore(ImRoomCoreV2) rac_fetchMemberUserInfoByUid:member.userId] takeUntil:self.rac_prepareForReuseSignal] subscribeNext:^(id x) {
        @strongify(self);
        NIMUser *user  = (NIMUser *)x;
        UserInfo *info = [[UserInfo alloc] init];
        info.nick = user.userInfo.nickName;
        info.gender = (UserGender)user.userInfo.gender;
        
        self.usernameLabel.attributedText = [BaseAttrbutedStringHandler creatOnlineListUserNameWithGenderAttrWithUserInfo:info];
    }];
}

-(UIImageView *)avatar {
    if (!_avatar) {
        _avatar = [[UIImageView alloc]init];
        _avatar.layer.cornerRadius = 20;
        _avatar.layer.masksToBounds = YES;
    }
    return _avatar;
}

- (YYLabel *)usernameLabel {
    if (!_usernameLabel) {
        _usernameLabel = [[YYLabel alloc]init];
    }
    return _usernameLabel;
}

- (YYLabel *)idLabel {
    if (!_idLabel) {
        _idLabel = [[YYLabel alloc]init];
    }
    return _idLabel;
}

- (UIButton *)removeButton {
    if (!_removeButton) {
        _removeButton = [[UIButton alloc]init];
        [_removeButton addTarget:self action:@selector(onRemoveButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [_removeButton setTitle:@"移除" forState:UIControlStateNormal];
        [_removeButton setTitleColor:[XCTheme getTTMainColor] forState:UIControlStateNormal];
        _removeButton.titleLabel.font = [UIFont systemFontOfSize:12];
        _removeButton.layer.cornerRadius = 15;
        _removeButton.layer.masksToBounds = YES;
        _removeButton.layer.borderWidth = 1;
        _removeButton.layer.borderColor = [XCTheme getTTMainColor].CGColor;
    }
    return _removeButton;
}
@end
