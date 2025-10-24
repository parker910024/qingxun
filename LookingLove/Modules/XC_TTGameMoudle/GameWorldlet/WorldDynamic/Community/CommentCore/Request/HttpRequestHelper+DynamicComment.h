//
//  HttpRequestHelper+CPBind.h
//  UKiss
//
//  Created by apple on 2018/9/29.
//  Copyright © 2018年 yizhuan. All rights reserved.
//

#import "HttpRequestHelper.h"
@class CTCommentReplyModel;

NS_ASSUME_NONNULL_BEGIN
@interface HttpRequestHelper (DynamicComment)

/**
 请求动态评论列表

 @param uid uid
 @param dynamicId 动态id
 @param pageNum 页数
 @param success 成功回调
 @param failure 失败回调
 */
+ (void)requestCommentListWithUid:(NSString *)uid
                              dynamicId:(long)dynamicId
                              pageNum:(NSInteger)pageNum
                              Success:(void (^)(NSArray <CTCommentReplyModel *>* commentList ,int totalCount))success
                              failure:(void (^)(NSNumber *resCode, NSString *message))failure;

/**
 评论动态接口

 @param uid uid
 @param dynamicId 动态id
 @param content 评论文本
 @param success 成功回调
 @param failure 失败回调
 */
+ (void)requestAddCommentWithUid:(NSString *)uid
                        dynamicId:(long)dynamicId
                          content:(NSString *)content
                          Success:(void (^)(CTCommentReplyModel * commentModel))success
                          failure:(void (^)(NSNumber *resCode, NSString *message))failure;


/**
 删除评论/回复

 @param uid uid
 @param dynamicId 动态id
 @param commentId 评论id
 @param type  1评论2回复
 @param success 成功回调
 @param failure 失败回调
 */
+ (void)requestDeleteCommentWithUid:(NSString *)uid
                       dynamicId:(long)dynamicId
                         commentId:(long )commentId
                         type:(int)type
                         Success:(void (^)(void))success
                         failure:(void (^)(NSNumber *resCode, NSString *message))failure;

/**
 回复评论

 @param uid uid
 @param dynamicId 动态id
 @param toUid 回复的目标用户uid
 @param content 回复类容
 @param commentId 被回复的评论id
 @param type 0表示回复"回复" 1表示回复“评论"
 @param success 成功回调
 @param failure 失败回调
 */
+ (void)requestReplyCommentWithUid:(NSString *)uid
                         dynamicId:(long)dynamicId
                             toUid:(long)toUid
                           content:(NSString *)content
                         commentId:(long )commentId
                              type:(int)type
                           Success:(void (^)(CTCommentReplyModel * commentModel))success
                           failure:(void (^)(NSNumber *resCode, NSString *message))failure;

/**
 获取评论详情
 
 @param uid uid
 @param dynamicId 动态id
 @param commentId 评论id
 @param success 成功回调
 @param failure 失败回调
 */
+ (void)requestCommentDetailsWithUid:(NSString *)uid
                           dynamicId:(long)dynamicId
                           commentId:(long )commentId
                             Success:(void (^)(CTCommentReplyModel * commentModel))success
                             failure:(void (^)(NSNumber *resCode, NSString *message))failure;

/**
 请求回复列表

 @param uid uid
 @param commentId 评论id
 @param start 最后一条的创建时间
 @param success 成功回调
 @param failure 失败回调
 */
+ (void)requestCommentReplyListWithUid:(NSString *)uid
                        commentId:(long)commentId
                        dynamicId:(long)dynamicId
                        start:(NSInteger)start
                        ID:(long)ID
                          Success:(void (^)(NSArray <CTCommentReplyModel *>* commentList ,int totalCount))success
                          failure:(void (^)(NSNumber *resCode, NSString *message))failure;



/**
 举报动态、评论、回复

 @param formUid 举报人uid
 @param toUid 被举报人uid
 @param toCommenId 被举报评论（回复）id
 @param reportContent 举报分类文本
 @param success 成功回调
 @param failure 失败回调
 */
+ (void)requestReportPushWithFormUid:(NSString *)formUid
                             toUid:(NSString *)toUid
                             toCommenId:(long)toCommenId
                               reportContent:(NSString *)reportContent
                               Success:(void (^)(void))success
                               failure:(void (^)(NSNumber *resCode, NSString *message))failure;


/**
 获取举报的分类

 @param uid uid
 @param success 成功回调  {"name":"政治敏感","value":3}
 @param failure 失败回调
 */
+ (void)requestReportGetTypeWithUid:(NSString *)uid
                             Success:(void (^)(NSArray <NSDictionary *>*typeList))success
                             failure:(void (^)(NSNumber *resCode, NSString *message))failure;
@end

NS_ASSUME_NONNULL_END
