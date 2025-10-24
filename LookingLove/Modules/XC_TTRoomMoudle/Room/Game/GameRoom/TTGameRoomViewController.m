//
//  TTGameRoomViewController.m
//  TuTu
//
//  Created by KevinWang on 2018/10/30.
//  Copyright © 2018年 YiZhuan. All rights reserved.
//

#import "TTGameRoomViewController.h"

#import "TTGameRoomViewController+AttributedString.h"
#import "TTGameRoomViewController+Private.h"
#import "TTGameRoomViewController+FunctionMenu.h"
#import "TTGameRoomViewController+RoomContribution.h"
#import "TTGameRoomViewController+RoomShare.h"
#import "TTGameRoomViewController+RoomInput.h"
#import "TTGameRoomViewController+OnlineList.h"
#import "TTGameRoomViewController+Game.h"
#import "TTGameRoomViewController+ArrangeMic.h"
#import "TTGameRoomViewController+Introduce.h"
#import "TTGameRoomViewController+CPGameView.h"
#import "TTGameRoomViewController+MentoringShip.h"
#import "TTGameRoomViewController+ChatMessage.h"

#import "TTGameRoomViewController+OppositeSex.h"
#import "TTGameRoomViewController+RoomMessage.h"
#import "TTGameRoomViewController+RoomActivity.h"
#import "TTGameRoomViewController+MicPosition.h"
#import "TTGameRoomViewController+Red.h"
#import "TTGameRoomViewController+GuideView.h"
#import "TTGameRoomViewController+LittleWorldMessage.h"

#import "TTRoomIntroduceViewController.h"

//t
#import "XCTheme.h"
#import <Masonry.h>
#import "XCMacros.h"
#import "DESEncrypt.h"
#import "UIButton+EnlargeTouchArea.h"
#import "UIView+NTES.h"
#import "XCOpenBoxManager.h"

//core
#import "TTRoomUIClient.h"
#import "RoomCoreV2.h"
#import "RoomQueueCoreV2.h"
#import "RoomQueueCoreClient.h"
#import "ImRoomCoreV2.h"
#import "ImRoomCoreClient.h"
#import "ImRoomCoreClientV2.h"
#import "MeetingCore.h"
#import "MeetingCoreClient.h"
#import "ImMessageCoreClient.h"
#import "FaceCore.h"
#import "AuthCore.h"
#import "VersionCore.h"
#import "BalanceErrorClient.h"
#import "ArrangeMicCoreClient.h"
#import "ArrangeMicCore.h"
#import "CPGameCoreClient.h"
#import "MentoringShipCore.h"
#import "ImMessageCore.h"
#import "TTCPGamePrivateChatClient.h"
#import "AuthCoreClient.h"
#import "RoomGiftValueCoreClient.h"
#import "MissionCore.h"
#import "MissionCoreClient.h"
#import "LittleWorldCore.h"
#import "XCLittleWorldRoomAttachment.h"
#import "XCRoomSuperAdminAttachment.h"
#import "CPGameCore.h"
#import "RoomRedClient.h"
#import "PraiseCore.h"
#import "PraiseCoreClient.h"
#import "GameCore.h"

//model
#import "TTPositionTopicModel.h"
#import "TTWorldletRoomModel.h"
// tool
#import "SDCycleScrollView.h"
#import "TTStatisticsService.h"
#import "TTPopup.h"
#import "TTNewUserGiftAlertView.h"
#import "XCMediator+TTGameModuleBridge.h"
#import "XCCurrentVCStackManager.h"
#import "XCMediator+TTRoomMoudleBridge.h"
#import <YYCache/YYCache.h>
#import "LookingLoveUtils.h"

// view
#import "LLRoomJoinPartyRoomGuideView.h"


@interface TTGameRoomViewController ()
<
RoomCoreClient,
RoomQueueCoreClient,
ImRoomCoreClient,
ImRoomCoreClientV2,
MeetingCoreClient,
BalanceErrorClient,
FaceCoreClient,
ArrangeMicCoreClient,
CPGameCoreClient,
MissionCoreClient,
PraiseCoreClient,
UITextFieldDelegate
>

@property (strong, nonatomic) dispatch_source_t timer; //发送公屏倒计时
@property (nonatomic, strong) TTRoomActivityCycleView *roomActivityCycleView;
@property (nonatomic, strong) TTRoomActivityCycleView *roomActivityCycleTopLeftView; // 左上活动页
// 新用户的提示
@property (nonatomic, strong) TTNewUserGiftAlertView *userNewGiftView;
@property (nonatomic, strong) CPGameListModel *gameInfo;
@end

@implementation TTGameRoomViewController

#pragma mark - overload
- (BOOL)isHiddenNavBar {
    return YES;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

#pragma mark - life cycle
- (void)dealloc {
    RemoveCoreClientAll(self);
    self.redEntranceView.delegate = nil;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [LookingLoveUtils lookingLoveWillShowRoom:20];
    
    [IQKeyboardManager sharedManager].enable = NO;
    [IQKeyboardManager sharedManager].enableAutoToolbar = NO;
    
    [self.messageView reloadChatList:NO];
    [self updateRoomInfoLabel];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self updateFunctionMenu];
    
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"Mini"] isEqualToString:@"open"]) {
        self.miniRoomButton.userInteractionEnabled = YES;
        [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"Mini"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
    [self.view bringSubviewToFront:self.listView];
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    if ([TTPopup hasShowPopup]) {
        [TTPopup dismiss];
    }
    
    [IQKeyboardManager sharedManager].enable = YES;
    [IQKeyboardManager sharedManager].enableAutoToolbar = YES;
    [IQKeyboardManager sharedManager].toolbarDoneBarButtonItemText = @"取消";
    
    [[NSUserDefaults standardUserDefaults] setObject:@"open" forKey:@"Mini"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initView];
    [self initConstrations];
    [self updateView];
    [self addCore];
    [self addNotificationCenter];
    [self addRoomEdgePanGesture];
    
    if (self.roomInfo.type == RoomType_CP) {
        if (self.roomInfo.isOpenGame) {
            [self updateGameStatusForUI];
        }
    }
    self.hadShowFinishView = NO;
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    if (CGRectEqualToRect(self.redEntranceView.frame, CGRectZero)) {
        //初始化红包入口
        //因为红包入口可拖动，所以使用frame方式初始化
        CGFloat width = 43;
        CGFloat height = 53;
        CGFloat x = KScreenWidth - width - 10;
        CGFloat y = CGRectGetMaxY(self.roomActivityCycleView.frame) + 70;
        if (GetCore(TTGameStaticTypeCore).openRoomStatus == OpenRoomType_CP) {
            y += 65;
        }
        self.redEntranceView.frame = CGRectMake(x, y, width, height);
        self.gameView.frame = CGRectMake(KScreenWidth - 50 - 10, CGRectGetMaxY(self.roomContributionBtn.frame) + 10, 50, 60);
    }
}

#pragma mark -
#pragma mark 滑动切换房间
/// 添加房间边缘手势(用于切换房间)
- (void)addRoomEdgePanGesture {
    if (GetCore(RoomCoreV2).fromType == JoinRoomFromType_PartyRoom && GetCore(CPGameCore).roomUids) {
        UISwipeGestureRecognizer *leftSwipeGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureChangeNextRoom:)];
        leftSwipeGesture.direction = UISwipeGestureRecognizerDirectionLeft;
        [self.view addGestureRecognizer:leftSwipeGesture];
        
        UISwipeGestureRecognizer *rightSwipeGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureChangeNextRoom:)];
        rightSwipeGesture.direction = UISwipeGestureRecognizerDirectionRight;
        [self.view addGestureRecognizer:rightSwipeGesture];
        
        if ([self isFirstJoinPartyRoom]) {
            // 第一次进入嗨聊房显示新手引导
            LLRoomJoinPartyRoomGuideView *guideView = [[LLRoomJoinPartyRoomGuideView alloc] initWithFrame:self.view.bounds];
            [self.view addSubview:guideView];
        }
    }
}

/// 如果是第一次进入嗨聊房
- (BOOL)isFirstJoinPartyRoom {
    
    YYCache *cache = [YYCache cacheWithName:@"kOpenPartyRoomCache"];
    
    BOOL isFirstJoinPartyRoom = (BOOL)[cache objectForKey:@"kFirstJoinPartyRoomKey"];
    
    if (!isFirstJoinPartyRoom) {
        [cache setObject:@(YES) forKey:@"kFirstJoinPartyRoomKey"];
    }
    
    return !isFirstJoinPartyRoom;
}

- (void)panGestureChangeNextRoom:(UISwipeGestureRecognizer *)panGesture {
    // 如果没有多个嗨聊房就不继续进行下去
    if (GetCore(CPGameCore).roomUids.count == 0) {
        return;
    }
    
    // 如果只有一个嗨聊房。抖动提示无法切换
    if (GetCore(CPGameCore).roomUids.count == 1) {
        [self shakeView:self.view];
        return;
    }
    
    // 当前进入房间的 index
    NSInteger currentIndex = GetCore(CPGameCore).currentRoomIndex;
    CGPoint startPoint = CGPointZero;
    switch (panGesture.state) {
        case UIGestureRecognizerStateBegan:
            // 记录手势开始的点
            startPoint = [panGesture locationInView:self.view];
        case UIGestureRecognizerStateCancelled:
        case UIGestureRecognizerStateEnded:
        {
            // 如果可以通过手势滑动切换房间
            if ([self canJionPartyRoomWithIndex:currentIndex panGesture:panGesture]) {
                
                [TTStatisticsService trackEvent:@"room_hiparty_slide" eventDescribe:@"房间内-滑动切换嗨聊房"];
                
                // 获取手势在屏幕上的位置
                CGPoint point = [panGesture locationInView:self.view];
                NSInteger newRoomIndex = GetCore(CPGameCore).currentRoomIndex;
                NSDictionary *dict = GetCore(CPGameCore).roomUids[newRoomIndex];
                if ((point.x - startPoint.x) > 100) { // 滑动的偏移量
                    
                    if (dict[@"uid"]) {
                        [[XCMediator sharedInstance] ttRoomMoudle_presentRoomViewControllerWithRoomUid:[dict[@"uid"] userIDValue] andNeedEdgeGesture:YES];
                    }
                }
            }
        }
            break;
            
        default:
            break;
    }
}

/// 对界面进行抖动操作
/// @param viewToShake 目标view
- (void)shakeView:(UIView*)viewToShake {
    // 偏移值
    CGFloat t = 6.0;
    // 左摇
    CGAffineTransform translateLeft =CGAffineTransformTranslate(CGAffineTransformIdentity,-t,0.0);
    // 右晃
    CGAffineTransform translateRight  =CGAffineTransformTranslate(CGAffineTransformIdentity, t,0.0);
    // 执行动画 重复动画且执行动画回路
    viewToShake.transform = translateLeft;
    [UIView animateWithDuration:0.07 delay:0.0 options:UIViewAnimationOptionAutoreverse | UIViewAnimationOptionRepeat animations:^{
        // 设置重复次数 repeatCount为float
        [UIView setAnimationRepeatCount:2.0];
        viewToShake.transform = translateRight;
        
    } completion:^(BOOL finished){
        if(finished){
            // 从视图当前状态回到初始状态
            [UIView animateWithDuration:0.05 delay:0.0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
                viewToShake.transform =CGAffineTransformIdentity;
            } completion:NULL];
        }
    }];
}

/// 是否可以通过手势切换嗨聊房
/// @param currentIndex 当前房间的 index
/// @param panGesture 左右滑动手势
- (BOOL)canJionPartyRoomWithIndex:(NSInteger)currentIndex panGesture:(UISwipeGestureRecognizer *)panGesture {
    if (panGesture.direction == UISwipeGestureRecognizerDirectionLeft) {
        if (currentIndex == [self firstRoomIndex]) {
            // 已经是第0个了 不需要再进行操作下去
            currentIndex = [self lastRoomIndex];
        } else if (currentIndex > 0) {
            // 只要不是第0个 就可以进行 -1 操作
            currentIndex -= 1;
        }
        
    } else if (panGesture.direction == UISwipeGestureRecognizerDirectionRight) {

        if (currentIndex == [self lastRoomIndex]) {
            // 已经是数据中的最后一个了。不需要再操作下去
            currentIndex = [self firstRoomIndex];
        } else if (currentIndex < GetCore(CPGameCore).roomUids.count) {
            // 只要不是最后一条数据就可以进行 +1 操作
            currentIndex += 1;
        }
    }
    
    // 更新 core 里的房间 index
    GetCore(CPGameCore).currentRoomIndex = currentIndex;
    return YES;
}

/// 最后一个房间的 index
- (NSInteger)lastRoomIndex {
    return GetCore(CPGameCore).roomUids.count - 1;
}

/// 第一个房间的 index
- (NSInteger)firstRoomIndex {
    return 0;
}

#pragma mark - textFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (!self.sendButton.enabled) {
        return NO;
    }
    [self sendButtonDidClick:self.sendButton];
    return YES;
}
#pragma mark -
#pragma mark ArrangeMicCoreClient
- (void)roomArrangeMicStatusChangeWith:(CustomNotiHeaderArrangeMic)status {
    [GetCore(ArrangeMicCore) getArrangeMicList:self.roomInfo.uid status:0 page:1 pageSize:20];
    switch (status) {
        case Custom_Noti_Header_ArrangeMic_Non_Empty:
        {
            // 从无到有 显示红点
            [self updateQueueMicStatus:YES];
        }
            break;
        case Custom_Noti_Header_ArrangeMic_Empty:
        {
            // 从有到无 取消红点
            [self updateQueueMicStatus:NO];
        }
            break;
        default:
            break;
    }
}

// micList
- (void)getArrangeMicListSuccess:(ArrangeMicModel *)arrangeList status:(int)status {
    if (arrangeList.queue.count > 0) {
        [self updateQueueMicStatus:YES];
    }
}

- (void)getApplyRoomPKUsersSuccess:(ArrangeMicModel *)model status:(int)stauts{
    if (model.queue.count > 0) {
        [self updateQueueMicStatus:YES];
    }
}

#pragma mark - BalanceErrorClient
//余额额不足
- (void)onBalanceNotEnough {
    
    [TTPopup dismiss];
    
    [self ttShowBalanceNotEnougth];
}

#pragma mark - MeetingCoreClient
- (void)onJoinMeetingSuccess {
    
    [self updateFunctionMenu];
}

#pragma mark - RoomCoreClient
- (void)onGameRoomInfoUpdateSuccess:(RoomInfo *)info eventType:(RoomUpdateEventType)eventType{
    if (eventType==RoomUpdateEventTypeOpenAudioHight || eventType==RoomUpdateEventTypeCloseAudioHight) {
        if (GetCore(MeetingCore).isPlaying) {
            [GetCore(MeetingCore) stopPlayMusic];
            GetCore(MeetingCore).isPlaying = NO;
            GetCore(MeetingCore).currentMusic = nil;
        }
        
    }
    [self updateRoomInfoLabel];
    [self updateBoxStatus];
}

- (void)onGameRoomInfoUpdateFailth:(NSString *)message {
    [XCHUDTool showErrorWithMessage:message];
}

//在黑名单
- (void)mySelfIsInBalckList:(BOOL)state{
    if (state) {
        [XCHUDTool showErrorWithMessage:@"您已被房主加入黑名单"];
        [[TTRoomModuleCenter defaultCenter] dismissChannelViewWithQuitCurrentRoom:YES];
    }
}

- (void)onReceiveSuperAdminKickUsersWithMessage:(NIMMessage *)message {
    NIMCustomObject * object = message.messageObject;
    XCRoomSuperAdminAttachment * attach = (XCRoomSuperAdminAttachment *)object.attachment;
    TTRoomSuperAdminModel * model = [TTRoomSuperAdminModel modelWithJSON:attach.data];
    NSLog(@"%@", GetCore(AuthCore).getUid);
    if (model.targetUid == GetCore(AuthCore).getUid.userIDValue) {
        if (attach.second == Custom_Noti_Sub_Room_SuperAdmin_DownMic) {
            [XCHUDTool showErrorWithMessage:@"系统检测涉嫌违规，你被抱下麦"];
        }else if (attach.second == Custom_Noti_Sub_Room_SuperAdmin_TickManagerRoom) {
            [XCHUDTool showErrorWithMessage:@"系统检测涉嫌违规，你已被请出房间"];
            [self ttReceiveSuperAdminMessageQuitRoomHandle];
        }
    }
}

- (void)onReceiveSuperAdminOffical:(NIMMessage *)message {
    NIMCustomObject * object = message.messageObject;
    XCRoomSuperAdminAttachment * attach = (XCRoomSuperAdminAttachment *)object.attachment;
    if (attach.first == Custom_Noti_Header_Room_SuperAdmin) {
        if (attach.second == Custom_Noti_Sub_Room_SuperAdmin_unLimmit) {
            [XCHUDTool showErrorWithMessage:@"系统检测涉嫌违规，予以解除进房限制"];
            
        } else if (attach.second == Custom_Noti_Sub_Room_SuperAdmin_unLock) {
            [XCHUDTool showErrorWithMessage:@"系统检测涉嫌违规，予以解除房间上锁警告"];
            
        } else {
            UIView *view = [UIApplication sharedApplication].keyWindow;
            [XCHUDTool showErrorWithMessage:@"系统检测涉嫌违规，房间已关闭" inView:view];
        }
        
    }
    
}

/// 关注房主结果通知
- (void)onRecvFocusOwner:(NIMMessage *)message {
    //延迟是因为，云信发完通知，接口状态还没有改变
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [XCHUDTool showSuccessWithMessage:@"关注成功"];
        [self updateFoucsOwnerButtonLayout];
    });
}



#pragma mark - RoomQueueCoreClient
- (void)thisUserIsBePrevent:(BePreventType)type{
    if (type == BePreventTypeDownMic) {
        
        [XCHUDTool showErrorWithMessage:@"不能踢皇帝陛下哦"];
    }else if (type == BePreventTypecloseMic){
        
        [XCHUDTool showErrorWithMessage:@"不能禁麦皇帝陛下哦"];
    }
}

- (void)onMicroUpMicFail{
    
    [XCHUDTool showErrorWithMessage:@"上麦失败,请重试哦"];
}

- (void)onMicroStateChange {
    [self updateFunctionMenu];
}

- (void)onMicroQueueUpdate:(NSMutableDictionary *)micQueue {
    
    [self updateFunctionMenu];
}

- (void)onManagerAdd:(NIMChatroomMember *)member{
    
    [self updateFunctionMenu];//更新toolBar菜单
    [self updateView];//更新话题编辑权限
    [self isShowTogetherButton];
}
- (void)onManagerRemove:(NIMChatroomMember *)member{
    [self updateFunctionMenu];
    [self updateView];
    [self isShowTogetherButton];
}
//被挤下麦了
- (void)onMicroBeSqueezedOut{
    [XCHUDTool showErrorWithMessage:@"你被挤下麦了哦"];
}
//房主邀请上麦
- (void)onMicroBeInvite {
    [self ttShowInviteAlert];
}

- (void)onMicroBeKicked {
    [XCHUDTool showErrorWithMessage:@"你已被房主或者管理员抱下麦"];
    //    downMic
    NotifyCoreClient(CPGameCoreClient, @selector(downMic), downMic);
    
}

#pragma mark - ImRoomCoreClient
//房间不存在
- (void)onMeInterChatRoomFailth {
    
    [self ttShowFinishLive];
}
#pragma mark  --- 进入房间成功 ---
- (void)onMeInterChatRoomSuccess {

    self.isEnterRoomSuccess = YES;
    [XCHUDTool hideHUD];
    [self updateView];
    [self isShowTogetherButton];
    [self requestQueueListShowRedBageOrNo];
    
    [self masterSendInviteToApprentice];
    
    [self.roomActivityCycleView requestDataWithActivity];
    [self.roomActivityCycleTopLeftView requestDataWithActivity];
    
    if (self.roomInfo.type == RoomType_CP) {
        [self enterCPRoomSuccess];
    }else{
        NIMChatroomMember *mineMember = GetCore(RoomQueueCoreV2).myMember;
        if (mineMember.type != NIMChatroomMemberTypeCreator || mineMember.type != NIMChatroomMemberTypeManager) {
            [self addGuideView];
        } else {
            if (!self.roomInfo.showGiftValue) {
                [self addGuideView];
            }
        }
        
        if (self.roomInfo.worldId > 0) {
            [self showLittleWorldMessage];
        }
        
        [self showLittleWorldAttendRoomMessage];
    }
    
    //房间红包入口初始化
    [self initialRedEntranceView];
    //房主关注按钮初始化
    [self updateFoucsOwnerButtonLayout];
    
    // 区分房间类型（普通房、牌照房、新秀房）
    NSString *roomType = @"";
    switch (self.roomInfo.isPermitRoom) {
        case PermitRoomType_Other: // 普通房
        {
            roomType = @"普通房";
        }
            break;
        case PermitRoomType_Licnese:
        {
            roomType = @"牌照房";
        }
            break;
        case PermitRoomType_YoungerStar:
        {
            roomType = @"新秀房";
        }
            break;
        default:
            break;
    }
    // 统计房间类型
    [TTStatisticsService trackEvent:TTStatisticsServiceRoomListType eventDescribe:roomType];
    // 统计房间标签
    [TTStatisticsService trackEvent:TTStatisticsServiceRoomListLabel eventDescribe:self.roomInfo.roomTag];
    RoomInfo *roomInfo = GetCore(ImRoomCoreV2).currentRoomInfo;
    @weakify(self);
    [[GetCore(GameCore) requestRoomConfig:roomInfo.uid] subscribeNext:^(id  _Nullable x) {
           @strongify(self);
        
        self.gameInfo = (CPGameListModel *)x;
        if (self.gameInfo) {
           
            self.gameView.hidden = NO;
            self.gameView.gameInfo = self.gameInfo;
            
            NIMChatroomMember *myMember = GetCore(ImRoomCoreV2).myMember;
            BOOL isCreator = myMember.type == NIMChatroomMemberTypeCreator;
            BOOL isManager = myMember.type == NIMChatroomMemberTypeManager;
            
            if(isCreator || isManager) {
                self.gameView.showDeleteBtn = YES;
            } else {
                self.gameView.showDeleteBtn = NO;
            }
        } else {
            self.gameView.hidden = YES;
        }
    }];
    
    if ([GetCore(UserCore) getUserInfoInDB:GetCore(AuthCore).getUid.userIDValue].platformRole == XCUserInfoPlatformRoleSuperAdmin) { // 超级管理员隐藏分享
        self.shareButton.hidden = YES;
    }
}

- (void)onMeInterChatSameRoomSuccess {
    [self initialRedEntranceView];
    RoomInfo *roomInfo = GetCore(ImRoomCoreV2).currentRoomInfo;
    @weakify(self);
    [[GetCore(GameCore) requestRoomConfig:roomInfo.uid] subscribeNext:^(id  _Nullable x) {
           @strongify(self);
        
        self.gameInfo = (CPGameListModel *)x;
        if (self.gameInfo) {
           
            self.gameView.hidden = NO;
            self.gameView.gameInfo = self.gameInfo;
            
            NIMChatroomMember *myMember = GetCore(ImRoomCoreV2).myMember;
            BOOL isCreator = myMember.type == NIMChatroomMemberTypeCreator;
            BOOL isManager = myMember.type == NIMChatroomMemberTypeManager;
            
            if(isCreator || isManager) {
                self.gameView.showDeleteBtn = YES;
            } else {
                self.gameView.showDeleteBtn = NO;
            }
        } else {
            self.gameView.hidden = YES;
        }
        
    }];
}

- (void)onMeExitChatRoomSuccessV2 {
    self.isEnterRoomSuccess = NO;
//    [[TTGoldEggManager mainManager] stopAutoSmashEgg];
    [[XCOpenBoxManager shareManager] stopAutoOpenBox];
    [[XCOpenBoxManager shareManager] stopAutoOpenDiamondBox];
    
    [self chatRoomHiddenWhenTouchView];
    [self hideRoomContainerViewData];
}

- (void)onUserInterChatRoom:(NIMMessage *)message {
    [self updateOnLineCount];
}

- (void)onUserExitChatRoom:(NIMMessage *)message {
    [self updateOnLineCount];
}

- (void)onUserBeAddBlack:(NIMMessage *)message{
    [self updateOnLineCount];
}

- (void)onConnectionStateChanged:(NIMChatroomConnectionState)state{
    [self updateOnLineCount];
}

#pragma mark - ImRoomCoreClientV2
//房间信息变更
- (void)onCurrentRoomInfoChanged{
    [self updateView];
    if (!GetCore(RoomCoreV2).hasChangeGiftEffectControl) {
        GetCore(RoomCoreV2).hasAnimationEffect = GetCore(ImRoomCoreV2).currentRoomInfo.hasAnimationEffect;
    }
    
    [self updateRoomInfoLabelAndIcon:GetCore(ImRoomCoreV2).currentRoomInfo];
    
    if (GetCore(TTGameStaticTypeCore).openRoomStatus != OpenRoomType_CP) {
        [self isShowTogetherButton];
    }
    
    if (self.roomInfo) {
        if (self.roomInfo.type == RoomType_CP) {
            if ([self.roomInfo.limitType length] <= 0) {
                [self addOppositeSexMatchPool];
            } else {
                [self removeOppositeSexMatchPool];
            }
        } else {
            if (self.roomInfo.roomPwd.length > 0) {
                [self removeOppositeSexMatchPool];
            } else {
                [self addOppositeSexMatchPool];
            }
        }
        
        if (self.isEnterRoomSuccess) {
            [self updateRedEntranceViewShowStatus];
        }
    }
}

- (void)onCurrentRoomOnLineUserCountUpdate{
    
    [self updateOnLineCount];
}

- (void)onGetRoomQueueSuccessV2:(NSMutableDictionary*)info{
    
    self.firstEnterRoom = YES;
    self.secondEnterRoom = YES;
    [self updateFunctionMenu];
    
    if (self.roomInfo.type == RoomType_CP) {
        [self connectRoomKengWeiSuccess];
    }else{
        //       [self onGetRoomQueueSuccessV2UpTeams:info]; pk时的方法，已经没用
    }
}

/**
 更新麦序的回调方法

 @param userId 用户 uid
 @param position 坑位
 @param updateType 类型，上麦 or 下麦
 */
- (void)onRoomQueueUpdate:(UserID)userId position:(int)position type:(RoomQueueUpateType)updateType {
    // 离开模式下，房主位有人上坑后，就请求关闭离线模式(旧版情况下会有，新版做了处理不会)
    if (self.roomInfo.leaveMode && position == -1 && updateType == RoomQueueUpateTypeAdd) {
        // 关闭离线模式
        [GetCore(RoomCoreV2) requestChangeRoomLeaveMode:self.roomInfo.uid leaveMode:NO];
        
    // 离开模式下，如果有管理将房主抱上麦，就请求关闭离开模式，新旧版都会有这个问题，需要处理。
    } else if (self.roomInfo.leaveMode && userId == self.roomInfo.uid && updateType == RoomQueueUpateTypeAdd) {
        //  如果是管理员身份，才可以发送关闭离开模式的请求。不然会太多人并发数据了
        if (GetCore(RoomQueueCoreV2).myMember.type == NIMChatroomMemberTypeManager) {
            [GetCore(RoomCoreV2) requestChangeRoomLeaveMode:self.roomInfo.uid leaveMode:NO];
        }
    }
}

#pragma mark - ImMessageCoreClient
- (void)onSendRoomActivityCountDownTimeWithMsg:(NIMMessage *)msg error:(NSError *)error {
     
}


#pragma mark -
#pragma mark MissonClient
/// 是否是新用户
- (void)getMissionNewUser:(BOOL)isSuccess configID:(NSInteger)configID code:(NSInteger)code message:(NSString *)message {
    if (!isSuccess) {
        return;
    }
    
    if (![self.navigationController.topViewController isKindOfClass:NSClassFromString(@"TTGameRoomContainerController")]) {
        return;
    }
    
    //TODO 显示新人领取界面
    TTNewUserGiftAlertView *newUserGift = [[TTNewUserGiftAlertView alloc] initWithFrame:CGRectMake(0, 0, 274, 253)];
    
    newUserGift.finishHandler = ^{
        [TTStatisticsService trackEvent:@"popup_newUser_reward" eventDescribe:@"新人有礼弹窗-领取奖励"];
        // 点击领取
        [XCHUDTool showLoading];
        // 是成就任务
        [GetCore(MissionCore) requestMissionReceiveByMissionID:[NSString stringWithFormat:@"%ld", configID] type:2];
    };
    
    self.userNewGiftView = newUserGift;
    
    [TTPopup popupView:newUserGift style:TTPopupStyleAlert];
}


/**
 领取奖励回调
 @param isSuccess 是否成功
 @param type 任务领取类型 1 日常 2 是成就
 */
- (void)getMissionReceive:(BOOL)isSuccess type:(NSInteger)type code:(NSInteger)code message:(NSString *)message {
    [XCHUDTool hideHUD];
    
    if (!isSuccess) {
        // 如果领取失败，提示一下失败原因
        [XCHUDTool showErrorWithMessage:message];
        return;
    }
    
    if (!self.userNewGiftView) {
        return;
    }
    
    // 成功后改变状态
    [self.userNewGiftView changeConfirmButtonState];
    [XCHUDTool showSuccessWithMessage:@"送个萝卜礼物试试吧~"];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [TTPopup dismiss];
    });
}

#pragma mark - TTRoomUIClient
- (void)roomUIClientOnGetUserInfoByUidSuccess{
    
    self.roomOwnerUserInfo = GetCore(ImRoomCoreV2).roomOwnerInfo;
    [self updateOnLineCount];
    [self updateCoverView];
}


#pragma mark - event response
- (void)hideRoomContainerView{
    [self chatRoomHiddenWhenTouchView];
    [self hideRoomContainerViewData];
}

//进入box
- (void)boxEnterButtonAction:(UIButton *)boxEnterButton{
    [TTStatisticsService trackEvent:[self roomFullTrackName:TTStatisticsServiceRoomSmashEggClick] eventDescribe:@"砸蛋入口"];
    
    [self.editTextFiled resignFirstResponder];
//    [[TTGoldEggManager mainManager] showGoldEgg];
    [[XCOpenBoxManager shareManager] showBox];
}
//发送消息
- (void)sendButtonDidClick:(UIButton *)button{
    if (!self.sendButton.enabled) {
        return;
    }
    
    if (self.editTextFiled.text.length > 0) {
        NIMMessage *msg = [[NIMMessage alloc]init];
        msg.text = self.editTextFiled.text;
        
        [GetCore(ImMessageCore) antiSpam:self.editTextFiled.text withMessage:msg];
        
        if (msg.antiSpamOption.hitClientAntispam) {
            [XCHUDTool showErrorWithMessage:@"发送失败，官方提醒你文明用语"];
            return;
        }
        
        [GetCore(ImRoomCoreV2) sendMessage:self.editTextFiled.text];
        self.editTextFiled.text = @"";
        self.inputMessage = @"";
        [self.editTextFiled resignFirstResponder];
        [self openCountdown];
    }
}
//贡献版
- (void)roomContributionBtnClick:(UIButton *)button{
    [TTStatisticsService trackEvent:[self roomFullTrackName:TTStatisticsServiceRoomRankingListClick] eventDescribe:@"房间榜"];
    
    [self.editTextFiled resignFirstResponder];
    [self ttShowRoomGiftListView];
}

//关注房主
- (void)didClickFocusOwnerButton:(UIButton *)sender {
    
    [GetCore(PraiseCore) praise:GetCore(AuthCore).getUid.userIDValue bePraisedUid:self.roomInfo.uid];
}

//在线
- (void)onlineLabelClick:(UIGestureRecognizer *)recognizer{
    
    [self ttShowOnlineList];
}

//最小化
- (void)miniRoomButtonClick:(UIButton *)button{
    [self.editTextFiled resignFirstResponder];
    [self ttSetBeMiniRoom];
}
//分享
- (void)shareButtonClick:(UIButton *)button{
    [self.editTextFiled resignFirstResponder];
    [self ttShowRoomShareView];
}

//设置
- (void)settingButtonClick:(UIButton *)button {
    [self.editTextFiled resignFirstResponder];
    [self ttShowCloseList];
}

//🎲
- (void)togetherButtonDidClick:(UIButton *)button {
    if (!GetCore(FaceCore).isShowingFace) {
        if (GetCore(FaceCore).isLoadFace) {
            [GetCore(FaceCore) sendAllFace:[GetCore(FaceCore)getPlayTogetherFace]];
        }
    }
}

//重新加载toolBar
- (void)reloadToolBar {
    self.toolBarBgView.hidden = YES;
    [self updateFunctionMenu];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.editTextFiled resignFirstResponder];
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.editTextFiled resignFirstResponder];
}

- (void)didClickRoomIntroduceBtn:(UIButton *)button {
    NIMChatroomMember *myMember = GetCore(ImRoomCoreV2).myMember;
    if (myMember.type == NIMChatroomMemberTypeCreator || myMember.type == NIMChatroomMemberTypeManager) {
        TTRoomIntroduceViewController *introduceVC = [[TTRoomIntroduceViewController alloc] init];
        introduceVC.ttRoomInfo = self.roomInfo;
        [self.navigationController pushViewController:introduceVC animated:YES];
    } else {
        [self showIntroduceAlertView];
    }
}

- (void)backGroupChatBtnAction:(UIButton *)sender {
    [TTStatisticsService trackEvent:@"room-back-to-world" eventDescribe:@"语音房-回到小世界"];
    GetCore(LittleWorldCore).littleWorldBackChat = YES;
    
    [self miniRoomButtonClick:nil];
}

#pragma mark - overload
- (void)ttBeKicked:(NIMChatroomKickReason)reson {
    
    [GetCore(RoomCoreV2) clearDragonWithRoomUid:self.roomInfo.uid uid:GetCore(AuthCore).getUid.longLongValue];
    GetCore(RoomCoreV2).currenDragonFaceSendInfo = nil;
    [self updateOnLineCount];
    if (reson == 2) {
        [self ttQuiteRoom:2];
    } else if (reson == 5){
        [self ttQuiteRoom:5];
    } else {
        [self ttShowFinishLive];
    }
    
    if (reson ==2 || reson == 5) {
        [GetCore(ImRoomCoreV2) invalidateTimer];
        [GetCore(ImRoomCoreV2) resetAllQueue];
    }
    
    if ([_delegate respondsToSelector:@selector(roomExit)]) {
        [_delegate roomExit];
    }
    
}

//超管拉黑的时候
- (void)ttSuperAdminBeKicked:(NIMChatroomBeKickedResult *)reson {
    [GetCore(RoomCoreV2) clearDragonWithRoomUid:self.roomInfo.uid uid:GetCore(AuthCore).getUid.longLongValue];
    GetCore(RoomCoreV2).currenDragonFaceSendInfo = nil;
    [self updateOnLineCount];
     if (reson.reason == 5){
        [self ttQuiteRoomByAdmin:reson];
     }else if(reson.reason == 2) {
         [self ttQuiteRoomByAdmin:reson];
     }
    
    if (reson.reason ==2 || reson.reason == 5) {
        [GetCore(ImRoomCoreV2) invalidateTimer];
        [GetCore(ImRoomCoreV2) resetAllQueue];
    }
    
    if ([_delegate respondsToSelector:@selector(roomExit)]) {
        [_delegate roomExit];
    }
}

- (void)ttBeInBlackList{
    [GetCore(RoomCoreV2) clearDragonWithRoomUid:self.roomInfo.uid uid:GetCore(AuthCore).getUid.longLongValue];
    GetCore(RoomCoreV2).currenDragonFaceSendInfo = nil;
    [XCHUDTool showErrorWithMessage:@"您已被管理员拉黑"];
    
    [self.navigationController popToRootViewControllerAnimated:NO];
    
    [TTPopup dismiss];
    [[TTRoomModuleCenter defaultCenter] dismissChannelViewWithQuitCurrentRoom:YES];
    
    if ([_delegate respondsToSelector:@selector(roomExit)]) {
        [_delegate roomExit];
    }
}

#pragma mark - private method
- (void)updateRoomInfoLabelAndIcon:(RoomInfo *)info {
    self.roomInfoLabel.attributedText = [self creatRoomTitle:info.title];
    self.roomInfoLabel.textAlignment = NSTextAlignmentCenter;
    
    self.roomInfoIcon.attributedText = [self creatRoomLock_GiftEffect_HighAudio:info];
    
    NSInteger iconNumber = 0;
    // lock
    if (info.roomPwd.length && ![info isEqual:@" "]) {
        iconNumber = iconNumber + 1;
    }
    
    // GiftEffect
    if (!info.hasAnimationEffect) {
        iconNumber = iconNumber + 1;
    }
    
    //  AudioQulity
    if (info.audioQuality == AudioQualityType_High) {
        iconNumber = iconNumber + 1;
    }
    
    NSInteger iconWidth = 16 * iconNumber;
    // titleLabelWidth = KScreenWidth - (分享按钮 + 间隔 + 设置按钮 + 间隔 + offset) * 2
    NSInteger titleLabelWidth = KScreenWidth - (20 + 17 + 20 + 14 + 30) * 2;
    
//    [self.roomInfoLabel mas_updateConstraints:^(MASConstraintMaker *make) {
//        make.centerY.equalTo(self.miniRoomButton).offset(-6);
//        make.width.lessThanOrEqualTo(@(titleLabelWidth));
//        if (iconNumber > 1) {
//            make.centerX.equalTo(self.view).offset(-(iconWidth * 0.5));
//        } else {
//            make.centerX.equalTo(self.view);
//        }
//    }];
    
    BOOL isLike = self.focusOwnerButton.hidden;
    CGFloat focusWidth = isLike ? 0 : 36;
    [self.roomInfoLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.miniRoomButton).offset(-6);
        make.width.lessThanOrEqualTo(@(titleLabelWidth-focusWidth));
        if (iconNumber > 1 || !isLike) {
            make.centerX.equalTo(self.view).offset(-0.5*(iconWidth+focusWidth));
        } else {
            make.centerX.equalTo(self.view);
        }
    }];
}

//更新关注房主约束
- (void)updateFoucsOwnerButtonLayout {
    
    if (GetCore(AuthCore).getUid.userIDValue == self.roomInfo.uid) {
        self.focusOwnerButton.hidden = YES;
        [self updateRoomInfoLabelAndIcon:GetCore(ImRoomCoreV2).currentRoomInfo];
        return;
    }
    
    @KWeakify(self);
    [GetCore(PraiseCore) isUid:GetCore(AuthCore).getUid.userIDValue isLikeUid:self.roomInfo.uid success:^(BOOL isLike) {
        @KStrongify(self);
        CGFloat focusWidth = isLike ? 0 : 36;
        self.focusOwnerButton.hidden = isLike;
        [self.focusOwnerButton mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(focusWidth);
        }];
        
        [self updateRoomInfoLabelAndIcon:GetCore(ImRoomCoreV2).currentRoomInfo];
    }];
}

//靓/id/在线人数
- (void)updateOnLineCount {
    
    self.IDAndOnlineLabel.attributedText = [self creatRoomBeauty_ID:self.roomOwnerUserInfo onLineCount:(int)GetCore(ImRoomCoreV2).onlineNumber];
    self.IDAndOnlineLabel.textAlignment = NSTextAlignmentCenter;
}

//更新房间信息
- (void)updateView {
    
    self.roomInfo = GetCore(ImRoomCoreV2).currentRoomInfo;
    if (self.roomInfo != nil) {
        self.roomOwnerUserInfo = GetCore(ImRoomCoreV2).roomOwnerInfo;
        
        if (self.roomInfo.roomId != self.messageHeaderView.roomInfo.roomId) {
            self.messageHeaderView.roomInfo = self.roomInfo;
            self.messageView.tableView.tableHeaderView = self.messageHeaderView;
        }
        
        [self updateCoverView];
        if (!self.roomInfo.valid) {
            //房主不在房间
            //            [self ttShowFinishLive];
        }
        [self updateOnLineCount];
        NIMChatroomMember *myMember = GetCore(ImRoomCoreV2).myMember;
        NSString *topic = @" 暂无房间话题";
        BOOL showEditIcon = (myMember.type == NIMChatroomMemberTypeCreator || myMember.type == NIMChatroomMemberTypeManager) ? YES : NO;
        
        if (self.roomInfo.roomDesc.length > 0) {
            topic = self.roomInfo.roomDesc;
        } else {
            if (myMember.type == NIMChatroomMemberTypeCreator || myMember.type == NIMChatroomMemberTypeManager) {
                topic = @" 点击设置房间话题";
            }
        }
        
//        [self.positionView setupRoomTag:self.roomInfo.tagPict tagName:self.roomInfo.roomTag topic:topic showEditIcon:showEditIcon];
//        self.positionView.showGiftValue = [GetCore(ImRoomCoreV2) canOpenGiftValue] && self.roomInfo.showGiftValue;
        
        [self configKTVUI];//配置KTV ui
        
        [self showBackChatGroup];
    }
    
    //刷新公屏消息
    [self.messageView reloadChatList:NO];
    [self updateBoxStatus];
}

/**
 更新箱子状态
 */
- (void)updateBoxStatus {
}

#pragma mark --- 房间信息改变 刷新UI ---
- (void)configKTVUI {
    
    if (self.roomInfo.isOpenGame && self.roomInfo.type == RoomType_CP) {
        // 是否开启了游戏模式
        self.gamePlayView.hidden = NO;
        self.roomActivityCycleView.hidden = YES;
        self.roomActivityCycleTopLeftView.hidden = YES;
        self.roomIntroduceBtn.hidden = YES;
        
        [self.roomPositionView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.roomContributionBtn).offset(40);
            make.height.mas_equalTo(KScreenWidth * 0.58 + 154);
        }];
        
        if (self.roomActivityCycleTopLeftView.superview) {
            [self.roomActivityCycleTopLeftView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.width.mas_equalTo(65);
                make.height.mas_equalTo(65);
                make.bottom.equalTo(self.roomPositionView.mas_top).offset(-8);
                make.right.equalTo(self.view).offset(-14);
            }];
        }
        
//        [self.positionView layoutIfNeeded];
//        self.positionView.positonViewType = XCRoomPositionViewTypeCPGame;
        [self updateFunctionMenu];
        
    } else {
        
        [self updateFunctionMenu];
        self.roomActivityCycleView.hidden = NO;
        self.roomActivityCycleTopLeftView.hidden = NO;
        self.roomIntroduceBtn.hidden = YES;
        self.gamePlayView.hidden = YES;
    
        if (GetCore(TTGameStaticTypeCore).openRoomStatus == OpenRoomType_CP) {
            [self.roomContributionBtn layoutIfNeeded];
            [self.roomPositionView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.roomContributionBtn.mas_top);
                make.left.right.equalTo(self.view);
                make.height.mas_equalTo(GetCore(TTGameStaticTypeCore).openRoomStatus == OpenRoomType_CP ? 195:312);
            }];
            
//            [self.positionView layoutIfNeeded];
//            self.positionView.top = self.roomContributionBtn.bottom + 14;
//            self.positionView.size = CGSizeMake(KScreenWidth, 195);
//            self.positionView.left = 0;
//            self.positionView.positonViewType = XCRoomPositionViewTypeCP;
//
                
            if (self.roomActivityCycleTopLeftView.superview) {
                [self.roomActivityCycleTopLeftView mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(self.roomPositionView.mas_bottom).offset(90);
                    make.right.mas_equalTo(-8);
                    make.width.mas_equalTo(65);
                    make.height.mas_equalTo(65);
                }];
            }
        } else {
            [self.roomPositionView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.roomContributionBtn);
                make.left.right.equalTo(self.view);
                make.height.mas_equalTo(self.roomInfo.type == RoomType_Love ? 267 : 312);
            }];
            
            
            if (self.roomActivityCycleTopLeftView.superview) {
                [self.roomActivityCycleTopLeftView mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.top.mas_equalTo(self.roomContributionBtn.mas_bottom).offset(10);
                    make.left.mas_equalTo(18);
                    make.width.mas_equalTo(65);
                    make.height.mas_equalTo(65);
                }];
            }
        }
    }
}

//更新背景
- (void)updateCoverView {
    if ([_delegate respondsToSelector:@selector(updateBackPicWith:userInfo:)]) {
        [_delegate updateBackPicWith:self.roomInfo userInfo:self.roomOwnerUserInfo];
    }
}

//创建房间title/lock/effect/高音质
- (void)updateRoomInfoLabel{
    
    if (GetCore(ImRoomCoreV2).currentRoomInfo) {
        if (GetCore(RoomCoreV2).hasChangeGiftEffectControl) {
            
        }
        [self updateRoomInfoLabelAndIcon:GetCore(ImRoomCoreV2).currentRoomInfo];
        [self updateFoucsOwnerButtonLayout];
    }
}

- (void)deleteSuperAdminUpdateFunctionMenu {
    
    self.functionMenuView.delegateSuperAdmin = YES;
    [self updateFunctionMenu];
}

//发送公屏倒计时
- (void)openCountdown{
    
    __block NSInteger time = 3.0; //倒计时时间
    if (_timer != nil) {
        dispatch_source_cancel(_timer);
    }
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(_timer, ^{
        
        if(time <= 0){ //倒计时结束
            dispatch_source_cancel(self->_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.sendButton setTitle:@"发送" forState:UIControlStateNormal];
                self.sendButton.enabled = YES;
            });
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.sendButton setTitle:[NSString stringWithFormat:@"%ld", (long)time] forState:UIControlStateNormal];
                self.sendButton.enabled = NO;
                time--;
            });
            
        }
    });
    dispatch_resume(_timer);
}

/** 根据排麦列表数据来显示小红点与否
 *  在产品强烈的要求下
 */
- (void)requestQueueListShowRedBageOrNo {
    if (self.roomInfo && self.roomInfo.roomModeType == RoomModeType_Open_Micro_Mode) {
        [GetCore(ArrangeMicCore) getArrangeMicList:self.roomInfo.uid status:0 page:1 pageSize:20];
    }
}

- (void)addCore{
    AddCoreClient(TTRoomUIClient, self);
    AddCoreClient(RoomCoreClient, self);
    AddCoreClient(RoomQueueCoreClient, self);
    AddCoreClient(ImRoomCoreClient, self);
    AddCoreClient(ImRoomCoreClientV2, self);
    AddCoreClient(BalanceErrorClient, self);
    AddCoreClient(MeetingCoreClient, self);
    AddCoreClient(ImMessageCoreClient, self);
    AddCoreClient(FaceCoreClient, self);
    AddCoreClient(ArrangeMicCoreClient, self);
    AddCoreClient(CPGameCoreClient, self);
    AddCoreClient(MentoringShipCoreClient, self);
    AddCoreClient(TTCPGamePrivateChatClient, self);
    AddCoreClient(AuthCoreClient, self);
    AddCoreClient(RoomGiftValueCoreClient, self);
    AddCoreClient(MissionCoreClient, self);
    AddCoreClient(LittleWorldCoreClient, self);
    AddCoreClient(PraiseCoreClient, self);
    AddCoreClient(LittleWorldWoreToastClient, self);
    AddCoreClient(RoomRedClient, self);
    AddCoreClient(PraiseCoreClient, self);
}

- (void)addNotificationCenter{
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHidden:) name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textFieldEditChanged:) name:UITextFieldTextDidChangeNotification object:self.editTextFiled];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deleteSuperAdminUpdateFunctionMenu) name:@"NotSuperAdmin" object:nil];
}

- (void)initView {
    [self.view addSubview:self.miniRoomButton];
    [self.view addSubview:self.roomInfoLabel];
    [self.view addSubview:self.focusOwnerButton];
    [self.view addSubview:self.roomInfoIcon];
    [self.view addSubview:self.shareButton];
    [self.view addSubview:self.settingButton];
    [self.view addSubview:self.roomPositionView];

//    [self.view addSubview:self.positionView];
    [self.view addSubview:self.IDAndOnlineLabel];
    [self.view addSubview:self.roomContributionBtn];
    [self.view addSubview:self.roomIntroduceBtn];
    
    //🎲
    if (!GetCore(VersionCore).loadingData && (GetCore(TTGameStaticTypeCore).openRoomStatus != OpenRoomType_Love)) {
        [self.view addSubview:self.togetherButton];
    }

    [self.view addSubview:self.backGroupChatBtn];

    if (GetCore(TTGameStaticTypeCore).openRoomStatus == OpenRoomType_CP) {
        [self.view addSubview:self.gamePlayView];
    }
    //box
//    [self.view addSubview:self.boxEnterButton];
    
    [self.view addSubview:self.messageView];
    [self.view addSubview:self.roomActivityCycleView];
    [self.view addSubview:self.roomActivityCycleTopLeftView];
    
    [self.view addSubview:self.roomContainerView];
    [self.roomContainerView addSubview:self.roomContainerBgView];
    
    [self.view addSubview:self.editContainerView];
    [self.editContainerView addSubview:self.editTextFiled];
    [self.editContainerView addSubview:self.sendButton];
    [self.view addSubview:self.toolBarBgView];
    
    if (GetCore(TTGameStaticTypeCore).openRoomStatus != OpenRoomType_Love) {
        [self.view addSubview:self.gameCancelBtn];
        [self.view addSubview:self.gameOpenBtn];
        [self.view addSubview:self.gameStartBtn];;
    }
    
    
    [self.view addSubview:self.masterTimeView];
    
    [self.view addSubview:self.redEntranceView];
    
    [self.view addSubview:self.gameView];
    
    self.firstEnterRoom = YES;
    self.secondEnterRoom = YES;
}

- (void)initConstrations {
    [self.miniRoomButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(14);
        make.top.equalTo(self.view).offset(30+kSafeAreaTopHeight);
        make.height.width.equalTo(@22);
    }];
    [self.roomInfoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.miniRoomButton).offset(-6);
        make.width.lessThanOrEqualTo(@200);
        make.centerX.equalTo(self.view);
    }];
    [self.focusOwnerButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.roomInfoLabel.mas_right).offset(4);
        make.centerY.equalTo(self.roomInfoLabel);
        make.width.mas_equalTo(0);
        make.height.mas_equalTo(19);
    }];
    [self.roomInfoIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.focusOwnerButton.mas_right);
        make.centerY.equalTo(self.miniRoomButton).offset(-6);
        make.width.mas_greaterThanOrEqualTo(13);
    }];
    [self.shareButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.settingButton.mas_left).offset(-17);
        make.centerY.mas_equalTo(self.miniRoomButton);
        make.width.height.mas_equalTo(20);
    }];
    [self.settingButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-14);
        make.centerY.mas_equalTo(self.miniRoomButton);
        make.width.height.mas_equalTo(20);
    }];
    
    [self.IDAndOnlineLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.roomInfoLabel.mas_bottom).offset(3);
        make.width.lessThanOrEqualTo(@200);
        make.centerX.equalTo(self.view);
    }];
    
    [self.roomContributionBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(-12);
        make.top.mas_equalTo(statusbarHeight+57);
        make.width.mas_equalTo(90);
        make.height.mas_equalTo(26);
    }];
    
    [self.roomIntroduceBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.roomContributionBtn.mas_right).offset(8);
        make.centerY.mas_equalTo(self.roomContributionBtn);
        make.width.mas_equalTo(40);
        make.height.mas_equalTo(24);
    }];
    
    CGFloat positionHeight = 312;
    if (GetCore(TTGameStaticTypeCore).openRoomStatus == OpenRoomType_CP) {
        positionHeight = 195;
    } else if (GetCore(TTGameStaticTypeCore).openRoomStatus == OpenRoomType_Love) {
        positionHeight = 267;
    }
    
    [self.roomPositionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.roomContributionBtn);
        make.left.right.equalTo(self.view);
        make.height.mas_equalTo(positionHeight);
    }];
    
    if (GetCore(TTGameStaticTypeCore).openRoomStatus == OpenRoomType_CP) {
        [self.gamePlayView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.roomPositionView);
            make.top.equalTo(self.roomPositionView).offset(0);
            make.left.right.mas_equalTo(self.view).offset(0);
            make.height.mas_equalTo(self.gamePlayView.mas_width).multipliedBy(0.58);
        }];
    }
    [self.messageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.roomPositionView.mas_bottom).offset(13);
        make.bottom.equalTo(self.view).offset(-57-kSafeAreaBottomHeight);
        make.left.equalTo(self.view).offset(8);
        make.right.equalTo(self.view).offset(-88);
    }];
    
    [self.roomActivityCycleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.messageView);
        make.right.equalTo(self.view).offset(-8);
        make.width.height.equalTo(@65);
    }];
    
    //box
    if (GetCore(TTGameStaticTypeCore).openRoomStatus == OpenRoomType_CP) {
        [self.roomActivityCycleTopLeftView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.roomActivityCycleView.mas_bottom).offset(25);
            make.right.equalTo(self.view).offset(-8);
            make.width.mas_equalTo(65);
            make.height.mas_equalTo(65);
        }];
    } else {
        [self.roomActivityCycleTopLeftView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.roomContributionBtn.mas_bottom).offset(30);
            make.left.mas_equalTo(10);
            make.width.mas_equalTo(65);
            make.height.mas_equalTo(65);
        }];
    }
    
    //🎲
    int offset = 33+20+kSafeAreaTopHeight; //33 = toolbar itemheight
    if (!GetCore(VersionCore).loadingData && (GetCore(TTGameStaticTypeCore).openRoomStatus != OpenRoomType_Love)) {
        [self.togetherButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.view).offset(-offset);
            make.width.height.equalTo(@40);
            make.right.equalTo(self.view).offset(-15);
        }];
    }
    
    [self.roomContainerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    
    [self.roomContainerBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.roomContainerView);
    }];
    
    [self.editContainerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.equalTo(self.view);
        make.height.equalTo(@40);
    }];
    [self.toolBarBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    [self.editTextFiled mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.editContainerView).offset(15);
        make.top.equalTo(self.editContainerView).offset(5);
        make.bottom.equalTo(self.editContainerView).offset(-5);
        make.right.equalTo(self.editContainerView).offset(-70);
    }];
    [self.sendButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.editContainerView).offset(-10);
        make.top.bottom.equalTo(self.editTextFiled);
        make.width.equalTo(@50);
    }];

    
    if (GetCore(TTGameStaticTypeCore).openRoomStatus != OpenRoomType_Love) {
        [self.gameStartBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(self.view).offset(-offset+5);
            if (self.togetherButton.superview) {
                make.right.mas_equalTo(self.togetherButton.mas_left).offset(-6);
            }else {
                make.right.mas_equalTo(self.view.mas_right).offset(-15);
            }
        }];
        [self.gameCancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self.gameStartBtn.mas_right).offset(13);
            make.bottom.mas_equalTo(self.gameStartBtn.mas_top);
        }];
        [self.gameOpenBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self.gameCancelBtn.mas_left).offset(-16);
            make.bottom.mas_equalTo(self.gameStartBtn.mas_top);
        }];
    }
    
    CGFloat masterTimeViewWidth = 67;
    if (GetCore(MentoringShipCore).countDownStatus == TTMasterCountDownStatusEnd) {
        masterTimeViewWidth = 75;
    }
    [self.masterTimeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.messageView);
        make.left.mas_equalTo(0);
        make.width.mas_equalTo(masterTimeViewWidth);
        make.height.mas_equalTo(27);
    }];
    
    [self.backGroupChatBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-8);
        make.bottom.mas_equalTo(-(60 + kSafeAreaBottomHeight));
        make.size.mas_equalTo(CGSizeMake(36, 36));
    }];
}

#pragma mark - Getter & Setter
- (void)setIsSameRoom:(BOOL)isSameRoom {
    _isSameRoom = isSameRoom;
    
    self.isEnterRoomSuccess = isSameRoom;
}

- (UIButton *)miniRoomButton{
    if (!_miniRoomButton) {
        _miniRoomButton = [[UIButton alloc] init];
        [_miniRoomButton setImage:[UIImage imageNamed:@"nav_bar_back_white"] forState:UIControlStateNormal];
        [_miniRoomButton addTarget:self action:@selector(miniRoomButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [_miniRoomButton setEnlargeEdgeWithTop:15 right:15 bottom:15 left:15];
    }
    return _miniRoomButton;
}
- (UIButton *)shareButton {
    if(!_shareButton){
        _shareButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_shareButton setImage:[UIImage imageNamed:@"tt_room_share_logo"] forState:UIControlStateNormal];
        [_shareButton addTarget:self action:@selector(shareButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        
        [_shareButton setEnlargeEdgeWithTop:8 right:8 bottom:8 left:8];

    }
    return _shareButton;
}
- (UIButton *)settingButton {
    if (!_settingButton) {
        _settingButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_settingButton setImage:[UIImage imageNamed:@"tt_room_setting_btn"] forState:UIControlStateNormal];
        [_settingButton addTarget:self action:@selector(settingButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        
        [_settingButton setEnlargeEdgeWithTop:8 right:8 bottom:8 left:8];
    }
    return _settingButton;
}
- (MarqueeLabel *)roomInfoLabel{
    if (!_roomInfoLabel) {
        _roomInfoLabel = [[MarqueeLabel alloc] init];
        _roomInfoLabel.scrollDuration = 8.0;
        _roomInfoLabel.fadeLength = 10.0f;
    }
    return _roomInfoLabel;
}

- (UIButton *)focusOwnerButton {
    if (!_focusOwnerButton) {
        _focusOwnerButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_focusOwnerButton setTitle:@"关注" forState:UIControlStateNormal];
        _focusOwnerButton.titleLabel.font = [UIFont boldSystemFontOfSize:10];
        _focusOwnerButton.backgroundColor = [[XCTheme getMainDefaultColor] colorWithAlphaComponent:0.2];
        _focusOwnerButton.layer.masksToBounds = YES;
        _focusOwnerButton.layer.cornerRadius = 9.5;
        _focusOwnerButton.layer.borderWidth = 1;
        _focusOwnerButton.layer.borderColor = [XCTheme getMainDefaultColor].CGColor;
        
        [_focusOwnerButton addTarget:self action:@selector(didClickFocusOwnerButton:) forControlEvents:UIControlEventTouchUpInside];
        
        _focusOwnerButton.hidden = YES;
    }
    return _focusOwnerButton;
}

- (UILabel *)roomInfoIcon{
    if (!_roomInfoIcon) {
        _roomInfoIcon = [[UILabel alloc] init];
    }
    return _roomInfoIcon;
}
- (YYLabel *)IDAndOnlineLabel{
    if (!_IDAndOnlineLabel) {
        _IDAndOnlineLabel = [[YYLabel alloc] init];
        _IDAndOnlineLabel.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onlineLabelClick:)];
        [_IDAndOnlineLabel addGestureRecognizer:tap];
    }
    return _IDAndOnlineLabel;
}

- (UIButton *)roomContributionBtn {
    if (_roomContributionBtn == nil) {
        _roomContributionBtn = [[UIButton alloc]init];
        //        [_roomContributionBtn setImage:[UIImage imageNamed:@"tt_room_contribution_btn"] forState:UIControlStateNormal];
        [_roomContributionBtn addTarget:self action:@selector(roomContributionBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        _roomContributionBtn.backgroundColor = UIColorRGBAlpha(0x000000, 0.2);
        [_roomContributionBtn setTitle:@"房间榜" forState:UIControlStateNormal];
        [_roomContributionBtn setImage:[UIImage imageNamed:@"tt_room_contribution_ico"] forState:UIControlStateNormal];
        [_roomContributionBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _roomContributionBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        _roomContributionBtn.layer.cornerRadius = 13;
        _roomContributionBtn.layer.masksToBounds = YES;
        _roomContributionBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 16, 0, 0);
        _roomContributionBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 20, 0, 0);
    }
    return _roomContributionBtn;
}
- (UIButton *)boxEnterButton{
    if (!_boxEnterButton) {
        _boxEnterButton = [[UIButton alloc] init];
        [_boxEnterButton setImage:[UIImage imageNamed:@"tt_room_box_enter"] forState:UIControlStateNormal];
        [_boxEnterButton addTarget:self action:@selector(boxEnterButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _boxEnterButton;
}

//- (XCRoomPositionView *)positionView{
//    if (!_positionView) {
//        XCRoomPositionItemSource *source = [XCRoomPositionItemSource itemSourceWithNormalImage:@"room_game_position_normal" muteImage:@"room_game_position_mute" lockImage:@"room_game_position_lock" sunImage:@"room_game_position_vip_sun"];
//
//        if (GetCore(TTGameStaticTypeCore).openRoomStatus == OpenRoomType_CP) {
//            _positionView = [[XCRoomPositionView alloc] initWithPositonViewStyle:XCRoomPositionViewLayoutStyleTuTu positonViewType:XCRoomPositionViewTypeCP positionSource:source];
//        }else{
//            _positionView = [[XCRoomPositionView alloc] initWithPositonViewStyle:XCRoomPositionViewLayoutStyleTuTu positonViewType:XCRoomPositionViewTypeNormal positionSource:source];
//        }
//        _positionView.delegate = self;
//    }
//    return _positionView;
//}

- (TTPositionView *)roomPositionView {
    if (!_roomPositionView) {
        TTRoomPositionViewLayoutStyle style = TTRoomPositionViewLayoutStyleNormal;
        TTRoomPositionViewType type = TTRoomPositionViewTypeNormal;
        
        if (GetCore(TTGameStaticTypeCore).openRoomStatus == OpenRoomType_CP) {
            style = TTRoomPositionViewLayoutStyleCP;
            type = TTRoomPositionViewTypeNormal;
        } else if (GetCore(TTGameStaticTypeCore).openRoomStatus == OpenRoomType_Love) {
            style = TTRoomPositionViewLayoutStyleLove;
            type = TTRoomPositionViewTypeLove;
        }
        _roomPositionView = [[TTPositionView alloc] initWithPositonViewStyle:style positonViewType:type];
        _roomPositionView.delegate = self;
        
    }
    return _roomPositionView;
}


- (TTMessageHeaderView *)messageHeaderView{
    if (!_messageHeaderView) {
        _messageHeaderView = [[TTMessageHeaderView alloc] init];
        _messageHeaderView.delegate = self;
    }
    return _messageHeaderView;
}
- (TTMessageView *)messageView{
    if (!_messageView) {
        _messageView = [[TTMessageView alloc] init];
        _messageView.tableView.tableHeaderView = self.messageHeaderView;
        _messageView.delegate = self;
    }
    return _messageView;
}

- (TTRoomActivityCycleView *)roomActivityCycleView {
    if (!_roomActivityCycleView) {
        _roomActivityCycleView = [[TTRoomActivityCycleView alloc] initWithType:ActivityPositionTypeBottomRight];
        _roomActivityCycleView.delegate = self;
    }
    return _roomActivityCycleView;
}

- (TTRoomActivityCycleView *)roomActivityCycleTopLeftView {
    if (!_roomActivityCycleTopLeftView) {
        _roomActivityCycleTopLeftView = [[TTRoomActivityCycleView alloc] initWithType:ActivityPositionTypeTopLeft];
        _roomActivityCycleTopLeftView.delegate = self;
    }
    return _roomActivityCycleTopLeftView;
}

- (UIButton *)togetherButton{
    if (!_togetherButton) {
        _togetherButton = [[UIButton alloc] init];
        _togetherButton.hidden = YES;
        [_togetherButton setImage:[UIImage imageNamed:@"tt_room_dis"] forState:UIControlStateNormal];
        [_togetherButton addTarget:self action:@selector(togetherButtonDidClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _togetherButton;
}

- (UIView *)toolBarBgView {
    if (!_toolBarBgView) {
        _toolBarBgView = [[UIView alloc] init];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(reloadToolBar)];
        [_toolBarBgView addGestureRecognizer:tap];
        _toolBarBgView.hidden = YES;
    }
    return _toolBarBgView;
}
- (UIView *)editContainerView{
    if (!_editContainerView) {
        _editContainerView = [[UIView alloc] init];
        _editContainerView.hidden = YES;
        _editContainerView.backgroundColor = [UIColor whiteColor];
    }
    return _editContainerView;
}
- (UITextField *)editTextFiled{
    if (!_editTextFiled) {
        _editTextFiled = [[UITextField alloc] init];
        _editTextFiled.placeholder = @"请输入消息...";
        _editTextFiled.borderStyle = UITextBorderStyleNone;
        _editTextFiled.returnKeyType = UIReturnKeySend;
        _editTextFiled.delegate = self;
        
    }
    return _editTextFiled;
}
- (UIButton *)sendButton{
    if (!_sendButton) {
        _sendButton = [[UIButton alloc] init];
        [_sendButton setTitle:@"发送" forState:UIControlStateNormal];
        _sendButton.titleLabel.textColor = [UIColor whiteColor];
        _sendButton.titleLabel.font = [UIFont systemFontOfSize:15];
        _sendButton.backgroundColor = [XCTheme getTTMainColor];
        _sendButton.layer.cornerRadius = 5.0;
        _sendButton.layer.masksToBounds = YES;
        [_sendButton addTarget:self action:@selector(sendButtonDidClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _sendButton;
}

- (UIView *)roomContainerView {
    if (!_roomContainerView) {
        _roomContainerView = [[UIView alloc] init];
        _roomContainerView.hidden = YES;
    }
    return _roomContainerView;
}
- (UIView *)roomContainerBgView {
    if (!_roomContainerBgView) {
        _roomContainerBgView = [[UIView alloc] init];
        _roomContainerBgView.backgroundColor = [UIColor blackColor];
        _roomContainerBgView.alpha = 0.4;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideRoomContainerView)];
        [_roomContainerBgView addGestureRecognizer:tap];
    }
    return _roomContainerBgView;
}


- (TTCPGameView *)gamePlayView {
    if (!_gamePlayView) {
        _gamePlayView = [TTCPGameView sharedGameView];
        _gamePlayView.hidden = YES;
    }
    return _gamePlayView;
}

- (UIButton *)gameStartBtn {
    if (!_gameStartBtn) {
        _gameStartBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _gameStartBtn.hidden = YES;
        [_gameStartBtn setImage:[UIImage imageNamed:@"game_start"] forState:UIControlStateNormal];
        [_gameStartBtn addTarget:self action:@selector(onClickGameStartBtn:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _gameStartBtn;
}

- (UIButton *)gameOpenBtn {
    if (!_gameOpenBtn) {
        _gameOpenBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _gameOpenBtn.hidden = YES;
        [_gameOpenBtn setImage:[UIImage imageNamed:@"game_open"] forState:UIControlStateNormal];
        [_gameOpenBtn addTarget:self action:@selector(onClickGameOpenBtn:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _gameOpenBtn;
}

- (UIButton *)gameCancelBtn {
    if (!_gameCancelBtn) {
        _gameCancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _gameCancelBtn.hidden = YES;
        [_gameCancelBtn setImage:[UIImage imageNamed:@"game_cancel"] forState:UIControlStateNormal];
        [_gameCancelBtn addTarget:self action:@selector(onClickGameCancelBtn:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _gameCancelBtn;
}

- (UIButton *)roomIntroduceBtn {
    if (!_roomIntroduceBtn) {
        _roomIntroduceBtn = [[UIButton alloc]init];
        _roomIntroduceBtn.backgroundColor = RGBACOLOR(255, 255, 255, 0.16);
        [_roomIntroduceBtn setTitle:@"公告" forState:UIControlStateNormal];
        [_roomIntroduceBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _roomIntroduceBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        [_roomIntroduceBtn addTarget:self action:@selector(didClickRoomIntroduceBtn:) forControlEvents:UIControlEventTouchUpInside];
        _roomIntroduceBtn.layer.cornerRadius = 12;
        _roomIntroduceBtn.layer.masksToBounds = YES;
        _roomIntroduceBtn.hidden = YES;
    }
    return _roomIntroduceBtn;
}

- (TTMasterTimeView *)masterTimeView {
    if (!_masterTimeView) {
        _masterTimeView = [[TTMasterTimeView alloc] init];
        _masterTimeView.delegate = self;
        _masterTimeView.hidden = YES;
        if (GetCore(MentoringShipCore).masterUid && GetCore(MentoringShipCore).apprenticeUid) {
            _masterTimeView.hidden = NO;
            if (GetCore(MentoringShipCore).currentTime) {
                
            } else {
                [GetCore(MentoringShipCore) openCountdownWithTime:3 * 60];
            }
        } else if (GetCore(MentoringShipCore).countDownStatus == TTMasterCountDownStatusEnd) {
            _masterTimeView.hidden = NO;
            [_masterTimeView updateSendGiftStatus];
        } else {
            _masterTimeView.hidden = YES;
        }
    }
    return _masterTimeView;
}

- (TTRoomContributionController *)contributionVC {
    if (_contributionVC == nil) {
        _contributionVC = [[TTRoomContributionController alloc] init];
        _contributionVC.view.frame = CGRectMake(0, KScreenHeight-480, KScreenWidth, 480);
        _contributionVC.delegate = self;
    }
    return _contributionVC;
}

- (TTGameRoomContributionContainerView *)contributionContainerView {
    if (_contributionContainerView == nil) {
        _contributionContainerView = [[TTGameRoomContributionContainerView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        _contributionContainerView.hidden = YES;
        [_contributionContainerView addSubview:self.contributionVC.view];
        
        @weakify(self)
        _contributionContainerView.maskViewTapActionBlock = ^{
            @strongify(self);
            
            ///榜单隐藏时清除缓存
            [GetCore(RankCore) clearCache];
            
            [UIView animateWithDuration:0.2 animations:^{
                self.contributionContainerView.hidden = YES;
            }];
        };
    }
    return _contributionContainerView;
}

- (UIButton *)backGroupChatBtn {
    if (!_backGroupChatBtn) {
        _backGroupChatBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_backGroupChatBtn setImage:[UIImage imageNamed:@"room_backGroupChat"] forState:UIControlStateNormal];
        [_backGroupChatBtn addTarget:self action:@selector(backGroupChatBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        _backGroupChatBtn.hidden = YES;
    }
    return _backGroupChatBtn;
}

- (TTRedEntranceView *)redEntranceView {
    if (_redEntranceView == nil) {
        _redEntranceView = [[TTRedEntranceView alloc] init];
        _redEntranceView.delegate = self;
        _redEntranceView.hidden = YES;
    }
    return _redEntranceView;
}

- (TTRedListView *)redListView {
    if (_redListView == nil) {
        _redListView = [[TTRedListView alloc] init];
        _redListView.delegate = self;
    }
    
    return _redListView;
}

- (TTRedDrawView *)redDrawView {
    if (_redDrawView == nil) {
        _redDrawView = [[TTRedDrawView alloc] init];
        _redDrawView.delegate = self;
    }
    return _redDrawView;
}

- (WBGameView *)gameView {
    if (!_gameView) {
        _gameView = [WBGameView new];
        _gameView.hidden = YES;
        _gameView.delegate = self;
    }
    return _gameView;
}


@end
