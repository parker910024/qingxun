//
//  TTWkGameViewController.m
//  TuTu
//
//  Created by new on 2019/1/14.
//  Copyright © 2019 YiZhuan. All rights reserved.
//

#import "TTWkGameViewController.h"
#import <WebKit/WebKit.h>
#import <Masonry/Masonry.h>
#import "XCMacros.h"
#import "RoomCoreV2.h"
#import "ImRoomCoreV2.h"
#import "ImMessageCore.h"
#import "RoomQueueCoreV2.h"
#import "AuthCore.h"
#import "CPGameCore.h"
#import "UserCore.h"
#import "XCHUDTool.h"
#import "CPGameCoreClient.h"
#import "UIColor+UIColor_Hex.h"
#import "UIImageView+QiNiu.h"
#import "XCTheme.h"
#import "UIButton+EnlargeTouchArea.h"
#import "MeetingCore.h"
#import "ImRoomCoreClientV2.h"
#import "XCMediator.h"
#import "TTCPGameCustomModel.h"
#import "TTCPGameCustomInfo.h"
#import "TTCPGamePrivateChatCore.h"
#import "TTGameStaticTypeCore.h"
#import "XCMediator+TTDiscoverModuleBridge.h"

#import "XCShareView.h"
#import "TTGameInformationModel.h"
#import "TTCPGamePrivateChatClient.h"
#import "TTCPGameOverAndSelectClient.h"
#import "ShareCore.h"
#import "MentoringShipCore.h"
#import "UIView+NTES.h"
#import "TTPopup.h"

#import "TTWKGameStartView.h" // 游戏开始的对战信息View
#import "TTWKGameCloseView.h" // 左下角的关闭按钮
#import "TTGameExitAlertView.h" // 认输退出的弹窗
#import "TTWKGameOverView.h" // 游戏结束的View
#import "TTWKGameFaceView.h" // 表情View
#import "TTFaceAnimationView.h" // 表情动画View
#import "TTFaceFlyView.h"

typedef enum : NSUInteger {
    TTGameOverSelect_Again = 1, // 再来一局
    TTGameOverSelect_ChangeGame = 2, // 换个游戏
    TTGameOverSelect_Agree_AgainGame = 3, // 同意再来一局
    TTGameOverSelect_Level = 4, // 离开
} TTGameOverSelectType;


typedef enum : NSUInteger {
    TTGameOverShared_Win = 1, // 胜利
    TTGameOverShared_Lose = 2, // 失败
    TTGameOverShared_draw = 3, // 平局
} TTGameOverSharedType;


@interface TTWkGameViewController ()<TTWKGameOverViewDelegate,XCShareViewDelegate,TTWKGameCloseViewDelegate,TTWKGameOverViewDelegate,TTWKGameStartViewDelegate,TTWKGameFaceViewDelgate>{
    BOOL showWatchBtn;
}

@property (nonatomic, strong) NSMutableDictionary *resultDict;
@property (nonatomic, strong) TTWKGameStartView *gameStartView;
@property (nonatomic, strong) TTWKGameCloseView *closeView;
@property (nonatomic, strong) TTWKGameOverView *gameOverView;
@property (nonatomic, strong) TTWKGameFaceView *faceView;
@property (nonatomic, strong) TTFaceAnimationView *faceAnimationView;
@property (nonatomic, strong) NSString *sharePictureString;
@property (nonatomic, strong) NSMutableDictionary *gameStartDict;
@property (nonatomic, assign) int gameOverType;

@end

@implementation TTWkGameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.hiddenNavBar = YES;
    
    AddCoreClient(TTCPGameOverAndSelectClient, self);
    AddCoreClient(CPGameCoreClient, self);
    
    self.urlString = self.gameUrlString;
    
    [self changeWebViewFrame];
}

- (void)changeWebViewFrame{
    if ([self.superviewType isEqualToString:@"publicChat"]){
        if (self.watching) {
            [GetCore(MeetingCore) setCloseMicro:YES];
        }
    }
    if (@available(iOS 11.0, *)) {
        self.webview.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    [self.webview mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
    }];
    
    self.closeView = [[TTWKGameCloseView alloc] initWithFrame:CGRectMake(15, KScreenHeight - (20 + kSafeAreaBottomHeight + 39), 150, 39)];
    self.closeView.delegate = self;
    [self.view addSubview:self.closeView];
}

#pragma mark -- TTWKGameCloseView Delgate --- 
- (void)closeCurrentPage {
    
    if (self.watching) {
        if ([self.superviewType isEqualToString:@"publicChat"]) {
            [GetCore(MeetingCore) leaveMeeting:self.gameStartDict[@"uidLeft"]];
            [GetCore(MeetingCore) leaveMeeting:self.gameStartDict[@"uidRight"]];
        }
        [self.navigationController popViewControllerAnimated:YES];
        
    } else {
        
        TTGameExitAlertView *alertView = [[TTGameExitAlertView alloc] initWithFrame:CGRectMake(0, 0, 295, 173) title:@"提示" message:@"退出则为认输" cancel:^{
            
            [TTPopup dismiss];

            [self ThrowInTheTowel];
            
            [[BaiduMobStat defaultStat] logEvent:@"h5_gamepage_giveup_click"
                                      eventLabel:@"认输退出"];
        } ensure:^{
            [TTPopup dismiss];
        }];
        
        [TTPopup popupView:alertView style:TTPopupStyleAlert];
    }
}

- (void)changeVoiceCurrentPage{
    NSString *js = [NSString stringWithFormat:@"mute()"];
    [self.webview evaluateJavaScript:js completionHandler:^(id _Nullable other, NSError * _Nullable error) {
    }];
}

- (void)helpWithCurrentPage{
    NSString *js = [NSString stringWithFormat:@"intro()"];
    [self.webview evaluateJavaScript:js completionHandler:^(id _Nullable other, NSError * _Nullable error) {
    }];
}


- (void)ThrowInTheTowel{
    NSString *js = [NSString stringWithFormat:@"surrender()"];
    [self.webview evaluateJavaScript:js completionHandler:^(id _Nullable other, NSError * _Nullable error) {
        NSString *robotId = [[NSUserDefaults standardUserDefaults] objectForKey:@"Robot"];
        if ([robotId integerValue] > 0) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                [GetCore(RoomQueueCoreV2) removeChatroomQueueWithPosition:@"0" uid:[robotId userIDValue] success:^(BOOL success) {
                    [GetCore(ImRoomCoreV2) kickUser:robotId.userIDValue];
                } failure:^(NSString *message) {
                    [GetCore(ImRoomCoreV2) kickUser:robotId.userIDValue];
                }];
            });
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            if ([self.superviewType isEqualToString:@"room"]) {
                [self.navigationController popViewControllerAnimated:YES];
                return;
            }
            NSDictionary *dict = @{@"gameType":@(TTGameOverSelect_Level)};
            NSError *parseError = nil;
            NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:&parseError];
            NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
            
            NSString *opponentID;
            NIMCustomSystemNotification *notification = [[NIMCustomSystemNotification alloc] initWithContent:jsonString];
            
            if ([self.gameStartDict[@"uidLeft"] userIDValue] == GetCore(AuthCore).getUid.userIDValue) {
                opponentID = [NSString stringWithFormat:@"%@",self.gameStartDict[@"uidRight"]];
            }else{
                opponentID = [NSString stringWithFormat:@"%@",self.gameStartDict[@"uidLeft"]];
            }
            
            NIMSession *session = [NIMSession session:opponentID type:NIMSessionTypeP2P];
            
            [[NIMSDK sharedSDK].systemNotificationManager sendCustomNotification:notification toSession:session completion:nil];
            
            if ([self.superviewType isEqualToString:@"privateChat"] || [self.superviewType isEqualToString:@"publicChat"]) {
                if (!GetCore(RoomCoreV2).isInRoom){
                    [GetCore(MeetingCore) leaveMeeting:self.gameStartDict[@"uidLeft"]];
                    [GetCore(MeetingCore) leaveMeeting:self.gameStartDict[@"uidRight"]];
                    [GetCore(MeetingCore) setCloseMicro:YES];
                }
            }
            [self.navigationController popViewControllerAnimated:YES];
        });
    }];
}

- (void)h5ReturnGameShows:(WKScriptMessage *)message{
    
    TTGameInformationModel *model = [TTGameInformationModel modelWithJSON:message.body];
    NSString *pkType = model.result[@"pkType"];
    NSString *drawString = model.result[@"resultType"];
    
    if (self.watching){
        if ([self.superviewType isEqualToString:@"publicChat"]) {
            [GetCore(MeetingCore) leaveMeeting:model.result[@"roomId"]];
        }
        [self.navigationController popViewControllerAnimated:YES];
        return;
    }
    
    self.resultDict = [NSMutableDictionary dictionary];
    [self.resultDict setDictionary:model.result];
    
    if ([pkType isEqualToString:@"pk_1v1"]) {
        if ([drawString isEqualToString:@"not_draw"]) {
            NSString *winnerUid = [model.result[@"winners"] safeObjectAtIndex:0][@"uid"];
            
            NSString *robotId = [[NSUserDefaults standardUserDefaults] objectForKey:@"Robot"];
            
            if (![self.superviewType isEqualToString:@"room"]) {
                self.gameOverView = [[TTWKGameOverView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight)];
                self.gameOverView.superViewType = self.superviewType;
                self.gameOverView.dataDict = model.result;
                self.gameOverView.delegate = self;
                [self.view addSubview:self.gameOverView];
            }
            
            if (GetCore(AuthCore).getUid.userIDValue == winnerUid.userIDValue) {
                TTCPGameCustomInfo *gameInfo = [TTCPGameCustomInfo modelWithJSON:model.result];
                // 房间进来的游戏才改变游戏状态
                // 游戏结束统计
                if ([self.superviewType isEqualToString:@"room"]) {
                    
                    TTCPGameCustomModel *cpAtt = [[TTCPGameCustomModel alloc] init];
                    cpAtt.nick = [GetCore(UserCore) getUserInfoInDB:GetCore(AuthCore).getUid.userIDValue].nick;
                    cpAtt.gameResultInfo = gameInfo;
                    
                    [self CPRoomGameOverDetailWithModel:cpAtt WithGameInfoModel:model];
                    
                    NotifyCoreClient(CPGameCoreClient, @selector(gameOverAndWuSueecss:), gameOverAndWuSueecss:[cpAtt model2dictionary]);
                    
                    [self.navigationController popViewControllerAnimated:YES];
                }else if ([self.superviewType isEqualToString:@"publicRoom"]) {
                    
                    TTCPGameCustomModel *cpAtt = [[TTCPGameCustomModel alloc] init];
                    cpAtt.nick = [GetCore(UserCore) getUserInfoInDB:GetCore(AuthCore).getUid.userIDValue].nick;
                    cpAtt.gameResultInfo = gameInfo;
                    
                    Attachment *attachement = [[Attachment alloc]init];
                    attachement.first = Custom_Noti_Header_CPGAME;
                    attachement.second = Custom_Noti_Sub_CPGAME_End;
                    attachement.data = [cpAtt model2dictionary];
                    [GetCore(ImMessageCore) sendCustomMessageAttachement:attachement sessionId:[NSString stringWithFormat:@"%ld",(long)GetCore(ImRoomCoreV2).currentRoomInfo.roomId] type:NIMSessionTypeChatroom];
                    
                    // 多人房 游戏结束，统计
                    NotifyCoreClient(TTCPGamePrivateChatClient, @selector(gameOverFromNormalRoomChat:), gameOverFromNormalRoomChat:[model model2dictionary]);
                }else if ([self.superviewType isEqualToString:@"publicChat"]) {
                    // 公聊大厅 游戏结束的返回都走这里
                    NotifyCoreClient(TTCPGamePrivateChatClient, @selector(gameOverFromPublicChat:), gameOverFromPublicChat:[model model2dictionary]);
                }else if ([self.superviewType isEqualToString:@"privateChat"]){
                    //                    私聊 游戏结束的返回都走这里
                    NotifyCoreClient(TTCPGamePrivateChatClient, @selector(gameOverFromPrivateChat:), gameOverFromPrivateChat:[model model2dictionary]);
                }
            }else if (GetCore(AuthCore).getUid.userIDValue != winnerUid.userIDValue && [robotId integerValue] > 0){
                
                if (![self.superviewType isEqualToString:@"room"]) {
                    self.gameOverView = [[TTWKGameOverView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight)];
                    self.gameOverView.superViewType = self.superviewType;
                    self.gameOverView.dataDict = model.result;
                    self.gameOverView.delegate = self;
                    [self.view addSubview:self.gameOverView];
                }
                
                if ([self.superviewType isEqualToString:@"room"]) {
                    // 当你的对手是机器人，并且你输了。那么机器人将不会发送自定义云信自定义通知，这个地方不能有赢的人来发了，只能由玩家，也就是你发送自定义通知
                    TTCPGameCustomInfo *gameInfo = [TTCPGameCustomInfo modelWithJSON:model.result];
                    
                    TTCPGameCustomModel *cpAtt = [[TTCPGameCustomModel alloc] init];
                    cpAtt.nick = [GetCore(UserCore) getUserInfoInDB:GetCore(AuthCore).getUid.userIDValue].nick;
                    cpAtt.gameResultInfo = gameInfo;
                    
                    [self CPRoomGameOverDetailWithModel:cpAtt WithGameInfoModel:model];
                    
                    NotifyCoreClient(CPGameCoreClient, @selector(gamefailerAction:), gamefailerAction:cpAtt);
                    
                    [self.navigationController popViewControllerAnimated:YES];
                    
                }
            }else{
                if ([self.superviewType isEqualToString:@"room"]) {
                    [self.navigationController popViewControllerAnimated:YES];
                }
            }
        }else{
            if (![self.superviewType isEqualToString:@"room"]) {
                self.gameOverView = [[TTWKGameOverView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight)];
                self.gameOverView.superViewType = self.superviewType;
                self.gameOverView.dataDict = model.result;
                self.gameOverView.delegate = self;
                [self.view addSubview:self.gameOverView];
            }
            if ([self.superviewType isEqualToString:@"room"]) {
                if ([[model.result[@"users"] safeObjectAtIndex:0][@"uid"] userIDValue] == GetCore(AuthCore).getUid.userIDValue) {
                    
                    TTCPGameCustomInfo *gameInfo = [TTCPGameCustomInfo modelWithJSON:model.result];
                    
                    TTCPGameCustomModel *cpAtt = [[TTCPGameCustomModel alloc] init];
                    cpAtt.nick = [GetCore(UserCore) getUserInfoInDB:GetCore(AuthCore).getUid.userIDValue].nick;
                    cpAtt.gameResultInfo = gameInfo;
                    
                    [self CPRoomGameOverDetailWithModel:cpAtt WithGameInfoModel:model];
                    
                    NotifyCoreClient(CPGameCoreClient, @selector(gameOverAndNobodyWin:), gameOverAndNobodyWin:[cpAtt model2dictionary]);
                    
                    [self.navigationController popViewControllerAnimated:YES];
                }else{
                    [self.navigationController popViewControllerAnimated:YES];
                }
            }else if ([self.superviewType isEqualToString:@"publicRoom"]){
                if ([[model.result[@"users"] safeObjectAtIndex:0][@"uid"] userIDValue] == GetCore(AuthCore).getUid.userIDValue) {
                    
                    TTCPGameCustomInfo *gameInfo = [TTCPGameCustomInfo modelWithJSON:model.result];
                    
                    TTCPGameCustomModel *cpAtt = [[TTCPGameCustomModel alloc] init];
                    cpAtt.nick = [GetCore(UserCore) getUserInfoInDB:GetCore(AuthCore).getUid.userIDValue].nick;
                    cpAtt.gameResultInfo = gameInfo;
                    
                    Attachment *attachement = [[Attachment alloc]init];
                    attachement.first = Custom_Noti_Header_CPGAME;
                    attachement.second = Custom_Noti_Sub_CPGAME_End;
                    attachement.data = [cpAtt model2dictionary];
                    [GetCore(ImMessageCore) sendCustomMessageAttachement:attachement sessionId:[NSString stringWithFormat:@"%ld",(long)GetCore(ImRoomCoreV2).currentRoomInfo.roomId] type:NIMSessionTypeChatroom];
                    
                    NotifyCoreClient(TTCPGamePrivateChatClient, @selector(gameOverFromNormalRoomChat:), gameOverFromNormalRoomChat:[model model2dictionary]);
                }
            }else if ([self.superviewType isEqualToString:@"privateChat"]){
                if ([[model.result[@"users"] safeObjectAtIndex:0][@"uid"] userIDValue] == GetCore(AuthCore).getUid.userIDValue) {
                    NotifyCoreClient(TTCPGamePrivateChatClient, @selector(gameOverFromPrivateChat:), gameOverFromPrivateChat:[model model2dictionary]);
                }
            }else if ([model.result[@"roomId"] userIDValue] == GetCore(AuthCore).getUid.userIDValue) {
                NotifyCoreClient(TTCPGamePrivateChatClient, @selector(gameOverFromPublicChat:), gameOverFromPublicChat:[model model2dictionary]);
            }else{
                //                [self.navigationController popViewControllerAnimated:YES];
            }
        }
    }
}


- (void)CPRoomGameOverDetailWithModel:(TTCPGameCustomModel *)cpAttModel WithGameInfoModel:(TTGameInformationModel *)model{
    // 改变房间游戏状态
    [[GetCore(CPGameCore) requestGameRoomid:GetCore(RoomCoreV2).getCurrentRoomInfo.uid WithGameStatus:1 GameId:@"" gameName:@"" StartUid:@""] subscribeError:^(NSError *error) {
    }];
    
    // 游戏结束之后的统计
    @KWeakify(self);
    [[GetCore(CPGameCore) requestGameOverGameResult:[self dictionaryToJson:[model model2dictionary]]] subscribeError:^(NSError *error) {
        @KStrongify(self);
        [XCHUDTool showErrorWithMessage:error.domain inView:self.view];
    }];
    
    Attachment *attachement = [[Attachment alloc]init];
    attachement.first = Custom_Noti_Header_CPGAME;
    attachement.second = Custom_Noti_Sub_CPGAME_End;
    attachement.data = [cpAttModel model2dictionary];
    [GetCore(ImMessageCore) sendCustomMessageAttachement:attachement sessionId:[NSString stringWithFormat:@"%ld",(long)GetCore(ImRoomCoreV2).currentRoomInfo.roomId] type:NIMSessionTypeChatroom];
}

#pragma mark --- 游戏开始了，返回的两个头像数据  ---
- (void)gameStarth5ReturnGameShows:(WKScriptMessage *)message{
    
    NSString *js = [NSString stringWithFormat:@"hideButton()"];
    [self.webview evaluateJavaScript:js completionHandler:^(id _Nullable other, NSError * _Nullable error) {
    }];

    TTGameInformationModel *model = [TTGameInformationModel modelWithJSON:message.body];
    
    self.gameStartDict = [NSMutableDictionary dictionaryWithDictionary:[model model2dictionary]];
    
    if (self.gameStartView) {
        [self.gameStartView removeFromSuperview];
        
    }
    self.gameStartView = [[TTWKGameStartView alloc] initWithFrame:CGRectMake(17, statusbarHeight + 10, KScreenWidth - 17 * 2, 55)];
    self.gameStartView.watching = self.watching;
    self.gameStartView.dataModel = model;
    if (!self.watching){
        showWatchBtn = YES;
    }else {
        showWatchBtn = NO;
    }
    self.gameStartView.hiddenWatchBtnBool = showWatchBtn;
    self.gameStartView.delegate = self;
    [self.view addSubview:self.gameStartView];
    
    
    if (!self.watching) {
        
        if (self.faceView) {
            [self.faceView removeFromSuperview];
        }
        self.faceView =  [[TTWKGameFaceView alloc] initWithFrame:CGRectMake(KScreenWidth - 13 - 150, KScreenHeight - (20 + kSafeAreaBottomHeight + 44), 150, 44)];
        self.faceView.dataModel = model;
        self.faceView.delegate = self;
        [self.view addSubview:self.faceView];
    }
    
}

- (void)sendFaceWithImageString:(NSString *)imageString WithObj:(TTWKGameFaceView *)object {
    
    TTFaceAnimationView *aniView = [self.view viewWithTag:1011];
    if (!aniView) {
        TTFaceAnimationView *faceAnimationView = [[TTFaceAnimationView alloc] initWithFrame:CGRectMake(12 + 20, statusbarHeight + 10 + 7, 200, 150)];
        faceAnimationView.backgroundColor = UIColor.clearColor;
        faceAnimationView.tag = 1011;
        [self.view addSubview:faceAnimationView];
        aniView = faceAnimationView;
    }

    TTFaceFlyView *flyView = [[TTFaceFlyView alloc] initWithFrame:CGRectMake(0, 5, 40, 40)];
    flyView.imageString = imageString;
    [aniView addSubview:flyView];
    
    [flyView animateInView:aniView withDirection:YES];
}

#pragma mark --- 收到对方发来的表情 ---
- (void)receiveAnotherOneSendFaceAcitonWithFaceString:(NSString *)faceString {
    TTFaceAnimationView *aniView = [self.view viewWithTag:1012];
    if (!aniView) {
        TTFaceAnimationView *faceAnimationView = [[TTFaceAnimationView alloc] initWithFrame:CGRectMake(KScreenWidth - (12 + 20 + 200), statusbarHeight + 10 + 7, 200, 150)];
        faceAnimationView.backgroundColor = UIColor.clearColor;
        faceAnimationView.tag = 1012;
        aniView = faceAnimationView;
        [self.view addSubview:faceAnimationView];
    }
    TTFaceFlyView *flyView = [[TTFaceFlyView alloc] initWithFrame:CGRectMake(aniView.width - 40, 5, 40, 40)];
    flyView.imageString = faceString;
    [aniView addSubview:flyView];
    
    [flyView animateInView:aniView withDirection:NO];
}

#pragma mark ---  当其中一个人异常退出时，这个人默认就是回到游戏选择页面，不管是什么异常，对方胜利  ---
- (void)gameAbnormalOverReturnGameShows:(WKScriptMessage *)message {
    if (self.watching) {
        [self.navigationController popViewControllerAnimated:YES];
        
        NSString *urlStr = [NSString stringWithFormat:@""];
        
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlStr]];
        
        [self.webview loadRequest:request];
    }else{
        NSString *robotId = [[NSUserDefaults standardUserDefaults] objectForKey:@"Robot"];
        if ([robotId integerValue] > 0) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                if ([[GetCore(ImRoomCoreV2).micQueue allKeys] count] == 2){
                    for (int i = 0; i < 2; i++) {
                        ChatRoomMicSequence *sequence = [GetCore(ImRoomCoreV2).micQueue objectForKey:[NSString stringWithFormat:@"%d",i - 1]];
                        if (sequence.userInfo.uid == robotId.userIDValue) {
                            //                            [GetCore(RoomQueueCoreV2) kickDownMic:robotId.userIDValue position:i - 1];
                            [GetCore(RoomQueueCoreV2) removeChatroomQueueWithPosition:[NSString stringWithFormat:@"%d",i - 1] uid:robotId.userIDValue success:^(BOOL success) {
                            } failure:^(NSString *message) {
                                
                            }];
                        }
                    }
                }
                [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"Robot"];
                [[NSUserDefaults standardUserDefaults] synchronize];
            });
        }
        
        if ([self.superviewType isEqualToString:@"room"]) {
            NotifyCoreClient(CPGameCoreClient, @selector(gameOverForAbnormalReturnSelectPage), gameOverForAbnormalReturnSelectPage);
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            NSDictionary *dict = @{@"gameType":@(TTGameOverSelect_Level)};
            NSError *parseError = nil;
            NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:&parseError];
            NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
            
            NSString *opponentID;
            NIMCustomSystemNotification *notification = [[NIMCustomSystemNotification alloc] initWithContent:jsonString];
            
            if ([self.gameStartDict[@"uidLeft"] userIDValue] == GetCore(AuthCore).getUid.userIDValue) {
                opponentID = [NSString stringWithFormat:@"%@",self.gameStartDict[@"uidRight"]];
            }else{
                opponentID = [NSString stringWithFormat:@"%@",self.gameStartDict[@"uidLeft"]];
            }
            
            NIMSession *session = [NIMSession session:opponentID type:NIMSessionTypeP2P];
            
            [[NIMSDK sharedSDK].systemNotificationManager sendCustomNotification:notification toSession:session completion:nil];
            
            [self.navigationController popViewControllerAnimated:YES];
        }
        
        NSString *urlStr = [NSString stringWithFormat:@""];
        
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlStr]];
        
        [self.webview loadRequest:request];
    }
}

// 游戏开始之后，是否显示切换观战按钮
- (void)gameStartAndWhetherShowWatchBtn:(WKScriptMessage *)message{
    if (!self.watching){
        showWatchBtn = YES;
    }else {
        showWatchBtn = NO;
    }
}

// 切换观战视角
- (void)switchChangeWatch{
    NSString *js = [NSString stringWithFormat:@"changeWatch()"];
    [self.webview evaluateJavaScript:js completionHandler:^(id _Nullable other, NSError * _Nullable error) {
    }];
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    GetCore(TTGameStaticTypeCore).acceptGameFromNormalRoom = NO;
    GetCore(MentoringShipCore).isHideGrabApprenticeHint = YES;
    [self.navigationController setNavigationBarHidden:YES];
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self.navigationController setNavigationBarHidden:NO];
    GetCore(MentoringShipCore).isHideGrabApprenticeHint = NO;
    if([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    };
    [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"outOfMatchEnterYouRoom"];
    [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"outOfMatchEnterMyRoom"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
}

- (void)shareView:(XCShareView *)shareView didSelected:(XCShareItemTag)itemTag{
    SharePlatFormType sharePlatFormType;
    
    [TTPopup dismiss];

    switch (itemTag) {
        case XCShareItemTagAppFriends:
            sharePlatFormType = Share_Platfrom_Type_Within_Application;
            break;
        case XCShareItemTagMoments:
            sharePlatFormType = Share_Platform_Type_Wechat_Circle;
            break;
        case XCShareItemTagWeChat:
            sharePlatFormType = Share_Platform_Type_Wechat;
            break;
        case XCShareItemTagQQZone:
            sharePlatFormType = Share_Platform_Type_QQ_Zone;
            break;
        case XCShareItemTagQQ:
            sharePlatFormType = Share_Platform_Type_QQ;
            break;
        default:
            sharePlatFormType = Share_Platform_Type_Wechat_Circle;
            break;
    }
    [self handleShare:sharePlatFormType];
}

- (void)shareViewDidClickCancle:(XCShareView *)shareView{
    [TTPopup dismiss];
}

- (void)handleShare:(SharePlatFormType)platform{
    
    if ([self.superviewType isEqualToString:@"room"]) {
        [[BaiduMobStat defaultStat]logEvent:@"cp_room_game_share_way" eventLabel:@"选择分享渠道"];
    }else if ([self.superviewType isEqualToString:@"publicRoom"]){
        [[BaiduMobStat defaultStat]logEvent:@"mp_room_game_share_way" eventLabel:@"选择分享渠道"];
    }else if ([self.superviewType isEqualToString:@"publicChat"]){
        [[BaiduMobStat defaultStat]logEvent:@"public_chat_game_share_way" eventLabel:@"选择分享渠道"];
    }else if ([self.superviewType isEqualToString:@"privateChat"]){
        [[BaiduMobStat defaultStat]logEvent:@"private_chat_game_share_way" eventLabel:@"选择分享渠道"];
    }
    
    
    if (platform == Share_Platfrom_Type_Within_Application) {
        ShareModelInfor * model = [[ShareModelInfor alloc] init];
        model.currentVC = self;
        model.roomInfor = GetCore(RoomCoreV2).getCurrentRoomInfo;
        model.shareType = Custom_Noti_Sub_Share_Room;
        [GetCore(ShareCore) reloadShareModel:model];
        GetCore(TTGameStaticTypeCore).shareRoomOrInviteType = TTShareRoomOrInviteFriendStatus_Share;
        UIViewController * controller = [[XCMediator sharedInstance] ttDiscoverMoudle_TTFamilyShareContainViewController];
        [self.navigationController pushViewController:controller animated:YES];
        
    }else{
        if ([self.resultDict[@"resultType"] isEqualToString:@"not_draw"]) {
            
            NSString *winnerUid = [self.resultDict[@"winners"] safeObjectAtIndex:0][@"uid"];
            if (GetCore(AuthCore).getUid.userIDValue == winnerUid.userIDValue) {
                self.gameOverType = TTGameOverShared_Win;
            }else{
                self.gameOverType = TTGameOverShared_Lose;
            }
        }else{
            self.gameOverType = TTGameOverShared_draw;
        }
        
        NSString *gameResultString = [NSString stringWithFormat:@"%d",self.gameOverType];
        
        [XCHUDTool showGIFLoadingInView:self.view];
        @KWeakify(self);
        [[GetCore(TTCPGamePrivateChatCore) requestSharePictureWith:[GetCore(UserCore) getUserInfoInDB:GetCore(AuthCore).getUid.userIDValue].avatar ErbanNo:[GetCore(UserCore) getUserInfoInDB:GetCore(AuthCore).getUid.userIDValue].erbanNo.userIDValue Nick:[GetCore(UserCore) getUserInfoInDB:GetCore(AuthCore).getUid.userIDValue].nick GameResult:gameResultString] subscribeNext:^(id x) {
            @KStrongify(self);
            [XCHUDTool hideHUDInView:self.view];
            [GetCore(ShareCore) shareH5WithTitle:@"" url:nil imgUrl:x desc:@"" platform:platform];
            
        } error:^(NSError *error) {
        }];
        
    }
    
}

// 分享
- (void)shareGameResultAction{
    
    if ([self.superviewType isEqualToString:@"room"]) {
        [[BaiduMobStat defaultStat]logEvent:@"cp_room_game_share" eventLabel:@"点击分享"];
    }else if ([self.superviewType isEqualToString:@"publicRoom"]){
        [[BaiduMobStat defaultStat]logEvent:@"mp_room_game_share" eventLabel:@"点击分享"];
    }else if ([self.superviewType isEqualToString:@"publicChat"]){
        [[BaiduMobStat defaultStat]logEvent:@"public_chat_game_share" eventLabel:@"点击分享"];
    }else if ([self.superviewType isEqualToString:@"privateChat"]){
        [[BaiduMobStat defaultStat]logEvent:@"private_chat_game_share" eventLabel:@"点击分享"];
    }
    
    CGSize itemSize = CGSizeMake((KScreenWidth-2*22)/4, 76);
    
    XCShareView *shareView = [[XCShareView alloc] initWithShareViewStyle:XCShareViewStyleCenterAndBottom items:[self getShareItems] itemSize:itemSize edgeInsets:UIEdgeInsetsMake(12, 22, 12, 22)];
    
    shareView.delegate = self;
    [TTPopup popupView:shareView style:TTPopupStyleActionSheet];
}


- (NSArray<XCShareItem *>*)getShareItems{
    
    BOOL installWeChat = [GetCore(ShareCore) isInstallWechat];
    BOOL installQQ = [GetCore(ShareCore) isInstallQQ];
    
    XCShareItem *tutuItem = [XCShareItem itemWitTag:XCShareItemTagAppFriends title:@"好友" imageName:@"share_friend" disableImageName:@"share_friend" disable:NO];
    
    XCShareItem *momentItem = [XCShareItem itemWitTag:XCShareItemTagMoments title:@"朋友圈" imageName:@"share_wxcircle" disableImageName:@"share_wxcircle_disable" disable:!installWeChat];
    XCShareItem *weChatItem = [XCShareItem itemWitTag:XCShareItemTagWeChat title:@"微信好友" imageName:@"share_wx" disableImageName:@"share_wx_disable" disable:!installWeChat];
    XCShareItem *qqZoneItem = [XCShareItem itemWitTag:XCShareItemTagQQZone title:@"QQ空间" imageName:@"share_qqzone" disableImageName:@"share_qqzone_disable" disable:!installQQ];
    XCShareItem *qqItem = [XCShareItem itemWitTag:XCShareItemTagQQ title:@"QQ好友" imageName:@"share_qq" disableImageName:@"share_qq_disable" disable:!installQQ];
    
    if ([self.superviewType isEqualToString:@"room"] || [self.superviewType isEqualToString:@"publicRoom"]) {
        // 在房间呢
        return @[tutuItem,momentItem,weChatItem,qqZoneItem,qqItem];
    }else{
        return @[momentItem,weChatItem,qqZoneItem,qqItem];
    }
    
}

// 再来一局
- (void)againGameActionHander{
    
    if ([self.gameOverView.ageinGameButton.titleLabel.text isEqualToString:@"对方已准备，马上再战"]) {
        
        NSDictionary *dict = @{@"gameType":@(TTGameOverSelect_Agree_AgainGame)};
        NSError *parseError = nil;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:&parseError];
        NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        
        NSString *opponentID;
        NSString *nickString;
        NIMCustomSystemNotification *notification = [[NIMCustomSystemNotification alloc] initWithContent:jsonString];
        
        
        if ([[self.resultDict[@"users"] safeObjectAtIndex:0][@"uid"] userIDValue] == GetCore(AuthCore).getUid.userIDValue) {
            opponentID = [NSString stringWithFormat:@"%@",[self.resultDict[@"users"] safeObjectAtIndex:1][@"uid"]];
            
            nickString = [NSString stringWithFormat:@"%@",[self.resultDict[@"users"] safeObjectAtIndex:0][@"name"]];
        }else{
            opponentID = [NSString stringWithFormat:@"%@",[self.resultDict[@"users"] safeObjectAtIndex:0][@"uid"]];
            
            nickString = [NSString stringWithFormat:@"%@",[self.resultDict[@"users"] safeObjectAtIndex:1][@"name"]];
        }
        
        NIMSession *session = [NIMSession session:opponentID type:NIMSessionTypeP2P];
        
        [[NIMSDK sharedSDK].systemNotificationManager sendCustomNotification:notification toSession:session completion:nil];
        @KWeakify(self);
        [[GetCore(CPGameCore) requestGameUrlFromGamePageUid:GetCore(AuthCore).getUid.userIDValue Name:nickString Roomid:[self.resultDict[@"roomId"] userIDValue] GameId:self.resultDict[@"gameId"] ChannelId:self.resultDict[@"channelId"] AiUId:0] subscribeError:^(NSError *error) {
            @KStrongify(self);
            [XCHUDTool showErrorWithMessage:error.domain inView:self.view];
        }];
        
    }else{
        if ([self.superviewType isEqualToString:@"room"]) {
            [[BaiduMobStat defaultStat]logEvent:@"cp_room_game__again" eventLabel:@"点击再来一局"];
        }else if ([self.superviewType isEqualToString:@"publicRoom"]){
            [[BaiduMobStat defaultStat]logEvent:@"mp_room_game_again" eventLabel:@"点击再来一局"];
        }else if ([self.superviewType isEqualToString:@"publicChat"]){
            [[BaiduMobStat defaultStat]logEvent:@"public_chat_game_again" eventLabel:@"点击再来一局"];
        }else if ([self.superviewType isEqualToString:@"privateChat"]){
            [[BaiduMobStat defaultStat]logEvent:@"private_chat_game_again" eventLabel:@"点击再来一局"];
        }
        
        self.gameOverView.ageinGameButton.backgroundColor = UIColorFromRGB(0xBABABA);
        
        [self.gameOverView.ageinGameButton setTitle:@"等待对方接受" forState:UIControlStateNormal];
        
        self.gameOverView.ageinGameButton.userInteractionEnabled = NO;
        
        NSDictionary *dict = @{@"gameType":@(TTGameOverSelect_Again)};
        NSError *parseError = nil;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:&parseError];
        NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        
        NSString *opponentID;
        NIMCustomSystemNotification *notification = [[NIMCustomSystemNotification alloc] initWithContent:jsonString];
        
        if ([[self.resultDict[@"users"] safeObjectAtIndex:0][@"uid"] userIDValue] == GetCore(AuthCore).getUid.userIDValue) {
            opponentID = [NSString stringWithFormat:@"%@",[self.resultDict[@"users"] safeObjectAtIndex:1][@"uid"]];
        }else{
            opponentID = [NSString stringWithFormat:@"%@",[self.resultDict[@"users"] safeObjectAtIndex:0][@"uid"]];
        }
        
        NIMSession *session = [NIMSession session:opponentID type:NIMSessionTypeP2P];
        
        [[NIMSDK sharedSDK].systemNotificationManager sendCustomNotification:notification toSession:session completion:nil];
    }
    
}

//  对方同意了再来一局
- (void)sendAgreePlayGameAgainAction{
    
    NSString *opponentID;
    NSString *nickString;
    
    if ([[self.resultDict[@"users"] safeObjectAtIndex:0][@"uid"] userIDValue] == GetCore(AuthCore).getUid.userIDValue) {
        opponentID = [NSString stringWithFormat:@"%@",[self.resultDict[@"users"] safeObjectAtIndex:1][@"uid"]];
        
        nickString = [NSString stringWithFormat:@"%@",[self.resultDict[@"users"] safeObjectAtIndex:0][@"name"]];
    }else{
        opponentID = [NSString stringWithFormat:@"%@",[self.resultDict[@"users"] safeObjectAtIndex:0][@"uid"]];
        
        nickString = [NSString stringWithFormat:@"%@",[self.resultDict[@"users"] safeObjectAtIndex:1][@"name"]];
    }
    
    @KWeakify(self);
    [[GetCore(CPGameCore) requestGameUrlFromGamePageUid:GetCore(AuthCore).getUid.userIDValue Name:nickString Roomid:[self.resultDict[@"roomId"] userIDValue] GameId:self.resultDict[@"gameId"] ChannelId:self.resultDict[@"channelId"] AiUId:0] subscribeError:^(NSError *error) {
        @KStrongify(self);
        [XCHUDTool showErrorWithMessage:error.domain inView:self.view];
    }];
}

// 收到再来一局的通知
- (void)receiveAgainGameAction{
    
    self.gameOverView.ageinGameButton.backgroundColor = UIColorFromRGB(0x24D7A7);
    [self.gameOverView.ageinGameButton setTitle:@"对方已准备，马上再战" forState:UIControlStateNormal];
}

//  进入游戏
- (void)onCPRoomGameUrlFromWebViewPage:(NSString *)gameUrlString{
    
    [self.gameOverView removeFromSuperview];
    
    if ([[[UIDevice currentDevice]systemVersion]intValue ] >= 9.0) {
        NSArray * types =@[WKWebsiteDataTypeMemoryCache,WKWebsiteDataTypeDiskCache]; // 9.0之后才有的
        NSSet *websiteDataTypes = [NSSet setWithArray:types];
        NSDate *dateFrom = [NSDate dateWithTimeIntervalSince1970:0];
        [[WKWebsiteDataStore defaultDataStore] removeDataOfTypes:websiteDataTypes modifiedSince:dateFrom completionHandler:^{
            
        }];
    }else{
        NSString *libraryPath = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory,NSUserDomainMask,YES) objectAtIndex:0];
        NSString *cookiesFolderPath = [libraryPath stringByAppendingString:@"/Cookies"];
        NSLog(@"%@", cookiesFolderPath);
        NSError *errors;
        [[NSFileManager defaultManager] removeItemAtPath:cookiesFolderPath error:&errors];
        
    }
    
    self.urlString = gameUrlString;
    
}

// 换个游戏
- (void)changGameActionHander{
    
    if ([self.superviewType isEqualToString:@"room"]) {
        [[BaiduMobStat defaultStat]logEvent:@"cp_room_game_newgame" eventLabel:@"点击换个游戏"];
    }else if ([self.superviewType isEqualToString:@"publicRoom"]){
        [[BaiduMobStat defaultStat]logEvent:@"mp_room_game_newgame" eventLabel:@"点击换个游戏"];
    }else if ([self.superviewType isEqualToString:@"publicChat"]){
        [[BaiduMobStat defaultStat]logEvent:@"public_chat_game_newgame" eventLabel:@"点击换个游戏"];
    }else if ([self.superviewType isEqualToString:@"privateChat"]){
        [[BaiduMobStat defaultStat]logEvent:@"private_chat_game_newgame" eventLabel:@"点击换个游戏"];
    }
    
    NSDictionary *dict = @{@"gameType":@(TTGameOverSelect_Level)};
    NSError *parseError = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:&parseError];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    NSString *opponentID;
    NSString *nickString;
    NIMCustomSystemNotification *notification = [[NIMCustomSystemNotification alloc] initWithContent:jsonString];
    
    if ([[self.resultDict[@"users"] safeObjectAtIndex:0][@"uid"] userIDValue] == GetCore(AuthCore).getUid.userIDValue) {
        opponentID = [NSString stringWithFormat:@"%@",[self.resultDict[@"users"] safeObjectAtIndex:1][@"uid"]];
        
        nickString = [NSString stringWithFormat:@"%@",[self.resultDict[@"users"] safeObjectAtIndex:0][@"name"]];
    }else{
        opponentID = [NSString stringWithFormat:@"%@",[self.resultDict[@"users"] safeObjectAtIndex:0][@"uid"]];
        
        nickString = [NSString stringWithFormat:@"%@",[self.resultDict[@"users"] safeObjectAtIndex:1][@"name"]];
    }
    
    NIMSession *session = [NIMSession session:opponentID type:NIMSessionTypeP2P];
    
    [[NIMSDK sharedSDK].systemNotificationManager sendCustomNotification:notification toSession:session completion:nil];
    
    if (self.clickButton) {
        self.clickButton(@"换个游戏",@"");
    }
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

// 换个对手
- (void)changePeopleActionHander{
    
    if ([self.superviewType isEqualToString:@"room"]) {
    }else if ([self.superviewType isEqualToString:@"publicRoom"]){
        [[BaiduMobStat defaultStat]logEvent:@"mp_room_game_newmatch" eventLabel:@"点击换个对手"];
    }else if ([self.superviewType isEqualToString:@"publicChat"]){
        [[BaiduMobStat defaultStat]logEvent:@"public_chat_game_newmatch" eventLabel:@"点击换个对手"];
    }else if ([self.superviewType isEqualToString:@"privateChat"]){
        
    }
    
    NSDictionary *dict = @{@"gameType":@(TTGameOverSelect_Level)};
    NSError *parseError = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:&parseError];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    NSString *opponentID;
    NSString *nickString;
    NIMCustomSystemNotification *notification = [[NIMCustomSystemNotification alloc] initWithContent:jsonString];
    
    if ([[self.resultDict[@"users"] safeObjectAtIndex:0][@"uid"] userIDValue] == GetCore(AuthCore).getUid.userIDValue) {
        opponentID = [NSString stringWithFormat:@"%@",[self.resultDict[@"users"] safeObjectAtIndex:1][@"uid"]];
        
        nickString = [NSString stringWithFormat:@"%@",[self.resultDict[@"users"] safeObjectAtIndex:0][@"name"]];
    }else{
        opponentID = [NSString stringWithFormat:@"%@",[self.resultDict[@"users"] safeObjectAtIndex:0][@"uid"]];
        
        nickString = [NSString stringWithFormat:@"%@",[self.resultDict[@"users"] safeObjectAtIndex:1][@"name"]];
    }
    
    NIMSession *session = [NIMSession session:opponentID type:NIMSessionTypeP2P];
    
    [[NIMSDK sharedSDK].systemNotificationManager sendCustomNotification:notification toSession:session completion:nil];
    
    if (self.clickButton) {
        self.clickButton(@"换个对手",[self.resultDict objectForKey:@"gameId"]);
    }
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

// 返回上一层
- (void)backMainPageAciton {
    
    if ([self.superviewType isEqualToString:@"room"]) {
        [[BaiduMobStat defaultStat]logEvent:@"cp_room_game_return" eventLabel:@"点击返回"];
    }else if ([self.superviewType isEqualToString:@"publicRoom"]){
        [[BaiduMobStat defaultStat]logEvent:@"mp_room_game_return" eventLabel:@"点击返回"];
    }else if ([self.superviewType isEqualToString:@"publicChat"]){
        [[BaiduMobStat defaultStat]logEvent:@"public_chat_game_return" eventLabel:@"点击返回"];
    }else if ([self.superviewType isEqualToString:@"privateChat"]){
        [[BaiduMobStat defaultStat]logEvent:@"private_chat_game_return" eventLabel:@"点击返回"];
    }
    
    NSDictionary *dict = @{@"gameType":@(TTGameOverSelect_Level)};
    NSError *parseError = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:&parseError];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    NSString *opponentID;
    NIMCustomSystemNotification *notification = [[NIMCustomSystemNotification alloc] initWithContent:jsonString];
    
    if ([[self.resultDict[@"users"] safeObjectAtIndex:0][@"uid"] userIDValue] == GetCore(AuthCore).getUid.userIDValue) {
        opponentID = [NSString stringWithFormat:@"%@",[self.resultDict[@"users"] safeObjectAtIndex:1][@"uid"]];
    }else{
        opponentID = [NSString stringWithFormat:@"%@",[self.resultDict[@"users"] safeObjectAtIndex:0][@"uid"]];
    }
    
    NIMSession *session = [NIMSession session:opponentID type:NIMSessionTypeP2P];
    
    [[NIMSDK sharedSDK].systemNotificationManager sendCustomNotification:notification toSession:session completion:nil];
    
    [self.navigationController popViewControllerAnimated:YES];
}

// 收到对方返回
- (void)receiveAnotherOneLiveGameAction{
    
    if (self.gameOverView) {
        self.gameOverView.ageinGameButton.backgroundColor = UIColorFromRGB(0xBABABA);
        [self.gameOverView.ageinGameButton setTitle:@"对方已返回" forState:UIControlStateNormal];
        
        self.gameOverView.ageinGameButton.userInteractionEnabled = NO;
        
        if ([self.superviewType isEqualToString:@"privateChat"] || [self.superviewType isEqualToString:@"publicChat"]) {
            if (!GetCore(RoomCoreV2).isInRoom){
                [GetCore(MeetingCore) leaveMeeting:self.resultDict[@"roomId"]];
                [GetCore(MeetingCore) setCloseMicro:YES];
            }
        }
        
    }else{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            self.gameOverView.ageinGameButton.backgroundColor = UIColorFromRGB(0xBABABA);
            [self.gameOverView.ageinGameButton setTitle:@"对方已返回" forState:UIControlStateNormal];
            
            self.gameOverView.ageinGameButton.userInteractionEnabled = NO;
            
            if ([self.superviewType isEqualToString:@"privateChat"] || [self.superviewType isEqualToString:@"publicChat"]) {
                if (!GetCore(RoomCoreV2).isInRoom){
                    [GetCore(MeetingCore) leaveMeeting:self.resultDict[@"roomId"]];
                    [GetCore(MeetingCore) setCloseMicro:YES];
                }
            }
        });
    }
}

- (NSString *)dictionaryToJson:(NSDictionary *)dict{
    NSError *error;
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:&error];
    
    NSString *jsonString;
    
    if (!jsonData) {
        NSLog(@"%@",error);
    } else {
        jsonString = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    
    NSMutableString *mutStr = [NSMutableString stringWithString:jsonString];

    return mutStr;
}

- (void)dealloc{
    NSLog(@"%s",__func__);
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */



@end
