//
//  XCDBManager.m
//  BberryCore
//
//  Created by 卫明何 on 2017/11/14.
//  Copyright © 2017年 chenran. All rights reserved.
//

#import "XCDBManager.h"
#import "UserInfo+WCTTableCoding.h"
#import "AuthCore.h"
#import "CommonFileUtils.h"
#import "UserEnterRoomInfo+WCTTableCoding.h"


static XCDBManager *instance = nil;
static NSString *const UserTable = @"user";
@interface XCDBManager ()
@property (nonatomic, strong) WCTDatabase *dataBase;
@property (nonatomic, strong) WCTTable    *table;
@property (nonatomic, strong) WCTTable    *enterRoomTable;

@end

@implementation XCDBManager
{
    dispatch_queue_t writeQueue;
}

#pragma mark - Life Cycle
+ (XCDBManager *)defaultManager {
    if (instance) {
        return instance;
    }
    @synchronized (self) {
        if (instance == nil) {
            instance = [[XCDBManager alloc] init];
            [instance creatUserDB];
        }
    }
    return instance;
}

- (void)clearManager {
    instance = nil;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        writeQueue = dispatch_queue_create("com.yy.face.YYFace.UserDb", DISPATCH_QUEUE_SERIAL);
    }
    return self;
}

#pragma mark - CreatOrUpdate

- (void)creatOrUpdateUser:(UserInfo *)user complete:(void (^)(void))complete {
    BOOL result = NO;
    dispatch_async(writeQueue, ^{
        [_table insertOrReplaceObject:user];
        if (complete) {
            complete();
        }
    });
}

- (void)creatOrUpdateUsers:(NSArray *)users {
    BOOL result = NO;
    if (users.count > 0) {
        dispatch_async(writeQueue, ^{
            [_table insertOrReplaceObjects:users];
        });
    }
}



#pragma mark - Creat UserDB
- (BOOL)creatUserDB {
//    [WCTStatistics SetGlobalErrorReport:^(WCTError *error) {
////        NSLog(@"[WCDB]%@", error.description);
//    }];

    [WCTDatabase globalTraceError:^(WCTError * _Nonnull error) {
            
    }];
    
    NSString *databasePath = [self getDBPath];
//    if (![CommonFileUtils isFileExists:databasePath]) {
        _dataBase = [[WCTDatabase alloc] initWithPath:databasePath];
//    }
    
//    BOOL isExist = [_dataBase isTableExists:NSStringFromClass(UserInfo.class)];
//    if (!isExist) {
    
        BOOL resultUserInfo = [_dataBase createTable:NSStringFromClass(UserInfo.class) withClass:UserInfo.class];
    
        BOOL resultUserEnterRoomInfo = [_dataBase createTable:NSStringFromClass(UserEnterRoomInfo.class) withClass:UserEnterRoomInfo.class];


        if (resultUserInfo) {
            _table = [_dataBase getTable:NSStringFromClass(UserInfo.class) withClass:UserInfo.class];
        }
        if (resultUserEnterRoomInfo) {
            _table = [_dataBase getTable:NSStringFromClass(UserEnterRoomInfo.class) withClass:UserEnterRoomInfo.class];

        }
//    }else {
//        _table = [_dataBase getTableOfName:NSStringFromClass(UserInfo.class) withClass:UserInfo.class];
//    }
    return YES;
}

- (NSString *)getDBPath {
    NSString *path = [NSString stringWithFormat:@"Documents/database/%@",[GetCore(AuthCore) getUid]];
    NSString *databasePath = [NSHomeDirectory() stringByAppendingPathComponent:path];
    NSString *dbName = [NSString stringWithFormat:@"%@.db",[GetCore(AuthCore)getUid]];
    databasePath = [databasePath stringByAppendingPathComponent:dbName];
    return databasePath;
}

+ (void)destroy {
    instance = nil;
}

#pragma mark - Insert
- (BOOL)insertUser:(UserInfo *)user {
    //    return [_table insertOrReplaceObject:user];
//    return [_table insertObject:user];
    
    return [_dataBase insertOrReplaceObject:user intoTable:NSStringFromClass(UserInfo.class)];
}



#pragma mark - Update
- (BOOL)updateUser:(UserInfo *)user {
    return [_table updateProperties:UserInfo.allProperties toObject:user where:UserInfo.uid == user.uid];
    
    
}



#pragma mark - Delete
- (BOOL)deletUser:(UserInfo *)user {
    return [_table deleteObjectsWhere:UserInfo.uid == user.uid];
}

- (BOOL)deletAllUsers {
    return [_table deleteObjects];
}


#pragma mark - Select
- (void)getUserWithUserID:(UserID)userID success:(void (^)(UserInfo *userInfo))success {
    dispatch_async(writeQueue, ^{
//        [_table insertOrReplaceObject:user];
        UserInfo *info = [_table getObjectWhere:UserInfo.uid == userID];
        success(info);
    });
//    return ;
}

- (UserInfo *)getUserWithUserID:(UserID)userID {
    return [_table getObjectWhere:UserInfo.uid == userID];
}

- (NSArray<UserInfo *> *)getUsersWithUserIDs:(NSArray *)uid {

    NSMutableArray *users = [NSMutableArray array];
    for (NSNumber *userId in uid) {
        UserInfo *userInfo = [self getUserWithUserID:userId.userIDValue];
        [users addObject:userInfo];
    }
    return users;
}

- (NSArray *)getAllUser {
    return [_table getObjects];
}

#pragma mark - UserEnterRoomInfo
- (void)creatOrUpdateUserEnterRoomInfo:(UserEnterRoomInfo *)enterRoomInfo complete:(void (^)(void))complete {
    BOOL result = NO;
    dispatch_async(writeQueue, ^{
        [_enterRoomTable insertOrReplaceObject:enterRoomInfo];
        if (complete) {
            complete();
        }
    });
}

- (void)creatOrUpdateUserEnterRoomInfos:(NSArray *)enterRoomInfos {
    BOOL result = NO;
    if (enterRoomInfos.count > 0) {
        dispatch_async(writeQueue, ^{
            [_enterRoomTable insertOrReplaceObjects:enterRoomInfos];
        });
    }
}

- (BOOL)updateUserEnterRoomInfo:(UserEnterRoomInfo *)enterRoomInfo {
    
    return [_enterRoomTable updateProperties:UserEnterRoomInfo.allProperties toObject:enterRoomInfo where:UserEnterRoomInfo.enterRoomUid == enterRoomInfo.enterRoomUid];
}
- (BOOL)insertUserEnterRoomInfo:(UserEnterRoomInfo *)enterRoomInfo {
    //    return [_table insertOrReplaceObject:user];
    //    return [_table insertObject:user];
    return [_dataBase insertOrReplaceObject:enterRoomInfo intoTable:NSStringFromClass(UserEnterRoomInfo.class)];
}
- (void)getUserEnterRoomInfoWithRoomUid:(NSString *)roomuid success:(void (^)(UserEnterRoomInfo *enterRoomInfo))success {
    dispatch_async(writeQueue, ^{
        //        [_table insertOrReplaceObject:user];
        UserEnterRoomInfo *enterRoomInfo = [_enterRoomTable getObjectWhere:UserEnterRoomInfo.enterRoomUid == roomuid];
        success(enterRoomInfo);
    });
    //    return ;
}

- (UserEnterRoomInfo *)getUserWithUserEnterRoomUid:(NSString *)roomuid {
    return [_enterRoomTable getObjectWhere:UserEnterRoomInfo.enterRoomUid == roomuid];
}

- (BOOL)deletEnterRoomInfo:(UserEnterRoomInfo *)enterRoomInfo {
    return [_enterRoomTable deleteObjectsWhere:UserEnterRoomInfo.enterRoomUid == enterRoomInfo.enterRoomUid];
}

- (BOOL)deletAllUserEnterRoomInfos {
    return [_enterRoomTable deleteObjects];
}

@end
