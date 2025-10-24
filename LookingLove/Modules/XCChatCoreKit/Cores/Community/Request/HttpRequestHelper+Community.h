//
//  HttpRequestHelper+Community.h
//  XCChatCoreKit
//
//  Created by KevinWang on 2019/2/14.
//  Copyright © 2019 YiZhuan. All rights reserved.
//
/** 社区HttpRequest*/

#import "HttpRequestHelper.h"
#import "CommunityInfo.h"
#import "CommunityCommentInfo.h"
#import "CommunityMusicInfo.h"
#import "CommunityPublishInfo.h"

#import "CommunityProductInfo.h"
#import "CommunityMessageInfo.h"
#import "UserInfo.h"


NS_ASSUME_NONNULL_BEGIN

@interface HttpRequestHelper (Community)

/** 校验用户是否拥有发布权限*/
+ (void)requestUserPublishPermissionSuccess:(void (^)(BOOL hasPermission))success
                                    failure:(void (^)(NSNumber *resCode, NSString *message))failure;



/**
 随机获取一个作品
 */
+ (void)requestCommunityWorksRandomWorksSuccess:(void (^)(NSArray<CommunityInfo *> *))success
                                   failure:(void (^)(NSNumber *resCode, NSString *message))failure;

/**
 根据id获取社区作品
 @param worksId 作品id
 */
+ (void)requestCommunityWorksWithWorksID:(NSString *)worksId
                            success:(void (^)(CommunityInfo *))success
                            failure:(void (^)(NSNumber *resCode, NSString *message))failure;





/**
 自增作品播放量接口 works/play(POST)
 @param worksId 作品id
 */
+ (void)reportCommunityWorksPlayWithWorksID:(NSString *)worksId
                                    success:(void (^)(BOOL isSucess))success
                                    failure:(void (^)(NSNumber *resCode, NSString *message))failure;


/**
 点赞/取消点赞
 @param worksId 作品id
 */
+ (void)requestCommunityWorksLikeWorksByWorksId:(NSString *)worksId
                                        success:(void (^)(BOOL success))success
                                        failure:(void (^)(NSNumber *resCode, NSString *message))failure;




/**
 评论列表:works/comment/list(GET)
 @param worksId    作品Id
 @param page       页码
 */
+ (void)requestCommunityWorksCommentListByWorksID:(NSString *)worksId
                                             page:(int)page
                                          success:(void (^)(NSArray<CommunityCommentInfo *> *))success
                                          failure:(void (^)(NSNumber *resCode, NSString *message))failure;

/**
 评论作品:works/comment/save(POST)
 @param publishCommentInfo    评论模型
 */
+ (void)publishCommunityWorksCommentByPublishCommentInfo:(CommunityPublishCommentInfo *)publishCommentInfo
                                                 success:(void (^)(CommunityCommentInfo * commentInfo))success
                                                 failure:(void (^)(NSNumber *resCode, NSString *message))failure;
/**
 点赞评论:works/comment/like(POST)
 @param commentId 评论id
 */
+ (void)requestCommunityWorksLikeCommentByCommentId:(NSString *)commentId
                                            success:(void (^)(BOOL success))success
                                            failure:(void (^)(NSNumber *resCode, NSString *message))failure;

/**
 删除评论:works/comment/del(POST)
 @param commentId 评论id
 @param targetUid 删除人uid，可能是作品
 */
+ (void)requestCommunityWorksDeleteComment:(UserID)targetUid
                                 commentId:(NSString *)commentId
                                   success:(void (^)(BOOL success))success
                                   failure:(void (^)(NSNumber *resCode, NSString *message))failure;

/**
 获取回复列表:works/comment/reply/list(get)
 @param commentId    评论id（主评论）    是    [string]
 @param page    页码    是    [int]
 @param size    数量    是    [int]
 @param state 0 结束头部刷新。  1 结束底部刷新
 */
+ (void)requestCommunityWorksCommentListByCommentId:(NSString *)commentId
                                               page:(int)page
                                               size:(int)size
                                            success:(void (^)(NSArray<CommunityCommentInfo *> *))success
                                            failure:(void (^)(NSNumber *resCode, NSString *message))failure;





/** 背景音乐接口*/
+ (void)requestCommunityBackgroundMusicGroupSuccess:(void (^)(NSArray<CommunityMusicData *> *))success
                                            failure:(void (^)(NSNumber *resCode, NSString *message))failure;

/**
 获取指定分类的背景音乐列表
 @param catalogId 分类id
 @param page 页码
 */
+ (void)requestCommunityBackgroundMusicByCatalogId:(NSString *)catalogId
                                              page:(int)page
                                           success:(void (^)(NSArray<CommunityMusicInfo *> *))success
                                           failure:(void (^)(NSNumber *resCode, NSString *message))failure;






/**
 社区作品发布
 @param publishInfo 发布信息
 */
+ (void)publishCommunityWorksByCommunityPublishInfo:(CommunityPublishInfo *)publishInfo
                                            success:(void (^)(BOOL success))success
                                            failure:(void (^)(NSNumber *resCode, NSString *message))failure;




/**
 统计用户的作品数和点赞数
 @param targetUid 目标用户uid
 @param success 成功的返回
 @param failure 失败
 */
+ (void)requestCommunityUserTotalTargetUid:(NSString *)targetUid
                                   success:(void (^)(NSString *likeCount, NSString *worksCount))success
                                   failure:(void (^)(NSNumber *resCode, NSString *message))failure;


/**
 关注 多个用户
 @param targetUids 目标用户uid    是    [array]
 @param success 成功的返回
 @param failure 失败
 */
+ (void)requestCommunityFollowUserTargetUids:(NSArray<NSString *>*)targetUids
                               success:(void (^)(BOOL success))success
                               failure:(void (^)(NSNumber *resCode, NSString *message))failure;


/**
 随机 获取可以关注的用户
 @param size 当前页
 @param success 成功的返回
 @param failure 失败
 */
+ (void)requestCommunityFollowUserSize:(int)size
                               success:(void (^)(NSArray<UserInfo *> *userArray))success
                               failure:(void (^)(NSNumber *resCode, NSString *message))failure;


/**
 获取关注的 用户社区作品列表
 @param page 当前页
 @param pageSize 每一页的数量
 @param success 成功的返回
 @param failure 失败
 */
+ (void)requestCommunityFollowUserProductListPage:(int)page
                                            pageSize:(int)pageSize
                                             success:(void (^)(NSArray<CommunityInfo *> *productArray))success
                                             failure:(void (^)(NSNumber *resCode, NSString *message))failure;

/**
 获取用户社区作品列表

 @param targetUid 要获取的用户
 @param page 当前页
 @param pageSize 每一页的数量
 @param success 成功的返回
 @param failure 失败
 */
+ (void)requestCommunityUserProductListWithTargetUid:(UserID)targetUid
                                                page:(int)page
                                            pageSize:(int)pageSize
                                             success:(void (^)(NSArray<CommunityProductInfo *> *productArray))success
                                             failure:(void (^)(NSNumber *resCode, NSString *message))failure;

/**
 获取用户 点赞/喜欢  社区作品列表
 
 @param targetUid 要获取的用户
 @param page 当前页
 @param pageSize 每一页的数量
 @param success 成功的返回
 @param failure 失败
 */
+ (void)requestCommunityUserLikeListWithTargetUid:(UserID)targetUid
                                             page:(int)page
                                         pageSize:(int)pageSize
                                          success:(void (^)(NSArray<CommunityProductInfo *> * _Nonnull))success
                                          failure:(void (^)(NSNumber * _Nonnull, NSString * _Nonnull))failure;

/**
 根据类型 获取 社区 消息
 
 @param type 消息类型. 1-点赞，2-At，3-评论
 @param page 当前页码
 @param pageSize 每页数量
 @param success 成功
 @param failure 失败
 */
+ (void)requestCommunityMessageListWithType:(int)type
                                       page:(int)page
                                   pageSize:(int)pageSize
                                    success:(void (^)(NSArray<CommunityMessageInfo *> * _Nonnull))success
                                    failure:(void (^)(NSNumber * _Nonnull, NSString * _Nonnull))failure;



/**
 弹幕列表
 @param worksId 作品ID

 */

+ (void)requestCommunityCommentBarrageListWithWorksId:(NSString *)worksId
                                              success:(void (^)(NSArray<CommunityCommentInfo *> *))success
                                              failure:(void (^)(NSNumber *resCode, NSString *message))failure;

/**
 获取消息计数器
 */

+ (void)requestCommunitycounterSuccess:(void (^)(NSDictionary *dic))success
                               failure:(void (^)(NSNumber *resCode, NSString *message))failure;

/**
 删除作品
 
 @param worksId 作品id
 @param success 成功
 @param failure failure
 */
+ (void)requestCommunityDeleteWorksId:(NSString *)worksId
                              success:(void (^)(BOOL success))success
                              failure:(void (^)(NSNumber *resCode, NSString *message))failure;
@end

NS_ASSUME_NONNULL_END
