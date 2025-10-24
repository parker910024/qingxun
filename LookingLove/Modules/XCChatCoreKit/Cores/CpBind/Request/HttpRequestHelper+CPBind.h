//
//  HttpRequestHelper+CPBind.h
//  UKiss
//
//  Created by apple on 2018/9/29.
//  Copyright © 2018年 yizhuan. All rights reserved.
//

#import "HttpRequestHelper.h"
@class CPOnline;
@class XCRedPckageModel;

NS_ASSUME_NONNULL_BEGIN

@interface HttpRequestHelper (CPBind)
+ (void)requestCPBindWithUniqueCode:(NSString *)code
                    recomUniqueCode:(NSString *)recomUniqueCode
                            success:(void (^)(void))success
                            failure:(void (^)(NSNumber *resCode, NSString *message))failure;

+ (void)requestCPUnBindSuccess:(void (^)(void))success
                       failure:(void (^)(NSNumber *resCode, NSString *message))failure;



/**
 进cp房，查询当前陪伴值以及在线时长阶段

 @param uid 用户uid
 @param coupleUid cpUid
 @param roomId 房间id
 @param success 成功回调
 @param failure 失败回调
 */
+ (void)requestCPOnlineWithUid:(NSString *)uid
                        coupleUid:(NSString *)coupleUid
                        roomId:(NSString *)roomId
                        Success:(void (^)(CPOnline *cpOnline))success
                        failure:(void (^)(NSNumber *resCode, NSString *message))failure;

/**
 cp房间请求和响应cp
 
 @param uid 用户uid
 @param coupleUid cpUid
 @param roomId 房间id
 @param success 成功回调
 @param failure 失败回调
 */
+ (void)requestCPOnlineFinishWithUid:(NSString *)uid
                       coupleUid:(NSString *)coupleUid
                       roomId:(NSString *)roomId
                       Success:(void (^)(XCRedPckageModel *onlineFinish))success
                       failure:(void (^)(NSNumber *resCode, NSString *message))failure;


/**
 定时获取陪伴值

 @param uid 用户的uid
 @param type 0,1;一进入房间传type=0，表示不会增加陪伴值
 @param success 成功回调
 @param failure 失败回调
 */
+ (void)requestCPOnlineAddAccompanyWithUid:(NSString *)uid
                                      type:(NSString *)type
                                   Success:(void (^)(int accompanyValue , int addValue))success
                                   failure:(void (^)(NSNumber *resCode, NSString *message))failure;


/**
 cp上次的登录在线时间

 @param lastLoginTime 上次登录时间
 @param success 成功回调
 @param failure 失败回调
 */
+ (void)requestCPOnlineGetInfoWithUid:(NSString *)uid
                                   Success:(void (^)(NSString *lastLoginTime))success
                                   failure:(void (^)(NSNumber *resCode, NSString *message))failure;


/**
 切换文字模式

 @param uid uid
 @param success 成功回调
 @param failure 失败回调
 */
+ (void)requestCPOnlineTextModeWithUid:(NSString *)uid
                                        Success:(void (^)())success
                                        failure:(void (^)(NSNumber *resCode, NSString *message))failure;


/**
 cp离线更新数据

 @param uid uid
 @param roomUid 房主的uid
 @param coupleUid cpUid
 @param leavediffer 剩下的倒计时  秒数
 @param success 成功回调
 @param failure 失败回调
 */
+ (void)requestCPLeaveRoomAndSyncTimeUid:(NSString *)uid
                                 coupleUid:(NSString *)coupleUid
                                  roomId:(NSInteger)roomId
                             leavediffer:(long)leavediffer
                               Success:(void (^)())success
                               failure:(void (^)(NSNumber *resCode, NSString *message))failure;


/**
 双方都离线，同步时间

 @param uid uid
 @param coupleUid cpUid
 @param roomId 房间id
 @param success 成功回调
 @param failure 失败回调
 */
+ (void)requestCPRoomSyncTimeUid:(NSString *)uid
                                 coupleUid:(NSString *)coupleUid
                                  roomId:(NSInteger)roomId
                                 Success:(void (^)())success
                                 failure:(void (^)(NSNumber *resCode, NSString *message))failure;
@end

NS_ASSUME_NONNULL_END
