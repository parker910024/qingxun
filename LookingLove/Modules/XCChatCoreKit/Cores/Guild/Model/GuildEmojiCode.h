//
//  GuildEmojiCode.h
//  XCChatCoreKit
//
//  Created by lee on 2019/2/27.
//  Copyright © 2019 KevinWang. All rights reserved.
//

#import "BaseObject.h"

NS_ASSUME_NONNULL_BEGIN
@interface GuildEmojiCode : BaseObject<NSCoding>
/** 用户 uid */
@property (nonatomic, assign) UserID uid;
/** 公会模厅 id */
@property (nonatomic, copy) NSString *hallId;
/** emoji 邀请码 */
@property (nonatomic, copy) NSString *emojiCode;
/** 失效时间，拼接好的字符串     */
@property (nonatomic, copy) NSString *expireDateStr;
/** 失效时间戳     */
@property (nonatomic, copy) NSString *expireDate;
/** 分享内容     */
@property (nonatomic, copy) NSString *shareContent;
@end

NS_ASSUME_NONNULL_END
