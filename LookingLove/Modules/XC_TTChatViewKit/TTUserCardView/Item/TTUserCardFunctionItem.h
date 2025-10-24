//
//  TTUserCardFunctionItem.h
//  TuTu
//
//  Created by 卫明 on 2018/11/16.
//  Copyright © 2018 YiZhuan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "UserCore.h"

NS_ASSUME_NONNULL_BEGIN

typedef enum : NSUInteger {
    TTUserCardFunctionItemType_SendGift = 1, //送礼物
    TTUserCardFunctionItemType_SendMagic = 2,//发魔法
    TTUserCardFunctionItemType_SendDress = 3,//送装扮
    TTUserCardFunctionItemType_Foucs = 4,//关注
    
    TTUserCardFunctionItemType_Kick = 5,//踢出
    TTUserCardFunctionItemType_SetManager = 6,//设置管理员
    TTUserCardFunctionItemType_CancelManager = 7,//取消管理员
    TTUserCardFunctionItemType_Black = 8,//加入黑名单
    
    TTUserCardFunctionItemType_CloseMic = 9,//闭麦
    TTUserCardFunctionItemType_OpenMic = 10,//开麦
    TTUserCardFunctionItemType_MicUp = 11,//抱上麦位
    TTUserCardFunctionItemType_MicDown = 12,//抱下麦位
    TTUserCardFunctionItemType_LockPosition = 13,//锁麦
    TTUserCardFunctionItemType_UnlockPosition = 14,//开锁
    TTUserCardFunctionItemType_DownBySelf = 15,//下麦旁听
    
    TTUserCardFunctionItemType_PersonPage = 16, //个人主页
    TTUserCardFunctionItemType_Find = 17,//踩Ta
    TTUserCardFunctionItemType_RoomChat = 18,//房间内私聊
    TTUserCardFunctionItemType_DisableSendMsg = 19, // 禁言
} TTUserCardFunctionItemType;

@interface TTUserCardFunctionItem : NSObject

@property (strong, nonatomic) UIImage *normalIcon;

@property (copy, nonatomic) NSString *normalTitle;

@property (strong, nonatomic) UIImage *disableIcon;

@property (nonatomic,copy) NSString *disableTitle;

/**
 用户block 带uid
 */
@property (nonatomic,copy) void (^actionBolock)(UserID uid , NSIndexPath *indexPath, TTUserCardFunctionItem *item);

/**
 用户点击block 带用户信息
 */
@property (nonatomic,copy) void (^actionUserBlock)(UserInfo *userInfo , NSIndexPath *indexPath, TTUserCardFunctionItem *item);

/**
 用户信息卡的uid
 */
@property (nonatomic,assign) UserID actionId;

/**
 在用户信息卡中间的功能区，这个值可以进行两种状态的切换，并不会关闭交互；在用户信息卡下面的功能区，这个值会切换状态，并且会关闭交互
 */
@property (nonatomic,assign) BOOL isDisable;

/**
 类型，只做回传，内部不做任何处理
 */
@property (nonatomic,assign) TTUserCardFunctionItemType type;

@end

NS_ASSUME_NONNULL_END
