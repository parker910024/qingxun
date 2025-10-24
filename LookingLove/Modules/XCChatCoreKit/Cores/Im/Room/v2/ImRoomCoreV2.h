//
//  ImRoomCoreV2.h
//  BberryCore
//
//  Created by Mac on 2017/12/8.
//  Copyright © 2017年 chenran. All rights reserved.
//

#import "BaseCore.h"
#import <NIMSDK/NIMSDK.h>
#import "ChatRoomMicSequence.h"
#import "RoomInfo.h"
#import "ChatRoomQueueNotifyModel.h"

//聊天室成员平台角色拓展字段
extern NSString *const XCChatroomMemberExtPlatformRole;

@interface ImRoomCoreV2 : BaseCore

@property (strong, nonatomic)NSMutableArray<NIMChatroomMember *> *displayMembers; //在线列表(第一页的owner/mic/manager)
@property (strong, nonatomic)NSMutableArray<NIMChatroomMember *> *micMembers; //麦序列表
@property (strong, nonatomic)NSMutableArray<NIMChatroomMember *> *micMembersNoRoomOwner; //麦序列表,不含房主
@property (strong, nonatomic)NSMutableDictionary<NSString *, ChatRoomMicSequence *> *micQueue;//麦序位置信息
@property (strong, nonatomic)NSMutableArray<NIMChatroomMember *> *onLineManagerMembers; //在线管理成员
@property (strong, nonatomic)NSMutableArray<NIMChatroomMember *> *guestMembers; //游客非麦序成员

@property (strong, nonatomic)NSMutableArray<NIMChatroomMember *> *allManagers; //管理员成员
@property (strong, nonatomic)NSMutableArray<NIMChatroomMember *> *backLists; //黑名单
@property (strong, nonatomic)NSMutableArray<NIMChatroomMember *> *noMicMembers; //用户返回非麦上成员
@property (strong, nonatomic)NSMutableArray<NIMChatroomMember *> *normalMembers; //在线普通用户
@property (strong, nonatomic)NSArray<NIMChatroomMember *> *tempMembers;
@property (nonatomic, strong) NIMChatroomMember *lastChatroomMember;//在线列表分页请求 当前页最后一个房间成员


/**
 房间在线人数
 
 超管作为隐身人身份进入房间，所以查询云信在线人数接口后减去对应超管人数
 为减少资源开销，在线人数计算策略如下：
 云信在线人数>XCRoomOnlineMemberAdjustMaximum，最终人数=云信在线人数
 云信在线人数<=XCRoomOnlineMemberAdjustMaximum，每隔一分钟遍历在线人数列表超管人数，最终人数=云信在线人数-超管人数
 同时维护一份超管列表superAdmins，超管进出房间及时更新
 定时遍历是为了防止超管异常退出
 */
@property (nonatomic, assign) NSInteger onlineNumber;

@property (assign, nonatomic) UserID p2pUid; //p2pUid
@property (strong, nonatomic) NIMChatroomMember *roomOwner; //房主
@property (strong, nonatomic) UserInfo *roomOwnerInfo; //房主个人信息
@property (strong, nonatomic) NIMChatroomMember *myMember;//我自己的Member
@property (strong, nonatomic) NIMChatroomMember *myLastMember;//更新前 我自己的Member

@property (nonatomic, strong) ChatRoomMicSequence *micSequence;
@property (nonatomic, strong) NIMChatroom *currentChatRoom;
@property (nonatomic, strong) RoomInfo *currentRoomInfo;

@property (nonatomic, assign) BOOL isLoading;

- (void) enterChatRoom:(NSInteger) roomId;//enter
- (void) exitChatRoom:(NSInteger)roomId;//exit
- (void) kickUser:(UserID)beKickedUid;//kick 被踢出房间
//提出房间 带回调的
- (void)kickUser:(UserID)beKickedUid  successBlcok:(void (^)(BOOL success))successBlcok;

- (RACSignal *)rac_queryQueueWithRoomId:(NSString *)roomId;
- (void)queryQueueWithRoomId:(NSString *)roomId;//拿麦序成员

/**
 当前房间在线用户列表请求响应，当前兔兔使用，create by @lvjunhang
 
 @discussion 第一页包含麦序与固定成员
 @param isRefresh 是否刷新数据
 */
- (void)requestChatRoomOnlineMembersWithRefresh:(BOOL)isRefresh;

/**
 当前房间未上麦用户列表请求响应，当前兔兔使用，create by @lvjunhang
 
 @discussion 第一页包含麦序与固定成员
 @param isRefresh 是否刷新数据
 */
- (void)requestChatRoomNoMicMembersWithRefresh:(BOOL)isRefresh;

- (void)queryChatRoomMembersWithPage:(int)page state:(int)state;//通过页数查询聊天室成员，第一页包含麦序与固定成员
- (void)queryNoMicChatRoomMembersWithPage:(int)page state:(int)state;//通过页数查询不在麦上的人，第一页包含房主管理
- (void)queryManagerorBackList;//查询管理员列表
- (void)queryChartRoomMembersWithUids:(NSArray *)uids;//根据uids获取对应的NIMChatroomMember
- (RACSignal *)rac_queryChartRoomMemberByUid:(NSString *)uid;//根据uid获取NIMChatroomMember
- (RACSignal *)rac_fetchMemberUserInfoByUid:(NSString *)uid;//rac根据uid获取NIMUser
- (RACSignal *)rac_fetchChatRoomInfoByRoomId:(NSString *)roomId;//rac根据roomid获取chatroom

- (void)markManagerList:(UserID)userID enable:(BOOL)enable;//设置/取消管理员
- (void)markBlackList:(UserID)userID enable:(BOOL)enable;//YES设置/NO取消黑名单


- (void)updateMyRoomMemberInfoWithrequest:(NIMChatroomMemberInfoUpdateRequest *)request;//修改我的聊天室个人信息（等级，贵族)

- (void)sendMessage:(NSString *)message;//发送消息

/**发送消息给cp对象*/
- (void)sendP2pWithMessage:(NSString *)message;
/**发送消息给陌生人对象（P2P）*/
- (void)sendP2pStrangerWithMessage:(NSString *)message;

- (BOOL)isInRoom ;//判断是否在房间
- (BOOL)isInBackList:(UserID)uid;//判断是否在房间黑名单

- (void)repairMicQueue;//绑定麦序
- (NSMutableDictionary *)queryOnMicroMemberExt;
//重置all array
- (void)resetAllQueue;
/** 重置定时器*/
- (void)invalidateTimer;

/**更新在线人数*/
- (void)updateOnLineNmuber;

/**
 房间是否能开启礼物值
 */
- (BOOL)canOpenGiftValue;

/**
 房间是否已开启礼物值

 @discussion 房间模式能够开启礼物值，且打开了礼物值功能
 */
- (BOOL)hasOpenGiftValue;

@end

