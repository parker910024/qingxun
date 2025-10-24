//
//  GuildOwnerHallInfo.h
//  XCChatCoreKit
//
//  Created by lvjunhang on 2019/1/17.
//  Copyright © 2019 KevinWang. All rights reserved.
//  获取厅主模厅信息

#import "BaseObject.h"

NS_ASSUME_NONNULL_BEGIN

@interface GuildOwnerHallGroupChat : BaseObject
@property (nonatomic, copy) NSString *str;
@property (nonatomic, copy) NSString *icon;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, assign) NSInteger type;
@property (nonatomic, assign) NSInteger tid;
@property (nonatomic, assign) NSInteger ownerUid;
@property (nonatomic, assign) BOOL inChat;
@property (nonatomic, assign) NSInteger chatId;
@end

@interface GuildOwnerHallInfo : BaseObject

@property (nonatomic, assign) NSInteger hallId;
@property (nonatomic, copy) NSString *hallName;
@property (nonatomic, assign) BOOL inHall;
@property (nonatomic, strong) NSArray<GuildOwnerHallGroupChat *> *groupChats;

@end

NS_ASSUME_NONNULL_END
