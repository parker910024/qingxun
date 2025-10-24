////
////  RoomCore.h
////  BberryCore
////
////  Created by chenran on 2017/5/27.
////  Copyright © 2017年 chenran. All rights reserved.
////
//
//#import "BaseCore.h"
//#import "RoomInfo.h"
//#import "MicroUserListInfo.h"
//
//typedef NS_ENUM(NSInteger, RoomRole) {
//    RoomOwner   = 0, //房主
//    Customer    = 1, //游客
//    Manager     = 2, //管理员
//    MircoActor  = 3, //麦序上
//};
//
//@interface RoomCore : BaseCore
//@property (nonatomic, strong) RoomInfo *currentRoomInfo;
//@property (nonatomic, assign) BOOL isInRoom;
//@property (nonatomic, strong) NSMutableArray<MicroUserListInfo *> *currentApplyList; //麦序列表
//@property (nonatomic, strong) NSMutableArray *speakingList;
//@property (nonatomic, strong) NSMutableArray *finallyUserList;
//@property (nonatomic, copy) NSDictionary *currentMicroList;
//@property (nonatomic, strong) NSMutableArray *messages;
//@property (nonatomic, strong) NSMutableArray *members; //游客
//@property (nonatomic, strong) NSMutableArray *adminMembers; //麦序
//@property (nonatomic, strong) NSMutableArray *positionArr; //麦序位置
//@property (nonatomic, assign) CGPoint avatarPosition; //房主头像位置
//
////房间操作
//-(void)rewardAndOpenRoom:(UserID)uid rewardMonye:(NSInteger)rewardMonye title:(NSString *)title roomDesc:(NSString *)roomDesc backPic:(NSString*)backPic;//开启竞拍房
//-(void)openRoom:(UserID)uid type:(RoomType)type title:(NSString *)title roomDesc:(NSString *)roomDesc backPic:(NSString*)backPic rewardId:(NSString *)rewardId;//开启房间
//- (void)updateRoomInfo:(UserID) uid title:(NSString *)title roomDesc:(NSString *)roomDesc backPic:(NSString *)backPic;
//- (void)updateGameRoomInfo:(UserID)uid title:(NSString *)title roomTopic:(NSString *)roomTopic roomPassword:(NSString *)roomPassword tag:(int)tag;//房主更新房间信息
//- (void)managerUpdateGameRoomInfo:(UserID)uid title:(NSString *)title roomTopic:(NSString *)roomTopic roomPassword:(NSString *)roomPassword tag:(int)tag; //管理员修改房间信息
//-(void) closeRoom:(UserID)uid;
//
////麦序
//- (NSMutableArray *)getAdminMembers;//麦序
//-(void) applyMicro:(UserID)uid roomOwnerUid:(UserID)roomOwnerUid;
//-(void) upMicro:(UserID)uid roomOwnerUid:(UserID)roomOwnerUid seqNo:(NSInteger)seqNo;
//-(void) leftMicro:(UserID)uid roomOwnerUid:(UserID)roomOwnerUid;
//-(void) denyApplyMicro:(UserID)uid roomOwnerUid:(UserID)roomOwnerUid;
//-(void) updateMicroList:(UserID)roomOwnerUid curUids:(NSArray *)curUids type:(NSInteger)type;
//
////麦操作
//- (void)OwnerInviteUserUpMicroByUid:(NSString *)uid;//房主邀请用户上麦
//- (void)userAgreeUpMicroRoomUid:(NSString *)roomUid;//用户同意上麦
//- (void)ownerKickUserByUid:(NSString *)uid;//房主踢用户下麦
//- (void)userLeftMicroWithRoomUid:(UserID)roomuid;//用户离开麦序
//
////获取房间成员与信息
//- (RACSignal *)fetchMemberInfoByUid:(NSString *)uid;//获取单个用户资料
//- (void)fetchMembersInfoByUids:(NSArray *)uids type:(NSInteger)type;//批量获取用户信息
//- (void)fetchRoomMembers;//获取游客
//- (void)fetchRoomRegularMembers; //获取麦序
//- (void)fetchRoomAllRegularMembers;//获取所有有固定成员（管理与黑名单）
//
//
////获取房间信息
//- (RoomInfo *) getCurrentRoomInfo;//当前房间信息
//- (NSInteger)getTheLisnterNumber;//获取房间收听人数
//- (void)getRoomBounsList;//获取房间贡献榜
//- (void)getUserInterRoomInfo:(UserID)uid;//获取用户进入了的房间的信息
//- (RACSignal *)requestRoomInfo:(UserID) uid;//请求房间信息
//- (RACSignal *)requestRoomInfoByUids:(NSArray *)uids;//批量查询房间状态
//
////黑名单
//- (void)judgeIsInBlackList:(NSString *)roomID; //查询自己
//- (void)updateMemberInBlackList:(UserID)userID;   //拉黑用户
//- (void)requestBlackList; //请求黑名单列表
//
//
////房间统计
//- (void)recordTheRoomTime:(UserID)uid roomUid:(UserID)roomUid;//房间统计
//- (void)reportUserInterRoom; //用户进入房间上报
//- (void)reportUserOuterRoom; //用户退出房间上报
//
//
////房间权限操作
//- (void)setRoomManagerWithUid:(UserID)uid;//设置为房间管理员
//- (void)removeRoomManagerWithUid:(UserID)uid;//移除房间管理员
//- (void)removeBlackListWithUid:(UserID)uid;//移除房间黑名单
//- (void)setRoomNormalWithUid:(UserID)uid;//设置为房间普通成员
//
//- (void)savePosition:(NSMutableArray *)list;  //保存游戏房cell的位置
//-(void) sendMessage:(NSString *)message;
//
//@end

