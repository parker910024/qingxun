//
//  GuildCheckEmojiCode.h
//  XCChatCoreKit
//
//  Created by lee on 2019/2/27.
//  Copyright © 2019 KevinWang. All rights reserved.
//

#import "BaseObject.h"


/**
 校验暗号邀请码的的类型

 - CheckEmojiCodeResultTypeInvalid: 失效 or 不存在的类型
 - CheckEmojiCodeResultTypeGuild: 公会邀请码类型
 */
typedef NS_ENUM(NSUInteger, CheckEmojiCodeResultType) {
    /** 失效 or 不存在 */
    CheckEmojiCodeResultTypeInvalid = 0,
    /** 公会邀请码 */
    CheckEmojiCodeResultTypeGuild = 1,
};


/**
 检验暗号是不是会显示弹窗

 - CheckEmojiCodeAlertStatusClose: 不显示
 - CheckEmojiCodeAlertStatusShow: 显示
 */
typedef NS_ENUM(NSUInteger, CheckEmojiCodeAlertStatus) {
    CheckEmojiCodeAlertStatusClose = 0,
    CheckEmojiCodeAlertStatusShow = 1,
};
NS_ASSUME_NONNULL_BEGIN

@interface GuildCheckEmojiCode : BaseObject
/** 昵称 */
@property (nonatomic, copy) NSString *nick;
/** 公会模厅名字 */
@property (nonatomic, copy) NSString *hallName;
/** 校验不通过的code */
@property (nonatomic, assign) NSInteger code;
/** 校验不通过的msg     */
@property (nonatomic, copy) NSString *msg;
/** 转码之后的暗号，校验成功才会返回，用于加入模厅传参     */
@property (nonatomic, copy) NSString *emojiCode;
/**
 校验暗号邀请码的的类型
 
 - CheckEmojiCodeResultTypeInvalid: 失效 or 不存在的类型
 - CheckEmojiCodeResultTypeGuild: 公会邀请码类型
 */
@property (nonatomic, assign) CheckEmojiCodeResultType type;
/**
 检验暗号是不是会显示弹窗
 
 - CheckEmojiCodeAlertStatusClose: 不显示
 - CheckEmojiCodeAlertStatusShow: 显示
 */
@property (nonatomic, assign) CheckEmojiCodeAlertStatus showDialog;
@end

NS_ASSUME_NONNULL_END
