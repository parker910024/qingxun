//
//  XCOpenBoxManager.m
//  XCRoomMoudle
//
//  Created by KevinWang on 2018/8/22.
//  Copyright © 2018年 YiZhuan. All rights reserved.
//

#import "XCOpenBoxManager.h"
//vc
//#import "XCRoomViewControllerCenter.h"
#import "TTRoomModuleCenter.h"
#import "XCBoxTrophyHistoryViewController.h"
//#import "XCMediator+XCPersonalMoudleBridge.h"
#import "XCMediator+TTPersonalMoudleBridge.h"
//view
#import "XCBoxMainView.h"
#import "XCDiamondBoxMainView.h"
#import "XCBoxTypeSelectView.h"
#import "XCBoxBuykeyView.h"
#import "XCBoxHelpView.h"
//t
#import "UIView+XCToast.h"
#import "XCAlertControllerCenter.h"
#import "XCMacros.h"
#import "XCTheme.h"
#import "TTStatisticsService.h"

//core
#import "AuthCore.h"
#import "PurseCore.h"
#import "PurseCoreClient.h"
#import "BoxCore.h"
#import "BoxCoreClient.h"
#import "BoxStatusClient.h"
#import "BalanceErrorClient.h"
#import "BoxOpenBoxEnergyInfo.h"
#import "NSArray+Safe.h"
#import "XCCurrentVCStackManager.h"


#define kBOX_WIDTH (KScreenWidth <  355 ? (KScreenWidth - 10) : 355)
#define kBOX_HEIGHT (KScreenWidth < 355 ? (440*kBOX_WIDTH/320 + 10): 440)

@interface XCOpenBoxManager()
<XCBoxMainViewDelegate,
XCDiamondBoxMainViewDelegate,
XCBoxBuykeyViewDelegate,
BoxCoreClient,
PurseCoreClient,
BalanceErrorClient,
XCBoxTypeSelectViewDelegate
>
@property (nonatomic, strong) UIView *bgView;//背景遮盖
@property (nonatomic, strong) XCBoxMainView *boxMainView;
@property (nonatomic, strong) XCDiamondBoxMainView *diamondBoxMainView;
@property (nonatomic, strong) XCBoxTypeSelectView *boxTypeSelectView;
@property (nonatomic, strong) XCBoxHelpView *helpView;
@property (nonatomic, strong) XCBoxBuykeyView *buyKeyView;//购买钥匙View
@property (nonatomic, strong) XCBoxBuykeyView *needBuyKeyView;//需要购买钥匙View
@property (nonatomic, strong) XCBoxTrophyHistoryViewController  *trophyHistoryVC;//奖品历史
@property (nonatomic, strong) XCBoxTrophyHistoryViewController  *jackpotVC;//奖池

@property (nonatomic, assign) int openTimes;//抽奖次数
@property (nonatomic, assign) BOOL sendMessage;//是否发中奖消息
@property (nonatomic, strong) dispatch_source_t autoOpenTimer;//自动抽奖
@property (nonatomic, assign) XCBoxType boxType;// 宝箱类型


@property (nonatomic, assign) int currentEnergy; // 当前能量
@property (nonatomic, assign) int totalEnergy; // 总能量

@property (nonatomic, strong) NSTimer *energyQuestionTimer; // 能量值❓ timer

@end

static XCOpenBoxManager *instance;

static int kBOX_MAXKEY = 99999;

@implementation XCOpenBoxManager

#pragma mark - life cycle
+ (instancetype)shareManager{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
        instance.sendMessage = YES;
    });
    return instance;
}

#pragma mark - XCBoxMainViewDelegate
- (void)boxMainViewOpenBox:(XCBoxMainView *)boxMainView openCountType:(XCBoxSelectOpenCountType)openCountType sendMessage:(BOOL)sendMessage{
    int openTimes = 0;
    switch (openCountType) {
        case XCBoxSelectOpenCountTypeOne:
            openTimes = 1;
            break;
        case XCBoxSelectOpenCountTypeTen:
            openTimes = 10;
            break;
        case XCBoxSelectOpenCountTypeHundred:
            openTimes = 100;
            break;
        default:
            openTimes = 1;
            break;
    }
    self.openTimes = openTimes;
    self.sendMessage = sendMessage;
    if (openTimes<=GetCore(BoxCore).keyInfo.keyNum) {
        [self.boxMainView resetBox];
        [GetCore(BoxCore) openBoxByKey:openTimes sendMessage:sendMessage type:XCBoxOpenBoxType_Manual];
    }else{
        if (GetCore(BoxCore).keyInfo.keyNum==0) {
            [self.boxMainView addSubview:self.buyKeyView];
            self.buyKeyView.isDiamondBox = NO;
        }else{
            [self.boxMainView addSubview:self.needBuyKeyView];
            self.needBuyKeyView.needKeyNumber = openTimes - GetCore(BoxCore).keyInfo.keyNum;
        }
    
    }

}

- (void)boxMainView:(XCBoxMainView *)boxMainView didChangeAutoOpenState:(XCBoxMainViewAutoOpenBoxState)state{
    if (state == XCBoxMainViewAutoOpenBoxStateStart) {
        NSLog(@"start");
        if (GetCore(BoxCore).keyInfo.keyNum<=0) {
            [self.boxMainView addSubview:self.buyKeyView];
            self.buyKeyView.isDiamondBox = NO;
            [self.boxMainView resetAutoOpenBoxStatue];
        }else{
            [self startAutoOpenBox];
        }
    }else{
        [self pauseAutoOpenBox];
        NSLog(@"pause");
    }
}

- (void)boxMainView:(XCBoxMainView *)boxMainView eventType:(XCBoxMainViewEventType)eventType{
    switch (eventType) {
        case XCBoxMainViewEventTypeClose:
            [self closeBox];
            break;
        case XCBoxMainViewEventTypeRecode:
            self.trophyHistoryVC.isJackpot = NO;
            [self.boxMainView addSubview:self.trophyHistoryVC.view];
            break;
        case XCBoxMainViewEventTypeHelp:
        {
            [self.boxMainView addSubview:self.helpView];
            [GetCore(BoxCore) getBoxConfigSource];
        }
            break;
        case XCBoxMainViewEventTypeJackpot:
            self.jackpotVC.isJackpot = YES;
            self.jackpotVC.isDiamondJackpot = NO;
            [self.boxMainView addSubview:self.jackpotVC.view];
            break;
        case XCBoxMainViewEventTypeBuyKey:
            [self.boxMainView addSubview:self.buyKeyView];
            self.buyKeyView.isDiamondBox = NO;
            break;
        case XCBoxMainViewEventTypeRecharge:
        {
            [self closeBox];
            UIViewController *vc = [[XCMediator sharedInstance] ttPersonalModule_rechargeController];
            [[TTRoomModuleCenter defaultCenter].currentNav pushViewController:vc animated:YES];
        }
            break;
        case XCBoxMainViewEventTypeEnergyQuestion: {
//            [self.boxMainView.boxTips setHidden:NO];

        }
        default:
            break;
    }
}

- (void)boxMainView:(XCBoxMainView *)boxMainView didChangeMessageTipState:(BOOL)sendMessage{
    self.sendMessage = sendMessage;
}

#pragma mark - XCDiamondViewDelegate
- (void)diamondBoxMainViewOpenBox:(XCDiamondBoxMainView *)diamondBoxMainView openCountType:(XCBoxSelectOpenCountType)openCountType sendMessage:(BOOL)sendMessage {
    int openTimes = 0;
    switch (openCountType) {
        case XCBoxSelectOpenCountTypeOne:
            openTimes = 1;
            break;
        case XCBoxSelectOpenCountTypeTen:
            openTimes = 10;
            break;
        case XCBoxSelectOpenCountTypeHundred:
            openTimes = 100;
            break;
        default:
            openTimes = 1;
            break;
    }
    self.openTimes = openTimes;
    self.sendMessage = sendMessage;
    if (openTimes<=GetCore(BoxCore).keyInfo.keyNum) {
        [self.diamondBoxMainView resetBox];
        [GetCore(BoxCore) openDiamondBoxByKey:openTimes sendMessage:sendMessage type:XCBoxOpenBoxType_Manual];
    }else{
        if (GetCore(BoxCore).keyInfo.keyNum==0) {
            [self.diamondBoxMainView addSubview:self.buyKeyView];
            self.buyKeyView.isDiamondBox = YES;
        }else{
            [self.diamondBoxMainView addSubview:self.needBuyKeyView];
            self.needBuyKeyView.needKeyNumber = openTimes - GetCore(BoxCore).keyInfo.keyNum;
        }
    }
}

- (void)diamondBoxMainView:(XCDiamondBoxMainView *)diamondBoxMainView didChangeAutoOpenState:(XCDiamondBoxMainViewAutoOpenBoxState)state {
    if (state == XCDiamondBoxMainViewAutoOpenBoxStateStart) {
        NSLog(@"start");
        if (GetCore(BoxCore).keyInfo.keyNum<=0) {
            [self.diamondBoxMainView addSubview:self.buyKeyView];
            self.buyKeyView.isDiamondBox = YES;
            [self.diamondBoxMainView resetAutoOpenBoxStatue];
        }else{
            [self startAutoOpenDiamondBox];
        }
    }else{
        [self pauseAutoOpenBox];
        NSLog(@"pause");
    }
}

- (void)diamondBoxMainView:(XCDiamondBoxMainView *)diamondBoxMainView eventType:(XCDiamondBoxMainViewEventType)eventType {
    switch (eventType) {
        case XCDiamondBoxMainViewEventTypeClose:
            [self closeBox];
            break;
        case XCDiamondBoxMainViewEventTypeRecode:
            self.trophyHistoryVC.isJackpot = NO;
            self.trophyHistoryVC.isDiamondBox = YES;
            [self.diamondBoxMainView addSubview:self.trophyHistoryVC.view];
            break;
        case XCDiamondBoxMainViewEventTypeHelp: {
            [self.diamondBoxMainView addSubview:self.helpView];
            self.helpView.isDiamondBox = YES;
            [GetCore(BoxCore) getBoxConfigSource];
        }
            break;
        case XCDiamondBoxMainViewEventTypeJackpot:
            self.jackpotVC.isJackpot = YES;
            self.jackpotVC.isDiamondJackpot = YES;
            self.jackpotVC.isDiamondBox = YES;
            [self.diamondBoxMainView addSubview:self.jackpotVC.view];
            break;
        case XCDiamondBoxMainViewEventTypeBuyKey:
            [self.diamondBoxMainView addSubview:self.buyKeyView];
            self.buyKeyView.isDiamondBox = YES;
            break;
        case XCDiamondBoxMainViewEventTypeRecharge: {
            [self closeBox];
            UIViewController *vc = [[XCMediator sharedInstance] ttPersonalModule_rechargeController];
            [[TTRoomModuleCenter defaultCenter].currentNav pushViewController:vc animated:YES];
        }
            break;
        case XCDiamondBoxMainViewEventTypeEnergyQuestion: {
//            [self.diamondBoxMainView.boxTips setHidden:NO];
        }
            break;
        default:
            break;
    }
}

- (void)diamondBoxMainView:(XCDiamondBoxMainView *)diamondBoxMainView didChangeMessageTipState:(BOOL)sendMessage {
    self.sendMessage = sendMessage;
}

#pragma mark - XCBoxBuykeyViewDelegate
- (void)ensureBuyKeyWithKeyNumber:(NSInteger)keyNum type:(XCBoxBuyKeyType)type{
    if (keyNum > kBOX_MAXKEY) {
        [UIView showToastInKeyWindow:@"购买钥匙数量上限" duration:2.0 position:YYToastPositionCenter];
        return;
    }
    
    if (self.boxType == XCBoxSelectType_Normal) {
        [GetCore(BoxCore) buyBoxKeysByKey:keyNum type:type];
    } else {
        [GetCore(BoxCore) buyDiamondBoxKeysByKey:keyNum type:type];
    }
    
}

#pragma mark - XCBoxTypeSelectViewDelegate

- (void)onBoxTypeSelected:(XCBoxSelectType)boxType {
    self.boxType = boxType;
    
    AddCoreClient(BoxCoreClient, self);
    AddCoreClient(PurseCoreClient, self);
    AddCoreClient(BalanceErrorClient, self);
    
    [GetCore(BoxCore) getBoxConfigSource];
    [GetCore(PurseCore) requestBalanceInfo:GetCore(AuthCore).getUid.userIDValue];
    // 先注释掉，服务器说已过期的接口
//    [GetCore(BoxCore) getBoxCritActivityData];//避免没收到通知，但是活动正在进行中，所有进入开箱子主动查询
    
    self.bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight)];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapBgView:)];
    [self.bgView addGestureRecognizer:tap];
    if (projectType() == ProjectType_LookingLove) {
        self.bgView.backgroundColor = UIColorRGBAlpha(0x000000, 0.8);
    } else {
        self.bgView.backgroundColor = [UIColor clearColor];
    }
    
     // 点击砸蛋统计
    NSString *roomType = @"多人房";
    NSString *eggType = @"金蛋";
    NSString *eventString = @"mp_room_smashEgg_choose";
    
    // 如果是陪伴房
    if (GetCore(RoomCoreV2).getCurrentRoomInfo.type == RoomType_CP) {
        roomType = @"陪伴房";
        eventString = @"cp_room_smashEgg_choose";
    }
    
    if (boxType ==  XCBoxSelectType_Normal) {
        [GetCore(BoxCore) getBoxKeysInfo];
        [GetCore(BoxCore) getBoxOpenActivityDataByBoxType:XCBoxType_Normal];
        [self.boxMainView updateKey:GetCore(BoxCore).keyInfo.keyNum];
        [self.boxMainView updateGold:GetCore(PurseCore).balanceInfo.goldNum];
        [self.bgView addSubview:self.boxMainView];
        
    } else {
        
        eggType = @"至尊蛋";
        
        [GetCore(BoxCore) getDiamondBoxKeysInfo];
        [GetCore(BoxCore) getBoxOpenActivityDataByBoxType:XCBoxType_Diamond];
        [self.diamondBoxMainView updateKey:GetCore(BoxCore).keyInfo.keyNum];
        [self.diamondBoxMainView updateGold:GetCore(PurseCore).balanceInfo.goldNum];
        [self.bgView addSubview:self.diamondBoxMainView];
    }
    
    [TTStatisticsService trackEvent:eventString eventDescribe:[NSString stringWithFormat:@"开始砸%@-%@",eggType, roomType]];
    
    [[XCCurrentVCStackManager shareManager].getCurrentVC.view addSubview:self.bgView];
}

#pragma mark - BoxCoreClient normal box
/**
 获取暴击活动数据
 */
- (void)onGetBoxCritActivityDataSuccess:(BoxCirtData *)cirtData{
    
    if (cirtData.status == BoxCirtActivityStatus_Start) {
        [self.boxMainView beginCirtActivity:cirtData];
    }
    
}
- (void)onGetBoxCritActivityDataFailth:(NSString *)message{
    
}

//暴击活动状态改变
- (void)boxCirtActivityStatusUpdate:(NSUInteger)status msg:(NIMMessage *)msg{
    
    if (status == Custom_Noti_Sub_Box_OpenBoxCirt_Start) {
        
        [GetCore(BoxCore) getBoxCritActivityData];
    }else if (status == Custom_Noti_Sub_Box_OpenBoxCirt_END){
        
        [self.boxMainView endCirtActivity];
    }else if (status == Custom_Noti_Sub_Box_OpenBoxCirt_Win){
        
        [self.boxMainView endCirtActivity];
    }
}


//获取钥匙信息
- (void)onGetKeysInfoSuccess:(BoxKeyInfoModel *)info{
    [self.boxMainView updateKey:GetCore(BoxCore).keyInfo.keyNum];
    self.buyKeyView.keyPrice = GetCore(BoxCore).keyInfo.keyPrice;
}
- (void)onGetKeysInfoFailth:(NSString *)message{}

//购买钥匙
- (void)onbuyBoxKeysType:(XCBoxBuyKeyType)type success:(int)keyNum{
    [self.boxMainView updateKey:keyNum];
    [self.boxMainView updateGold:GetCore(PurseCore).
     balanceInfo.goldNum];
    [self.buyKeyView removeFromSuperview];
    [self.needBuyKeyView removeFromSuperview];
    
    if (type == XCBoxBuyKeyType_Need) {
        [GetCore(BoxCore) openBoxByKey:self.openTimes sendMessage:self.sendMessage type:XCBoxOpenBoxType_Manual];
    }
    
}
- (void)onbuyBoxKeysType:(XCBoxBuyKeyType)type Failth:(NSString *)message{}

- (void)onBoxKeysUpdate{
    NSLog(@"%@",GetCore(BoxCore).keyInfo);
    [self.boxMainView updateKey:GetCore(BoxCore).keyInfo.keyNum];
}
//开箱子
- (void)onOpenBoxByKeyType:(XCBoxOpenBoxType)type success:(NSArray *)boxPrizes{

    [self.boxMainView updateBoxState:boxPrizes type:type];
}
- (void)onOpenBoxByKeyType:(XCBoxOpenBoxType)type failth:(NSString *)message{

}

//help
- (void)onGetBoxConfigSourceSuccess:(BoxConfigInfo *)configInfo{
    [self.boxMainView updateBg:GetCore(BoxCore).configInfo.backgroundUrl];
    [self.helpView updateImage:GetCore(BoxCore).configInfo.ruleUrl];
}
- (void)onGetBoxConfigSourceFailth:(NSString *)message{
    [self.boxMainView updateBg:GetCore(BoxCore).configInfo.backgroundUrl];
    [self.helpView updateImage:GetCore(BoxCore).configInfo.ruleUrl];
}

#pragma mark - BoxCoreClient diamond box
//获取钥匙信息
- (void)onGetDiamondBoxKeysInfoSuccess:(BoxKeyInfoModel *)info {
    [self.diamondBoxMainView updateKey:info.keyNum];
    self.buyKeyView.keyPrice = info.keyPrice;
}
- (void)onGetDiamondBoxKeysInfoFailth:(NSString *)message{
    
}
//购买钥匙
- (void)onbuyDiamondBoxKeysType:(XCBoxBuyKeyType)type success:(int)keyNum{
    [self.diamondBoxMainView updateKey:keyNum];
    [self.diamondBoxMainView updateGold:GetCore(PurseCore).balanceInfo.goldNum];
    [self.buyKeyView removeFromSuperview];
    [self.needBuyKeyView removeFromSuperview];
    
    if (type == XCBoxBuyKeyType_Need) {
        [GetCore(BoxCore) openDiamondBoxByKey:self.openTimes sendMessage:self.sendMessage type:XCBoxOpenBoxType_Manual];
    }
    
}
//开箱子
- (void)onOpenDiamondBoxByKeyType:(XCBoxOpenBoxType)type success:(NSArray *)boxPrizes {
    [self.diamondBoxMainView updateBoxState:boxPrizes type:type];
}

- (void)onOpenDiamondBoxByKeyType:(XCBoxOpenBoxType)type failth:(NSString *)message{
    
}
- (void)onDiamondBoxKeysUpdate {
    [self.diamondBoxMainView updateKey:GetCore(BoxCore).keyInfo.keyNum];
}

- (void)onGetDiamondBoxActivityStatusSuccess:(BoxStatus *)status {
    [self.boxTypeSelectView updateBoxStatus:status];
}

- (void)onGetBoxOpenActivityData:(XCBoxType)type success:(BoxOpenInfo *)openBoxInfo {
    BoxOpenBoxEnergyInfo *energyInfo = openBoxInfo.openBoxEnergyAct;
    
    NSArray *ranges = openBoxInfo.openBoxEnergyAct.energyRanges;
    // 排下序
    NSSortDescriptor *lowestTohighest = [NSSortDescriptor sortDescriptorWithKey:@"self" ascending:YES];
    NSArray *sortedRanges = [ranges sortedArrayUsingDescriptors:[NSArray arrayWithObject:lowestTohighest]];
    NSNumber *maxEnergy = ranges.lastObject;
    
    self.currentEnergy = energyInfo.userEnergy.curEnergy;
    self.totalEnergy = maxEnergy.intValue;
    
    CGFloat progress =  (CGFloat)self.currentEnergy / (CGFloat)self.totalEnergy;
    int timeLeft = openBoxInfo.openBoxCritAct.totalTime - openBoxInfo.openBoxCritAct.alreadyStartedTime;
    if (type == XCBoxType_Normal) {
        [self.boxMainView updateProgress:progress];
        [self.boxMainView updateProgressWithRanges:sortedRanges];
        [self.boxMainView updateLuckyValueExpireDays:energyInfo.userEnergy.expireDays];
        [self.boxMainView updateTimeLeft:timeLeft];
    } else {
        [self.diamondBoxMainView updateProgress:progress];
        [self.diamondBoxMainView updateProgressWithRanges:sortedRanges];
        [self.diamondBoxMainView updateLuckyValueExpireDays:energyInfo.userEnergy.expireDays];
        [self.diamondBoxMainView updateTimeLeft:timeLeft];
    }
}

- (void)onGetBoxOpenActivityData:(XCBoxType)type failth:(NSString *)message {

}

- (void)onGetBoxOpenEnergy:(int)value {
    if (self.totalEnergy <= 0) {
        return;
    }
    self.currentEnergy = self.currentEnergy + value;
    
    CGFloat progress =  (CGFloat)self.currentEnergy / (CGFloat)self.totalEnergy;
    
    // 如果累加的能量值超过最大的能量值，能量进度重置
    int subEnergy = self.currentEnergy - self.totalEnergy;
    if (subEnergy > 0) {
        // 累积的能量值重置
        self.currentEnergy = self.currentEnergy % self.totalEnergy;
        // 进度条值重置
        progress =  (CGFloat)self.currentEnergy / (CGFloat)self.totalEnergy;
    }
 
    if (self.boxType == XCBoxSelectType_Normal) {
        [self.boxMainView updateProgress:progress];
    } else {
        [self.diamondBoxMainView updateProgress:progress];
    }
}

#pragma mark - PurseCoreClient
- (void)onBalanceInfoUpdate:(BalanceInfo *)balanceInfo{
    if (self.boxType == XCBoxSelectType_Normal) {
        [self.boxMainView updateGold:GetCore(PurseCore).balanceInfo.goldNum];
    } else {
        [self.diamondBoxMainView updateGold:GetCore(PurseCore).balanceInfo.goldNum];
    }
}


#pragma mark - BalanceErrorClient
- (void)onBalanceNotEnough{
    [self closeBox];
}

#pragma mark - event response
- (void)tapBgView:(UIGestureRecognizer *)recognizer{
    
    CGPoint location = [recognizer locationInView:recognizer.view];
    location = [self.boxMainView.layer convertPoint:location fromLayer:recognizer.view.layer];
    if (![self.boxMainView.layer containsPoint:location]) {
        [self closeBox];
    }else{
        location = [self.boxMainView.buyLabel.layer convertPoint:location fromLayer:self.boxMainView.layer];
        if ([self.boxMainView.buyLabel.layer containsPoint:location]) {
            [self.boxMainView addSubview:self.buyKeyView];
        }
    }
}

#pragma mark - Public Method
- (void)showBox {
    AddCoreClient(BoxStatusClient, self);

    [GetCore(BoxCore) getDiamondBoxActivityStatus];

    self.boxTypeSelectView = [[XCBoxTypeSelectView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight)];
    self.boxTypeSelectView.delegate = self;
    [[XCAlertControllerCenter defaultCenter] presentAlertWith:[XCCurrentVCStackManager shareManager].getCurrentVC view:self.boxTypeSelectView  dismissBlock:nil];
}

- (void)stopAutoOpenBox{
    [self pauseAutoOpenBox];
    [self.boxMainView resetAutoOpenBoxStatue];
}

- (void)stopAutoOpenDiamondBox{
    [self pauseAutoOpenDiamondBox];
    [self.diamondBoxMainView resetAutoOpenBoxStatue];
}

#pragma mark - private method
- (void)closeBox{
    RemoveCoreClientAll(self);
    [self.diamondBoxMainView cleanProgressBoxView];
    [self.diamondBoxMainView endCirtActivity];
    [self.diamondBoxMainView removeFromSuperview];
//    [self.diamondBoxMainView.boxTips setHidden:YES];

    [self.boxMainView cleanProgressBoxView];
    [self.boxMainView endCirtActivity];
    [self.boxMainView removeFromSuperview];
//    [self.boxMainView.boxTips setHidden:YES];

    [self.bgView removeFromSuperview];
    [self.trophyHistoryVC.view removeFromSuperview];
    [self.jackpotVC.view removeFromSuperview];
    
    [self.buyKeyView removeFromSuperview];
    [self.needBuyKeyView removeFromSuperview];
    [self.helpView removeFromSuperview];
    
    [[XCAlertControllerCenter defaultCenter] dismissAlertNeedBlock:NO];
}

- (void)startAutoOpenBox{
    [self stopAutoOpenDiamondBox];
    NSTimeInterval period = 2.0;
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    dispatch_source_set_timer(_timer, dispatch_walltime(NULL, 0), period * NSEC_PER_SEC, 0);
    @weakify(self);
    dispatch_source_set_event_handler(_timer, ^{
        @strongify(self);
        if (GetCore(BoxCore).keyInfo.keyNum > 0) {
            @weakify(self);
            dispatch_sync(dispatch_get_main_queue(), ^{
                @strongify(self);
                [self.boxMainView resetBox];
                [GetCore(BoxCore) openBoxByKey:1 sendMessage:self.sendMessage type:XCBoxOpenBoxType_Auto];
            });
        
        } else {
            dispatch_source_cancel(_timer);
            self.autoOpenTimer = nil;
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.boxMainView resetBox];
            });
            
            [self.boxMainView resetAutoOpenBoxStatue];
        }
    });
    dispatch_resume(_timer);
    self.autoOpenTimer = _timer;
}

- (void)startAutoOpenDiamondBox {
    [self stopAutoOpenBox];
    NSTimeInterval period = 2.0;
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    dispatch_source_set_timer(_timer, dispatch_walltime(NULL, 0), period * NSEC_PER_SEC, 0);
    @weakify(self);
    dispatch_source_set_event_handler(_timer, ^{
        @strongify(self);
        if (GetCore(BoxCore).keyInfo.keyNum > 0) {
            @weakify(self);
            dispatch_sync(dispatch_get_main_queue(), ^{
                @strongify(self);
                [self.diamondBoxMainView resetBox];
                [GetCore(BoxCore) openDiamondBoxByKey:1 sendMessage:self.sendMessage type:XCBoxOpenBoxType_Auto];
            });
            
        } else {
            dispatch_source_cancel(_timer);
            self.autoOpenTimer = nil;
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.diamondBoxMainView resetBox];
            });
            
            [self.diamondBoxMainView resetAutoOpenBoxStatue];
        }
    });
    dispatch_resume(_timer);
    self.autoOpenTimer = _timer;
}


- (void)pauseAutoOpenBox{
    [self.boxMainView resetBox];
    if (self.autoOpenTimer != nil) {
        dispatch_source_cancel(self.autoOpenTimer);
        self.autoOpenTimer = nil;
    }
}

- (void)pauseAutoOpenDiamondBox{
    [self.diamondBoxMainView resetBox];
    if (self.autoOpenTimer != nil) {
        dispatch_source_cancel(self.autoOpenTimer);
        self.autoOpenTimer = nil;
    }
}


#pragma mark - Getter & Setter
- (XCBoxMainView *)boxMainView{
    if (!_boxMainView) {
        _boxMainView = [[XCBoxMainView alloc] initWithFrame:CGRectMake((KScreenWidth-kBOX_WIDTH)/2, (KScreenHeight-kBOX_HEIGHT)/2, kBOX_WIDTH, kBOX_HEIGHT)];
        _boxMainView.delegate = self;
    }
    return _boxMainView;
}

- (XCDiamondBoxMainView *)diamondBoxMainView{
    if (!_diamondBoxMainView) {
        _diamondBoxMainView = [[XCDiamondBoxMainView alloc] initWithFrame:CGRectMake((KScreenWidth-kBOX_WIDTH)/2, (KScreenHeight-kBOX_HEIGHT)/2, kBOX_WIDTH, kBOX_HEIGHT)];
        _diamondBoxMainView.delegate = self;
    }
    return _diamondBoxMainView;
}

- (XCBoxBuykeyView *)buyKeyView {
    if (!_buyKeyView) {
        _buyKeyView = [[XCBoxBuykeyView alloc] init];
        _buyKeyView.frame = self.boxMainView.bounds;
        _buyKeyView.keyPrice = GetCore(BoxCore).keyInfo.keyPrice;
        _buyKeyView.delegate = self;
    }
    return _buyKeyView;
}

- (XCBoxBuykeyView *)needBuyKeyView {
    if (!_needBuyKeyView) {
        _needBuyKeyView = [[XCBoxBuykeyView alloc] initWithNeedKey];
        _needBuyKeyView.frame = self.boxMainView.bounds;
        _needBuyKeyView.delegate = self;
    }
    return _needBuyKeyView;
}

- (XCBoxTrophyHistoryViewController *)trophyHistoryVC {
    if (!_trophyHistoryVC) {
        _trophyHistoryVC = [[XCBoxTrophyHistoryViewController alloc] init];
        _trophyHistoryVC.isJackpot = NO;
        _trophyHistoryVC.view.frame = self.boxMainView.bounds;
    }
    return _trophyHistoryVC;
}

- (XCBoxTrophyHistoryViewController *)jackpotVC {
    if (!_jackpotVC) {
        _jackpotVC = [[XCBoxTrophyHistoryViewController alloc] init];
        _jackpotVC.isJackpot = YES;
        _jackpotVC.view.frame = self.boxMainView.bounds;
    }
    return _jackpotVC;
}
- (XCBoxHelpView *)helpView{
    if (!_helpView) {
        _helpView = [[XCBoxHelpView alloc] init];
        _helpView.frame = self.boxMainView.bounds;
        _helpView.isDiamondBox = NO; // 默认为no
        [_helpView updateImage:GetCore(BoxCore).configInfo.ruleUrl];
    }
    return _helpView;
}

@end
