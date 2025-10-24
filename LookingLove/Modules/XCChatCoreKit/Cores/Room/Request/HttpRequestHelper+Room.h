//
//  HttpRequestHelper+Room.h
//  BberryCore
//
//  Created by chenran on 2017/5/27.
//  Copyright © 2017年 chenran. All rights reserved.
//

#import "HttpRequestHelper.h"
#import "RewardInfo.h"
#import "RoomInfo.h"
#import "MicroListInfo.h"
#import "StrangerRoomInfo.h"
#import "RoomCoreV2.h"
#import "StrangerCoupleInfo.h"

@interface HttpRequestHelper (Room)



/**
 获取龙珠

 @param roomUid 房间id
 @param uid 用户id
 */
+ (void)getDragonBallWithRoomUid:(UserID )roomUid
                             uid:(UserID )uid
                         success:(void (^)(NSArray* ballList, BOOL isNew))success
                         failure:(void (^)(NSNumber *code, NSString *msg))failure;

/**
 清除龙珠状态
 
 @param roomUid 房间id
 @param uid 用户id
 */
+ (void)clearDragonBallWithRoomUid:(UserID )roomUid
                               uid:(UserID )uid
                           success:(void (^)(BOOL success))success
                           failure:(void (^)(NSNumber *code, NSString *msg))failure;

#pragma mark - 更新房间信息

/**
 更新房间信息

 @param infoDict 房间信息字典
 @param type 修改的类型 (房主/管理员)
 @param hasAnimationEffect hasAnimationEffect
 @param audioQuality audioQuality
 @param success 成功的回调
 @param failure 失败的回调
 */
+ (void)updateRoomInfo:(NSDictionary *)infoDict
                  type:(UpdateRoomInfoType)type
    hasAnimationEffect:(BOOL)hasAnimationEffect
          audioQuality:(AudioQualityType)audioQuality
               success:(void (^)(RoomInfo *))success
               failure:(void (^)(NSNumber *, NSString *))failure;

/**
 开启房间离开模式
 interface room/leave/mode/open
 @param roomUid 房主uid
 */
+ (void)requestChangeRoomLeaveMode:(long long)roomUid
                         leaveMode:(BOOL)leaveMode
                           success:(void (^)(BOOL))success
                           failure:(void (^)(NSNumber *, NSString *))failure;

#pragma mark - 统计相关
/**
 用户退出房间上报

 @param success 成功
 @param failure 失败
 */
+ (void)reportUserOutRoomSuccess:(void (^)(BOOL success))success failure:(void (^)(NSNumber *resCode, NSString *message))failure;
/**
 用户进入房间上报

 @param success 成功
 @param failure 失败
 */
+ (void)reportUserInterRoomSuccess:(void (^)(BOOL success))success failure:(void (^)(NSNumber *resCode, NSString *message))failure;
/**
 房间统计埋点
 
 @param uid uid
 @param roomUid 房主uid
 */
+ (void)recordTheRoomTime:(UserID)uid roomUid:(UserID)roomUid;

#pragma mark - 开房&关房

/**
 开悬赏房交悬赏金接口
 
 @param uid 房主UID
 @param servDura 服务时长
 @param success 成功
 @param failure 失败
 */
+ (void) rewardForRoom:(UserID)uid servDura:(NSInteger)servDura rewardMonye:(NSInteger)rewardMonye
               success:(void (^)(RewardInfo *))success
               failure:(void (^)(NSNumber *resCode, NSString *message))failure;

/**
 开房
 
 @param uid uid
 @param type 房间类型 1、竞拍房 2、悬赏房
 @param title 房间标题
 @param roomDesc 房间介绍
 @param backPic 背景图
 @param rewardId 悬赏id
 @param success 成功
 @param failure 失败
 */
+ (void) openRoom:(UserID)uid type:(RoomType)type title:(NSString *)title roomDesc:(NSString *)roomDesc backPic:(NSString*)backPic rewardId:(NSString *)rewardId
          success:(void (^)(RoomInfo *))success
          failure:(void (^)(NSNumber *resCode, NSString *message))failure;


/**
 关闭房间
 
 @param uid 房主uid
 */
+ (void) closeRoom:(UserID)uid
           success:(void (^)(void))success
           failure:(void (^)(NSNumber *resCode, NSString *message))failure;


#pragma mark - 获取房间信息相关
/**
 通过userId拿房间信息
 
 @param uid 房主uid
 @param success 成
 @param failure 失败
 */
+ (void) getRoomInfo:(UserID) uid
             success:(void (^)(RoomInfo *))success
             failure:(void (^)(NSNumber *resCode, NSString *message))failure;


/**
 通过uids批量获取房间信息
 
 @param uids 房主uids集合
 @param success 成功
 @param failure 失败
 */
+ (void) getRoomInfoByUids:(NSArray *)uids
                   success:(void (^)(NSArray<RoomInfo *> *))success
                   failure:(void (^)(NSNumber *resCode, NSString *message))failure;

/**
 获取用户所在房间信息

 @param uid uid
 @param success 成功
 @param failure 失败
 */
+ (void)requestUserInRoomInfoBy:(UserID)uid Success:(void (^)(RoomInfo *roomInfo))success failure:(void (^)(NSNumber *resCode, NSString *message))failure;

/*
 更新房间关闭公屏状态
 */
+ (void)updateRoomMessageViewState:(UserID)uid
                     isCloseScreen:(BOOL)isCloseScreen
                           success:(void (^)(RoomInfo *info))success
                           failure:(void (^)(NSNumber *resCode, NSString *message))failure;

#pragma mark - 麦序操作
/**
 直接上麦
 
 @param uid 用户UID
 @param roomId roomId
 @param success 成功
 @param failure 失败
 */
+(void)upMicro:(UserID)uid roomId:(UserID)roomId position:(NSInteger)position
       success:(void (^)(void))success
       failure:(void (^)(NSNumber *resCode, NSString *message))failure;

/**
 直接下麦
 
 @param uid 用户UID
 @param roomId roomId
 @param success 成功
 @param failure 失败
 */
+(void)leftMicro:(UserID)uid roomId:(UserID)roomId position:(NSInteger)position
         success:(void (^)(void))success
         failure:(void (^)(NSNumber *resCode, NSString *message))failure;

/**
 锁坑位/取消操作
 @param roomOwnerUid 房主uid
 @param position 位置
 @param state 锁/开坑
 @param success 成功
 @param failure 失败
 */
+ (void)micPlace:(NSInteger)position roomOwnerUid:(UserID)roomOwnerUid state:(NSInteger)state
         success:(void (^)(void))success
         failure:(void (^)(NSNumber *resCode, NSString *message))failure;
/**
 锁麦/开麦操作
 @param roomOwnerUid 房主uid
 @param position 位置
 @param state 锁/开坑
 @param success 成功
 @param failure 失败
 */
+ (void)micState:(NSInteger)position roomOwnerUid:(UserID)roomOwnerUid state:(NSInteger)state
         success:(void (^)(void))success
         failure:(void (^)(NSNumber *resCode, NSString *message))failure;


/**
 踢用户下麦

 @param uid 被踢用户ID
 @param position 位置
 @param roomId 房间id
 @param success 成功
 @param failure 失败
 */
+ (void)ownerKickUserByUid:(NSString *)uid position:(int)position roomId:(int)roomId success:(void (^)(BOOL))success failure:(void (^)(NSNumber *, NSString *))failure ;

/**
 邀请上麦

 @param uid 被邀请人的UID
 @param position 位置
 @param roomId 房间id
 @param success 成功
 @param failure 失败
 */
+ (void)inviteUpMicroWithUid:(UserID)uid position:(int)position roomId:(int)roomId success:(void (^)(BOOL))success failure:(void (^)(NSNumber *, NSString *))failure ;




/**
 获取房间麦序列表
 
 @param ownerUid 房主UID
 @param success 成功
 @param failure 失败
 */
+ (void)fetchMicroListInfoByOwnerUid:(NSString *)ownerUid success:(void (^)(NSMutableArray *userList))success failure:(void (^)(NSNumber *resCode, NSString *message))failure;

/**
 更新麦序列表
 
 @param roomOwnerUid 房主uid
 @param type 上麦类型，44更新交换麦序，45房主给用户上麦，46房主踢用户下麦，47房主置顶用户麦序
 @param success 成功
 @param failure 失败
 */
+(void) updateMicroList:(UserID)roomOwnerUid
                curUids:(NSArray *)curUids
                   type:(NSInteger)type
                success:(void (^)(void))success
                failure:(void (^)(NSNumber *resCode, NSString *message))failure;





#pragma mark - 暂时未使用
/**
 用户离开麦序
 
 @param roomUid 房主uid
 */
+ (void)userLeftMicroWithRoomUid:(UserID)roomUid;



/**
 用户同意上麦
 
 @param roomUid 房间id
 @param success 成功
 @param failure 失败
 */
+ (void)userAgreeUpMicroRoomUid:(NSString *)roomUid success:(void (^)(BOOL isSuccess))success failure:(void (^)(NSNumber *, NSString *))failure;


/**
 申请上麦
 
 @param uid 申请人
 @param roomOwnerUid 房主uid
 @param success 成功
 @param failure 失败
 */
+(void)applyMicro:(UserID)uid roomOwnerUid:(UserID)roomOwnerUid
          success:(void (^)(void))success
          failure:(void (^)(NSNumber *resCode, NSString *message))failure;

/**
 上麦、申请列表
 
 @param roomOwnerUid 房主
 @param success 成功
 @param failure 失败
 */
+(void) requestMicroList:(UserID)roomOwnerUid
                 success:(void (^)(MicroListInfo *microListInfo))success
                 failure:(void (^)(NSNumber *resCode, NSString *message))failure;

/**
 拒绝上麦
 
 @param uid 被拒绝人
 @param roomOwnerUid 房主uid
 @param success 成功
 @param failure 失败
 */
+(void) denyApplyMicro:(UserID)uid roomOwnerUid:(UserID)roomOwnerUid
               success:(void (^)(void))success
               failure:(void (^)(NSNumber *resCode, NSString *message))failure;

#pragma mark - CP陌生人房间
/**创建陌生人房间*/
+ (void)requestStrangerWithCreateSuccess:(void (^)(RoomInfo *roomInfo))success failure:(void (^)(NSString *message))failure;

/**创建帖子陌生人房*/
+ (void)requestDynamicStrangerWithCreateSuccess:(void (^)(RoomInfo *roomInfo))success failure:(void (^)(NSString *message))failure;

/**进入陌生人房间*/
+ (void)requestStrangeJoinRoomWithRoomUid:(UserID)roomUid success:(void (^)(void))success failure:(void (^)(NSString *message))failure;

/**离开陌生人房间*/
+ (void)requestStrangerLeaveRoomWithRoomUid:(UserID)roomUid withUid:(UserID)uid success:(void (^)(void))success failure:(void (^)(NSString *message))failure;

/**陌生人房间列表*/
+ (void)requestStrangerListRoomWithStart:(NSUInteger)pageNum
                                pageSize:(NSUInteger)pageSize
                                 success:(void (^)(NSArray<StrangerRoomInfo*>* roomInfoList))success
                                 failure:(void (^)(NSString *message))failure;

/**匹配查找房间*/
+ (void)requestStrangerWithFindRoomSuccess:(void (^)(RoomInfo *roomInfo))success failure:(void (^)(NSString *message))failure;


/**陌生人房间编辑*/
+ (void)requestStrangerRoomInfo:(UserID)roomId title:(NSString *)title success:(void (^)(RoomInfo *roomInfo))success failure:(void (^)(NSString *message))failure;


/**陌生人房间绑定CP请求*/
+ (void)requestStrangerBindCpWithRoomInfo:(UserID)roomId coupleUid:(UserID)coupleUid withType:(int)type success:(void (^)(StrangerCoupleInfo * coupleInfo))success failure:(void (^)(NSString *message))failure;


/**
 和Ta组cp

 @param coupleUid cpuid
 */
+ (void)requeStrangerMessageWishCoupleUid:(UserID)coupleUid withType:(int)type success:(void (^)(StrangerCoupleInfo * coupleInfo))success failure:(void (^)(NSString *message))failure;


/**
 和Ta组cp答应他
 
 @param coupleUid cpuid
 @param roomId 房间id
 */
+ (void)requeStrangerMessageAgreeCoupleUid:(UserID)coupleUid withRoomId:(NSInteger)roomId success:(void (^)(StrangerCoupleInfo * coupleInfo))success failure:(void (^)(NSString *message))failure;


/*
 CP 房 邀请
 */
+ (void)getRoomInviteByUids:(NSArray *)uids getRoomInfo:(UserID)uid success:(void (^)(void))success failure:(void (^)(NSNumber *, NSString *))failure;


/**
 隐藏房间
 @param hideFlag 是否隐藏房间
 */
+ (void)requestSettingHideRoom:(BOOL)hideFlag success:(void (^)(void))success failure:(void (^)(NSNumber *, NSString *))failure;

/**
 解除房间限制或上锁

 @param limitType 限制类型
 @param roomPwd 房间密码
 @param success 成功
 @param failure 失败
 */
+ (void)requestSettingUnlockRoomLimitType:(NSString *)limitType roomPwd:(NSString *)roomPwd success:(void (^)(void))success failure:(void (^)(NSNumber *, NSString *))failure;

/**
 超管设置房间角色
 @param roomUid 房间的Uid
 @param targetUid 目标的id
 @param opt //1: 设置为管理员;2:设置普通等级用户;-1:设为黑名单用户;-2:设为禁言用户
 @param  notifyExt json字符串 {"handleUid":901258,"role":1} role 代表是超管
 @param success 成功
 @param failure 失败
 */
+ (void)requestSettingRoomAdminWithRoomUid:(UserID)roomUid targetUid:(UserID)targetUid opt:(int)opt notifyExt:(NSString *)notifyExt  success:(void (^)(void))success failure:(void (^)(NSNumber *, NSString *))failure;

#pragma mark -
#pragma mark 超管操作记录统计
/// 超管操作的事项进行统计
/// @param operateType 超管操作类型
/// @param uid 当前操作的超管 uid
/// @param roomUid 房间id
/// @param targetUid 对某一目标执行的 uid
/// @param success 成功
/// @param failure 失败
+ (void)recordSuperAdminOperate:(SuperAdminOperateType)operateType
                  superAdminUid:(UserID)uid
                        roomUid:(UserID)roomUid
                      targetUid:(UserID)targetUid
                        success:(void (^)(void))success
                        failure:(void (^)(NSNumber *, NSString *))failure;

/// 进房记录
+ (void)requestRoomVisitRecordOnCompletion:(HttpRequestHelperCompletion)completion;

/// 进房记录清除
+ (void)requestRoomVisitRecordCleanOnCompletion:(HttpRequestHelperCompletion)completion;

/// 进房欢迎语
/// 接收方uid
+ (void)requestRoomEnterGreetingToUid:(NSString *)toUid
                           completion:(HttpRequestHelperCompletion)completion;

/// 获取红包配置信息
+ (void)requestRoomRedConfigCompletion:(HttpRequestHelperCompletion)completion;

/// 红包分享
/// @param roomUid 房主uid
/// @param packetId 红包id
+ (void)requestRoomRedShare:(NSString *)packetId
                    roomUid:(NSString *)roomUid
                 completion:(HttpRequestHelperCompletion)completion;

/// 获取房间内可抢的红包列表
/// @param roomUid 房主uid
+ (void)requestRoomRedList:(NSString *)roomUid
                completion:(HttpRequestHelperCompletion)completion;

/// 获取红包详情
/// @param packetId 红包id
+ (void)requestRoomRedDetail:(NSString *)packetId
                  completion:(HttpRequestHelperCompletion)completion;

/// 抢红包
/// @param packetId 红包id
+ (void)requestRoomRedDraw:(NSString *)packetId
                completion:(HttpRequestHelperCompletion)completion;

/// 发红包
/// @param roomUid 房主uid
/// @param amount 金币数
/// @param num 红包个数
/// @param requirementType 红包条件
/// @param notifyText 喊话文案
+ (void)requestRoomSendRedByRoomUid:(UserID)roomUid amount:(NSInteger)amount num:(NSInteger)num requirementType:(int)requirementType notifyText:(NSString *)notifyText
completion:(HttpRequestHelperCompletion)completion;

@end
