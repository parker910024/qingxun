//
//  CommunityCoreClient.h
//  XCChatCoreKit
//
//  Created by KevinWang on 2019/2/14.
//  Copyright © 2019 YiZhuan. All rights reserved.
//
/** 社区CoreClient*/

#import <Foundation/Foundation.h>
#import "CommunityInfo.h"
#import "CommunityProductInfo.h"
#import "CommunityMessageInfo.h"
#import "CommunityCommentInfo.h"
#import "UserID.h"
#import "UserInfo.h"
NS_ASSUME_NONNULL_BEGIN

@protocol CommunityCoreClient <NSObject>

/** 根据id获取社区作品*/
- (void)onRequestCommunityWorksWithWroksIDSuccess:(CommunityInfo *)communityInfo;
- (void)onRequestCommunityWorksWithWroksIDFailth:(NSString *)msg;
/** 随机获取一个作品*/
- (void)onRequestCommunityWorksRandomWorksSuccess:(NSArray<CommunityInfo *> *)infoList;
- (void)onRequestCommunityWorksRandomWorksFailth:(NSString *)msg;

/** 弹幕状态改变*/
- (void)onCommunityWorksDanMuStatuUpdate:(BOOL)isShowDanMu;

/**点赞/取消点赞*/
- (void)onRequestCommunityWorksLikeWorksSuccess:(CommunityInfo *)communityInfo className:(NSString *)className;
- (void)onRequestCommunityWorksLikeWorksFailth:(NSString *)msg className:(NSString *)className;

/** 评论列表*/
- (void)onRequestCommunityWorksCommentListSussceState:(int)state page:(int)page commentList:(NSArray *)commentList;
- (void)onRequestCommunityWorksCommentListFailthState:(int)state page:(int)page message:(NSString *)message;
/** 评论作品*/
- (void)onPublishCommunityWorksCommentSuccess:(CommunityCommentInfo *)commentInfo worksCommentType:(CommunityWorksCommentType)worksCommentType;
- (void)onPublishCommunityWorksCommentFailth:(NSString *)msg;
/** 点赞评论*/
- (void)onRequestCommunityWorksLikeCommentSuccess:(CommunityCommentInfo *)commentInfo indexPath:(NSIndexPath *)indexPath;
- (void)onRequestCommunityWorksLikeCommentFailth:(NSString *)msg;
/** 删除评论*/
- (void)onRequestCommunityWorksDeleteCommentSuccess;
- (void)onRequestCommunityWorksDeleteCommentFailth:(NSString *)msg;
/** 获取回复列表
 @param state 0 结束头部刷新;  1 结束底部刷新
 @param replyList 回复列表
 */
- (void)requestCommunityWorksCommentListSuccessState:(int)state replyList:(NSArray *)replyList;
- (void)requestCommunityWorksCommentListFailthState:(int)state message:(NSString *)message;


/** 背景音乐接口*/
- (void)onRequestCommunityBackgroundMusicGroupSuccess:(NSArray *)musicGroupList;
- (void)onRequestCommunityBackgroundMusicGroupFailth:(NSString *)message;
/** 获取指定分类的背景音乐列表
 @param state 0 结束头部刷新;  1 结束底部刷新
 @param musicList 音乐列表
 */
- (void)onRequestCommunityBackgroundMusicSuccessState:(int)state musicList:(NSArray *)musicList;
- (void)onRequestCommunityBackgroundMusicFailthState:(int)state message:(NSString *)message;



/** 社区作品发布*/
- (void)onPublishCommunityWorksSuccess;
- (void)onPublishCommunityWorksFailth:(NSString *)msg;




/**
  随机获取  关注 用户
 @param size 大小
 @param state 加载的状态 下啦 上啦
 */
- (void)onRequestCommunityFollowUserSize:(int)size success:(NSArray<UserInfo *> *)userArray;
- (void)onRequestCommunityFollowUserSizeFailth:(NSString *)msg;



/**
 获取关注 用户社区作品列表成功
 @param page 当前页
 @param state 加载的状态 下啦 上啦
 */
- (void)onRequestCommunityFollowUserProductListPage:(int)page  state:(int)state  success:(NSArray<CommunityInfo *> *)productArray;
- (void)onRequestCommunityFollowUserProductListfailth:(NSString *)msg;



/**
 获取用户社区作品列表成功
 
 @param targetUid 要获取的用户
 @param page 当前页
 @param state 加载的状态 下啦 上啦
 */
- (void)onRequestCommunityUserProductListTargetUid:(UserID)targetUid page:(int)page state:(int)state  success:(NSArray<CommunityProductInfo *> *)productArray;
- (void)onRequestCommunityUserProductListTargetUid:(UserID)targetUid failth:(NSString *)msg;

/**
 获取用户 点赞/喜欢  社区作品列表
 
 @param targetUid 要获取的用户
 @param page 当前页
 @param pageSize 每一页的数量
 @param state 加载状态
 */
- (void)onRequestCommunityUserLikeListTargetUid:(UserID)targetUid page:(int)page state:(int)state  success:(NSArray<CommunityProductInfo *> *)productArray;
- (void)onRequestCommunityUserLikeListTargetUid:(UserID)targetUid failth:(NSString *)msg;

/**
 根据类型 获取 社区 消息
 
 @param type 消息类型. 1-点赞，2-At，3-评论
 @param page 当前页码
 @param state 加载状态
 
 */
- (void)requestCommunityMessageListWithType:(int)type page:(int)page state:(int)state  success:(NSArray<CommunityMessageInfo *> *)messageInfoArray;
- (void)requestCommunityMessageListWithType:(int)type failth:(NSString *)msg;



@end

NS_ASSUME_NONNULL_END
