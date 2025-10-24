//
//  GuildHallGroupListItem.h
//  XCChatCoreKit
//
//  Created by lvjunhang on 2019/1/11.
//  Copyright © 2019年 KevinWang. All rights reserved.
//  模厅群聊列表

#import "BaseObject.h"
#import "GuildHallGroupInfo.h"

NS_ASSUME_NONNULL_BEGIN

@interface GuildHallGroupListItem : BaseObject
@property (nonatomic, copy) NSString *hallId;//模厅id
@property (nonatomic, copy) NSString *chatId;//群聊 Id
@property (nonatomic, copy) NSString *tid;//云信群聊tid
@property (nonatomic, copy) NSString *ownerUid;//群主uid
@property (nonatomic, copy) NSString *name;//群名称
@property (nonatomic, copy) NSString *icon;//群头像
@property (nonatomic, copy) NSString *notice;//群公告

@property (nonatomic, assign) GuildHallGroupType type;//群类型

@property (nonatomic, assign) BOOL inChat;//是否已在群聊中。false 不在。true在

@end

NS_ASSUME_NONNULL_END
