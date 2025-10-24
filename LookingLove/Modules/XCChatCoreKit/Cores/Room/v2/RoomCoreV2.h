//
//  RoomCoreV2.h
//  BberryCore
//
//  Created by Mac on 2017/12/12.
//  Copyright © 2017年 chenran. All rights reserved.
//

#import "BaseCore.h"
#import "RoomInfo.h"
#import <NIMSDK/NIMSDK.h>
#import "RoomCoreClient.h"
#import "RoomRedConfig.h"
#import "RoomRedListItem.h"
#import "RoomRedDetail.h"

NS_ASSUME_NONNULL_BEGIN

typedef enum {
    RoomDragonState_Not = 0,// 不参与龙珠 游戏
    RoomDragonState_Start = 1,//开始龙族游戏
    RoomDragonState_Open = 2,//展示龙珠（本局龙珠结束）
    RoomDragonState_Cancel = 3,//取消龙珠游戏 （本局龙珠结束）
}RoomDragonState;

typedef enum {
    UpdateRoomInfoTypeUser = 0, // 房主
    UpdateRoomInfoTypeManager = 1, // 管理员
} UpdateRoomInfoType;


typedef enum : NSUInteger {
    JoinRoomFromType_Other = 0,//其他
    JoinRoomFromType_Community = 1,//从社区进入房间
    JoinRoomFromType_PartyRoom = 2, // 从房间进入嗨聊房、派对匹配
} JoinRoomFromType;

/// 超管操作类型
typedef NS_ENUM(NSUInteger, SuperAdminOperateType) {
    SuperAdminOperateTypeUnlockRoom = 1, // 解除进房限制，目标为房间
    SuperAdminOperateTypeLockMic = 2, // 锁麦，目标为麦位
    SuperAdminOperateTypeCloseMic = 3, // 闭麦，目标为麦位
    SuperAdminOperateTypeDownkMic = 4, // 抱TA下麦，目标为用户，包括房主
    SuperAdminOperateTypeTickRoom = 5, // 踢出房间，目标为用户，除房主外
    SuperAdminOperateTypeBlackUser = 6, // 加入黑名单，目标为用户，除房主外
    SuperAdminOperateTypeCloseRoom = 7, // 关闭房间，目标为房间
    SuperAdminOperateTypeHiddenRoom = 8, // 隐藏房间，目标为房间
    SuperAdminOperateTypeCloseMessage = 9, // 关闭公屏消息，目标为房间
    SuperAdminOperateTypeOpenMessage = 10, // 开启公屏消息，目标为房间
    SuperAdminOperateTypeUnBlack = 11, //移除黑名单，目标为用户
};


@class FaceSendInfo;
@interface RoomCoreV2 : BaseCore

@property (nonatomic, assign) BOOL isInRoom;
@property (nonatomic, strong) NSMutableArray *speakingList;//说话list
@property (nonatomic, strong) NSMutableArray *messages;//消息
@property (nonatomic, strong) NSMutableArray *positionArr; //麦序位置
@property (nonatomic, assign) CGPoint avatarPosition; //房主头像位置

@property (nonatomic, assign) BOOL hasChangeGiftEffectControl;//记录本地是否操作过礼物特效
@property (nonatomic, assign) BOOL hasAnimationEffect;//记录本地是否有礼物特效与服务端无关

/****社区****/
@property (nonatomic, assign) JoinRoomFromType fromType;//进入房间类型
@property (nonatomic, copy) NSString *fromNick;//社区作品昵称

//龙珠
@property (nonatomic, strong) FaceSendInfo  *currenDragonFaceSendInfo;//当前 自己 龙族结果
@property (nonatomic, assign) RoomDragonState dragonState;//龙珠游戏状态
@property (nonatomic, strong) NSMutableArray<FaceSendInfo *> *dragonArray;//麦序上 只保存 最开始 龙珠的状态

@property (nonatomic, assign) BOOL openBoxSwitch;//宝箱开关  YES 展示  NO 隐藏

@property (nonatomic, assign) NSInteger openBoxLimitLevel;//开箱子 大于等级  展示

/** 平台是否隐藏红包，因为云信不下发该字段，所以从接口获取并保存 */
@property (nonatomic, assign) BOOL hideRedPacket;

/// 当前红包列表
@property (nonatomic, strong, nullable) NSArray<RoomRedListItem *> *redList;

#pragma mark - Dragon Ball
/**
 获取龙珠

@param roomUid 房间id
@param uid  用户id
*/
- (void)getDragonWithRoomUid:(UserID )roomUid
                         uid:(UserID )uid
                     success:(void (^)(NSArray* ballList, BOOL isNew))success
                     failure:(void (^)(NSNumber *code, NSString *msg))failure;

/**
 清除龙珠状态
 @param roomUid 房间id
 @param uid  用户id
 */
- (void)clearDragonWithRoomUid:(UserID )roomUid uid:(UserID )uid;



//房间操作
-(void)rewardAndOpenRoom:(UserID)uid rewardMonye:(NSInteger)rewardMonye title:(NSString *)title roomDesc:(NSString *)roomDesc backPic:(NSString*)backPic;//开启竞拍房
-(void)openRoom:(UserID)uid type:(RoomType)type title:(NSString *)title roomDesc:(NSString *)roomDesc backPic:(NSString*)backPic rewardId:(NSString *)rewardId;//开启房间



/**
 
 开启房间成功的回调。 需要增加一个回调来去掉开启房间时的loading
 
 **/

- (void)openCPRoom:(UserID)uid type:(RoomType)type title:(NSString *)title roomDesc:(NSString *)roomDesc backPic:(NSString *)backPic rewardId:(NSString *)rewardId success:(void (^)(BOOL success))success;

/**
 解除房间限制或上锁
 
 @param limitType 限制类型
 @param roomPwd 房间密码
 @param success 成功
 @param failure 失败
 */
- (void)unlockRoomLimitType:(NSString *)limitType roomPwd:(NSString *)roomPwd success:(void (^)(void))success failure:(void (^)(NSNumber *, NSString *))failure;

/**
 更新房间信息

 @param infoDict 房间信息字典
 @param type eventType
 */
- (void)updateGameRoomInfo:(NSDictionary *)infoDict
                      type:(UpdateRoomInfoType)type;
/**
 更新房间信息

 @param infoDict 房间信息字典
 @param type 更新房间的类型(房主/管理员)
 @param hasAnimationEffect hasAnimationEffect
 @param audioQuality audioQuality
 @param eventType eventType
 */
- (void)updateGameRoomInfo:(NSDictionary *)infoDict
                      type:(UpdateRoomInfoType)type
        hasAnimationEffect:(BOOL)hasAnimationEffect
              audioQuality:(AudioQualityType)audioQuality
                 eventType:(RoomUpdateEventType)eventType;


//更新房间关闭公屏状态
- (void)updateRoomMessageViewState:(UserID)uid isCloseScreen:(BOOL)isCloseScreen;

//更新房间关闭公屏状态 是不是超管
- (void)updateRoomMessageViewState:(UserID)uid isCloseScreen:(BOOL)isCloseScreen isSuperAdmin:(BOOL)isSuperAdmin;

-(void)closeRoom:(UserID)uid;

/**
 关房（block）

 @param uid uid
 @param success 成功
 @param failure 失败
 */
- (void)closeRoomWithBlock:(UserID)uid Success:(void(^)(UserID uid))success failure:(void(^)(NSNumber *resCode, NSString *message))failure;

//房间统计
- (void)recordTheRoomTime:(UserID)uid roomUid:(UserID)roomUid;//房间统计
- (void)reportUserInterRoom; //用户进入房间上报
- (void)reportUserOuterRoom; //用户退出房间上报
- (void)savePosition:(NSMutableArray *)list;  //保存游戏房cell的位置

//添加消息到内存，最多保留200
- (void)addMessageToArray:(NIMMessage *)msg;

//获取房间信息
- (RACSignal *)requestRoomInfo:(UserID) uid;//请求房间信息
- (RoomInfo *) getCurrentRoomInfo;//当前房间信息
- (void)getUserInterRoomInfo:(UserID)uid;//获取用户进入了的房间的信息

/**
 获取用户进入了的房间的信息
*/
- (void)getUserInterRoomInfo:(UserID)uid Success:(void (^)(RoomInfo *roomInfo))success failure:(void (^)(NSNumber *resCode, NSString *message))failure;

/**
 获取用户进入了的房间的信息

 @param uid 用户uid
 @return rac roominfo
 */
- (RACSignal *)rac_getUserInterRoomInfo:(UserID)uid;


//黑名单
- (void)judgeIsInBlackList:(NSString *)roomID; //查询自己

//发送聊天室消息成功
- (void)onSendChatRoomMessageSuccess:(NIMMessage *)msg;

/**
 开启房间离开模式
 interface 开启 room/leave/mode/open ， 关闭 room/leave/mode/close
 @param roomUid 房间uid
 @param leaveMode YES 开启 or NO 关闭
 */
- (void)requestChangeRoomLeaveMode:(long long)roomUid leaveMode:(BOOL)leaveMode;

#pragma mark - CP陌生人房间

/**
 创建房间
 */
- (void)requestStrangerWithCreat;

/**
 创建帖子陌生人房
 */
- (void)requestDynamicStrangerWithCreat;


/*
 请求陌生人房间k列表
 */
- (void)requestStrangerRoomListWithStart:(NSUInteger)pageNum page:(NSUInteger)pageSize;



/**匹配陌生人*/
- (void)requestStrangerWithFindRoom;

/**陌生人房间编辑*/
- (void)requestStrangerRoomInfo:(UserID)roomId title:(NSString *)title;

/**
 陌生人绑定cp
 
 @param coupleUid uid
 @param roomId id
 @param isAgree 用于私聊 是否是答应TA
 @param type 0为陌生人房间 1为私聊传入
 */
- (void)requestStrangerBindCpWithRoomInfo:(UserID)roomId coupleUid:(UserID)coupleUid withIsAgree:(BOOL)isAgree withType:(int)type;

- (void)requestUserP2PUidOuterRoom:(UserID)roomUid withUid:(UserID)uid; //p2p用户退出房间上报

- (void)requestP2PUidInterRoomUid:(UserID)roomUid; //进入房间上报

/**
 发送组Cp请求 查看是否符合组cp

 @param coupleUid cpuid
 @param type 0为陌生人房间 1为私聊传入
 */
- (void)requeStrangerMessageWishCoupleUid:(UserID)coupleUid withType:(int)type sender:(id)sender;

/**
 和Ta组cp答应他
 
 @param coupleUid cpuid
 @param roomId 房间id
 */
- (void)requeStrangerMessageAgreeCoupleUid:(UserID)coupleUid withRoomId:(NSInteger)roomId;


/* CP房 邀请好友*/
-(void)getRoomInviteUid:(NSArray *)array roomUid:(UserID )roomUid success:(void (^)(void))success;

#pragma mark - officalManagerRoomSetting

/**
 隐藏房间

 @param hideFlag 是否隐藏房间
 */
- (void)requestSettingHideRoom:(BOOL)hideFlag success:(void (^)(BOOL success))success;

//fengshuo start
/**
房间超管

 @param targetUid 目标的uid
 @param opt //1: 设置为管理员;2:设置普通等级用户;-1:设为黑名单用户;-2:设为禁言用户
 @param success 成功
 */
- (void)requsetRoomSettingSuperAdminWithTargetUid:(UserID)targetUid opt:(int)opt success:(void (^)(BOOL success))success;

/**
 发送自定义消息
 
 @param targetUserid 目标的uid
 @param targetName 目标的名字
 @param position 坑位
 @param second second
 */
- (void)sendCustomMessageToManagerOutRoomWithTargetUid:(UserID)targetUserid targetName:(NSString *_Nullable)targetName position:(NSString * _Nullable)position second:(Custom_Noti_Sub_Room_SuperAdmin)second;
//fengshuo end

/**
 超管官方管理操作
 */
- (void)sendOfficalManagerCustomMessage:(Custom_Noti_Sub_Room_SuperAdmin)type;

#pragma mark -
#pragma mark 超管操作记录统计
/// 超管操作的事项进行统计
- (void)recordSuperAdminOperate:(SuperAdminOperateType)operateType
                  superAdminUid:(UserID)uid
                        roomUid:(UserID)roomUid
                      targetUid:(UserID)targetUid;

/// 进房记录
- (void)requestRoomVisitRecord;
/// 进房记录清除
- (void)requestRoomVisitRecordClean;

/// 进房欢迎语
/// 接收方uid
- (void)requestRoomEnterGreetingToUid:(NSString *)toUid;

/// 进房欢迎语
/// 接收方uid
- (void)requestRoomEnterGreetingToUid:(NSString *)toUid completion:(void(^_Nullable)(RoomEnterGreeting * _Nullable data, NSNumber * _Nullable code, NSString * _Nullable msg))completion;

/// 获取红包配置信息
- (void)requestRoomRedConfigCompletion:(void(^)(RoomRedConfig * _Nullable data, NSNumber * _Nullable code, NSString * _Nullable msg))completion;

/// 红包分享
/// @param roomUid 房主uid
/// @param packetId 红包id
- (void)requestRoomRedShare:(NSString *)packetId
                    roomUid:(NSString *)roomUid
                 completion:(void(^)(BOOL success, NSNumber * _Nullable code, NSString * _Nullable msg))completion;

/// 获取房间内可抢的红包列表
/// @param roomUid 房主uid
- (void)requestRoomRedList:(NSString *)roomUid
                completion:(void(^)(NSArray<RoomRedListItem *> *_Nullable data, NSNumber * _Nullable code, NSString * _Nullable msg))completion;

/// 获取红包详情
/// @param packetId 红包id
- (void)requestRoomRedDetail:(NSString *)packetId
                  completion:(void(^)(RoomRedDetail * _Nullable data, NSNumber * _Nullable code, NSString * _Nullable msg))completion;

/// 抢红包
/// @param packetId 红包id
- (void)requestRoomRedDraw:(NSString *)packetId
                completion:(void(^)(NSString * _Nullable data, NSNumber * _Nullable code, NSString * _Nullable msg))completion;

/// 发红包
- (void)requestRoomSendRedByRoomUid:(UserID)roomUid amount:(NSInteger)amount num:(NSInteger)num requirementType:(int)requirementType notifyText:(NSString *_Nullable)notifyText
completion:(void(^_Nonnull)(NSDictionary * _Nullable data, NSNumber * _Nullable code, NSString * _Nullable msg))completion;

@end

NS_ASSUME_NONNULL_END
