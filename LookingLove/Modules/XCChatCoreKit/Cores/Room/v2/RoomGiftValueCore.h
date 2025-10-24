//
//  RoomGiftValueCore.h
//  AFNetworking
//
//  Created by lvjunhang on 2019/4/25.
//  房间礼物值

#import "BaseCore.h"

NS_ASSUME_NONNULL_BEGIN

@interface RoomGiftValueCore : BaseCore

/*
 获取房间所有麦序用户礼物值
 
 @param roomUid 房主 UID
 */
- (void)requestRoomMicGiftValueForRoomUid:(UserID)roomUid;

/**
 清除礼物值
 
 @param roomUid 房主 UID
 @param micUid 被清除的用户
 */
- (void)requestRoomGiftValueCleanWithRoomUid:(UserID)roomUid micUid:(UserID)micUid;

/**
 礼物值打开情况下，下麦
 
 @param roomUid 房主 UID
 @param micUid 下麦用户
 @param position 麦序位置
 */
- (void)requestRoomGiftValueStatusDownMicWithRoomUid:(UserID)roomUid micUid:(UserID)micUid position:(NSString *)position;

/**
 礼物值打开情况下，上麦
 
 @param roomUid 房主 UID
 @param micUid 上麦用户
 @param position 麦序位置
 */
- (void)requestRoomGiftValueStatusUpMicWithRoomUid:(UserID)roomUid micUid:(UserID)micUid position:(NSString *)position;

/**
 关闭房间礼物值开关
 
 @param roomUid 房主 UID
 */
- (void)requestRoomGiftValueCloseWithRoomUid:(UserID)roomUid;

/**
 开启房间礼物值开关
 
 @param roomUid 房主 UID
 */
- (void)requestRoomGiftValueOpenWithRoomUid:(UserID)roomUid;

@end

NS_ASSUME_NONNULL_END
