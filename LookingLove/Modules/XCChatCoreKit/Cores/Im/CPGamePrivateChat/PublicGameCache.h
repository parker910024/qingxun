//
//  PublicGameCache.h
//  XCChatCoreKit
//
//  Created by new on 2019/2/22.
//  Copyright © 2019 KevinWang. All rights reserved.
//

#import "BaseObject.h"
#import <YYCache.h>
#import <NIMSDK/NIMSDK.h>
NS_ASSUME_NONNULL_BEGIN


@interface PublicGameCache : BaseObject

+ (instancetype)sharePublicGameCache;

// 储存消息
- (void)saveGameInfo:(NIMMessage *)message;

// 修改消息
- (void)changeGameInfo:(NIMMessage *)message;

//  查询消息
- (NIMMessage *)selectGameInfo:(NSString *)messageID;

// 单独储存我自己发的消息
- (void)saveGameMessageFromMeInfo:(NSDictionary *)messageDic;

// 取出我自己的发的消息
- (NSDictionary *)takeOutMyOwnMessagesWithUid:(NSString *)uid;
@end

NS_ASSUME_NONNULL_END
