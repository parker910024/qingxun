//
//  GiftInfo.h
//  BberryCore
//
//  Created by chenran on 2017/7/13.
//  Copyright © 2017年 chenran. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseObject.h"

//送礼物对象类型
typedef enum : NSUInteger {
    SendGiftType_Room = 1, //轻聊或者竞拍房
    SendGiftType_Person = 2, //私聊
    SendGiftType_RoomToPerson = 3,//游戏房
} SendGiftType;

//礼物类型
typedef NS_ENUM(NSUInteger, GiftType) {
    GiftType_Talk = 1, // 轻聊或者竞拍房礼物
    GiftType_Game = 2, // 游戏轰趴礼物
    GiftType_Lucky = 3, // 福袋礼物
    GiftType_Card = 4,//卡片礼物
    GiftType_PublicChat = 5, // 公聊礼物
};

//游戏房礼物类型
typedef enum : NSUInteger {
    
    GameRoomGiftType_Normal,//普通礼物
    GameRoomGiftType_GiftPack,//背包礼物
    GameRoomGiftType_Noble,//贵族礼物
    GameRoomGiftType_PearGift,// 鸭梨礼物
} GameRoomGiftType;

#pragma mark -
#pragma mark 公会线萝卜礼物
/**
 赠送类型 1给主播直接刷礼物，2私聊送个人礼物,3房间内给坑位上的人送礼物,5.公聊大厅给人送礼物
 */

/**
 赠送类型 1给主播直接刷礼物，2私聊送个人礼物,3房间内给坑位上的人送礼物,5.公聊大厅给人送礼物
 
 - GameRoomSendType_Room: 给主播直接刷礼物
 - GameRoomSendType_Chat: 2私聊送个人礼物
 - GameRoomSendType_OnMic: 3房间内给坑位上的人送礼物
 - GameRoomSendType_PublicChat: 公聊大厅给人送礼物
 - GameRoomSendType_Team 群聊礼物
 */
typedef NS_ENUM(NSUInteger, GameRoomSendType) {
    GameRoomSendType_Room = 1,
    GameRoomSendType_Chat = 2,
    GameRoomSendType_OnMic = 3,
    GameRoomSendType_PublicChat = 5,
    GameRoomSendType_Team = 6,
};


/**
 送礼物的类型，1全麦，2多人非全麦，3个人送礼w

 - GameRoomSendGiftType_AllMic: 全麦
 - GameRoomSendGiftType_MutableOnMic: 多人w非全麦
 - GameRoomSendGiftType_ToOne: 对个人送礼
 */
typedef NS_ENUM(NSUInteger, GameRoomSendGiftType) {
    GameRoomSendGiftType_AllMic,
    GameRoomSendGiftType_MutableOnMic,
    GameRoomSendGiftType_ToOne,
};


/**
 礼物消费类型

 - GiftConsumeTypeCoin: 金币
 - GiftConsumeTypeCarrot: 萝卜
 */
typedef NS_ENUM(NSUInteger, GiftConsumeType) {
    GiftConsumeTypeCoin = 1, // 金币礼物
    GiftConsumeTypeCarrot = 2,  // 鸭梨礼物
    GiftConsumeTypeValueAdd = 3, // 增值礼物
    GiftConsumeTypeBox = 4, // 盲盒礼物
};


@interface GiftTips : BaseObject

/// 背景图
@property (nonatomic, strong) NSString *picUrl;
/// 标题
@property (nonatomic, strong) NSString *title;
/// 描述
@property (nonatomic, strong) NSString *content;
/// 跳转 url
@property (nonatomic, strong) NSString *skipUrl;

@end

@interface GiftAvatar : BaseObject

/// 送礼人头像
@property (nonatomic, strong) NSString *sendAvatar;
/// 送礼人昵称
@property (nonatomic, strong) NSString *sendNick;
/// 收礼人头像
@property (nonatomic, strong) NSString *receiveAvatar;
/// 收礼人昵称
@property (nonatomic, strong) NSString *receiveNick;
// MP4 视频大小
@property (nonatomic, strong) NSString *fileSize;
@end

@interface GiftInfo : BaseObject
/** 礼物id     */
@property (nonatomic, assign)NSInteger giftId;
/** 礼物名字  */
@property (nonatomic, strong)NSString *giftName;
/** 价格 */
@property (nonatomic, assign)double goldPrice;
/** 礼物url */
@property (nonatomic, copy)NSString *giftUrl;
/** 动图地址？？？ */
@property (nonatomic, copy)NSString *gifUrl;

@property (nonatomic, assign) BOOL hasGifPic;
@property (nonatomic, assign) GiftType giftType;//礼物类型
/** 是否有vgg特效 */
@property (assign, nonatomic) BOOL hasVggPic;
/** 动效url */
@property (copy, nonatomic) NSString *vggUrl;
@property (assign, nonatomic) BOOL hasLatest; //是否最新
@property (assign, nonatomic) BOOL hasTimeLimit; //是否限时
@property (assign, nonatomic) BOOL hasEffect; //是否特效
@property (assign, nonatomic) BOOL roomExclude; //是否是房间专属礼物
@property (assign, nonatomic) BOOL isNobleGift; //是否是贵族礼物

@property (nonatomic, assign) int nobleId;//礼物等级

@property (nonatomic,assign) BOOL isSendMsg;//是否支持发广播
//isSelected 用于本地修改
@property (nonatomic,assign) BOOL isSelected;//是否被选中

/** 是否是全服礼物 */
@property (nonatomic,assign) BOOL isWholeServer;

/**-------------  礼物背包 ----------------**/
@property (nonatomic, assign) NSInteger count;//
@property (nonatomic, assign) UserID uid;//用户id

//周星榜
@property (strong , nonatomic) NSString *picUrl;
//   1;// 金币礼物，2;// 鸭梨礼物，3;// 增值礼物， 4;// 盲盒礼物
@property (nonatomic, assign) GiftConsumeType consumeType;
/// 礼物tips
@property (nonatomic, strong) GiftTips *tips;

@property (nonatomic, assign) NSInteger confessStatus;  // 0：不是表白礼物，1：是表白礼物
@property (nonatomic, strong) NSString *mp4Url; // mp4链接

@property (nonatomic, strong) NSString *mp4Key; // 用于当前大礼物是否需要展示送礼人与收礼人头像和昵称的 key

@property (nonatomic, strong) GiftAvatar *giftMp4Key;
@end
