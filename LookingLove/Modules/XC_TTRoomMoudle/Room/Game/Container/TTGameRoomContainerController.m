//
//  TTGameRoomContainerController.m
//  TuTu
//
//  Created by KevinWang on 2018/10/30.
//  Copyright © 2018年 YiZhuan. All rights reserved.
//

#import "TTGameRoomContainerController.h"

//category
#import "TTGameRoomContainerController+GameRoom.h"
#import "TTGameRoomContainerController+MusicPlayer.h"
#import "TTGameRoomContainerController+SVGA.h"
#import "BaseAttrbutedStringHandler+TTRoomModule.h"

//core
#import "ImRoomCoreClient.h"
#import "ImRoomCoreClientV2.h"

#import "RoomCoreV2.h"
#import "RoomCoreClient.h"

#import "GiftCore.h"
#import "GiftCoreClient.h"

#import "UserCore.h"
#import "FaceCore.h"

#import "FileCoreClient.h"
#import "MeetingCoreClient.h"
#import "RoomMagicCoreClient.h"
#import "GameCoreClient.h"
#import "TTMp4PlayerClient.h"
//t
#import "TTRoomModuleCenter.h"
#import <SDWebImage/SDWebImageManager.h>
#import <NIMSDK/NIMSDK.h>
#import "XCConst.h"
#import "XCMacros.h"
#import "UIView+XCToast.h"
#import "SVGAParserManager.h"
#import "YYUtility.h"
#import "NSMutableArray+Safe.h"
#import "SystemObserver.h"
#import "UIImageView+QiNiu.h"
#import "NSString+Utils.h"
#import "XCTheme.h"
#import <Masonry/Masonry.h>
#import <POP.h>
#import "TTGameRoomAnimationProvider.h"

#import "XCCurrentVCStackManager.h"
#import "TTPopup.h"
#import "TTMp4PlayerTool.h"

//view
#import <YYText.h>
#import "TTGiftSpringView.h"

//vc
#import "TTGameRoomViewController.h"

#define kGiftAndMagicQueueScannerTime 0.3
static BOOL SDImageCacheOldShouldDecompressImages = YES;
static BOOL SDImagedownloderOldShouldDecompressImages = YES;

@interface TTGameRoomContainerController ()
<
ImRoomCoreClient,
RoomCoreClient,
GiftCoreClient,
ImRoomCoreClientV2,
FileCoreClient,
MeetingCoreClient,
RoomMagicCoreClient,
GameCoreClient,
SVGAPlayerDelegate,
TTGameRoomViewControllerDelagte
>

//gift
@property (strong, nonatomic) UIView *giftDisplayView;//房间礼物view
@property (strong, nonatomic) NSMutableArray<GiftAllMicroSendInfo *> *giftAnimateQueue;//gift animation
// 礼物的队列
@property (strong, nonatomic) NSMutableArray *giftEffectAnimateQueue;
/**
 是否正在播放动画
 */
@property (assign, nonatomic) BOOL isAnimating;
//room magic
@property(nonatomic,strong) NSMutableArray *magicAnimationQueue;//magic animation
@property(nonatomic,strong) NSMutableArray *magicEffectAnimationQueue;//magic effect
@property (nonatomic, assign) BOOL isShowRommMagicEffect;
//Timer
@property (nonatomic ,strong)dispatch_source_t timer;

//gift reuse
@property (strong,nonatomic)NSMutableSet * giftDequePool;//复用池
@property (strong,nonatomic)NSMutableSet * giftVisiablePool;//可见池
//spring gift reuse
@property (strong,nonatomic)NSMutableSet * springDequePool;//复用池
@property (strong,nonatomic)NSMutableSet * springVisiablePool;//可见池

@property (nonatomic, strong) NSMutableArray<NIMCustomObject *> *boxPirzeAnimationQueue;//开箱子四级奖品
@property (nonatomic ,strong)dispatch_source_t prizeTimer;//prizeTimer

@property (nonatomic, strong) NSArray *luckyBagAnimationImages; //福袋

// 用于记录横幅的View
@property (nonatomic, strong) TTGiftSpringView *springView;

@property (nonatomic, assign) BOOL isPlayMp4OrSvga; // 当前是否在播放svga或者是MP4动画
@end


@implementation TTGameRoomContainerController


#pragma mark - overload

- (BOOL)isHiddenNavBar {
    return YES;
}

- (BOOL)isNavRootViewController{
    return YES;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}


#pragma mark - life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.tempMusicBtnState = NO;
    self.tempMusicPlayerState = YES;
    
    [self addcore];
    [self initView];
    [self initConstrations];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_popFromRechage) name:kRechargePopToGameRoomNotification object:nil];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
    for (UIView *item in self.giftDisplayView.subviews) {
        [item removeFromSuperview];
    }
    [self _reset];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    GetCore(TTGameStaticTypeCore).giftSwitch = YES;
    SDImageCacheConfig *config = [SDImageCache sharedImageCache].config;
    config.shouldDecompressImages = NO;
    
    SDWebImageDownloader *downloder = [SDWebImageDownloader sharedDownloader];
    SDImagedownloderOldShouldDecompressImages = downloder.shouldDecompressImages;
    downloder.shouldDecompressImages = NO;
    
    [GetCore(FileCore) uploadMusicList];
    [self.musicPlayerView ttUpdateStatus];
    
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    self.isAnimating = NO;
    self.isShowRommMagicEffect = NO;
    GetCore(TTGameStaticTypeCore).giftSwitch = NO;
    for (UIView *view in self.giftDisplayView.subviews) {
        [view removeFromSuperview];
    }
}


- (void)dealloc {
    //Remove Client Here
    RemoveCoreClientAll(self);
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self.giftEffectAnimateQueue removeAllObjects];
    SDImageCacheConfig *config = [SDImageCache sharedImageCache].config;
    config.shouldDecompressImages = YES;
    
    SDWebImageDownloader *downloder = [SDWebImageDownloader sharedDownloader];
    downloder.shouldDecompressImages = SDImagedownloderOldShouldDecompressImages;
    [[SDImageCache sharedImageCache] clearMemory];
    
    [self _reset];
}

#pragma mark --- SVGAPlayerDelegate ---
- (void)svgaPlayerDidFinishedAnimation:(SVGAPlayer *)player {
    [self updateNobleOpenEffectQueue:player];
    [self updateCarEffectQueue:player];
    if (player == self.giftEffectView) {//gift
        [self.giftEffectAnimateQueue removeObjectAtSafeIndex:0];
        self.isPlayMp4OrSvga = NO;
        if ([self.springView superview]) {
            [self.springView pop_removeAnimationForKey:@"moveOutAnimation"];
            [self.springView removeFromSuperview];
            self.springView.giftReceiveInfo = nil;
            [self.springVisiablePool removeObject:self.springView];
            [self.springDequePool addObject:self.springView];
        }
        if (self.giftEffectAnimateQueue.count > 0) {
            
            [self _creatSpringView:self.giftEffectAnimateQueue[0]];
        } else {
            [UIView animateWithDuration:0.5 animations:^{
                self.giftEffectView.alpha = 0;
            }];
        }
    }else if (player == self.roomMagicEffectView){//magicEffect
        [self ttHandleRoomMagicEffectAnimation];
    }else if (player == self.svgaCarEffectView){//car
        
    }else if (player == self.nobleOpenEffectView){//noble
        
    }else{ //magicGift
        SVGAImageView *roomMagicView = (SVGAImageView *)player;
        [roomMagicView removeFromSuperview];
        roomMagicView.videoItem = nil;
        [self.magicVisiablePool removeObject:roomMagicView];
        [self.magicDequePool addObject:roomMagicView];
    }
}

#pragma mark - TTMp4PlayerClient
/// mp4播放完成的回调
/// @param container 当前播放Mp4的View
- (void)viewDidStopPlayWithView:(UIView *)container {
    if (container == self.giftEffectView) {//gift
        [self.giftEffectAnimateQueue removeObjectAtSafeIndex:0];
        self.isPlayMp4OrSvga = NO;
        if ([self.springView superview]) {
            [self.springView pop_removeAnimationForKey:@"moveOutAnimation"];
            [self.springView removeFromSuperview];
            self.springView.giftReceiveInfo = nil;
            [self.springVisiablePool removeObject:self.springView];
            [self.springDequePool addObject:self.springView];
        }
        if (self.giftEffectAnimateQueue.count > 0) {
            
            [self _creatSpringView:self.giftEffectAnimateQueue[0]];
        } else {
            [UIView animateWithDuration:0.5 animations:^{
                self.giftEffectView.alpha = 0;
            }];
        }
    }
}

#pragma mark - MeetingCoreClient
- (void)onUpdateNextMusicName:(NSString *)musicName Artist:(NSString *)artistName {
    [self.musicPlayerView ttUpdateStatus];
}

#pragma mark - FileCoreClient
- (void)onUploadMusicListSuccess:(NSArray *)musicArray{
    GetCore(MeetingCore).musicLists = [musicArray mutableCopy];
}


#pragma mark - ImRoomCoreClientV2

- (void)onGetRoomQueueSuccessV2:(NSMutableDictionary*)info{
    
    UserID myUid = [GetCore(AuthCore)getUid].userIDValue;
    
    @weakify(self);
    [GetCore(UserCore) getUserInfo:myUid refresh:NO success:^(UserInfo *info) {
        @strongify(self);
        self.myInfo = info;
    }failure:^(NSError *error) {
        
    }];
    
    BOOL isOnMic = [GetCore(RoomQueueCoreV2) isOnMicro:myUid];
    NSInteger temp = 0;
    for (ChatRoomMicSequence * sequence in [info allValues]) {
        if (self.myInfo.uid == sequence.userInfo.uid) {
            temp++;
            if (temp == 1) {
                break;
            }
        }
    }
    
    if (isOnMic == NO ||
        GetCore(ImRoomCoreV2).currentRoomInfo.isOpenGame) {
        
        if (self.musicEntrance.hidden == NO ||
            self.musicPlayerContainView.hidden == NO) {
            
            self.tempMusicBtnState = self.musicEntrance.hidden;
            self.tempMusicPlayerState = self.musicPlayerContainView.hidden;
        }
        
        self.musicPlayerContainView.hidden = YES;
        self.musicEntrance.hidden = YES;
        [self.musicPlayerView ttUpdateStatus];
        
        [GetCore(MeetingCore) stopPlayMusic];
        GetCore(MeetingCore).currentMusic = nil;
        GetCore(MeetingCore).isPlaying = NO;
        
    } else {   //上麦
        
        if (self.musicEntrance.hidden == NO ||
            self.musicPlayerContainView.hidden == NO) {
            
            self.tempMusicBtnState = self.musicEntrance.hidden;
            self.tempMusicPlayerState = self.musicPlayerContainView.hidden;
        }
        
        self.musicPlayerContainView.hidden = self.tempMusicPlayerState;
        self.musicEntrance.hidden = NO;
    }
}

#pragma mark - RoomCoreClient
- (void)onReceiveOpenBoxBigPrizeMsg:(NIMMessage *)message {
    NIMCustomObject *obj = (NIMCustomObject *)message.messageObject;
    
    [self.boxPirzeAnimationQueue addObject:obj];
    
    if (self.prizeTimer== nil) {
        [self _handleOpenBoxBigPrizeMsgAnimation];
    }
}

- (void)onManagerAdd:(NIMChatroomMember *)member {
    
    if (member.userId.userIDValue == [GetCore(AuthCore) getUid].userIDValue) {
        [UIView showToastInKeyWindow:@"你已经被房主设置为管理员" duration:2 position:YYToastPositionCenter];
    }
}

- (void)onManagerRemove:(NIMChatroomMember *)member {
    if (member.userId.userIDValue == [GetCore(AuthCore) getUid].userIDValue) {
        [UIView showToastInKeyWindow:@"你已经被房主移除管理员" duration:2 position:YYToastPositionCenter];
    }
}

- (void)onGameRoomInfoUpdateSuccess:(RoomInfo *)info eventType:(RoomUpdateEventType)eventType {
    
    [self onGetRoomQueueSuccessV2:GetCore(ImRoomCoreV2).micQueue];
    
    [self updateRoomBg:info andUserInfo:GetCore(ImRoomCoreV2).roomOwnerInfo];//update bg
}

// 相亲房公布心动结果通知（动画)
- (void)onRecvBlindDatePublicLoveResult:(NIMMessage *)message {
    
    NIMCustomObject *obj = (NIMCustomObject *)message.messageObject;
    Attachment *attachment = (Attachment *)obj.attachment;
    NSDictionary *dict = attachment.data;
    [self createLoveRoomPublicChooseLoveAnimation:dict];
}

#pragma mark - GiftCoreClient
- (void)onReceiveGift:(GiftAllMicroSendInfo *)giftReceiveInfo {
    if ([SystemObserver current_cpu_usage]>=70.0 &&
        giftReceiveInfo.uid != GetCore(AuthCore).getUid.userIDValue) {
        return;
    }
    
    [self _handleFaceMessage:giftReceiveInfo]; //扫描礼物队列
    
    GiftInfo *info = [GetCore(GiftCore) findGiftInfoByGiftId:giftReceiveInfo.giftId];
    if (!info) {
        info = giftReceiveInfo.gift;
    }
    
    // 如果是盲盒礼物
    if (giftReceiveInfo.gift.consumeType == GiftConsumeTypeBox) {
        @weakify(self);
        
        if (giftReceiveInfo.targetUsers.count > 0) {
            [giftReceiveInfo.targetUsers enumerateObjectsUsingBlock:^(UserInfo * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                
                @strongify(self);
                GiftInfo *gift = [GetCore(GiftCore) findPrizeGiftByGiftId:obj.receiveGiftId];

                // 新复制一个出来，不然礼物飘屏 和礼物飞到头像的 effect 会因为使用同一个，导致效果丢失（缺失了targetUsers）
                GiftAllMicroSendInfo *effectGift = [giftReceiveInfo yy_modelCopy];
                effectGift.targetUsers = @[obj];
                effectGift.targetUids = @[@(obj.uid)];
                effectGift.gift = gift;
                effectGift.receiveGiftId = obj.receiveGiftId;
                effectGift.targetNick = obj.nick;
                effectGift.targetAvatar = obj.avatar;
                
                [self addSpringEffective:effectGift gift:gift];
            }];
        } else {
            GiftInfo *gift = [GetCore(GiftCore) findPrizeGiftByGiftId:giftReceiveInfo.receiveGiftId];
            [self addSpringEffective:giftReceiveInfo gift:gift];
        }
        
    } else {
        [self addSpringEffective:giftReceiveInfo gift:info];
    }
}

- (void)addSpringEffective:(GiftAllMicroSendInfo *)giftReceiveInfo gift:(GiftInfo *)info {
    NSInteger giftTotal = 0;
    if (giftReceiveInfo.targetUids.count > 0) {
        giftTotal = giftReceiveInfo.giftNum * info.goldPrice * giftReceiveInfo.targetUids.count;
    } else {
        giftTotal = giftReceiveInfo.giftNum * info.goldPrice;
    }
    if (giftTotal >= 520) {
        if (giftReceiveInfo.gift.giftMp4Key.receiveAvatar || giftReceiveInfo.gift.giftMp4Key.sendAvatar) { // 需要扣头像，不用横幅
            if (!GetCore(RoomCoreV2).hasAnimationEffect) { // 关闭了礼物特效
                return;
            }
        }
        if (self.giftEffectAnimateQueue.count == 0 || self.isAnimating == NO) {
            if ((info.giftMp4Key.receiveAvatar.length > 0 || info.giftMp4Key.sendAvatar.length > 0) && giftReceiveInfo.targetUsers.count > 1) {
                NSDictionary *dict = [giftReceiveInfo model2dictionary];
                for (int i = 0; i < giftReceiveInfo.targetUsers.count; i++) {
                    UserInfo *info = [giftReceiveInfo.targetUsers safeObjectAtIndex:i];
                    if (i == 0) {
                        GiftAllMicroSendInfo *mp4GiftInfo = [[GiftAllMicroSendInfo alloc] init];
                        mp4GiftInfo = [GiftAllMicroSendInfo modelDictionary:dict];
                        mp4GiftInfo.targetUsers = @[info];
                        [self _creatSpringView:mp4GiftInfo];//创建特效动画
                        [self.giftEffectAnimateQueue addObject:mp4GiftInfo];
                    } else {
                        GiftAllMicroSendInfo *mp4GiftInfo = [[GiftAllMicroSendInfo alloc] init];
                        mp4GiftInfo = [GiftAllMicroSendInfo modelDictionary:dict];
                        mp4GiftInfo.targetUsers = @[info];
                        [self.giftEffectAnimateQueue addObject:mp4GiftInfo];
                    }
                }
            } else {
               [self _creatSpringView:giftReceiveInfo];//创建特效动画
               [self.giftEffectAnimateQueue addObject:giftReceiveInfo];
            }
        } else {
            if ((info.giftMp4Key.receiveAvatar.length > 0 || info.giftMp4Key.sendAvatar.length > 0) && giftReceiveInfo.targetUsers.count > 1) {
                NSDictionary *dict = [giftReceiveInfo model2dictionary];
                for (int i = 0; i < giftReceiveInfo.targetUsers.count; i++) {
                    UserInfo *info = [giftReceiveInfo.targetUsers safeObjectAtIndex:i];
                    GiftAllMicroSendInfo *mp4GiftInfo = [[GiftAllMicroSendInfo alloc] init];
                    mp4GiftInfo = [GiftAllMicroSendInfo modelDictionary:dict];
                    mp4GiftInfo.targetUsers = @[info];
                    [self.giftEffectAnimateQueue addObject:mp4GiftInfo];
                }
            } else {
               [self.giftEffectAnimateQueue addObject:giftReceiveInfo];
            }
        }
    }
}

- (void)addGiftSvga:(GiftAllMicroSendInfo *)giftEffect {

}


//接收到 福袋礼物 一对一
- (void)onReceiveLuckyGift:(GiftAllMicroSendInfo *)giftReceiveInfo {
    giftReceiveInfo.isLuckyBagGift = YES;
    [self onReceiveGift:giftReceiveInfo];
}

//接收到 全麦 福袋礼物
- (void)onReceiveAllMicroLuckyGift:(NSArray<GiftAllMicroSendInfo *> *)giftReceiveInfos {
    if (giftReceiveInfos.count <= 0) {
        return;
    }
    NSMutableArray *uids = [NSMutableArray array];
    NSMutableDictionary *giftInfoMap = [NSMutableDictionary dictionary];
    double totalPrice = 0;
    GiftAllMicroSendInfo *sendInfo = [GiftAllMicroSendInfo new];
    
    for (GiftAllMicroSendInfo *info in giftReceiveInfos) {
        NSString *uidStr = [NSString stringWithFormat:@"%lld",info.targetUid];
        [uids addObject:uidStr];
        [giftInfoMap safeSetObject:info forKey:uidStr];
        
        if (info.gift.hasVggPic) {
            sendInfo.gift = info.gift;
        }
        totalPrice += info.gift.goldPrice;
    }
    
    sendInfo.isLuckyBagGift = YES;
    sendInfo.giftNum = 1;
    sendInfo.uid = [giftReceiveInfos.firstObject uid];
    sendInfo.targetUids = uids;
    sendInfo.giftInfoMap = giftInfoMap;
    sendInfo.totalPrice = totalPrice;
    
    [self onReceiveGift:sendInfo];
}

#pragma mark - RoomMagicCoreClient
- (void)onReceiveRoomMagic:(RoomMagicInfo *)receiveRoomMagicInfo {
    
    if ([SystemObserver current_cpu_usage]>=70.0 &&
        receiveRoomMagicInfo.uid != GetCore(AuthCore).getUid.userIDValue) {
        //        for (SVGAImageView *item in self.magicDequePool) {
        //            [item clear];
        //        }
        return;
    }
    
    [self _handleRoomMagicMessage:receiveRoomMagicInfo];
    
    RoomMagicInfo *magicInfo = [GetCore(RoomMagicCore) findLocalMagicListsByMagicId:receiveRoomMagicInfo.giftMagicId];
    magicInfo = magicInfo == nil ? [[RoomMagicInfo alloc] init] : magicInfo;
    
    if (receiveRoomMagicInfo.playEffect &&
        (magicInfo.effectSvgUrl.length>0 ||
         receiveRoomMagicInfo.effectSvgUrl.length>0)) {
        
        if ((magicInfo.effectSvgUrl == nil || magicInfo.effectSvgUrl.length <= 0) &&
            receiveRoomMagicInfo.effectSvgUrl) {
            
            magicInfo.effectSvgUrl = receiveRoomMagicInfo.effectSvgUrl;
        }
        
        [self.magicEffectAnimationQueue addObject:magicInfo];
    }
}

#pragma mark - event response

- (void)didRecognizedMusicPlayerContainViewTapGestureRecognizer:(UIGestureRecognizer *)recognizer {
    [self.musicPlayerView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.musicPlayerContainView.mas_right).offset(0);
        make.top.mas_equalTo(kSafeAreaTopHeight + 15 + 37 + 44);
        make.width.mas_equalTo(self.view.frame.size.width - 85);
        make.height.mas_equalTo(80);
    }];
    
    @weakify(self);
    [UIView animateWithDuration:0.2 animations:^{
        @strongify(self);
        [self.view layoutIfNeeded];
        
    } completion:^(BOOL finished) {
        @strongify(self);
        self.musicPlayerContainView.hidden = YES;
        [self.musicPlayerContainView removeFromSuperview];
        self.musicPlayerContainView = nil;
        self.musicPlayerView = nil;
    }];
}

#pragma mark - puble method

- (void)ttBeInBlackList {
    [self.roomController ttBeInBlackList];
}

- (void)ttBeKicked:(NIMChatroomKickReason)reson {
    [self.roomController ttBeKicked:reson];
}

//超管拉黑
- (void)ttBeKickedBySuperAdmin:(NIMChatroomBeKickedResult *)result {
    [self.roomController ttSuperAdminBeKicked:result];
}

//处理房间魔法特效播放完毕
- (void)ttHandleRoomMagicEffectAnimation {
    [self.magicEffectAnimationQueue removeObjectAtSafeIndex:0];
    self.isShowRommMagicEffect = NO;
    if (self.magicEffectAnimationQueue.count > 0) {
        [self createRoomMagicEffectAnimation];
    }
}

//播放房间魔法特效
- (void)createRoomMagicEffectAnimation{
    
    if (self.isShowRommMagicEffect== NO && self.magicEffectAnimationQueue.count > 0) {
        self.isShowRommMagicEffect = YES;
        //play
        RoomMagicInfo *magicInfo = self.magicEffectAnimationQueue.firstObject;
        
        @weakify(self);
        [self.parserManager loadSvgaWithURL:[NSURL URLWithString:magicInfo.effectSvgUrl] completionBlock:^(SVGAVideoEntity * _Nullable videoItem) {
            @strongify(self);
            self.roomMagicEffectView.loops = 1;
            self.roomMagicEffectView.clearsAfterStop = YES;
            self.roomMagicEffectView.videoItem = videoItem;
            [self.roomMagicEffectView startAnimation];
        } failureBlock:^(NSError * _Nullable error) {
            
        }];
    }
}

#pragma mark - private method

//处理开箱子动画
- (void)_handleOpenBoxBigPrizeMsgAnimation{
    
    NSTimeInterval period = 6.0; //设置时间间隔
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    dispatch_source_set_timer(_timer, dispatch_walltime(NULL, 0), period * NSEC_PER_SEC, 0); //每秒执行
    @weakify(self);
    dispatch_source_set_event_handler(_timer, ^{
        @strongify(self);
        if (self.boxPirzeAnimationQueue.count > 0 ) {
            @weakify(self);
            dispatch_sync(dispatch_get_main_queue(), ^{
                @strongify(self);
                [self _createPrizeAnimation];
                [self.boxPirzeAnimationQueue removeObjectAtIndex:0];
            });
            
        } else {
            @strongify(self);
            dispatch_source_cancel(_timer);
            self.prizeTimer = nil;
        }
        
    });
    
    dispatch_resume(_timer);
    self.prizeTimer = _timer;
}

- (void)_createPrizeAnimation{
    NIMCustomObject *obj = self.boxPirzeAnimationQueue.firstObject;
    Attachment *attachment = (Attachment *)obj.attachment;
    YYLabel *label = [[YYLabel alloc] init];
    label.backgroundColor = UIColorFromRGB(0xFF5E83);
    NSMutableAttributedString *text = [BaseAttrbutedStringHandler createOpenBoxAttributedString:attachment.data[@"nick"] prizeName:attachment.data[@"prizeName"] prizeNum:attachment.data[@"prizeNum"] boxTypeStr:attachment.data[@"boxTypeStr"]];
    label.layer.cornerRadius = 13.0;
    CGFloat textLength = [NSString sizeWithText:text.mutableString font:[UIFont systemFontOfSize:13] maxSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX)].width+20;
    label.frame =CGRectMake(KScreenWidth, CGRectGetMinY(self.roomController.roomInfoLabel.frame), textLength, 26);
    label.attributedText = text;
    label.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:label];

    @weakify(self);
    [UIView animateWithDuration:2.0 animations:^{
        @strongify(self);
        label.frame =CGRectMake((KScreenWidth-textLength)/2, CGRectGetMinY(self.roomController.roomInfoLabel.frame), textLength, 26);
    } completion:^(BOOL finished) {
        @strongify(self);
        [UIView animateWithDuration:2.0 delay:2.0 options:UIViewAnimationOptionCurveLinear animations:^{
            label.frame =CGRectMake(-textLength, CGRectGetMinY(self.roomController.roomInfoLabel.frame), textLength, 26);
        } completion:^(BOOL finished) {
            [label removeFromSuperview];
        }];
    }];
}

//怪兽兼容
- (void)_popFromRechage{
    
}


- (void)_aniationDidFinish:(UIImageView *)giftImageView{
    [giftImageView removeFromSuperview];
    giftImageView.image = nil;
    [self.giftVisiablePool removeObject:giftImageView];
    [self.giftDequePool addObject:giftImageView];
}

//收到礼物 扫描礼物队列
- (void)_handleFaceMessage:(GiftAllMicroSendInfo *)allMicroSendInfo {
    [self.giftAnimateQueue addObject:allMicroSendInfo];
    
    @weakify(self);
    if (self.timer== nil) {
        @strongify(self);
        [self _startTheGiftQueueScanner];//addtimer
    }
}
//扫描房间魔法
- (void)_handleRoomMagicMessage:(RoomMagicInfo *)roomMagic {
    [self.magicAnimationQueue addObject:roomMagic];
    
    @weakify(self);
    if (self.timer== nil) {
        @strongify(self);
        [self _startTheGiftQueueScanner];//addtimer
    }
}

//扫描礼物队列
- (void)_startTheGiftQueueScanner {
    NSTimeInterval period = kGiftAndMagicQueueScannerTime; //设置时间间隔
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);    dispatch_source_set_timer(_timer, dispatch_walltime(NULL, 0), period * NSEC_PER_SEC, 0); //每秒执行
    @weakify(self);
    dispatch_source_set_event_handler(_timer, ^{
        @strongify(self);
        if (self.giftAnimateQueue.count > 0 || self.magicAnimationQueue.count > 0) {
            @weakify(self);
            dispatch_sync(dispatch_get_main_queue(), ^{
                @strongify(self);
                // 礼物和魔法限制CPU达到一定程度, 则不播放SVGA
                BOOL isCpuOvertop = NO;
                float cpu_usage = [SystemObserver current_cpu_usage];
                //                if (cpu_usage >= 70.0) {
                //                    isCpuOvertop = YES;
                [self showAutoCloseAnimationEffect:cpu_usage];
                //                }
                
                //handle gift
                if (self.giftAnimateQueue.count) {
                    GiftAllMicroSendInfo * info = self.giftAnimateQueue.firstObject;
                    if (isCpuOvertop && info.uid != GetCore(AuthCore).getUid.userIDValue) {
                        
                    } else {
                        [self _creatFlyGiftIcon:info];//计算坐标
                    }
                    [self.giftAnimateQueue removeObject:info];
                }
                
                //handle magic
                if (self.magicAnimationQueue.count) {
                    RoomMagicInfo *magicInfo = self.magicAnimationQueue.firstObject;
                    if (isCpuOvertop) {
                        
                    } else {
                        [self _calRoomMagicAnimatinPoint:magicInfo];
                    }
                    [self.magicAnimationQueue removeObject:magicInfo];
                }
            });
            
        } else {
            @strongify(self);
            dispatch_source_cancel(_timer);
            self.timer = nil;
        }
        
    });
    
    dispatch_resume(_timer);
    self.timer = _timer;
}

//计算礼物动画坐标
- (void)_creatFlyGiftIcon:(GiftAllMicroSendInfo *)giftReceiveInfo {
    if (!GetCore(RoomCoreV2).hasAnimationEffect) {
        return;
    }
    
    if (giftReceiveInfo.targetUids.count == 0
        && giftReceiveInfo.targetUid <= 0 ) {
        return;
    }
    
    GiftInfo *info = [GetCore(GiftCore) findGiftInfoByGiftId:giftReceiveInfo.giftId];
    if (!info) {
        info = giftReceiveInfo.gift;
    }
    
    if (giftReceiveInfo.targetUids.count > 0) {//全麦
        for (NSString *targetUid in giftReceiveInfo.targetUids) {
            
            if ([targetUid isKindOfClass:[NSString class]] ||
                [targetUid isKindOfClass:[NSNumber class]]) {
                
                NSDictionary *postionDictionary = [TTGameRoomAnimationProvider ttCreateGiftPosition:self.roomOwner.uid
                                                                                     giftRecivieUid:giftReceiveInfo.uid
                                                                                          targetUid:targetUid.userIDValue
                                                                                containerController:self];
                if (!postionDictionary) {
                    continue;
                }
                
                dispatch_time_t timer = dispatch_time(DISPATCH_TIME_NOW, 0.5 * NSEC_PER_SEC);
                @weakify(self);
                dispatch_after(timer, dispatch_get_main_queue(), ^{
                    @strongify(self);
                    if (giftReceiveInfo.isLuckyBagGift) {//福袋礼物
                        
                        GiftAllMicroSendInfo *giftInfo = [giftReceiveInfo.giftInfoMap objectForKey:targetUid];
                        [self _addTheLuchBagGiftAnimationWith:[postionDictionary[@"start"] CGPointValue]
                                             destinationPoint:[postionDictionary[@"end"] CGPointValue]
                                                  withGiftPic:[NSURL URLWithString:giftInfo.gift.giftUrl]];
                    } else {//普通礼物
                        
                        [self _addTheGiftAnimationWith:[postionDictionary[@"start"] CGPointValue]
                                      destinationPoint:[postionDictionary[@"end"] CGPointValue]
                                           withGiftPic:[NSURL URLWithString:info.giftUrl]];
                    }
                });
                
            } else {
                break;
            }
        }
        
    } else {
        NSDictionary *postionDictionary = [TTGameRoomAnimationProvider ttCreateGiftPosition:self.roomOwner.uid
                                                                             giftRecivieUid:giftReceiveInfo.uid
                                                                                  targetUid:giftReceiveInfo.targetUid
                                                                        containerController:self];
        if (!postionDictionary) {
            return;
        }
        if (giftReceiveInfo.isLuckyBagGift) {//福袋
            [self _addTheLuchBagGiftAnimationWith:[postionDictionary[@"start"] CGPointValue]
                                 destinationPoint:[postionDictionary[@"end"] CGPointValue]
                                      withGiftPic:[NSURL URLWithString:info.giftUrl]];
        } else {//普通礼物
            [self _addTheGiftAnimationWith:[postionDictionary[@"start"] CGPointValue]
                          destinationPoint:[postionDictionary[@"end"] CGPointValue]
                               withGiftPic:[NSURL URLWithString:info.giftUrl]];
        }
    }
}

- (void)createLoveRoomPublicChooseLoveAnimation:(NSDictionary *)dict {
    
    CGPoint starPoint;
    CGPoint destinationPoint;
    NSMutableArray *arr = GetCore(RoomCoreV2).positionArr;
    
    NSString *choosePosition = [GetCore(RoomQueueCoreV2) findThePositionByUid:[dict[@"chooseUid"] userIDValue]];
    if (!choosePosition) {
        choosePosition = dict[@"chooseMic"];
    }
    
    starPoint = [TTGameRoomAnimationProvider getNeedShowAnmationPosition:[dict[@"startMic"] integerValue] + 1
                                           positionPools:arr
                                                fromView:self.roomController.roomPositionView];
    
    destinationPoint = [TTGameRoomAnimationProvider getNeedShowAnmationPosition:[choosePosition integerValue] + 1
                                                                  positionPools:arr
                                                                       fromView:self.roomController.roomPositionView];
    
    [self _addTheGiftAnimationWith:starPoint
                  destinationPoint:destinationPoint
                       withGiftPic:nil withImage:[UIImage imageNamed:@"room_love_publicChoose"]];
}

//----------------------福袋礼物动画begin---------------------
//创建执行福袋礼物动画
- (void)_addTheLuchBagGiftAnimationWith:(CGPoint)orginPoint destinationPoint:(CGPoint)destinationPoint withGiftPic:(NSURL *)giftPic{
    __block UIImageView *giftImageView = [self.giftDequePool anyObject];
    if (giftImageView == nil) {
        giftImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0 , 55, 55)];
        [self.giftVisiablePool addObject:giftImageView];
    }else{
        [self.giftDequePool removeObject:giftImageView];
    }
    giftImageView.center = self.view.center;
    [giftImageView qn_setImageImageWithUrl:giftPic.absoluteString placeholderImage:nil type:ImageTypeRoomGift];
    giftImageView.alpha = 0;
    [self.giftDisplayView addSubview:giftImageView];
    [self.giftDisplayView bringSubviewToFront:giftImageView];
    giftImageView.layer.anchorPoint = CGPointMake(0.5, 0.5);
    
    
    UIImageView *luckBagImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0 , 250, 250)];
    luckBagImageView.contentMode = UIViewContentModeScaleAspectFit;
    luckBagImageView.image = [UIImage imageNamed:@"room_gift_lucky_bag_00"];
    luckBagImageView.center = orginPoint;
    luckBagImageView.alpha = 1;
    luckBagImageView.animationImages = self.luckyBagAnimationImages;
    luckBagImageView.animationDuration = 1.0;
    luckBagImageView.animationRepeatCount = 1;
    [self.giftDisplayView addSubview:luckBagImageView];
    [self.giftDisplayView bringSubviewToFront:luckBagImageView];
    luckBagImageView.layer.anchorPoint = CGPointMake(0.5, 0.5);
    
    
    POPBasicAnimation *luckyBagAnimation = [POPBasicAnimation animationWithPropertyNamed:kPOPViewCenter];
    luckyBagAnimation.fromValue = [NSValue valueWithCGPoint:orginPoint];
    luckyBagAnimation.toValue = [NSValue valueWithCGPoint:self.view.center];
    //    luckyBagAnimation.beginTime = CACurrentMediaTime();
    luckyBagAnimation.duration = 0.8;
    luckyBagAnimation.repeatCount = 1;
    luckyBagAnimation.removedOnCompletion = YES;
    @weakify(self);
    [luckyBagAnimation setCompletionBlock:^(POPAnimation *anim, BOOL finished) {
        @strongify(self);
        if (finished) {
            [luckBagImageView startAnimating];
            NSDictionary *source = @{@"luckBagImageView":luckBagImageView,
                                     @"giftImageView":giftImageView,
                                     @"destinationPoint":[NSValue valueWithCGPoint:destinationPoint]};
            
            [self performSelector:@selector(_realGiftAnimation:) withObject:source afterDelay:(1.0+0.01)];
        }
    }];
    [luckBagImageView pop_addAnimation:luckyBagAnimation forKey:@"luckyBagAnimation"];
    
}
- (void)_realGiftAnimation:(NSDictionary *)source{
    UIImageView *luckBagImageView = (UIImageView *)source[@"luckBagImageView"];
    UIImageView *giftImageView = (UIImageView *)source[@"giftImageView"];
    CGPoint destinationPoint = [source[@"destinationPoint"] CGPointValue];
    
    [luckBagImageView removeFromSuperview];
    giftImageView.alpha = 1;
    
    CAKeyframeAnimation *animation0 = [CAKeyframeAnimation animation];
    animation0.duration = 0.8;
    animation0.keyPath = @"transform.scale";
    animation0.values = @[@1.5,@1.0,@0.8];
    animation0.repeatCount = 1;
    animation0.calculationMode = kCAAnimationCubic;
    animation0.removedOnCompletion = NO;
    animation0.fillMode = kCAFillModeForwards;
    CAKeyframeAnimation *animation2 = [CAKeyframeAnimation animation];
    animation2.duration = 0.8;
    animation2.keyPath = @"position";
    animation2.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];;
    animation2.values = @[[NSValue valueWithCGPoint:self.view.center],[NSValue valueWithCGPoint:destinationPoint]];
    animation2.repeatCount = 1;
    animation2.removedOnCompletion = NO;
    animation2.fillMode = kCAFillModeForwards;
    
    
    CAAnimationGroup *group = [CAAnimationGroup animation];
    group.duration = 0.8;
    group.animations = @[animation0,animation2];
    group.repeatCount = 1;
    group.removedOnCompletion = NO;
    group.fillMode = kCAFillModeForwards;
    
    [self performSelector:@selector(_aniationDidFinish:) withObject:giftImageView afterDelay:0.8];
    [giftImageView.layer addAnimation:group forKey:@"giftAnimation"];
    
    
}
//----------------------福袋礼物动画end---------------------
//创建gift执行动画
- (void)_addTheGiftAnimationWith:(CGPoint)orginPoint destinationPoint:(CGPoint)destinationPoint withGiftPic:(NSURL *)giftPic {
    [self _addTheGiftAnimationWith:orginPoint destinationPoint:destinationPoint withGiftPic:giftPic withImage:nil];
}

//创建gift执行动画
- (void)_addTheGiftAnimationWith:(CGPoint)orginPoint destinationPoint:(CGPoint)destinationPoint withGiftPic:(NSURL *)giftPic withImage:(UIImage *)image {
    
    __block UIImageView *giftImageView = [self.giftDequePool anyObject];
    if (giftImageView == nil) {
        giftImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0 , 55, 55)];
        [self.giftVisiablePool addObject:giftImageView];
    }else{
        [self.giftDequePool removeObject:giftImageView];
    }
    
    giftImageView.center = orginPoint;
    if (image) {
        giftImageView.image = image;
    } else {
       [giftImageView qn_setImageImageWithUrl:giftPic.absoluteString placeholderImage:nil type:ImageTypeRoomGift];
    }
    giftImageView.alpha = 1;
    [self.giftDisplayView addSubview:giftImageView];
    [self.giftDisplayView bringSubviewToFront:giftImageView];
    giftImageView.layer.anchorPoint = CGPointMake(0.5, 0.5);
    CAAnimationGroup *group = [TTGameRoomAnimationProvider ttCreateGiftAnimation:self.view.center originPoint:orginPoint destinationPoint:destinationPoint];
    [giftImageView.layer addAnimation:group forKey:@"giftDisplayViewAnimation"];
    
    [self performSelector:@selector(_aniationDidFinish:) withObject:giftImageView afterDelay:(3.2+0.25)];
}


//创建特效动画
- (void)_creatSpringView:(GiftAllMicroSendInfo *)info {

    GiftInfo *giftInfo = info.gift;
    if (giftInfo.consumeType == GiftConsumeTypeBox) {
        giftInfo = [GetCore(GiftCore) findPrizeGiftByGiftId:info.receiveGiftId];
    }

    //    if (giftInfo.isWholeServer) {//全服礼物不触发房间横幅
    //        return;
    //    }
    NSInteger giftTotal = 0;
    if (info.targetUids.count > 0) {
        giftTotal = info.giftNum * giftInfo.goldPrice * info.targetUids.count;
    } else {
        giftTotal = info.giftNum * giftInfo.goldPrice;
    }
    
    NSInteger stayTime = 5;
    if (giftTotal >= 520) {
        self.isAnimating = YES;
        __block TTGiftSpringView *view = [self.springDequePool anyObject];
        if (view == nil) {
            view = [[TTGiftSpringView alloc] init];
            [self.springVisiablePool addObject:view];
        }else{
            [self.springDequePool removeObject:view];
        }
        if (giftInfo.giftMp4Key.receiveAvatar || giftInfo.giftMp4Key.sendAvatar) { //
            view.hidden = YES;
        } else {
            view.hidden = NO;
        }
        self.springView = view;
        [view setGiftReceiveInfo:info];
        view.frame = CGRectMake(self.view.frame.size.width, 100, self.view.frame.size.width, 153);
        [self.giftDisplayView addSubview:view];
        [self.giftDisplayView bringSubviewToFront:view];
        @weakify(self);
        
        POPSpringAnimation *springAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPViewCenter];
        springAnimation.springSpeed = 12;
        springAnimation.springBounciness = 10.f;
        springAnimation.fromValue = [NSValue valueWithCGPoint:view.center];
        springAnimation.toValue = [NSValue valueWithCGPoint:CGPointMake(view.frame.size.width / 2, view.center.y)];
        [springAnimation setCompletionBlock:^(POPAnimation *anim, BOOL finished) {
            @strongify(self);
            if (finished) {
                if (self.isPlayMp4OrSvga) { // 有动画。移除回调不用做任何操作
                    [self _moveOutAnimation:self.springView stayTime:stayTime isNeedDeal:NO];
                } else { // 无动画。移除回调需要做操作
                    [self _moveOutAnimation:self.springView stayTime:stayTime isNeedDeal:YES];
                }
            }
        }];
        [springAnimation setAnimationDidStartBlock:^(POPAnimation *anim) {
            @strongify(self);
            if ((giftInfo.mp4Url.length > 0 || giftInfo.hasVggPic) && GetCore(RoomCoreV2).hasAnimationEffect) {
                self.isPlayMp4OrSvga = YES;
                //test : giftInfo.vggUrl  ->https://img.erbanyy.com/Noble_OpenEffect_5.svga
//                [self.view bringSubviewToFront:self.giftEffectView];
                if (giftInfo.mp4Url.length > 0) {
                    self.giftEffectView.contentMode = UIViewContentModeScaleAspectFit;
                    self.giftEffectView.alpha = 1;
                    [[TTMp4PlayerTool defaultPlayerTool] playGiftMp4WithView:self.giftEffectView withCount:0 andGiftInfo:info];
                } else {
                    [self.parser loadSvgaWithURL:[NSURL URLWithString:giftInfo.vggUrl] completionBlock:^(SVGAVideoEntity * _Nullable videoItem) {
                        if (videoItem != nil) {
                            self.giftEffectView.contentMode = UIViewContentModeScaleAspectFit;
                            self.giftEffectView.alpha = 1;
                            self.giftEffectView.loops = 1;
                            self.giftEffectView.clearsAfterStop = YES;
                            self.giftEffectView.videoItem = videoItem;
                            [self.giftEffectView startAnimation];
                        }
                    } failureBlock:^(NSError * _Nullable error) {
                        
                    }];
                }
                
            } else {
                self.isPlayMp4OrSvga = NO;
            }
        }];
        
        [view pop_addAnimation:springAnimation forKey:@"spingOutAnimation"];
    }
}
//移除特效动画
- (void)_moveOutAnimation:(TTGiftSpringView *)view stayTime:(NSInteger)stayTime isNeedDeal:(BOOL)needDeal {
    POPBasicAnimation *moveAnimation = [POPBasicAnimation animationWithPropertyNamed:kPOPViewCenter];
    moveAnimation.fromValue = [NSValue valueWithCGPoint:view.center];
    moveAnimation.toValue = [NSValue valueWithCGPoint:CGPointMake(view.center.x - KScreenWidth, view.center.y)];
    moveAnimation.beginTime = CACurrentMediaTime() + stayTime;
    moveAnimation.duration = 0.5;
    moveAnimation.repeatCount = 1;
    moveAnimation.removedOnCompletion = YES;
    @weakify(self);
    [moveAnimation setCompletionBlock:^(POPAnimation *anim, BOOL finished) {
        @strongify(self);
        if (finished) {
            if (needDeal) {
                [self.giftEffectAnimateQueue removeObjectAtSafeIndex:0];
                if (self.giftEffectAnimateQueue.count > 0) {
                    [self _creatSpringView:self.giftEffectAnimateQueue[0]];
                } else {
                    [UIView animateWithDuration:0.5 animations:^{
                        self.giftEffectView.alpha = 0;
                    }];
                }
                [view removeFromSuperview];
                view.giftReceiveInfo = nil;
                [self.springVisiablePool removeObject:view];
                [self.springDequePool addObject:view];
            } else {
                if ([view superview]) {
                    [view removeFromSuperview];
                    view.giftReceiveInfo = nil;
                    [self.springVisiablePool removeObject:view];
                    [self.springDequePool addObject:view];
                }
            }
        }
    }];
    [view pop_addAnimation:moveAnimation forKey:@"moveOutAnimation"];
}

//计算房间魔法坐标
- (void)_calRoomMagicAnimatinPoint:(RoomMagicInfo *)receiveRoomMagicInfo{
    if (!GetCore(RoomCoreV2).hasAnimationEffect) {
        [self.magicEffectAnimationQueue removeAllObjects];
        return;
    }
    
    if (receiveRoomMagicInfo.targetUids.count == 0 && receiveRoomMagicInfo.targetUid <= 0 ) {
        return;
    }
    
    RoomMagicInfo *magicInfo = [GetCore(RoomMagicCore) findLocalMagicListsByMagicId:receiveRoomMagicInfo.giftMagicId];
    magicInfo = magicInfo == nil ? [[RoomMagicInfo alloc] init] : magicInfo;
    magicInfo.playPosition = magicInfo.playPosition;
    
    if ((magicInfo.magicSvgUrl.length <= 0  || magicInfo.magicSvgUrl == nil) && receiveRoomMagicInfo.magicSvgUrl) {
        magicInfo.magicSvgUrl = receiveRoomMagicInfo.magicSvgUrl;
    }
    if (receiveRoomMagicInfo.targetUids.count > 0) {//全麦
        for (NSString *targetUid in receiveRoomMagicInfo.targetUids) {
            
            if ([targetUid isKindOfClass:[NSString class]] ||
                [targetUid isKindOfClass:[NSNumber class]]) {
                NSDictionary *postionDictionary = [TTGameRoomAnimationProvider ttCreateRoomMagicPosition:self.roomOwner.uid
                                                                                          giftRecivieUid:receiveRoomMagicInfo.uid
                                                                                               targetUid:targetUid.userIDValue
                                                                                     containerController:self];
                if (!postionDictionary) {
                    continue;
                }
                dispatch_time_t timer = dispatch_time(DISPATCH_TIME_NOW, 0.5 * NSEC_PER_SEC);
                @weakify(self);
                dispatch_after(timer, dispatch_get_main_queue(), ^{
                    @strongify(self);
                    [self _createRoomMagicAnimation:magicInfo.magicSvgUrl
                                               from:[postionDictionary[@"start"] CGPointValue]
                                                 to:[postionDictionary[@"end"] CGPointValue]
                                           position:magicInfo.playPosition];
                });
                
            }else {
                break;
            }
        }
        
    }else {
        NSDictionary *postionDictionary = [TTGameRoomAnimationProvider ttCreateRoomMagicPosition:self.roomOwner.uid
                                                                                  giftRecivieUid:receiveRoomMagicInfo.uid
                                                                                       targetUid:receiveRoomMagicInfo.targetUid
                                                                             containerController:self];
        if (!postionDictionary) {
            return;
        }
        [self _createRoomMagicAnimation:magicInfo.magicSvgUrl
                                   from:[postionDictionary[@"start"] CGPointValue]
                                     to:[postionDictionary[@"end"] CGPointValue]
                               position:magicInfo.playPosition];
    }
}
//创建房间魔法
- (void)_createRoomMagicAnimation:(NSString *)magicUrl from:(CGPoint)orginPoint to:(CGPoint)destinationPoint position:(RoomMagicPlayPostion)playPostion{
    if (magicUrl == nil || magicUrl.length <= 0) {
        return;
    }
    SVGAImageView *roomMagicView = [self.magicDequePool anyObject];
    if (roomMagicView == nil) {
        roomMagicView = [[SVGAImageView alloc] init];
        [self.magicVisiablePool addObject:roomMagicView];
    }else{
        [self.magicDequePool removeObject:roomMagicView];
    }
    
    roomMagicView.contentMode = UIViewContentModeCenter;
    roomMagicView.frame = CGRectMake(0, 0, 120, 120);
    roomMagicView.center = orginPoint;
    roomMagicView.delegate = self;
    roomMagicView.userInteractionEnabled = NO;
    [self.view addSubview:roomMagicView];
    [self.view bringSubviewToFront:roomMagicView];
    
    CAKeyframeAnimation *pathAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    pathAnimation.calculationMode = kCAAnimationPaced;
    pathAnimation.fillMode = kCAFillModeForwards;
    pathAnimation.removedOnCompletion = NO;
    
    pathAnimation.repeatCount = 1;
    pathAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    pathAnimation.duration=1;
    
    CGMutablePathRef path = CGPathCreateMutable();
    CGPoint start = roomMagicView.center;
    int randomOffSet = 0;
    if (playPostion != RoomMagicPlayPostionCenter) {
        randomOffSet = arc4random() % 60 - 30;
    }
    
    CGPoint end = CGPointMake(destinationPoint.x+randomOffSet, destinationPoint.y+randomOffSet);
    CGFloat cpx = (start.x + end.x) / 2;
    CGFloat cpy = 100;
    CGPathMoveToPoint(path, NULL, start.x, start.y);
    CGPathAddQuadCurveToPoint(path, NULL, cpx, cpy, end.x, end.y);
    
    pathAnimation.path=path;
    [roomMagicView.layer addAnimation:pathAnimation forKey:@"pathAnimation"];
    CGPathRelease(path);
    [self.parser loadSvgaWithURL:[NSURL URLWithString:magicUrl] completionBlock:^(SVGAVideoEntity * _Nullable videoItem) {
        roomMagicView.loops = 1;
        roomMagicView.clearsAfterStop = YES;
        roomMagicView.videoItem = videoItem;
        [roomMagicView startAnimation];
    } failureBlock:^(NSError * _Nullable error) {
        
    }];
    //播放房间魔法特效
    [self createRoomMagicEffectAnimation];
}

- (void)_reset{
    
    for (UIImageView *imageView in self.giftVisiablePool.allObjects) {
        @autoreleasepool {
            imageView.image = nil;
            dispatch_async(dispatch_get_global_queue(0, 0),^{
                [imageView class];
            });
        }
    }
    NSMutableSet *tmpSet = self.giftVisiablePool;
    self.giftVisiablePool = nil;
    dispatch_async(dispatch_get_global_queue(0,0),^{
        [tmpSet class];
    });
    
    
    for (UIImageView *imageView in self.giftDequePool.allObjects) {
        @autoreleasepool {
            imageView.image = nil;
            dispatch_async(dispatch_get_global_queue(0, 0),^{
                [imageView class];
            });
        }
    }
    tmpSet = self.giftDequePool;
    self.giftDequePool = nil;
    dispatch_async(dispatch_get_global_queue(0,0),^{
        [tmpSet class];
    });
    
    for (SVGAImageView *imageView in self.magicVisiablePool.allObjects) {
        @autoreleasepool {
            imageView.videoItem = nil;
            dispatch_async(dispatch_get_global_queue(0, 0),^{
                [imageView class];
            });
        }
    }
    tmpSet = self.magicVisiablePool;
    self.magicVisiablePool = nil;
    dispatch_async(dispatch_get_global_queue(0,0),^{
        [tmpSet class];
    });
    
    for (SVGAImageView *imageView in self.magicDequePool.allObjects) {
        @autoreleasepool {
            imageView.videoItem = nil;
            dispatch_async(dispatch_get_global_queue(0, 0),^{
                [imageView class];
            });
        }
    }
    tmpSet = self.magicDequePool;
    self.magicDequePool = nil;
    dispatch_async(dispatch_get_global_queue(0,0),^{
        [tmpSet class];
    });
    
    
    
    for (TTGiftSpringView *imageView in self.springVisiablePool.allObjects) {
        @autoreleasepool {
            dispatch_async(dispatch_get_global_queue(0, 0),^{
                [imageView class];
            });
        }
    }
    tmpSet = self.springVisiablePool;
    self.springVisiablePool = nil;
    dispatch_async(dispatch_get_global_queue(0,0),^{
        [tmpSet class];
    });
    
    for (TTGiftSpringView *imageView in self.springDequePool.allObjects) {
        @autoreleasepool {
            dispatch_async(dispatch_get_global_queue(0, 0),^{
                [imageView class];
            });
        }
    }
    tmpSet = self.springDequePool;
    self.springDequePool = nil;
    dispatch_async(dispatch_get_global_queue(0,0),^{
        [tmpSet class];
    });
    
    [self.giftAnimateQueue removeAllObjects];
    [self.magicAnimationQueue removeAllObjects];
}

- (void)initView {
    
    [self addChildViewController:self.roomController];
    [self.view addSubview:self.roomController.view];
    
    //音乐播放器入口按钮
    [self.view addSubview:self.musicEntrance];
    
    UIView *roomBlackScale = [[UIView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    roomBlackScale.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.2];
    [self.view insertSubview:self.roomBg atIndex:0];
    [self.view insertSubview:self.svgDisplayView belowSubview:self.roomBg];
    [self.view insertSubview:roomBlackScale aboveSubview:self.roomBg];
        
    if (GetCore(TTGameStaticTypeCore).openRoomStatus == OpenRoomType_CP){
        roomBlackScale.hidden = YES;
    }
    
    [self.view addSubview:self.nobleOpenEffectView];
    [self.view addSubview:self.svgaCarEffectView];
    [self.view bringSubviewToFront:self.svgaCarEffectView];
    [self.view bringSubviewToFront:self.nobleOpenEffectView];
    
    [self.nobleOpenEffectView addSubview:self.nobleOpenTextLabel];
    [self.nobleOpenEffectView addSubview:self.nobleOpenCloseBtn];
    
    [self.view addSubview:self.giftDisplayView];
    [self.view addSubview:self.giftEffectView];
    [self.view addSubview:self.roomMagicEffectView];
    
    self.giftEffectView.delegate = self;
    self.giftEffectView.alpha = 0;
    self.roomMagicEffectView.delegate = self;
    
    
    GetCore(MeetingCore).voiceVol = 50;
}

- (void)initConstrations {
    
    [self.roomController.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view);
    }];
    
    //音乐播放器入口
    [self.musicEntrance mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(statusbarHeight+57);
        make.width.mas_equalTo(59);
        make.height.mas_equalTo(26);
        make.trailing.mas_equalTo(self.view.mas_trailing).offset(0);
    }];
    
    [self.nobleOpenTextLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.centerY.mas_equalTo(self.view.mas_centerY).offset(170); //340为SVGA动画的高度一半
        make.width.mas_offset(self.view.frame.size.width - 30);
    }];
    
    [self.nobleOpenCloseBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.mas_equalTo(self.view.mas_trailing).offset(-27);
        if (@available(iOS 11.0, *)) {
            make.top.mas_equalTo(self.view.mas_safeAreaLayoutGuideTop).offset(60);
        } else {
            make.top.mas_equalTo(self.view.mas_top).offset(60);
        }
        make.width.mas_equalTo(40);
        make.height.mas_equalTo(40);
    }];
}

- (void)addcore{
    
    AddCoreClient(ImRoomCoreClient, self);
    AddCoreClient(ImRoomCoreClientV2, self);
    AddCoreClient(RoomCoreClient, self);
    AddCoreClient(GiftCoreClient, self);
    AddCoreClient(FileCoreClient, self);
    AddCoreClient(MeetingCoreClient, self);
    AddCoreClient(RoomMagicCoreClient, self);
    AddCoreClient(GameCoreClient, self);
    AddCoreClient(TTRoomUIClient, self);
    AddCoreClient(TTMp4PlayerClient, self);
}

- (void)roomExit{
    self.musicEntrance.hidden = YES;
}

// cpu>=100 && 开启了开启了礼物特效 && iOS12以下 && iPhone6及以下机型
- (void)showAutoCloseAnimationEffect:(float)cpu_usage {
    // 开启了房间特效, 并CPU占用高达100
    if (GetCore(RoomCoreV2).hasAnimationEffect && cpu_usage >= 70 && [YYUtility isIphone6AndLow]) { //  && iPhone6以下
        GetCore(RoomCoreV2).hasAnimationEffect = NO;
        // iPhone6及以下机型
        
        TTAlertConfig *config = [[TTAlertConfig alloc] init];
        config.title = @"温馨提示";
        config.message = @"哎呀，消息太多啦，为了你更好的体验，默认关闭礼物特效哦~  点击更多按钮可以开启礼物特效哦";
        
        [TTPopup alertWithConfig:config confirmHandler:^{
            
        } cancelHandler:^{
            
        }];
    }
}

#pragma mark - getters and setters
- (void)setIsSameRoom:(BOOL)isSameRoom {
    _isSameRoom = isSameRoom;
    
    self.roomController.isSameRoom = isSameRoom;
}

- (UIView *)giftDisplayView {
    if (!_giftDisplayView) {
        _giftDisplayView = [[UIView alloc]initWithFrame:self.view.bounds];
        _giftDisplayView.backgroundColor = [UIColor clearColor];
        _giftDisplayView.contentMode = UIViewContentModeScaleToFill;
        _giftDisplayView.userInteractionEnabled = NO;
    }
    return _giftDisplayView;
}

- (SVGAImageView *)giftEffectView {
    if (!_giftEffectView) {
        _giftEffectView = [[SVGAImageView alloc]init];
        _giftEffectView.backgroundColor = UIColorRGBAlpha(0x000000, 0.5);
        _giftEffectView.frame = self.view.bounds;
        _giftEffectView.userInteractionEnabled = NO;
    }
    return _giftEffectView;
}

- (SVGAImageView *)roomMagicEffectView {
    if (!_roomMagicEffectView) {
        _roomMagicEffectView = [[SVGAImageView alloc]init];
        _roomMagicEffectView.backgroundColor = [UIColor clearColor];
        _roomMagicEffectView.frame = self.view.bounds;
        _roomMagicEffectView.userInteractionEnabled = NO;
    }
    return _roomMagicEffectView;
}

- (TTGameRoomViewController *)roomController {
    if (!_roomController) {
        _roomController = [[TTGameRoomViewController alloc]init];
        _roomController.delegate = self;
        _roomController.view.backgroundColor = [UIColor clearColor];
    }
    return _roomController;
}

- (TTMusicPlayerView *)musicPlayerView {
    if (!_musicPlayerView) {
        _musicPlayerView = [[TTMusicPlayerView alloc]init];
        _musicPlayerView.delegate = self;
    }
    return _musicPlayerView;
}

- (UIView *)musicPlayerContainView {
    if (!_musicPlayerContainView) {
        _musicPlayerContainView = [[UIView alloc] init];
        _musicPlayerContainView.backgroundColor = [UIColor clearColor];
        
        _musicPlayerContainView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didRecognizedMusicPlayerContainViewTapGestureRecognizer:)];
        [_musicPlayerContainView addGestureRecognizer:tapGes];
    }
    return _musicPlayerContainView;
}

- (TTMusicEntrance *)musicEntrance {
    if (!_musicEntrance) {
        _musicEntrance = [[TTMusicEntrance alloc]init];
        _musicEntrance.delegate = self;
        NSString * myUid = [GetCore(AuthCore) getUid];
        BOOL isOnMic = [GetCore(RoomQueueCoreV2) isOnMicro:myUid.longLongValue];
        _musicEntrance.userInteractionEnabled = YES;
        _musicEntrance.delegate = self;
        if (isOnMic == YES) {
            _musicEntrance.hidden = NO;
        }else{
            _musicEntrance.hidden = YES;
        }
        if (GetCore(RoomCoreV2).getCurrentRoomInfo.type == RoomType_CP) {
            if (GetCore(RoomCoreV2).getCurrentRoomInfo.isOpenGame) {
                _musicEntrance.hidden = YES;
            }
        }
    }
    return _musicEntrance;
}

- (NSMutableArray *)giftAnimateQueue {
    if (_giftAnimateQueue == nil) {
        _giftAnimateQueue = [NSMutableArray array];
    }
    return _giftAnimateQueue;
}
- (NSMutableArray *)giftEffectAnimateQueue {
    if (_giftEffectAnimateQueue == nil) {
        _giftEffectAnimateQueue = [NSMutableArray array];
    }
    return _giftEffectAnimateQueue;
}
- (NSMutableArray *)magicAnimationQueue{
    if (_magicAnimationQueue == nil) {
        _magicAnimationQueue = [NSMutableArray array];
    }
    return _magicAnimationQueue;
}
- (NSMutableArray *)magicEffectAnimationQueue{
    if (_magicEffectAnimationQueue == nil) {
        _magicEffectAnimationQueue = [NSMutableArray array];
    }
    return _magicEffectAnimationQueue;
}
- (NSMutableSet *)magicDequePool{
    if (!_magicDequePool) {
        _magicDequePool = [NSMutableSet set];
    }
    return _magicDequePool;
}
- (NSMutableSet *)magicVisiablePool{
    if (!_magicVisiablePool) {
        _magicVisiablePool = [NSMutableSet set];
    }
    return _magicVisiablePool;
}
- (NSMutableSet *)giftDequePool {
    if (!_giftDequePool) {
        _giftDequePool = [NSMutableSet set];
    }
    return _giftDequePool;
}
- (NSMutableSet *)giftVisiablePool {
    if (!_giftVisiablePool) {
        _giftVisiablePool = [NSMutableSet set];
    }
    return _giftVisiablePool;
}
- (NSMutableSet *)springDequePool {
    if (!_springDequePool) {
        _springDequePool = [NSMutableSet set];
    }
    return _springDequePool;
}
- (NSMutableSet *)springVisiablePool {
    if (!_springVisiablePool) {
        _springVisiablePool = [NSMutableSet set];
    }
    return _springVisiablePool;
}

- (NSMutableArray *)boxPirzeAnimationQueue {
    if (!_boxPirzeAnimationQueue) {
        _boxPirzeAnimationQueue = [NSMutableArray array];
    }
    return _boxPirzeAnimationQueue;
}

- (UIVisualEffectView *)effectView {
    if (!_effectView) {
        UIBlurEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
        _effectView = [[UIVisualEffectView alloc]initWithEffect:effect];
        _effectView.frame = CGRectMake(0, 0, KScreenWidth, KScreenHeight);
    }
    return _effectView;
}

- (SVGAParserManager *)parser {
    if (!_parser) {
        _parser = [[SVGAParserManager alloc]init];
    }
    return _parser;
}
- (NSArray *)luckyBagAnimationImages{
    if (!_luckyBagAnimationImages) {
        NSMutableArray *arrayM = [NSMutableArray array];
        for (int i = 0; i<=20; i++) {
            UIImage *img = [UIImage imageNamed:[NSString stringWithFormat:@"room_gift_lucky_bag_%02d",i]];
            [arrayM addObject:img];
        }
        _luckyBagAnimationImages = [arrayM copy];
    }
    return _luckyBagAnimationImages;
}

@end
