//
//  TTSessionViewController.m
//  TuTu
//
//  Created by gzlx on 2018/11/1.
//  Copyright © 2018年 YiZhuan. All rights reserved.
//

#import "TTSessionViewController.h"

#import "TTSessionViewController+PrivateGame.h"
#import "TTSessionViewController+MentoringShip.h"

#import "TTSessionConfig.h"
#import "TTMessageAttributedString.h"

//view
#import "XCOpenLiveAlertMessageContentView.h"
#import "XCRecPacketConentMessageView.h"
#import "XCNewsNoticeContentMessageView.h"
#import "XCGiftContentMessageView.h"
#import "TTRedColorAlertView.h"
#import "TTSessionFamilyView.h"
#import "XCTurntableContentView.h"
#import "XCP2PInteractiveView.h"
#import "XCNobleNotifyContentView.h"
#import "XCGuildMessageContentView.h"
#import "TTRoomeMessageNavView.h"
#import "TTOpenNobleTipCardView.h"
#import "TTSessionGuideView.h"
#import "XCCheckinNoticeMessageContentView.h"

#import "XCImagePreViewController.h"
#import "TTSessionBlackListController.h"
#import "NTESVideoViewController.h"

#import "BaseAttrbutedStringHandler+TTDynamicInfo.h"
#import "AnchorOrderAttributedStringMaker.h"

#import "XCMediator+TTPersonalMoudleBridge.h"
#import "XCMediator+TTDiscoverModuleBridge.h"
#import "XCMediator+TTRoomMoudleBridge.h"
#import "XCMediator+TTGameModuleBridge.h"
#import "XCMediator+TTMessageMoudleBridge.h"

//attachment
#import "NobleNotifyAttachment.h"
#import "P2PInteractiveAttachment.h"
#import "XCUserUpgradeAttachment.h"
#import "XCGiftAttachment.h"
#import "TurntableAttachment.h"
#import "XCRedPacketInfoAttachment.h"
#import "XCNewsInfoAttachment.h"
#import "RedPacketDetailInfo.h"
#import "XCGuildAttachment.h"
#import "XCMentoringShipAttachment.h"
#import "XCChatterboxAttachment.h"
#import "XCChatterboxPointAttachment.h"
#import "XCLittleWorldAutoQuitAttachment.h"
#import "XCDynamicAuditAttachment.h"
#import "XCCheckinNoticeAttachment.h"
#import "XCGameVoiceBottleAttachment.h"
#import "XCDynamicPostSuccessAttachment.h"
#import "XCCPGamePrivateSysNotiAttachment.h"

#import "TTChatterboxGameModel.h"
#import "LittleWorldListModel.h"
#import "TTGameStaticTypeCore.h"
#import "TTCPGameOverAndSelectClient.h"
#import "GroupCore.h"
#import "UserCore.h"
#import "AuthCore.h"
#import "FamilyCore.h"
#import "VersionCore.h"
#import "PraiseCore.h"
#import "ImFriendCore.h"
#import "HostUrlManager.h"
#import "BalanceErrorClient.h"
#import "FamilyCoreClient.h"
#import "XCApplicationSharement.h"
#import "MentoringShipCoreClient.h"
#import "GroupCoreClient.h"
#import "ImFriendCoreClient.h"
#import "CPGameCore.h"
#import "ImMessageCore.h"
#import "CPGameCoreClient.h"
#import "VoiceBottleCoreClient.h"
#import "ImMessageCoreClient.h"
#import "MessageCore.h"
#import "TTCPGameStaticCore.h"
#import "LittleWorldCore.h"

#import "XCHUDTool.h"
#import "TTPopup.h"
#import "XCHtmlUrl.h"
#import "TTSendGiftView.h"
#import "XCTheme.h"
#import "UIColor+UIColor_Hex.h"
#import "NSString+Utils.h"
#import "XCCurrentVCStackManager.h"
#import "TTStatisticsService.h"
#import "LookingLoveUtils.h"
#import "TTWKWebViewViewController.h"

#import "NIMKitProgressHUD.h"
#import <YYText/YYText.h>
#import <YYCache/YYCache.h>
#import <Masonry/Masonry.h>
#import "NSString+JsonToDic.h"
#import <IQKeyboardManager/IQKeyboardManager.h>

static NSString *const kChatterGuideStatusStoreKey = @"TTChatterViewControllerGuideStatus";
static NSString *const KTTChatterBoxIsSendGameMessageKey = @"KTTChatterBoxIsSendGameMessageKey";

@interface TTSessionViewController ()
<
NIMMessageCellDelegate,
MentoringShipCoreClient,
TTSendGiftViewDelegate,
FamilyCoreClient,
GroupCoreClient,
TTCPGameListViewDelegate,
TTRoomeMessageNavViewDelegate,
TTOpenNobleTipCardViewDelegate,
TTSelectGameViewDelegate,
CPGameCoreClient,
VoiceBottleCoreClient
>

@property (nonatomic, strong) TTSessionConfig *sessionConfig;
@property (nonatomic, strong) TTSendGiftView *giftView;
@property (nonatomic, strong) TTSessionFamilyView *familyView;
@property (nonatomic, strong) UserInfo *targetInfor;
/** 房间内的消息*/
@property (nonatomic, strong) TTRoomeMessageNavView *roomMessageNavView;
@property (nonatomic, assign) BOOL removeSelect;
@property (nonatomic, assign) NSInteger topInset;
@property (nonatomic, assign) BOOL chatterBoxType;

@property (nonatomic, strong) NSAttributedString *anchorOrderAttributedString;//主播订单富文本
@property (nonatomic, strong) AnchorOrderAttributedStringMaker *anchorOrderStrMaker;//主播订单富文本管理

@end

@implementation TTSessionViewController

#pragma mark - life cycle
- (void)dealloc {
    RemoveCoreClientAll(self);
    NSLog(@"%s", __func__);
    [GetCore(TTGameStaticTypeCore) destructionTimer];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    AddCoreClient(BalanceErrorClient, self);
    AddCoreClient(FamilyCoreClient, self);
    AddCoreClient(MentoringShipCoreClient, self);
    AddCoreClient(TTCPGamePrivateChatClient, self);
    AddCoreClient(TTCPGameOverAndSelectClient, self);
    AddCoreClient(GroupCoreClient, self);
    AddCoreClient(ImFriendCoreClient, self);
    AddCoreClient(CPGameCoreClient, self);
    AddCoreClient(VoiceBottleCoreClient, self);
    AddCoreClient(ImMessageCoreClient, self);

    [self initNavBar];
    [self initTitle];
    [self configGroupStatus];
    [self initRoomMessageNavView];
    [self initView];
    
    [self requestGameListData];
    
    //主播订单数据
    [self requestAnchorOrderData];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    // hx
    [LookingLoveUtils lookingLoveWillShowP2PChat:30];

    if (self.isRoomMessage) {
        [self.navigationController setNavigationBarHidden:YES animated:animated];
    }else{
        [self.navigationController setNavigationBarHidden:NO animated:animated];
    }
    
    [self.navigationController.navigationBar.subviews enumerateObjectsUsingBlock:^(UIView *view, NSUInteger idx, BOOL *stop) {
        if ([[UIDevice currentDevice].systemVersion doubleValue] >= 10.0) {
            //iOS10,改变了导航栏的私有接口为_UIBarBackground
            if ([view isKindOfClass:NSClassFromString(@"_UIBarBackground")]) {
                if ([[UIDevice currentDevice].systemVersion doubleValue] >= 14.0) {
                    [view.subviews firstObject].hidden = NO;
                } else {
                    [view.subviews firstObject].hidden = YES;
                }
            }
        }else{
            //iOS10之前使用的是_UINavigationBarBackground
            if ([view isKindOfClass:NSClassFromString(@"_UINavigationBarBackground")]) {
                
                [view.subviews firstObject].hidden = NO;
            }
        }
    }];
    
    [NIMKitProgressHUD dismiss];
    
    BOOL isBlock = [GetCore(ImFriendCore) isUserInBlackList:self.session.sessionId];
    [self refreshSessionSubTitle:isBlock ? @"已加入黑名单" : @""];
    if (self.session.sessionType == NIMSessionTypeTeam) {
        [self.view bringSubviewToFront:self.familyView];
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self setNeedsStatusBarAppearanceUpdate];
}

- (void)viewDidLayoutSubviews {
    if (self.isRoomMessage) {
        CGFloat height = 400;
        if (KScreenWidth > 320) {
            height = 530;
        }
        self.view.frame = CGRectMake(0, 0, KScreenWidth, height);
    }
}

- (void)initView {
    [self.view addSubview:self.selectGameButton];
    [self.view addSubview:self.listView];
    [self.selectGameButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-9);
        make.bottom.mas_equalTo(self.sessionInputView.mas_top).offset(-7);
        make.size.mas_equalTo(CGSizeMake(65, 65));
    }];
    
    if (GetCore(TTCPGameStaticCore).gameSwitch){
        self.selectGameButton.hidden = NO;
    }else{
        self.selectGameButton.hidden = YES;
    }
    
    if ([self.session.sessionId isEqualToString:keyWithType(KeyType_SecretaryUid, NO)] || [self.session.sessionId isEqualToString:keyWithType(KeyType_SystemNotifyUid, NO)]) {
        // 系统消息和小秘书消息 隐藏游戏按钮
        self.selectGameButton.hidden = YES;
    }
    
    if (self.session.sessionType == NIMSessionTypeTeam) { // 家族群组隐藏游戏按钮
        self.selectGameButton.hidden = YES;
    }
    
    if (self.isRoomMessage) { // 房间内的私聊
        self.selectGameButton.hidden = YES;
    }
    
    if (self.session.sessionType == NIMSessionTypeTeam) { // 家族群组隐藏游戏按钮
        self.selectGameButton.hidden = YES;
    }
    
    if (projectType() == ProjectType_Planet) { // hello处CP 不展示游戏
        self.selectGameButton.hidden = YES;
    }
    
    self.topInset = self.tableView.contentInset.top;
    if (self.isMatchMessage) {
        self.tableView.contentInset = UIEdgeInsetsMake(self.topInset + 170, 0, 0, 0);
        [self.view addSubview:self.gameView];
        [self.gameView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(KScreenWidth, 170));
            make.left.mas_equalTo(0);
            make.top.mas_equalTo(self.view.mas_top).offset(kNavigationHeight + self.topInset);
        }];
    }
    self.removeSelect = NO;
    
    EnvironmentType env = [HostUrlManager.shareInstance currentEnvironment];
    BOOL devMode = env == TestType || env == DevType;
    NSString *secretaryUid = keyWithType(KeyType_SecretaryUid, devMode);
    NSString *systemUid = keyWithType(KeyType_SystemNotifyUid, devMode);
    if ([self.session.sessionId isEqualToString:secretaryUid] || [self.session.sessionId isEqualToString:systemUid] ) {
        self.sessionInputView.hidden = YES;
        [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view);
        }];
    }
}

#pragma mark - override
- (id<NIMSessionConfig>)sessionConfig {
    if (_sessionConfig == nil) {
        _sessionConfig = [[TTSessionConfig alloc] init];
        _sessionConfig.roomMessage = self.isRoomMessage;
        _sessionConfig.session = self.session;
    }
    return _sessionConfig;
}

- (NSString *)sessionSubTitle {
    BOOL isBlock = [GetCore(ImFriendCore) isUserInBlackList:self.session.sessionId];
    return isBlock ? @"已加入黑名单" : @"";
}

/// 会话页导航栏子标题富文本，如果有值优先显示
- (NSAttributedString *)sessionSubTitleAttributedString {
    return self.anchorOrderAttributedString;
}

#pragma mark - Public
/// 撩一下，进入私聊时，自动给对方发送一句打招呼
- (void)flirtSayHi {
    
    NSString *cacheName = @"sayHiCacheName";
    NSString *storeKey = @"storeKey";
    YYCache *cache = [YYCache cacheWithName:cacheName];
    NSArray *ids = (NSArray *)[cache objectForKey:storeKey];
    NSString *pairId = [NSString stringWithFormat:@"%@_%@", GetCore(AuthCore).getUid, self.session.sessionId];
    
    if ([ids containsObject:pairId]) {
        //已经撩过TA，不能再撩了
        return;
    }
    
    //请求打招呼文案
    [GetCore(MessageCore) requestMessageGreetingToUid:self.session.sessionId completion:^(NSString * _Nullable greeting, NSNumber * _Nullable code, NSString * _Nullable msg) {
        
        if (greeting && greeting.length > 0) {
            
            //send msg
            NIMMessage *message = [[NIMMessage alloc] init];
            message.text = greeting;
            [[NIMSDK sharedSDK].chatManager sendMessage:message toSession:self.session error:nil];
            
            //store
            NSMutableArray *arr = [NSMutableArray arrayWithArray:ids ?: @[]];
            [arr addObject:pairId];
            [cache setObject:arr.copy forKey:storeKey];
        }
    }];
}

#pragma mark - XCRoomMessageNavViewDelegate
//房间内消息返回按钮
- (void)backButtonClick:(UIButton *)sender{
    if (self.isRoomMessage) {
        CATransition *transition = [CATransition animation];
        transition.duration = 0.3f;
        transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        transition.type = kCATransitionPush;
        transition.subtype = kCATransitionFromLeft;
        [self.view.superview.layer addAnimation:transition forKey:nil];
        [self removeFromParentViewController];
        [self.view removeFromSuperview];
    }
}

/// 群信息管理
- (void)pushToGroupManager {
    UIViewController *controller = [[XCMediator sharedInstance] ttDiscoverMoudle_TTGroupManagerViewController:self.session.sessionId];
    GetCore(GroupCore).isReloadGroupInfor = NO;
    [self.navigationController pushViewController:controller animated:YES];
}

///拉黑管理
- (void)pushToBlackList {
    TTSessionBlackListController *vc = [[TTSessionBlackListController alloc] init];
    vc.uid = self.session.sessionId.userIDValue;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - Toolbar More Actions Handle
- (void)onTapSendGift:(NIMMediaItem *)item {
    
    TTSendGiftView *giftView = [[TTSendGiftView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight) usingPlace:XCSendGiftViewUsingPlace_Message roomUid:0];
    giftView.delegate = self;
    giftView.targetInfo = self.targetInfor;
    
    TTPopupConfig *config = [[TTPopupConfig alloc] init];
    config.contentView = giftView;
    config.style = TTPopupStyleActionSheet;
    config.didFinishDismissHandler = ^(BOOL isDismissOnBackgroundTouch) {
        [IQKeyboardManager sharedManager].enable = NO;
    };
    config.didFinishShowingHandler = ^{
        
        [IQKeyboardManager sharedManager].enable = YES;
        if (iPhoneX) {
            [IQKeyboardManager sharedManager].keyboardDistanceFromTextField = 40;
        }
    };
    
    [TTPopup popupWithConfig:config];
}

// 话匣子游戏
- (void)onTapChatterbox:(NIMMediaItem *)item {
    [TTStatisticsService trackEvent:@"message-start-chatterbox" eventDescribe:@"消息-发起话匣子"];
    // 轻寻不要新手引导
    if (projectType() == ProjectType_CeEr) {
        [self launchChatterboxGame];
        return;
    }
    // 首次显示引导
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    BOOL hadGuide = [ud boolForKey:kChatterGuideStatusStoreKey];
    if (!hadGuide) {
        [ud setBool:YES forKey:kChatterGuideStatusStoreKey];
        [ud synchronize];
        
        TTSessionGuideView *guideView = [[TTSessionGuideView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight)];
        @weakify(self);
        guideView.chatterbox = ^{
            @strongify(self);
            [self launchChatterboxGame];
        };
        [[UIApplication sharedApplication].keyWindow addSubview:guideView];
    } else {
        [self launchChatterboxGame];
    }
}

//话匣子的时候 先打个招呼
- (void)chatterBoxHello {
    NSString * str = [NSString stringWithFormat:@"%@_%@_%@", GetCore(AuthCore).getUid, self.session.sessionId,KTTChatterBoxIsSendGameMessageKey];
    BOOL isSend = [[NSUserDefaults standardUserDefaults] boolForKey:str];
    if (isSend) {
        return;
    }
    NIMMessage * message = [[NIMMessage alloc] init];
    XCChatterboxAttachment * chatterAtt = [[XCChatterboxAttachment alloc] init];
    chatterAtt.first = Custom_Noti_Header_PrivateChat_Chatterbox;
    chatterAtt.second = Custom_Noti_Sub_PrivateChat_Chatterbox_Init;
    TTChatterboxGameModel *launchGameModel = [[TTChatterboxGameModel alloc] init];
    NIMCustomObject * object = [[NIMCustomObject alloc] init];
    launchGameModel.isShow = NO;
    chatterAtt.data = [launchGameModel model2dictionary];
    object.attachment = chatterAtt;
    [message setValue:self.session forKey:@"session"];
    [message setValue:@(NIMMessageTypeCustom) forKey:@"messageType"];
    message.messageObject = object;
    message.from = [NSString stringWithFormat:@"%@", GetCore(AuthCore).getUid];
    [[NIMSDK sharedSDK].conversationManager saveMessage:message forSession:self.session completion:^(NSError * _Nullable error) {
        if (error== nil) {
            [self uiAddMessages:@[message]];
            NSString * str = [NSString stringWithFormat:@"%@_%@_%@", GetCore(AuthCore).getUid,self.session.sessionId, KTTChatterBoxIsSendGameMessageKey];
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:str];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
    }];
}

- (void)launchChatterboxGame {
    
    if (self.chatterBoxType) {
        return;
    }
    
    self.chatterBoxType = YES;
    
    [TTStatisticsService trackEvent:@"home_start_chatterbox" eventDescribe:@"首页-私聊-点击话匣子"];
    
    [[GetCore(CPGameCore) requestChatterboxGameLaunchLWithUid:GetCore(AuthCore).getUid.userIDValue uidTo:self.session.sessionId.userIDValue] subscribeNext:^(id x) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            self.chatterBoxType = NO;
        });
        if ([x[@"result"] boolValue]) {
            [GetCore(CPGameCore) requestChatterboxGameList];
        } else {
            [XCHUDTool showErrorWithMessage:x[@"reason"]];
        }
    } error:^(NSError *error) {
        self.chatterBoxType = NO;
        [XCHUDTool showErrorWithMessage:error.domain];
    }];
}

- (void)acquireChatterboxGameListArray:(NSArray *)listArray {
    
    NSDate* date = [NSDate dateWithTimeIntervalSinceNow:0];//获取当前时间0秒后的时间
    NSTimeInterval time = [date timeIntervalSince1970] * 1000;// * 1000 是精确到毫秒，不乘就是精确到秒
    NSString *timeString = [NSString stringWithFormat:@"%.0f", time];
    
    XCChatterboxAttachment * chatterAtt = [[XCChatterboxAttachment alloc] init];
    chatterAtt.first = Custom_Noti_Header_PrivateChat_Chatterbox;
    chatterAtt.second = Custom_Noti_Sub_PrivateChat_Chatterbox_launchGame;
    
    TTChatterboxGameModel *launchGameModel = [[TTChatterboxGameModel alloc] init];
    launchGameModel.listArray = listArray;
    launchGameModel.startTime = timeString.userIDValue;
    chatterAtt.data = [launchGameModel model2dictionary];
    
    [GetCore(ImMessageCore) sendCustomMessageAttachement:chatterAtt sessionId:self.session.sessionId type:NIMSessionTypeP2P];
    
    [GetCore(CPGameCore) requestChatterboxGameReportLWithUid:GetCore(AuthCore).getUid.userIDValue uidTo:self.session.sessionId.userIDValue withType:1];
}

/** 话匣子游戏 抛点数 */
- (void)chatterboxGamePointCount:(NIMMessage *)message {
    
    if (self.chatterboxGamePointHandler) {
        self.chatterboxGamePointHandler();
    }
    
    [GetCore(CPGameCore) requestChatterboxGameReportLWithUid:GetCore(AuthCore).getUid.userIDValue uidTo:self.session.sessionId.userIDValue withType:2];
    
    XCChatterboxPointAttachment * chatterAtt = [[XCChatterboxPointAttachment alloc] init];
    chatterAtt.first = Custom_Noti_Header_PrivateChat_Chatterbox;
    chatterAtt.second = Custom_Noti_Sub_PrivateChat_Chatterbox_throwPoint;
    
    NSArray *dataArray = @[@"1",@"2",@"3",@"4",@"5",@"6"];
    
    int x = arc4random() % dataArray.count;
    
    TTChatterboxGameModel *launchGameModel = [[TTChatterboxGameModel alloc] init];
    launchGameModel.pointCount = [[dataArray safeObjectAtIndex:x] intValue];
    chatterAtt.data = [launchGameModel model2dictionary];
    
    [GetCore(ImMessageCore) sendCustomMessageAttachement:chatterAtt sessionId:self.session.sessionId type:NIMSessionTypeP2P];
        //        [giftView initDisplayModel];
}

/// 点击发-红-包
- (void)onTapRed:(NIMMediaItem *)item {
}

- (void)onTapGame:(NIMMediaItem *)item {
    [XCHUDTool showGIFLoadingInView:self.view];
    
    UserID userID = [GetCore(AuthCore) getUid].userIDValue;
    UserInfo *userInfo = [GetCore(UserCore) getUserInfoInDB:userID];
    NSString *familyId = @(userInfo.familyId).stringValue;
    @KWeakify(self);
    [GetCore(FamilyCore)requestFamilyInfoByFamilyId:familyId success:^(XCFamily *familyInfo) {
        @KStrongify(self);
        [XCHUDTool hideHUDInView:self.view];
        
        if (familyInfo.openGame && familyInfo.openMoney) {
            UIViewController *vc = [[XCMediator sharedInstance] ttDiscoverMoudle_TTFamilyGroupGameViewController:userInfo.familyId];
            [self.navigationController pushViewController:vc animated:YES];
        } else {
            [XCHUDTool showErrorWithMessage:@"本家族的游戏或者家族币已被关闭，请联系管理员" inView:self.view];
            [self.sessionInputView refreshStatus:NIMInputStatusText];
            [self.sessionInputView.moreContainer removeFromSuperview];
            self.sessionInputView.moreContainer = nil;
        }
    }];
}

- (void)onTapDressUp:(NIMMediaItem *)item {
    UIViewController *vc = [[XCMediator sharedInstance] ttPersonalModule_DressUpShopViewControllerWithUid:self.session.sessionId.userIDValue index:0];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - NIMMessageCellDelegate
- (BOOL)onTapAvatar:(NIMMessage *)message {
    if (self.isRoomMessage) {
        return NO;
    }
    UIViewController *vc = [[XCMediator sharedInstance] ttPersonalModule_personalViewController:message.from.userIDValue];
    [self.navigationController pushViewController:vc animated:YES];
    return YES;
}

- (BOOL)onTapCell:(NIMKitEvent *)event {
    BOOL handled = [super onTapCell:event];
    NIMMessage *message = event.messageModel.message;
    NSString *eventName = event.eventName;
    if ([event.eventName isEqualToString:NIMKitEventNameTapContent]) {
        NSString *actionName = [self actionNameForMessageType:message.messageType];
        if (actionName) {
            SEL selector = NSSelectorFromString(actionName);
            if (selector && [self respondsToSelector:selector]) {
                NIMKit_SuppressPerformSelectorLeakWarning([self performSelector:selector withObject:message]);
                handled = YES;
            }
        }
        
    } else if ([event.eventName isEqualToString:XCNobleNotifyMessageViewClick]) {
        [self showNobleNotify:message];
    } else if([eventName isEqualToString:@"XCNewsNoticeContentMessageViewClick"] ||
              [eventName isEqualToString:@"XCOnRedPacketNoticClick"] ||
              [eventName isEqualToString:@"XCTurntableMessageViewClick"] ||
              [eventName isEqualToString:@"XCP2PInteractiveViewClick"] ||
              [eventName isEqualToString:@"XCUserUpgadeMessageViewClick"] ||
              [eventName isEqualToString:@"XCRedInteractiveViewClick"] ||
              [eventName isEqualToString:@"MessageCommonView"] ||
              [eventName isEqualToString:XCGuildMessageContentViewClick] ||
              [eventName isEqualToString:@"XCApplicationContentViewClick"] ||
              [eventName isEqualToString:@"XCMentoringInviteMessageContentViewClick"]||
              [eventName isEqualToString:@"XCApprenticeSecondFollowMessageContentViewClick"] ||
              [eventName isEqualToString:@"XCMasterFirstTaskMessageContentViewClick"] ||
              [eventName isEqualToString:XCCheckinNoticeMessageContentViewClick]||
              [eventName isEqualToString:@"XCGameVoiceMessageContentViewClick"]||
              [eventName isEqualToString:@"XCChatterboxGameHellocContentViewClick"] ||
              [eventName isEqualToString:@"XCLittleWorldAutoQuitMessageContentViewClick"] ||
              [eventName isEqualToString:@"XCLittleWorldPostDynamicSuccessContentViewClick"]) {
        NIMMessage *message = event.messageModel.message;
        [self showCustom:message];
    }
    return handled;
}

#pragma mark - TTSendGiftViewDelegate
//关闭
- (void)sendGiftViewDidClose:(TTSendGiftView *)sendGiftView {
    [TTPopup dismiss];
}

//充值
- (void)sendGiftViewDidClickRecharge:(TTSendGiftView *)sendGiftView type:(GiftConsumeType)type {
    [TTPopup dismiss];
    
    if (type == GiftConsumeTypeCarrot) {
        // 跳转去做任务。
        UIViewController *vc = [[XCMediator sharedInstance] ttDiscoverMoudle_TTMissionViewController];
        [self.navigationController pushViewController:vc animated:YES];
        return;
    }
    // 之前的是跳去充值
    UIViewController *rechargeVc = [[XCMediator sharedInstance] ttPersonalModule_rechargeController];
    [self.navigationController pushViewController:rechargeVc animated:YES];
    [TTStatisticsService trackEvent:TTStatisticsServiceEventGiftViewToRecharge eventDescribe:@"私聊"];
    
    // 首次充值资格
    if (sendGiftView.isFirstRecharge) {
        [TTStatisticsService trackEvent:@"room_gift_oneyuan_entrance" eventDescribe:@"私聊"];
    }
}

- (void)sendGiftView:(TTSendGiftView *)sendGiftView currentNobleLevel:(NSInteger)currentLevel needNobelLevel:(NSInteger)needLevel {
    
    [TTPopup dismiss];
    
    TTOpenNobleTipCardView *cardView = [[TTOpenNobleTipCardView alloc] initWithCurrentLevel:MatchNobleNameUsingID(@(currentLevel).stringValue) doAction:@"" needLevel:MatchNobleNameUsingID(@(needLevel).stringValue)];
    cardView.delegate = self;
    
    [TTPopup popupView:cardView style:TTPopupStyleAlert];
}

// 萝卜不足，去做任务
- (void)sendGiftView:(TTSendGiftView *)sendGiftView notEnoughtCarrot:(NSString *)errorMsg {
    
    [self ttShowCarrotBalanceNotEnougth];
}

/** 萝卜钱包余额不足 */
- (void)ttShowCarrotBalanceNotEnougth {
    [TTPopup dismiss];
    
    //防止多次萝卜不足弹窗
    static BOOL hasShowRadishAlert = NO;
    if (hasShowRadishAlert) {
        return;
    }
    
    hasShowRadishAlert = YES;
    
    TTAlertMessageAttributedConfig *attConfig = [[TTAlertMessageAttributedConfig alloc] init];
    attConfig.text = @"完成任务获取更多的萝卜";
    attConfig.color = XCThemeMainColor;

    TTAlertConfig *config = [[TTAlertConfig alloc] init];
    config.message = @"您的萝卜不足,请前往任务中心\n完成任务获取更多的萝卜";
    config.confirmButtonConfig.title = @"前往";
    config.messageAttributedConfig = @[attConfig];
    
    @weakify(self);
    [TTPopup alertWithConfig:config confirmHandler:^{
        
        @strongify(self);
        UIViewController *vc = [[XCMediator sharedInstance] ttDiscoverMoudle_TTMissionViewController];
        [self.navigationController pushViewController:vc animated:YES];
        
        hasShowRadishAlert = NO;
        
    } cancelHandler:^{
        hasShowRadishAlert = NO;
    }];
}

#pragma mark - TTOpenNobleTipCardViewDelegate
- (void)openNobleTipCardViewDidGotoOpenNoble:(TTOpenNobleTipCardView *)cardView {
    [TTPopup dismiss];
    
    TTWKWebViewViewController *vc = [[TTWKWebViewViewController alloc] init];
    vc.urlString = HtmlUrlKey(kNobilityIntroURL);
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)openNobleTipCardViewDidClose:(TTOpenNobleTipCardView *)cardView {
    [TTPopup dismiss];
}

#pragma mark - BalanceErrorClient
- (void)onBalanceNotEnough {
    [TTPopup dismiss];
    
    [self showBalanceNotEnougth];
}

#pragma mark - PraiseCoreClient
- (void)onPraiseSuccess:(UserID)uid{
    if (self.isViewLoaded && self.view.window) {
        [XCHUDTool showSuccessWithMessage:@"关注成功，相互关注可成为好友哦" inView:self.view];
    }
    self.isLike = YES;
    [self refreshSessionTitle:[self sessionTitle:_targetInfor.nick]];
    [self updateTableViewFrame:YES];
}

- (void)onCancelSuccess:(UserID)uid{
    self.isLike = NO;
    [self refreshSessionTitle:[self sessionTitle:_targetInfor.nick]];
    [self updateTableViewFrame:NO];
}

#pragma mark - GroupCoreClient
- (void)deleteGroupSuccessWithTeamId:(NSInteger)teamId sessionId:(NSInteger)sessionId{
    if (self.session.sessionId.userIDValue == sessionId) {
        if (self.session.sessionType == NIMSessionTypeTeam) {
            self.navigationItem.rightBarButtonItems = @[];
        }
    }
}

- (void)outGroupSuccessTeamId:(NSInteger)teamId sessionId:(NSInteger)sessionId{
    if (self.session.sessionId.userIDValue == sessionId) {
        if (self.session.sessionType == NIMSessionTypeTeam) {
            self.navigationItem.rightBarButtonItems = @[];
        }
    }
}

#pragma mark - Private Method
- (void)checkIsFocus:(NSString *)info {
    
    self.nick = info;
    
    @KWeakify(self);
    [GetCore(PraiseCore) isUid:GetCore(AuthCore).getUid.userIDValue isLikeUid:self.session.sessionId.userIDValue success:^(BOOL isLike) {
        @KStrongify(self);
        self.isLike = isLike;
        [self refreshSessionTitle:[self sessionTitle:info]];
    }];
}

#pragma mark - Anchor Order
/// 主播订单数据
- (void)requestAnchorOrderData {
    
    [GetCore(LittleWorldCore) requestAnchorOrderStatusWithUid:self.session.sessionId completion:^(AnchorOrderStatus * _Nonnull data, NSNumber * _Nonnull errorCode, NSString * _Nonnull msg) {
        
        if (errorCode) {
            return;
        }
        
        if (data.workOrder) {
            self.anchorOrderStrMaker = [[AnchorOrderAttributedStringMaker alloc] initWithOrder:data.workOrder];
            
            @weakify(self)
            [self.anchorOrderStrMaker updateHandler:^(NSAttributedString * _Nonnull string) {
                @strongify(self)
                self.anchorOrderAttributedString = string;
                [self refreshSessionSubTitle:nil];
            }];
        }
        
        if (data.tips) {
            [self sendAnchorOrderTips:data.tips];
        }
    }];
}

/// 主播订单提示自定义消息，只给自己看的本地消息
- (void)sendAnchorOrderTips:(NSString *)tips {
    
    if (tips == nil || tips.length == 0) {
        return;
    }
    
    NSString *cacheName = @"sendAnchorOrderTips";
    NSString *storeKey = @"storeKey";
    YYCache *cache = [YYCache cacheWithName:cacheName];
    NSArray *ids = (NSArray *)[cache objectForKey:storeKey];
    NSString *pairId = [NSString stringWithFormat:@"%@_%@", GetCore(AuthCore).getUid, self.session.sessionId];
    
    if ([ids containsObject:pairId]) {
        //已经发过提示，不用再发了
        return;
    }
    
    XCCPGamePrivateSysNotiAttachment *attach = [[XCCPGamePrivateSysNotiAttachment alloc] init];
    attach.first = Custom_Noti_Header_CPGAME_PrivateChat_SystemNotification;
    attach.second = Custom_Noti_Sub_CPGAME_PrivateChat_SysNoti_AnchorOrderTips;
    attach.data = @{@"msg": tips};
    
    NIMMessage *message = [[NIMMessage alloc] init];
    NIMCustomObject *customObject = [[NIMCustomObject alloc] init];
    customObject.attachment = attach;
    message.messageObject = customObject;
    
    [[NIMSDK sharedSDK].conversationManager saveMessage:message forSession:self.session completion:^(NSError * _Nullable error) {
        
        if (error== nil) {
            
            [self uiAddMessages:@[message]];
            
            //store
            NSMutableArray *arr = [NSMutableArray arrayWithArray:ids ?: @[]];
            [arr addObject:pairId];
            [cache setObject:arr.copy forKey:storeKey];
        }
    }];
}

#pragma mark - TTSelectGameViewDelegate
- (void)removeSelectGameView {
    self.removeSelect = YES;
    if (@available(iOS 11.0, *)) {
        self.tableView.contentInset = UIEdgeInsetsMake(self.topInset, 0, 0, 0);
    } else {
        self.tableView.contentInset = UIEdgeInsetsMake(self.topInset + kNavigationHeight, 0, 0, 0);
    }
}

- (void)btnClickLaunchGameWithModel:(CPGameListModel *)model {
}

- (void)onFriendChanged {
    if (self.isMatchMessage) {
        self.topInset = self.topInset == 30 ? 0 : 30;
        [self.gameView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.view.mas_top).offset(kNavigationHeight + self.topInset);
        }];
    }
}

- (void)initRoomMessageNavView {
    if (self.isRoomMessage) {
        [self.view addSubview:self.roomMessageNavView];
    }
}

- (void)configGroupStatus {
    if (self.session.sessionType != NIMSessionTypeTeam) {
        return;
    }
    
    BOOL isInTeam = [[NIMSDK sharedSDK].teamManager isMyTeam:self.session.sessionId];
    if (!isInTeam) {
        [XCHUDTool showErrorWithMessage:@"您已退出群聊" inView:self.view];
        return;
    }
    
    [self setupFamilyView];
    
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, 30, 30);
    [button setImage:[UIImage imageNamed:@"message_group_manager_icon"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(pushToGroupManager) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem * rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    rightBarButtonItem.tintColor = UIColorFromRGB(0x1a1a1a);
    self.navigationItem.rightBarButtonItem = rightBarButtonItem;
    
    UserID userID = [GetCore(AuthCore) getUid].userIDValue;
    NSString *familyId = [GetCore(UserCore) getUserInfoInDB:userID].family.familyId;
    [GetCore(FamilyCore) requestFamilyInfoByFamilyId:familyId success:^(XCFamily *familyInfo) {}];
    [GetCore(GroupCore) fetchGroupDetailByTeamId:self.session.sessionId.userIDValue];
}

- (void)setupFamilyView {
    if (self.isRoomMessage) {
        return;
    }
    [self.view addSubview:self.familyView];
}

- (void)initNavBar {
    EnvironmentType env = [HostUrlManager.shareInstance currentEnvironment];
    BOOL devMode = env == TestType || env == DevType;
    NSString *secretaryUid = keyWithType(KeyType_SecretaryUid, devMode);
    NSString *systemUid = keyWithType(KeyType_SystemNotifyUid, devMode);
      
    if ([self.session.sessionId isEqualToString:secretaryUid] ||
        [self.session.sessionId isEqualToString:systemUid]) {
        //小秘书和系统通知不能拉黑
        return;
    }
    
    if (self.session.sessionType == NIMSessionTypeP2P) {
        UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"message_session_nav_more"] style:UIBarButtonItemStylePlain target:self action:@selector(pushToBlackList)];
        rightBarButtonItem.tintColor = UIColorFromRGB(0x1a1a1a);
        self.navigationItem.rightBarButtonItem = rightBarButtonItem;
        self.navigationController.navigationBar.barTintColor = UIColor.whiteColor;
    }
}

- (void)initTitle {
    if (self.session.sessionType == NIMSessionTypeP2P) {
        @weakify(self);
        [[GetCore(UserCore) getUserInfoByRac:self.session.sessionId.userIDValue refresh:YES] subscribeNext:^(id x) {
            @strongify(self);
            if (x) {
                UserInfo *userInfo = (UserInfo *)x;
                self.targetInfor = userInfo;
                if (self.isRoomMessage) {
                    self.roomMessageNavView.titleLabel.text = userInfo.nick;
                }else{
                    [self checkIsFocus:userInfo.nick];
                }
            }
        }];
        
    }else{
        if (self.isRoomMessage) {
            NIMTeam *team = [[[NIMSDK sharedSDK] teamManager] teamById:self.session.sessionId];
            self.roomMessageNavView.titleLabel.attributedText = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@(%ld)",[team teamName],(long)[team memberNumber]]];
        }
    }
}

/// 获取映射方法名
- (nullable NSString *)actionNameForMessageType:(NIMMessageType)type {
    
    static NSDictionary *actions = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        actions = @{@(NIMMessageTypeImage) :    @"showImage:",
                    @(NIMMessageTypeVideo) :    @"showVideo:",
                    @(NIMMessageTypeLocation) : @"showLocation:",
                    @(NIMMessageTypeFile)  :    @"showFile:",
                    @(NIMMessageTypeCustom):    @"showCustom:"};
    });
    
    return actions[@(type)];
}

- (void)showBalanceNotEnougth {
    
    //防止多次充值弹窗
    static BOOL hasShowRechargeAlert = NO;
    if (hasShowRechargeAlert) {
        return;
    }
    
    hasShowRechargeAlert = YES;
    
    if (![[XCCurrentVCStackManager shareManager].getCurrentVC isKindOfClass:[self class]]) {
        return; // 如果不在当前控制器就不弹出
    }
    
    TTAlertConfig *config = [[TTAlertConfig alloc] init];
    config.title = @"余额不足";
    config.message = @"是否前往充值";
    
    @weakify(self)
    [TTPopup alertWithConfig:config confirmHandler:^{
        
        @strongify(self);
        UIViewController *vc = [[XCMediator sharedInstance] ttPersonalModule_rechargeController];
        [self.navigationController pushViewController:vc animated:YES];
        
        hasShowRechargeAlert = NO;
        
        [TTStatisticsService trackEvent:TTStatisticsServiceEventNotEnoughToRecharge eventDescribe:@"送礼物-私聊"];
    } cancelHandler:^{
        hasShowRechargeAlert = NO;
    }];
}

#pragma mark Custom Content View Show Handle
- (void)showNobleNotify:(NIMMessage *)message {
    NIMCustomObject *customObject = (NIMCustomObject*)message.messageObject;
    UserInfo *userInfo = [GetCore(UserCore)getUserInfoInDB:[GetCore(AuthCore) getUid].userIDValue];
    if ([customObject.attachment isKindOfClass:[NobleNotifyAttachment class]]) {
        NobleNotifyAttachment *info = (NobleNotifyAttachment *)customObject.attachment;
        if (info.first == Custom_Noti_Header_NobleNotify) {
            switch (info.second) {
                case Custom_Noti_Sub_NobleNotify_Almost_OutDate:
                {
                    TTWKWebViewViewController *webView = [[TTWKWebViewViewController alloc]init];
                    NSString *url = [NSString stringWithFormat:@"%@/%@?nobleid=%ld",[HostUrlManager shareInstance].hostUrl,HtmlUrlKey(kNobilityOpenNobleURL),(long)userInfo.nobleUsers.level];;
                    webView.url = [NSURL URLWithString:url];
                    [self.navigationController pushViewController:webView animated:YES];
                }
                    break;
                case Custom_Noti_Sub_NobleNotify_Already_OutDate:
                {
                    TTWKWebViewViewController *webView = [[TTWKWebViewViewController alloc]init];
                    webView.urlString = HtmlUrlKey(kNobilityIntroURL);
                    [self.navigationController pushViewController:webView animated:YES];
                }
                    break;
                case Custom_Noti_Sub_NobleNotify_GoodNum_NotOK:
                {
                    TTWKWebViewViewController *webView = [[TTWKWebViewViewController alloc]init];
                    webView.urlString = HtmlUrlKey(kNobilityGoodNumURL);
                    [self.navigationController pushViewController:webView animated:YES];
                }
                    break;
                default:
                    break;
            }
        }else if (info.first == Custom_Noti_Header_CarNotify) {
            if (info.second == Custom_Noti_Sub_Car_OutDate) {
                UIViewController * controller = [[XCMediator sharedInstance] ttPersonalModule_MyDressUpController:1];
                [self.navigationController pushViewController:controller animated:YES];
            }
        }
    }
}

- (void)showImage:(NIMMessage *)message {
    NIMImageObject *object = (NIMImageObject *)message.messageObject;
    XCImagePreViewController *vc = [[XCImagePreViewController alloc]init];
    vc.ImageUrl = [object url];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)showVideo:(NIMMessage *)message{
    NIMVideoObject *object = (NIMVideoObject *)message.messageObject;
    NIMSession *session = message.session;
    
    NTESVideoViewItem *item = [[NTESVideoViewItem alloc] init];
    item.path = object.path;
    item.url  = object.url;
    item.session = session;
    item.itemId  = object.message.messageId;
    
    NTESVideoViewController *playerViewController = [[NTESVideoViewController alloc] initWithVideoViewItem:item];
    [self.navigationController pushViewController:playerViewController animated:YES];
    if(![[NSFileManager defaultManager] fileExistsAtPath:object.coverPath]){
        //如果封面图下跪了，点进视频的时候再去下一把封面图
        __weak typeof(self) wself = self;
        [[NIMSDK sharedSDK].resourceManager download:object.coverUrl filepath:object.coverPath progress:nil completion:^(NSError *error) {
            if (!error) {
                [wself uiUpdateMessage:message];
            }
        }];
    }
}

- (void)showCustom:(NIMMessage *)message {
    
    NIMCustomObject *customObject = (NIMCustomObject*)message.messageObject;
    Attachment *att = (Attachment *)customObject.attachment;
    
    //普通的自定义消息点击事件可以在这里做哦~
    if ([customObject.attachment isKindOfClass:[XCNewsInfoAttachment class]]) {
        XCNewsInfoAttachment *info = (XCNewsInfoAttachment *)customObject.attachment;
        TTWKWebViewViewController *webView = [[TTWKWebViewViewController alloc]init];
        webView.url = [NSURL URLWithString:info.webUrl];
        [self.navigationController pushViewController:webView animated:YES];
        
    } else if ([customObject.attachment isKindOfClass:[XCRedPacketInfoAttachment class]]) {
        UIViewController * controller = [[XCMediator sharedInstance] ttDiscoverMoudle_TTInviteRewardsViewController];
        [self.navigationController pushViewController:controller animated:YES];
    } else if ([customObject.attachment isKindOfClass:[TurntableAttachment class]]) {
        TTWKWebViewViewController *webView = [[TTWKWebViewViewController alloc]init];
        webView.urlString = HtmlUrlKey(kTurntableURL);
        [self.navigationController pushViewController:webView animated:YES];
        
    } else if ([customObject.attachment isKindOfClass:[P2PInteractiveAttachment class]]) {
        P2PInteractiveAttachment *info = (P2PInteractiveAttachment *)customObject.attachment;
        [self handleUniversalEvent:info];
        
    } else if([customObject.attachment isKindOfClass:[XCApplicationSharement class]]){
        XCApplicationSharement *info = (XCApplicationSharement *)customObject.attachment;
        [self shareApplication:info];
        
    } else if([customObject.attachment isKindOfClass:[XCGuildAttachment class]]){
        [self guildTapHandle:(XCGuildAttachment *)customObject.attachment];
        
    } else if([customObject.attachment isKindOfClass:[XCCheckinNoticeAttachment class]]){
        UIViewController *vc = [[XCMediator sharedInstance] ttDiscoverMoudle_TTCheckinViewController];
        [self.navigationController pushViewController:vc animated:YES];
        
    }else if ([customObject.attachment isKindOfClass:[MessageBussiness class]]){
        MessageBussiness * messageBuss = (MessageBussiness *)customObject.attachment;
        if (messageBuss.first == Custom_Noti_Header_Message_Handle && messageBuss.second == Custom_Noti_Sub_Header_Message_Handle_Content) {
            if (messageBuss.routerType == P2PInteractive_SkipType_LittleWorldGuestPage) {
                UIViewController * worldVC = [[XCMediator sharedInstance] ttGameMoudle_TTWorldletContainerViewControllerWithWorldId:messageBuss.params.worldId isFromRoom:NO];
                [self.navigationController pushViewController:worldVC animated:YES];
            } else if (messageBuss.params.actionType == FamilyNotificationType_CreatSuccess) {
                UIViewController * family = [[XCMediator sharedInstance] ttDiscoverMoudle_TTFamilyPersonViewController:messageBuss.params.familyId.userIDValue];
                [self.navigationController pushViewController:family animated:YES];
            }
        } else if (messageBuss.first == Custom_Noti_Header_OfficialAnchorCertification) {//官方主播认证
            if (messageBuss.routerType == P2PInteractive_SkipType_H5 && messageBuss.routerValue) {
                TTWKWebViewViewController *vc = [[TTWKWebViewViewController alloc] init];
                vc.urlString = messageBuss.routerValue;
                [self.navigationController pushViewController:vc animated:YES];
            }
        }
        
    }else if ([customObject.attachment isKindOfClass:[XCUserUpgradeAttachment class]]){
        XCUserUpgradeAttachment *info = (XCUserUpgradeAttachment *)customObject.attachment;
        TTWKWebViewViewController *webView = [[TTWKWebViewViewController alloc]init];
        if (info.second == Custom_Noti_Sub_User_UpGrade_ExperLevelSeq) {
            webView.urlString = HtmlUrlKey(kLevelURL);
        }else{
            webView.urlString = HtmlUrlKey(kCharmURL);
        }
        [self.navigationController pushViewController:webView animated:YES];
    }else if ([customObject.attachment isKindOfClass:[XCMentoringShipAttachment class]]){
        XCUserUpgradeAttachment *info = (XCUserUpgradeAttachment *)customObject.attachment;
        if (self.isRoomMessage) {
            return;
        }
        if (info.first == Custom_Noti_Header_Mentoring_RelationShip) {
            UserID uid = 0;
            XCMentoringShipAttachment * mentoringAtttach = [XCMentoringShipAttachment modelDictionary:att.data];
            if (info.second == Custom_Noti_Header_Sub_Mentoring_RelationShip_Mission_Invite) {
                uid = mentoringAtttach.masterUid;
            }else if (info.second == Custom_Noti_Header_Sub_Mentoring_RelationShip_Mission_One_Master){
                uid = mentoringAtttach.apprenticeUid;
            }else if (info.second == Custom_Noti_Header_Sub_Mentoring_RelationShip_Mission_One_Apprentice){
                uid = mentoringAtttach.masterUid;
            }
            if (uid > 0) {
                UIViewController * controller = [[XCMediator sharedInstance] ttPersonalModule_personalViewController:uid];
                [self.navigationController pushViewController:controller animated:YES];
            }
        }
    }else if ([customObject.attachment isKindOfClass:[XCUserUpgradeAttachment class]]) {
        
        XCUserUpgradeAttachment *info = (XCUserUpgradeAttachment *)customObject.attachment;
        TTWKWebViewViewController *webView = [[TTWKWebViewViewController alloc]init];
        if (info.second == Custom_Noti_Sub_User_UpGrade_ExperLevelSeq) {
            webView.urlString = HtmlUrlKey(kLevelURL);
        } else {
            webView.urlString = HtmlUrlKey(kCharmURL);
        }
        [self.navigationController pushViewController:webView animated:YES];
        
    }else if([customObject.attachment isKindOfClass:[XCChatterboxAttachment class]]) {
        if (att.first == Custom_Noti_Header_PrivateChat_Chatterbox) {
            if (att.second == Custom_Noti_Sub_PrivateChat_Chatterbox_Init) {
                // 轻寻不要新手引导
                if (projectType() == ProjectType_CeEr) {
                    [self launchChatterboxGame];
                    return;
                }
                // 首次显示引导
                NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
                BOOL hadGuide = [ud boolForKey:kChatterGuideStatusStoreKey];
                if (!hadGuide) {
                    [ud setBool:YES forKey:kChatterGuideStatusStoreKey];
                    [ud synchronize];
                    
                    TTSessionGuideView *guideView = [[TTSessionGuideView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight)];
                    @weakify(self);
                    guideView.chatterbox = ^{
                        @strongify(self);
                        [self launchChatterboxGame];
                        [TTStatisticsService trackEvent:@"home_start_chatterbox" eventDescribe:@"首页-私聊-点击话匣子"];
                    };
                    [[UIApplication sharedApplication].keyWindow addSubview:guideView];
                } else {
                    [self launchChatterboxGame];
                }
            }
        }
    }else if([customObject.attachment isKindOfClass:[XCGameVoiceBottleAttachment class]]){
        if (att.first == Custom_Noti_Header_Game_VoiceBottle) {
            if (att.second == Custom_Noti_Sub_Voice_Bottle_Recording) {
                [TTStatisticsService trackEvent:@"my_sound" eventDescribe:@"系统消息"];
                UIViewController * controller =  [[XCMediator sharedInstance] ttGameMoudle_TTVoiceMyViewController];
                [self.navigationController pushViewController:controller animated:YES];
            }else if (att.second == Custom_Noti_Sub_Voice_Bottle_Matching) {
                UIViewController * controller =  [[XCMediator sharedInstance] ttGameMoudle_TTVoiceMatchingViewController];
                [self.navigationController pushViewController:controller animated:YES];
            }
        }
    }else if ([customObject.attachment isKindOfClass:[RedPacketDetailInfo class]] ||
              (att.first == Custom_Noti_Header_Group_RedPacket &&
               att.second == Custom_Noti_Sub_Header_Group_RedPacket_Send)) {
        
        if (![[NIMSDK sharedSDK].teamManager isMyTeam:self.session.sessionId]) {
            [XCHUDTool showErrorWithMessage:@"你已经不在群组里了噢" inView:self.view];
            return;
        }
        
        RedPacketDetailInfo *redInfo = [[RedPacketDetailInfo alloc]init];
        if (message.localExt) {
            redInfo = [RedPacketDetailInfo yy_modelWithJSON:message.localExt];
        } else {
            if ([customObject.attachment isKindOfClass:[RedPacketDetailInfo class]]) {
                redInfo = (RedPacketDetailInfo *)customObject.attachment;
            } else if ([customObject.attachment isKindOfClass:[Attachment class]]) {
                redInfo = [RedPacketDetailInfo yy_modelWithJSON:att.data];
            }
            message.localExt = [redInfo model2dictionary];
        }
        
        if (redInfo.status == RedPacketStatus_NotOpen) {
            
            TTRedColorAlertView *red = [[TTRedColorAlertView alloc] init];
            red.frame = CGRectMake(0, 0, 275, 333);
            red.navigationController = self.navigationController;
            red.message = message;
            [red setInfo:redInfo];
            
            [TTPopup popupView:red style:TTPopupStyleAlert];
            
        } else if (redInfo.status == RedPacketStatus_DidOpen ||
                   redInfo.status == RedPacketStatus_OutDate ||
                   redInfo.status == RedPacketStatus_OutBouns) {
            
            TTRedColorAlertView *red = [[TTRedColorAlertView alloc] init];
            red.frame = CGRectMake(0, 0, 275, 333);
            red.navigationController = self.navigationController;
            red.message = message;
            [red setInfo:redInfo];
            
            [TTPopup popupView:red style:TTPopupStyleAlert];
        }
    } else if ([customObject.attachment isKindOfClass:[XCLittleWorldAutoQuitAttachment class]]) {
        if (att.first == Custom_Noti_Header_Room_LittleWorldQuit) { // 自动离开小世界
            if (att.second == Custom_Noti_Sub_Room_LittleWorldQuit) {
                MessageParams *params = [MessageParams yy_modelWithJSON:att.data[@"params"]];
                UIViewController *vc = [[XCMediator sharedInstance] ttGameMoudle_TTWorldletContainerViewControllerWithWorldId:params.worldId isFromRoom:NO];
                [self.navigationController pushViewController:vc animated:YES];
            }
        }
    } else if ([customObject.attachment isKindOfClass:[XCDynamicPostSuccessAttachment class]]) {
        if (att.first == Custom_Noti_Header_Dynamic) { // 小世界动态
            if (att.second == Custom_Noti_Sub_Dynamic_ShareDynamic) { // 分享动态
                // 跳转动态详情
                UIViewController *vc = [[XCMediator sharedInstance] ttGameMoudle_TTDynamicDetailViewControllerWithWorldID:att.data[@"routerValue"] dynamicID:att.data[@"dynamicId"] comment:NO];
                [self.navigationController pushViewController:vc animated:YES];
            }
        }
    }
}

#pragma mark Share Handle
- (void)shareApplication:(XCApplicationSharement *)shareMent {
    switch (shareMent.routerType) {
        case P2PInteractive_SkipType_Room: {
            [[XCMediator sharedInstance] ttRoomMoudle_presentRoomViewControllerWithRoomUid:shareMent.routerValue.userIDValue];
        }
            break;
        case P2PInteractive_SkipType_Family: {//邀请加入家族
            XCFamily *family = [XCFamily yy_modelWithDictionary:shareMent.data[@"info"]];
            UIViewController *familyVC=  [[XCMediator sharedInstance] ttDiscoverMoudle_TTFamilyPersonViewController:[family.familyId integerValue]];
            [self.navigationController pushViewController:familyVC animated:YES];
        }
            break;
        case P2PInteractive_SkipType_Group: {//邀请加入 群组
            GroupModel *model = [GroupModel yy_modelWithDictionary:shareMent.data[@"info"]];
            UIViewController *familyVC= [[XCMediator  sharedInstance] ttDiscoverMoudle_TTFamilyPersonViewController:model.familyId];
            [self.navigationController pushViewController:familyVC animated:YES];
        }
            break;
        case P2PInteractive_SkipType_LittleWorldGuestPage: { // 跳转小世界客态页
            
            LittleWorldListItem *model = [LittleWorldListItem yy_modelWithDictionary:shareMent.data[@"info"]];
            
            UIViewController *worldVC = [[XCMediator  sharedInstance] ttGameMoudle_TTWorldletContainerViewControllerWithWorldId:model.worldId isFromRoom:NO];
            
            [self.navigationController pushViewController:worldVC animated:YES];
        }
            break;
        default:
            break;
    }
}

//刷新本地的缓存
- (void)onUpdateMessageFromOriginAndLocalSuccess:(NIMMessage *)message {
    if ([message.session.sessionId isEqualToString:self.session.sessionId]) {
        [self uiUpdateMessage:message];
    }
}

#pragma mark Universal Handle
- (void)handleUniversalEvent:(P2PInteractiveAttachment *)interactive {
    switch (interactive.routerType) {
        case P2PInteractive_SkipType_Room:{
            [[XCMediator sharedInstance] ttRoomMoudle_presentRoomViewControllerWithRoomUid:interactive.routerValue.userIDValue];
        }
            break;
        case P2PInteractive_SkipType_H5:{
            TTWKWebViewViewController *webview = [[TTWKWebViewViewController alloc] init];
            webview.url = [NSURL URLWithString:interactive.routerValue];
            [self.navigationController pushViewController:webview animated:YES];
        }
            break;
        case P2PInteractive_SkipType_Purse:{
            UIViewController *vc = [[XCMediator sharedInstance] ttPersonalModule_goldCoinController];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case P2PInteractive_SkipType_Red:{
            UIViewController *vc = [[XCMediator sharedInstance] ttPersonalModule_redDrawalsViewController];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case P2PInteractive_SkipType_Recharge:{
            UIViewController *vc = [[XCMediator sharedInstance] ttPersonalModule_rechargeController];
            [self.navigationController pushViewController:vc animated:YES];
            
            [TTStatisticsService trackEvent:TTStatisticsServiceEventGiftViewToRecharge eventDescribe:@"私聊"];
        }
            break;
        case P2PInteractive_SkipType_Person:{
            UIViewController*vc = [[XCMediator  sharedInstance] ttPersonalModule_personalViewController:interactive.routerValue.userIDValue];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case P2PInteractive_SkipType_Car:{
            if ([interactive.routerValue integerValue] == 0) {
                //商城- 座驾
                UIViewController *dressUpVc = [[XCMediator sharedInstance]ttPersonalModule_DressUpShopViewControllerWithUid:0 index:1];
                [self.navigationController pushViewController:dressUpVc animated:YES];
            } else {
                //我的装扮 - 座驾
                UIViewController *myDressVc = [[XCMediator sharedInstance] ttPersonalModule_MyDressUpController:1];
                [self.navigationController pushViewController:myDressVc animated:YES];
            }
        }
            break;
        case P2PInteractive_SkipType_Headwear:{
            if ([interactive.routerValue integerValue] == 0) {
                //商城-头饰
                UIViewController *headwearVC = [[XCMediator  sharedInstance]ttPersonalModule_DressUpShopViewControllerWithUid:0 index:0];
                [self.navigationController pushViewController:headwearVC animated:YES];
            } else {
                //我的装扮-头饰
                UIViewController *myDressUp = [[XCMediator sharedInstance] ttPersonalModule_MyDressUpController:0];
                [self.navigationController pushViewController:myDressUp animated:YES];
            }
        }
            break;
        case P2PInteractive_SkipType_Background:{
            if ([interactive.routerValue integerValue] == 0) {
                //商城-背景
                UIViewController *backgroundVC = [[XCMediator  sharedInstance]ttPersonalModule_DressUpShopViewControllerWithUid:0 index:2];
                [self.navigationController pushViewController:backgroundVC animated:YES];
            } else {
                //我的装扮-背景
                UIViewController *myDressUp = [[XCMediator sharedInstance] ttPersonalModule_MyDressUpController:2];
                [self.navigationController pushViewController:myDressUp animated:YES];
            }
        }
            break;
        case P2PInteractive_SkipType_Recommend: {
            UIViewController *vc = [[XCMediator sharedInstance] ttPersonalModule_openMyRecommendCardViewController];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case P2PInteractive_SkipType_Checkin: {
            UIViewController *vc = [[XCMediator sharedInstance] ttDiscoverMoudle_TTCheckinViewController];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case P2PInteractive_SkipType_Nameplate: {
            UIViewController *myDressVc = [[XCMediator sharedInstance] ttPersonalModule_MyDressUpController:2];
            [self.navigationController pushViewController:myDressVc animated:YES];
        }
            break;
        case P2PInteractive_SkipType_SecretaryJumpChat: {
            NSDictionary *dict = [NSString dictionaryWithJsonString:interactive.routerValue];
            UIViewController *myDressVc = [[XCMediator sharedInstance] ttMessageMoudle_TTSessionViewController:[dict[@"uid"] integerValue] sessectionType:NIMSessionTypeP2P];
            [self.navigationController pushViewController:myDressVc animated:YES];
        }
            break;
        default:
            break;
    }
}

#pragma mark Guild Tap Handle
/**
 公会类型点击处理
 
 @param attachment attachment
 */
- (void)guildTapHandle:(XCGuildAttachment *)attachment {
    if (![attachment isKindOfClass:XCGuildAttachment.class]) {
        return;
    }
    if (attachment.routerType == P2PInteractive_SkipType_Guild_Hall) {
        
        UserID uid = [GetCore(AuthCore) getUid].userIDValue;
        @KWeakify(self);
        [GetCore(UserCore) getUserInfo:uid refresh:YES success:^(UserInfo *info) {
            @KStrongify(self);
            
            if (info.hallId > 0) {
                //公会首页
                UIViewController *guild = [[XCMediator sharedInstance] ttPersonalModule_TTGuildViewController];
                [self.navigationController pushViewController:guild animated:YES];
            } else {
                [XCHUDTool showErrorWithMessage:@"该厅不存在" inView:self.view];
            }
            
        } failure:^(NSError *error) {
            @KStrongify(self);
            [XCHUDTool showErrorWithMessage:@"获取信息错误" inView:self.view];
        }];
    }
}

#pragma mark - Getter Setter
- (TTSessionFamilyView *)familyView {
    if (!_familyView) {
        _familyView = [[TTSessionFamilyView alloc] initWithFrame:CGRectMake(KScreenWidth - 95 - 15, statusbarHeight + 44 + 15, 95, 30)];
        _familyView.navigationController = self.navigationController;
    }
    return _familyView;
}

- (UIButton *)selectGameButton {
    if (!_selectGameButton) {
        _selectGameButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_selectGameButton setImage:[UIImage imageNamed:@"chat_game_overlays"] forState:UIControlStateNormal];
        [_selectGameButton addTarget:self action:@selector(selectGameAction:) forControlEvents:UIControlEventTouchUpInside];
        
        UIPanGestureRecognizer *panGes = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panAction:)];
        [_selectGameButton addGestureRecognizer:panGes];
    }
    return _selectGameButton;
}

- (void)panAction:(UIPanGestureRecognizer *)sender {
    CGPoint translationPoint = [sender translationInView:self.view];
    CGPoint center = sender.view.center;
    
    CGPoint newCenter;
    
    if (center.x + translationPoint.x < 65 / 2) {
        newCenter.x = 65 / 2;
    }else if (center.x + translationPoint.x > KScreenWidth - 65 / 2){
        newCenter.x = KScreenWidth - 65 / 2;
    }else{
        newCenter.x = center.x + translationPoint.x;
    }
    
    if (center.y + translationPoint.y < 65 / 2 + kNavigationHeight) {
        newCenter.y = 65 / 2 + kNavigationHeight;
    }else if (center.y + translationPoint.y > KScreenHeight - 65 / 2){
        newCenter.y = KScreenHeight - 65 / 2;
    }else{
        newCenter.y = center.y + translationPoint.y;
    }
    
    sender.view.center = newCenter;
    
    [sender setTranslation:CGPointZero inView:self.view];
}

- (TTCPGameListView *)listView{
    if (!_listView) {
        _listView = [[TTCPGameListView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight) WithListType:TTGameListPrivate];
        _listView.delegate = self;
        _listView.hidden = YES;
    }
    return _listView;
}

- (void)selectGameAction:(UIButton *)sender{
    [[BaiduMobStat defaultStat]logEvent:@"private_chat_game" eventLabel:@"点击游戏选择面板按钮"];
    [self.listView showListViewAndRefreshData];
}

- (void)clickItem:(CPGameListModel *)model{
    [self selectGameWithGameListDelegate:model];
    
}

- (void)updateUIWithMessage:(NIMMessage *)message{
    [self uiUpdateMessage:message];
}

- (TTRoomeMessageNavView *)roomMessageNavView{
    if (!_roomMessageNavView) {
        _roomMessageNavView = [[TTRoomeMessageNavView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, 49)];
        _roomMessageNavView.delegate = self;
    }
    return _roomMessageNavView;
}

- (TTSelectGameView *)gameView{
    if (!_gameView) {
        _gameView = [[TTSelectGameView alloc] init];
        _gameView.userUid = self.session.sessionId;
        _gameView.delegate = self;
    }
    return _gameView;
}

@end

