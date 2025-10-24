//
//  NormalRoomGameCache.h
//  XCChatCoreKit
//
//  Created by new on 2019/3/18.
//  Copyright © 2019 YiZhuan. All rights reserved.
//

#import "BaseObject.h"
#import <YYCache.h>
NS_ASSUME_NONNULL_BEGIN

@interface NormalRoomGameCache : BaseObject

+ (instancetype)shareNormalGameCache;


//  多人房游戏消息 单独储存我自己发的消息
- (void)saveGameMessageFromMeInfo:(NSDictionary *)messageDic;

//  多人房游戏消息   删除掉我自己已经发送的失效的消息
- (void)removeGameMessageFromMeInfo:(NSDictionary *)messageDic;

// 取出我自己的发的消息
- (NSDictionary *)takeOutMyOwnMessagesWithUid:(NSString *)uid;

@end

NS_ASSUME_NONNULL_END
