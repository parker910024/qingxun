//
//  UserLittleWorld.h
//  XCChatCoreKit
//
//  Created by lvjunhang on 2019/11/25.
//  Copyright © 2019 YiZhuan. All rights reserved.
//  用户信息-小世界

#import "BaseObject.h"

NS_ASSUME_NONNULL_BEGIN

@interface UserLittleWorld : BaseObject
@property (nonatomic, copy) NSString *worldId;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *icon;
@end

NS_ASSUME_NONNULL_END
