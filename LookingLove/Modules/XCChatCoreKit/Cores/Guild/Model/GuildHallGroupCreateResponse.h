//
//  GuildHallGroupCreateResponse.h
//  XCChatCoreKit
//
//  Created by lvjunhang on 2019/1/10.
//  Copyright © 2019年 KevinWang. All rights reserved.
//  创建群聊返回数据解析模型

#import "BaseObject.h"

NS_ASSUME_NONNULL_BEGIN

@interface GuildHallGroupCreateResponse : BaseObject

/**
 云信的群聊唯一id
 */
@property (nonatomic, copy) NSString *tid;

/**
 群聊id
 */
@property (nonatomic, assign) long long chatId;

@end

NS_ASSUME_NONNULL_END
