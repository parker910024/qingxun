//
//  HttpRequestHelper+RoomGiftValue.h
//  AFNetworking
//
//  Created by lvjunhang on 2019/4/25.
//  房间礼物值

#import "HttpRequestHelper.h"
#import "RoomOnMicGiftValue.h"

NS_ASSUME_NONNULL_BEGIN

@interface HttpRequestHelper (RoomGiftValue)

/*
 获取房间所有麦序用户礼物值
 
 @param roomUid 房主 UID
 */
+ (void)requestRoomMicGiftValueForRoomUid:(UserID)roomUid success:(void (^)(RoomOnMicGiftValue *model))success failure:(void (^)(NSNumber *code, NSString *message))failure;

/**
 清除礼物值
 
 @param roomUid 房主 UID
 @param micUid 被清除的用户
 */
+ (void)requestRoomGiftValueCleanWithRoomUid:(UserID)roomUid micUid:(UserID)micUid success:(void (^)(RoomOnMicGiftValue *model))success failure:(void (^)(NSNumber *code, NSString *msg))failure;

/**
 礼物值打开情况下，下麦
 
 @param roomUid 房主 UID
 @param micUid 下麦用户
 @param position 麦序位置
 */
+ (void)requestRoomGiftValueStatusDownMicWithRoomUid:(UserID)roomUid micUid:(UserID)micUid position:(NSString *)position success:(void (^)(void))success failure:(void (^)(NSNumber *code, NSString *msg))failure;

/**
 礼物值打开情况下，上麦
 
 @param roomUid 房主 UID
 @param micUid 上麦用户
 @param position 麦序位置
 */
+ (void)requestRoomGiftValueStatusUpMicWithRoomUid:(UserID)roomUid micUid:(UserID)micUid position:(NSString *)position success:(void (^)(void))success failure:(void (^)(NSNumber *code, NSString *msg))failure;

/**
 关闭房间礼物值开关
 
 @param roomUid 房主 UID
 */
+ (void)requestRoomGiftValueCloseWithRoomUid:(UserID)roomUid success:(void (^)(void))success failure:(void (^)(NSNumber *code, NSString *msg))failure;

/**
 开启房间礼物值开关
 
 @param roomUid 房主 UID
 */
+ (void)requestRoomGiftValueOpenWithRoomUid:(UserID)roomUid success:(void (^)(void))success failure:(void (^)(NSNumber *code, NSString *msg))failure;

@end

NS_ASSUME_NONNULL_END
