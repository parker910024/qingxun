//
//  CheckinCoreClient.h
//  Pods
//
//  Created by lvjunhang on 2019/3/25.
//  签到相关接口

#import <Foundation/Foundation.h>
#import "CheckinDraw.h"
#import "CheckinRewardTodayNotice.h"
#import "CheckinSignDetail.h"
#import "CheckinSign.h"
#import "CheckinRewardTotalNotice.h"
#import "CheckinDrawNotice.h"
#import "CheckinReceiveTotalReward.h"
#import "CheckinReplenish.h"
#import "CheckinReplenishInfo.h"

@protocol CheckinCoreClient <NSObject>
@optional

/**
 签到分享统计接口响应
 
 @param isSuccess 是否成功，出现错误时通过 code 和 msg 返回
 @param code 错误码
 @param msg 错误信息
 */
- (void)responseCheckinShare:(BOOL)isSuccess errorCode:(NSNumber *)code msg:(NSString *)msg;

/**
 领取累计奖励响应
 
 @param data 数据
 @param code 错误码
 @param msg 错误信息
 */
- (void)responseCheckinReceiveTotalReward:(CheckinReceiveTotalReward *)data errorCode:(NSNumber *)code msg:(NSString *)msg;

/**
 瓜分金币响应
 
 @param data 瓜分信息
 @param code 错误码
 @param msg 错误信息
 */
- (void)responseCheckinDraw:(CheckinDraw *)data errorCode:(NSNumber *)code msg:(NSString *)msg;

/**
 每日签到奖励预告响应
 
 @param data 数据
 @param code 错误码
 @param msg 错误信息
 */
- (void)responseCheckinRewardTodayNotice:(NSArray<CheckinRewardTodayNotice *> *)data errorCode:(NSNumber *)code msg:(NSString *)msg;

/**
 获取签到详情
 
 @param data 数据
 @param code 错误码
 @param msg 错误信息
 */
- (void)responseCheckinSignDetail:(CheckinSignDetail *)data errorCode:(NSNumber *)code msg:(NSString *)msg;

/**
 签到接口响应
 
 @param data 数据
 @param code 错误码
 @param msg 错误信息
 */
- (void)responseCheckinSign:(CheckinSign *)data errorCode:(NSNumber *)code msg:(NSString *)msg;

/**
 累计奖励预告
 
 @param data 数据
 @param code 错误码
 @param msg 错误信息
 */
- (void)responseCheckinRewardTotalNotice:(NSArray<CheckinRewardTotalNotice *> *)data errorCode:(NSNumber *)code msg:(NSString *)msg;

/**
 瓜分金币通知栏
 
 @param data 数据
 @param code 错误码
 @param msg 错误信息
 */
- (void)responseCheckinDrawNotice:(NSArray<CheckinDrawNotice *> *)data errorCode:(NSNumber *)code msg:(NSString *)msg;

/**
 签到提醒(开启/关闭)
 
 @param isSuccess 是否成功，出现错误时通过 code 和 msg 返回
 @param code 错误码
 @param msg 错误信息
 */
- (void)responseCheckinSignRemind:(BOOL)isSuccess errorCode:(NSNumber *)code msg:(NSString *)msg;

/**
 获取签到分享图片
 
 @param data 数据
 @param code 错误码
 @param msg 错误信息
 */
- (void)responseCheckinShareImage:(NSString *)data errorCode:(NSNumber *)code msg:(NSString *)msg;

/**
 获取补签信息
 
 @param data 数据
 @param code 错误码
 @param msg 错误信息
 */
- (void)responseCheckinReplenishInfo:(CheckinReplenishInfo *)data errorCode:(NSNumber *)code msg:(NSString *)msg;

/**
 补签
 
 @param data 数据
 @param code 错误码
 @param msg 错误信息
 */
- (void)responseCheckinReplenish:(CheckinReplenish *)data errorCode:(NSNumber *)code msg:(NSString *)msg;

@end
