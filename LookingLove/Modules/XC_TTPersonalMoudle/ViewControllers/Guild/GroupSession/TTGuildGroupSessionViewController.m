//
//  TTGuildGroupSessionViewController.m
//  TuTu
//
//  Created by lvjunhang on 2019/1/11.
//  Copyright © 2019年 YiZhuan. All rights reserved.
//

#import "TTGuildGroupSessionViewController.h"

#import "TTWKWebViewViewController.h"
#import "TTGuildGroupCreateViewController.h"
#import "TTGuildGroupInfoViewController.h"

#import "TTSessionConfig.h"
#import "TTMessageAttributedString.h"

#import "XCMediator+TTPersonalMoudleBridge.h"
#import "XCMediator+TTDiscoverModuleBridge.h"
#import "XCMediator+TTRoomMoudleBridge.h"

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
#import "TTRoomeMessageNavView.h"

#import "XCImagePreViewController.h"
#import "TTSessionBlackListController.h"
#import "XCImagePreViewController.h"
#import "XCImagePreViewController.h"
#import "NTESVideoViewController.h"

//attachment
#import "NobleNotifyAttachment.h"
#import "P2PInteractiveAttachment.h"
#import "XCUserUpgradeAttachment.h"
#import "XCGiftAttachment.h"
#import "TurntableAttachment.h"
#import "XCRedPacketInfoAttachment.h"
#import "XCNewsInfoAttachment.h"
#import "RedPacketDetailInfo.h"

//core
#import "GroupCore.h"
#import "UserCore.h"
#import "AuthCore.h"
#import "FamilyCore.h"
#import "FamilyCoreClient.h"
#import "VersionCore.h"
#import "ImFriendCore.h"
#import "HostUrlManager.h"
#import "BalanceErrorClient.h"
#import "XCApplicationSharement.h"

#import "XCHUDTool.h"
#import "TTPopup.h"
#import "XCHtmlUrl.h"
#import "XCTheme.h"

#import <Masonry/Masonry.h>
#import <YYModel/YYModel.h>
#import <IQKeyboardManager/IQKeyboardManager.h>
#import "NIMGlobalMacro.h"
#import "NIMKitProgressHUD.h"

@interface TTGuildGroupSessionViewController ()
<
NIMMessageCellDelegate,
TTRoomeMessageNavViewDelegate
>

@property (nonatomic, strong) TTSessionConfig *sessionConfig;

/** 房间内的消息*/
@property (nonatomic, strong) TTRoomeMessageNavView * roomMessageNavView;
@end

@implementation TTGuildGroupSessionViewController

#pragma mark - Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self navigationStackRemoveController];
    [self configGroupStatus];
    [self initRoomMessageNavView];
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

- (void)dealloc {
    RemoveCoreClientAll(self);
}

#pragma mark - overriden
- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleDefault;
}

- (id<NIMSessionConfig>)sessionConfig {
    if (_sessionConfig == nil) {
        _sessionConfig = [[TTSessionConfig alloc] init];
        _sessionConfig.session = self.session;
        _sessionConfig.guildGroupType = YES;
    }
    return _sessionConfig;
}

#pragma mark - System Protocols
#pragma mark - Custom Protocols
#pragma mark - Core Protocols
#pragma mark - Event Responses
/// 群信息管理
- (void)pushToGroupInfo {
    TTGuildGroupInfoViewController *vc = [[TTGuildGroupInfoViewController alloc] init];
    vc.tid = self.session.sessionId;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - TTRoomeMessageNavViewDelegate
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

#pragma mark - NIMMessageCellDelegate
- (BOOL)onTapAvatar:(NIMMessage *)message {
    if (!self.isRoomMessage) {
        UIViewController *vc = [[XCMediator sharedInstance] ttPersonalModule_personalViewController:message.from.userIDValue];
        [self.navigationController pushViewController:vc animated:YES];
        return  YES;
    }
    return NO;
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
    } else if([eventName isEqualToString:@"XCNewsNoticeContentMessageViewClick"] ||
              [eventName isEqualToString:@"XCOnRedPacketNoticClick"] ||
              [eventName isEqualToString:@"XCTurntableMessageViewClick"] ||
              [eventName isEqualToString:@"XCP2PInteractiveViewClick"] ||
              [eventName isEqualToString:@"XCUserUpgadeMessageViewClick"] ||
              [eventName isEqualToString:@"XCRedInteractiveViewClick"] ||
              [eventName isEqualToString:@"MessageCommonView"] ||
              [eventName isEqualToString:@"XCApplicationContentViewClick"]) {
        NIMMessage *message = event.messageModel.message;
        [self showCustom:message];
    }
    return handled;
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
- (void)initRoomMessageNavView{
    if (self.isRoomMessage) {
        [self.view addSubview:self.roomMessageNavView];
        NIMTeam *team = [[[NIMSDK sharedSDK] teamManager] teamById:self.session.sessionId];
        self.roomMessageNavView.titleLabel.attributedText = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@(%ld)",[team teamName],(long)[team memberNumber]]];
    }
}

- (void)viewDidLayoutSubviews{
    if (self.isRoomMessage) {
        CGFloat height = 400;
        if (KScreenWidth > 320) {
            height = 530;
        }
        self.view.frame = CGRectMake(0, 0, KScreenWidth, height);
        self.tableView.frame = CGRectMake(0, 49, KScreenWidth, height -kSafeAreaBottomHeight - 49- 51);
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

- (void)configGroupStatus {
    if (self.session.sessionType != NIMSessionTypeTeam) {
        return;
    }
    
    BOOL isInTeam = [[NIMSDK sharedSDK].teamManager isMyTeam:self.session.sessionId];
    if (!isInTeam) {
        [XCHUDTool showErrorWithMessage:@"您已退出群聊" inView:self.view];
        return;
    }
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, 30, 30);
    [button setImage:[UIImage imageNamed:@"guild_session_nav_more"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(pushToGroupInfo) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    rightBarButtonItem.tintColor = UIColorFromRGB(0x1a1a1a);
    self.navigationItem.rightBarButtonItem = rightBarButtonItem;
}

/**
 从导航控制器栈中移除子控制器
 */
- (void)navigationStackRemoveController {
    NSMutableArray *viewControllers = [[NSMutableArray alloc] initWithArray:self.navigationController.viewControllers];
    for (UIViewController *vc in viewControllers) {
        if ([vc isKindOfClass:[TTGuildGroupCreateViewController class]]) {
            [viewControllers removeObject:vc];
            break;
        }
    }
    self.navigationController.viewControllers = viewControllers;
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
        
    } else if ([customObject.attachment isKindOfClass:[RedPacketDetailInfo class]] ||
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

#pragma mark - Getters and Setters
- (TTRoomeMessageNavView *)roomMessageNavView{
    if (!_roomMessageNavView) {
        _roomMessageNavView = [[TTRoomeMessageNavView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, 49)];
        _roomMessageNavView.delegate = self;
    }
    return _roomMessageNavView;
}
@end

