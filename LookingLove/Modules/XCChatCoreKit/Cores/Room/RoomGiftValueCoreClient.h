//
//  RoomGiftValueCoreClient.h
//  Pods
//
//  Created by lvjunhang on 2019/4/25.
//  房间礼物值相关接口

#import "RoomOnMicGiftValue.h"

@protocol RoomGiftValueCoreClient <NSObject>

@optional
/**
 获取房间所有麦序用户礼物值
 
 @param data 信息
 @param code 错误码
 @param msg 错误信息
 */
- (void)responseRoomOnMicGiftValue:(RoomOnMicGiftValue *)data errorCode:(NSNumber *)code msg:(NSString *)msg;

/**
 清除礼物值
 
 @param micUid 被清除对象uid
 @param data 信息
 @param code 错误码
 @param msg 错误信息
 */
- (void)responseRoomGiftValueClean:(UserID)micUid giftValue:(RoomOnMicGiftValue *)data errorCode:(NSNumber *)code msg:(NSString *)msg;

/**
 礼物值打开情况下，下麦
 
 @param success 操作是否成功
 @param code 错误码
 @param msg 错误信息
 */
- (void)responseRoomGiftValueStatusDownMic:(BOOL)success errorCode:(NSNumber *)code msg:(NSString *)msg;

/**
 礼物值打开情况下，上麦
 
 @param success 操作是否成功
 @param code 错误码
 @param msg 错误信息
 */
- (void)responseRoomGiftValueStatusUpMic:(BOOL)success errorCode:(NSNumber *)code msg:(NSString *)msg;

/**
 关闭房间礼物值开关
 
 @param success 操作是否成功
 @param code 错误码
 @param msg 错误信息
 */
- (void)responseRoomGiftValueClose:(BOOL)success errorCode:(NSNumber *)code msg:(NSString *)msg;

/**
 开启房间礼物值开关
 
 @param success 操作是否成功
 @param code 错误码
 @param msg 错误信息
 */
- (void)responseRoomGiftValueOpen:(BOOL)success errorCode:(NSNumber *)code msg:(NSString *)msg;

@end
