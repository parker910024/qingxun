//
//  PraiseCoreClient.h
//  BberryCore
//
//  Created by chenran on 2017/5/18.
//  Copyright © 2017年 chenran. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Attention.h"

@class UserInfo;

@protocol PraiseCoreClient <NSObject>

@optional
//关注
- (void) onPraiseSuccess:(UserID)uid;
- (void) onPraiseFailth:(NSString *)msg;
//取消关注
- (void) onCancelSuccess:(UserID)uid;
- (void) onCancelFailth:(NSString *)msg;
- (void) onCancelSuccess:(UserID)uid beOperation:(UserInfo *)info;

- (void) onDeleteFriendSuccess:(UserID)uid;
- (void) onDeleteFriendFailth:(NSString *)msg;
//关注列表
- (void) onRequestAttentionListState:(int)state success:(NSArray *)attentionList;
- (void) onRequestAttentionListState:(int)state failth:(NSString *)msg;

// 首页关注列表
- (void) onRequestAttentionListStateForGamePage:(int)state success:(NSArray *)attentionList;

- (void) onRequestIsLikeSuccess:(BOOL)isLike islikeUid:(UserID)islikeUid;
- (void) onRequestIsLikeFailth:(NSString *)msg;

//粉丝列表
- (void) onRequestFansListState:(int)state success:(NSArray *)fansList;
- (void) onRequestFansListState:(int)state failth:(NSString *)msg;


// 未读评论 1，点赞列表
- (void) onRequestUnReadListSuccess:(NSArray *)lists;
- (void) onRequestUnReadListFailth:(NSString *)msg;

//清空评论点赞列表
- (void) requestUnReadClearListSuccess;
- (void) requestUnReadClearListFailth:(NSString *)msg;

//获取未读消息总数
- (void) requestUnReadCountTpyeSuccess:(int)likeCount withCommentCount:(int)commentCount;
- (void) requestUnReadCountFailth:(NSString *)msg;


// 历史消息评论 1，点赞列表
- (void) onRequestHistoryListSuccess:(NSArray *)lists;
- (void) onRequestHistoryListFailth:(NSString *)msg;



@end
