//
//  AppInitClient.h
//  BberryCore
//
//  Created by 卫明何 on 2018/1/8.
//  Copyright © 2018年 chenran. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RoomInfo.h"

@protocol AppInitClient <NSObject>

@optional

- (void)onGetFaceDataSuccess:(NSArray *)faceArr;//face
- (void)onGetNoblePrivilegeSuccess;//noble
- (void)onGetAdSuucess;//ad
- (void)onGetMonsterWillShow:(NSArray *)monsterArr;//monster
- (void)onNeedOpenRoomWithRoomType:(RoomType)roomType;
- (void)onGetPublicChatroomIdSuccess;

#pragma mark -
#pragma mark 定位
- (void)onGetLocationSuccess:(BOOL)success errorCode:(NSNumber *)errorCode message:(NSString *)message;

@end
