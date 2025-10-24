//
//  UserCore.h
//  BberryCore
//
//  Created by chenran on 2017/5/11.
//  Copyright © 2017年 chenran. All rights reserved.
//

#import "BaseCore.h"
#import "UserInfo.h"
#import "UserEnterRoomInfo.h"
#import "UserGift.h"
#import "UserExtensionRequest.h"

//NIM
#import <NIMSDK/NIMSDK.h>

/// 随机类型
typedef NS_ENUM(NSUInteger, RandomType) {
    RandomAvatarType = 1000, // 随机头像
    RandomNickType = 1001,   // 随机昵称
};

@interface UserCore : BaseCore

@property (nonatomic,assign) BOOL haddRepairUserInfo;
@property (assign, nonatomic) BOOL isSaveUserInfo;

//cache
- (void)cacheUserInfos:(NSArray *)userInfos
              complete:(void (^)(void))complete;

- (void)cacheUserInfo:(UserInfo *)userInfo
             complete:(void (^)(void))complete;

//query
- (RACSignal *)requestUserInfos:(NSArray *)userIdList;

- (NIMUser *)fetchUserByUid:(NSString *)userId;


/**
 获取单个用户信息（不查缓存，只查数据库）

 @param userId 用户uid
 @param refresh 是否需要刷新
 @param success 成功
 @param failure 失败
 */
- (void)getUserInfo:(UserID)userId refresh:(BOOL)refresh success:(void (^)(UserInfo *))success failure:(void (^)(NSError *))failure;

/**
 批量获取用户信息接口

 @param userIds uids数组
 @param refresh 是否需要刷新
 @param success 成功
 */

- (void)getUserInfos:(NSArray *)userIds refresh:(BOOL)refresh success:(void (^)(NSArray *infoArr))success;

/**
 查询数据库（同步方法）

 @param userId 用户uid
 @return userInfo
 */
- (UserInfo *)getUserInfoInDB:(UserID)userId;

/**
 礼物墙

 @param userId 用户id
 @param orderType orderType
 */
- (void)getReceiveGift:(UserID)userId orderType:(OrderType)orderType;

//获取礼物墙成就列表
- (void)getAchieveGiftForUid:(UserID)targetUid;

/**
 用户信息聚合接口
 
 @param userId 用户uid
 @param requests NSArray<UserExtensionRequest *> 不传默认返回QueryUserInfoExtension_Full 并且不刷新直接查数据库，除非数据库里面也没有数据
 @return 信号
 */
- (RACSignal *)queryExtensionUserInfoByWithUserID:(UserID)userId requests:(NSArray *)requests;


//action
- (RACSignal *)saveUserInfoWithUserID:(UserID)userId userInfos:(NSDictionary *)userInfos;
- (RACSignal *)saveUserInfoWithUserID:(UserID)userId userInfos:(NSDictionary *)userInfos isRepair:(BOOL)isRepair;

/**
 请求推广导流房间uid
 */
- (void)requestRecommendRoomUid;
/**
 上传URL图片到服务器

 @param url url
 */
- (void)uploadImageUrlToServer:(NSString *)url;


/**
 从服务器删除图片

 @param pid 图片ID
 */
- (void)deleteImageUrlToServerWithPid:(NSString *)pid;


/**
 用rac查询用户信息

 @param userId 用户ID
 @param refresh 是否刷新
 @return rac 信号
 */
- (RACSignal *)getUserInfoByRac:(UserID)userId refresh:(BOOL)refresh;


/**
 用rac查询用户信息，带缓存

 @param uid 用户uid
 @param refresh 是否刷新
 @return rac 信号
 */
- (RACSignal *)getUserInfoByUid:(UserID)uid refresh:(BOOL)refresh;


/**
 查询用户守护榜
 @param uid 用户uid
 */
- (void)getUserGuardRankByUid:(UserID)uid;


#pragma mark - UserEnterRoomInfo
/**
 查询数据库（同步方法）
 
 @param roomuid 房主uid
 @return UserEnterRoomInfo
 */
- (UserEnterRoomInfo *)getUserEnterRoomInfoInDB:(NSString *)roomuid;

/**
 插入或更新

 @param info UserEnterRoomInfo
 */
- (void)saveOrUpadateEnterRoomInfo:(UserEnterRoomInfo *)info;

#pragma mark -
#pragma mark 公会线业务  - 萝卜礼物

/**
 用户获得的萝卜礼物
 
 @param userID 用户 uid
 */
- (void)getReceiveCarrotGift:(UserID)userID;

#pragma mark - 更新 位置开关
/**
 更新 位置开关
 
 @param showLocation 位置开关
 */
- (void)updateUserInfoLocationSwitch:(BOOL)showLocation;

#pragma mark - 更新 年龄开关
/**
 更新 年龄开关
 
 @param show 是否显示年龄
 */
- (void)updateUserInfoAgeSwitch:(BOOL)show;

#pragma mark - 更新匹配聊天开关
/**
 更新匹配聊天开关
 
 @param show 是否显示匹配聊天
 */
- (void)updateUserInfoMatchChatSwitch:(BOOL)show;

#pragma mark - 消息设置
/// 获取用户消息设置状态
- (void)requestUserInfoNotifyStatus;

/// 更新系统消息状态
- (void)updateUserInfoSystemNotify:(BOOL)notify completion:(void (^)(BOOL result, NSNumber *errCode, NSString *msg))completion;

/// 更新互动消息状态
- (void)updateUserInfoInteractionNotify:(BOOL)notify completion:(void (^)(BOOL result, NSNumber *errCode, NSString *msg))completion;

#pragma mark - 随机用户信息
/// 用户选择随机资料
/// @param type 随机头像，随机昵称
- (void)userRandomInfoWithType:(RandomType)type;
/// 用户随机资料开关
- (void)getUserRandomInfoStatus;
@end
