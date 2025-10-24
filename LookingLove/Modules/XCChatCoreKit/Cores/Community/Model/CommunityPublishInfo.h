//
//  CommunityPublishInfo.h
//  XCChatCoreKit
//
//  Created by KevinWang on 2019/2/28.
//  Copyright © 2019 YiZhuan. All rights reserved.
//
/** 发布作品参数对应模型*/

#import "BaseObject.h"

NS_ASSUME_NONNULL_BEGIN

@interface CommunityPublishInfo : BaseObject
/** 封面图*/
@property (nonatomic, copy) NSString *cover;
/** 作品地址*/
@property (nonatomic, copy) NSString *url;
/** 作品时长*/
@property (nonatomic, assign) int duration;
/** 相关联@的用户uid*/
@property (nonatomic, strong) NSString *atUids;
/** 是否公开*/
@property (nonatomic, assign) BOOL isPublic;
/** 用户地址*/
@property (nonatomic, copy) NSString *address;
/** 作品话题*/
@property (nonatomic, copy) NSArray *topics;
/** 作品内容*/
@property (nonatomic, copy) NSString *content;
/** 是否发布作品,否则保存至草稿箱 */
@property (nonatomic, assign) BOOL isSave;
@end

NS_ASSUME_NONNULL_END
