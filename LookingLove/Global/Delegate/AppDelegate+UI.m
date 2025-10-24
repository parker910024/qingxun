//
//  AppDelegate+UI.m
//  TuTu
//
//  Created by Mac on 2018/10/29.
//  Copyright © 2018年 YiZhuan. All rights reserved.
//

#import "AppDelegate+UI.h"

#import "BaseNavigationController.h"
#import "XCCurrentVCStackManager.h"
#import "TTGameRoomContainerController.h"

#import "VersionCore.h"
#import "RedInfo.h"
#import "AuthCore.h"
#import "ImMessageCore.h"
#import "XCGuildAttachment.h"
#import "CPGameCore.h"
#import "ImLoginCore.h"
#import "TTGameStaticTypeCore.h"
#import "RoomInfo.h"
#import "UIView+XCToast.h"
#import "RoomCoreV2.h"
#import "RoomQueueCoreV2.h"
#import "ImRoomCoreV2.h"
#import "AuthCore.h"
#import "MentoringShipCore.h"
#import "ArrangeMicCore.h"
#import "MeetingCore.h"
#import "FaceCore.h"
#import "TTGameStaticTypeCore.h"
#import "MentoringShipCore.h"

#import "TTCPGameView.h"
#import "TTRoomModuleCenter.h"

#import "XCMediator+TTRoomMoudleBridge.h"
#import "XCMediator+TTDiscoverModuleBridge.h"
#import "XCMediator+TTMessageMoudleBridge.h"

#import "WMAdvertiseView.h"
#import "WMAdImageTool.h"

#import "TTAppEvaluate.h"
#import "AppScoreClient.h"
#import "TTWKWebViewViewController.h"

//t
#import "TTBoradcastManager.h"
#import "TTChannalGiftManager.h"
#import "TTTopAlertViewTool.h"
#import "UIView+XCToast.h"

#import "TTGuildGroupManageConst.h"
#import "TTStatisticsService.h"
#import "XCOpenBoxManager.h"

#import "TTLaunchGuideView.h"
#import "RouterSkipCenter.h"

@implementation AppDelegate (UI)

- (void)setAppMainUI{
    
    self.tabBarController = [[BaseTabBarViewController alloc] init];
    
    //floatView
    [XCFloatView shareFloatView].hidden = YES;
    [XCFloatView shareFloatView].delegate = self;
    [self.tabBarController.view addSubview:[XCFloatView shareFloatView]];
    
    [[TTAppEvaluate mainCenter] ttaddAppReview:SCORE_NEWRED_ACCOUNTNAME];
    
    // 初始化 window
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [self.window makeKeyAndVisible];
    [self.window setRootViewController:self.tabBarController];
}

#pragma mark - XCFloatViewDelegate
/** 点击悬浮球的回调 */
- (void)floatViewDidClick:(XCFloatView *)floatView roomInfo:(RoomInfo *)roomInfo {
    [[XCMediator sharedInstance] ttRoomMoudle_maxRoomViewController:[roomInfo model2dictionary]];
}

/** 关闭按钮点击的回调 */
- (void)floatView:(XCFloatView *)floatView didClickCloseButton:(UIButton *)btn {
    [TTStatisticsService trackEvent:TTStatisticsServiceEventRoomMinimizeClosed eventDescribe:@"房间最小化关闭按钮"];
    [[XCMediator sharedInstance] ttRoomMoudle_closeRoomViewController];
}

#pragma mark - ImRoomCoreClientV2
- (void)onMeExitChatRoomSuccessV2 {
    ///最小化按钮点关闭房间，退房成功回调后，停止自动砸蛋
    [[XCOpenBoxManager shareManager] stopAutoOpenBox];
    [[XCOpenBoxManager shareManager] stopAutoOpenDiamondBox];
}

#pragma mark - ActivityCoreClient
- (void)onReceiveP2PRedPacket:(RedInfo *)info {
    
}

#pragma mark - VersionCoreClient
- (void)onRequestVersionStatusSuccess:(VersionInfo *)versionInfo {

}

/**
 强制更新
 */
- (void)appNeedUpdateWithDesc:(NSString *)desc version:(NSString *)version {
    [[TTTopAlertViewTool shareTTTopAlertViewTool] ttShowUpdateViewWithDesc:desc version:version];
}

- (void)appNeedForceUpdateWithDesc:(NSString *)desc version:(NSString *)version {
    [[TTTopAlertViewTool shareTTTopAlertViewTool] ttShowForceUpdateViewWithDesc:desc version:version];
}

#pragma mark - NobleCoreClient
- (void)onReceiveNobleBoardcast:(NobleBroadcastInfo *)nobleinfo {
#ifdef DEBUG
    
#else
    if ([NSString stringWithFormat:@"%lld",nobleinfo.uid].length < 6) {
        return;
    }
    
#endif
    NSString *subStr;
    if (nobleinfo.type == NobleBroadcastType_Open) {
        subStr = @"开通";
    }else if (nobleinfo.type == NobleBroadcastType_Renew) {
        subStr = @"续费";
    }else {
        subStr = @"";
    }
    NSString *nobleName = [NSString stringWithFormat:@"\"%@\"",nobleinfo.nobleInfo.name];
    NSMutableString *resultStr = [NSMutableString stringWithFormat:@"恭喜%@%@%@贵族",nobleinfo.nick,subStr,nobleName];
    if (nobleinfo.roomErbanNo.length > 0 && ![nobleinfo.roomErbanNo isEqual:[NSNull null]]) {
        [resultStr appendString:[NSString stringWithFormat:@",快来房间%@%@膜拜",nobleinfo.roomErbanNo,nobleinfo.roomTitle]];
    }else{
        [resultStr appendString:@",速来膜拜"];
    }
    CGSize contentSize = [self sizeWithText:resultStr font:[UIFont systemFontOfSize:14] maxSize:CGSizeMake(MAXFLOAT, 30)];
    [[TTBoradcastManager shareManager] showBoradCast:[[NSMutableAttributedString alloc] initWithString:resultStr] width:contentSize.width];
}

#pragma mark - GiftCoreClient

- (void)onReceiveGiftChannelNotify:(GiftChannelNotifyInfo *)giftChannelInfo{
#ifdef DEBUG
    NSLog(@"%@",giftChannelInfo);
#else
    
    if (([NSString stringWithFormat:@"%lld",giftChannelInfo.sendUserUid].length < 6 && [NSString stringWithFormat:@"%lld",giftChannelInfo.recvUserUid].length < 6)) {
        return;
    }
    
#endif
    // 全服礼物, 只在房间和公聊大厅时, 才展示
    if (!GetCore(TTGameStaticTypeCore).giftSwitch) {
        return;
    }

    [[TTChannalGiftManager shareManager] showGiftBoradCast:giftChannelInfo];
}

- (void)onReceiveNamePlateChannelNotify:(NSArray *)namePlateChannelInfoArray {
    // 全服铭牌, 只在房间时, 才展示
    if ([[[XCCurrentVCStackManager shareManager] getCurrentVC] isKindOfClass:TTGameRoomContainerController.class]) {
        [[TTChannalGiftManager shareManager] showNamePlate:namePlateChannelInfoArray];
    }
    
}

/// 全服年度通知
- (void)onReceiveAnnualBroadcastNotify:(AnnualBroadcastNotifyInfo *)info {
    [[TTChannalGiftManager shareManager] showAnnualBroadcast:info jumpHandler:^{
        
        [[RouterSkipCenter shareInstance] handleRouterType:info.routerType value:info.routerValue];
    }];
}

#pragma mark - HttpErrorClient
- (void)networkDisconnect {
    dispatch_main_sync_safe(^{
        [UIView hideToastView];
        if (self.errorCount < 2) {
            self.errorCount++;
            dispatch_main_sync_safe(^{
                
                [[TTTopAlertViewTool shareTTTopAlertViewTool] ttShowBadNetworkAlertView];
            });
        }
    });
}

#pragma mark - public method

- (void)setupLaunchADView {
    // 判断沙盒中是否存在广告图片，如果存在，直接显示
    NSString *imageName = [kUserDefaults valueForKey:adImageName];
    NSString *filePath = [WMAdImageTool getFilePathWithImageName:imageName];
    BOOL isExist = [WMAdImageTool isFileExistWithFilePath:filePath];
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    
    //这里是操作首次安装前五次启动不显示闪屏的逻辑，不知道谁的代码，吐槽
    if ([userDefault integerForKey:@"adShow"]) {
        [userDefault setInteger:[userDefault integerForKey:@"adShow"]+1 forKey:@"adShow"];
    } else {
        [userDefault setInteger:1 forKey:@"adShow"];
    }
    
    if (isExist) {// 图片存在
        
        if ([userDefault integerForKey:@"adShow"] > 4) {
            @weakify(self);
            AdInfo *info = [[AdCache shareCache] getAdInfoFromCacheInMainWith:imageName];
            
            WMAdvertiseView *advertiseView = [[WMAdvertiseView alloc] initWithFrame:self.window.bounds];
            advertiseView.filePath = filePath;
            advertiseView.dismissHandler = ^(BOOL shouldJump) {
                @strongify(self)
                if (!shouldJump || info == nil) {
                    //新人引导
                    [self showLaunchGuideView];
                    return;
                }
                
                //闪屏跳转处理
                if ([GetCore(ImLoginCore) isImLogin]) {
                    [self advertiseJumpHandleWithInfo:info];
                } else {
                    [self performSelector:@selector(advertiseJumpHandleWithInfo:) withObject:info afterDelay:2.0];
                }
                
                //新人引导
                [self showLaunchGuideView];
            };
            [advertiseView show];
        }
    } else {
        [self showLaunchGuideView];
    }
}

#pragma mark - Private Methods
/**
 显示新人引导页面
 */
- (void)showLaunchGuideView {
    
    NSMutableArray *imageArray = [NSMutableArray array];
    for (int index = 0; index < 3; index++) {
        
        NSMutableString *name = [NSMutableString stringWithFormat:@"launch_guide_%d", index];
        if (iPhoneXSeries) {
            [name appendString:@"_x"];
        }
        
        [imageArray addObject:name];
    }
    
    TTLaunchGuideView *launchGuide = [[TTLaunchGuideView alloc] initWithImages:imageArray.copy];
    launchGuide.wholeFinalPageInteractionEnabled = YES;
    launchGuide.hidenEnterButton = YES;
    launchGuide.hidenPageControl = YES;
    launchGuide.openDebugMode = NO;
    [launchGuide showWithCompletion:nil];
}

/// 闪屏广告跳转处理
- (void)advertiseJumpHandleWithInfo:(AdInfo *)info {
    if (![GetCore(ImLoginCore) isImLogin]) {
        return; // 必须登录后才可以跳转
    }
    
    if (UIApplication.sharedApplication.keyWindow != self.window) {
        //当前窗口不是主控制器所在窗口时，拦截跳转（目前可能情况时，闪屏后出现新人引导
        return;
    }
    
    switch (info.type) {
        case SplashInfoSkipTypeRoom: {
            // 跳转房间
            [[XCMediator sharedInstance]ttRoomMoudle_presentRoomViewControllerWithRoomUid:info.link.userIDValue];
        }
            break;
        case SplashInfoSkipTypeWeb: {
            // 跳转 H5
            TTWKWebViewViewController *webView = [[TTWKWebViewViewController alloc]init];
            webView.url = [NSURL URLWithString:info.link];
            [[[XCCurrentVCStackManager shareManager]currentNavigationController] pushViewController:webView animated:YES];
        }
            break;
        default:
            break;
    }
}

- (CGSize)sizeWithText:(NSString *)text font:(UIFont *)font maxSize:(CGSize)maxSize{
    NSDictionary *attrs = @{NSFontAttributeName : font};
    return [[NSString stringWithFormat:@"全服通知:%@",text] boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
}

//检查更新公会入厅状态
- (void)checkUpdateGuildHallJoinStatus:(NIMMessage *)msg {
    if ([msg.messageObject isKindOfClass:NIMCustomObject.class]) {
        NIMCustomObject *object = (NIMCustomObject *)msg.messageObject;
        if ([object.attachment isKindOfClass:XCGuildAttachment.class]) {
            XCGuildAttachment *attach = (XCGuildAttachment *)object.attachment;
            if (attach.second == Custom_Noti_Sub_HALL_BECOME_CHIEF ||
                attach.second == Custom_Noti_Sub_HALL_NOTICE) {
                
                //当用户的公会入厅状态发生改变时，发出通知
                [[NSNotificationCenter defaultCenter] postNotificationName:TTGuildGroupManageMayUpdateHallJoinStatusNoti object:nil];
            }
        }
    }
}

#pragma mark - MentoringShipCoreClient
- (void)onRecvCustomP2PGrabApprenticeNoti:(NSArray<MentoringGrabModel *> *)grabModels {
    [[BaiduMobStat defaultStat] logEvent:@"mentor_push" eventLabel:@"师徒推送"];
    if ([GetCore(MentoringShipCore) isHideGrabApprenticeHint]) {
        return;
    }
    
    TTMasterHintView *hintView = [TTMasterHintView shareMasterHintView];
    hintView.delegate = self;
    [hintView show];
}

#pragma mark - TTMasterHintViewDelegate
/** hint 的点击事件 */
- (void)masterHintView:(TTMasterHintView *)hintView didTapActionView:(UIView *)tapView {
    [[BaiduMobStat defaultStat] logEvent:@"global_push_jump" eventLabel:@"师徒推送-点击跳转"];
    [[TTMasterHintView shareMasterHintView] dismiss];
    
    UIViewController *rootViewController = [UIApplication sharedApplication].keyWindow.rootViewController;
    // 如果当前控制器是消息控制器, 则选中消息seg
    UIViewController *messageVC = [[XCMediator sharedInstance] ttMessageMoudle_TTMainMessageViewController];
    if ([[[XCCurrentVCStackManager shareManager] getCurrentVC] isKindOfClass:[messageVC class]]) {
        [GetCore(MentoringShipCore) updateMessageMainViewControllerSelectIndex:0];
        return;
    }

    // 有一个被present出来的控制器 要先dismiss
    if ([rootViewController presentedViewController]) {
        // 先让房间最小化
        [[XCMediator sharedInstance] ttRoomMoudle_minRoomViewControllerCompleteBlock:^{
            // 如果还有被present出来的控制器 要先dismiss
            if ([rootViewController presentedViewController]) {
                [self masterHintAppRootVCDismissPressentedVC];
            } else {
                [self masterHintAppRootVCPopToRootVC];
            }
        }];
    } else {
        [self masterHintAppRootVCPopToRootVC];
    }
    
    [GetCore(MentoringShipCore) updateMessageMainViewControllerSelectIndex:0];
}

/**
 窗口的根控制器 dismiss modal出来的控制器并 pop到RootVC并选中消息
 */
- (void)masterHintAppRootVCDismissPressentedVC {
    UIViewController *rootViewController = [UIApplication sharedApplication].keyWindow.rootViewController;
    [[rootViewController presentedViewController] dismissViewControllerAnimated:YES completion:^{
        [self masterHintAppRootVCPopToRootVC];
    }];
}

/**
 pop到RootVC并选中消息
 */
- (void)masterHintAppRootVCPopToRootVC {
    if ([[XCCurrentVCStackManager shareManager] getCurrentVC].navigationController.viewControllers.count > 1) {
        [[[XCCurrentVCStackManager shareManager] getCurrentVC].navigationController popToRootViewControllerAnimated:YES];
    }
    if ([[UIApplication sharedApplication].delegate.window.rootViewController isKindOfClass:[UITabBarController class]]) {
        UITabBarController *tabVC = (UITabBarController *)[UIApplication sharedApplication].delegate.window.rootViewController;
        if (tabVC.selectedViewController) {
            if ([tabVC.selectedViewController isKindOfClass:[UINavigationController class]]) {
                [tabVC.selectedViewController popToRootViewControllerAnimated:YES];
            }
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [tabVC setSelectedIndex:2];
            });
        }
    }
}

@end
