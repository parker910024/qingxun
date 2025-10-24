//
//  GuildChatGroupAllMemberResponse.h
//  XCChatCoreKit
//
//  Created by lee on 2019/1/18.
//  Copyright © 2019 KevinWang. All rights reserved.
//

#import "BaseObject.h"

NS_ASSUME_NONNULL_BEGIN

@interface GuildChatGroupAllMemberResponse : BaseObject

/** 管理员数量 */
@property (nonatomic, copy) NSString *managerCount;
/** 群聊成员列表 */
@property (nonatomic, copy) NSArray *members;
/** 成员数量 */
@property (nonatomic, copy) NSString *count;
/** 已静音数量 */
@property (nonatomic, copy) NSString *muteCount;

@end

NS_ASSUME_NONNULL_END
