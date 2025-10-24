//
//  TTGameRoomViewController.h
//  TuTu
//
//  Created by KevinWang on 2018/10/30.
//  Copyright © 2018年 YiZhuan. All rights reserved.
//

#import "BaseUIViewController.h"

//core
#import "RoomCoreV2.h"
#import "RoomQueueCoreV2.h"
#import "RoomQueueCoreClient.h"

#import "ImRoomCoreV2.h"
#import "ImRoomCoreClient.h"
#import "ImRoomCoreClientV2.h"

#import "MeetingCore.h"
#import "MeetingCoreClient.h"

#import "FaceCore.h"
#import "AuthCore.h"
#import "UserCore.h"
#import "VersionCore.h"
#import "BalanceErrorClient.h"
#import "CPGameCore.h"
#import "TTCPGamePrivateChatClient.h"

//vc
#import "TTRoomModuleCenter.h"
#import "TTRoomContributionController.h"

//view
#import <YYLabel.h>
#import "TTMessageView.h"
#import "TTMessageHeaderView.h"
#import "XCRoomActivityView.h"
#import "XCShareView.h"
#import "XCGameRoomFaceView.h"
#import "TTFunctionMenuView.h"
#import "TTOffLineView.h"
#import "TTMasterTimeView.h"
#import "TTCPGameView.h" // CP房游戏View
#import "TTCPGameListView.h"
#import "TTGameRoomContributionContainerView.h"
#import "TTPositionView.h"
#import "TTRoomActivityCycleView.h"
#import "TTRedEntranceView.h"
#import "TTRedListView.h"
#import "TTRedDrawView.h"
#import "WBGameView.h"

//tool
#import "XCHUDTool.h"
#import "TTGameStaticTypeCore.h"

#import <IQKeyboardManager.h>
#import "MarqueeLabel.h"

@protocol TTGameRoomViewControllerDelagte <NSObject>
@optional

- (void)showRoomExit:(UserID)uid;
- (void)roomExit;
- (void)roomInitSuccessWithType:(RoomType)roomtype;
- (void)updateBackPicWith:(RoomInfo *)info userInfo:(UserInfo *)userInfo;

@end


@interface TTGameRoomViewController : BaseUIViewController

/**
 *
 */
@property (nonatomic,strong) TTPositionView *roomPositionView;

//nav:最小化 title 分享 设置
//返回/最小化
@property (nonatomic, strong) UIButton *miniRoomButton;
//房间title
@property (nonatomic, strong) MarqueeLabel *roomInfoLabel;
//关注房主
@property (nonatomic, strong) UIButton *focusOwnerButton;
// 锁房/礼物特效/高音质
@property (nonatomic, strong) UILabel *roomInfoIcon;
//分享
@property (nonatomic, strong) UIButton *shareButton;
//设置
@property (nonatomic, strong) UIButton *settingButton;

//view:id、在线、房间榜、箱子、坑位、公屏、activity、工具条 输入框
//靓/id/在线
@property (nonatomic, strong) YYLabel *IDAndOnlineLabel;

//贡献榜
@property (nonatomic, strong) UIButton *roomContributionBtn;
@property (nonatomic, strong) TTGameRoomContributionContainerView *contributionContainerView;
@property (nonatomic, strong) TTRoomContributionController *contributionVC;

//公告
@property (nonatomic, strong) UIButton *roomIntroduceBtn;
//开箱子 砸蛋
@property (nonatomic, strong) UIButton *boxEnterButton;
//房间坑位
//@property (nonatomic, strong) XCRoomPositionView *positionView;
//公屏头
@property (nonatomic, strong) TTMessageHeaderView *messageHeaderView;
//公屏
@property (nonatomic, strong) TTMessageView *messageView;
//活动
@property (nonatomic, strong) XCRoomActivityView *activityView;
@property (nonatomic, strong, readonly) TTRoomActivityCycleView *roomActivityCycleView;
@property (nonatomic, strong, readonly) TTRoomActivityCycleView *roomActivityCycleTopLeftView; // 左上活动页

//🎲
@property (nonatomic, strong) UIButton *togetherButton;

//工具条
//toolBar
@property (nonatomic, strong) TTFunctionMenuView *functionMenuView;
@property (nonatomic, strong) TTFunctionMenuButton *moreToolBarButton;//更多功能toolBarButton
//toolBar BG
@property (nonatomic, strong) UIView *toolBarBgView;
@property (nonatomic, assign) TTFunctionMenuType menuType;
//表情
@property (nonatomic, strong) XCGameRoomFaceView *roomFaceView;
/** 师徒任务3, 倒计时的view */
@property (nonatomic, strong) TTMasterTimeView *masterTimeView;

//房间容器view（在线与贡献榜容器）
@property (nonatomic, strong) UIView *roomContainerView;
//容器view的背景，用于设置背景与手势
@property (nonatomic, strong) UIView *roomContainerBgView;

//输入框
//输入容器
@property (nonatomic, strong) UIView *editContainerView;
//输入框
@property (nonatomic, strong) UITextField *editTextFiled;
//发送按钮
@property (nonatomic, strong) UIButton *sendButton;
//草稿
@property (nonatomic, copy) NSString *inputMessage;
//键盘是否显示
@property (nonatomic, assign) BOOL keyboardIsShow;


@property (nonatomic, assign) BOOL isSameRoom;//是否 是最小化进入相同的房间
@property (nonatomic, assign) BOOL isEnterRoomSuccess;//进入房间成功

//配对
@property (nonatomic, strong) UIButton *gameStartBtn;//开始
@property (nonatomic, strong) UIButton *gameOpenBtn;//开
@property (nonatomic, strong) UIButton *gameCancelBtn;//取消

//  CP房游戏界面
@property (nonatomic, strong) TTCPGameView *gamePlayView;
@property (nonatomic, assign) BOOL onWheatType; // 房间重连
@property (nonatomic, assign) BOOL firstEnterRoom; // 用于判断是否是第一次进入页面
@property (nonatomic, assign) BOOL secondEnterRoom; // 进入房间自动上麦，麦上的人游戏界面改变。改变完之后，房间信息再发生变动，将不以这个为基准判断
@property (nonatomic, assign) BOOL insuranceBOOL;
@property (nonatomic, assign) BOOL gameStatus;
@property (nonatomic, assign) BOOL isShowMessage; // 安卓和iOS 游戏不一样时。是否显示安卓发起的游戏信息

// 普通房游戏界面
@property (nonatomic, strong) TTCPGameListView *listView;
@property (nonatomic, strong) NSString *acceptMessageID; // 发起的游戏ID
@property (nonatomic, strong) WBGameView *gameView;//派对游戏小窗口

//chatMessage
@property (nonatomic, strong) UIViewController *messageVc;

//房主用户信息
@property (nonatomic, strong) UserInfo *roomOwnerUserInfo;
//房间信息
@property (nonatomic, strong) RoomInfo *roomInfo;

//是否已经显示主播已下线的view
@property (nonatomic, assign) BOOL hadShowFinishView;
@property (nonatomic, weak) id<TTGameRoomViewControllerDelagte> delegate;
// 是否已经显示关注房主
@property (nonatomic, assign) BOOL isShowAttention;

/**
 派对房才有的返回上一层
 */
@property (nonatomic, strong) UIButton *backGroupChatBtn;
@property (nonatomic, assign) NSInteger attendCount;
@property (nonatomic, strong) dispatch_source_t attendTimer;
@property (nonatomic, assign) NSInteger joinWorldCount;
@property (nonatomic, strong) dispatch_source_t joinWorldTimer;

/// 红包入口
@property (nonatomic, strong) TTRedEntranceView *redEntranceView;
/// 红包列表
@property (nonatomic, strong) TTRedListView *redListView;
/// 抢红包
@property (nonatomic, strong) TTRedDrawView *redDrawView;

//被拉近黑名单
- (void)ttBeInBlackList;
//被踢 超管
- (void)ttSuperAdminBeKicked:(NIMChatroomBeKickedResult *)reson;
//被踢
- (void)ttBeKicked:(NIMChatroomKickReason)reson;
//更新房间title/lock/礼物特效
- (void)updateRoomInfoLabel;

@end
