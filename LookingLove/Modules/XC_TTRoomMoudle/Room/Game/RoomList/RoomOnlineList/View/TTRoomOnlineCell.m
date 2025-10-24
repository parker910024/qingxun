//
//  TTRoomOnlineCell.m
//  TuTu
//
//  Created by lvjunhang on 2018/11/8.
//  Copyright © 2018年 YiZhuan. All rights reserved.
//

#import "TTRoomOnlineCell.h"
#import "TTNobleSourceHandler.h"

//3rd part
#import <YYText/YYLabel.h>
#import <Masonry/Masonry.h>

//category
#import "NSString+JsonToDic.h"
#import "UIImageView+QiNiu.h"
#import "BaseAttrbutedStringHandler+TTRoomModule.h"

//core
#import "RoomQueueCoreV2.h"
#import "ImRoomCoreV2.h"
#import "ImRoomExtMapKey.h"

#import "XCMacros.h"
#import "XCTheme.h"

@interface TTRoomOnlineCell ()
/**
 用户头像
 */
@property (strong, nonatomic) UIImageView *avatarImageView;

/**
 贵族头饰
 */
@property (strong, nonatomic) UIImageView *headerWareImageView;
    
/**
 *用户名和性别 官方
*/
@property (nonatomic, strong) YYLabel * nameLabel;
    
/**
 子标题（是否新用户，是否官方，房间职位，经验等级，魅力等级）
 */
@property (strong, nonatomic) YYLabel *subTitleLabel;

/**
 在麦上显示标签
 */
@property (strong, nonatomic) UILabel *onMicroStatusLabel;

/**
 底部分割线
 */
@property (strong, nonatomic) UIView *underline;

@end

@implementation TTRoomOnlineCell

#pragma mark - life cycle
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initView];
        [self initConstrations];
    }
    return self;
}

#pragma mark - private method
- (void)initView {
    self.backgroundColor = UIColor.clearColor;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    self.avatarImageView.layer.cornerRadius = 19.f;
    self.avatarImageView.layer.masksToBounds = YES;
    
    [self.contentView addSubview:self.avatarImageView];
    [self.contentView addSubview:self.headerWareImageView];
    [self.contentView addSubview:self.nameLabel];
    [self.contentView addSubview:self.subTitleLabel];
    [self.contentView addSubview:self.onMicroStatusLabel];
    [self.contentView addSubview:self.underline];
}

- (void)initConstrations {
    
    [self.avatarImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.contentView.mas_leading).offset(15);
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
        make.width.height.mas_equalTo(40);
    }];
    [self.headerWareImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(56);
        make.center.mas_equalTo(self.avatarImageView);
    }];
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.avatarImageView.mas_trailing).offset(12);
        make.top.mas_equalTo(self.avatarImageView.mas_top);
        make.trailing.mas_equalTo(self.onMicroStatusLabel.mas_leading).offset(-5);
    }];
    
    [self.subTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.nameLabel.mas_leading);
        make.top.mas_equalTo(self.nameLabel.mas_bottom).offset(6);
    }];
    [self.onMicroStatusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(30);
        make.right.mas_equalTo(-16);
        make.width.mas_equalTo(32);
        make.height.mas_equalTo(14);
    }];
    
    [self.underline mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.contentView).inset(15);
        make.height.mas_equalTo(0.5);
        make.bottom.mas_equalTo(0);
    }];
}

#pragma mark - setter & getter
- (void)setMember:(NIMChatroomMember *)member {
    _member = member;
        
    NSDictionary *nobleDict = [NSString dictionaryWithJsonString:member.roomExt];
    LevelInfo *userLevelVo = [LevelInfo yy_modelWithJSON:nobleDict[member.userId]];
    SingleNobleInfo *nobleInfo = [SingleNobleInfo yy_modelWithJSON:nobleDict[member.userId]];
    NSString *anchorName = [nobleDict[member.userId] objectForKey:ImRoomExtKeyOfficialAnchorCertificationName];
    NSString *anchorPic = [nobleDict[member.userId] objectForKey:ImRoomExtKeyOfficialAnchorCertificationIcon];
    
    self.onMicroStatusLabel.hidden = ![GetCore(RoomQueueCoreV2) isOnMicro:member.userId.userIDValue];
    
    if (nobleInfo.headwear) {
        self.headerWareImageView.hidden = NO;
        [TTNobleSourceHandler handlerImageView:self.headerWareImageView soure:nobleInfo.headwear imageType:ImageTypeUserLibaryDetail];
    } else {
        self.headerWareImageView.hidden = YES;
    }
    @weakify(self);
    [[[GetCore(ImRoomCoreV2) rac_fetchMemberUserInfoByUid:member.userId] takeUntil:self.rac_prepareForReuseSignal]subscribeNext:^(id x) {
        @strongify(self);
        NIMUser *user  = (NIMUser *)x;
        UserInfo *info = [[UserInfo alloc] init];
        info.nick = member.roomNickname;
        info.gender = (UserGender)user.userInfo.gender;
        info.userLevelVo = userLevelVo;
        info.newUser = [nobleDict[@"newUser"] boolValue];
        info.defUser = userLevelVo.defUser;
        info.nobleUsers = nobleInfo;
        
        if (anchorName && anchorPic) {
            UserOfficialAnchorCertification *cert = [[UserOfficialAnchorCertification alloc] init];
            cert.fixedWord = anchorName;
            cert.iconPic = anchorPic;
            info.nameplate = cert;
        }
        
        if (nobleInfo.enterHide) {
             [self.avatarImageView qn_setImageImageWithUrl:RankHideAvatarUrl placeholderImage:[XCTheme defaultTheme].default_avatar type:ImageTypeUserIcon];
        }else{
             [self.avatarImageView qn_setImageImageWithUrl:member.roomAvatar placeholderImage:[XCTheme defaultTheme].default_avatar type:ImageTypeUserIcon];
        }
        
        self.nameLabel.attributedText = [BaseAttrbutedStringHandler createOnlineListUserNameAndGenderAndOfficalWithUserInfor:info isHide:nobleInfo.enterHide];
        
        self.subTitleLabel.attributedText = [BaseAttrbutedStringHandler roomOnlineSubTitleAttributedStringWithUserInfo:info chatRoomMember:member];
    }];
}

- (UIImageView *)avatarImageView {
    if (!_avatarImageView) {
        _avatarImageView = [[UIImageView alloc]init];
    }
    return _avatarImageView;
}

- (UIImageView *)headerWareImageView {
    if (!_headerWareImageView) {
        _headerWareImageView = [[UIImageView alloc] init];
        _headerWareImageView.hidden = YES;
    }
    return _headerWareImageView;
}

- (YYLabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [[YYLabel alloc]init];
    }
    return _nameLabel;
}

- (YYLabel *)subTitleLabel {
    if (!_subTitleLabel) {
        _subTitleLabel = [[YYLabel alloc]init];
    }
    return _subTitleLabel;
}

- (UILabel *)onMicroStatusLabel {
    if (!_onMicroStatusLabel) {
        _onMicroStatusLabel = [[UILabel alloc] init];
        _onMicroStatusLabel.text = @"上麦";
        _onMicroStatusLabel.textColor = UIColor.whiteColor;
        _onMicroStatusLabel.font = [UIFont systemFontOfSize:10];
        _onMicroStatusLabel.textAlignment = NSTextAlignmentCenter;
        _onMicroStatusLabel.layer.cornerRadius = 7;
        _onMicroStatusLabel.layer.masksToBounds = YES;
        _onMicroStatusLabel.backgroundColor = [UIColor.blackColor colorWithAlphaComponent:0.8];
    }
    return _onMicroStatusLabel;
}

- (UIView *)underline {
    if (_underline == nil) {
        _underline = [[UIView alloc] init];
        _underline.backgroundColor = [UIColor.whiteColor colorWithAlphaComponent:0.1];
    }
    return _underline;
}

@end
