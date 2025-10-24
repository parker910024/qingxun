//
//  TTRoomModuleCenter.m
//  TuTu
//
//  Created by KevinWang on 2018/10/30.
//  Copyright © 2018年 YiZhuan. All rights reserved.
//

#import "TTRoomModuleCenter.h"

//core
#import "RoomCoreClient.h"
#import "RoomQueueCoreClient.h"
#import "ImMessageCoreClient.h"
#import "MeetingCoreClient.h"

#import "ImRoomCoreV2.h"
#import "ImRoomCoreClient.h"
#import "ImRoomCoreClientV2.h"

#import "ImLoginCore.h"
#import "ImLoginCoreClient.h"

#import "VersionCore.h"
#import "VersionCoreClient.h"

#import "UserCore.h"
#import "UserCoreClient.h"

#import "AuthCore.h"
#import "AuthCoreClient.h"

#import "AppInitClient.h"
#import "ClientCore.h"
#import "LinkedMeClient.h"
#import "ActivityCoreClient.h"
#import "AdCoreClient.h"
#import "APNSCoreClient.h"
#import "ImPublicChatroomCore.h"
#import "MentoringShipCore.h"
#import "LittleWorldCore.h"
//VC
#import "TTGameRoomViewController.h"
#import "TTGameRoomContainerController.h"
#import "BaseNavigationController.h"
#import "XCMediator+TTGameModuleBridge.h"

//t
#import "XCHUDTool.h"
#import "XCCurrentVCStackManager.h"
#import "XCHtmlUrl.h"
#import "TTPopup.h"

//view
#import "TTInputPwdView.h"
#import "TTTurntableView.h"
#import "TTUpGradeView.h"
#import "XCRoomTeenagerModeAlertView.h"

// alert
#import "TTWKWebViewViewController.h"
#import "TTRoomKTVAlerView.h"


@interface TTRoomModuleCenter()
<
RoomCoreClient,
RoomQueueCoreClient,
ImRoomCoreClient,
ImRoomCoreClientV2,
ImMessageCoreClient,
ImLoginCoreClient,
MeetingCoreClient,
VersionCoreClient,
UserCoreClient,
AuthCoreClient,
LinkedMeClient,
AdCoreClient,
APNSCoreClient,
ActivityCoreClient,
AppInitClient,
TTInputPwdViewDelegate
>

@property(nonatomic, assign) UserID notificationUid;
//需要开房类型
@property(nonatomic, assign) RoomType needOpenRoomType;
@property(nonatomic, assign) BOOL needOpen;
@property(nonatomic, assign) BOOL isLoadingRoom;
@property(nonatomic, copy) NSString *linkmeShareFamilyId;
@property (nonatomic, strong) UIWindow * gradeWindow;

@end

@implementation TTRoomModuleCenter

#pragma mark - life cycle
+ (instancetype)defaultCenter{
    
    static dispatch_once_t onceToken = 0;
    static id instance;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

- (instancetype)init{
    
    if (self = [super init]) {
        
        AddCoreClient(RoomCoreClient, self);
        AddCoreClient(RoomQueueCoreClient, self);
        AddCoreClient(ImRoomCoreClient, self);
        AddCoreClient(ImRoomCoreClientV2, self);
        AddCoreClient(ImLoginCoreClient, self);
        AddCoreClient(MeetingCoreClient, self);
        AddCoreClient(LinkedMeClient, self);
        AddCoreClient(ActivityCoreClient, self);
        AddCoreClient(AuthCoreClient, self);
        AddCoreClient(VersionCoreClient, self);
        AddCoreClient(AdCoreClient, self);
        AddCoreClient(AppInitClient, self);
        AddCoreClient(ImMessageCoreClient, self);
        AddCoreClient(UserCoreClient, self);
        AddCoreClient(APNSCoreClient, self);

        [[NSNotificationCenter defaultCenter] addObserver : self selector:@selector (saveTopStatusBarHeight:) name:UIApplicationDidChangeStatusBarFrameNotification object:nil];
        
        __block TTGameRoomContainerController *vc = [[TTGameRoomContainerController alloc] init];
        vc.view.tag = 10000;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            vc = nil;
        });
    }
    return self;
}

- (void)dealloc{
    
    RemoveCoreClientAll(self);
}

#pragma mark - notifaction

- (void)saveTopStatusBarHeight:(NSNotification *)noti {
    
    if (noti) {
        if (noti.userInfo) {
            NSValue *statusBarFrameValue = [noti.userInfo objectForKey:UIApplicationStatusBarFrameUserInfoKey];
            CGRect rect = [statusBarFrameValue CGRectValue];
            if (rect.size.height == 40) {
                self.systemOperationStatusBarIsShow = YES;
            }else {
                self.systemOperationStatusBarIsShow = NO;
            }
        }
    }
}


#pragma mark - puble method
//开启指定类型的房间
- (void)openRoonWithType:(RoomType)type {
    [XCHUDTool showGIFLoading];
    [GetCore(UserCore) getUserInfo:GetCore(AuthCore).getUid.userIDValue refresh:YES success:^(UserInfo *info) {
        if (info.isCertified) {
            [self openRoom:type];
        }else{
            if (GetCore(ClientCore).strategy == FaceLivenessStrategy_Force) {//强制
                [self showTipsAlertView:type];
            }else if (GetCore(ClientCore).strategy == FaceLivenessStrategy_Guide){//引导
                [self showTipsAlertView:type];
            }else{//不提示
                [self openRoom:type];
            }
        }
        [XCHUDTool hideHUD];
    }failure:^(NSError *error) {
        [XCHUDTool hideHUD];
    }];
}

/**
 根据房间类型开启房间
 
 @param type 房间类型
 */

- (void)openRoom:(RoomType )type {
    
    [[GetCore(RoomCoreV2) requestRoomInfo:[GetCore(AuthCore) getUid].userIDValue] subscribeNext:^(id x) {
        if (x == nil) { //当前没开房
            [XCHUDTool showGIFLoading];
            UserInfo *info = [GetCore(UserCore) getUserInfoInDB:[GetCore(AuthCore) getUid].userIDValue];
            NSString *title = [NSString stringWithFormat:@"%@的房间",info.nick];
            if (GetCore(LittleWorldCore).worldId && GetCore(LittleWorldCore).roomTitle) {
                title = GetCore(LittleWorldCore).roomTitle;
            }
            [GetCore(RoomCoreV2) openRoom:[GetCore(AuthCore)getUid].userIDValue type:type title:title roomDesc:@"" backPic:@"" rewardId:nil];
        }else { //当前有开房
            
            RoomInfo *roomInfo = (RoomInfo *)x;
            if (!GetCore(LittleWorldCore).worldId) { // 不是从群聊派对进入的
                if (roomInfo.worldId) { // 还是派对房。清除派对模式
                    [GetCore(LittleWorldCore) requestWorldLetCloseGroupChatWithRoomUid:roomInfo.uid];
                }
            }
            if (type == roomInfo.type) { //要开的房间跟已经开的房间一样
                [XCHUDTool showGIFLoading];
                
                //如果是小世界进来的话 就用小世界core保存的值
                if (GetCore(LittleWorldCore).worldId && GetCore(LittleWorldCore).roomTitle) {
                    roomInfo.title = GetCore(LittleWorldCore).roomTitle;
                }
                
                if (roomInfo.valid) { //房间有效
                    
                    [self presentRoomViewWithRoomInfo:roomInfo]; //直接进入房间
                    
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        if (GetCore(LittleWorldCore).worldId && roomInfo.uid == GetCore(AuthCore).getUid.userIDValue && roomInfo.title) {
                            NSDictionary *params = @{@"title": roomInfo.title};
                            [GetCore(RoomCoreV2) updateGameRoomInfo:params type:UpdateRoomInfoTypeUser];
                        }
                    });
                    
                }else{
                    if (type == RoomType_Game || type == RoomType_CP || type == RoomType_Love) {
                        [GetCore(RoomCoreV2) openRoom:[GetCore(AuthCore) getUid].userIDValue type:type title:roomInfo.title roomDesc:roomInfo.roomDesc backPic:@"" rewardId:nil];
                    }
                }
            } else { //要开的房间跟已经开的房间不一样，需要提示用户是否要关闭之前的房间
                if (roomInfo.valid) { //  房间有效。提示用户
                    NSString *alertString;
                    
                    if (type == RoomType_CP) {
                        if (roomInfo.type == RoomType_CP) {
                        }
                        alertString = @"创建陪伴房，普通房将会被关闭并移出房间内所有用户，确认创建吗？";
                    } else if (type == RoomType_Game) {
                        if (roomInfo.type == RoomType_CP) {
                            alertString = @"创建陪伴房，普通房将会被关闭并移出房间内所有用户，确认创建吗？";
                        } else if (roomInfo.type == RoomType_Love) {
                            self.needOpenRoomType = roomInfo.type;
                            [self presentRoomViewWithRoomInfo:roomInfo];
                            return;
                        }
                        if (GetCore(LittleWorldCore).worldId && GetCore(LittleWorldCore).roomTitle) {
                            roomInfo.title = GetCore(LittleWorldCore).roomTitle;
                        }
                    }
                    TTRoomKTVAlerView *alertView = [[TTRoomKTVAlerView alloc] initWithFrame:CGRectMake(0, 0, 295, 182) title:@"提示" subTitle:nil attrMessage:nil message:alertString backgroundMessage:nil cancel:^{
                        
                        [TTPopup dismiss];
                        
                    } ensure:^{
                        
                        [TTPopup dismiss];

                        [XCHUDTool showGIFLoading];
                        self.needOpenRoomType = type;
                        [GetCore(RoomCoreV2)closeRoomWithBlock:roomInfo.uid Success:^(UserID uid) {//close
                            //open
                            [GetCore(RoomCoreV2)openRoom:uid type:type title:roomInfo.title roomDesc:roomInfo.roomDesc.length > 0 ? roomInfo.roomDesc :  @"" backPic:@"" rewardId:nil];
                        } failure:^(NSNumber *resCode, NSString *message) {
                            
                        }];
                    }];
                    
                    [TTPopup dismiss];
                    [TTPopup popupView:alertView style:TTPopupStyleAlert];
                    
                }else {
                    [XCHUDTool showGIFLoading];
                    UserInfo *info = [GetCore(UserCore) getUserInfoInDB:[GetCore(AuthCore) getUid].userIDValue];
                    NSString *title = [NSString stringWithFormat:@"%@的房间",info.nick];
        
                    if (GetCore(LittleWorldCore).worldId && GetCore(LittleWorldCore).roomTitle) {
                        title = GetCore(LittleWorldCore).roomTitle;
                    }
                    
                    [GetCore(RoomCoreV2) openRoom:[GetCore(AuthCore) getUid].userIDValue type:type title:title roomDesc:roomInfo.roomDesc.length > 0 ? roomInfo.roomDesc : @"" backPic:@"" rewardId:nil];
                }
            }
        }
        
    } error:^(NSError *error) {
        NSLog(@"%@",error);
        // 隐藏弹窗
        [XCHUDTool hideHUD];
        // 青少年模式下的错误信息处理
        [self alertTeenagerViewWithError:error];
    }];
}

//根据房间信息进入房间
- (void)presentRoomViewWithRoomInfo:(RoomInfo *)roomInfo{
    [XCHUDTool hideHUD];
    if (roomInfo == nil) return;
    
    if (roomInfo.uid == GetCore(ImPublicChatroomCore).publicChatroomUid) { //过滤公聊
        return;
    }
    
    if (self.isLoadingRoom) return;
    self.isLoadingRoom = YES;
    
    if ([TTPopup hasShowPopup]) {
        [TTPopup dismiss];
        
        self.isLoadingRoom = NO;
        [self presentRoomViewWithRoomInfo:roomInfo];
        
        return;
    }
    
    //当前房间信息
    RoomInfo *currentRoomInfo = [GetCore(RoomCoreV2) getCurrentRoomInfo];
    
    if (currentRoomInfo.roomId != roomInfo.roomId) { //最小化a房间，点击进入b房间
        if ([GetCore(RoomQueueCoreV2) isOnMicro:GetCore(AuthCore).getUid.userIDValue]) {
            [GetCore(RoomQueueCoreV2) downMicAndIsExitRoom:YES];
        }
    }
    
    if (roomInfo.type == RoomType_CP) {
        GetCore(TTGameStaticTypeCore).openRoomStatus = OpenRoomType_CP;
    } else if (roomInfo.type == RoomType_Game) {
        GetCore(TTGameStaticTypeCore).openRoomStatus = OpenRoomType_Normal;
    } else if (roomInfo.type == RoomType_Love) {
        GetCore(TTGameStaticTypeCore).openRoomStatus = OpenRoomType_Love;
    }
    
    if (self.currentNav == nil) {//导航为nil
        TTGameRoomContainerController *vc;
        
        if (roomInfo.type == RoomType_Game || roomInfo.type == RoomType_CP || roomInfo.type == RoomType_Love) {//哄趴
            vc = [[TTGameRoomContainerController alloc]init];
        }else {
            [XCHUDTool showErrorWithMessage:@"暂不支持该房间类型"];
            self.isLoadingRoom = NO;
            return;
        }
        
        BaseNavigationController *nav = [[BaseNavigationController alloc]init];
        if (vc != nil) {
            nav.viewControllers = @[vc];
        }else {
            self.isLoadingRoom = NO;
            [XCHUDTool showErrorWithMessage:@"房间不存在"];
            return;
        }
        
        @weakify(self)
        //获取当前根控制器。present  包装了导航控制器的房间
        [[GetCore(UserCore) getUserInfoByUid:roomInfo.uid refresh:NO] subscribeNext:^(id x) {
            
            UserInfo *info = (UserInfo *)x;
            GetCore(ImRoomCoreV2).roomOwnerInfo = info;
            NotifyCoreClient(TTRoomUIClient, @selector(roomUIClientOnGetUserInfoByUidSuccess), roomUIClientOnGetUserInfoByUidSuccess);
        }];
        
        if (currentRoomInfo.roomId != roomInfo.roomId ) {//更换房间清空队列与房间消息
            //兔兔特有的消息缓存
            [[TTMessageContentProvider shareProvider].messages removeAllObjects];
            [GetCore(RoomCoreV2).messages removeAllObjects];
            [GetCore(ImRoomCoreV2) resetAllQueue];
        }else {
            vc.isSameRoom = YES;
        }
        UIViewController *currentVc = [[XCCurrentVCStackManager shareManager] getCurrentVC];
        if (currentVc == nil) {
            self.isLoadingRoom = NO;
            [XCHUDTool showErrorWithMessage:@"登录状态异常，请退出重试"];
        }
        nav.modalPresentationStyle = UIModalPresentationFullScreen;
        [currentVc presentViewController:nav animated:YES completion:^{
            
            @strongify(self)
            self.currentNav = nav;
            self.isLoadingRoom = NO;
            
            [XCHUDTool hideHUD];
            if (currentRoomInfo == nil) { //点击进入房间
                GetCore(ImRoomCoreV2).currentRoomInfo = roomInfo;
                [GetCore(ImRoomCoreV2) enterChatRoom:roomInfo.roomId];
                
            } else {
                if (currentRoomInfo.roomId != roomInfo.roomId) { //最小化a房间，点击进入b房间
                    self.currentRoomInfo = roomInfo;
                    [GetCore(ImRoomCoreV2) exitChatRoom:GetCore(ImRoomCoreV2).currentRoomInfo.roomId];//退出a房间
                } else {
                    //进入相同的房间
                    NotifyCoreClient(ImRoomCoreClient, @selector(onMeInterChatSameRoomSuccess), onMeInterChatSameRoomSuccess);
                }
            }
            // 进入房间, 请求下礼物列表(专属礼物)
            [GetCore(GiftCore) requestGiftListWithRoomUid:roomInfo.uid];
        }];
        
        
    } else {//在房间里面的时候nav才不会空（在房间点击查看个人资料，找到ta）
        if (currentRoomInfo.roomId != roomInfo.roomId) { //不在本房间，已经离开了房间
            
            [GetCore(ImRoomCoreV2) exitChatRoom:GetCore(ImRoomCoreV2).currentRoomInfo.roomId];
            @weakify(self);
            [self.currentNav dismissViewControllerAnimated:YES completion:^{
                @strongify(self);
                self.currentNav = nil;
                self.isLoadingRoom = NO;
                [self presentRoomViewWithRoomInfo:roomInfo];
            }];
        } else { //在本房间
            self.isLoadingRoom = NO;
            [self.currentNav popToRootViewControllerAnimated:YES];
        }
        
    }
}

//根据房间所有者id。获取房间信息
- (void)presentRoomViewWithRoomOwnerUid:(UserID)ownerUid
                                success:(void (^)(RoomInfo *))successBlock
                                   fail:(void (^)(NSString *))failBlock{
    
    if (ownerUid > 0) {
        [[GetCore(RoomCoreV2) requestRoomInfo:ownerUid] subscribeNext:^(id x) {
            RoomInfo *roomInfo = (RoomInfo *)x;
            
//            if ((roomInfo.type != RoomType_Game) && ownerUid == [GetCore(AuthCore)getUid].userIDValue) {
//                if (roomInfo.type == RoomType_CP) {
//
//                }else{
//                    [GetCore(RoomCoreV2)closeRoomWithBlock:roomInfo.uid Success:^(UserID uid) {
//
//                        [GetCore(RoomCoreV2)openRoom:uid type:roomInfo.type title:roomInfo.title roomDesc:@"" backPic:@"" rewardId:nil];
//                    } failure:^(NSNumber *resCode, NSString *message) {
//
//                    }];
//                }
//            }
            
            UserInfo *myInfo = [GetCore(UserCore) getUserInfoInDB:GetCore(AuthCore).getUid.userIDValue];
            if (myInfo.platformRole == XCUserInfoPlatformRoleSuperAdmin) {
                if (roomInfo) {
                    [XCHUDTool hideHUD];
                    if (successBlock) {
                        successBlock((RoomInfo *)x);
                    }
                }else {
                    if (successBlock) {
                        successBlock(nil);
                    }
                    [XCHUDTool showErrorWithMessage:@"该房间不存在"];
                }
                return;
            }
            if (roomInfo.roomPwd.length > 0 && [GetCore(AuthCore) getUid].userIDValue != roomInfo.uid) {
                [XCHUDTool hideHUD];
                if (self.isLoadingRoom) {
                    return;
                }
                
                TTInputPwdView *pwdView = [[TTInputPwdView alloc] initWithFrame:CGRectMake(0, 0, 311.f, 182.f) roomInfo:roomInfo title:@"房间密码" leftAction:@"取消" rightAction:@"解锁"];
                pwdView.delegate = self;
                [TTPopup popupView:pwdView style:TTPopupStyleAlert];
            }else {
                if (roomInfo) {
                    [XCHUDTool hideHUD];
                    if (successBlock) {
                        successBlock((RoomInfo *)x);
                    }
                }else {
                    if (successBlock) {
                        successBlock(nil);
                    }
                    [XCHUDTool showErrorWithMessage:@"该房间不存在"];
                }
            }
        } error:^(NSError *error) {
            if (failBlock) {
                failBlock(error.description);
            }
            // 青少年模式下的错误信息处理
            [self alertTeenagerViewWithError:error];
        }];
    }else {
        [XCHUDTool hideHUD];
        if (failBlock) {
            failBlock(@"网络异常");
        }
        [XCHUDTool showErrorWithMessage:@"网络异常"];
    }
}


//退出当前房间
- (void)dismissChannelViewWithQuitCurrentRoom:(BOOL)isQuit{
    
    [self dismissChannelViewWithQuitCurrentRoom:isQuit animation:YES];
}

- (void)dismissChannelViewWithQuitCurrentRoom:(BOOL)isQuit animation:(BOOL)animation{
    [self dismissChannelViewWithQuitCurrentRoom:isQuit animation:animation completion:nil];
}

- (void)dismissChannelViewWithQuitCurrentRoom:(BOOL)isQuit animation:(BOOL)animation completion:(void(^)(void))completion{
    
    self.isLoadingRoom = NO;
    
    if ([TTPopup hasShowPopup]) {
        [TTPopup dismiss];
    }
    
    if (self.currentNav != nil) {
        [self.currentNav dismissViewControllerAnimated:animation completion:^{
            if (GetCore(LittleWorldCore).littleWorldBackChat) {
                UIViewController *VC = [[XCMediator sharedInstance] ttGameMoudle_TTWorldletContainerViewControllerWithWorldId:[NSString stringWithFormat:@"%lld",GetCore(RoomCoreV2).getCurrentRoomInfo.worldId] isFromRoom:NO];
                [[XCCurrentVCStackManager shareManager].getCurrentVC.navigationController pushViewController:VC animated:YES];
                
                GetCore(LittleWorldCore).littleWorldBackChat = NO;
            }
            if (completion) {
                completion();
            }
        }];
        self.currentNav = nil;
    }else{
        if (completion) {
            completion();
        }
    }
    
    if (isQuit) {
        if ([GetCore(RoomQueueCoreV2) isOnMicro:GetCore(AuthCore).getUid.userIDValue]) {
            [GetCore(RoomQueueCoreV2) downMicAndIsExitRoom:YES];
        }
        [GetCore(ImRoomCoreV2) exitChatRoom:GetCore(ImRoomCoreV2).currentRoomInfo.roomId];
        
        // 师徒任务3 清除
        if (GetCore(MentoringShipCore).masterUid && GetCore(MentoringShipCore).apprenticeUid) {
            GetCore(MentoringShipCore).masterUid = 0;
            GetCore(MentoringShipCore).apprenticeUid = 0;
            GetCore(MentoringShipCore).inviteApprenticeUid = 0;
            [GetCore(MentoringShipCore) stopCountDown];
            GetCore(MentoringShipCore).countDownStatus = TTMasterCountDownStatusDefult;
        }
    }
    if (GetCore(LittleWorldCore).worldId) {
        GetCore(LittleWorldCore).worldId = 0;
    }
}


#pragma mark - client
#pragma mark - ImRoomCoreClient

- (void)onUserBeKicked:(NSString *)roomid reason:(NIMChatroomKickReason)reason
{
    self.isLoadingRoom = NO;
    [GetCore(RoomCoreV2) reportUserOuterRoom];
    if (self.currentNav != nil) {
        if (GetCore(ImRoomCoreV2).currentRoomInfo.type == RoomType_Game || GetCore(ImRoomCoreV2).currentRoomInfo.type == RoomType_CP ||
            GetCore(ImRoomCoreV2).currentRoomInfo.type == RoomType_Love) {
            NSLog(@"%ld",(long)GetCore(ImRoomCoreV2).currentRoomInfo.type);
            TTGameRoomContainerController *vc = self.currentNav.viewControllers[0];
            [vc ttBeKicked:reason];
        }
    }
}

- (void)onUserBeKicked:(NSString *)roomid kickResult:(NIMChatroomBeKickedResult *)kickResult {
    self.isLoadingRoom = NO;
    [GetCore(RoomCoreV2) reportUserOuterRoom];
    if (self.currentNav != nil) {
        if (GetCore(ImRoomCoreV2).currentRoomInfo.type == RoomType_Game || GetCore(ImRoomCoreV2).currentRoomInfo.type == RoomType_CP ||
            GetCore(ImRoomCoreV2).currentRoomInfo.type == RoomType_Love) {
            NSLog(@"%ld",(long)GetCore(ImRoomCoreV2).currentRoomInfo.type);
            TTGameRoomContainerController *vc = self.currentNav.viewControllers[0];
            [vc ttBeKickedBySuperAdmin:kickResult];
        }
    }
}

- (void)onMeInterChatRoomInBlackList
{
    self.isLoadingRoom = NO;
    if (self.currentNav != nil) {
        RoomInfo *info = [GetCore(RoomCoreV2) getCurrentRoomInfo];
        if (info.type == RoomType_Game || info.type == RoomType_CP || info.type == RoomType_Love) {
            TTGameRoomContainerController *vc = self.currentNav.viewControllers[0];
            [vc ttBeInBlackList];
        }
    }
}

- (void)onMeExitChatRoomSuccessV2 {
    
    if (self.currentRoomInfo != nil) {
        [GetCore(ImRoomCoreV2) enterChatRoom:self.currentRoomInfo.roomId];
        self.currentRoomInfo = nil;
    }
}

//自己进入房间失败
- (void)onMeInterChatRoomFailth {
    //    [UIView showToastInKeyWindow:@"房间已关闭" duration:2.0 position:(YYToastPosition)YYToastPositionCenter];
    //    [self dismissChannelViewWithQuitCurrentRoom:YES animation:NO];
}

#pragma mark - LinkMeClient
- (void)jumpInRoomWithRoomid:(NSString *)uid {
    
    if (uid.length > 0) {
        self.notificationUid = uid.userIDValue;
        
        if ([GetCore(ImLoginCore)isImLogin] && GetCore(VersionCore).versionInfo) {
            dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0/*延迟执行时间*/ * NSEC_PER_SEC));
            @weakify(self);
            dispatch_after(delayTime, dispatch_get_main_queue(), ^{
                @strongify(self);
                [self presentRoomViewWithRoomOwnerUid:self.notificationUid success:^(RoomInfo *roomInfo) {
                    [[TTRoomModuleCenter defaultCenter] presentRoomViewWithRoomInfo:roomInfo];
                } fail:^(NSString *errorMsg) {
                }];
                self.notificationUid = 0;
                
            });
        }
        
    }
}
//家族
- (void)jumpInFamilyWithFamilyId:(NSString *)familyId {
}

#pragma mark - VersionCoreClient

- (void)onRequestVersionStatusSuccess:(VersionInfo *)versionInfo {
    if (versionInfo.status != Version_ForceUpdate) {
        if (self.notificationUid > 0) {
            if ([GetCore(ImLoginCore)isImLogin]) {
                dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0/*延迟执行时间*/ * NSEC_PER_SEC));
                @weakify(self);
                dispatch_after(delayTime, dispatch_get_main_queue(), ^{
                    @strongify(self);
                    [self presentRoomViewWithRoomOwnerUid:self.notificationUid success:^(RoomInfo *roomInfo) {
                        [[TTRoomModuleCenter defaultCenter] presentRoomViewWithRoomInfo:roomInfo];
                    } fail:^(NSString *errorMsg) {
                    }];
                    self.notificationUid = 0;
                    
                });
            }
            
        }
        
    }
}

#pragma mark - ImLoginCoreClient
- (void)onImLoginSuccess
{
    if (!GetCore(ClientCore).needOpenRoom) {
        if (self.notificationUid > 0) {
            self.linkmeShareFamilyId = nil;
            if (GetCore(VersionCore).versionInfo.status != Version_ForceUpdate) {
                [self presentRoomViewWithRoomOwnerUid:self.notificationUid success:^(RoomInfo *roomInfo) {
                    [[TTRoomModuleCenter defaultCenter] presentRoomViewWithRoomInfo:roomInfo];
                } fail:^(NSString *errorMsg) {
                }];
                self.notificationUid = 0;
                
            }
        }
        
    }else {
        GetCore(ClientCore).needOpenRoom = NO;
        [self openRoonWithType:GetCore(ClientCore).foreTouchOpenRoomType];
    }
    
    if (self.linkmeShareFamilyId.length > 0) {
        [self jumpInFamilyWithFamilyId:self.linkmeShareFamilyId];
    }
}

#pragma mark - AppInitClient

- (void)onNeedOpenRoomWithRoomType:(RoomType)roomType {
    if (GetCore(ImLoginCore).isImLogin) {
        GetCore(ClientCore).needOpenRoom = NO;
        [self openRoonWithType:GetCore(ClientCore).foreTouchOpenRoomType];
    }
}

#pragma mark - ImMessageCoreClient

- (void)onSendMessageFailthWithError {
    [XCHUDTool showErrorWithMessage:@"网络连接异常，请重试"];
}

#pragma mark - RoomQueueCoreClient

- (void)thereIsNoFreePosition {
    [XCHUDTool showErrorWithMessage:@"没有空余的位置"];
}

- (void)thereIsNoLockPosition{
    [XCHUDTool showErrorWithMessage:@"麦上无空位了"];
}

#pragma mark - RoomCoreClient
/** 青少年模式下在线时间达到上限 */
- (void)roomOnLineTimsMaxWithMessage:(NSString *)msg {
    [self showRoomAlertTeenagerModeTimesUp:msg];
}

- (void)thereIsNoMicoPrivacy {
    
    TTAlertConfig *config = [[TTAlertConfig alloc] init];
    config.title = @"温馨提示";
    config.message = @"应用需要麦克风权限";
    config.confirmButtonConfig.title = @"设置";
    
    [TTPopup alertWithConfig:config confirmHandler:^{
        
        NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
        if (@available(iOS 10.0, *)) {
            
            if([[UIApplication sharedApplication] canOpenURL:url]) {
                [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:^(BOOL success) {
                }];
            }
            
        } else {
            if ([[UIApplication sharedApplication] canOpenURL:url]) {
                [[UIApplication sharedApplication] openURL:url];
            }
        }
        
    } cancelHandler:^{
        
    }];
}

- (void)onCloseRoomSuccess {
    [XCHUDTool hideHUD];
    if (self.needOpen) {
        if (self.needOpenRoomType != 0) {
            if (self.needOpenRoomType == RoomType_Party) {
                
            }else if (self.needOpenRoomType == RoomType_Auction) {
                
            }else if (self.needOpenRoomType == RoomType_Game || self.needOpenRoomType == RoomType_CP || self.needOpenRoomType == RoomType_Love) {
                UserInfo *info = [GetCore(UserCore) getUserInfoInDB:[GetCore(AuthCore) getUid].userIDValue];
                NSString *title = [NSString stringWithFormat:@"%@的房间",info.nick];
                [GetCore(RoomCoreV2)openRoom:[GetCore(AuthCore)getUid].userIDValue type:self.needOpenRoomType title:title roomDesc:@"" backPic:@"" rewardId:nil];
            }
        }
    }
}

- (void)onOpenRoomSuccess:(RoomInfo *)roomInfo {
    [XCHUDTool hideHUD];
    self.needOpen = NO;
    if (roomInfo.type == RoomType_Game || roomInfo.type == RoomType_CP || roomInfo.type == RoomType_Love) {
        [self presentRoomViewWithRoomInfo:roomInfo];
    }
}

#pragma mark - APNSCoreClient
- (void)onRequestToOpenRoomWithUid:(UserID)uid {
    self.notificationUid = uid;
    if ([GetCore(ImLoginCore) isImLogin]) {
        [self presentRoomViewWithRoomOwnerUid:self.notificationUid success:^(RoomInfo *roomInfo) {
            [self presentRoomViewWithRoomInfo:roomInfo];
        } fail:^(NSString *errorMsg) {
        }];
        self.notificationUid = 0;
    }
}

#pragma mark - TTInputPwdViewDelegate
- (void)inputPwdViewDidClose:(TTInputPwdView *)passwordView{
    [TTPopup dismiss];
}

- (void)inputPwdViewDidClose:(TTInputPwdView *)passwordView closePwdViewAndNeedPresent:(RoomInfo *)roomInfo {
    
    [TTPopup dismiss];
    
    [self presentRoomViewWithRoomInfo:roomInfo];
}

#pragma mark - ImLoginCoreClient
- (void)onMeInterChatRoomBadNetWork {
    self.currentRoomInfo = nil;
    [self dismissChannelViewWithQuitCurrentRoom:YES animation:YES];
    [XCHUDTool showErrorWithMessage:@"进入房间失败，请重试"];
}

- (void)onImKick {
    [GetCore(RoomCoreV2) reportUserOuterRoom];
    [self dismissChannelViewWithQuitCurrentRoom:YES animation:NO];
}

#pragma mark - AuthCoreClient

- (void)onLogout {
    [GetCore(RoomCoreV2) reportUserOuterRoom];
    [self dismissChannelViewWithQuitCurrentRoom:YES animation:NO];
}

#pragma mark - UserCoreClient
//请求导流成功
- (void)onRequestRecommendRoomUidSuccess:(UserID)uid {
    self.recommendUid = uid;
}

//导流
- (void)showRecommendRoomView {
}


#pragma mark - MeetingCoreClient
- (void)onMeetingQualityDown {
    [XCHUDTool showErrorWithMessage:@"当前网络异常，与服务器断开连接，请检查网络"];
}

- (void)onMeetingQualityBad {
    if (GetCore(ImRoomCoreV2).isInRoom) {
        [XCHUDTool showErrorWithMessage:@"当前网络不稳定，请检查网络"];
    }
}

#pragma mark - AdCoreClient
//转盘推送
- (void)onReceiveTurntableMessage {
    
    TTTurntableView *turntable = [[TTTurntableView alloc] initWithFrame:CGRectMake(0, 0, 280, 315)];
    
    TTPopupConfig *config = [[TTPopupConfig alloc] init];
    config.style = TTPopupStyleAlert;
    config.contentView = turntable;
    config.shouldDismissOnBackgroundTouch = NO;
    
    [TTPopup popupWithConfig:config];
}

#pragma mark - 等级升级
- (void)onReceiveUserUpGradeMessage:(UserUpGradeInfo *)upGradeInfo type:(UserUpgradeViewType)type{
    
    TTUpGradeView *upgradeView= [[TTUpGradeView alloc] initWithFrame:CGRectMake(0, 0, 270, 260)];
    upgradeView.gradeWindow = self.gradeWindow;
    [upgradeView configttUpgradeView:upGradeInfo type:type];
    self.gradeWindow.windowLevel = UIWindowLevelNormal;
    self.gradeWindow.backgroundColor = UIColorRGBAlpha(0x000000, 0.7);
    upgradeView.center = self.gradeWindow.center;
    [self.gradeWindow addSubview:upgradeView];
    
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    [self.gradeWindow makeKeyAndVisible];
    [keyWindow makeKeyWindow];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.gradeWindow.windowLevel = UIWindowLevelNormal -1;
        [upgradeView removeFromSuperview];
    });
}

- (UIWindow *)gradeWindow
{
    if (_gradeWindow== nil) {
        _gradeWindow = [[UIWindow alloc] init];
        _gradeWindow.windowLevel = UIWindowLevelNormal;
    }
    return _gradeWindow;
}

#pragma mark - private method
- (void)showTipsAlertView:(RoomType)type {
    
    TTAlertConfig *config = [[TTAlertConfig alloc] init];
    
    config.message = @"为了营造更安全的网络环境\n保护您和他人的财产安全\n请先进行实名认证";
    config.messageLineSpacing = 4;
    config.confirmButtonConfig.title = @"前往认证";
    config.confirmButtonConfig.titleColor = UIColor.whiteColor;
    config.confirmButtonConfig.backgroundColor = [XCTheme getTTMainColor];
    
    TTAlertMessageAttributedConfig *nameAttrConf = [[TTAlertMessageAttributedConfig alloc] init];
    nameAttrConf.text = @"实名认证";
    nameAttrConf.color = [XCTheme getTTMainColor];
    config.messageAttributedConfig = @[nameAttrConf];
    
    @weakify(self);
    [TTPopup alertWithConfig:config confirmHandler:^{
        
        TTWKWebViewViewController *web = [[TTWKWebViewViewController alloc] init];
        web.urlString = [NSString stringWithFormat:@"%@?uid=%@", HtmlUrlKey(kIdentityURL), GetCore(AuthCore).getUid];
        [[[XCCurrentVCStackManager shareManager]currentNavigationController] pushViewController:web animated:YES];

    } cancelHandler:^{
        
        //0：不提示，1：强制，2：强引导
        @strongify(self);
        if (GetCore(ClientCore).strategy == FaceLivenessStrategy_Guide) {
            [self openRoom:type];
        } else {
            self.isLoadingRoom = NO;
        }
    }];
}

#pragma mark -
#pragma mark 青少年模式进房失败提示
/**
 * 根据错误信息弹出青少年提示
 * @param error 服务器返回的错误信息
 */
- (void)alertTeenagerViewWithError:(NSError *)error {
    if ([error isKindOfClass:[CoreError class]]) {
        
        CoreError *coreError = (CoreError *) error;
        // 当 code = 30000 的时候才进行显示弹窗
        if (coreError.resCode == 30000) {
            [self showRoomAlertTeenagerModeTimesUp:coreError.message];
        } else {
            [XCHUDTool showErrorWithMessage:coreError.message];
        }
    }
}

/**
 * 显示青少年在线时长达到上限弹窗
 * @param errorMessage 失败信息
 */
- (void)showRoomAlertTeenagerModeTimesUp:(NSString *)errorMessage {
    XCRoomTeenagerModeAlertView *teenagerModeAlertView = [[XCRoomTeenagerModeAlertView alloc] initWithFrame:CGRectMake(0, 0, 311, 200)
                                                                                                 resMessage:errorMessage];
//
//
//
    @weakify(self);
    teenagerModeAlertView.roomTeenagerModeAlertBlock = ^{
        @strongify(self);
        // 优先判断当前用户是否在麦上。
        // 再进行关闭房间操作
        if ([self currentUserIsOnMic]) {
            // 用户下麦
            [GetCore(RoomQueueCoreV2) downMic];
        };

        // 关闭房间
        // 如果在房间内时
        if (GetCore(RoomCoreV2).isInRoom) {

            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t) (0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self dismissChannelViewWithQuitCurrentRoom:YES animation:YES];
            });
        };
        
        [TTPopup dismiss];
    };
    
    TTPopupService *service = [[TTPopupService alloc] init];
    service.shouldDismissOnBackgroundTouch = NO;
    service.contentView = teenagerModeAlertView;
    service.style = TTPopupStyleAlert;
    
    [TTPopup popupWithConfig:service];
}

/**
 * 当前用户是否在麦上
 * @return 是否
 */
- (BOOL)currentUserIsOnMic {
    return [GetCore(RoomQueueCoreV2) isOnMicro:[GetCore(AuthCore).getUid userIDValue]];
}


@end
