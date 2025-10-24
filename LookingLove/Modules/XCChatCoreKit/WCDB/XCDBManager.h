//
//  XCDBManager.h
//  BberryCore
//
//  Created by 卫明何 on 2017/11/14.
//  Copyright © 2017年 chenran. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserInfo.h"
#import "UserEnterRoomInfo.h"

@interface XCDBManager : NSObject

#pragma mark - Life Cycle
+ (XCDBManager *)defaultManager;
+ (void)destroy;
// 清除单利, 退出登录切换账号的时候调用
- (void)clearManager;

#pragma mark - CreatOrUpdate

- (void)creatOrUpdateUser:(UserInfo *)user complete:(void (^)(void))complete;
- (void)creatOrUpdateUsers:(NSArray *)users;

#pragma mark - Insert
- (BOOL)insertUser:(UserInfo *)user;

#pragma mark - Update
- (BOOL)updateUser:(UserInfo *)user;

#pragma mark - Delete
- (BOOL)deletUser:(UserInfo *)user;
- (BOOL)deletAllUsers;

#pragma mark - Select
- (void)getUserWithUserID:(UserID)userID success:(void (^)(UserInfo *userInfo))success;
- (UserInfo *)getUserWithUserID:(UserID)userID;
- (NSArray<UserInfo *> *)getUsersWithUserIDs:(NSArray *)uid;
- (NSArray *)getAllUser;



#pragma mark - UserEnterRoomInfo
// 更新
- (BOOL)updateUserEnterRoomInfo:(UserEnterRoomInfo *)enterRoomInfo;
//插入
- (BOOL)insertUserEnterRoomInfo:(UserEnterRoomInfo *)enterRoomInfo;
//
- (void)creatOrUpdateUserEnterRoomInfo:(UserEnterRoomInfo *)enterRoomInfo complete:(void (^)(void))complete;
//
- (void)creatOrUpdateUserEnterRoomInfos:(NSArray *)enterRoomInfos;
//获取
- (void)getUserEnterRoomInfoWithRoomUid:(NSString *)roomuid success:(void (^)(UserEnterRoomInfo *enterRoomInfo))success;
//获取
- (UserEnterRoomInfo *)getUserWithUserEnterRoomUid:(NSString *)roomuid;
//删除所有
- (BOOL)deletAllUserEnterRoomInfos;
//删除
- (BOOL)deletEnterRoomInfo:(UserEnterRoomInfo *)enterRoomInfo;
@end
