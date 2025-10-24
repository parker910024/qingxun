//
//  TTPositionViewDatasourceProtocol.h
//  TTPositionView
//
//  Created by fengshuo on 2019/5/16.
//  Copyright © 2019 fengshuo. All rights reserved.
//
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "Attachment.h"
#import "FaceReceiveInfo.h"
#import "RoomOnMicGiftValue.h"
#import "TTPositionTopicModel.h"
#import "TTPositionViewUIProtocol.h"
NS_ASSUME_NONNULL_BEGIN


@protocol TTPositionViewDatasourceProtocol <NSObject>
@optional
#pragma mark - 麦序的
/** 更新麦序信息*/
- (void)updatePostionMicWithSqueue:(NSMutableDictionary *)micDic;

#pragma mark - 龙珠
/** 收到龙珠的消息的时候*/
- (void)dealDragonWithRecieveInfos:(NSMutableArray<FaceReceiveInfo *> *)faceRecieveInfos state:(CustomNotificationDragon)state;
/** 清楚空坑上 可能存在的龙珠*/
- (void)clearMicNotPeopelDragon;
#pragma mark - 光圈
/** 坑位上说话的时候 刷新光圈*/
- (void)reloadTheSpeakingView;

#pragma mark - face
- (void)showFaceInPositionViewWith:(NSMutableArray<FaceReceiveInfo *> *)faceRecieveInfos;
#pragma mark Gift Value Handle
/**
 更新坑位的礼物值
 @param giftValue 礼物值
 @param uid 接收礼物用户的uid
 @param updateTime 接收礼物时间
 */
- (void)updatePostionItemGiftValue:(long long)giftValue
                               uid:(UserID)uid
                        updateTime:(NSString *)updateTime;
/**
 清除礼物值同步自定义消息
 
 @param model 当前所有麦位礼物值信息
 */
- (void)cleanGiftValueSyncCustomNotify:(RoomOnMicGiftValue *)model;

/** 更新房间话题的内容*/
- (void)updatePositionTopicLableWith:(TTPositionTopicModel *)model;

/** 房间模式的切换*/
- (void)updateRoomPositionTypeWith:(TTRoomPositionViewType)positionType;
@end




NS_ASSUME_NONNULL_END
