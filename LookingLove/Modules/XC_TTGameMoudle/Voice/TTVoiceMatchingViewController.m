//
//  TTVoiceMatchingViewController.m
//  XC_TTGameMoudle
//
//  Created by Macx on 2019/5/30.
//  Copyright © 2019 YiZhuan. All rights reserved.
//

#import "TTVoiceMatchingViewController.h"

#import "TTVoiceMyViewController.h"
#import "TTVoiceRecordViewController.h"
#import "TTWKWebViewViewController.h"
#import "XCMediator+TTMessageMoudleBridge.h"
#import "XCMediator+TTPersonalMoudleBridge.h"
#import "XCCurrentVCStackManager.h"

#import "TTVoiceMatchingNavView.h"
#import "TTVoiceSelectSexView.h"
#import "TTUseGreetingsAlertView.h"
#import "TTVoiceMyView.h"
#import "TTVoiceBottleView.h"
#import "TTVoiceLoadingView.h"

#import "PKRWaveAnimation.h"
#import "TTPopup.h"
#import "TTNewbieGuideView.h"

#import "VoiceBottleCore.h"
#import "VoiceBottleModel.h"
#import "VoiceBottleCoreClient.h"
#import "AuthCore.h"
#import "UserCore.h"
#import "XCPlayerTool.h"
#import "MeetingCore.h"

#import "XCMacros.h"
#import "XCTheme.h"
#import "XCHUDTool.h"
#import "SVGA.h"
#import "SVGAParserManager.h"
#import "XCHtmlUrl.h"
#import "TTStatisticsService.h"
#import "XCFloatView.h"

#import <Masonry/Masonry.h>

#define kScale (KScreenWidth / 375)

/** 没有录制音频时, 点击不喜欢次数, 存储的是字典{uid : count} */
static NSString *const kUnlikeButtonDidClickCountKey = @"kUnlikeButtonDidClickCountKey";
/** 新手引导页 */
static NSString *const kVoiceGuideStatusStoreKey = @"TTVoiceViewControllerMatchGuideStatus";

@interface TTVoiceMatchingViewController ()<TTVoiceSelectSexViewDelegate, TTUseGreetingsAlertViewDelegate, MLSwipeableViewDataSource, MLSwipeableViewDelegate, VoiceBottleCoreClient, TTVoiceLoadingViewDelegate, TTVoiceBottleViewDelegate>

/** 导航栏 */
@property (nonatomic, strong) TTVoiceMatchingNavView *navView;
/** bg */
@property (nonatomic, strong) UIImageView *bgImageView;
/** 我的声音 */
@property (nonatomic, strong) TTVoiceMyView *myVoiceView;
/** swipeableView */
@property (nonatomic, strong) MLSwipeableView *swipeableView;;

/** 不喜欢 */
@property (nonatomic, strong) UIButton *unlikeButton;
/** 喜欢 */
@property (nonatomic, strong) UIButton *likeButton;
/** 水波纹 */
@property (nonatomic, strong) PKRWaveAnimation *waveAnimView;
/** loading */
@property (nonatomic, strong) TTVoiceLoadingView *loadingView;
/** 喜欢动画 */
@property (nonatomic, strong) SVGAImageView *likeSvgaImageView;

/** timer */
@property (nonatomic, weak) NSTimer *timer;

/** bottleView数组 */
@property (nonatomic, strong) NSArray *bottleViewArray;
/** 声音瓶子模型数组 */
@property (nonatomic, strong) NSMutableArray *bottleModels;
/** 声音瓶子是否 全部滑完了 */
@property (nonatomic, assign) BOOL isVoiceSlideOver;
/** 声音瓶子是否 即将滑完了 */
@property (nonatomic, assign) BOOL isVoiceWillSlideOver;
/** 是否没有更多瓶子了 */
@property (nonatomic, assign) BOOL isNoMoreVoice;
/** 是都展示了UseGreetingsAlertView */
@property (nonatomic, assign) BOOL isShowUseGreetingsAlertView;
/** 旧版本个人介绍模型 */
@property (nonatomic, strong) VoiceBottleModel *historyVoiceModel;
/** 是否已录制声音 */
@property (nonatomic, assign) BOOL hasVoice;
/** SVGAParserManager */
@property (nonatomic, strong) SVGAParserManager *parserManager;

/** 当前正在展示瓶子的view */
@property (nonatomic, strong) TTVoiceBottleView *currentBottleView;
/** isViewDidAppear */
@property (nonatomic, assign) BOOL isViewDidAppear;
/** 又滑喜欢 将要跳转到私聊页面 */
@property (nonatomic, assign) BOOL isWillJump;

/** 用来记录离开萌圈是否需要还原麦序状态*/
@property (nonatomic, assign) BOOL needOpenMicrState;
@property (nonatomic, assign) BOOL needOpenMuteState;

@end

@implementation TTVoiceMatchingViewController

#pragma mark - life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initView];
    [self initAction];
    [self requestData];
    [self initConstrations];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.myVoiceView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.view).offset(0);
        make.top.mas_equalTo(self.navView.mas_bottom).offset(51 * kScale);
        make.width.mas_equalTo(99);
        make.height.mas_equalTo(50);
    }];
    self.myVoiceView.titleLabel.alpha = 1;
    self.timer = [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(myVoiceViewShrinkAction) userInfo:nil repeats:NO];
    
    // 如果房间最小化，关闭声音
    [self updateStatus:YES];
    // 播放
    [self startPlayCurrentVoice];
    // 用户在录制界面没有保存声音就按返回到声音匹配页面，需要再次弹使用打招呼咨询弹窗；
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.timer = nil;
    [self stopPlayCurrentVoice];
    
    // 如果房间最小化状态，开启声音
    [self updateStatus:NO];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (!self.isViewDidAppear) {
        self.isViewDidAppear = YES;
        [self requestVoiceBottleData];
        // 提前加载2个瓶子, 滑动时循环使用
        self.bottleViewArray = @[[TTVoiceBottleView new], [TTVoiceBottleView new]];
    } else {
        if (!self.hasVoice) {
            [self showUseGreetingsAlertView];
        }
    }
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    //Remove Client Here
    RemoveCoreClientAll(self);
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

#pragma mark - public methods
- (void)updateStatus:(BOOL)appear {
    
    if (GetCore(ImRoomCoreV2).currentRoomInfo.roomId>0) {
        
        [[XCFloatView shareFloatView] setHidden:appear];
        
        if (appear && GetCore(MeetingCore).isPlaying) {
            [GetCore(MeetingCore) pausePlayMusic];
            GetCore(MeetingCore).isPlaying = NO;
        }
        
        if (appear) {
            if (!GetCore(MeetingCore).isCloseMicro) {
                self.needOpenMicrState = YES;
                [GetCore(MeetingCore) setCloseMicro:YES];
            }
            if (!GetCore(MeetingCore).isMute) {
                [GetCore(MeetingCore) setMute:YES];
                self.needOpenMuteState = YES;
            }
        } else {
            if (self.needOpenMicrState) {
                [GetCore(MeetingCore) setCloseMicro:NO];
            }
            if (self.needOpenMuteState) {
                [GetCore(MeetingCore) setMute:NO];
            }
            
            if (!GetCore(MeetingCore).isPlaying) {
                [GetCore(MeetingCore) resumePlayMusic];
                GetCore(MeetingCore).isPlaying = YES;
            }
        }
    }
}
#pragma mark - [系统控件的Protocol]   //注意要把名字改掉，这个MARK只做功能划分，不是一个真正的MARK，每个不一样的Protocol，需要一个新的MARK”

#pragma mark - TTVoiceBottleViewDelegate
/** 点击了去举报按钮 */
- (void)voiceBottleView:(TTVoiceBottleView *)voiceBottleView didClickReportButton:(UIButton *)button {
    TTWKWebViewViewController *webViewController = [[TTWKWebViewViewController alloc] init];
    NSString *urlstr = [NSString stringWithFormat:@"%@?reportUid=%ld&source=VOICE", HtmlUrlKey(kReportURL), (long)voiceBottleView.bottleModel.uid];
    webViewController.urlString = urlstr;
    [self.navigationController pushViewController:webViewController animated:YES];
}

#pragma mark - TTVoiceLoadingViewDelegate
/** 点击了刷新按钮 */
- (void)voiceLoadingView:(TTVoiceLoadingView *)voiceLoadingView didClickRrefreshButton:(UIButton *)button {
    [self requestVoiceBottleData];
}

#pragma mark - TTVoiceSelectSexViewDelegate
/** 点击了关闭 */
- (void)voiceSelectSexViewCloseAction:(TTVoiceSelectSexView *)selectSexView {
    
}

/** 点击了确定按钮 */
- (void)voiceSelectSexView:(TTVoiceSelectSexView *)selectSexView didClickSureButton:(UIButton *)button {
    [TTPopup dismiss];
    
    [self.bottleModels removeAllObjects];
    [self requestVoiceBottleData];
}

#pragma mark - TTUseGreetingsAlertViewDelegate
/** 点击了去录制按钮 */
- (void)useGreetingsAlertView:(TTUseGreetingsAlertView *)useGreetingsAlertView didClickRecordButton:(UIButton *)button {
    [TTPopup dismiss];
    [self pushToRecordVC:self.historyVoiceModel.id];
    self.isShowUseGreetingsAlertView = NO;
    [TTStatisticsService trackEvent:@"soundmatch_useOld_pop" eventDescribe:@"询问使用弹窗-去录制"];
}

/** 点击了确认使用按钮 */
- (void)useGreetingsAlertView:(TTUseGreetingsAlertView *)useGreetingsAlertView didClickSureUseButton:(UIButton *)button {
    [TTPopup dismiss];
    self.isShowUseGreetingsAlertView = NO;
    [self startPlayCurrentVoice];
    [GetCore(VoiceBottleCore) sendOldVoiceIntroduceSyncVoiceBottle:self.historyVoiceModel.id];
    [TTStatisticsService trackEvent:@"soundmatch_useOld_pop" eventDescribe:@"询问使用弹窗-确认使用"];
}

#pragma mark - MLSwipeableViewDataSource
- (UIView<SwipeableViewProtocol> *)nextViewForSwipeableView:(MLSwipeableView *)swipeableView index:(NSUInteger)index {
    
    VoiceBottleModel *model = [self.bottleModels safeObjectAtIndex:index];
    if (!model) {
        self.isVoiceWillSlideOver = YES;
        return nil;
    }
    
    self.isVoiceWillSlideOver = NO;
    self.isVoiceSlideOver = NO;
    NSUInteger i = index % self.bottleViewArray.count;
    TTVoiceBottleView *item = self.bottleViewArray[i];
//    item.frame = CGRectInset(swipeableView.bounds, 0, 0);
    item.frame = CGRectMake(0, 0, 295 * kScale, (441 + 100) * kScale);
    item.bottleModel = model;
    item.heartImageView.hidden = YES;
    item.delegate = self;
    return item;
}

#pragma mark - MLSwipeableViewDelegate
- (void)swipeableView:(MLSwipeableView *)swipeableView willDisplay:(UIView *)view {
    if (view) {
        TTVoiceBottleView *item = (TTVoiceBottleView *)view;
        item.heartImageView.hidden = NO;
    }
}

- (void)swipeableView:(MLSwipeableView *)swipeableView didDisplay:(UIView *)view {
    self.currentBottleView = (TTVoiceBottleView *)view;
    
    if (!self.isShowUseGreetingsAlertView) { // 如果正在展示 "使用打招呼弹框", 则不自动播放
        // 播放
        [self startPlayCurrentVoice];
    }
}

- (BOOL)swipeableView:(MLSwipeableView *)swipeableView willSwipeLeft:(UIView *)view {
    return [self shouldUnlikeAction];
}

- (BOOL)swipeableView:(MLSwipeableView *)swipeableView willSwipeRight:(UIView *)view {
    if (self.isWillJump) {
        return NO;
    }
    return [self shouldLikeAction];
}

- (void)swipeableView:(MLSwipeableView *)swipeableView didSwipeLeft:(UIView *)view {
    if (self.isVoiceWillSlideOver) {
        self.isVoiceSlideOver = YES; // 瓶子滑完了, 没了
        
        [self stopPlayCurrentVoice];
        self.currentBottleView = nil;
        [self requestVoiceBottleData];
    }
}

- (void)swipeableView:(MLSwipeableView *)swipeableView didSwipeRight:(UIView *)view {
    if (self.isVoiceWillSlideOver) {
        self.isVoiceSlideOver = YES; // 瓶子滑完了, 没了
        
        [self stopPlayCurrentVoice];
        self.currentBottleView = nil;
        [self requestVoiceBottleData];
    }
}

#pragma mark - VoiceBottleCoreClient
/** 获取声音匹配列表 */
- (void)requestVoiceMatchingListSuccess:(NSArray<VoiceBottleModel *> *)array {
    [self hideLoadingView];
    
    if (self.isVoiceSlideOver) {
        [self.bottleModels removeAllObjects];
    }
    
    if (array.count == 0) {
        // 没有更多数据了
        self.isNoMoreVoice = YES;
    } else {
        self.isNoMoreVoice = NO;
    }
    
    if (self.bottleModels.count == 0) {
        if (self.isNoMoreVoice) {
            // 展示没有更多数据
            [self showLoadingViewWithStatus:TTVoiceLoadingViewStatusNoMore];
        } else {
            if (!self.swipeableView.superview) {
                [self.view insertSubview:self.swipeableView aboveSubview:self.bgImageView];
            }
        }
        [self.bottleModels addObjectsFromArray:array];
        [self.swipeableView reloadData];
    } else {
        [self.bottleModels addObjectsFromArray:array];
    }
    
    if (projectType() == ProjectType_LookingLove || projectType() == ProjectType_Planet) {
        return;
    }
    if (self.bottleModels.count > 0) {
        NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
        BOOL hadGuide = [ud boolForKey:kVoiceGuideStatusStoreKey];
        if (!hadGuide) {
            [ud setBool:YES forKey:kVoiceGuideStatusStoreKey];
            [ud synchronize];
            [self showGuideView];
        }
    }
}

- (void)requestVoiceMatchingListFail:(NSString *)message errorCode:(NSNumber *)errorCode {
    [XCHUDTool showErrorWithMessage:message];
    [self showLoadingViewWithStatus:TTVoiceLoadingViewStatusNoNet];
}

/** 查询旧版本个人介绍声音 */
- (void)requestOldVoiceIntroduceSuccess:(NSDictionary *)dict {
    self.historyVoiceModel = [VoiceBottleModel yy_modelWithJSON:dict[@"historyVoice"]];
    self.hasVoice = [dict[@"hasVoice"] boolValue];
    
    [self showUseGreetingsAlertView];
}

- (void)requestOldVoiceIntroduceFail:(NSString *)message errorCode:(NSNumber *)errorCode {
    
}

/** 同步旧版本个人介绍声音到声音瓶子 */
- (void)sendOldVoiceIntroduceSyncVoiceBottleSuccess {
    self.hasVoice = YES;
}

- (void)sendOldVoiceIntroduceSyncVoiceBottleFail:(NSString *)message errorCode:(NSNumber *)errorCode {
    [XCHUDTool showErrorWithMessage:message];
    [self showUseGreetingsAlertView];
}

/** 声音录制完成 回调声音model*/
- (void)recordVoiceCompleteWithVoiceBottleModel:(VoiceBottleModel *)voiceModel {
    self.hasVoice = YES;
}

#pragma mark - event response
- (void)didClickUnlikeButton:(UIButton *)button {
    button.enabled = NO;
    // 1s内只允许点击一次
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        button.enabled = YES;
    });
    
    [self.swipeableView swipeTopViewToLeft];
}

- (void)didClickLikeButton:(UIButton *)button {
    button.enabled = NO;
    // 1s内只允许点击一次
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        button.enabled = YES;
    });
    
    [self.swipeableView swipeTopViewToRight];
}

- (void)didTapMyVoiceView:(UITapGestureRecognizer *)tapGes {
    [TTStatisticsService trackEvent:@"my_sound" eventDescribe:@"声音瓶子"];
    TTVoiceMyViewController *vc = [[TTVoiceMyViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)myVoiceViewShrinkAction {
    [self.myVoiceView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.view).offset(51);
    }];
    self.timer = nil;
    [UIView animateWithDuration:0.6 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.myVoiceView.titleLabel.alpha = 0;
        [self.view layoutIfNeeded];
    } completion:nil];
}

- (void)appDidEnterBackground {
    [[XCPlayerTool sharedPlayerTool] pause];
    self.currentBottleView.playOrPauseButton.selected = YES;
}

#pragma mark - private method
- (void)pushToRecordVC:(NSInteger)voiceId {
    TTVoiceRecordViewController *recordVC = [[TTVoiceRecordViewController alloc] init];
    if (voiceId > 0) {
        recordVC.voiceId = voiceId;
    }
    [self.navigationController pushViewController:recordVC animated:YES];
}

// 开始播放当前的声音瓶子
- (void)startPlayCurrentVoice {
    [self.currentBottleView resetBottleView];
    if (self.currentBottleView.bottleModel.voiceUrl.length) {
        [[XCPlayerTool sharedPlayerTool] startPlay:self.currentBottleView.bottleModel.voiceUrl];
        [XCPlayerTool sharedPlayerTool].delegate = self.currentBottleView;
    }
}

- (void)stopPlayCurrentVoice {
    [[XCPlayerTool sharedPlayerTool] stop];
    [XCPlayerTool sharedPlayerTool].delegate = nil;
    [self.currentBottleView resetBottleView];
}

- (void)showUseGreetingsAlertView {
    if (![[XCCurrentVCStackManager shareManager].getCurrentVC isKindOfClass:[self class]]) {
        return;
    }
    if (!self.hasVoice && self.historyVoiceModel.id) {
        [self stopPlayCurrentVoice];
        self.isShowUseGreetingsAlertView = YES;
        TTUseGreetingsAlertView *alertView = [[TTUseGreetingsAlertView alloc] init];
        alertView.model = self.historyVoiceModel;
        alertView.delegate = self;
        TTPopupConfig *config = [[TTPopupConfig alloc] init];
        config.contentView = alertView;
        config.style = TTPopupStyleAlert;
        [TTPopup popupWithConfig:config];
    }
}

- (void)showLoadingViewWithStatus:(TTVoiceLoadingViewStatus)status {
    self.loadingView.status = status;
    self.loadingView.hidden = NO;
    
    self.likeButton.hidden = YES;
    self.unlikeButton.hidden = YES;
    self.likeSvgaImageView.hidden = YES;
    _swipeableView.hidden = YES;
    
    if (status == TTVoiceLoadingViewStatusNoNet || status == TTVoiceLoadingViewStatusNoMore) {
        [self stopPlayCurrentVoice];
        self.currentBottleView = nil;
    }
}

- (void)hideLoadingView {
    self.loadingView.hidden = YES;
    
    self.likeButton.hidden = NO;
    self.unlikeButton.hidden = NO;
    self.likeSvgaImageView.hidden = NO;
    _swipeableView.hidden = NO;
}

- (void)showGoRecordAlertWithMessage:(NSString *)message {
    
    if (![[XCCurrentVCStackManager shareManager].getCurrentVC isKindOfClass:[self class]]) {
        return;
    }
    
    TTAlertConfig *config = [[TTAlertConfig alloc] init];
    config.title = @"提示";
    config.message = message;
    config.cancelButtonConfig.title = @"取消";
    config.confirmButtonConfig.title = @"去录制";
    @KWeakify(self);
    [TTPopup alertWithConfig:config confirmHandler:^{
        @KStrongify(self);
        // 去录制
        [self pushToRecordVC:0];
    } cancelHandler:^{
        
    }];
}

// 是否需要响应喜欢的动作
- (BOOL)shouldLikeAction {
    if (!self.hasVoice) {
        [self showGoRecordAlertWithMessage:@"想要进一步了解Ta\n需要先录制一个声音哦~"];
        [TTStatisticsService trackEvent:@"soundmatch_record_pop" eventDescribe:@"去录制弹窗-喜欢"];
        return NO;
    }
    
    NSString *matchString = [[NSBundle mainBundle] pathForResource:@"voiceMatching_like" ofType:@"svga"];
    NSURL *matchUrl = [NSURL fileURLWithPath:matchString];
    
    @KWeakify(self);
    self.likeSvgaImageView.hidden = NO;
    [self.parserManager loadSvgaWithURL:matchUrl completionBlock:^(SVGAVideoEntity * _Nullable videoItem) {
        @KStrongify(self)
        self.likeSvgaImageView.loops = 1;
        self.likeSvgaImageView.clearsAfterStop = NO;
        self.likeSvgaImageView.videoItem = videoItem;
        [self.likeSvgaImageView startAnimation];
    } failureBlock:^(NSError * _Nullable error) {
        
    }];
    
    [self addScaleAnimation:_likeButton];
    self.isWillJump = YES;
    NSInteger uid = self.currentBottleView.bottleModel.uid;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.7 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        @KStrongify(self);
        // 跳转到私聊
        UIViewController *controller = [[XCMediator sharedInstance] ttMessageMoudle_TTSessionViewController:uid sessectionType:NIMSessionTypeP2P];
        [self.navigationController pushViewController:controller animated:YES];
        self.likeSvgaImageView.hidden = YES;
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            self.isWillJump = NO;
        });
    });
    
    [GetCore(VoiceBottleCore) sendVoiceLikeRequestWithVoiceId:self.currentBottleView.bottleModel.id isLike:YES];
    
    [TTStatisticsService trackEvent:@"soundmatch_like" eventDescribe:@"声音匹配_喜欢"];
    
    return YES;
}

// 是否需要响应不喜欢的动作
- (BOOL)shouldUnlikeAction {
    
    if (![self canListenWhenNoVoice]) {
        return NO;
    }
    
    [self addScaleAnimation:_unlikeButton];
    
    [GetCore(VoiceBottleCore) sendVoiceLikeRequestWithVoiceId:self.currentBottleView.bottleModel.id isLike:NO];
    
    [TTStatisticsService trackEvent:@"soundmatch_unlike" eventDescribe:@"声音匹配_不喜欢"];
    return YES;
}

- (BOOL)canListenWhenNoVoice {
    if (!self.hasVoice) {
        NSDictionary *dict = [[NSUserDefaults standardUserDefaults] dictionaryForKey:kUnlikeButtonDidClickCountKey];
        NSString *key = [GetCore(AuthCore) getUid];
        if (key.length) {
            NSInteger count = [dict[key] integerValue];
            if (count > 1) { // 只能点两次
                [self showGoRecordAlertWithMessage:@"想要捡更多声音瓶子\n需要先录制一个声音哦~"];
                [TTStatisticsService trackEvent:@"soundmatch_record_pop" eventDescribe:@"去录制弹窗-不喜欢"];
                return NO;
            } else {
                count = count + 1;
                NSMutableDictionary *dictM = [NSMutableDictionary dictionaryWithDictionary:dict];
                dictM[key] = @(count);
                [[NSUserDefaults standardUserDefaults] setObject:dictM forKey:kUnlikeButtonDidClickCountKey];
            }
        } else {
            return NO;
        }
    }
    
    return YES;
}

// 添加缩放动画
- (void)addScaleAnimation:(UIView *)view {
    CAKeyframeAnimation *scaleAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
    NSValue *value1 = [NSNumber numberWithFloat:1.0];
    NSValue *value2 = [NSNumber numberWithFloat:0.9];
    NSValue *value3 = [NSNumber numberWithFloat:1.2];
    NSValue *value4 = [NSNumber numberWithFloat:1.0];
    scaleAnimation.values = @[value1, value2, value3, value4];
    scaleAnimation.duration = 0.5; //设置时间
    scaleAnimation.repeatCount = 1; //重复次数
    [view.layer addAnimation:scaleAnimation forKey:@"CQScale"];
}

- (void)requestData {
    [self showLoadingViewWithStatus:TTVoiceLoadingViewStatusLoading];
    AddCoreClient(VoiceBottleCoreClient, self);
    
    [GetCore(VoiceBottleCore) requestOldVoiceIntroduce];
}

- (void)requestVoiceBottleData {
    [self showLoadingViewWithStatus:TTVoiceLoadingViewStatusLoading];
    NSInteger gender = [self getRequestVoiceBottleListType];
    [GetCore(VoiceBottleCore) requestVoiceMatchingListWithGender:gender pageSize:10];
}

// 获取上次用户选中的性别类型, 默认为异性
- (NSInteger)getRequestVoiceBottleListType {
    NSString *gender = [[NSUserDefaults standardUserDefaults] stringForKey:kRequestVoiceBottleListTypeKey];
    if (!gender.length) {
        UserInfo *info = [GetCore(UserCore) getUserInfoInDB:[GetCore(AuthCore) getUid].userIDValue];
        if (info.gender == UserInfo_Male) {
            return 2;
        } else {
            return 1;
        }
    }
    
    return [gender integerValue];
}

- (void)showGuideView {
    CGPoint centerPoint = self.likeButton.center;
    
    CGRect newRect = CGRectMake(centerPoint.x - 45, centerPoint.y - 45, 90, 90);
    
    TTNewbieGuideView *guideView = [[TTNewbieGuideView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight) withArcWithFrame:newRect withSpace:YES withCorner:45 withPage:TTGuideViewPage_Voice];
    
    __block TTNewbieGuideView *guideViewBlock = guideView;
    @weakify(self);
    guideView.currentType = ^(NSInteger index) {
        @strongify(self);
        CGRect nextRect = CGRectMake(self.myVoiceView.frame.origin.x, self.myVoiceView.frame.origin.y, self.myVoiceView.frame.size.width * 2, self.myVoiceView.frame.size.height);
        
        [guideViewBlock addArcWithFrame:nextRect withCorner:self.myVoiceView.frame.size.height / 2];
        
        [guideViewBlock initViewWithPageName:TTGuideViewPage_Voice];
    };
    [self.view addSubview:guideView];
}

- (void)initAction {
    
    if (![[XCCurrentVCStackManager shareManager].getCurrentVC isKindOfClass:[self class]]) {
        return;
    }
    
    @KWeakify(self);
    self.navView.backButtonDidClickAction = ^{
        @KStrongify(self);
        [self.navigationController popViewControllerAnimated:YES];
    };
    
    self.navView.selectSexButtonDidClickAction = ^{
        @KStrongify(self);
        
        if (![self canListenWhenNoVoice]) {
            return;
        }
        
        TTVoiceSelectSexView *selectSexView = [[TTVoiceSelectSexView alloc] init];
        selectSexView.type = [self getRequestVoiceBottleListType];
        selectSexView.delegate = self;
        TTPopupConfig *config = [[TTPopupConfig alloc] init];
        config.contentView = selectSexView;
        config.style = TTPopupStyleActionSheet;
        [TTPopup popupWithConfig:config];
    };
}

- (void)initView {
    [self.view addSubview:self.bgImageView];
    [self.view addSubview:self.loadingView];
    [self.view addSubview:self.navView];
    [self.view addSubview:self.waveAnimView];
    [self.view addSubview:self.myVoiceView];
    [self.view addSubview:self.likeButton];
    [self.view addSubview:self.unlikeButton];
    [self.view addSubview:self.likeSvgaImageView];
    
    // 底部波浪效果
    [self.waveAnimView loadWaveView:2 waveColors:@[RGBACOLOR(255, 255, 255, 0.15), RGBACOLOR(255, 255, 255, 0.15)] opacity:1 amplitude:25 * kScale palstance:M_PI*1.5/CGRectGetWidth(self.view.frame) wavespeed:0.02 offsetY:0 isLaunchBubbles:NO];
    
    // app退到后台
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appDidEnterBackground) name:UIApplicationWillResignActiveNotification object:nil];
}

- (void)initConstrations {
    [self.bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.mas_equalTo(self.view);
    }];
    
    [self.loadingView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.mas_equalTo(self.view);
    }];
    
    [self.navView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.mas_equalTo(self.view);
        make.height.mas_equalTo(kSafeAreaTopHeight + 64);
    }];
    
    [self.waveAnimView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(self.view);
        make.height.mas_equalTo(kSafeAreaBottomHeight + 60 * kScale);
    }];
    
    [self.myVoiceView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.view).offset(0);
        make.top.mas_equalTo(self.navView.mas_bottom).offset(51 * kScale);
        make.width.mas_equalTo(99);
        make.height.mas_equalTo(50);
    }];
    
    [self.unlikeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(70 * kScale);
        make.top.mas_equalTo(38 * kScale + kSafeAreaTopHeight + 461 * kScale);
        make.width.mas_equalTo(70 * kScale);
        make.height.mas_equalTo(70 * kScale);
    }];
    
    [self.likeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-70 * kScale);
        make.centerY.width.height.mas_equalTo(self.unlikeButton);
    }];
    
    [self.likeSvgaImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-53 * kScale);
        make.center.mas_equalTo(self.likeButton);
        make.width.height.mas_equalTo(105 * kScale);
    }];
}

#pragma mark - getters and setters
- (BOOL)isHiddenNavBar {
    return YES;
}

- (TTVoiceMatchingNavView *)navView {
    if (!_navView) {
        _navView = [[TTVoiceMatchingNavView alloc] init];
        _navView.titleLabel.text = @"声音瓶子";
        _navView.selectSexButton.hidden = NO;
    }
    return _navView;
}

- (UIImageView *)bgImageView {
    if (!_bgImageView) {
        _bgImageView = [[UIImageView alloc] init];
        _bgImageView.image = [UIImage imageNamed:@"voice_bg"];
    }
    return _bgImageView;
}

- (TTVoiceMyView *)myVoiceView {
    if (!_myVoiceView) {
        _myVoiceView = [[TTVoiceMyView alloc] init];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapMyVoiceView:)];
        [_myVoiceView addGestureRecognizer:tap];
    }
    return _myVoiceView;
}

- (UIButton *)unlikeButton {
    if (!_unlikeButton) {
        _unlikeButton = [[UIButton alloc] init];
        [_unlikeButton setBackgroundImage:[UIImage imageNamed:@"voice_unlike_btn"] forState:UIControlStateNormal];
        [_unlikeButton setBackgroundImage:[UIImage imageNamed:@"voice_unlike_btn"] forState:UIControlStateDisabled];
        [_unlikeButton addTarget:self action:@selector(didClickUnlikeButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _unlikeButton;
}

- (UIButton *)likeButton {
    if (!_likeButton) {
        _likeButton = [[UIButton alloc] init];
        [_likeButton setBackgroundImage:[UIImage imageNamed:@"voice_like_btn"] forState:UIControlStateNormal];
        [_likeButton setBackgroundImage:[UIImage imageNamed:@"voice_like_btn"] forState:UIControlStateDisabled];
        [_likeButton addTarget:self action:@selector(didClickLikeButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _likeButton;
}

- (PKRWaveAnimation *)waveAnimView {
    if (!_waveAnimView) {
        _waveAnimView = [[PKRWaveAnimation alloc] init];
    }
    return _waveAnimView;
}

- (MLSwipeableView *)swipeableView {
    if (!_swipeableView) {
        CGFloat cardViewX = (KScreenWidth - 295 * kScale) / 2;
        _swipeableView = [[MLSwipeableView alloc] initWithFrame:CGRectMake(cardViewX, kSafeAreaTopHeight + 20, 295 * kScale, (441 + 100) * kScale)];
        _swipeableView.delegate = self;
        _swipeableView.dataSource = self;
        _swipeableView.threshold = 100;
        _swipeableView.rotationFactor = 0;
    }
    return _swipeableView;
}

- (NSMutableArray *)bottleModels {
    if (!_bottleModels) {
        _bottleModels = [NSMutableArray array];
    }
    return _bottleModels;
}

- (TTVoiceLoadingView *)loadingView {
    if (!_loadingView) {
        _loadingView = [[TTVoiceLoadingView alloc] init];
        _loadingView.delegate = self;
    }
    return _loadingView;
}

- (SVGAParserManager *)parserManager {
    if (!_parserManager) {
        _parserManager = [[SVGAParserManager alloc] init];
    }
    return _parserManager;
}

- (SVGAImageView *)likeSvgaImageView {
    if (!_likeSvgaImageView) {
        _likeSvgaImageView = [[SVGAImageView alloc]init];
        _likeSvgaImageView.contentMode = UIViewContentModeScaleAspectFill;
        _likeSvgaImageView.userInteractionEnabled = NO;
        _likeSvgaImageView.hidden = YES;
    }
    return _likeSvgaImageView;
}
@end
