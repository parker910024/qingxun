//
//  HttpRequestHelper+CPRoom.h
//  UKiss
//
//  Created by apple on 2018/10/13.
//  Copyright © 2018年 yizhuan. All rights reserved.
//

#import "HttpRequestHelper.h"
#import "XCCPSignStatus.h"
#import "XCRedPckageModel.h"
#import "CPSignInlistModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface HttpRequestHelper (CPRoom)



/**
 签到日历列表

 @param uid uid
 @param success 成功回调
 @param failure 失败回调
 */
+ (void)requestCPRoomUserSignInlistWithByUid:(NSString *)uid
                             success:(void (^)(CPSignInlistModel *signInlistModel))success
                             failure:(void (^)(NSNumber *resCode, NSString *message))failure;

/**
//每日签到接口/打卡记录
 */
+ (void)requestCPRoomSignInWithByUid:(UserID)uid
                       success:(void (^)(XCRedPckageModel *signInInfo))success
                       failure:(void (^)(NSNumber *resCode, NSString *message))failure;


/**
 每天是否是每天第一次启动
 */
+ (void)requestCPRoomDayFirstWithByUid:(UserID)uid
                         success:(void (^)(BOOL isFirst))success
                         failure:(void (^)(NSNumber *resCode, NSString *message))failure;

/**
 今天的打卡状态/记录
 */
+ (void)requestCPRoomSignInStatusWithByUid:(UserID)uid
                             success:(void (^)(XCCPSignStatus * signStatus))success
                             failure:(void (^)(NSNumber *resCode, NSString *message))failure;

/**
 打卡提醒
 */
+ (void)requestCPRoomSignInRemindWithByUid:(UserID)uid
                                   success:(void (^)(void))success
                                   failure:(void (^)(NSNumber *resCode, NSString *message))failure;

/**
 回到爱窝
 */
+ (void)requestCPRoomBackRoomWithByUid:(NSString *)uid
                               success:(void (^)(void))success
                               failure:(void (^)(NSNumber *resCode, NSString *message))failure;

@end

NS_ASSUME_NONNULL_END
