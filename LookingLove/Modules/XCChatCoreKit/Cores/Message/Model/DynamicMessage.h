//
//  DynamicMessage.h
//  XCChatCoreKit
//
//  Created by lvjunhang on 2019/11/28.
//  Copyright © 2019 YiZhuan. All rights reserved.
//  动态消息列表模型

#import "BaseObject.h"

NS_ASSUME_NONNULL_BEGIN

@class DynamicMessageRes;

@interface DynamicMessage : BaseObject
@property (nonatomic, assign) NSInteger targetId;//msgType为2时为评论id
@property (nonatomic, copy) NSString *worldName;
@property (nonatomic, assign) NSInteger type;//类型 0：纯文本，1:语音，2图片，3视频
@property (nonatomic, copy) NSString *content;//动态内容
@property (nonatomic, assign) NSInteger gender;
@property (nonatomic, assign) NSInteger age;
@property (nonatomic, copy) NSString *dynamicId;//动态id
@property (nonatomic, copy) NSString *msgId;//消息id
@property (nonatomic, assign) NSInteger uid;
@property (nonatomic, assign) NSInteger actionType;//动作类型，1-评论,2-回复,3-点赞,4-分享
@property (nonatomic, copy) NSString *message;//消息，如"赞了你的动态"
@property (nonatomic, assign) NSInteger status;//状态，0-未读，1-已读
@property (nonatomic, assign) NSInteger msgType;//类型，1-动态，2-评论(回复也算评论)
@property (nonatomic, copy) NSString *worldId;
@property (nonatomic, copy) NSString *nick;
@property (nonatomic, copy) NSString *avatar;
@property (nonatomic, copy) NSString *targetUid;//目标对象uid
@property (nonatomic, copy) NSString *publishTime;//发布时间
@property (nonatomic, copy) NSString *dynamicUid;//动态发布者uid
@property (nonatomic, strong) DynamicMessageRes *dynamicRes;

@end

@interface DynamicMessageRes: NSObject
//@property (nonatomic, assign) NSInteger id;
@property (nonatomic, assign) NSInteger height;
@property (nonatomic, assign) NSInteger resDuration;
@property (nonatomic, assign) NSInteger width;
@property (nonatomic, copy) NSString *format;
@property (nonatomic, copy) NSString *resUrl;
@end

NS_ASSUME_NONNULL_END
