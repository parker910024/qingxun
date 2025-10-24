//
//  GuildHallInfo.h
//  XCChatCoreKit
//
//  Created by lvjunhang on 2019/1/7.
//  Copyright © 2019年 KevinWang. All rights reserved.
//  模厅信息

#import "BaseObject.h"

NS_ASSUME_NONNULL_BEGIN

@interface GuildHallInfo : BaseObject

/**
 模厅id
 */
@property (nonatomic, copy) NSString *hallId;
/**
 模厅名称
 */
@property (nonatomic, copy) NSString *hallName;
/**
 角色类型： 1：厅主，2：高管，3：普通成员，为空表示不属于这个模厅成员
 */
@property (nonatomic, copy) NSString *roleType;

/**
 厅主的 uid
 */
@property (nonatomic, copy) NSString *ownerUid;

@end

NS_ASSUME_NONNULL_END
