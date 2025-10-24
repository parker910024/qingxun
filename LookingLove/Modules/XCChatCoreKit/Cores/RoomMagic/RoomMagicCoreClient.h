//
//  RoomMagicCoreClient.h
//  BberryCore
//
//  Created by Mac on 2018/3/16.
//  Copyright © 2018年 chenran. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RoomMagicInfo.h"

@protocol RoomMagicCoreClient <NSObject>

@optional
//房间魔法列表刷新
- (void)onRoomMagicListNeedRefresh;

//请求用户个人页魔法礼物的列表
- (void)onRequestPersonMagicListSuccessWithUid:(UserID)uid andList:(NSArray *)list;
- (void)onRequestPersonMagicListFailth:(NSString *)message;

//收到房间魔法
- (void)onReceiveRoomMagic:(RoomMagicInfo *)roomMagicInfo;
//房间魔法已下架
- (void)onRoomMagicDidOffLine:(NSString *)message;




@end
