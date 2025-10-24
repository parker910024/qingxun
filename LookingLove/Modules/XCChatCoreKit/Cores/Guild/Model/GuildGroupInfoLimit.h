//
//  GuildGroupInfoLimit.h
//  XCChatCoreKit
//
//  Created by lvjunhang on 2019/1/17.
//  Copyright © 2019 KevinWang. All rights reserved.
//

#import "BaseObject.h"

NS_ASSUME_NONNULL_BEGIN

@interface GuildGroupInfoLimit : BaseObject
@property (nonatomic, assign) NSUInteger publicMax;//公开群聊上限
@property (nonatomic, assign) NSUInteger privateMax;//内部群聊上限
@property (nonatomic, assign) NSUInteger memberMax;//群聊人数上限
@end

NS_ASSUME_NONNULL_END
