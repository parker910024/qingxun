//
//  RoomMagicCore.h
//  BberryCore
//
//  Created by Mac on 2018/3/16.
//  Copyright © 2018年 chenran. All rights reserved.
//

#import "BaseCore.h"
#import "RoomMagicInfo.h"
#import "GiftInfo.h"

typedef enum : NSUInteger {
    RoomMagicTypeNormal,
    RoomMagicTypeNoble,
} RoomMagicType;




@interface RoomMagicCore : BaseCore

/**
 添加一个魔法到本地缓存

 @param magic 魔法模型
 */
- (void)addAMagicInLocalStorage:(RoomMagicInfo *)magic;

/**
 查询魔法礼物实体

 @param magicId 魔法ID
 @return 魔法实体
 */
- (RoomMagicInfo *)queryMagicByid:(NSString *)magicId;

/**
 *  加载本地房间魔法列表
 */
- (NSMutableArray *)getRoomMagicType:(RoomMagicType)type;

/**
 *  加载网络房间魔法列表
 */
- (void)requestRoomMagicList;

/**
 请求用户个人页魔法礼物的列表

 @param uid 用户uid
 */
- (void)requestPersonMagicListByUid:(UserID)uid;

/**
 *  全麦送房间魔法
 */
- (void)sendAllMicroMagicByUids:(NSString *)targetUids magicId:(NSInteger)magicId roomUid:(NSInteger)roomUid;
/**
 房间内赠送多人魔法
 
 @param targetUids 接收者的uid
 @param magicId 魔法id
 @param roomUid 房间id
 @param gameRoomSendGiftType 全麦/多人非全麦/单人
 */
- (void)sendBatchMagicByUids:(NSString *)targetUids magicId:(NSInteger)magicId roomUid:(NSInteger)roomUid gameRoomSendGiftType:(GameRoomSendGiftType)gameRoomSendGiftType;
/**
 *  p2p送房间魔法
 */
- (void)sendMaigc:(NSInteger)magicId targetUid:(UserID)targetUid roomUid:(NSInteger)roomUid;

/*
 * 检查本地魔法列表是否包含收到的魔法
 */
- (RoomMagicInfo *)findLocalMagicListsByMagicId:(NSInteger)magicId;


/*
 * 房间魔法性能测试
 */
- (void)cancelMagicTimer;
- (void)startMagicTimer;
- (int)getMagicCount;

@end
