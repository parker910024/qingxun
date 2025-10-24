//
//  RoomGiftValueCore.m
//  AFNetworking
//
//  Created by lvjunhang on 2019/4/25.
//

#import "RoomGiftValueCore.h"
#import "RoomGiftValueCoreClient.h"
#import "RoomOnMicGiftValue.h"
#import "HttpRequestHelper+RoomGiftValue.h"

@implementation RoomGiftValueCore

/*
 获取房间所有麦序用户礼物值
 
 @param roomUid 房主 UID
 */
- (void)requestRoomMicGiftValueForRoomUid:(UserID)roomUid {
    [HttpRequestHelper requestRoomMicGiftValueForRoomUid:roomUid success:^(RoomOnMicGiftValue *model) {
        
        NotifyCoreClient(RoomGiftValueCoreClient, @selector(responseRoomOnMicGiftValue:errorCode:msg:), responseRoomOnMicGiftValue:model errorCode:nil msg:nil);
        
    } failure:^(NSNumber *code, NSString *message) {
        NotifyCoreClient(RoomGiftValueCoreClient, @selector(responseRoomOnMicGiftValue:errorCode:msg:), responseRoomOnMicGiftValue:nil errorCode:code msg:message);
    }];
}

/**
 清除礼物值
 
 @param roomUid 房主 UID
 @param micUid 被清除的用户
 */
- (void)requestRoomGiftValueCleanWithRoomUid:(UserID)roomUid micUid:(UserID)micUid {
    
    [HttpRequestHelper requestRoomGiftValueCleanWithRoomUid:roomUid micUid:micUid success:^(RoomOnMicGiftValue *model) {
        NotifyCoreClient(RoomGiftValueCoreClient, @selector(responseRoomGiftValueClean:giftValue:errorCode:msg:), responseRoomGiftValueClean:micUid giftValue:model errorCode:nil msg:nil);
    } failure:^(NSNumber *code, NSString *msg) {
        NotifyCoreClient(RoomGiftValueCoreClient, @selector(responseRoomGiftValueClean:giftValue:errorCode:msg:), responseRoomGiftValueClean:micUid giftValue:nil errorCode:code msg:msg);
    }];
}

/**
 礼物值打开情况下，下麦
 
 @param roomUid 房主 UID
 @param micUid 下麦用户
 @param position 麦序位置
 */
- (void)requestRoomGiftValueStatusDownMicWithRoomUid:(UserID)roomUid micUid:(UserID)micUid position:(NSString *)position {
    
    [HttpRequestHelper requestRoomGiftValueStatusDownMicWithRoomUid:roomUid micUid:micUid position:position success:^{
        NotifyCoreClient(RoomGiftValueCoreClient, @selector(responseRoomGiftValueStatusDownMic:errorCode:msg:), responseRoomGiftValueStatusDownMic:YES errorCode:nil msg:nil);
    } failure:^(NSNumber *code, NSString *msg) {
        NotifyCoreClient(RoomGiftValueCoreClient, @selector(responseRoomGiftValueStatusDownMic:errorCode:msg:), responseRoomGiftValueStatusDownMic:NO errorCode:code msg:msg);
    }];
}

/**
 礼物值打开情况下，上麦
 
 @param roomUid 房主 UID
 @param micUid 上麦用户
 @param position 麦序位置
 */
- (void)requestRoomGiftValueStatusUpMicWithRoomUid:(UserID)roomUid micUid:(UserID)micUid position:(NSString *)position {
    
    [HttpRequestHelper requestRoomGiftValueStatusUpMicWithRoomUid:roomUid micUid:micUid position:position success:^{
        NotifyCoreClient(RoomGiftValueCoreClient, @selector(responseRoomGiftValueStatusUpMic:errorCode:msg:), responseRoomGiftValueStatusUpMic:YES errorCode:nil msg:nil);
    } failure:^(NSNumber *code, NSString *msg) {
        NotifyCoreClient(RoomGiftValueCoreClient, @selector(responseRoomGiftValueStatusUpMic:errorCode:msg:), responseRoomGiftValueStatusUpMic:NO errorCode:code msg:msg);
    }];
}

/**
 关闭房间礼物值开关
 
 @param roomUid 房主 UID
 */
- (void)requestRoomGiftValueCloseWithRoomUid:(UserID)roomUid {
    
    [HttpRequestHelper requestRoomGiftValueCloseWithRoomUid:roomUid success:^{
        NotifyCoreClient(RoomGiftValueCoreClient, @selector(responseRoomGiftValueClose:errorCode:msg:), responseRoomGiftValueClose:YES errorCode:nil msg:nil);
    } failure:^(NSNumber *code, NSString *msg) {
        NotifyCoreClient(RoomGiftValueCoreClient, @selector(responseRoomGiftValueClose:errorCode:msg:), responseRoomGiftValueClose:NO errorCode:code msg:msg);
    }];
}

/**
 开启房间礼物值开关
 
 @param roomUid 房主 UID
 */
- (void)requestRoomGiftValueOpenWithRoomUid:(UserID)roomUid {
    
    [HttpRequestHelper requestRoomGiftValueOpenWithRoomUid:roomUid success:^{
        NotifyCoreClient(RoomGiftValueCoreClient, @selector(responseRoomGiftValueOpen:errorCode:msg:), responseRoomGiftValueOpen:YES errorCode:nil msg:nil);
    } failure:^(NSNumber *code, NSString *msg) {
        NotifyCoreClient(RoomGiftValueCoreClient, @selector(responseRoomGiftValueOpen:errorCode:msg:), responseRoomGiftValueOpen:NO errorCode:code msg:msg);
    }];
}

@end
