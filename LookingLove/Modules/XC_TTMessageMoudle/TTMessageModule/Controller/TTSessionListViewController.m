//
//  TTSessionListViewController.m
//  TuTu
//
//  Created by gzlx on 2018/10/31.
//  Copyright © 2018年 YiZhuan. All rights reserved.
//

#import "TTSessionListViewController.h"
#import "TTSessionViewController.h"

#import "TTLittleWorldSessionViewController.h"

#import "TTMessageEmptyDataView.h"
#import "TTSessionListHeadView.h"
#import "XCKeyWordTool.h"
#import <NIMSDK/NIMSDK.h>

#import "XCMediator+TTPersonalMoudleBridge.h"
#import "XCMediator+TTMessageMoudleBridge.h"

#import "YYEmptyContentToastView.h"
#import "UIColor+UIColor_Hex.h"
#import "XCHUDTool.h"

#import "ImLoginCoreClient.h"
#import "VersionCore.h"
#import "TTServiceCore.h"
#import "TTServiceCoreClient.h"

#import "Attachment.h"
#import "XCOpenLiveAttachment.h"
#import "XCRedPacketInfoAttachment.h"
#import "XCNewsInfoAttachment.h"
#import "NobleNotifyAttachment.h"
#import "XCGiftAttachment.h"
#import "TurntableAttachment.h"
#import "XCUserUpgradeAttachment.h"
#import "XCCPGamePrivateAttachment.h"
#import "XCGuildAttachment.h"
#import "XCCheckinNoticeAttachment.h"
#import "XCCheckinDrawCoinAttachment.h"
#import "UserCore.h"
#import "AuthCore.h"
#import "MentoringShipCoreClient.h"
#import "MentoringShipCore.h"
#import "TTServiceCore.h"

#import "XCMacros.h"
#import "XCTheme.h"
#import <Masonry/Masonry.h>

#import "XCMediator+TTMessageMoudleBridge.h"
#import "TTWKWebViewViewController.h"
#import "ClientCore.h"
#import "XCHtmlUrl.h"

static NSString *const kAtMeContent = @"[有人@你]";

@interface TTSessionListViewController () <ImLoginCoreClient, TTServiceCoreClient, TTSessionListHeadViewDelegate, MentoringShipCoreClient>
@property (nonatomic, strong) TTMessageEmptyDataView *emptyDataView;
/** Header */
@property (nonatomic, strong) TTSessionListHeadView *headView;
/**
 *
 */
@property (nonatomic,assign) BOOL isCanBack;
@end

@implementation TTSessionListViewController
- (BOOL)isHiddenNavBar{
    if (self.isRoomMessage) {
        return YES;
    }
    return NO;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self forbiddenSideBack];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self resetSideBack];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self refresh];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
}

- (void)dealloc {
    RemoveCoreClientAll(self);
}

#pragma mark - overload
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer*)gestureRecognizer {
    return self.isCanBack;
}

- (void)forbiddenSideBack {
    self.isCanBack = NO;
    //关闭ios右滑返回
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.delegate = self;
    }
}

- (void)resetSideBack {
    self.isCanBack = YES;
    //开启ios右滑返回
    if([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.delegate = nil;
    }
}


#pragma mark - overload
- (void)onSelectedRecent:(NIMRecentSession *)recent atIndexPath:(NSIndexPath *)indexPath {
    if (self.isRoomMessage) {
        
        NSString *sessionId = recent.session.sessionId;
        NIMTeam *team = [[NIMSDK sharedSDK].teamManager teamById:sessionId];
        
        //公会类型的群聊有区别于其他会话：team.serverCustomInfo 值为 {"type":1} JSON 形式
        NSDictionary *guildGroupTypeInfo = @{@"type": @1};
        NSString *guildGroupTypeInfoJSON = [guildGroupTypeInfo yy_modelToJSONString];
        if (team && [team.serverCustomInfo isEqualToString:guildGroupTypeInfoJSON]) {
            //跳转公会的群聊
            UIViewController *sessionVC = [[XCMediator sharedInstance] ttPersonalModule_TTGuildGroupSessionViewControllerWithSessionId:sessionId];
            [sessionVC setValue:@(YES) forKey:@"isRoomMessage"];
            CATransition *transition = [CATransition animation];
            transition.duration = 0.3f;
            transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
            transition.type = kCATransitionPush;
            transition.subtype = kCATransitionFromRight;
            [self.mainController.view.layer addAnimation:transition forKey:nil];
            [self.mainController addChildViewController:sessionVC];
            [self.mainController.view addSubview:sessionVC.view];
            return;
        }
    
        NSDictionary * littleWorldTypeInfo = @{@"type":@2};
        if (team && [team.serverCustomInfo isEqualToString:[littleWorldTypeInfo yy_modelToJSONString]]) {
            //跳转x小世界的群聊
            UIViewController *sessionVC = [[XCMediator sharedInstance] ttMessageMoudle_TTLittleWorldSessionViewController:sessionId];
            [sessionVC setValue:@(YES) forKey:@"isRoomMessage"];
            CATransition *transition = [CATransition animation];
            transition.duration = 0.3f;
            transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
            transition.type = kCATransitionPush;
            transition.subtype = kCATransitionFromRight;
            [self.mainController.view.layer addAnimation:transition forKey:nil];
            [self.mainController addChildViewController:sessionVC];
            [self.mainController.view addSubview:sessionVC.view];
            return;
        }
        
        TTSessionViewController * sessionVC =[[TTSessionViewController alloc] initWithSession:recent.session];
        sessionVC.isRoomMessage = YES;
        CATransition *transition = [CATransition animation];
        transition.duration = 0.3f;
        transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        transition.type = kCATransitionPush;
        transition.subtype = kCATransitionFromRight;
        [self.mainController.view.layer addAnimation:transition forKey:nil];
        [self.mainController addChildViewController:sessionVC];
        [self.mainController.view addSubview:sessionVC.view];
    }else{
        NSString *sessionId = recent.session.sessionId;
        NIMTeam *team = [[NIMSDK sharedSDK].teamManager teamById:sessionId];
        
        //公会类型的群聊有区别于其他会话：team.serverCustomInfo 值为 {"type":1} JSON 形式
        NSDictionary *guildGroupTypeInfo = @{@"type": @1};
        NSString *guildGroupTypeInfoJSON = [guildGroupTypeInfo yy_modelToJSONString];
        if (team && [team.serverCustomInfo isEqualToString:guildGroupTypeInfoJSON]) {
            //跳转公会的群聊
            UIViewController *vc = [[XCMediator sharedInstance] ttPersonalModule_TTGuildGroupSessionViewControllerWithSessionId:sessionId];
            [self.navigationController pushViewController:vc animated:YES];
            return;
        }
        
        NSDictionary * littleWorldTypeInfo = @{@"type":@2};
        if (team && [team.serverCustomInfo isEqualToString:[littleWorldTypeInfo yy_modelToJSONString]]) {
            //跳转小世界的群聊
            UIViewController *vc = [[TTLittleWorldSessionViewController alloc] initWithSession:[NIMSession session:sessionId type:NIMSessionTypeTeam]];
            [self.navigationController pushViewController:vc animated:YES];
            return;
        }
        
       TTSessionViewController * sessionVC =[[TTSessionViewController alloc] initWithSession:recent.session];
        [self.navigationController pushViewController:sessionVC animated:YES];
    }
}

- (void)onSelectedServiceAtIndexPath:(NSIndexPath *)indexPath{
//    if(GetCore(ClientCore).customerType == 1){
//        [self.navigationController pushViewController:[GetCore(TTServiceCore) getQYSessionViewController] animated:YES];
//    }else{
        TTWKWebViewViewController *webView = [[TTWKWebViewViewController alloc] init];
        webView.urlString = HtmlUrlKey(kLive800);
        [self.navigationController pushViewController:webView animated:YES];
//    }
}

- (NSAttributedString *)contentForRecentSession:(NIMRecentSession *)recent {
    NSAttributedString *content;
    if (recent.lastMessage.messageType == NIMMessageTypeCustom) {
        
        NIMCustomObject *obj = (NIMCustomObject *)recent.lastMessage.messageObject;
        NSString *text = @"";
        if ([obj.attachment isKindOfClass:[XCOpenLiveAttachment class]]) {
            if (GetCore(VersionCore).loadingData) {
                text = @"[消息]";
            } else {
                text = recent.lastMessage.apnsContent;
            }
        } else if ([obj.attachment isKindOfClass:[XCRedPacketInfoAttachment class]]) {
            text = [NSString stringWithFormat:@"[%@]",[XCKeyWordTool sharedInstance].xcRedColor];
        } else if ([obj.attachment isKindOfClass:[XCNewsInfoAttachment class]]) {
            text = @"[推文]";
        } else if ([obj.attachment isKindOfClass:[XCGiftAttachment class]]) {
            text = @"[礼物]";
        } else if ([obj.attachment isKindOfClass:[TurntableAttachment class]]) {
            text = @"[活动]";
        } else if ([obj.attachment isKindOfClass:[XCGuildAttachment class]]) {
            text = @"您收到一条厅消息";
        } else if ([obj.attachment isKindOfClass:[NobleNotifyAttachment class]]) {
            Attachment *att = (Attachment *)obj.attachment;
            if (att.first == Custom_Noti_Header_CarNotify) {
                text = @"[座驾消息]";
            } else if (att.first == Custom_Noti_Header_NobleNotify) {
                text = @"[消息]";
            }
        } else if ([obj.attachment isKindOfClass:[XCUserUpgradeAttachment class]]) {
            text = @"升级消息";
        } else if ([obj.attachment isKindOfClass:[XCCPGamePrivateAttachment class]]){
            text = @"你收到一条游戏邀请消息";
        } else if ([obj.attachment isKindOfClass:[XCCheckinNoticeAttachment class]]) {
            text = @"[签到提醒]";
        } else if ([obj.attachment isKindOfClass:[XCCheckinDrawCoinAttachment class]]) {
            text = @"[签到瓜分百万]";
        } else {
            if (recent.lastMessage.apnsContent.length > 0) {
                if (GetCore(VersionCore).loadingData) {
                    text = @"[消息]";
                } else {
                    if([obj.attachment isKindOfClass:[Attachment class]]){
                        Attachment *attachment = (Attachment *)obj.attachment;
                        if (attachment.first == Custom_Noti_Header_Gift) {
                            text = @"[礼物]";
                        }else {
                            text = recent.lastMessage.apnsContent;
                            
                        }
                    }else {
                        text = recent.lastMessage.apnsContent;
                    }
                }
            } else {
                text = @"[消息]";
            }
        }
        
        content = [[NSAttributedString alloc] initWithString:text];
    } else {
        content = [super contentForRecentSession:recent];
        
        if ([self unreadAtMeStatusForRecentSession:recent]) {
            NSDictionary *attributes = @{NSForegroundColorAttributeName: UIColor.redColor};
            NSAttributedString *atMeAtt = [[NSAttributedString alloc] initWithString:kAtMeContent attributes:attributes];
            
            NSMutableAttributedString *attContent = [[NSMutableAttributedString alloc] initWithAttributedString:content];
            [attContent insertAttributedString:atMeAtt atIndex:0];
            
            content = [attContent copy];
        }
    }
    NSMutableAttributedString *attContent = [[NSMutableAttributedString alloc] initWithAttributedString:content];
    return attContent;
}

- (void)refresh {
    [super refresh];
    
    [self.tableView reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return self.isRoomMessage ? 0 : 1;
    }
    tableView.backgroundView = self.recentSessions.count == 0 && self.isRoomMessage ? self.emptyDataView : nil;
    return self.recentSessions.count;
}

#pragma mark - TTServiceCoreClient
//- (void)onQYUnreadCountChanged:(NSInteger)count{
//    TTQYServiceTableViewCell * cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
//    if (count> 0) {
//        cell.badgeView.hidden = NO;
//        cell.badgeView.badgeValue = @(count).stringValue;
//    }else{
//        cell.badgeView.hidden = YES;
//    }
//}

//- (void)onReceiveQYMessage:(QYMessageInfo *)message{
//    TTQYServiceTableViewCell * cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
//    [cell onReceiveQYMessageUpdateUI:message];
//    [self.tableView reloadData];
//}

#pragma mark - ImLoginCoreClient
- (void)onImLogoutSuccess {
    [self.recentSessions removeAllObjects];
}

- (void)onImSyncSuccess {
    if ([NIMSDK sharedSDK].conversationManager.allRecentSessions.count) {
        [self setValue:[[NIMSDK sharedSDK].conversationManager.allRecentSessions mutableCopy] forKey:NSStringFromSelector(@selector(recentSessions))];
        [self refresh];
    }
}

#pragma mark - TTSessionListHeadViewDelegate
- (void)sessionListHeadView:(TTSessionListHeadView *)headerView didClickGoButtonWithUid:(long long)uid {
    [[BaiduMobStat defaultStat] logEvent:@"news_rob" eventLabel:@"抢徒弟"];
    [XCHUDTool showGIFLoadingInView:self.view];
    UserID masterUid = [[GetCore(AuthCore) getUid] userIDValue];
    [GetCore(MentoringShipCore) mentoringShipGrabApprenticeWithMasterUid:masterUid apprenticeUid:uid];
}

#pragma mark - MentoringShipCoreClient
- (void)onRecvCustomP2PGrabApprenticeNoti:(NSArray<MentoringGrabModel *> *)grabModels {
    [self updateHeaderView];
}

/** 更新了可抢徒弟的数据 */
- (void)updateGrabApprenticeData:(NSArray<MentoringGrabModel *> *)grabModels {
    [self updateHeaderView];
}

/** 抢徒弟成功的回调 */
- (void)mentoringShipGrabApprenticeSuccess:(UserID)apprenticeUid {
    [XCHUDTool hideHUDInView:self.view];
    [[BaiduMobStat defaultStat] logEvent:@"news_rob_succeed" eventLabel:@"抢徒成功"];
    NIMSession *session = [NIMSession session:[NSString stringWithFormat:@"%lld", apprenticeUid] type:NIMSessionTypeP2P];
    TTSessionViewController *vc = [[TTSessionViewController alloc] initWithSession:session];
    [self.navigationController pushViewController:vc animated:YES];
    
    NSMutableArray *grabMs = [GetCore(MentoringShipCore).grabApprenticesModels copy];
    for (MentoringGrabModel *model in grabMs) {
        if (model.uid == apprenticeUid) {
            [GetCore(MentoringShipCore).grabApprenticesModels removeObject:model];
        }
    }
    [self updateHeaderView];
}

/** 抢徒弟失败的回调 */
- (void)mentoringShipGrabApprenticeFail:(NSString *)message errorCode:(NSNumber *)errorCode {
    [XCHUDTool hideHUDInView:self.view];
    [XCHUDTool showErrorWithMessage:message inView:self.view];
}

#pragma mark - Private Methods
- (void)initView {
    AddCoreClient(ImLoginCoreClient, self);
    AddCoreClient(TTServiceCoreClient, self);
    AddCoreClient(MentoringShipCoreClient, self);
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.separatorColor = [UIColor colorWithHexString:@"#f0f0f0"];
    self.tableView.sectionHeaderHeight = 0;
    self.tableView.sectionFooterHeight = 0;
    self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 1, 1)];
    
    if (self.isRoomMessage) {
        [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.view).offset(0);
            make.left.right.bottom.mas_equalTo(self.view);
        }];
    }else{
        [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(self.view);
            make.top.bottom.mas_equalTo(self.view);
        }];
        [self updateHeaderView];
    }
}

- (void)updateHeaderView {
    NSMutableArray *grabMs = GetCore(MentoringShipCore).grabApprenticesModels;
    if (grabMs.count > 0) {
        self.headView.frame = CGRectMake(0, 0, KScreenWidth, 140);
    } else {
        self.headView.frame = CGRectMake(0, 0, KScreenWidth, 0);
    }
    self.tableView.tableHeaderView = self.headView;
    [self.tableView reloadData];
    self.headView.grabModels = grabMs;
}

///查询是否有未读的@我
- (BOOL)unreadAtMeStatusForRecentSession:(NIMRecentSession *)recent {
    
    NSString *sessionId = recent.session.sessionId;
    NSAssert(sessionId != nil, @"Unexcepted issue for invalid message id");
    BOOL hasUnread = [[NSUserDefaults standardUserDefaults] boolForKey:sessionId];
    if (recent.unreadCount == 0) {
        if (hasUnread) {
            [self updateUnreadAtMeStatusWithSessionId:sessionId isUnread:NO];
        }
        return NO;
    }
    
    UserInfo *info = [GetCore(UserCore) getUserInfoInDB:GetCore(AuthCore).getUid.longLongValue];
    NSString *atMe = [NSString stringWithFormat:@"@%@", info.nick];
    if ([recent.lastMessage.text containsString:atMe] && !hasUnread) {
        [self updateUnreadAtMeStatusWithSessionId:sessionId isUnread:YES];
        return YES;
    }
    
    return hasUnread;
}

///更新是否有未读的@我
- (void)updateUnreadAtMeStatusWithSessionId:(NSString *)sessionId isUnread:(BOOL)isUnread {
    
    NSAssert(sessionId != nil, @"Unexcepted issue for invalid message id");
    [[NSUserDefaults standardUserDefaults] setBool:isUnread forKey:sessionId];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

#pragma mark - getter
- (TTMessageEmptyDataView *)emptyDataView {
    if (_emptyDataView == nil) {
        _emptyDataView = [[TTMessageEmptyDataView alloc] init];
        _emptyDataView.backgroundColor = UIColor.whiteColor;
        _emptyDataView.text = @"你还没有聊天记录哦！\n快去和好友聊天吧！";
        _emptyDataView.image = @"common_noData_empty";
        _emptyDataView.imageCenterOffsetY = -50;
        _emptyDataView.textToImageBottomOffset = 4;
    }
    return _emptyDataView;
}

- (TTSessionListHeadView *)headView {
    if (!_headView) {
        _headView = [[TTSessionListHeadView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, 140)];
        _headView.delegate = self;
    }
    return _headView;
}

@end

