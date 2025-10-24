//
//  CommunityCommentInfo.h
//  XCChatCoreKit
//
//  Created by KevinWang on 2019/2/28.
//  Copyright © 2019 YiZhuan. All rights reserved.
//
/** 社区评论列表模型*/

#import "BaseObject.h"

typedef enum : NSUInteger {
    CommunityWorksCommentType_Works=1,//评论作品
    CommunityWorksCommentType_Comment,//对评论回复
    CommunityWorksCommentType_Reply,//对回复回复
} CommunityWorksCommentType;

NS_ASSUME_NONNULL_BEGIN

@interface CommunityCommentInfo : BaseObject

/** 评论id*/
@property (nonatomic, copy) NSString *ID;
/** 回复类型*/
@property (nonatomic, assign) CommunityWorksCommentType type;
/** 作品用户uid*/
@property (nonatomic, assign) long worksUid;
/** 评论用户uid*/
@property (nonatomic, assign) long uid;
/** 评论用户昵称 */
@property (nonatomic, copy) NSString *nick;
/** 评论用户头像*/
@property (nonatomic, copy) NSString *avatar;
/** 目标用户uid*/
@property (nonatomic, assign) long targetUid;
/** 目标用户昵称*/
@property (nonatomic, copy) NSString *targetNick;
/** 内容*/
@property (nonatomic, copy) NSString *content;
/** 作品id*/
@property (nonatomic, copy) NSString *worksId;
/** 父评论id*/
@property (nonatomic, copy) NSString *parentId;
/** 创建时间*/
@property (nonatomic, copy) NSString *createTime;
/** 是否作者*/
@property (nonatomic, assign) BOOL isAuthor;
/** 是否已点赞*/
@property (nonatomic, assign) BOOL isLike;
/** 点赞数量*/
@property (nonatomic, assign) int likeCount;
/** 回复数量*/
@property (nonatomic, assign) int replyCount;
/** 回复列表*/
@property (nonatomic, strong) NSArray<CommunityCommentInfo *> *replies;

/** 本地属性:回复列表*/
@property (nonatomic, strong) NSMutableArray *repliyComments;

/** 本地属性:弹幕长度*/
@property (assign , nonatomic) CGFloat brrageWidth;

@end


@interface CommunityPublishCommentInfo : BaseObject

/** 作品id*/
@property (nonatomic, copy) NSString *worksId;
/** 父评论id，回复评论时需要*/
@property (nonatomic, copy) NSString *pCommentId;
/** 内容*/
@property (nonatomic, copy) NSString *content;
/** 评论对象，作品/评论/回复的发布人*/
@property (nonatomic, assign) long targetUid;
/** AT用户，可能有多个*/
@property (nonatomic, strong) NSString *atUids;
/** 回复类型*/
@property (nonatomic, assign) CommunityWorksCommentType worksCommentType;
@end


NS_ASSUME_NONNULL_END
