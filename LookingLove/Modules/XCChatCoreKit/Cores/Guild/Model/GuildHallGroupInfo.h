//
//  GuildHallGroupChatInfo.h
//  XCChatCoreKit
//
//  Created by lvjunhang on 2019/1/7.
//  Copyright © 2019年 KevinWang. All rights reserved.
//  群聊的群资料

#import "BaseObject.h"

NS_ASSUME_NONNULL_BEGIN


/**
 群身份

 - GuildHallGroupAuthorityOwner: 群主
 - GuildHallGroupAuthorityManager: 管理员
 - GuildHallGroupAuthorityMember: 群成员
 */
typedef NS_ENUM(NSUInteger, GuildHallGroupAuthority) {
    GuildHallGroupAuthorityOwner = 1,
    GuildHallGroupAuthorityManager = 2,
    GuildHallGroupAuthorityMember = 3,
};

/**
 群类型

 - GuildHallGroupTypeOuter: 公开群
 - GuildHallGroupTypeInner: 内部群
 */
typedef NS_ENUM(NSUInteger, GuildHallGroupType) {
    GuildHallGroupTypeOuter = 1,
    GuildHallGroupTypeInner = 2,
};

static inline NSString * GuildHallGroupTypeName(GuildHallGroupType type) {
    switch (type) {
        case GuildHallGroupTypeOuter: return @"公开群";
        case GuildHallGroupTypeInner: return @"内部群";
        default: return @"";
    }
}

@interface GuildHallGroupInfo : BaseObject

@property (nonatomic, copy) NSString *chatId;//群聊 Id
@property (nonatomic, copy) NSString *tid;//云信的群聊唯一id
@property (nonatomic, copy) NSString *uid;//
@property (nonatomic, copy) NSString *name;//群名称
@property (nonatomic, copy) NSString *icon;//群头像
@property (nonatomic, copy) NSString *notice;//群公告

@property (nonatomic, assign) GuildHallGroupAuthority role;//群身份
@property (nonatomic, assign) GuildHallGroupType type;//群类型

@property (nonatomic, assign) BOOL promptStatus;//是否消息提醒，false:关闭免打扰,true:开启免打扰

@property (nonatomic, strong) NSArray *memberAvatars;//群成员列表
@property (nonatomic, strong) NSArray *managerAvatars;//群管理列表
@property (nonatomic, strong) NSArray *muteList;//群禁言列表？

@end

NS_ASSUME_NONNULL_END
