//
//  RoomMagicInfo.h
//  BberryCore
//
//  Created by Mac on 2018/3/16.
//  Copyright © 2018年 chenran. All rights reserved.
//
//  魔法列表
#import "BaseObject.h"
#import "UserInfo.h"
#import "RoomOnMicGiftValue.h"

typedef enum : NSUInteger {
    RoomMagicPlayPostionCenter = 1,
    RoomMagicPlayPostionLeft,
    RoomMagicPlayPostionRight,
    RoomMagicPlayPostionTop,
    RoomMagicPlayPostionBottom,
} RoomMagicPlayPostion;

@interface RoomMagicInfo : BaseObject
//id
@property (nonatomic, assign) NSInteger magicId;
//名称
@property (nonatomic, copy) NSString *magicName;
//价格
@property (nonatomic, assign) int magicPrice;
//icon
@property (nonatomic, copy) NSString *magicIcon;
//魔法svg
@property (nonatomic, copy) NSString *magicSvgUrl;
//特效svg
@property (nonatomic, copy) NSString *effectSvgUrl;
//播放位置(1中点播放，其它都是非中点播放)
@property (nonatomic, assign) RoomMagicPlayPostion playPosition;
//贵族等级(0为非贵族)
@property (nonatomic, assign) int nobleId;
//前端添加字段 是否选中
@property (nonatomic, assign) BOOL isSelected;
//伤害值，打怪兽专用
@property (nonatomic,assign) NSInteger impactValue;


//-------------receive---------------
//收到魔法num
@property (nonatomic, assign) int giftMagicNum;
//收到魔法id
@property (nonatomic, assign) NSInteger giftMagicId;
//送魔法uid
@property (nonatomic, assign) UserID uid;
//送魔法nick
@property (nonatomic, copy) NSString *nick;
//送魔法头像
@property (nonatomic, copy) NSString *avatar;
//收p2p魔法uid
@property (nonatomic, assign) UserID targetUid;
//收p2p魔法nick
@property (nonatomic, copy) NSString *targetNick;
//收p2p魔法头像
@property (nonatomic, copy) NSString *targetAvatar;
//是否播放特效。true为播放，false为不播放
@property (nonatomic, assign) BOOL playEffect;
//全麦收魔法uid集合
@property (nonatomic, strong) NSArray *targetUids;
/** 非全麦 多人送礼时 */
@property (nonatomic, copy) NSArray<UserInfo *> *targetUsers;
/** 是否是 非全麦 多人送礼 (自定义字段, 不是后台返回) */
@property (nonatomic, assign) BOOL isBatch;
    
/**
 当前礼物时间，用于判断接收礼物先后
 */
@property (nonatomic, copy) NSString *currentTime;
/**
 礼物值信息
 */
@property (nonatomic, strong) NSArray<RoomOnMicGiftValueDetail *> *giftValueVos;

@end
