//
//  RoomEnterGreeting.h
//  XCChatCoreKit
//
//  Created by lvjunhang on 2020/3/28.
//  Copyright © 2020 YiZhuan. All rights reserved.
//  进房欢迎语

#import "BaseObject.h"

NS_ASSUME_NONNULL_BEGIN

@interface RoomEnterGreeting : BaseObject
@property (nonatomic, assign) BOOL isFans;//toUid 是否为当前用户的粉丝
@property (nonatomic, copy) NSString *msg;//欢迎语，${nick}为昵称占位符，”欢迎${nick}进入房间“
@property (nonatomic, copy) NSString *toUid;//接收方uid，与请求参数toUid相同

@end

NS_ASSUME_NONNULL_END
