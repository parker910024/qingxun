//
//  BaseAttrbutedStringHandler+RoomMessage.h
//  TuTu
//
//  Created by KevinWang on 2018/11/7.
//  Copyright © 2018年 YiZhuan. All rights reserved.
//

#import "BaseAttrbutedStringHandler.h"
#import "UserCore.h"

@class PrivilegeInfo;

@interface BaseAttrbutedStringHandler (RoomMessage)

//创建 官|用户等级|昵称
+ (NSMutableAttributedString *)creatOffical_nobleBadge_userLevel_nickAttributedByUserInfo:(UserInfo *)userInfo;

//创建开箱子 全麦送 公屏信息
+ (NSMutableAttributedString *)createOpenBoxAllMicroSendAttributedString:(NSString *)nickName prizeValue:(NSInteger)value prizeUrl:(NSString *)prizUrl prizeNum:(NSInteger)num;

/// 创建开箱子公屏信息
/// @param nickName 用户昵称
/// @param prizeName 奖品名称
/// @param num 奖品数量
/// @param boxTypeStr 砸蛋方式(金蛋，至尊蛋)
+ (NSMutableAttributedString *)createOpenBoxAttributedString:(NSString *)nickName prizeName:(NSString *)prizeName prizeNum:(NSNumber *)num boxTypeStr:(NSString *)boxTypeStr;

//创建开箱子公屏信息
+ (NSMutableAttributedString *)createOpenBoxAttributedString:(NSString *)nickName prizeName:(NSString *)prizeName prizeNum:(NSNumber *)num;

//创建拉黑/踢出房间/踢下麦富文本
+ (NSMutableAttributedString *)creatKick:(BaseAttributedStringKickType)kickTye handleNick:(NSString *)handleNick targetNick:(NSString *)targetNick;
//排麦的时候管理员抱人上麦
+ (NSMutableAttributedString *)createEmbrace:(NSString *)nick;

/// 根据字体颜色&字体大小生成富文本属性字典
/// @param textColor 字体颜色
/// @param size 字体大小
+ (NSDictionary *)textAttributedWithColor:(UIColor *)textColor size:(CGFloat)size;

//系统通知富文本
+ (NSMutableAttributedString *)creatSysNobleNotify:(NSString *)nick andSingleNobleInfo:(PrivilegeInfo *)singleNobleInfo typeStr:(NSString *)typeStr;

/**
 生成机器人退出房间自定义消息

 @param robotName 机器人名字
 @return 富文本
 */
+ (NSMutableAttributedString *)creatRobotOutRoomStrBy:(NSString *)robotName;

/** 官方的官字*/
+ (NSMutableAttributedString *)makeOfficalImage:(UserInfo *)userInfo;

/** 新人的新*/
+ (NSMutableAttributedString *)makeNewImage:(UserInfo *)userInfo;
@end
