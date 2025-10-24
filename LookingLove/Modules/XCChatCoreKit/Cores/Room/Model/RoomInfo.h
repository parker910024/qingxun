//
//  RoomInfo.h
//  BberryCore
//
//  Created by chenran on 2017/5/27.
//  Copyright © 2017年 chenran. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserInfo.h"
#import "AuctionInfo.h"
#import "BaseObject.h"
#import "UserBackground.h"

typedef enum {
    RoomType_Auction = 1,//拍卖房
    RoomType_Party = 2, //轻聊房
    RoomType_Game = 3,  //轰趴房
    RoomType_Stranger = 4, //陌生人房
    RoomType_CP = 5, //cp房
    RoomType_Love = 7, // 相亲房
    RoomType_DynamicStranger = 14, //社区红包动态语音房
    RoomType_RingUp = 15 //通话房间
}RoomType;

typedef enum {
    PermitRoomType_Licnese = 1,//牌照
    PermitRoomType_Personal = 2, // 个人
    PermitRoomType_YoungerStar = 3,//新秀
    PermitRoomType_Other//其他
}PermitRoomType;

typedef enum {
    AudioQualityType_low=1,//1：低
    AudioQualityType_High=2//2：高
}AudioQualityType;

typedef NS_ENUM(NSInteger, RoomModeType){
    RoomModeType_Normal_Mode = 0,//普通模式
    RoomModeType_Open_Micro_Mode = 1,//排麦模式
    RoomModeType_Close_Micro_Mode = 2,//非排麦模式
    RoomModeType_Open_PK_Mode = 3,//开启PK
    RoomModeType_Close_PK_Mode = 4,//关闭PK
    RoomModeType_Open_Leave_Mode = 5, // 开启房主离开模式
};

typedef NS_ENUM(NSInteger, BlindDateProcedure) {
    BlindDateProcedure_Indroduce = 1, // 自我介绍
    BlindDateProcedure_selectLove = 2,// 心动选择
    BlindDateProcedure_publicLove = 3,// 公布心动
    BlindDateProcedure_resetIndroduce = 4,// 重新开始
    BlindDateProcedure_selectLoveTimerEnd = 5,// 心动选择倒计时结束
};

@interface RoomInfo : BaseObject

@property(nonatomic, assign) AccountType defUser;

@property(nonatomic, assign) NSInteger officeUser;
@property(nonatomic, copy) NSString *roomPwd;
@property(nonatomic, assign) BOOL canSpringGift;
@property(nonatomic, copy) NSString *backPic;
@property (nonatomic, assign) int abChannelType;
@property(nonatomic, copy) NSString *meetingName;
@property(nonatomic, assign) NSInteger onlineNum;
@property(nonatomic, assign) long createTime;
@property(nonatomic, assign) long updateTime;
@property(nonatomic, assign) long openTime;
@property(nonatomic, assign) NSInteger operatorStatus;
@property(nonatomic, copy) NSString *roomDesc;
@property(nonatomic, assign) NSInteger roomId;
@property(nonatomic, copy) NSString *roomTag;

@property(nonatomic, copy) NSString *avatar; // 房主icon
@property(nonatomic, assign) UserGender gender; // 房主性别
@property(nonatomic, assign) UserID uid;    // 房主 uid
@property(nonatomic, copy) NSString *nick; // 房主昵称

@property(nonatomic, copy) NSString *title;//房间名字
/**
 兔兔的房间类型
 */
@property (nonatomic,assign) PermitRoomType  isPermitRoom;

@property(nonatomic, assign) RoomType type;
@property(nonatomic, assign) BOOL valid;
@property(nonatomic, assign) int tagId;
@property(nonatomic, copy) NSString *tagPict;

//是否关闭公屏消息 yes关闭 false显示
@property (nonatomic, assign) BOOL isCloseScreen;
//公屏操作人：0.房主或管理员；1.超管
@property (nonatomic, assign) int closeScreenFlag;
//true显示动画    false不显示动画
@property (nonatomic, assign) BOOL hasAnimationEffect;
/** 是否是纯净模式 */
@property (nonatomic, assign) BOOL isPureMode;
// 是否关闭砸箱子
@property (nonatomic, assign) BOOL closeBox;

/**
 是否隐藏房间
 */
@property (nonatomic, assign) int hideFlag;

@property (nonatomic, assign) AudioQualityType audioQuality;
@property (nonatomic, strong) UserBackground  *background;//
@property (nonatomic, assign) BOOL hasDragonGame;//是否有龙珠游戏
@property (nonatomic, assign) BOOL isOpenKTV; //是否开启了KTV
@property (nonatomic, assign) BOOL hasKTVPriv; //是否开启KTV权限
/** 房间介绍 */
@property (nonatomic, strong) NSString *introduction;

@property (nonatomic, strong) NSString *limitType; // CP房  房间进入限制
@property (nonatomic, assign) BOOL opengame;
@property (nonatomic, assign) BOOL isOpenGame;
@property (nonatomic, strong) NSDictionary *roomGame;

@property (nonatomic, assign) RoomModeType roomModeType;//房间模式

@property (nonatomic, assign) BOOL showGiftValue;//是否打开礼物值
/** 离开模式 */
@property (nonatomic, assign) BOOL leaveMode;//是否打开离开模式

/** 是否是群聊派对 */
@property (nonatomic, assign) UserID worldId;

/** 平台是否隐藏红包 */
@property (nonatomic, assign) BOOL hideRedPacket;

/** 是否关闭红包 */
@property (nonatomic, assign) BOOL closeRedPacket;

// ---- 相亲房 ------
@property (nonatomic, strong) NSString *chooseTime; // 开始心动选择的时间戳

@property (nonatomic, assign) BlindDateProcedure procedure; // 相亲流程(1 -- 自我介绍, 2-- 心动选择, 3 -- 心动公布, 4 -- 重新开始, 5 -- 心动选择倒计时结束)

@property (nonatomic, strong) NSString *remainderTime; // 倒计时时长
// -------  ////
@end
