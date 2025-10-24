//
//  TTPublicNIMChatroomController.m
//  TuTu
//
//  Created by 卫明 on 2018/11/11.
//  Copyright © 2018 YiZhuan. All rights reserved.
//

#import "TTPublicNIMChatroomController.h"

//const
#import "XCMacros.h"

//tool
#import "UIView+NIM.h"
#import "UITableView+NIMScrollToBottom.h"
#import <Masonry/Masonry.h>
#import "SVGAParserManager.h"
#import <POP.h>
#import "NSArray+Safe.h"
#import "NSMutableArray+Safe.h"
#import "XCCurrentVCStackManager.h"
#import <SDWebImage/SDImageCacheConfig.h>
#import <SDWebImage/SDWebImageDownloader.h>
#import <SDWebImage/SDImageCache.h>
#import "XCCurrentVCStackManager.h"
#import "XCHtmlUrl.h"

//core
#import "PublicChatroomCore.h"
#import "GiftCore.h"
#import "UserCore.h"
#import "ImMessageCore.h"
#import "AuthCore.h"

//client
#import "TTPublicChatroomMessageProtocol.h"
#import "BalanceErrorClient.h"
#import "PublicChatroomMessageClient.h"

//NIM
#import "NIMMessageMaker.h"

//config
#import "TTPublicChatRoomConfig.h"
#import "TTPublicChatUserCardFunctionItemConfig.h"

//view
#import "TTPublicGiftSpringView.h"
#import "TTUserCardContainerView.h"
#import "TTOpenNobleTipCardView.h"

//bridge
#import "XCMediator+TTPersonalMoudleBridge.h"
#import "XCMediator+TTMessageMoudleBridge.h"
#import "XCMediator+TTDiscoverModuleBridge.h"

//vc
#import "TTWKWebViewViewController.h"


#import "XCTheme.h"

//tool
#import <BaiduMobStatCodeless/BaiduMobStat.h>
#import "XCHUDTool.h"

#import "TTCPGamePrivateChatCore.h"
#import "TTCPGameCustomInfo.h"
#import "TTGameCPPrivateChatModel.h"
#import "XCCPGamePrivateAttachment.h"
#import "TTCPGamePrivateChatClient.h"
#import "PublicGameCache.h"
#import "XCCPGamePrivateSysNotiAttachment.h"
#import "TTGameCPPrivateSysNotiModel.h"
#import "ImMessageCore.h"
#import "ImPublicChatroomCore.h"
#import "TTCPGameStaticCore.h"
#import "TTCPGameOverAndSelectClient.h"
#import "CPGameCore.h"
#import "TTGameStaticTypeCore.h"

#import "XCMediator+TTDiscoverModuleBridge.h"
#import "TTPopup.h"
#import "TTStatisticsService.h"

static BOOL SDImageCacheOldShouldDecompressImages = YES;
static BOOL SDImagedownloderOldShouldDecompressImages = YES;


#define kGiftQueueScannerTime 0.3

@interface TTPublicNIMChatroomController ()
<
TTPublicChatInputViewDelegate,
TTPublicChatroomMessageProtocol,
TTOpenNobleTipCardViewDelegate,
BalanceErrorClient,
PublicChatroomMessageClient,
TTCPGameListViewDelegate
>


@property (nonatomic, assign) BOOL isPublicChat;

@property (strong, nonatomic) TTPublicChatRoomConfig *config;

@property (strong, nonatomic) UIButton *newMessageTips;

@property (strong, nonatomic) SVGAParserManager *parser;

@property (strong, nonatomic) NSMutableArray *giftAnimateQueue;

@property (strong, nonatomic) dispatch_source_t timer;

@property (nonatomic, assign) BOOL isAnimating;

@property (strong, nonatomic) NSMutableSet *springReusePool;

@property (strong, nonatomic) NSMutableSet *springVisablePool;

@property (strong, nonatomic) UIView *giftDisplayView;

// 游戏
@property (nonatomic, strong) UIButton *selectGameButton;

@end

@implementation TTPublicNIMChatroomController

- (instancetype)initWithSession:(NIMSession *)session isPublicChat:(BOOL)isPublicChat {
    if (self = [super initWithSession:session]) {
        _isPublicChat = isPublicChat;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupConfigurator:YES childVC:self];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(nimHadNewMessage:) name:@"NIM_HAS_NEW_MESAAGE" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(messageTableViewHadInBottom:) name:@"MESSAGETABLEVIEW_HAD_INBOTTOM" object:nil];
    // Do any additional setup after loading the view.
    [self initView];
    [self initConstrations];
    self.view.backgroundColor = UIColorFromRGB(0xf5f5f5);
    self.tableView.backgroundColor = UIColorFromRGB(0xf5f5f5);
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[BaiduMobStat defaultStat]logEvent:@"friendship_hall_click" eventLabel:@"进入交友大厅"];
    SDImageCacheConfig *config = [SDImageCache sharedImageCache].config;
    config.shouldDecompressImages = NO;
    
    SDWebImageDownloader *downloder = [SDWebImageDownloader sharedDownloader];
    SDImagedownloderOldShouldDecompressImages = downloder.shouldDecompressImages;
    downloder.shouldDecompressImages = NO;
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    self.listView.hidden = YES;
    if ([self.navigationController.viewControllers indexOfObject:self] == NSNotFound) {  // 点击左上角返回
        NSMutableDictionary *messsicDict = [[[PublicGameCache sharePublicGameCache] takeOutMyOwnMessagesWithUid:GetCore(AuthCore).getUid] mutableCopy];
        NSArray *allKeyArray = messsicDict.allKeys;
        NSMutableArray *gameDataArray = [NSMutableArray array];
        for (int i = 0; i < allKeyArray.count; i++) {
            NIMMessage *message = messsicDict[allKeyArray[i]];
            NIMCustomObject *obj = (NIMCustomObject *)message.messageObject;
            Attachment *attachment = (Attachment *)obj.attachment;
            TTGameCPPrivateChatModel *model = [TTGameCPPrivateChatModel modelDictionary:attachment.data];
            if (!message.localExt) {
                [gameDataArray addObject:message.messageId];
                model.status = TTGameStatusTypeInvalid;
                model.uuId = message.messageId;
                message.localExt = [model model2dictionary];
                [[PublicGameCache sharePublicGameCache] saveGameInfo:message];
                
                XCCPGamePrivateSysNotiAttachment *sysNotificaton = [[XCCPGamePrivateSysNotiAttachment alloc] init];
                sysNotificaton.first = Custom_Noti_Header_CPGAME_PublicChat_Respond;
                sysNotificaton.second = Custom_Noti_Sub_CPGAME_PublicChat_Respond_Cancel;
                sysNotificaton.data = [model model2dictionary];
                [GetCore(ImMessageCore) sendCustomMessageAttachement:sysNotificaton sessionId:[NSString stringWithFormat:@"%ld",GetCore(ImPublicChatroomCore).publicChatroomId] type:NIMSessionTypeChatroom];
                [self.listView destructionTimer];
                [messsicDict removeObjectForKey:allKeyArray[i]];
            }
        }
        [[PublicGameCache sharePublicGameCache] saveGameMessageFromMeInfo:messsicDict];
        
        if (gameDataArray.count > 0) {
            [[GetCore(TTCPGamePrivateChatCore) requestCancelGameInviteWith:GetCore(AuthCore).getUid.userIDValue MsgIds:[gameDataArray componentsJoinedByString:@","]] subscribeError:^(NSError *error) {
                [XCHUDTool showErrorWithMessage:error.domain];
            }];
        }
    }
}

- (void)initView {
    
    AddCoreClient(BalanceErrorClient, self);
    AddCoreClient(TTPublicChatroomMessageProtocol, self);
    AddCoreClient(PublicChatroomMessageClient, self);
    AddCoreClient(TTCPGamePrivateChatClient, self);
    AddCoreClient(TTCPGameOverAndSelectClient, self);
    // 进入公聊大厅, 请求下礼物列表(专属礼物)
    [GetCore(GiftCore) requestGiftListWithRoomUid:GetCore(ImPublicChatroomCore).publicChatroomUid];
    [self.view addSubview:self.newMessageTips];
    
    [self.view addSubview:self.selectGameButton];
    
    [self.view addSubview:self.listView];
    
    if (GetCore(TTCPGameStaticCore).gameSwitch){
        self.selectGameButton.hidden = NO;
    }else{
        self.selectGameButton.hidden = YES;
    }
    
    if (projectType() == ProjectType_Planet) { // hello处CP 不展示游戏
        self.selectGameButton.hidden = YES;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    [self reset];
}

- (void)initConstrations {
    [self.newMessageTips mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(111);
        make.height.mas_equalTo(41);
        make.trailing.mas_equalTo(self.view.mas_trailing);
        make.bottom.mas_equalTo(self.publicChatInputView.mas_top).offset(-12);
    }];
    
    [self.selectGameButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-9);
        make.bottom.mas_equalTo(self.publicChatInputView.mas_top).offset(-48);
        make.size.mas_equalTo(CGSizeMake(65, 65));
    }];
}

- (void)dealloc {
    RemoveCoreClientAll(self);
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    SDImageCacheConfig *config = [SDImageCache sharedImageCache].config;
    config.shouldDecompressImages = YES;
    
    SDWebImageDownloader *downloder = [SDWebImageDownloader sharedDownloader];
    downloder.shouldDecompressImages = SDImagedownloderOldShouldDecompressImages;
    [[SDImageCache sharedImageCache] clearMemory];
    
    [self reset];
}

#pragma mark - message event
- (void)nimHadNewMessage:(NSNotification *)noti {
    if (self.newMessageTips.hidden) {
        self.newMessageTips.hidden = NO;
    }
}

- (void)messageTableViewHadInBottom:(NSNotification *)noti {
    if (!self.newMessageTips.hidden) {
        self.newMessageTips.hidden = YES;
    }
}

#pragma mark - Touch Event
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    [_publicChatInputView endEditing:YES];
    
}


#pragma mark --- 选择游戏 ---
- (void)selectGameAction:(UIButton *)sender{
    [[BaiduMobStat defaultStat]logEvent:@"public_chat_game" eventLabel:@"点击游戏选择面板按钮"];
    
    [self.listView showListViewAndRefreshData];
    
}

- (void)clickItem:(CPGameListModel *)model{
    
    NSMutableDictionary *messageDict = [[[PublicGameCache sharePublicGameCache] takeOutMyOwnMessagesWithUid:GetCore(AuthCore).getUid] mutableCopy];
    NSArray *allKeyArray = messageDict.allKeys;
    for (int i = 0; i < allKeyArray.count; i++) {
        NIMMessage *message = messageDict[allKeyArray[i]];
        NIMCustomObject *obj = (NIMCustomObject *)message.messageObject;
        Attachment *attachment = (Attachment *)obj.attachment;
        TTGameCPPrivateChatModel *model = [TTGameCPPrivateChatModel modelDictionary:attachment.data];
        if (!message.localExt) {
            model.status = TTGameStatusTypeInvalid;
            model.uuId = message.messageId;
            message.localExt = [model model2dictionary];
            [[PublicGameCache sharePublicGameCache] saveGameInfo:message];
            [self uiUpdateMessage:message];
            XCCPGamePrivateSysNotiAttachment *sysNotificaton = [[XCCPGamePrivateSysNotiAttachment alloc] init];
            sysNotificaton.first = Custom_Noti_Header_CPGAME_PublicChat_Respond;
            sysNotificaton.second = Custom_Noti_Sub_CPGAME_PublicChat_Respond_Cancel;
            sysNotificaton.data = [model model2dictionary];
            [GetCore(ImMessageCore) sendCustomMessageAttachement:sysNotificaton sessionId:[NSString stringWithFormat:@"%ld",GetCore(ImPublicChatroomCore).publicChatroomId] type:NIMSessionTypeChatroom];
            [messageDict removeObjectForKey:allKeyArray[i]];
        }
    }
    [[PublicGameCache sharePublicGameCache] saveGameMessageFromMeInfo:messageDict];
    
    
    [[BaiduMobStat defaultStat]logEvent:@"public_chat_game_choice" eventLabel:@"点击选择游戏（公聊大厅）"];
    self.listView.hidden = YES;
    
    
    GetCore(TTCPGamePrivateChatCore).publicChatType = YES;
    
    NSDate* date = [NSDate dateWithTimeIntervalSinceNow:0];//获取当前时间0秒后的时间
    NSTimeInterval time = [date timeIntervalSince1970] * 1000;// * 1000 是精确到毫秒，不乘就是精确到秒
    NSString *timeString = [NSString stringWithFormat:@"%.0f", time];
    
    XCCPGamePrivateAttachment * shareMent = [[XCCPGamePrivateAttachment alloc] init];
    shareMent.first = Custom_Noti_Header_CPGAME_PrivateChat;
    shareMent.second = Custom_Noti_Sub_CPGAME_PrivateChat_LaunchGame;
    TTCPGameCustomInfo *gameInfo = [TTCPGameCustomInfo modelDictionary:[model model2dictionary]];
    
    TTGameCPPrivateChatModel *launchGameModel = [[TTGameCPPrivateChatModel alloc] init];
    launchGameModel.startTime = timeString.userIDValue;
    launchGameModel.status = TTGameStatusTypeTimeing;
    launchGameModel.time = 60;
    launchGameModel.gameInfo = gameInfo;
    launchGameModel.startUid = GetCore(AuthCore).getUid.userIDValue;
    launchGameModel.nick = [GetCore(UserCore) getUserInfoInDB:GetCore(AuthCore).getUid.userIDValue].nick;
    shareMent.data = [launchGameModel model2dictionary];
    [GetCore(PublicChatroomCore) onSendPublicChatGameMessage:shareMent];
}

#pragma mark - inputview
- (void)setupInputView {
    if (self.isPublicChat) {
        if ([self shouldShowInputView]) {
            self.publicChatInputView = [[TTPublicChatInputView alloc] initWithFrame:CGRectMake(0, KScreenHeight - 50 - kSafeAreaBottomHeight, self.view.nim_width,50)];
            self.publicChatInputView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
            [self.publicChatInputView setSession:self.session];
            [self.publicChatInputView setInputDelegate:self];
            [self.publicChatInputView setInputActionDelegate:self];
            [self.publicChatInputView refreshStatus:TTInputStatusText];
            [self.view addSubview:_publicChatInputView];
            
        }
    }else {
        [super setupInputView];
    }
}

#pragma mark - gift

- (void)onReceiveGiftInPublicChatRoom:(GiftAllMicroSendInfo *)giftInfo {
    GiftInfo *info = [GetCore(GiftCore) findGiftInfoByGiftId:giftInfo.giftId];
    if (!info) {
        info = giftInfo.giftInfo;
    }
    
    NSInteger giftTotal = 0;
    if (giftInfo.targetUids.count > 0) {
        giftTotal = giftInfo.giftNum * info.goldPrice * giftInfo.targetUids.count;
    }else {
        giftTotal = giftInfo.giftNum * info.goldPrice;
    }
    
    if (giftTotal >= 66) {
        if (self.giftAnimateQueue.count == 0 || self.isAnimating == NO) {
            [self creatSpringView:giftInfo];
            [self.giftAnimateQueue addObject:giftInfo];
        }else {
            [self.giftAnimateQueue addObject:giftInfo];
        }
    }
}

- (void)onCurrentPublicChatroomReceiveGift:(GiftAllMicroSendInfo *)info {
    
}

- (void)startTheGiftAnimateQueueScanner {
    NSTimeInterval period = kGiftQueueScannerTime;
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    dispatch_source_set_timer(_timer, dispatch_walltime(NULL, 0), period * NSEC_PER_SEC, 0); //每秒执行
    @weakify(self);
    dispatch_source_set_event_handler(_timer, ^{
        @strongify(self);
        if (self.giftAnimateQueue.count > 0) {
            @weakify(self);
            dispatch_sync(dispatch_get_main_queue(), ^{
                @strongify(self);
                if (self.giftAnimateQueue.count > 0) {
                    
                }
            });
        }
    });
}

#pragma mark - gift queue

- (void)creatSpringView:(GiftAllMicroSendInfo *)info {
    GiftInfo *giftInfo = [GetCore(GiftCore) findGiftInfoByGiftId:info.giftId];
    if (!giftInfo) {
        giftInfo = info.giftInfo;
    }
    NSInteger giftTotal = 0;
    if (info.targetUids.count > 0) {
        giftTotal = info.giftNum * giftInfo.goldPrice *info.targetUids.count;
    }else {
        giftTotal = info.giftNum * giftInfo.goldPrice;
    }
    
    NSInteger stayTime = 3;
    
    if (giftTotal >= 66) {
        self.isAnimating = YES;
        __block TTPublicGiftSpringView *view = [self.springReusePool anyObject];
        if (view == nil) {
            view = [[TTPublicGiftSpringView alloc]init];
            [self.springVisablePool addObject:view];
        }else {
            [self.springReusePool removeObject:view];
        }
        [view setInfo:info];
        NSString *matchString = [[NSBundle mainBundle] pathForResource:@"message_public_bg" ofType:@"svga"];
        
        NSURL *matchUrl = [NSURL fileURLWithPath:matchString];
        [self.parser loadSvgaWithURL:matchUrl completionBlock:^(SVGAVideoEntity * _Nullable videoItem) {
            view.svgaImageView.videoItem = videoItem;
            view.svgaImageView.loops = 2;
            view.svgaImageView.clearsAfterStop = YES;
            [view.svgaImageView startAnimation];
        } failureBlock:^(NSError * _Nullable error) {
            
        }];
        
        view.frame = CGRectMake(0, 0, 300, 145);
        view.center = CGPointMake([UIScreen mainScreen].bounds.size.width / 2, [UIScreen mainScreen].bounds.size.width / 2);
        [self.giftDisplayView addSubview:view];
        [self.giftDisplayView bringSubviewToFront:view];
        [self.view bringSubviewToFront:self.giftDisplayView];
        @weakify(self);
        
        POPSpringAnimation *springAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPViewCenter];
        springAnimation.springSpeed = 12;
        springAnimation.springBounciness = 10.f;
        springAnimation.fromValue = [NSValue valueWithCGPoint:view.center];
        springAnimation.toValue = [NSValue valueWithCGPoint:CGPointMake(self.view.nim_centerX, view.center.y)];
        [springAnimation setCompletionBlock:^(POPAnimation *anim, BOOL finished) {
            @strongify(self);
            if (finished) {
                [self moveOutAnimation:view stayTime:stayTime];
            }
        }];
        [springAnimation setAnimationDidStartBlock:^(POPAnimation *anim) {
            
        }];
        [view pop_addAnimation:springAnimation forKey:@"spingOutAnimation"];
    }else {
        self.isAnimating = NO;
    }
}

- (void)moveOutAnimation:(TTPublicGiftSpringView *)view stayTime:(NSInteger)stayTime{
    POPBasicAnimation *moveAnimation = [POPBasicAnimation animationWithPropertyNamed:kPOPViewCenter];
    moveAnimation.fromValue = [NSValue valueWithCGPoint:view.center];
    moveAnimation.toValue = [NSValue valueWithCGPoint:CGPointMake(view.center.x + KScreenWidth, view.center.y)];
    moveAnimation.beginTime = CACurrentMediaTime() + stayTime;
    moveAnimation.duration = 0.5;
    moveAnimation.repeatCount = 1;
    moveAnimation.removedOnCompletion = YES;
    @weakify(self);
    [moveAnimation setCompletionBlock:^(POPAnimation *anim, BOOL finished) {
        @strongify(self);
        if (finished) {
            [view.svgaImageView stopAnimation];
            [self.giftAnimateQueue removeObjectAtSafeIndex:0];
            if (self.giftAnimateQueue.count > 0) {
                
                [self creatSpringView:self.giftAnimateQueue[0]];
            }
            [view removeFromSuperview];
            view.info = nil;
            [self.springVisablePool removeObject:view];
            [self.springReusePool addObject:view];
        }
    }];
    [view pop_addAnimation:moveAnimation forKey:@"moveOutAnimation"];
}

#pragma mark - TTOpenNobleTipCardView

- (void)openNobleTipCardViewDidGotoOpenNoble:(TTOpenNobleTipCardView *)cardView {
    [TTPopup dismiss];
    TTWKWebViewViewController *vc = [[TTWKWebViewViewController alloc]init];
    
    vc.urlString = HtmlUrlKey(kNobilityIntroURL);
    [[[XCCurrentVCStackManager shareManager]currentNavigationController]pushViewController:vc animated:YES];
}

- (void)openNobleTipCardViewDidClose:(TTOpenNobleTipCardView *)cardView {
    [TTPopup dismiss];
}

#pragma mark - TTSendGiftViewDelegate

- (void)sendGiftViewDidClickReport:(TTSendGiftView *)sendGiftView {
    [TTPopup dismiss];
    TTWKWebViewViewController *vc = [[TTWKWebViewViewController alloc]init];
    NSString *urlstr = [NSString stringWithFormat:@"%@?reportUid=%lld",HtmlUrlKey(kReportURL),sendGiftView.targetInfo.uid];
    vc.urlString = urlstr;
    [[[XCCurrentVCStackManager shareManager]currentNavigationController]pushViewController:vc animated:YES];
}

- (void)sendGiftView:(TTSendGiftView *)sendGiftView currentNobleLevel:(int)currentLevel needNobelLevel:(int)needLevel {
    
    [TTPopup dismiss];
    
    TTOpenNobleTipCardView *view = [[TTOpenNobleTipCardView alloc]initWithCurrentLevel:[self nobleNameByNobleLevel:currentLevel] doAction:@"" needLevel:[self nobleNameByNobleLevel:needLevel]];
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
    [TTStatisticsService trackEvent:TTStatisticsServiceEventGiftViewToRecharge eventDescribe:@"公聊大厅-礼物面板充值"];
    
    // 首次充值资格
    if (sendGiftView.isFirstRecharge) {
        [TTStatisticsService trackEvent:@"room_gift_oneyuan_entrance" eventDescribe:@"公聊大厅"];
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
    [[TTPublicChatUserCardFunctionItemConfig getCenterFunctionItemsInPublicChatRoomWithUid:userid vc:self]subscribeNext:^(id x) {
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

#pragma mark - TTPublicChatInputViewDelegatenk
- (void)didChangeInputHeight:(CGFloat)inputHeight {
    [self.interactor changeLayout:inputHeight];
}

#pragma mark - NIMMessageCellDelegate

- (BOOL)onTapAvatar:(NIMMessage *)message {
    NSMutableArray * bottomOpeArray = [TTPublicChatUserCardFunctionItemConfig getFunctionItemsInPublicChatRoomWithUid:message.from.userIDValue];
    [XCHUDTool showGIFLoadingInView:self.view];
    @KWeakify(self);
    [[TTPublicChatUserCardFunctionItemConfig getCenterFunctionItemsInPublicChatRoomWithUid:message.from.userIDValue vc:self]subscribeNext:^(id x) {
        
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

- (BOOL)onLongPressAvatar:(NIMMessage *)message {
    return YES;
}

#pragma mark - NIMInputActionDelegate

- (void)onSendText:(NSString *)text atAttachment:(PublicChatAtMemberAttachment *)atAttachment {
    [_publicChatInputView endEditing:YES];
    __block NIMMessage *message = nil;
    
    @KWeakify(self);
    [[GetCore(ImPublicChatroomCore) rac_queryPublicChartRoomMemberByUid:GetCore(AuthCore).getUid] subscribeNext:^(id x) {
        @KStrongify(self);
        GetCore(ImPublicChatroomCore).publicMe = (NIMChatroomMember *)x;
        if (GetCore(ImPublicChatroomCore).publicMe.tempMuteDuration > 0) {
            [XCHUDTool showErrorWithMessage:[NSString stringWithFormat:@"你已被禁言，剩余%.1f分钟。官方提醒您文明用语",GetCore(ImPublicChatroomCore).publicMe.tempMuteDuration*1.0/60]];
            return;
        }
        
        message = [[NIMMessage alloc]init];
        message.text = text;
        
        [GetCore(ImMessageCore)antiSpam:text withMessage:message];
        
        if (message.antiSpamOption.hitClientAntispam) {
            [XCHUDTool showErrorWithMessage:@"发送失败，官方提醒你文明用语"];
            return;
        }
        
        if (atAttachment.atUids.count > 0) {
            atAttachment.content = text;
            atAttachment.originAtNames = nil;
            [self.publicChatInputView addAtTimes];
            [GetCore(PublicChatroomCore)onSendPublicChatAtMessage:atAttachment];
        }else {
            [GetCore(PublicChatroomCore)onSendPublicChatTextMessage:text];
        }
        [self.publicChatInputView cleanMessage];
    }];
}

#pragma mark - ZJScrollPageViewChildVcDelegate

- (void)zj_viewWillDisappearForIndex:(NSInteger)index {
    if (index == 0) {
        [_publicChatInputView endEditing:YES];
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

#pragma mark - private

- (void)reset {
    for (TTPublicGiftSpringView *imageView in self.springVisablePool.allObjects) {
        @autoreleasepool {
            [imageView.svgaImageView stopAnimation];
            imageView.info = nil;
            dispatch_async(dispatch_get_global_queue(0, 0),^{
                [imageView class];
            });
        }
    }
    NSMutableSet *tmpSet = self.springVisablePool;
    self.springVisablePool = nil;
    dispatch_async(dispatch_get_global_queue(0,0),^{
        [tmpSet class];
    });
    
    for (TTPublicGiftSpringView *imageView in self.springReusePool.allObjects) {
        @autoreleasepool {
            [imageView.svgaImageView stopAnimation];
            imageView.info = nil;
            dispatch_async(dispatch_get_global_queue(0, 0),^{
                [imageView class];
            });
        }
    }
    tmpSet = self.springReusePool;
    self.springReusePool = nil;
    dispatch_async(dispatch_get_global_queue(0,0),^{
        [tmpSet class];
    });
    
    [self.giftAnimateQueue removeAllObjects];
}

- (NSString *)nobleNameByNobleLevel:(int)nobleLevel{
    NSString *nobleLevelString = [NSString stringWithFormat:@"%d",nobleLevel];
    NSDictionary *matchNobleName = @{@"0":@"平民",
                                     @"1":@"男爵",
                                     @"2":@"子爵",
                                     @"3":@"伯爵",
                                     @"4":@"侯爵",
                                     @"5":@"公爵",
                                     @"6":@"国王",
                                     @"7":@"皇帝"};
    return matchNobleName[nobleLevelString];
}

#pragma mark - user respone

- (void)scrollToBottom {
    [self.tableView nim_scrollToBottom:YES];
}

#pragma mark - Getter & Setter

- (SVGAParserManager *)parser {
    if (!_parser ){
        _parser = [[SVGAParserManager alloc]init];
    }
    return _parser;
}

- (NSMutableArray *)giftAnimateQueue {
    if (!_giftAnimateQueue) {
        _giftAnimateQueue = [NSMutableArray array];
    }
    return _giftAnimateQueue;
}

- (UIView *)giftDisplayView {
    if (!_giftDisplayView) {
        _giftDisplayView = [[UIView alloc]initWithFrame:[UIScreen mainScreen].bounds];
        _giftDisplayView.backgroundColor = [UIColor clearColor];
        _giftDisplayView.userInteractionEnabled = NO;
        [self.view addSubview:self.giftDisplayView];
    }
    return _giftDisplayView;
}

- (NSMutableSet *)springReusePool {
    if (!_springReusePool) {
        _springReusePool = [NSMutableSet set];
    }
    return _springReusePool;
}

- (NSMutableSet *)springVisablePool {
    if (!_springVisablePool) {
        _springVisablePool = [NSMutableSet set];
    }
    return _springVisablePool;
}

- (id<NIMSessionConfig>)sessionConfig {
    return self.config;
}

- (TTPublicChatRoomConfig *)config {
    if (!_config) {
        _config = [[TTPublicChatRoomConfig alloc]initWithChatroom:self.session.sessionId];
    }
    return _config;
}

- (UIButton *)newMessageTips {
    if (!_newMessageTips) {
        _newMessageTips = [[UIButton alloc]init];
        [_newMessageTips setBackgroundImage:[UIImage imageNamed:@"message_public_chat_newmessage_icon"] forState:UIControlStateNormal];
        _newMessageTips.hidden = YES;
        [_newMessageTips addTarget:self action:@selector(scrollToBottom) forControlEvents:UIControlEventTouchUpInside];
    }
    return _newMessageTips;
}


- (UIButton *)selectGameButton{
    if (!_selectGameButton) {
        _selectGameButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_selectGameButton setImage:[UIImage imageNamed:@"chat_game_overlays"] forState:UIControlStateNormal];
        [_selectGameButton addTarget:self action:@selector(selectGameAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _selectGameButton;
}

- (TTCPGameListView *)listView{
    if (!_listView) {
        _listView = [[TTCPGameListView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight - kNavigationHeight) WithListType:TTGameListPublicAndNormalRoom];
        _listView.delegate = self;
        _listView.hidden = YES;
    }
    return _listView;
}

@end
