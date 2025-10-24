//
//  CPBindCore.h
//  UKiss
//
//  Created by apple on 2018/9/29.
//  Copyright © 2018年 yizhuan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseCore.h"
@class CTCommentReplyModel;

NS_ASSUME_NONNULL_BEGIN

@interface DynamicCommentCore : BaseCore


/**
 请求评论列表

 @param uid uid
 @param dynamicId 动态id
 @param pageNum 页数

 */
- (void)requestCommentListWithUid:(NSString *)uid dynamicId:(long)dynamicId pageNum:(NSInteger)pageNum;


/**
 评论接口

 @param uid uid
 @param dynamicId 动态id
 @param content 评论内容
 */
- (void)requestAddCommentWithUid:(NSString *)uid dynamicId:(long)dynamicId content:(NSString *)content;

/**
 删除评论接口

 @param uid uid
 @param dynamicId 动态id
 @param commentId 评论id
 @param sender 谁请求的
 @param type 1评论2回复

 */
- (void)requestDeleteCommentWithUid:(NSString *)uid dynamicId:(long)dynamicId commentId:(long )commentId type:(int)type sender:(id)sender;


/**
 回复评论接口

 @param uid uid
 @param dynamicId 动态id
 @param toUid 回复的目标用户uid
 @param content 评论内容
 @param commentId 评论id
 @param type 0表示回复“回复” 1表示回复“评论”

 */
- (void)requestReplyCommentWithUid:(NSString *)uid
                         dynamicId:(long)dynamicId
                             toUid:(long)toUid
                           content:(NSString *)content
                         commentId:(long )commentId
                              type:(int)type;

/**
 查询单个评论、回复 详情

 @param uid uid
 @param dynamicId 动态id
 @param commentId 评论id
 */
- (void)requestCommentDetailsWithUid:(NSString *)uid dynamicId:(long)dynamicId commentId:(long )commentId;


/**
 某个评论的回复列表

 @param uid uid
 @param commentId 评论id
 */
- (void)requestCommentReplyListWithUid:(NSString *)uid commentId:(long)commentId dynamicId:(long)dynamicId start:(NSInteger)start ID:(long)ID;

/**
 举报动态、评论、回复
 
 @param formUid 举报人uid
 @param toUid 被举报人uid
 @param toCommenId 被举报评论（回复）id
 @param reportContent 举报分类文本
 @param sender 谁请求的
 */
- (void)requestReportPushWithFormUid:(NSString *)formUid
                                    toUid:(NSString *)toUid
                               toCommenId:(long)toCommenId
                       reportContent:(NSString *)reportContent sender:(id)sender;


/**
 获取举报的分类
 
 @param uid uid
 @param sender 谁请求的
 */
- (void)requestReportGetTypeWithUid:(NSString *)uid sender:(id)sender;



@end

NS_ASSUME_NONNULL_END
