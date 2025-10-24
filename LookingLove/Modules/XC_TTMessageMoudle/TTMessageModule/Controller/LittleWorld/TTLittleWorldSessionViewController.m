//
//  TTLittleWorldSessionViewController.m
//  XC_TTMessageMoudle
//
//  Created by fengshuo on 2019/6/28.
//  Copyright © 2019 WJHD. All rights reserved.
//

#import "TTLittleWorldSessionViewController.h"
//第三方类
#import <Masonry/Masonry.h>
#import "UIView+NIM.h"
//XC_类
#import "XCMacros.h"
#import "XCHUDTool.h"
#import "NSMutableDictionary+Safe.h"
#import "XCHtmlUrl.h"
#import "XCCurrentVCStackManager.h"
#import "XCTheme.h"
#import "TTStatisticsService.h"

//XC_tt类
#import "TTPopup.h"
#import "TTRoomSettingsInputAlertView.h"
#import "TTUserCardContainerView.h"
#import "TTOpenNobleTipCardView.h"
//core
#import "RoomCoreV2.h"
#import "LittleWorldCore.h"
#import "ImMessageCore.h"
#import "AuthCore.h"
#import "UserCore.h"
#import "LittleWorldCoreClient.h"
#import "ImRoomCoreClient.h"
#import "XCNewsInfoAttachment.h"
#import "XCRedPacketInfoAttachment.h"
#import "P2PInteractiveAttachment.h"
#import "XCApplicationSharement.h"
#import "MessageBussiness.h"
#import "XCUserUpgradeAttachment.h"
#import "TurntableAttachment.h"
#import "RedPacketDetailInfo.h"
#import "GroupModel.h"
#import "BalanceErrorClient.h"
//view
#import "TTLittleWorldTopicView.h"
#import "TTLittleWorldPartyListView.h"
#import "TTRoomeMessageNavView.h"
#import "TTRedColorAlertView.h"
#import "TTLittleWorldSessionGuideView.h"
//VC
#import "TTLittleWorldEditTopicViewController.h"
#import "XCImagePreViewController.h"
#import "NTESVideoViewController.h"
#import "TTWKWebViewViewController.h"
//tool
#import "TTPublicChatUserCardFunctionItemConfig.h"
//NIM
#import "NIMMessageMaker.h"
#import "NIMKitInfoFetchOption.h"
#import "NIMKit.h"
#import "NIMSessionConfigurator.h"
#import "TTSessionConfig.h"
#import "NIMKitProgressHUD.h"
//bridge
#import "XCMediator+TTMessageMoudleBridge.h"
#import "XCMediator+TTDiscoverModuleBridge.h"
#import "XCMediator+TTPersonalMoudleBridge.h"
#import "XCMediator+TTRoomMoudleBridge.h"

@interface TTLittleWorldSessionViewController ()
<
TTLittleWorldTopicViewDelegate,
TTLittleWorldInputViewDelegate,
NIMInputActionDelegate,
LittleWorldCoreClient,
ImRoomCoreClient,
TTRoomeMessageNavViewDelegate,
TTOpenNobleTipCardViewDelegate,
TTLittleWorldPartyListViewDelegate,
BalanceErrorClient
>

/** 派对*/
@property (nonatomic,strong) UIButton *partyButton;
/** 编辑话题*/
@property (nonatomic,strong) TTLittleWorldTopicView *topicView;

/** */
@property (nonatomic,strong) LittleWorldTeamModel *teamModel;
/** 配置*/
@property (nonatomic,strong) TTSessionConfig *sessionConfig;
/** 导航栏*/
@property (nonatomic,strong) TTRoomeMessageNavView *roomMessageNavView;

/** 头部的话题的*/
@property (nonatomic,assign) TTLittleWorldTopicViewType topicType;
@end

@implementation TTLittleWorldSessionViewController

- (void)dealloc {
    RemoveCoreClientAll(self);
     [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self addCore];
    [self initView];
    [self initContrations];
    [self setupNavigationItem];
    
    [self configGroupStatus];
    
    if (projectType() != ProjectType_LookingLove || projectType() != ProjectType_Planet) {
        [self loadGuideViewIfNeed];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (self.isRoomMessage) {
        [self.navigationController setNavigationBarHidden:YES animated:animated];
    }else{
        [self.navigationController setNavigationBarHidden:NO animated:animated];
    }
    
    [self.navigationController.navigationBar.subviews enumerateObjectsUsingBlock:^(UIView *view, NSUInteger idx, BOOL *stop) {
        if ([[UIDevice currentDevice].systemVersion doubleValue] >= 10.0) {
            //iOS10,改变了导航栏的私有接口为_UIBarBackground
            if ([view isKindOfClass:NSClassFromString(@"_UIBarBackground")]) {
                [view.subviews firstObject].hidden = YES;
            }
        } else {
            //iOS10之前使用的是_UINavigationBarBackground
            if ([view isKindOfClass:NSClassFromString(@"_UINavigationBarBackground")]) {
                
                [view.subviews firstObject].hidden = NO;
            }
        }
    }];
       [NIMKitProgressHUD dismiss];
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
        self.tableView.frame = CGRectMake(0, 49, KScreenWidth, height -kSafeAreaBottomHeight - 49- 51);
    }
}

#pragma mark - overriden
- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleDefault;
}

- (id<NIMSessionConfig>)sessionConfig {
    if (_sessionConfig == nil) {
        _sessionConfig = [[TTSessionConfig alloc] init];
        _sessionConfig.session = self.session;
    }
    return _sessionConfig;
}

#pragma mark - NIMMessageCellDelegate
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
    } else if([eventName isEqualToString:@"XCNewsNoticeContentMessageViewClick"] ||
              [eventName isEqualToString:@"XCOnRedPacketNoticClick"] ||
              [eventName isEqualToString:@"XCTurntableMessageViewClick"] ||
              [eventName isEqualToString:@"XCP2PInteractiveViewClick"] ||
              [eventName isEqualToString:@"XCUserUpgadeMessageViewClick"] ||
              [eventName isEqualToString:@"XCRedInteractiveViewClick"] ||
              [eventName isEqualToString:@"MessageCommonView"] ||
              [eventName isEqualToString:@"XCApplicationContentViewClick"]||
              [eventName isEqualToString:@"XCLittleWorldMessageContentViewClick"]) {
        NIMMessage *message = event.messageModel.message;
        [self showCustom:message];
    }
    return handled;
}

- (BOOL)onTapAvatar:(NIMMessage *)message {
   
    NSMutableArray * bottomOpeArray = [TTPublicChatUserCardFunctionItemConfig getFunctionItemsInPublicChatRoomWithUid:message.from.userIDValue];
    [XCHUDTool showGIFLoadingInView:self.view];
    @KWeakify(self);
    [[TTPublicChatUserCardFunctionItemConfig getCenterFunctionItemsInLittleWorldTeamWithUid:message.from.userIDValue vc:self]subscribeNext:^(id x) {
        
        @KStrongify(self);
        [XCHUDTool hideHUDInView:self.view];
        
        NSMutableArray * functionArray = x;
        
        CGFloat height = [TTUserCardContainerView getTTUserCardContainerViewHeightWithFunctionArray:functionArray bottomOpeArray:bottomOpeArray];
        TTUserCardContainerView *view = [[TTUserCardContainerView alloc]initWithFrame:CGRectMake(0, 0, 314, height) uid:message.from.userIDValue];
        view.itemBlock = ^(UserID uid) {
            if (uid > 0) {
                UIViewController * controller = [[XCMediator sharedInstance] ttMessageMoudle_TTSessionViewController:uid sessectionType:NIMSessionTypeP2P];
                [self.navigationController pushViewController:controller animated:YES];
            }
        };
        [view setTTUserCardContainerViewHeightWithFunctionArray:functionArray bottomOpeArray:bottomOpeArray];
        
        [TTPopup popupView:view style:TTPopupStyleAlert];
    }];
    
    return YES;
}
- (BOOL)onTapGame:(NIMMessage *)message {
    return NO;
}

- (BOOL)onTapSendGift:(NIMMessage *)message {
    return NO;
}

- (BOOL)onTapDressUp:(NIMMessage *)message {
    return NO;
}

#pragma mark - Private Methods
/// 设置导航栏
- (void)setupNavigationItem {
    
    UIButton *moreButton = [UIButton buttonWithType:UIButtonTypeCustom];
    moreButton.frame = CGRectMake(0, 0, 44, 44);
    [moreButton setImage:[UIImage imageNamed:@"guild_memberList_rightItem_more"] forState:UIControlStateNormal];
    [moreButton addTarget:self action:@selector(onClickNavivationMoreButton:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:moreButton];
}

- (void)initRoomMessageNavView {
    if (self.isRoomMessage) {
        [self.view addSubview:self.roomMessageNavView];
        NIMTeam *team = [[[NIMSDK sharedSDK] teamManager] teamById:self.session.sessionId];
        self.roomMessageNavView.titleLabel.attributedText = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@(%ld)",[team teamName],(long)[team memberNumber]]];
    }
}

- (void)addCore {
    AddCoreClient(LittleWorldCoreClient, self);
    AddCoreClient(ImRoomCoreClient, self);
    AddCoreClient(BalanceErrorClient, self);
}

- (void)initView {
    [self setupConfigurator:NO childVC:self];
    [self checkLittleWorldTeamDetail];
    
    //话题编辑
    [self.view addSubview:self.topicView];
    if (!self.isRoomMessage) {
        //创建pary
        [self.view addSubview:self.partyButton];
    }
    [self initRoomMessageNavView];
}

- (void)initContrations {
    if (!self.isRoomMessage) {
        [self.partyButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.mas_equalTo(65);
            make.right.mas_equalTo(self.view).offset(-7);
            make.bottom.mas_equalTo(self.view).offset(-kSafeAreaBottomHeight-30);
        }];
    }
}

- (void)setupInputView {
    if ([self shouldShowInputView]) {
        self.publicChatInputView = [[TTLittleWorldInputView alloc] initWithFrame:CGRectMake(0, KScreenHeight - kSafeAreaBottomHeight - 51, self.view.nim_width,0)];
        self.publicChatInputView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
        [self.publicChatInputView setSession:self.session];
        [self.publicChatInputView setInputDelegate:self];
        [self.publicChatInputView setInputActionDelegate:self];
        [self.publicChatInputView refreshStatus:TTLittleWorldInputStatusText];
        [self.view addSubview:_publicChatInputView];
    }
}

- (void)reloadLittleWorldTopicViewWithNumberPerosn:(int)number topic:(NSString *)topic attarchSecond:(Custom_Noti_Sub_Little_World)second {
    [NIMKitProgressHUD dismiss];
    if (second == Custom_Noti_Sub_Little_World_Group_Topic) {
        self.teamModel.topic = topic;
    }else if (second == Custom_Noti_Sub_Little_World_Member_Count) {
        self.teamModel.count = number;
    }
    BOOL isCreate = NO;
    if (GetCore(AuthCore).getUid.userIDValue == self.teamModel.uid) {
        isCreate = YES;
    }
    
    if (self.topicType) {
        
        if (![self.topicView superview]) {
            [self.view addSubview:self.topicView];
        }
        if (self.topicType == TTLittleWorldTopicViewType_Topic) {
            if (second == Custom_Noti_Sub_Little_World_Member_Count) {
                if (self.isRoomMessage) {
                    self.topicType = TTLittleWorldTopicViewType_Topic;
                }else {
                    self.topicType = TTLittleWorldTopicViewType_OnLineAndTopic;
                }
                
                self.tableView.contentInset = UIEdgeInsetsMake(self.tableView.contentInset.top + 40, 0, 0, 0);
                if (self.isRoomMessage) {
                    self.topicView.frame = CGRectMake(0,49, KScreenWidth,90);
                }else {
                    self.topicView.frame = CGRectMake(0, statusbarHeight + 44, KScreenWidth, 130);
                }
                
            }
        }else if (self.topicType == TTLittleWorldTopicViewType_OnLineAndTopic) {
            if (second == Custom_Noti_Sub_Little_World_Member_Count && number == 0) {
                //如果是房间 的话 不展示在线人数
                self.topicType = TTLittleWorldTopicViewType_Topic;
                self.tableView.contentInset = UIEdgeInsetsMake(self.tableView.contentInset.top - 40, 0, 0, 0);
                if (self.isRoomMessage) {
                    self.topicView.frame = CGRectMake(0,49, KScreenWidth,90);
                }else {
                    self.topicView.frame = CGRectMake(0, statusbarHeight + 44, KScreenWidth, 90);
                }
            }
        }
        [self.topicView updateTTLittleWorldTopicViewFrameWithType:self.topicType teamPartyModel:self.teamModel isCreateEr:isCreate];
    }
}

/**
 加载新人引导
 */
- (void)loadGuideViewIfNeed {
    
    NSString *storeKey = @"littleWorldSessionGuideStoreKey";
    
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    BOOL hadGuide = [ud boolForKey:storeKey];
    if (hadGuide) {
        return;
    }
    
    //Setting First Guide
    [ud setBool:YES forKey:storeKey];
    [ud synchronize];
    
    TTLittleWorldSessionGuideView *guideView = [[TTLittleWorldSessionGuideView alloc] init];
    [self.tabBarController.view addSubview:guideView];
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

- (void)configGroupStatus {
    
    if (self.session.sessionType != NIMSessionTypeTeam) {
        return;
    }
    
    BOOL isInTeam = [[NIMSDK sharedSDK].teamManager isMyTeam:self.session.sessionId];
    if (!isInTeam) {
        [XCHUDTool showErrorWithMessage:@"您已退出群聊" inView:self.view];
        if (!self.isRoomMessage) {
            self.partyButton.hidden = YES;
        }
        return;
    }
}

- (void)showImage:(NIMMessage *)message {
    NIMImageObject *object = (NIMImageObject *)message.messageObject;
    XCImagePreViewController *vc = [[XCImagePreViewController alloc]init];
    vc.ImageUrl = [object url];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)showVideo:(NIMMessage *)message {
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
        
    }else if ([customObject.attachment isKindOfClass:[MessageBussiness class]]){
        MessageBussiness * messageBuss = (MessageBussiness *)customObject.attachment;
        if (messageBuss.first == Custom_Noti_Header_Message_Handle && messageBuss.second == Custom_Noti_Sub_Header_Message_Handle_Content) {
            if (messageBuss.params.actionType == FamilyNotificationType_CreatSuccess) {
                UIViewController * family = [[XCMediator sharedInstance] ttDiscoverMoudle_TTFamilyPersonViewController:messageBuss.params.familyId.userIDValue];
                [self.navigationController pushViewController:family animated:YES];
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
    }else if ([customObject.attachment isKindOfClass:[XCUserUpgradeAttachment class]]) {
        
        XCUserUpgradeAttachment *info = (XCUserUpgradeAttachment *)customObject.attachment;
        TTWKWebViewViewController *webView = [[TTWKWebViewViewController alloc]init];
        if (info.second == Custom_Noti_Sub_User_UpGrade_ExperLevelSeq) {
            webView.urlString = HtmlUrlKey(kLevelURL);
        } else {
            webView.urlString = HtmlUrlKey(kCharmURL);
        }
        [self.navigationController pushViewController:webView animated:YES];
        
    }else if ([customObject.attachment isKindOfClass:[XCLittleWorldAttachment class]]) {
        XCLittleWorldAttachment *info = [XCLittleWorldAttachment yy_modelWithJSON:att.data];;
        UserID roomUid = info.roomUid;
        if (roomUid) {
            [[XCMediator sharedInstance] ttRoomMoudle_presentRoomViewControllerWithRoomUid:roomUid];
        }
        // 仅仅用于统计
        [GetCore(LittleWorldCore) reportWorldMemberoActiveType:4 reportUid:GetCore(AuthCore).getUid.userIDValue worldId:self.teamModel.worldId];
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
                       
                       TTPopupService *service = [[TTPopupService alloc] init];
                       service.contentView = red;
                       [TTPopup popupWithConfig:service];
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
            UIViewController *familyVC =  [[XCMediator sharedInstance] ttDiscoverMoudle_TTFamilyPersonViewController:[family.familyId integerValue]];
            [self.navigationController pushViewController:familyVC animated:YES];
        }
            break;
        case P2PInteractive_SkipType_Group: {//邀请加入 群组
            GroupModel *model = [GroupModel yy_modelWithDictionary:shareMent.data[@"info"]];
            UIViewController *familyVC= [[XCMediator  sharedInstance] ttDiscoverMoudle_TTFamilyPersonViewController:model.familyId];
            [self.navigationController pushViewController:familyVC animated:YES];
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
        default:
            break;
    }
}

#pragma mark - TTRoomeMessageNavViewDelegate
- (void)backButtonClick:(UIButton *)sender {
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

#pragma mark - TTLittleWorldTopicViewDelegate
//查看群聊中的派对
- (void)ttLittleWorldTopicViewCheckNumberPerson:(TTLittleWorldTopicView *)view {
    if (self.publicChatInputView.toolBar.showsKeyboard) {
        self.publicChatInputView.toolBar.showsKeyboard = NO;
    }
    TTLittleWorldPartyListView * partyView =  [[TTLittleWorldPartyListView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, 514)];
    partyView.worldId = self.teamModel.worldId;
    partyView.delegate = self;
    [TTPopup popupView:partyView style:TTPopupStyleActionSheet];
}
//关闭查看群聊中的派对
- (void)ttLittleWorldTopicView:(TTLittleWorldTopicView *)view closeNumberPerson:(UIButton *)sender {
    TTLittleWorldTopicViewType type = TTLittleWorldTopicViewType_Topic;
    BOOL isCreate = NO;
    if (self.teamModel.uid == GetCore(AuthCore).getUid.userIDValue) {
        isCreate = YES;
    }
    NSLog(@"%f",self.tableView.contentInset.top);
    view.frame = CGRectMake(0, statusbarHeight + 44, KScreenWidth, 90);
     [view updateTTLittleWorldTopicViewFrameWithType:type teamPartyModel:self.teamModel isCreateEr:isCreate];
    self.tableView.contentInset = UIEdgeInsetsMake(self.tableView.contentInset.top - 40, 0, 0, 0);
   
}
//管理者编辑话题
- (void)ttLittleWorldTopicView:(TTLittleWorldTopicView *)view managerEditTopicAction:(UIButton *)sender {
    [TTStatisticsService trackEvent:@"world-page-editing-topics" eventDescribe:@"世界客态页-群聊-编辑话题"];
    TTLittleWorldEditTopicViewController * VC = [[TTLittleWorldEditTopicViewController alloc] init];
    VC.chatId = self.teamModel.chatId;
    [self.navigationController pushViewController:VC animated:YES];
}

#pragma mark - TTSendGiftViewDelegate
- (void)sendGiftViewDidClickReport:(TTSendGiftView *)sendGiftView {
    [TTPopup dismiss];
    TTWKWebViewViewController *vc = [[TTWKWebViewViewController alloc]init];
    NSString *urlstr = [NSString stringWithFormat:@"%@?reportUid=%lld",HtmlUrlKey(kReportURL),sendGiftView.targetInfo.uid];
    vc.urlString = urlstr;
    [[[XCCurrentVCStackManager shareManager]currentNavigationController]pushViewController:vc animated:YES];
}

- (void)sendGiftView:(TTSendGiftView *)sendGiftView currentNobleLevel:(NSInteger)currentLevel needNobelLevel:(NSInteger)needLevel {
    
    [TTPopup dismiss];
    
    TTOpenNobleTipCardView *view = [[TTOpenNobleTipCardView alloc]initWithCurrentLevel:MatchNobleNameUsingID(@(currentLevel).stringValue) doAction:@"" needLevel:MatchNobleNameUsingID(@(needLevel).stringValue)];
    view.delegate = self;
    [TTPopup popupView:view style:TTPopupStyleAlert];
}

- (void)sendGiftViewDidClickRecharge:(TTSendGiftView *)sendGiftView type:(GiftConsumeType)type {
    
    [TTPopup dismiss];
    
    if (type == GiftConsumeTypeCarrot) {
        // 跳转去做任务。
        UIViewController *vc = [[XCMediator sharedInstance] ttDiscoverMoudle_TTMissionViewController];
        [self.navigationController pushViewController:vc animated:YES];
        return;
    }
    
    // 之前的是跳去充值
    UIViewController *vc = [[XCMediator sharedInstance] ttPersonalModule_rechargeController];
    [self.navigationController pushViewController:vc animated:YES];
    
    // 首次充值资格
    if (sendGiftView.isFirstRecharge) {
        [TTStatisticsService trackEvent:@"room_gift_oneyuan_entrance" eventDescribe:@"群聊"];
    }
}

// 萝卜不足，去做任务
- (void)sendGiftView:(TTSendGiftView *)sendGiftView notEnoughtCarrot:(NSString *)errorMsg {
    // 跳转去任务
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
    attConfig.color = [XCTheme getTTMainColor];
    
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

- (void)sendGiftViewDidClose:(TTSendGiftView *)sendGiftView {
    [TTPopup dismiss];
}

- (void)sendGiftView:(TTSendGiftView *)sendGiftView showUserInfoCardWithUid:(UserID)userid {
    [TTPopup dismiss];
    
    NSMutableArray * bottomOpeArray = [TTPublicChatUserCardFunctionItemConfig getFunctionItemsInPublicChatRoomWithUid:userid];
    [XCHUDTool showGIFLoadingInView:self.view];
    @KWeakify(self);
    [[TTPublicChatUserCardFunctionItemConfig getCenterFunctionItemsInLittleWorldTeamWithUid:userid vc:self]subscribeNext:^(id x) {
        @KStrongify(self);
        [XCHUDTool hideHUDInView:self.view];
        
        NSMutableArray * functionArray = x;
        
        CGFloat height = [TTUserCardContainerView getTTUserCardContainerViewHeightWithFunctionArray:functionArray bottomOpeArray:bottomOpeArray];
        
        TTUserCardContainerView *view = [[TTUserCardContainerView alloc]initWithFrame:CGRectMake(0, 0, 314, height) uid:userid];
        view.itemBlock = ^(UserID uid) {
            if (uid > 0) {
                UIViewController * controller = [[XCMediator sharedInstance] ttMessageMoudle_TTSessionViewController:uid sessectionType:NIMSessionTypeP2P];
                [self.navigationController pushViewController:controller animated:YES];
            }
        };
        [view setTTUserCardContainerViewHeightWithFunctionArray:functionArray bottomOpeArray:bottomOpeArray];
        
        [TTPopup popupView:view style:TTPopupStyleAlert];
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

#pragma mark - TTLittleWorldInputViewDelegate
- (void)onSendText:(NSString *)text atUsers:(NSArray *)atUsers {
    text = [text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    text = [text stringByReplacingOccurrencesOfString:@"\r" withString:@""];
    text = [text stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    if (text.length <= 0) {
        [XCHUDTool showErrorWithMessage:@"不能发送空白消息" inView:self.view];
        return;
    }
    NSMutableArray *users = [NSMutableArray arrayWithArray:atUsers];
    if (self.session.sessionType == NIMSessionTypeP2P)
    {
        [users addObject:self.session.sessionId];
    }
    NSString *robotsToSend = [self robotsToSend:users];
    
    NIMMessage *message = nil;
    if (robotsToSend.length)
    {
        message = [NIMMessageMaker msgWithRobotQuery:text toRobot:robotsToSend];
    }
    else
    {
        message = [NIMMessageMaker msgWithText:text];
    }
    
    if(self.session.sessionType == NIMSessionTypeTeam) {
        NIMTeam *team = [[NIMSDK sharedSDK].teamManager teamById:self.session.sessionId];
        NSMutableDictionary *aps = [NSMutableDictionary dictionary];
        NSMutableDictionary *alert = [NSMutableDictionary dictionary];
        [alert safeSetObject:team.teamName forKey:@"title"];
        [alert safeSetObject:[NSString stringWithFormat:@"%@:%@",[GetCore(UserCore)getUserInfoInDB:[GetCore(AuthCore)getUid].userIDValue].nick,message.text] forKey:@"body"];
        [aps safeSetObject:alert forKey:@"alert"];
        NSDictionary *dic = @{@"alert":[alert copy]};
        message.apnsPayload = @{@"apsField":dic};
    }
    
    [GetCore(ImMessageCore) antiSpam:message.text withMessage:message];
    
    if (message.antiSpamOption.hitClientAntispam) {
         [XCHUDTool showErrorWithMessage:@"发送失败，官方提醒你文明用语" inView:self.view];
        return;
    }
    
    if (atUsers.count) {
        NIMMessageApnsMemberOption *apnsOption = [[NIMMessageApnsMemberOption alloc] init];
        apnsOption.userIds = atUsers;
        apnsOption.forcePush = YES;
        
        NIMKitInfoFetchOption *option = [[NIMKitInfoFetchOption alloc] init];
        option.session = self.session;
        
        NSString *me = [[NIMKit sharedKit].provider infoByUser:[NIMSDK sharedSDK].loginManager.currentAccount option:option].showName;
        apnsOption.apnsContent = [NSString stringWithFormat:@"%@在群里@了你",me];
        message.apnsMemberOption = apnsOption;
    }
    [self sendMessage:message];
    
    [self.publicChatInputView cleanMessage];
    
    // 首次发言统计每天一次
    [GetCore(LittleWorldCore) reportWorldMemberoActiveType:1 reportUid:GetCore(AuthCore).getUid.userIDValue worldId:self.teamModel.worldId];
}

- (NSString *)robotsToSend:(NSArray *)atUsers {
    for (NSString *userId in atUsers) {
        if ([[NIMSDK sharedSDK].robotManager isValidRobot:userId]) {
            return userId;
        }
    }
    return nil;
}

- (void)didChangeInputHeight:(CGFloat)inputHeight {
    [self.interactor changeLayout:inputHeight];
    if (!self.isRoomMessage) {
        [UIView animateWithDuration:0.1 animations:^{
            [self.partyButton mas_updateConstraints:^(MASConstraintMaker *make) {
                make.bottom.mas_equalTo(self.view).offset(-kSafeAreaTopHeight-inputHeight -14);
            }];
        }];
    }
}

- (void)didClickInputViewPhoto {
     [self.interactor mediaPicturePressed];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    [_publicChatInputView endEditing:YES];
}

#pragma mark - TTLittleWorldPartyListViewDelegate
- (void)reloadNumberPersonWhenRequestListEmpty {
    if (self.teamModel && self.teamModel.count > 0) {
      [self reloadLittleWorldTopicViewWithNumberPerosn:0 topic:@"" attarchSecond:Custom_Noti_Sub_Little_World_Member_Count];
    }
}

- (void)ttLittleWorldPartyListView:(TTLittleWorldPartyListView *)listView didClickEnterRoomWithHasParty:(BOOL)hasParty {
    if (hasParty) {
        [TTPopup dismiss];
        [[XCMediator sharedInstance] ttRoomMoudle_presentRoomViewControllerWithRoomUid:GetCore(AuthCore).getUid.userIDValue];
    }else {
        
        // 创建语音派对统计小世界用户活跃
        [GetCore(LittleWorldCore) reportWorldMemberoActiveType:3 reportUid:GetCore(AuthCore).getUid.userIDValue worldId:self.teamModel.worldId];
        
        [TTPopup dismiss];
        [TTStatisticsService trackEvent:@"world-page-create-party" eventDescribe:@"世界客态页-群聊-创建语音派对"];
        [[GetCore(RoomCoreV2) requestRoomInfo:GetCore(AuthCore).getUid.userIDValue] subscribeNext:^(id x) {
            RoomInfo * info = (RoomInfo *)x;
            UserInfo * infor = [GetCore(UserCore) getUserInfoInDB:GetCore(AuthCore).getUid.userIDValue];
            
            NSString *title = info.title ? info.title : [NSString stringWithFormat:@"%@的房间",infor.nick];
            TTRoomSettingsInputAlertView *alert = [[TTRoomSettingsInputAlertView alloc] init];
            alert.title = @"修改派对名称";
            alert.content = title;
            alert.maxCount = 16;
            GetCore(LittleWorldCore).isLittleWorldInput = YES;
            [alert showAlertWithCompletion:^(NSString * _Nonnull content) {
                if (content) {
                    GetCore(LittleWorldCore).roomTitle = content;
                }else {
                    GetCore(LittleWorldCore).roomTitle = title;
                }
                [TTStatisticsService trackEvent:@"world-page-modify-party-name" eventDescribe:@"世界客态页-群聊-修改派对名称"];
                [[XCMediator sharedInstance] ttRoomMoudle_presentRoomViewControllerWithType:3 worldId:listView.worldId];
            } dismiss:^{
            }];
        } error:^(NSError *error) {
            if ([error isKindOfClass:[CoreError class]]) {
                
                // 青少年模式开启后
                CoreError *coreError = (CoreError *) error;
                // 当 code = 30000 的时候才进行显示弹窗
                if (coreError.resCode == 30000) {
                    [[XCMediator sharedInstance] ttRoomMoudle_presentRoomViewControllerWithType:3 worldId:listView.worldId];
                }
            }
        }];
        
    }
}

#pragma mark - httpCoreClient
- (void)requsetLittleWorldTeamDetailSuccess:(LittleWorldTeamModel *)model {
    self.teamModel = model;
    //是群主的话
    TTLittleWorldTopicViewType type;
    CGFloat offx;
    BOOL isCreate = NO;
    //有在线人数和 话题
    if (model.count > 0) {
        offx = 130;
        type = TTLittleWorldTopicViewType_OnLineAndTopic;
    }else {
        //只有话题
        type = TTLittleWorldTopicViewType_Topic;
        offx = 90;
    }
    if (GetCore(AuthCore).getUid.userIDValue == model.uid) {
        isCreate = YES;
    }

    if (self.isRoomMessage) {
        offx = 90;
         self.topicView.frame = CGRectMake(0, 49, KScreenWidth, offx);
        type = TTLittleWorldTopicViewType_Topic;
    }else {
       self.topicView.frame = CGRectMake(0, statusbarHeight + 44, KScreenWidth, offx);
    }
   self.topicType = type;
    
     [self.topicView updateTTLittleWorldTopicViewFrameWithType:type teamPartyModel:model isCreateEr:isCreate];
    [self.topicView layoutIfNeeded];
    self.tableView.contentInset = UIEdgeInsetsMake(self.tableView.contentInset.top + offx, 0, 0, 0);
    self.topicView.hidden = NO;
    
    // 仅用于小世界统计
    GetCore(LittleWorldCore).reportWorldID = model.worldId;
}

- (void)requsetLittleWorldTeamDetailFail:(NSString *)message {
    self.topicView.hidden = YES;
    [self.topicView removeFromSuperview];
}

- (void)updateLittleWorldTeamNameOrTopicFail:(NSString *)message {
    [XCHUDTool showErrorWithMessage:message inView:self.view];
}



- (void)onReceiveTeamNotificationUpdateTopicOrNumbePersonWithAttach:(XCLittleWorldAttachment *)attach second:(Custom_Noti_Sub_Little_World)second {
    [self reloadLittleWorldTopicViewWithNumberPerosn:attach.count topic:attach.topic attarchSecond:second];
}


- (void)creatLittleWorldTeamPartySuccess:(NSString *)warn {
    [self checkLittleWorldTeamDetail];
    if (warn && warn.length > 0) {
        [XCHUDTool showSuccessWithMessage:warn inView:[UIApplication sharedApplication].delegate.window delay:2 enabled:YES];
    }
}

//进房成功 上报服务器 创建群聊派对
- (void)onMeInterChatRoomSuccess {
    if (GetCore(LittleWorldCore).worldId && GetCore(RoomCoreV2).getCurrentRoomInfo.type != RoomType_CP) {
        BOOL ownerFlag = GetCore(AuthCore).getUid.userIDValue == self.teamModel.uid;
        [GetCore(LittleWorldCore) createLittleWorldTeamPartyWithWorldId:self.teamModel.worldId tid:[NSString stringWithFormat:@"%lld", self.teamModel.tid] ownerFlag:ownerFlag];
    }
}

//自己最小化房间 进房
- (void)onMeInterChatSameRoomSuccess {
    if (GetCore(LittleWorldCore).worldId && GetCore(RoomCoreV2).getCurrentRoomInfo.type != RoomType_CP) {
        BOOL ownerFlag = GetCore(AuthCore).getUid.userIDValue == self.teamModel.uid;
        [GetCore(LittleWorldCore) createLittleWorldTeamPartyWithWorldId:self.teamModel.worldId tid:[NSString stringWithFormat:@"%lld", self.teamModel.tid] ownerFlag:ownerFlag];
    }
}

#pragma mark - BalanceErrorClient

- (void)onBalanceNotEnough {
    [TTPopup dismiss];
    
    //防止多次充值弹窗
    static BOOL hasShowRechargeAlert = NO;
    if (hasShowRechargeAlert) {
        return;
    }
    
    hasShowRechargeAlert = YES;
    
    TTAlertConfig *config = [[TTAlertConfig alloc] init];
    config.title = @"余额不足";
    config.message = @"余额不足，是否前往充值";
    
    @weakify(self)
    [TTPopup alertWithConfig:config confirmHandler:^{
        
        @strongify(self)
        UIViewController *vc = [[XCMediator sharedInstance]ttPersonalModule_rechargeController];
        [self.navigationController pushViewController:vc animated:YES];
        
        [TTStatisticsService trackEvent:TTStatisticsServiceEventNotEnoughToRecharge eventDescribe:@"送礼物-公聊大厅"];
        hasShowRechargeAlert = NO;
        
    } cancelHandler:^{
        hasShowRechargeAlert = NO;
    }];
}

#pragma mark - LittleWorldCoreClient
- (void)responseWorldGroupQuitSuccess:(BOOL)success code:(NSNumber *)errorCode msg:(NSString *)msg {
    
    if (success) {
        [XCHUDTool showSuccessWithMessage:@"已退出群聊"];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.6 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.navigationController popViewControllerAnimated:YES];
        });
        
        NSString *des = [NSString stringWithFormat:@"退出群聊"];
        [TTStatisticsService trackEvent:@"world_leave_group_chat" eventDescribe:des];
        return;
    }
    
    [XCHUDTool showErrorWithMessage:msg];
}

#pragma mark - http
- (void)checkLittleWorldTeamDetail {
    [GetCore(LittleWorldCore) requsetLittleWorldTeamDetailWithTid:self.session.sessionId.userIDValue];
}

#pragma mark - Actions
- (void)partyButtonDidClick:(UIButton *)sender {
    if (self.publicChatInputView.toolBar.showsKeyboard) {
        self.publicChatInputView.toolBar.showsKeyboard = NO;
    }
    TTLittleWorldPartyListView * view =  [[TTLittleWorldPartyListView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, 514)];
    view.worldId = self.teamModel.worldId;
    view.delegate = self;
    [TTPopup popupView:view style:TTPopupStyleActionSheet];
    
}

//编辑群名字
- (void)onClickNavivationEditButton:(UIButton *)sender {
    TTRoomSettingsInputAlertView *alert = [[TTRoomSettingsInputAlertView alloc] init];
    alert.title = @"群名称";
    alert.placeholder = @"请输入群名称";
    NIMTeam *team = [[NIMSDK sharedSDK].teamManager teamById:self.session.sessionId];
    alert.content = team.teamName;
    alert.maxCount = 16;
    @weakify(self)
    [alert showAlertWithCompletion:^(NSString * _Nonnull content) {
        @strongify(self)
        
        [GetCore(LittleWorldCore) updteLittleWorldTeamNameOrTopicWithTeamName:content topic:nil chatId:self.teamModel.chatId];
    } dismiss:^{
    }];
}

//导航栏更多按钮
- (void)onClickNavivationMoreButton:(UIButton *)sender {
    
    //键盘收起
    if (self.publicChatInputView.toolBar.showsKeyboard) {
        self.publicChatInputView.toolBar.showsKeyboard = NO;
    }

    @weakify(self)
    [GetCore(LittleWorldCore) requestWorldDetailWithWorldId:@(self.teamModel.worldId).stringValue uid:GetCore(AuthCore).getUid.userIDValue completion:^(LittleWorldListItem * _Nonnull data, NSNumber * _Nonnull errorCode, NSString * _Nonnull msg) {
        
        @strongify(self)
        BOOL mute = data.currentMember.promtFlag == 0;//是否开启免打扰
        NSString *muteStr = [NSString stringWithFormat:@"%@消息免打扰", mute ? @"关闭" : @"开启"];
        TTActionSheetConfig *muteItem = [TTActionSheetConfig actionWithTitle:muteStr
                                                                   color:[XCTheme getTTMainTextColor]
                                                                 handler:^{
            if (mute) {
                //开启消息免打扰
                [TTStatisticsService trackEvent:@"world-page-no-message" eventDescribe:@"世界客态页-开启消息免打扰"];
                [[GetCore(LittleWorldCore) requestWorldLetChatMuteWithChatId:self.teamModel.chatId uid:GetCore(AuthCore).getUid.userIDValue ope:YES] subscribeError:^(NSError *error) {
                    [XCHUDTool showErrorWithMessage:error.domain];
                } completed:^{
                    [XCHUDTool showSuccessWithMessage:@"设置成功"];
                }];
                
            } else {
                //关闭消息免打扰
                [[GetCore(LittleWorldCore) requestWorldLetChatMuteWithChatId:self.teamModel.chatId uid:GetCore(AuthCore).getUid.userIDValue ope:NO] subscribeError:^(NSError *error) {
                    [XCHUDTool showErrorWithMessage:error.domain];
                } completed:^{
                    [XCHUDTool showSuccessWithMessage:@"设置成功"];
                }];
            }
        }];
        
        TTActionSheetConfig *quit = [TTActionSheetConfig actionWithTitle:@"退出群聊"
                                                                   color:[XCTheme getTTMainTextColor]
                                                                 handler:^{
            
            [TTPopup alertWithMessage:@"退出群聊就不能和朋友们谈天说地了，确定退出吗?" confirmHandler:^{
                NSString *chatId = nil;
                [GetCore(LittleWorldCore) requestWorldGroupQuitWithChatId:chatId sessionId:self.session.sessionId];
            } cancelHandler:^{
            }];
        }];
        
        NIMTeam *team = [[NIMSDK sharedSDK].teamManager teamById:self.session.sessionId];
        BOOL owner = [team.owner isEqualToString:GetCore(AuthCore).getUid];

        TTActionSheetConfig *edit = [TTActionSheetConfig actionWithTitle:@"修改群名"
                                                                   color:[XCTheme getTTMainTextColor]
                                                                 handler:^{
            TTRoomSettingsInputAlertView *alert = [[TTRoomSettingsInputAlertView alloc] init];
            alert.title = @"群名称";
            alert.placeholder = @"请输入群名称";
            alert.content = team.teamName;
            alert.maxCount = 16;
            @weakify(self)
            [alert showAlertWithCompletion:^(NSString * _Nonnull content) {
                @strongify(self)
                
                [GetCore(LittleWorldCore) updteLittleWorldTeamNameOrTopicWithTeamName:content topic:nil chatId:self.teamModel.chatId];
            } dismiss:^{
            }];
        }];
        
        [TTPopup actionSheetWithItems:@[muteItem, (owner ? edit : quit)]];
    }];
}

#pragma mark - setters and getters
- (UIButton *)partyButton {
    if (!_partyButton) {
        _partyButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_partyButton setImage:[UIImage imageNamed:@"littleworld_open_party"] forState:UIControlStateNormal];
        [_partyButton setImage:[UIImage imageNamed:@"littleworld_open_party"] forState:UIControlStateSelected];
        [_partyButton addTarget:self action:@selector(partyButtonDidClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _partyButton;
}

- (TTLittleWorldTopicView *)topicView {
    if (!_topicView) {
        _topicView = [[TTLittleWorldTopicView alloc] initWithFrame:CGRectMake(0, statusbarHeight + 44, KScreenWidth, 0)];
        _topicView.delegate = self;
    }
    return _topicView;
}

- (TTRoomeMessageNavView *)roomMessageNavView {
    if (!_roomMessageNavView) {
        _roomMessageNavView = [[TTRoomeMessageNavView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, 49)];
        _roomMessageNavView.delegate = self;
    }
    return _roomMessageNavView;
}

@end
