//
//  UserCoreClient.h
//  BberryCore
//
//  Created by chenran on 2017/5/11.
//  Copyright © 2017年 chenran. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserInfo.h"
#import "UserRankingInfo.h"
#import "UserNotifyStatus.h"

@protocol UserCoreClient <NSObject>

@optional
- (void)onCurrentUserInfoUpdate:(UserInfo *)userInfo;
//当前用户信息需要完善
- (void)onCurrentUserInfoNeedComplete:(UserID)uid;
- (void)onCurrentUserInfoLogout;

//展示礼物墙
- (void)onGetReceiveGiftSuccess:(NSArray *)userGiftList uid: (UserID)uid;
- (void)onGetReceiveGiftFailth:(NSString *)message;

//获取礼物墙成就列表
- (void)onGetAchievementGiftSuccess:(NSArray *)achievementGiftList uid: (UserID)uid;
- (void)onGetAchievementGiftFailth:(NSString *)message;

//上传用户图片
- (void)onUploadImageUrlToServerSuccess;
- (void)onUploadImageUrlToServerFailth:(NSString *)message;

//删除用户图片
- (void)deleteImageToServerSuccess;
- (void)deleteImageUrlToServerFailth:(NSString *)message;

//===座驾
//获取商城座驾列表成功
- (void)onGetCarListSuccess:(NSArray *)list state:(int)state;
//获取商城座驾列表失败
- (void)onGetCarListFailth:(NSString *)message;

//获取车库座驾列表成功
- (void)onGetOwnCarList:(UserCarPlaceType)placeType success:(NSArray *)list;
//获取车库座驾列表失败
- (void)onGetOwnCarList:(UserCarPlaceType)placeType failth:(NSString *)message;

//使用座驾成功
- (void)onUseCarSuccess;
- (void)onUseCarFailth:(NSString *)message;


/**  头饰  **/
//获取头饰商城成功
- (void)onGetHeadWearListSuccess:(NSArray *)list state:(int)state;
//获取头饰商城列表失败
- (void)onGetHeadwearListFailth:(NSString *)message;

//获取头饰库列表成功
- (void)onGetOwnHeadwearList:(UserHeadwearPlaceType)placeType success:(NSArray *)list;
//获取头饰库列表失败
- (void)onGetOwnHeadwearList:(UserHeadwearPlaceType)placeType failth:(NSString *)message;

//使用头饰成功
- (void)onUseHeadwearSuccess;
- (void)onUseHeadwearFailth:(NSString *)message;

//获取铭牌列表成功
- (void)onGetNameplateListSuccess:(NSArray *)list state:(int)state;
//获取铭牌列表失败
- (void)onGetNameplateListFailth:(NSString *)message;

//制作铭牌列表成功
- (void)onMakeNameplateSuccess:(BOOL)success;
//获取铭牌列表失败
- (void)onMakeNameplateFailth:(NSString *)message;

//使用/摘取铭牌列表成功
- (void)onUseNameplateSuccess:(BOOL)success used:(NSInteger)used;
//使用/摘取铭牌列表成功失败
- (void)onUseNameplateFailth:(NSString *)message;

//家族的通知需要刷新 user/get的
- (void)onFamilyUpdateUserInfor;

//获取导流用户推荐信息成功
- (void)onRequestRecommendRoomUidSuccess:(UserID)uid;


/** 背景  **/

//获取背景商城成功
- (void)onGetBackgroundListSuccess:(NSArray *)list state:(int)state;
//获取背景商城列表失败
- (void)onGetBackgroundListFailth:(NSString *)message;

//获取背景库列表成功
- (void)onGetOwnBackgroundListSuccess:(NSArray *)list;
//获取背景库列表失败
- (void)onGetOwnBackgroundListFailth:(NSString *)message;

//获取可用背景列表成功
- (void)onGetOwnAvailableBackgroundListSuccess:(NSArray *)list;
//获取可用背景列表失败
- (void)onGetOwnAvailableBackgroundListFailth:(NSString *)message;

//使用背景成功
- (void)onUseBackgroundSuccess;
- (void)onUseBackgroundFailth:(NSString *)message;



//守护榜
- (void)onUseGuardRankSuccess:(UserRankingInfo *)userRankingInfo withUid:(UserID)uid;
- (void)onUseGuardRankFailth:(NSString *)message;

// 保存用户信息失败
- (void)onSaveUserInfoFailth:(NSString *)message errorCode:(NSInteger)errorCode;

#pragma mark -
#pragma mark 公会线 --- 萝卜礼物墙
- (void)onGetReceiveCarrotGiftSuccess:(NSArray *)userGiftList uid: (UserID)uid code:(NSNumber *)code msg:(NSString *)msg;

#pragma mark - 更新 位置开关
// 更新 位置开关
- (void)updateUserInfoLocationSwitchSuccess:(BOOL)showLocation;
- (void)updateUserInfoLocationSwitchFailth:(BOOL)showLocation errorMessage:(NSString *)message;

#pragma mark - 更新年龄开关
/// 更新年龄开关回调
/// @param success 是否更新成功
/// @param code 错误码
/// @param msg 错误信息
- (void)responseUserInfoAgeSwitchSuccess:(BOOL)success code:(NSNumber *)code msg:(NSString *)msg;

#pragma mark - 更新匹配聊天开关
/// 更新匹配聊天开关回调
/// @param success 是否更新成功
/// @param code 错误码
/// @param msg 错误信息
- (void)responseUserInfoMatchChatSwitchSuccess:(BOOL)success code:(NSNumber *)code msg:(NSString *)msg;

/// 获取用户消息设置状态
- (void)responseUserInfoNotifyStatus:(UserNotifyStatus *)data code:(NSNumber *)code msg:(NSString *)msg;

#pragma mark - 用户资料随机
/// 随机用户资料
/// @param randomNick 随机昵称
/// @param randomAvatarUrl 随机头像
/// @param resCode 错误码
/// @param resMsg 错误信息
- (void)userRandomInfoSuccessWithNick:(NSString *)randomNick randomAvatar:(NSURL *)randomAvatarUrl resCode:(NSNumber *)resCode resMsg:(NSString *)resMsg;

/// 用户资料随机开关
/// @param nickStatus 随机昵称开关
/// @param avatarStatus 随机头像开关
/// @param resCode 错误码
/// @param resMsg 错误信息
- (void)getUserRandomInfoStatus:(BOOL)nickStatus avatarStatus:(BOOL)avatarStatus resCode:(NSNumber *)resCode resMsg:(NSString *)resMsg;
@end

