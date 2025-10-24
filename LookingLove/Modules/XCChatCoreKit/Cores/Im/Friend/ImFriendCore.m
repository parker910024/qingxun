//
//  ImFriendCore.m
//  BberryCore
//
//  Created by chenran on 2017/4/19.
//  Copyright © 2017年 chenran. All rights reserved.
//

#import "ImFriendCore.h"
#import "ImLoginCoreClient.h"
#import "UserCore.h"
#import <NIMSDK/NIMSDK.h>
#import "ImFriendCoreClient.h"
#import "NotificationCoreClient.h"

#import "HttpRequestHelper+ImFriend.h"

@interface ImFriendCore()<ImLoginCoreClient, NIMUserManagerDelegate, NotificationCoreClient,NIMSystemNotificationManagerDelegate>

@end

@implementation ImFriendCore
{
    NSMutableArray* _myFriends;
    NSMutableArray* _myBlackList;
    NSMutableArray* _myMuteUserList;
}

+ (void)load {
    GetCore(ImFriendCore);
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        AddCoreClient(ImLoginCoreClient, self);
        AddCoreClient(NotificationCoreClient, self);
        _myFriends = [NSMutableArray array];
        _myBlackList = [NSMutableArray array];
        _myMuteUserList = [NSMutableArray array];
        [[NIMSDK sharedSDK].userManager addDelegate:self];
        [[NIMSDK sharedSDK].systemNotificationManager addDelegate:self];
        
        //获取小秘书、系统消息UID
        [self requestSecretarySystemUIDsWithCompletion:nil];
    }
    return self;
}

-(void)dealloc
{
    RemoveCoreClient(ImLoginCoreClient, self);
    RemoveCoreClient(NotificationCoreClient, self);
    [[NIMSDK sharedSDK].userManager removeDelegate:self];
}

- (NSArray<UserInfo *> *)getMyFriends
{
    return [_myFriends copy];
}

- (NSArray<UserInfo *> *)getBlackList
{
    return [_myBlackList copy];
}

- (NSArray<UserInfo *> *)getMuteList
{
    return [_myMuteUserList copy];
}

- (void)requestFriend:(NSString *)accid requestMsg:(NSString *)requestMsg
{
    if (accid.length > 0) {
        NIMUserRequest *request = [[NIMUserRequest alloc] init];
        request.userId = accid;                            //封装用户ID
        request.operation = NIMUserOperationRequest;                    //封装验证方式
        request.message  = requestMsg;
        
        [[NIMSDK sharedSDK].userManager requestFriend:request completion:^(NSError * _Nullable error) {
            if (error == nil) {
                NotifyCoreClient(ImFriendCoreClient, @selector(onRequestFriendSuccess), onRequestFriendSuccess);
            } else {
                NotifyCoreClient(ImFriendCoreClient, @selector(onRequestFriendFailth), onRequestFriendFailth);
            }
        }];
    }
}

- (void)deleteFriend:(NSString *)accid
{
    if (accid.length > 0) {
        [[NIMSDK sharedSDK].userManager deleteFriend:accid completion:^(NSError * _Nullable error) {
            if (error == nil) {
                NotifyCoreClient(ImFriendCoreClient, @selector(onDeleteFriendSuccess), onDeleteFriendSuccess);
            } else {
                NotifyCoreClient(ImFriendCoreClient, @selector(onDeleteFirendFailth), onDeleteFirendFailth);
            }
        }];
    }
}

- (void)addFriend:(NSString *)accid
{
    if (accid.length > 0) {
        NIMUserRequest *request = [[NIMUserRequest alloc] init];
        request.userId = accid;
        request.operation = NIMUserOperationAdd;
        
        [[NIMSDK sharedSDK].userManager requestFriend:request completion:^(NSError * _Nullable error) {
            if (error == nil) {
                NotifyCoreClient(ImFriendCoreClient, @selector(onRequestFriendSuccess), onRequestFriendSuccess);
                [self updateMyFriends];
            } else {
                NotifyCoreClient(ImFriendCoreClient, @selector(onRequestFriendFailth), onRequestFriendFailth);
                [self updateMyFriends];
            }
        }];
    }
}

- (void)addToBlackList:(NSString *)accid
{
    if (accid.length > 0) {
        [[NIMSDK sharedSDK].userManager addToBlackList:accid completion:^(NSError * _Nullable error) {
            if (error == nil) {
                NotifyCoreClient(ImFriendCoreClient, @selector(onAddToBlackListSuccess), onAddToBlackListSuccess);
                [self updateBlackList];
                [self updateMyFriends];
            } else {
                NotifyCoreClient(ImFriendCoreClient, @selector(onAddToBlackListFailth), onAddToBlackListFailth);
                [self updateBlackList];
                [self updateMyFriends];
            }
        }];
    }
}

- (void)removeFromBlackList:(NSString *)accid
{
    if (accid.length > 0) {
        [[NIMSDK sharedSDK].userManager removeFromBlackBlackList:accid completion:^(NSError * _Nullable error) {
            if (error == nil) {
                NotifyCoreClient(ImFriendCoreClient, @selector(onRemoveFromBlackListSuccess), onRemoveFromBlackListSuccess);
                [self updateBlackList];
                [self updateMyFriends];
            } else {
                NotifyCoreClient(ImFriendCoreClient, @selector(onRemoveFromBlackListFailth), onRemoveFromBlackListFailth);
                [self updateBlackList];
                [self updateMyFriends];
            }
        }];
    }
}

- (BOOL)isUserInBlackList:(NSString *)accid
{
    if (accid.length > 0) {
        return [[NIMSDK sharedSDK].userManager isUserInBlackList:accid];
    }
    return NO;
}

/**
 *  是否需要消息通知
 *
 *  @param userId 用户Id
 */
- (BOOL)notifyForNewMsg:(NSString *)userId {
    return [[NIMSDK sharedSDK].userManager notifyForNewMsg:userId];
}

/**
 *  设置消息提醒
 *
 *  @param notify 是否提醒
 *  @param userId 用户Id
 *  @param completion 完成回调
 */
- (void)updateNotifyState:(BOOL)notify
                  forUser:(NSString *)userId
               completion:(nullable void(^)(NSError * __nullable error))completion {
    
    [[NIMSDK sharedSDK].userManager updateNotifyState:notify forUser:userId completion:completion];
}

- (BOOL)isMyFriend:(NSString *)accid
{
    if (accid.length > 0) {
        return [[NIMSDK sharedSDK].userManager isMyFriend:accid];
    }
    return NO;
}

- (void) updateMyFriends
{
    NSArray *friends = [[NIMSDK sharedSDK].userManager myFriends];
    [_myFriends removeAllObjects];
    if (friends.count > 0) {
        NSMutableArray *uids = [NSMutableArray array];
        for (NIMUser *user in friends) {
            NSString *uid = user.userId;
            if (![self isUserInBlackList:uid]) {//过滤黑名单
                [uids addObject:@([uid integerValue])];
            }
            
        }
        [GetCore(UserCore) getUserInfos:uids refresh:YES success:^(NSArray *infoArr) {
            _myFriends = [infoArr mutableCopy];
            NotifyCoreClient(ImFriendCoreClient, @selector(onFriendChanged), onFriendChanged);
        }];
        
    }else {
        NotifyCoreClient(ImFriendCoreClient, @selector(onFriendChanged), onFriendChanged);

    }
    
}

- (void) updateBlackList
{
    NSArray *blackList = [[NIMSDK sharedSDK].userManager myBlackList];
    [_myBlackList removeAllObjects];
    if (blackList.count > 0) {
        NSMutableArray *uids = [NSMutableArray array];
        for (NIMUser *user in blackList) {
            NSString *uid = user.userId;
            if ([self isUserInBlackList:uid]) {

                [uids addObject:@([uid integerValue])];

            }
        }
        [GetCore(UserCore)getUserInfos:uids refresh:YES success:^(NSArray *infoArr) {
            _myBlackList = [infoArr mutableCopy];
            NotifyCoreClient(ImFriendCoreClient, @selector(onBlackListChanged), onBlackListChanged);
        }];

    }else{
        NotifyCoreClient(ImFriendCoreClient, @selector(onBlackListChanged), onBlackListChanged);
    }
    

}

- (void) updateMuteList
{
    if (_secretarySystemUIDs) {
        //因为小秘书或系统消息UID查询用户信息导致接口报错，所以将其剔除
        
        [_myMuteUserList removeAllObjects];
        NSArray *muteUserList = [[NIMSDK sharedSDK].userManager myMuteUserList];
        
        for (NIMUser *user in muteUserList) {
            
            if ([user.userId isEqualToString:self.secretarySystemUIDs.secretaryUid]) {
                continue;
            }
            
            if ([user.userId isEqualToString:self.secretarySystemUIDs.systemMessageUid]) {
                continue;
            }
            
            [GetCore(UserCore)getUserInfo:user.userId.userIDValue refresh:NO success:^(UserInfo *info) {
                [_myMuteUserList addObject:info];
            } failure:^(NSError *error) {
            }];
        }
        
        NotifyCoreClient(ImFriendCoreClient, @selector(onMuteListChanged), onMuteListChanged);
    }
}

-(void) onFriendAdd
{
    [self updateMyFriends];
}

#pragma mark - NIMUserManagerDelegate
- (void)onFriendChanged:(NIMUser *)user
{
    [self updateMyFriends];
}

- (void)onBlackListChanged
{
    [self updateBlackList];
}

- (void)onMuteListChanged
{
    [self updateMuteList];
}

#pragma mark - ImLoginCoreClient
- (void)onImSyncSuccess
{
    [self updateMyFriends];
    [self updateBlackList];
    [self updateMuteList];
}

#pragma mark - NotificationCoreClient
- (void)onRecvFriendAddNoti:(NIMSystemNotification *)notification
{
    if (notification.type == NIMSystemNotificationTypeFriendAdd) {
        if ([notification.attachment isKindOfClass:[NIMUserAddAttachment class]]) {
            NIMUserAddAttachment *atta = (NIMUserAddAttachment *)notification.attachment;
            if (atta.operationType == NIMUserOperationRequest) {
                NotifyCoreClient(ImFriendCoreClient, @selector(onRecieveFriendAddNoti:), onRecieveFriendAddNoti:notification.sourceID);
            }
        }
    }
}

- (void)onReceiveSystemNotification:(NIMSystemNotification *)notification {
    
    NIMSystemNotificationType type = notification.type;
    
    switch (type) {
        case NIMSystemNotificationTypeTeamApply: {
            
            break;
        }
        case NIMSystemNotificationTypeTeamApplyReject: {
            
            break;
        }
        case NIMSystemNotificationTypeTeamInvite: {
            
            break;
        }
        case NIMSystemNotificationTypeTeamIviteReject: {
            
            break;
        }
        case NIMSystemNotificationTypeFriendAdd:
        {
            NotifyCoreClient(ImFriendCoreClient, @selector(onFriendAdded), onFriendAdded);
            id object = notification.attachment;
            if ([object isKindOfClass:[NIMUserAddAttachment class]]) {
                //强类型转换
                NIMUserOperation operation = [(NIMUserAddAttachment *)object operationType];
                //根据不同的操作类型去处理不同业务
                switch (operation) {
                    case NIMUserOperationAdd:
                        // 对方直接加你为好友
                        break;
                    case NIMUserOperationRequest:
                        // 对方请求加你为好友
                        break;
                    case NIMUserOperationVerify:
                        //对方通过了你的好友请求
                        break;
                    case NIMUserOperationReject:
                        //对方拒绝了你的好友请求
                        break;
                    default:
                        break;
                }
            }

        }
    }
}

#pragma mark - Request
- (void)requestSecretarySystemUIDsWithCompletion:(void(^)(SecretarySystemUIDs *))completion {
    @weakify(self)
    [HttpRequestHelper requestSecretarySystemUIDsWithCompletion:^(id data, NSNumber *code, NSString *msg) {
        
        @strongify(self)
        self.secretarySystemUIDs = [SecretarySystemUIDs modelWithJSON:data];
        if (self.secretarySystemUIDs) {
            [self updateMuteList];
        }
        
        !completion ?: completion(self.secretarySystemUIDs);
    }];
}

#pragma mark - getter
- (NSCache *)hadCloseNotFriendNoticeCache {
    if (!_hadCloseNotFriendNoticeCache) {
        _hadCloseNotFriendNoticeCache = [[NSCache alloc]init];
        _hadCloseNotFriendNoticeCache.countLimit = 500;
    }
    return _hadCloseNotFriendNoticeCache;
}

@end
