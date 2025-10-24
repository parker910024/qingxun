//
//  BaseAttrbutedStringHandler+TTRoomModule.h
//  TuTu
//
//  Created by KevinWang on 2018/10/30.
//  Copyright © 2018年 YiZhuan. All rights reserved.
//

#import "BaseAttrbutedStringHandler.h"

@class UserInfo;
@class NIMChatroomMember;
@class Attachment;

@interface BaseAttrbutedStringHandler (TTRoomModule)

/// 创建开箱子公屏信息(新版)
/// @param nickName 用户昵称
/// @param uid 用户 uid
/// @param prizeName 奖品名称
/// @param num 奖品数量
/// @param boxTypeStr 砸蛋类型描述(金蛋，至尊蛋)
+ (NSMutableAttributedString *)createOpenBoxAttributedString:(NSString *)nickName uid:(NSString *)uid prizeName:(NSString *)prizeName prizeNum:(NSNumber *)num boxTypeStr:(NSString *)boxTypeStr;

//创建开箱子公屏信息
+ (NSMutableAttributedString *)createOpenBoxAttributedString:(NSString *)nickName uid:(NSString *)uid prizeName:(NSString *)prizeName prizeNum:(NSNumber *)num;

/**
 在线列表子标题用户各种icon生成 (用户名|性别)
 
 @param userInfo 用户信息
 @return 富文本
 */
+ (NSMutableAttributedString *)creatOnlineListUserNameWithGenderAttrWithUserInfo:(UserInfo *)userInfo;
/**
  在线列表 用户名|性别|官
 @param userInfor 用户信息
 @param isHide 隐身
 */
+ (NSMutableAttributedString *)createOnlineListUserNameAndGenderAndOfficalWithUserInfor:(UserInfo *)userInfor isHide:(BOOL)isHide;

//房间在线列表副标题（新 官方 房主 管理 等级 魅力值）
+ (NSMutableAttributedString *)roomOnlineSubTitleAttributedStringWithUserInfo:(UserInfo *)userInfo chatRoomMember:(NIMChatroomMember *)chatRoomMember;

//名字|性别
+ (NSMutableAttributedString *)creatNickAndGenderAttributedStringByUserInfo:(UserInfo *)userInfo nameTextColor:(UIColor *)nameColor;
//名字|性别
+ (NSMutableAttributedString *)creatNickAndGenderAttributedStringByUserInfo:(UserInfo *)userInfo nameTextColor:(UIColor *)nameColor nameFont:(UIFont *)font;

//勋章|经验等级|魅力等级
+ (NSMutableAttributedString *)creatBadge_expLevel_charmLevelByUserInfo:(UserInfo *)userInfo;
//兔兔号|粉丝数
+ (NSMutableAttributedString *)creatErbanNumAndFansAttributedStringByUserInfo:(UserInfo *)userInfo labelAttribute:(NSDictionary *)labelAttribute;
//家族
+ (NSMutableAttributedString *)creatFamilyStrByUserInfo:(UserInfo *)userInfo labelAttribute:(NSDictionary *)labelAttribute;


//开通贵族提示卡片
+ (NSMutableAttributedString *)creatOpenNobleTipCardNeedLevelString:(NSString *)needLevel;
+ (NSMutableAttributedString *)creatOpenNobleTipCardCurrentLevelString:(NSString *)currentLevel;


//创建欢迎xx富文本
+ (NSMutableAttributedString *)creatWelcomeAttributedByNick:(NSString *)nick;
//开通贵族富文本
+ (NSMutableAttributedString *)creatOpenNobleAttrByNick:(NSString *)nick nobleName:(NSString *)nobleName;


//房间排麦的公屏消息
+ (NSMutableAttributedString *)crateRoomArrangeMicWith:(Attachment *)attachment;

@end
