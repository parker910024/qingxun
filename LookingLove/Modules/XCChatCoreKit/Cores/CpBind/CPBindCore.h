//
//  CPBindCore.h
//  UKiss
//
//  Created by apple on 2018/9/29.
//  Copyright © 2018年 yizhuan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseCore.h"

NS_ASSUME_NONNULL_BEGIN

@interface CPBindCore : BaseCore

/**
 绑定CP
 
 @param uid 登录uid
 @param code 对应cp配对码
 */
- (void)requestCPBindWithUniqueCode:(NSString *)code withRecomUniqueCode:(NSString *)recomUniqueCode;

/**
 解绑CP
 */
- (void)requestCPUnBindWithByUid;

/**
 进cp房，查询当前陪伴值以及在线时长阶段
 
 @param uid 用户uid
 @param coupleUid cpUid
 @param roomId 房间id
 */
- (void)requestCPOnlineWithUid:(NSString *)uid
                        coupleUid:(NSString *)coupleUid
                        roomId:(NSString *)roomId;

/**
 cp房间请求和响应cp
 
 @param uid 用户uid
 @param coupleUid cpUid
 @param roomId 房间id
 */
- (void)requestCPOnlineFinishWithUid:(NSString *)uid
                           coupleUid:(NSString *)coupleUid
                              roomId:(NSString *)roomId;

/**
 定时获取陪伴值
 
 @param uid 用户的uid
 @param type 0,1;一进入房间传type=0，表示不会增加陪伴值
 */
- (void)requestCPOnlineAddAccompanyWithUid:(NSString *)uid type:(NSString *)type;

/**
 cp上次的登录在线时间

 @param uid  用户uid
 */
- (void)requestCPOnlineGetInfoWithUid:(NSString *)uid;


/**
 切换文字模式

 @param Uid uid
 */
- (void)requestCPOnlineTextModeWithUid:(NSString *)Uid;


/**
 cp离线更新倒计时

 @param uid uid
 @param  coupleUid cpUid
 @param roomId 房间id
 @param leavediffer 剩下的倒计时  秒数
 */
- (void)requestCPLeaveRoomAndSyncTimeUid:(NSString *)uid
                                   coupleUid:(NSString *)coupleUid
                                    roomId:(NSInteger)roomId
                                    leavediffer:(long)leavediffer;


/**
 双方都离线，同步时间

 @param uid uid
 @param roomUid cpUid
 @param roomId 房间id
 */
- (void)requestCPRoomSyncTimeUid:(NSString *)uid
                                 coupleUid:(NSString *)coupleUid
                                  roomId:(NSInteger)roomId;

@end

NS_ASSUME_NONNULL_END
