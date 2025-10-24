//
//  TTGameRoomViewController+CPGameView.h
//  TuTu
//
//  Created by new on 2019/1/10.
//  Copyright © 2019 YiZhuan. All rights reserved.
//

#import "TTGameRoomViewController.h"
#import "ImMessageCoreClient.h"

NS_ASSUME_NONNULL_BEGIN

@interface TTGameRoomViewController (CPGameView)<ImMessageCoreClient>

- (void)updateGameStatusForUI; // 最小化进入的房间的时候在viewDidLoad 里面去调用这个方法

// 设置房间的限制类型
- (void)setEnterRoomPermissions:(NIMChatroomMember *)mineMember;

// 设置红包红包
-  (void)setRedbag:(NIMChatroomMember *)mineMember isClose:(BOOL)isClose;


//更改 游戏 模式 改变布局 声网进入游戏模式
- (void)CpOpenGameChangeCpMode;

//  关闭
- (void)CpCloseGameChangeCpMode;

//开启 游戏模式  请求接口
- (void)gameOpenRoomCPMode;

//关闭 游戏模式 请求接口
- (void)gameCloseRoomCPMode;


//  CP房间游戏列表
- (void)getGameList;

// 统一关闭接口。 关闭游戏面板的同时。调用关闭接口
- (void)closeCPModel;


// 进入房间 从外部匹配
- (void)enterFromOutOfRoom:(NSString *)gameString;


// 抱机器人上麦
- (void)HoldRobotOnTheMic;


- (void)enterCPRoomSuccess;


- (void)connectRoomKengWeiSuccess;
@end

NS_ASSUME_NONNULL_END
