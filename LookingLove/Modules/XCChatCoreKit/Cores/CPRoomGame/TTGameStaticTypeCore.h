//
//  TTGameStaticTypeCore.h
//  XCChatCoreKit
//
//  Created by new on 2019/3/5.
//  Copyright © 2019 YiZhuan. All rights reserved.
//

#import "BaseCore.h"

typedef enum : NSUInteger {
    OpenRoomType_Normal = 3, // 普通房
    OpenRoomType_CP = 5, // CP房
    OpenRoomType_Love = 7, // 相亲房
} TTOpenRoomType;


typedef enum : NSUInteger {
    EnterRoomStatus_Normal = 1, // 正常进入房间
    EnterRoomStatus_Match = 2, // 匹配进入房间
    EnterRoomStatus_Private = 3, // 私聊进入房间
} TTEnterRoomStatusType;

typedef enum : NSUInteger {
    TTShareRoomOrInviteFriendStatus_Share = 1, // 分享房间
    TTShareRoomOrInviteFriendStatus_Invite = 2, // 邀请好友
} TTShareRoomOrInviteFriendStatusType;

NS_ASSUME_NONNULL_BEGIN

@interface TTGameStaticTypeCore : BaseCore

@property (nonatomic, assign) int openRoomStatus; // 开房间时的 房间type 判断

@property (nonatomic, assign) int enterRoomStatus; // 进入房间的途径判断。暂时用不到

@property (nonatomic, strong) NSString *gameID;  // 用于定时器优化

@property (nonatomic, strong) NSMutableArray *privateMessageArray; // 游戏列表数据源

@property (nonatomic, assign) BOOL selectGameForMe; // 陪伴房是谁选择了游戏

@property (nonatomic, assign) BOOL acceptGameFromNormalRoom; // 用于多人房点击接受的防重复点击

@property (nonatomic, assign) BOOL watchGameFromNormalRoom;  // 用于多人房点击观战的防重复点击

@property (nonatomic, assign) BOOL giftSwitch; // 全屏礼物的开关

//@property (nonatomic, assign) NSInteger genderIndex; // 找玩友匹配当前选择的性别  暂时用不到

@property (nonatomic, assign) BOOL launchGameSwitch;

@property (nonatomic, assign) BOOL checkType;

@property (nonatomic, assign) int shareRoomOrInviteType;

- (void)createrTimer;

- (void)destructionTimer;
@end

NS_ASSUME_NONNULL_END
