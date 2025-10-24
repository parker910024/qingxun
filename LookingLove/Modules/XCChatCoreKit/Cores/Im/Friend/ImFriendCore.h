//
//  ImFriendCore.h
//  BberryCore
//
//  Created by chenran on 2017/4/19.
//  Copyright © 2017年 chenran. All rights reserved.
//
#import "BaseCore.h"
#import "UserInfo.h"
#import "SecretarySystemUIDs.h"

@interface ImFriendCore : BaseCore

//记录本次启动内与谁 关闭了
//Key:对方UID Value:自己UID
@property (strong, nonatomic) NSCache *hadCloseNotFriendNoticeCache;

//小秘书、系统通知UID
@property (strong, nonatomic, nullable) SecretarySystemUIDs *secretarySystemUIDs;

- (NSArray<UserInfo *> *)getMyFriends;
- (NSArray<UserInfo *> *)getBlackList;
- (NSArray<UserInfo *> *)getMuteList;

- (BOOL) isMyFriend:(NSString *)accid;
- (void) addFriend:(NSString *)accid;
- (void) deleteFriend:(NSString *)accid;
- (void) requestFriend:(NSString *)accid requestMsg:(NSString *)requestMsg;
- (void) addToBlackList:(NSString *)accid;
- (void) removeFromBlackList:(NSString *)accid;
- (BOOL) isUserInBlackList:(NSString *)accid;

/**
 *  是否需要消息通知
 *
 *  @param userId 用户Id
 */
- (BOOL)notifyForNewMsg:(NSString *)userId;

/**
 *  设置消息提醒
 *
 *  @param notify 是否提醒
 *  @param userId 用户Id
 *  @param completion 完成回调
 */
- (void)updateNotifyState:(BOOL)notify
                  forUser:(NSString *)userId
               completion:(nullable void(^)(NSError * __nullable error))completion;

#pragma mark - Request
/// 获取小秘书、系统消息UID
- (void)requestSecretarySystemUIDsWithCompletion:(void(^)(SecretarySystemUIDs *))completion;

@end
