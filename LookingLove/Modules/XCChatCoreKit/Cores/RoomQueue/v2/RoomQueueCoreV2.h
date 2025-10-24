//
//  RoomQueueCoreV2.h
//  BberryCore
//
//  Created by Mac on 2017/12/8.
//  Copyright © 2017年 chenran. All rights reserved.
//

#import "BaseCore.h"
#import <NIMSDK/NIMSDK.h>
#import "ChatRoomMicSequence.h"
#import "RoomQueueCustomAttachment.h"
#import "XCInviteMicAttachment.h"
#import "RoomInfo.h"
#import "CPGameCoreClient.h"

@interface RoomQueueCoreV2 : BaseCore

@property (nonatomic, strong) MicroState *micState;
@property (strong, nonatomic) NIMChatroomMember *myLastMember;//更改前的  我自己的Member
@property (strong, nonatomic) NIMChatroomMember *myMember;//我自己的Member
@property (assign, nonatomic) BOOL needCloseMicro;//更新麦序的时候是否需要关麦

- (void)freeMicPlace:(int)position;//解除麦位封锁
- (void)lockMicPlace:(int)position;//封锁麦位

//封锁麦位 带block
- (void)lockMicPlace:(int)position success:(void (^)(BOOL success))success;
//麦位静音 带回调
- (void)closeMic:(int)position success:(void (^) (BOOL success))success;
- (void)closeMic:(int)position;//麦位静音(皇帝除外)
- (void)openMic:(int)position;//取消麦位静音
- (void)downMic;//下麦
- (void)downMicAndIsExitRoom:(BOOL)exitRoom; // 退出房间下麦
- (void)upMic:(int)position;//上指定麦
/// 断网重连上麦
/// @param position 麦位
/// @param isReConnect 是否是断网重连
- (void)upMic:(int)position isReConnect:(BOOL)isReConnect;
- (void)upFreeMic;//上一个空闲麦

//踢它下麦 有回调
- (void)kickDownMic:(UserID)uid position:(int)position success:(void (^) (NSString * nick,  UserID uid))kickDownBlock;

- (void)kickDownMic:(UserID)uid position:(int)position;//踢它下麦(皇帝除外)
// 拉黑踢下麦
- (void)kickDownMic:(UserID)uid position:(int)position isBlack:(BOOL)isBlack;
/// 抱人下麦
/// @param uid 用户uid
/// @param position 坑位
/// @param kickRoom 是否是踢出房间
/// @param isBlack 是否是拉黑
- (void)kickDownMic:(UserID)uid position:(int)position kickRoom:(BOOL)kickRoom isBlack:(BOOL)isBlack;

/// 抱人下麦
/// @param uid 用户uid
/// @param position 坑位
/// @param kickRoom 是否是踢出房间
/// @param isBlack 是否是拉黑
/// @param kickDownBloc 踢人回调
- (void)kickDownMic:(UserID)uid position:(int)position kickRoom:(BOOL)kickRoom isBlack:(BOOL)isBlack success:(void(^)(void))kickDownBloc;

- (void)inviteUpMic:(UserID)uid postion:(NSString *)position;//邀请上指定麦位
- (void)inviteUpFreeMic:(UserID)uid;//邀请上空闲麦
//邀请上锁定的麦（排麦的时候）
- (void)inviteUpLockMic:(UserID)uid;
/**
 邀请上锁定的麦（排麦的时候）相亲房使用
 @param uid 用户uid
 */
- (void)inviteUpLockMic:(UserID)uid gender:(UserGender)gender;

- (BOOL)isOnMicro:(UserID)uid;//判断是否在麦上
- (NSString *)findThePositionByUid:(UserID)uid;//通过uid判断麦位
- (NIMChatroomMember *)findTheMemberByUserId:(UserID)uid;//通过uid查找member
- (ChatRoomMicSequence *)findTheRoomQueueMemberInfo:(UserID)uid;//通过uid查找麦序信息
- (NSMutableArray *)findSendGiftMember;//获取麦上的人跟房主

//通过NIMSDK修改队列下麦
- (void)removeChatroomQueueWithPosition:(NSString *)position
                                    uid:(UserID)uid
                                success:(void (^)(BOOL success))success
                                failure:(void (^)(NSString *message))failure;//从队列中删除


/**
 获取聊天室链接状态

 @return 是否正在重连
 */
- (BOOL)getChatRoomConnectState;

/**
 房间坑位开启倒计时
 
 @param position 坑位索引
 @param seconds  倒计时时长(单位秒)
 */
- (void)openMicServeTimer:(int)position seconds:(int)seconds;

/**
 房间坑位停止倒计时
 
 @param uid 关闭倒计时的用户uid
 @param position 坑位索引
 */
- (void)closeMicServeTimer:(UserID)uid position:(int)position;


/*
 CP房游戏匹配，匹配到机器人 要抱机器人上麦
 @param userInfo 机器人的用户信息
 @param position 坑位索引
 
 */
- (void)updateChatroomQueueWithPosition:(NSString *)position
                               userInfo:(UserInfo *)userInfo
                                success:(void (^)(BOOL success))success
                                failure:(void (^)(NSString *message))failure;
@end
