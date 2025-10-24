//
//  CommunityCore.h
//  XCChatCoreKit
//
//  Created by KevinWang on 2019/2/14.
//  Copyright © 2019 YiZhuan. All rights reserved.
//
/** 社区Core*/

#import "BaseCore.h"
#import "CommunityPublishInfo.h"
#import "CommunityCommentInfo.h"
#import "CommunityInfo.h"

NS_ASSUME_NONNULL_BEGIN

//消息类型. 1-点赞，2-At，3-评论

typedef NS_ENUM(NSUInteger, CommunityAboutMEType) {
    CommunityAboutMEType_Praise = 1,//赞
    CommunityAboutMEType_AT = 2,//提到
    CommunityAboutMEType_Discuss = 3,//评论
};

@interface CommunityCore : BaseCore

/** 是否显示弹幕*/
@property (nonatomic, assign) BOOL isShowDanMu;



/** 校验用户是否拥有发布权限*/
- (RACSignal *)requestUserPublishPermission;




/** 随机获取一个作品*/
- (void)requestCommunityWorksRandomWorks;

/**
 根据id获取社区作品
 @param worksId 作品id
 */
- (void)requestCommunityWorksWithWorksID:(NSString *)worksId;


/*
 自增作品播放量接口 works/play(POST)
 
 @param worksId 作品id
 */
- (void)reportCommunityWorksPlay:(NSString *)worksId;


/**
 点赞/取消点赞
 @param communityInfo 作品
 */
- (void)requestCommunityWorksLikeWorksByCommunityInfo:(CommunityInfo *)communityInfo className:(NSString *)className;


/**
 评论列表:works/comment/list(GET)
 @param worksId    作品Id
 @param page       页码
 @param state 0 结束头部刷新。  1 结束底部刷新
 */
- (void)requestCommunityWorksCommentListByWorksID:(NSString *)worksId page:(int)page state:(int)state;

/**
 评论作品:works/comment/save(POST)
 @param publishCommentInfo    评论模型
 */
- (void)publishCommunityWorksCommentByPublishCommentInfo:(CommunityPublishCommentInfo *)publishCommentInfo;

/**
 点赞评论:works/comment/like(POST)
 @param commentInfo 评论模型
 @param indexPath 位置
 */
- (void)requestCommunityWorksLikeCommentByCommentInfo:(CommunityCommentInfo *)commentInfo indexPath:(NSIndexPath *)indexPath;

/**
 删除评论:works/comment/del(POST)
 @param targetUid 删除人uid，可能是作品
 @param commentId 评论id
 */
- (void)requestCommunityWorksDeleteComment:(UserID)targetUid commentId:(NSString *)commentId;

/**
 获取回复列表:works/comment/reply/list(get)
 @param commentId    评论id（主评论）    是    [string]
 @param page    页码    是    [int]
 @param size    数量    是    [int]
 @param state 0 结束头部刷新。  1 结束底部刷新
 */
- (void)requestCommunityWorksCommentListByCommentId:(NSString *)commentId page:(int)page size:(int)size state:(int)state;






/** 背景音乐接口*/
- (void)requestCommunityBackgroundMusicGroup;

/**
 获取指定分类的背景音乐列表
 @param catalogId 分类id
 @param page 页码
 @param state 0 结束头部刷新。  1 结束底部刷新
 */
- (void)requestCommunityBackgroundMusicByCatalogId:(NSString *)catalogId page:(int)page state:(int)state;





/**
 社区作品发布
 @param publishInfo 发布模型
 */
- (void)publishCommunityWorksByCommunityPublishInfo:(CommunityPublishInfo *)publishInfo;




/*统计用户的作品数和点赞数
 @param targetUid 目标用户uid
 */
- (RACSignal *)requestCommunityUserTotalTargetUid:(NSString*)targetUid;



/*关注 多个用户
 @param targetUids 目标用户uid    是    [array]
 */
- (RACSignal *)requestCommunityFollowUserTargetUids:(NSArray<NSString *> *)targetUids;

/**
 随机 获取可以关注的用户
 @param size 当前页
 */
- (void)requestCommunityFollowUserSize:(int)size;

/**
 获取 关注 用户的 社区作品 列表

 @param page 当前页数
 @param pageSize 每一页的数量
 @param state 加载状态 上啦 下啦
 */
- (void)requestCommunityFollowUserProductPage:(int)page  pageSize:(int)pageSize state:(int)state;



/**
 获取用户的 社区作品 列表

 @param targetuid 需要获取的用户uid
 @param page 当前页数
 @param pageSize 每一页的数量
 @param state 加载状态 上啦 下啦
 */
- (void)requestCommunityUserProductWithTargetUid:(UserID)targetuid page:(int)page  pageSize:(int)pageSize state:(int)state;

/**
 获取用户 点赞/喜欢  社区作品列表
 
 @param targetUid 要获取的用户
 @param page 当前页
 @param pageSize 每一页的数量
 @param state 加载状态
 */

- (void)requestCommunityUserLikeListWithTargetUid:(UserID)targetUid page:(int)page pageSize:(int)pageSize state:(int)state;

/**
 根据类型 获取 社区 消息
 
 @param type 消息类型. 1-点赞，2-At，3-评论
 @param page 当前页码
 @param pageSize 每页数量
 @param state 加载状态
 */

- (void)requestCommunityMessageListWithType:(int)type page:(int)page pageSize:(int)pageSize state:(int)state;


/**
 弹幕列表
 @param worksId 作品ID
 
 */
- (RACSignal *)requestCommunityCommentBarrageListWithWorksId:(NSString *)worksId;

/**
 获取消息计数器 
 */
- (RACSignal *)requestCommunitycounter;
/**
  删除作品
 */
- (RACSignal *)requestCommunityDeleteWorksId:(NSString *)worksId;

@end


NS_ASSUME_NONNULL_END
