//
//  TTGameRoomContainerController.h
//  TuTu
//
//  Created by KevinWang on 2018/10/30.
//  Copyright © 2018年 YiZhuan. All rights reserved.
//

#import "TTBaseRoomViewController.h"

//vc
#import "TTGameRoomViewController.h"

//music
#import "TTMusicPlayerView.h"
#import "TTMusicEntrance.h"

//core
#import "ImRoomCoreV2.h"
#import "ImRoomCoreClient.h"
#import "ImRoomCoreClientV2.h"

#import "FileCore.h"
#import "FileCoreClient.h"

#import "MeetingCore.h"
#import "MeetingCoreClient.h"

#import "RoomQueueCoreV2.h"
#import "RoomQueueCoreClient.h"

#import "RoomMagicCore.h"
#import "RoomMagicCoreClient.h"

#import "TTRoomUIClient.h"
#import "AuthCore.h"
#import "GiftCoreClient.h"

//tool
#import "SVGAParserManager.h"


@interface TTGameRoomContainerController : TTBaseRoomViewController

/*------------music--------------*/
//临时音乐按钮状态
@property (assign, nonatomic)BOOL tempMusicBtnState;
//临时音乐播放器状态
@property (assign, nonatomic)BOOL tempMusicPlayerState;
//播放器入口按钮
@property (strong, nonatomic) TTMusicEntrance *musicEntrance;
//播放器界面
@property (strong, nonatomic) TTMusicPlayerView * musicPlayerView;
//播放器界面容器
@property (nonatomic, strong) UIView *musicPlayerContainView;

/*------------animation--------------*/
//礼物svg动画view
@property (strong, nonatomic) SVGAImageView *giftEffectView;
//房间魔法
@property (strong, nonatomic) SVGAImageView *roomMagicEffectView;
//reuse 复用池
@property (strong,nonatomic)NSMutableSet * magicDequePool;//复用池
@property (strong,nonatomic)NSMutableSet * magicVisiablePool;//可见池
//SVGA管理器
@property (strong, nonatomic) SVGAParserManager *parser;


//高斯模糊view
@property (strong, nonatomic) UIVisualEffectView *effectView;
//game vc
@property (strong, nonatomic) TTGameRoomViewController *roomController;
//自己的用户信息
@property (strong, nonatomic)UserInfo * myInfo;
//房主用户信息
@property (strong, nonatomic) UserInfo *roomOwner;

/*------------ 是否进入相同的房间 即 最小化 在进入房间 ----------*/
@property (nonatomic, assign) BOOL isSameRoom;//是否 是进入相同的房间 即最小化之后 回到房间

//被踢
- (void)ttbeKicked:(NIMChatroomKickReason)reson;
//被踢 有理由的
- (void)ttBeKickedBySuperAdmin:(NIMChatroomBeKickedResult *)result;
//被拉黑
- (void)ttBeInBlackList;
//处理房间魔法特效播放完毕
- (void)ttHandleRoomMagicEffectAnimation;

- (void)onGetRoomQueueSuccessV2:(NSMutableDictionary*)info;

@end
