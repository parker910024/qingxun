//
//  HttpRequestHelper+Auth.h
//  BberryCore
//
//  Created by chenran on 2017/3/5.
//  Copyright © 2017年 chenran. All rights reserved.
//

#import "HttpRequestHelper.h"
#import "UserInfo.h"
#import "UserGift.h"

#import "UserExtensionRequest.h"

#import "UserRankingInfo.h"


@interface HttpRequestHelper (User)


+ (void)requestRecommendChannelSuccess:(void (^)(UserID roomuid))success
                               failure:(void (^)(NSNumber *, NSString *))failure;

/**
 从服务器删除用户图片

 @param pid 图片id
 @param success 成功
 @param failure 失败
 */
+ (void)deleteImageToServerWithpid:(NSString *)pid
                           success:(void (^)(BOOL))success
                           failure:(void (^)(NSNumber *, NSString *))failure;


/**
 上传用户资料图片到服务器
 
 @param urlStr url字符串
 @param success 成功
 @param failure 失败
 */
+ (void) uploadImageURLToServerWithURL:(NSString *)urlStr
                               success:(void (^)(BOOL))success
                               failure:(void (^)(NSNumber *resCode, NSString *message))failure;


/**
 获取用户信息

 @param userId 用户id
 @param success 成功
 @param failure 失败
 */
+ (void) getUserInfo:(UserID )userId
             success:(void (^)(UserInfo *))success
             failure:(void (^)(NSNumber *resCode, NSString *message))failure;

/**
 获取用户扩展
 
 @param userId 用户id
 @param request QueryUserInfoExtension
 @param success 成功
 @param failure 失败
 */
+ (void) getUserInfoExtension:(UserID )userId
                      request:(QueryUserInfoExtension)request
                      success:(void (^)(UserInfo *))success
                      failure:(void (^)(NSNumber *resCode, NSString *message))failure;

/**
 批量获取用户信息

 @param userIds 用户id
 @param success 成功
 @param failure 失败  
 */
+ (void) getUserInfos:(NSArray *)userIds
              success:(void (^)(NSArray *))success
              failure:(void (^)(NSNumber *resCode, NSString *message))failure;

/*
 获取礼物墙
 
 */
+ (void)getReceiveGift:(UserID)userId orderType:(OrderType)orderType success:(void(^)(NSArray *))success failure:(void(^)(NSNumber *resCode,NSString *message)) failure;

//获取礼物墙成就列表
+ (void)getAchieveGiftForUid:(UserID)targetUid success:(void(^)(NSArray *))success failure:(void(^)(NSNumber *resCode,NSString *message)) failure;

/**
 更新用户信息

 @param userId 用户id
 @param success 成功
 @param failure 失败 
 */
+ (void) updateUserInfo:(UserID)userId
              userInfos:(NSDictionary *)userInfos
                success:(void (^)(UserInfo *))success
                failure:(void (^)(NSNumber *resCode, NSString *message))failure;
/**
 获取用户守护榜
 
 @param userId 用户id
 @param success 成功
 @param failure 失败
 */
+ (void)getUserGuardRank:(UserID)userId
                 success:(void (^)(UserRankingInfo *userRankingInfo))success
                failure:(void (^)(NSNumber *resCode, NSString *message))failure;

#pragma mark -
#pragma mark 公会线业务  - 萝卜礼物

/**
 用户获得的萝卜礼物
 
 @param userID 用户 uid
 */
+ (void)getReceiveCarrotGift:(UserID)userID
                     success:(void(^)(NSArray *))success
                     failure:(void(^)(NSNumber *resCode,NSString *message)) failure;

#pragma mark - 更新 位置开关
/**
 更新 位置开关
 
 @param showLocation 位置开关
 */
+ (void)updateUserInfoLocationSwitch:(BOOL)showLocation
                             success:(void(^)(void))success
                             failure:(void(^)(NSNumber *resCode,NSString *message))failure;

#pragma mark - 更新 年龄开关
/**
 更新 年龄开关
 
 @param show 是否显示年龄
 */
+ (void)updateUserInfoAgeSwitch:(BOOL)show
                     completion:(HttpRequestHelperCompletion)completion;

#pragma mark - 更新匹配聊天开关
/**
 更新匹配聊天开关
 
 @param show 是否显示匹配聊天
 */
+ (void)updateUserInfoMatchChatSwitch:(BOOL)show
                           completion:(HttpRequestHelperCompletion)completion;

#pragma mark - 消息设置
/// 获取用户消息设置状态
+ (void)requestUserInfoNotifyStatusWithCompletion:(HttpRequestHelperCompletion)completion;

/// 更新系统消息状态
+ (void)updateUserInfoSystemNotify:(BOOL)notify completion:(HttpRequestHelperCompletion)completion;

/// 更新互动消息状态
+ (void)updateUserInfoInteractionNotify:(BOOL)notify completion:(HttpRequestHelperCompletion)completion;

#pragma mark - 随机用户信息
/// 用户选择随机资料
/// @param type 随机头像，随机昵称
+ (void)userRandomInfoWithType:(NSInteger)type andCompletionHandler:(HttpRequestHelperCompletion)completion;

/// 用户随机资料开关
/// @param completion 完成回调
+ (void)getUserRandomInfoStatusAndCompletionHandler:(HttpRequestHelperCompletion)completion;
@end
