//
//  GiftCoreClient.h
//  BberryCore
//
//  Created by chenran on 2017/7/13.
//  Copyright © 2017年 chenran. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GiftReceiveInfo.h"
#import "GiftAllMicroSendInfo.h"
#import "GiftChannelNotifyInfo.h"
#import "GiftInfo.h"
#import "AnnualBroadcastNotifyInfo.h"

@protocol GiftCoreClient <NSObject>
@optional
- (void)onRequestGiftList:(NSArray *)giftInfos;
- (void)onReceiveGift:(GiftAllMicroSendInfo *)giftReceiveInfo;
- (void)onGiftIsOffLine:(NSString *)message;
- (void)onGiftIsRefresh;
- (void)onReceiveGiftChannelNotify:(GiftChannelNotifyInfo *)giftChannelInfo;
- (void)onGiftNotCarrotToPay:(NSString *)message; // 萝卜不足
/** 请求房间普通礼物 + 专属礼物 失败的回调 */
- (void)onRequestGiftListFailth:(NSString *)message roomUid:(NSInteger)roomUid;
/// 请求盲盒奖励礼物列表
/// @param prizeGifts 礼物列表
- (void)onRequestPrizeGiftList:(NSArray<GiftInfo *> *)prizeGifts code:(NSInteger)code msg:(NSString *)msg;
/**
 收到房间  福袋礼物

 @param giftReceiveInfo 数据模型
 */
- (void)onReceiveLuckyGift:(GiftAllMicroSendInfo *)giftReceiveInfo;

/**
 收到房间全麦  福袋礼物
 
 @param giftReceiveInfos 数据模型
 */
- (void)onReceiveAllMicroLuckyGift:(NSArray<GiftAllMicroSendInfo *> *)giftReceiveInfos;



//获取背包礼物
- (void)onBackPackGiftSuccess:(NSArray<GiftInfo *> *)infos;
//获取背包礼物失败
- (void)onBackPackGiftFailed:(NSString *)message;
//背包礼物赠送成功
- (void)onUpdatePackGiftWithGiftId:(NSInteger)giftId giftNum:(NSInteger)count microCount:(NSInteger)microCount;


///**
// 收到开箱子  需要送全麦礼物
//
// @param recordId 中奖记录id
// @param code 验证码
// */
//- (void)onReceiveOpenBoxAllMicroSendRecordId:(NSInteger)recordId code:(NSString *)code;

//全服铭牌飘屏
- (void)onReceiveNamePlateChannelNotify:(NSArray *)namePlateChannelInfoArray;

/// 全服年度通知
- (void)onReceiveAnnualBroadcastNotify:(AnnualBroadcastNotifyInfo *)info;

@end
