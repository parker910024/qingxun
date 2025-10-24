//
//  M80AttributedLabel+NIMKit.h
//  NIM
//
//  Created by chris.
//  Copyright (c) 2015 Netease. All rights reserved.
//

#import "NIMKitDependency.h"

@interface M80AttributedLabel (NIMKit)
- (void)nim_setText:(NSString *)text;

/// 动态回复评论
/// @param text 回复的消息内容
/// @param replyNickName 被回复人昵称 @XXX用户的昵称
- (void)nim_setText:(NSString *)text replyNickName:(NSString *)replyNickName;
@end
