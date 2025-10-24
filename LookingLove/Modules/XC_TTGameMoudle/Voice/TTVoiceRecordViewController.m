//
//  TTVoiceRecordViewController.m
//  AFNetworking
//
//  Created by fengshuo on 2019/6/3.
// 录制声音

#import "TTVoiceRecordViewController.h"
//view
#import "TTVoiceNoteView.h"
#import "TTVoiceProgressView.h"
#import "TTVoiceTimeView.h"
#import "TTVoiceActionView.h"
#import "TTVoiceCardView.h"
#import "TTVoiceContentCardView.h"
#import "TTVoiceMatchingNavView.h"
//vc
#import "TTVoiceMyViewController.h"
//XC_tt
#import "TTPopup.h"
#import "XCHUDTool.h"
#import "XCHtmlUrl.h"
#import "TTStatisticsService.h"
#import "NSArray+Safe.h"
//XC类
#import "XCTheme.h"
#import "XCMacros.h"
#import "XCVoiceRecordTool.h"
#import "YYUtility.h"
//core
#import "VoiceBottleCore.h"
#import "FileCore.h"
#import "FileCoreClient.h"
#import "VoiceBottleCoreClient.h"

//第三方工具类
#import <Masonry/Masonry.h>

#define kScale (KScreenWidth / 375)

@interface TTVoiceRecordViewController ()
<
     TTVoiceRecordToolDelegate,
     TTVoiceActionViewDelegate,
     TTVoiceContentCardViewDelegate,
     VoiceBottleCoreClient,
     FileCoreClient
>
/** 导航栏*/
@property (nonatomic,strong) TTVoiceMatchingNavView *navView;
/** 背景图*/
@property (nonatomic, strong) UIImageView * backImageView;
/**  显示文字的View*/
@property (nonatomic,strong) TTVoiceCardView *cardView;
/** 录制的文字的容器*/
@property (nonatomic, strong) UIView * contentContainerView;
/** 声波上面的那一条线*/
@property (nonatomic, strong) TTVoiceNoteView * topNoteView;
/** 声波下面的那一条线*/
@property (nonatomic, strong) TTVoiceNoteView * downNoteView;
/** 声波的容器*/
@property (nonatomic, strong) UIView * notContainerView;
/** 声波下面的那一条线*/
@property (nonatomic, strong) TTVoiceTimeView * timeView;
/** 描述性文字*/
@property (nonatomic, strong) UILabel * descripLabel;
/** 开始录制 暂停 试听*/
@property (nonatomic, strong) TTVoiceActionView * actionView;
/** 录制工具*/
@property (nonatomic, strong) XCVoiceRecordTool * recordTool;
/** 卡片的数据源*/
@property (nonatomic, strong) NSMutableArray *cardArray;

/** 当前剧本的UId 上传声音的时候使用*/
@property (nonatomic,assign) UserID currentPid;

/** 录音的时间*/
@property (nonatomic,assign) int recordTime;

/**
 *
 */
@property (nonatomic,assign) BOOL isRequest;
@end

@implementation TTVoiceRecordViewController
- (BOOL)isHiddenNavBar {
    return YES;
}

- (void)dealloc{
     RemoveCoreClientAll(self);
    [self invideRecord];
    [self.topNoteView removeFromParent];
    [self.downNoteView removeFromParent];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addCore];
    [self initView];
    [self initConstrations];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[XCVoiceRecordTool sharedRecordTool] stopPlaying];
    [self invideRecord];
    [self.actionView updateProgress:0];
    [self.timeView updateContentWith:@"按下录音" isRecordShort:NO];
    self.actionView.recordState = HandleActionRecordState_Prepare;
}

#pragma mark - public methods

#pragma mark - TTVoiceContentCardViewDelegate
- (void)reloadDataChangeNext {
     [self.cardView swipeCardItemToDirection:TTVoiceCardViewSwipeDirectionLeft];
}

#pragma mark - TTVoiceActionViewDelegate
/** 点击了重录*/
- (void)ttVoiceActionView:(TTVoiceActionView *)view didClickRestart:(UIButton *)sender {
    if (self.recordTool.player.isPlaying) {
        [self.recordTool stopPlaying];
        [self.recordTool pauseTimer];
    }
    [self invideRecord];
    [self.actionView updateProgress:0];
    self.actionView.auditionButton.selected = NO;
    self.actionView.auditionLabel.text = @"试听";
    [self.timeView updateContentWith:@"按下录音" isRecordShort:NO];
    self.actionView.recordState = HandleActionRecordState_Prepare;
}

/** 点击了完成*/
- (void)ttVoiceActionView:(TTVoiceActionView *)view didClickComplete:(UIButton *)sender {
    //如果是准备的时候 点击一下  那就是开始录音
    if (view.recordState == HandleActionRecordState_Prepare) {
        @KWeakify(self);
        [YYUtility checkMicPrivacy:^(BOOL succeed) {
            @KStrongify(self);
            if (!succeed) {
                [self thereIsNoMicoPrivacy];
            }else {
                view.recordState = HandleActionRecordState_Record;
                self.recordTime = 0;
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.recordTool startRecording];
                });
            }
        }];
        
       
    }else if (view.recordState == HandleActionRecordState_Record){
        //如果是正在录音的话
        if (self.timeView.second < 5) {
            self.actionView.recordState = HandleActionRecordState_Prepare;
            [self.recordTool pauseRecording];
            [self invideRecord];
            [self.timeView setSecond:0 totalSecond:60];
            [self.actionView updateProgress:0];
            [self.timeView updateContentWith:@"录音时间少于5秒" isRecordShort:YES];
            self.recordTime = 0;
        }else {
            [XCVoiceRecordTool sharedRecordTool].isNewPlayer = YES;
            self.actionView.recordState = HandleActionRecordState_Finshed;
            [self.recordTool pauseRecording];
            [self.recordTool stopRecording];
            [self.recordTool invalidateTimer];
        }
    }else if (view.recordState == HandleActionRecordState_Finshed) {
        if (self.recordTool.player.isPlaying) {
            [self.recordTool stopPlaying];
            [self.recordTool pauseTimer];
        }
         [XCHUDTool showGIFLoading];
            [[XCVoiceRecordTool sharedRecordTool] playAudioWithCafToMP3OfURL];
          NSData *fileData = [NSData dataWithContentsOfURL:[XCVoiceRecordTool sharedRecordTool].playerFileUrl];
        if (fileData) {
          [GetCore(FileCore) qiNiuUploadFile:fileData uploadType:UploadDataTypeVoiceBottle];
        }else {
            [XCHUDTool showErrorWithMessage:@"录音失败请重试"];
            [self invideRecord];
            [self.actionView updateProgress:0];
            [self.timeView updateContentWith:@"按下录音" isRecordShort:NO];
            self.actionView.recordState = HandleActionRecordState_Prepare;
        }
    }
}

/** 点击了试听*/
- (void)ttVoiceActionView:(TTVoiceActionView *)view didClickAudition:(UIButton *)sender {
     sender.selected = !sender.selected;
    if (sender.selected) {
        if (self.recordTool.isNewPlayer) {
             [self.recordTool playRecordingFile];
        }else {
            [self.recordTool startPlaying];
        }
        self.actionView.auditionLabel.text = @"暂停";
    }else{
        [self.recordTool pauseTimer];
        [self.recordTool pausePlaying];
         self.actionView.auditionLabel.text = @"试听";
    }
}
#pragma mark-  RecordToolDelegate
-(void)recordTool:(XCVoiceRecordTool *)recordTool didStartRecoring:(CGFloat)value {
    [_topNoteView changeVolume:value];
    [_downNoteView changeVolume:value];
    
    if(self.recordTool.player.isPlaying){
        [self.timeView setSecond:self.recordTool.player.currentTime totalSecond:self.recordTool.player.duration];
    }else{
        if (self.recordTool.recorder.currentTime -0.4 >= 60) {
            [self.recordTool pauseRecording];
            self.recordTool.isNewPlayer = YES;
            self.actionView.recordState = HandleActionRecordState_Finshed;
            [self.recordTool stopRecording];
            [self.recordTool invalidateTimer];
            self.recordTime = 60;
        }else{
            [self.timeView setSecond:self.recordTool.recorder.currentTime totalSecond:60];
            if (self.actionView.recordState == HandleActionRecordState_Record) {
                self.recordTime = self.timeView.second;
            }
        }
        if (self.actionView.recordState == HandleActionRecordState_Record) {
            [self.actionView updateProgress:self.timeView.second];
        }
    }
}

-(void)recordTool:(XCVoiceRecordTool *)recordTool didFinishedPlayer:(AVAudioPlayer *)player {
    self.actionView.auditionButton.selected = NO;
    self.actionView.auditionLabel.text= @"试听";
    [self.timeView setSecond:self.recordTool.player.duration totalSecond:self.recordTool.player.duration];
}

#pragma mark - VoiceBottleCoreClient
- (void)getVoicePiaWhenRecordFail:(NSString *)message {
    [XCHUDTool showErrorWithMessage:message];
}

- (void)getVoicePiaWhenRecordSuccess:(NSArray<VoiceBottlePiaModel *> *)array {
    [self.cardArray removeAllObjects];
    if (array.count > 0) {
        [self.cardArray addObjectsFromArray:array];
    }
    if (self.isRequest) {
        self.cardView.currentShowingItemIdx = 0;
         [self.cardView reloadCardItems];
    }else {
       [self.cardView fillCardItems];
        self.isRequest = YES;
    }
    
}



#pragma mark - FileCoreClient
//上传声音成功
- (void)didUploadTTVoiceBottleSuccess:(NSString *)key {
     NSString *fileurl = [NSString stringWithFormat:@"%@/%@",keyWithType(KeyType_QiNiuBaseURL, NO),key];
    [GetCore(VoiceBottleCore) uploadVoiceWith:fileurl voiceLength:self.recordTime piaId:self.currentPid voiceId:self.voiceId];
}

- (void)didUploadTTVoiceBottleFailth:(NSString *)message {
    [XCHUDTool hideHUD];
    [XCHUDTool showErrorWithMessage:message];
}

- (void)uploadVoiceBottleFail:(NSString *)message {
    [XCHUDTool hideHUD];
    [XCHUDTool showErrorWithMessage:message];
}
//录音发布成功
- (void)recordVoiceCompleteWithVoiceBottleModel:(VoiceBottleModel *)voiceModel {
    [XCHUDTool hideHUD];
    [self.actionView updateProgress:0];
    [self.timeView setSecond:0 totalSecond:60];
    [self.timeView updateContentWith:@"按下录音" isRecordShort:NO];
    [self invideRecord];
    self.actionView.recordState = HandleActionRecordState_Prepare;
     [TTStatisticsService trackEvent:@"my_sound_record_save" eventDescribe:@"保存录音"];
    [XCHUDTool showErrorWithMessage:@"发布成功" inView:self.view delay:2 enabled:YES];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - event response
#pragma mark - private method
- (void)invideRecord {
    [self.recordTool destructionRecordingFile];
    [self.recordTool destructionDestinationFile];
    [self.recordTool stopRecording];
    [self.recordTool pauseTimer];
    [self.recordTool invalidateTimer];
}

- (void)addCore {
    AddCoreClient(FileCoreClient, self);
    AddCoreClient(VoiceBottleCoreClient, self);
    [GetCore(VoiceBottleCore) getVoiceBottlePiaWhenRecord];
}

- (void)initView {
    [self.view addSubview:self.backImageView];
    [self.view addSubview:self.navView];
    [self.view addSubview:self.contentContainerView];
    [self.contentContainerView addSubview:self.cardView];
    [self.view addSubview:self.notContainerView];
    [self.view addSubview:self.timeView];
    [self.view addSubview:self.actionView];
    [self.view addSubview:self.descripLabel];

    [self configView];
    [self configCarView];
    
    @KWeakify(self);
    self.navView.backButtonDidClickAction = ^{
        @KStrongify(self);
        if (self.actionView.recordState != HandleActionRecordState_Prepare) {
            
            TTAlertConfig *config = [[TTAlertConfig alloc] init];
            config.title = @"提示";
            config.message = @"录制的声音还没有保存哦~ \n 确认返回吗？";
            config.confirmButtonConfig.title = @"继续录音";
            config.cancelButtonConfig.title = @"确认返回";
            [TTPopup alertWithConfig:config confirmHandler:^{
            
            } cancelHandler:^{
                [self invideRecord];
                [self.actionView updateProgress:0];
                [self.timeView updateContentWith:@"按下录音" isRecordShort:NO];
                self.actionView.recordState = HandleActionRecordState_Prepare;
                [self.navigationController popViewControllerAnimated:YES];
            }];
        }else {
            [self.navigationController popViewControllerAnimated:YES];
        }
    };
}

- (void)configView {
    self.recordTool.isNewPlayer = YES;
    [self.actionView updateProgress:0];
    [self.timeView updateContentWith:@"按下录音" isRecordShort:NO];
    self.actionView.recordState = HandleActionRecordState_Prepare;
}

- (void)configCarView {
    [self.cardView registerCardItemViewClass:[TTVoiceContentCardView class] forIdentifier:@"Identifie"];
    @KWeakify(self);
    [self.cardView setCardItemGetBlock:^__kindof UIView * _Nullable(TTVoiceCardView * _Nonnull cardView, NSInteger idx) {
        @KStrongify(self);
        TTVoiceContentCardView *view = [cardView dequeueReuseableCardItemViewWithIdentifier:@"Identifie"];
        view.layer.cornerRadius = 14;
        view.delegate = self;
        return view;
    }];
    [self.cardView setCardItemDidApearBlock:^(TTVoiceCardView * _Nonnull cardView, __kindof UIView * _Nonnull itemView, NSInteger idx) {
         @KStrongify(self);
        TTVoiceContentCardView * contetnView = (TTVoiceContentCardView *)itemView;
        if (self.cardArray.count > 0) {
            contetnView.picModel = [self.cardArray safeObjectAtIndex:idx];
            self.currentPid = contetnView.picModel.pid;
            [TTStatisticsService trackEvent:@"my_sound_text_switch" eventDescribe:@"切换文案"];
        }
        contetnView.isShowReload = YES;
        if (self.cardArray.count > idx && self.cardArray.count - 1 == idx) {
            [GetCore(VoiceBottleCore) getVoiceBottlePiaWhenRecord];
        }
    }];
    
    [self.cardView setCardItemWillDisapearBlock:^(TTVoiceCardView * _Nonnull cardView, __kindof UIView * _Nonnull itemView, NSInteger idx, JCCardViewSwipeDirection direction) {
        TTVoiceContentCardView * contetnView = (TTVoiceContentCardView *)itemView;
        [contetnView clearData];
    }];
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


- (void)initConstrations {
    [self.backImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view);
    }];
    
    [self.navView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.mas_equalTo(self.view);
        make.height.mas_equalTo(kSafeAreaTopHeight + 64);
    }];
    

    [self.descripLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.view);
        make.bottom.mas_equalTo(self.view).offset((-kSafeAreaBottomHeight - 26) * kScale);
    }];
    
    
    [self.actionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.view);
        make.bottom.mas_equalTo(self.descripLabel.mas_top).offset(-23 * kScale);
        make.height.mas_equalTo(90 * kScale);
    }];
    
    [self.timeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.view);
        make.bottom.mas_equalTo(self.actionView.mas_top).offset(-20 * kScale);
    }];
}

#pragma mark - setters and getters

- (TTVoiceMatchingNavView *)navView {
    if (!_navView) {
        _navView = [[TTVoiceMatchingNavView alloc] init];
        _navView.titleLabel.text = @"录制声音";
    }
    return _navView;
}

- (UIImageView *)backImageView {
    if (!_backImageView) {
        _backImageView = [[UIImageView alloc] init];
        _backImageView.image = [UIImage imageNamed:@"voice_bg"];
        _backImageView.userInteractionEnabled = YES;
    }
    return _backImageView;
}

- (UIView *)contentContainerView {
    if (!_contentContainerView) {
        _contentContainerView = [[UIView alloc] initWithFrame:CGRectMake(0, 34 * kScale+kSafeAreaTopHeight + 64, KScreenWidth, 290 *kScale)];
    }
    return _contentContainerView;
}

- (TTVoiceCardView *)cardView {
    if (!_cardView) {
        _cardView = [[TTVoiceCardView alloc] init];
        _cardView.frame = CGRectMake((KScreenWidth- 315 * kScale)/ 2, 0, 315 * kScale, 259 * kScale);
        _cardView.maxCardItemCount = 3;
    }
    return _cardView;
}

- (TTVoiceNoteView *)topNoteView {
    if (!_topNoteView) {
        _topNoteView = [[TTVoiceNoteView alloc] init];
        _topNoteView.tag = 0;
        [_topNoteView setVoiceWaveNumber:1];
    }
    return _topNoteView;
}

- (TTVoiceNoteView *)downNoteView{
    if (!_downNoteView) {
        _downNoteView = [[TTVoiceNoteView alloc] init];
        _downNoteView.tag = 1;
        [_downNoteView setVoiceWaveNumber:1];
    }
    return _downNoteView;
}

- (UIView *)notContainerView {
    if (!_notContainerView) {
        _notContainerView = [[UIView alloc] init];
        _notContainerView.frame = CGRectMake(0, CGRectGetMaxY(self.contentContainerView.frame), KScreenWidth, 100 * kScale);
        [self.topNoteView showInParentView:self.notContainerView];
        [self.topNoteView startVoiceWave];
        
        [self.downNoteView showInParentView:self.notContainerView];
        [self.downNoteView startVoiceWave];
    }
    return _notContainerView;
}

- (UILabel *)descripLabel {
    if (!_descripLabel) {
        _descripLabel = [[UILabel alloc] init];
        _descripLabel.text = @"录制的声音会自动放入声音匹配哦~";
        _descripLabel.textAlignment = NSTextAlignmentCenter;
        _descripLabel.font = [UIFont systemFontOfSize:12];
        _descripLabel.textColor = UIColorRGBAlpha(0xffffff, 0.7);
    }
    return _descripLabel;
}

- (TTVoiceTimeView *)timeView {
    if (!_timeView) {
        _timeView = [[TTVoiceTimeView alloc] init];
    }
    return _timeView;
}

- (TTVoiceActionView *)actionView {
    if (!_actionView) {
        _actionView = [[TTVoiceActionView alloc] init];
        _actionView.delegate = self;
    }
    return _actionView;
}

-(XCVoiceRecordTool *)recordTool{
    if (!_recordTool) {
        self.recordTool = [XCVoiceRecordTool sharedRecordTool];
        self.recordTool.delegate = self;
    }
    return _recordTool;
}

- (NSMutableArray *)cardArray {
    if (!_cardArray) {
        _cardArray = [NSMutableArray array];
    }
    return _cardArray;
}

@end
