//
//  HttpRequestHelper+Praise.h
//  BberryCore
//
//  Created by chenran on 2017/5/18.
//  Copyright © 2017年 chenran. All rights reserved.
//

#import "HttpRequestHelper.h"

@interface HttpRequestHelper (Praise)


/**
 获取用户粉丝列表

 @param uid 用户id
 */
+ (void)getFansListWithUid:(UserID)uid
                      page:(NSInteger)page
                   success:(void (^)(NSArray *userInfos))success
                   failure:(void (^)(NSNumber *resCode, NSString *message))failure;

/**
 点赞

 @param paiseUid 点赞人的UID
 @param bePraisedUid 被点赞的UID
 @param success 成功
 @param failure 失败
 */
+ (void) praise:(UserID)paiseUid bePraisedUid:(UserID)bePraisedUid
             success:(void (^)(void))success
             failure:(void (^)(NSNumber *resCode, NSString *message))failure;


/**
 取消点赞

 @param cancelUid 取消人的UID
 @param beCanceledUid 被去掉的UID
 @param success 成功
 @param failure 失败
 */
+ (void) cancel:(UserID)cancelUid beCanceledUid:(UserID)beCanceledUid
        success:(void (^)(void))success
        failure:(void (^)(NSNumber *resCode, NSString *message))failure;

/**
 去掉点赞

 @param deleteFriendUid 点赞人的UID
 @param beDeletedFriendUid 被点赞人的UID
 @param success 成功
 @param failure 失败
 */
+ (void) deleteFriend:(UserID)deleteFriendUid beDeletedFriendUid:(UserID)beDeletedFriendUid
            success:(void (^)(void))success
            failure:(void (^)(NSNumber *resCode, NSString *message))failure;


/**
 获取关注列表

 @param uid uid
 @param success 成功
 @param failure 失败
 */
+ (void) requestAttentionList:(UserID)uid
                        state:(int)state
                         page:(int)page
                     PageSize:(int)pageSize
                      success:(void (^)(NSArray *userInfos))success
                      failure:(void (^)(NSNumber *resCode, NSString *message))failure;


/**
 是否喜欢

 @param uid uid
 @param isLikeUid 被喜欢人的uid
 @param success 成功
 @param failure 失败
 */
+ (void) isLike:(UserID)uid isLikeUid:(UserID)isLikeUid
        success:(void (^)(BOOL isLike))success
        failure:(void (^)(NSNumber *resCode, NSString *message))failure;

/**
 获取未读列表vkiss
 
 @param type 类型 0, 评论 1，点赞
 @param success 成功
 @param failure 失败
 */
+ (void) requestUnReadListTpye:(int)type
                      success:(void (^)(NSArray *userInfos))success
                      failure:(void (^)(NSNumber *resCode, NSString *message))failure;

/**
清除消息
 
 @param type 类型 0, 评论 1，点赞
 @param success 成功
 @param failure 失败
 */
+ (void) requestUnReadClearListTpye:(int)type
                       success:(void (^)())success
                       failure:(void (^)(NSString *message))failure;

/**
 获取未读消息总数
 */
+ (void) requestUnReadCountSuccess:(void (^)(int likeCount, int commentCount))success
                           failure:(void (^)(NSString *message))failure;


/**
 查询评论历史消息

 @param type 类型 0, 评论 1，点赞
 @param page 页数
 @param success 成功
 @param failure 失败
 */
+ (void) requestHistoryListTpye:(int)type
                           page:(NSInteger)page
                        minDate:(NSInteger)minDate
                        success:(void (^)(NSArray *lists))success
                        failure:(void (^)(NSString *message))failure;
@end
