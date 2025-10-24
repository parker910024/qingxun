//
//  HttpRequestHelper+UserBackground.h
//  BberryCore
//
//  Created by Macx on 2018/6/20.
//  Copyright © 2018年 chenran. All rights reserved.
//

#import "HttpRequestHelper.h"
#import "UserBackground.h"

@interface HttpRequestHelper (UserBackground)


/**
 获取背景商城列表
 
 @param success 成功
 @param failure 失败
 */
+ (void)getBackgroundListWithPageSize:(NSString *)pageSize page:(NSString *)page uid:(UserID)uid Success:(void (^)(NSArray *))success failure:(void (^)(NSNumber *, NSString *))failure;


/**
 使用背景

 @param backgroundId 背景ID
 @param success 成功
 @param failure 失败
 */
+ (void)useBackgroundByBackgroundId:(NSString *)backgroundId roomUid:(NSString *)roomUid Success:(void (^)(BOOL))success failure:(void (^)(NSNumber *, NSString *))failure;
/**
 取消使用背景
 
 @param success 成功
 @param failure 失败
 */
+ (void)cancelBackgroundByRoomUid:(NSString *)roomUid Success:(void (^)(BOOL))success failure:(void (^)(NSNumber *, NSString *))failure;
/**
 购买背景
 
 @param backgroundId 背景ID
 @param success 成功
 @param failure 失败
 */
+ (void)buyOrRenewBackgroundByBackgroundId:(NSString *)backgroundId Success:(void (^)(BOOL))success failure:(void (^)(NSNumber *, NSString *))failure;


/**
 获取背景详情
 
 @param backgroundId 头饰ID
 @param success 成功
 @param failure 失败
 */
+ (void)getBackgroundDetailWithBackgroundId:(NSString *)backgroundId Success:(void (^)(UserBackground *))success failure:(void (^)(NSNumber *, NSString *))failure;

/**
 获取用户的背景列表
 @param uid     用户id
 @param success 成功
 @param failure 失败
 */
+ (void)getBackgroundList:(NSString *)uid
                    success:(void (^)(NSArray *))success
                    failure:(void (^)(NSNumber *, NSString *))failure;

/**
 获取用户可用背景列表
 @param uid     用户id
 @param success 成功
 @param failure 失败
 */
+ (void)getUserAvailableBackgroundList:(NSString *)uid
                               success:(void (^)(NSArray *))success
                               failure:(void (^)(NSNumber *, NSString *))failure;
/**
 赠送背景
 @param uid     赠送的用户id
 @param targetUid     被赠送的用户id
 @param backgroundId     背景id
 @param success 成功
 @param failure 失败
 */
+ (void)presentBackgroundFromUid:(NSString *)uid
                   toTargetUid:(UserID)targetUid
                withBackgroundId:(NSString *)backgroundId
                       success:(void (^)(BOOL))success
                       failure:(void (^)(NSNumber *, NSString *))failure;



@end
