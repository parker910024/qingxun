//
//  CPBindCoreClient.h
//  UKiss
//
//  Created by apple on 2018/9/29.
//  Copyright © 2018年 yizhuan. All rights reserved.
//

#import <Foundation/Foundation.h>
@class CPOnline;
@class XCRedPckageModel;
@protocol CPBindCoreClient <NSObject>

@optional

/**绑定成功*/
- (void)requestCPBindInfoSuccess;
- (void)requestCPBindInfoFailth:(NSString *)message;

/**解绑成功*/
- (void)requestCPUnBindInfoSuccess;
- (void)requestCPUnBindInfoFailth:(NSString *)message;

/**查询当前陪伴值以及在线时长阶段成功*/
- (void)requestCPOnlineSuccess:(CPOnline*)cpOnline;
- (void)requestCPOnlineFailth:(NSString *)message;

/**cp房间请求和响应 finish*/
- (void)requestCPOnlineFinishSuccess:(XCRedPckageModel *)onlineFinish;
- (void)requestCPOnlineFinishFailth:(NSString *)message;

/** 定时获取陪伴值*/
- (void)requestCPOnlineAddAccompanySuccess:(int)accompanyValue addValue:(int)addValue;
- (void)requestCPOnlineAddAccompanyFailth:(NSString *)message;

/** cp上次的登录在线时间*/
- (void)requestCPOnlineGetInfoSuccess:(NSString *)lastLoginTime;
- (void)requestCPOnlineGetInfoFailth:(NSString *)message;

/** 切换文字模式*/
- (void)requestCPOnlineTextSuccess;
- (void)requestCPOnlineTextFailth:(NSString *)message;

/** cp离线更新倒计时*/
- (void)requestCPLeaveRoomAndSyncTimeSuccess;
- (void)requestCPLeaveRoomAndSyncTimeFailth:(NSString *)message;

/** 双方都离线，同步时间*/
- (void)requestCPRoomSyncTimeSuccess;
- (void)requestCPRoomSyncTimeFailth:(NSString *)message;
@end
