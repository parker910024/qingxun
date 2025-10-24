//
//  RoomCoreClient.h
//  BberryCore
//
//  Created by chenran on 2017/5/27.
//  Copyright © 2017年 chenran. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RoomInfo.h"
#import "MicroListInfo.h"
#import "Attachment.h"
#import <NIMSDK/NIMSDK.h>
#import "StrangerRoomInfo.h"
#import "StrangerCoupleInfo.h"
#import "RoomOnMicGiftValue.h"
#import "RoomVisitRecord.h"
#import "RoomEnterGreeting.h"
#import "RoomLoveModelSuccess.h"

typedef enum : NSUInteger {
    
    RoomUpdateEventTypeOther,
    RoomUpdateEventTypeOpenGiftEffect,
    RoomUpdateEventTypeCloseGiftEffect,
    RoomUpdateEventTypeOpenAudioHight,
    RoomUpdateEventTypeCloseAudioHight,
    RoomUpdateEventTypeOpenMessageView,
    RoomUpdateEventTypeCloseMessageView,

} RoomUpdateEventType;

@protocol RoomCoreClient <NSObject>

@optional
//收到龙珠消息龙珠
- (void)onRecvChatRoomDragonMsg:(NIMMessage *)message;


- (void)onOpenRoomSuccess:(RoomInfo *)roomInfo;
- (void)onOpenRoomFailth:(NSNumber *)resCode message:(NSString *)message;

- (void)onUpdateRoomInfoSuccess:(RoomInfo *)roomInfo;
- (void)onUpdateRoomInfoFailth:(NSString *)message;

- (void)onCurrentRoomMsgUpdate:(NSMutableArray *)messages;

- (void)onSpeakUsersReport:(NSArray *)userInfos;
- (void)onMySpeakStateUpdate:(BOOL)speaking;

- (void)mySelfIsInBalckList:(BOOL)state;//当前用户是否在黑名单里面

- (void)userInterRoomWith:(NIMChatroomMember *)member;//用户进入
- (void)userExitChatRoomWith:(NSString *)userId;//用户退出

- (void)requestUserRoomInterInfo:(RoomInfo *)info uid:(UserID)uid; //用户当前进入房间信息成功
- (void)requestUserRoomInterInfoFailth:(NSString *)message; //获取用户当前进入房间信息失败
- (void)thereIsNoMicoPrivacy;//没有麦克风权限

- (void)onManagerAdd:(NIMChatroomMember *)member;//添加管理员
- (void)onManagerRemove:(NIMChatroomMember *)member;//移除管理员

- (void)userBeAddBlack:(NIMChatroomMember *)member; //用户被加入黑名单
- (void)userBeRemoveBlack:(NIMChatroomMember *)member; //用户被移除黑名单


- (void)onGameRoomInfoUpdateSuccess:(RoomInfo *)info eventType:(RoomUpdateEventType)eventType; //房间信息更新成功
- (void)onGameRoomInfoUpdateFailth:(NSString *)message; //房间信息更新失败
- (void)onMicroStateChange; //麦序改变

- (void)onCloseRoomSuccess;
- (void)onCloseRoomFailth:(NSString *)message code:(NSNumber*)code;

- (void)onReceiveNobleBroadcastMsg:(NSString *)content;//收到贵族系统广播
- (void)onReceiveGiftBoardcast:(NSString *)content;//收到全服礼物广播
- (void)onReceiveMonsterGameBoardcast:(NSString *)content;//收到怪兽相关广播

- (void)onReceiveAllBoardcast:(NSString *)content;//收到广播的时候

//清除单条缓存的消息
- (void)onMessageDidRemoveFromCache:(NIMMessage *)message;

//清除多条缓存的消息
- (void)onMessagesDidRemoveFromCache:(NSArray *)message;

// 更改房间离开模式状态成功
- (void)onChangeRoomLeaveModeSuccess:(BOOL)leaveMode;
// 更改房间离开模式状态失败
- (void)onChangeRoomLeaveModeFailth:(NSString *)message code:(NSNumber *)code;

/** 开启离线模式发送自定义消息处理事件 */
- (void)onNoticeRoomIsOpenLeaveMode:(NIMMessage *)message;
/**
 青少年模式下，房间在线时长达到上限
 
 @param msg 提示的信息
 */
- (void)roomOnLineTimsMaxWithMessage:(NSString *)msg;
#pragma mark - CP陌生人房间

/** 陌生人房间创建成功*/
- (void)onCreatStrangerSuccessWithRoomInfo:(RoomInfo *)roomInfo;
/** 陌生人房间创建失败*/
- (void)onCreatStrangerFailth:(NSString *)message;

/** 创建帖子陌生人房成功*/
- (void)onCreatDynamicStrangerSuccessWithRoomInfo:(RoomInfo *)roomInfo;
/** 创建帖子陌生人房失败*/
- (void)onCreatDynamicStrangerFailth:(NSString *)message;

/** 陌生人房间列表数据*/
- (void)onStrangerRoomListSuccess:(NSArray<StrangerRoomInfo*> *)roomList;
/** 陌生人房间列表数据失败*/
- (void)onStrangerRoomListFailth:(NSString *)msg;


/** 陌生人匹配*/
- (void)onStrangerFindRoomSuccess:(RoomInfo *)roomInfo;
/** 陌生人匹配失败*/
- (void)onStrangerFindRoomFailth:(NSString *)msg;

/** 陌生人房间title*/
- (void)onStrangerRoomInfoSuccess:(RoomInfo *)roomInfo;
- (void)onStrangerRoomInfoFailth:(NSString *)msg;


/**
 陌生人绑定cp

 @param coupleInfo coupleInfo
 @param isAgree 用于私聊 是否是答应TA
 */
- (void)onStrangerBindCpSuccess:(StrangerCoupleInfo *)coupleInfo withIsAgree:(BOOL)isAgree;
- (void)onStrangerBindCpFailth:(NSString *)msg;

- (void)onStrangeJoinRoomSuccess;
- (void)onStrangeJoinRoomFailth:(NSString *)msg;

/**
 和他组Cp
 */
- (void)onStrangerMessageWishCoupleSuccess:(StrangerCoupleInfo *)coupleInfo sender:(id)sender;
- (void)onStrangerMessageWishCoupleFailth:(NSString *)msg sender:(id)sender;


/**
 答应他
 */
- (void)onStrangerMessageAgreeCoupleSuccess:(StrangerCoupleInfo *)coupleInfo;
- (void)onStrangerMessageAgreeCoupleFailth:(NSString *)msg;

//超管踢出管理员
- (void)onReceiveSuperAdminKickUsersWithMessage:(NIMMessage *)message;

- (void)onReceiveSuperAdminOffical:(NIMMessage *)message;

/**
 中四级奖品
 */
- (void)onReceiveOpenBoxBigPrizeMsg:(NIMMessage *)message;

/**
 接收到清除礼物值同步消息

 @param giftValue 清除后麦位礼物值信息
 */
- (void)onReceiveCleanGiftValueSync:(RoomOnMicGiftValue *)giftValue;

#pragma mark Room Visit Record
/// 进房记录
- (void)responseRoomVisitRecord:(NSArray<RoomVisitRecord *> *)data errorCode:(NSNumber *)code msg:(NSString *)msg;
/// 进房记录清除
- (void)responseRoomVisitRecordClean:(BOOL)success errorCode:(NSNumber *)code msg:(NSString *)msg;

#pragma mark Room Enter Greeting
/// 进房欢迎语
- (void)responseRoomEnterGreeting:(RoomEnterGreeting *)data errorCode:(NSNumber *)code msg:(NSString *)msg;

#pragma mark Focus Owner
/// 关注房主结果通知
- (void)onRecvFocusOwner:(NIMMessage *)message;

//游戏消息
- (void)responseRoomGame:(Attachment *)data;


// 相亲房相亲结果通知（动画)
- (void)onRecvBlindDateResult:(RoomLoveModelSuccess *)model;

// 相亲房公布心动结果通知（动画)
- (void)onRecvBlindDatePublicLoveResult:(NIMMessage *)message;
@end
