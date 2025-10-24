//
//  PraiseCore.h
//  BberryCore
//
//  Created by chenran on 2017/5/18.
//  Copyright © 2017年 chenran. All rights reserved.
//

#import "BaseCore.h"

@class UserInfo;
@interface PraiseCore : BaseCore
//关注
- (void) praise:(UserID)paiseUid bePraisedUid:(UserID)bePraisedUid;
- (void)praise:(UserID)paiseUid bePraisedUid:(UserID)bePraisedUid completion:(void(^_Nonnull)(BOOL success, NSNumber * _Nullable code, NSString * _Nullable msg))completion;

//取消关注
- (void) cancel:(UserID)cancelUid beCanceledUid:(UserID)beCanceledUid;
- (void) cancel:(UserID)cancelUid beCanceledUid:(UserID)beCanceledUid beOperation:(UserInfo *)info;

//delete
- (void) deleteFriend:(UserID)deleteUid beDeletedUid:(UserID)beDeletedUid;
//获取关注列表
- (void) requestAttentionListState:(int)state page:(int)page PageSize:(int)pageSize;

// 首页获取关注列表的方法，要区别开上面的方法，避免主页点击更多进入二级页面会通知主页刷新
- (void) requestAttentionForGamePageListState:(int)state page:(int)page PageSize:(int)pageSize;

//获取粉丝列表
- (void) requestFansListState:(int)state page:(NSInteger)page;
//判断是否关注某人
- (void) isLike:(UserID)uid isLikeUid:(UserID)isLikeUid;

// 判断是否关注某人
- (void) isUid:(UserID)uid isLikeUid:(UserID)isLikeUid success:(void (^)(BOOL isLike))success;

- (RACSignal *)rac_queryIsLike:(UserID)uid isLikeUid:(UserID)isLikeUid;
- (RACSignal *)rac_praise:(UserID)praiseUid WithBePraisedUid:(UserID)bePraisedUid;
- (RACSignal *)rac_cancel:(UserID)cancelUid beCanceledUid:(UserID)beCanceledUid;


/**
 获取未读列表 点赞列表
 @param uid uid
 @param tpye 类型 0, 评论 1，点赞
 */
- (void) requestUnReadListType:(int)type;

/**
 清除消息
 
 @param tpye 类型 0, 评论 1，点赞
 */
- (void)requestUnReadClearListTpye:(int)type;

/**
 获取未读数量
 */
- (void)requestUnReadCount;

/**
 查询评论历史消息
 
 @param type 类型 0, 评论 1，点赞
 @param page 页数
 */
- (void) requestHistoryListTpye:(int)type
                           page:(NSInteger)page
                        minDate:(NSInteger)minDate;
@end
