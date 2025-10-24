//
//  DynamicMessageUnread.h
//  XCChatCoreKit
//
//  Created by lvjunhang on 2019/11/28.
//  Copyright © 2019 YiZhuan. All rights reserved.
//  动态消息未读

#import "BaseObject.h"

NS_ASSUME_NONNULL_BEGIN

@interface DynamicMessageUnread : BaseObject
/// 总计未读消息数
@property (nonatomic, assign) NSInteger total;
/// 评论未读消息数
@property (nonatomic, assign) NSInteger comment;
/// 分享未读消息数
@property (nonatomic, assign) NSInteger share;
/// 回复未读消息数
@property (nonatomic, assign) NSInteger reply;
/// 点赞未读消息数
@property (nonatomic, assign) NSInteger like;
@end

NS_ASSUME_NONNULL_END
