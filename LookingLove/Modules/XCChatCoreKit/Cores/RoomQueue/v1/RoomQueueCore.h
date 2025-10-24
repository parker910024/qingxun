////
////  RoomQueueCore.h
////  BberryCore
////
////  Created by 卫明何 on 2017/9/5.
////  Copyright © 2017年 chenran. All rights reserved.
////
//
//#import "BaseCore.h"
//#import <NIMSDK/NIMSDK.h>
//#import "RoomQueueMemberInfo.h"
//
//@interface RoomQueueCore : BaseCore
//
//@property (strong, nonatomic) NSMutableArray *speakMembersUid; // 说话列表
//@property (assign, nonatomic) BOOL isRoomOwnerSpeaking; //房主说话
//@property (strong, nonatomic)NSMutableArray<NIMChatroomMember *> *allMembers; //所有成员
//@property (strong, nonatomic)NSMutableArray<NIMChatroomMember *> *guestMembers; //游客非麦序成员
//@property (strong, nonatomic)NSMutableArray<NIMChatroomMember *> *backList; //黑名单
//@property (strong, nonatomic)NSMutableArray<NIMChatroomMember *> *micMembers; //游客麦序成员
//@property (strong, nonatomic)NSMutableArray<NIMChatroomMember *> *mamagerMembers; // 管理员成员
//@property (strong, nonatomic)NSMutableDictionary<NSString *, RoomQueueMemberInfo *> *micQueue; //麦序位置信息
//@property (strong, nonatomic)NSMutableArray<NIMChatroomMember *> *displayAllMembers; //所有成员显示用数组
//@property (strong, nonatomic)NIMChatroomMember *roomOwner; //房主
//@property (assign, nonatomic)BOOL isLoad;
//@property (strong, nonatomic)NSMutableDictionary *microList;
//
//@property (strong, nonatomic)NSMutableArray<NIMUser *> *mamagerUsers; //管理员（含用户信息）
//@property (strong, nonatomic)NSMutableArray<NIMUser *> *backListUsers; //黑名单（含用户信息）
//@property (strong, nonatomic)NIMChatroomMember *myMember;//我自己的Member
//
//@property (strong, nonatomic) RoomQueue *myRoomQueue;
//
//- (NSMutableArray *)findSendGiftMember;//获取麦上的人跟房主
//- (void)getRoomMicroMembersWithRoomID:(NSString *)roomId;// 获取游戏房麦序
//
///**
// 更换麦序
//
// @param old 旧的麦序位置
// @param new 新的麦序位置
// @param roomId 房间ID
// */
//- (void)changeTheMicroSerialWithOldSerial:(NSString *)old new:(NSString *)new roomId:(NSString *)roomId;
//- (void)upMircoSerialWithSerial:(NSString *)serial;//上麦，serial 麦序
//- (void)downMicro;//下麦
//- (void)upMicro;// 上麦
//- (void)inviteOnMic:(UserID)uid;//邀请上麦
//- (void)kiedMircoWithUid:(UserID)uid;//踢人下麦
//- (void)lockThePositionWithSerial:(NSString *)serial;//锁麦位，serial 麦序
//- (void)muteThePositionWithSerial:(NSString *)serial;//禁麦。serial 麦序
//- (void)activeThePositionWithSerial:(NSString *)serial;//解除禁麦
//- (void)unlockThePositionWithSerial:(NSString *)serial;//解锁麦序，serial 麦序
//
///**
// 判断是否在麦上
// @param uid uid
// @return YES or NO
// */
//- (BOOL)isOnMicro:(UserID)uid;
//
///**
// 通过uid判断麦位
//
// @param uid 用户id
// @return 位置
// */
//- (NSString *)findThePositionByUid:(UserID)uid;
//
///**
// 通过uid查找member
//
// @param uid 用户uid
// @return member
// */
//- (NIMChatroomMember *)findTheMemberByUserId:(UserID)uid;
//
///**
// 通过uid查找麦序信息
//
// @param uid uid
// @return 麦序信息
// */
//- (RoomQueueMemberInfo *)findTheRoomQueueMemberInfo:(UserID)uid;
//
//
//
//@end

