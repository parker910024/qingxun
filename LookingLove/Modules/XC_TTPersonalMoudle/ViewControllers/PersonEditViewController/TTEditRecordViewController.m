//
//  TTEditRecordViewController.m
//  TuTu
//
//  Created by Macx on 2018/11/8.
//  Copyright © 2018年 YiZhuan. All rights reserved.
//

#import "TTEditRecordViewController.h"
#import "TTEditRecordViewController+Record.h"

//core
#import "AuthCore.h"
#import "FileCore.h"
#import "UserCore.h"
#import "MediaCore.h"
#import "UserCoreClient.h"
#import "MediaCoreClient.h"
#import "FileCoreClient.h"
//t
#import "XCTheme.h"
#import <Masonry/Masonry.h>
#import "XCMacros.h"
#import "UIButton+EnlargeTouchArea.h"
//cate
#import "XCHUDTool.h"

@interface TTEditRecordViewController ()<UserCoreClient,FileCoreClient,MediaCoreClient>
@property (nonatomic, strong) UIButton  *backBtn;//
@property (nonatomic, strong) UILabel  *titleLabel;//

@property (nonatomic, strong) UILabel  *tipLabel;//
@property (nonatomic, strong) UILabel  *recordLabel;//

@property (nonatomic, strong) UIButton  *recordBtn;//
@property (nonatomic, strong) UILabel  *recordBtnLabel;//
@property (nonatomic, strong) UILabel  *playOrPauseBtnLabel;//
@property (nonatomic, strong) UIButton  *rerecordBtn;//
@property (nonatomic, strong) UILabel  *rerecordBtnLabel;//


@end

@implementation TTEditRecordViewController

- (void)dealloc {
    RemoveCoreClient(UserCoreClient, self);
    RemoveCoreClient(FileCoreClient, self);
    RemoveCoreClient(MediaCoreClient, self);
    
}

- (BOOL)isHiddenNavBar {
    return YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addClient];
    [self initSubviews];
    [self openRecordServiceWithBlock:^(BOOL isSuccess) {
        if (!isSuccess) {
            [XCHUDTool showErrorWithMessage:@"请到设置中允许麦克风权限才能录音哦～"];
            [self.navigationController popViewControllerAnimated:YES];
        }
    }];
}

- (void)addClient {
    AddCoreClient(UserCoreClient, self);
    AddCoreClient(FileCoreClient, self);
    AddCoreClient(MediaCoreClient, self);
}


- (void)initSubviews {
    [self.view addSubview:self.backBtn];
    [self.view addSubview:self.titleLabel];
    [self.view addSubview:self.tipLabel];
    [self.view addSubview:self.recordLabel];
    [self.view addSubview:self.recordTimeLabel];
    [self.view addSubview:self.recordBtn];
    [self.view addSubview:self.recordBtnLabel];
    [self.view addSubview:self.playOrPauseBtn];
    [self.view addSubview:self.playOrPauseBtnLabel];
    [self.view addSubview:self.rerecordBtn];
    [self.view addSubview:self.rerecordBtnLabel];
    [self makeConstriants];
}

- (void)makeConstriants {
    [self.backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view).offset(12);
        make.top.mas_equalTo(self.view).offset(statusbarHeight+13);
    }];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view);
        make.top.mas_equalTo(self.backBtn.mas_bottom).offset(50);
    }];
    [self.tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view);
        make.top.mas_equalTo(self.titleLabel.mas_bottom).offset(20);
    }];
    
    [self.recordBtnLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.view).offset(-53-kSafeAreaBottomHeight);
        make.centerX.mas_equalTo(self.view);
    }];
    [self.rerecordBtnLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.recordBtnLabel);
        make.right.mas_equalTo(self.recordBtnLabel.mas_left).offset(-41);
    }];
    [self.playOrPauseBtnLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.recordBtnLabel);
        make.left.mas_equalTo(self.recordBtnLabel.mas_right).offset(41);
    }];
    [self.recordBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view);
        make.bottom.mas_equalTo(self.recordBtnLabel.mas_top).offset(-14);
    }];
    [self.recordLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view);
        make.bottom.mas_equalTo(self.recordBtn.mas_top).offset(-55);
    }];
    [self.recordTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view);
        make.bottom.mas_equalTo(self.recordBtn.mas_top).offset(-35);
    }];
    
    [self.rerecordBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.rerecordBtnLabel);
        make.bottom.mas_equalTo(self.rerecordBtnLabel.mas_top).offset(-22);
    }];
    [self.playOrPauseBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.playOrPauseBtnLabel);
        make.bottom.mas_equalTo(self.playOrPauseBtnLabel.mas_top).offset(-22);
    }];
}

#pragma mark -FileCoreClient
- (void)onUploadVoiceSuccess:(NSString *)url
{
    if (url.length > 0) {
        UserID uid = [GetCore(AuthCore) getUid].userIDValue;
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        [dic setObject:url forKey:@"userVoice"];
        [dic setObject:@(self.secondTime) forKey:@"voiceDura"];
        @weakify(self)
        [[GetCore(UserCore) saveUserInfoWithUserID:uid userInfos:dic.copy] subscribeNext:^(id x) {
            @strongify(self);
            [XCHUDTool hideHUDInView:self.view];
            !self.recordVoiceRefreshHandler ? : self.recordVoiceRefreshHandler(self.filePath);
            [self.navigationController popViewControllerAnimated:YES];
        } error:^(NSError *error) {
            @strongify(self);
            [XCHUDTool hideHUDInView:self.view];
        }];
    } else {
        [XCHUDTool hideHUDInView:self.view];
        [XCHUDTool showErrorWithMessage:@"录音上传失败，请重试" inView:self.view];
    }
}

- (void)onUploadVoiceFailth:(NSError *)error
{
    [XCHUDTool hideHUDInView:self.view];
    [XCHUDTool showErrorWithMessage:@"录音上传失败，请重试" inView:self.view];
}

#pragma mark - Event

- (void)onClickBackAction:(UIButton *)btn {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)startRecordAction:(UIButton *)btn {
    if (![GetCore(MediaCore) isRecording]) {
        [GetCore(MediaCore) record];
        self.recordTimeLabel.hidden = NO;
        self.secondTime = 0;
        self.recordLabel.text = @"录制中";
    }
}

- (void)stopRecordAction:(UIButton *)btn {
    [GetCore(MediaCore) stopRecord];
    if (self.secondTime <= 1) {
        self.recordTimeLabel.hidden = YES;
        [self changeRecordStateToSave:NO];
        [XCHUDTool showErrorWithMessage:@"招呼声不能少于2秒哦" inView:self.view];
    } else {
        [self changeRecordStateToSave:YES];
    }
    self.recordLabel.text = @"长按录音";
}

- (void)saveRecordAction:(UIButton *)btn {
    if (self.filePath) {
        [XCHUDTool showGIFLoadingInView:self.view];
        [GetCore(FileCore) uploadVoice:self.filePath];
    }
}

- (void)onClickPlayOrPauseAction:(UIButton *)btn {
   
    if (GetCore(MediaCore).isPlaying) {
        [GetCore(MediaCore) stopPlay];
        btn.selected = NO;
    }else {
        [GetCore(MediaCore) play:self.filePath];
        btn.selected = YES;
    }
}

- (void)onClickRerecordBtnAction:(UIButton *)btn {
    
    self.recordLabel.hidden = NO;
    self.recordTimeLabel.hidden = YES;
    
    self.filePath = nil;
    self.secondTime = 0;
    self.recordTimeLabel.text = @"00:00";
    [self changeRecordStateToSave:NO];
}


#pragma mark - private

- (void)changeRecordStateToSave:(BOOL)save {
    if (save) {
        [self.recordBtn setImage:[UIImage imageNamed:@"person_edit_recordSave"] forState:UIControlStateNormal];
        [self.recordBtn removeTarget:self action:@selector(startRecordAction:) forControlEvents:UIControlEventTouchDown];
        [self.recordBtn removeTarget:self action:@selector(stopRecordAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.recordBtn addTarget:self action:@selector(saveRecordAction:) forControlEvents:UIControlEventTouchUpInside];
        self.rerecordBtn.hidden = NO;
        self.playOrPauseBtn.hidden = NO;
        self.recordLabel.hidden = YES;
        self.recordTimeLabel.hidden = YES;
//        self.rerecordBtnLabel.hidden = NO;
//        self.playOrPauseBtnLabel.hidden = NO;
    }else {
        self.recordLabel.hidden = NO;
        self.recordTimeLabel.text = @"00:00";
        self.rerecordBtn.hidden = YES;
        self.playOrPauseBtn.hidden = YES;
//        self.rerecordBtnLabel.hidden = YES;
//        self.playOrPauseBtnLabel.hidden = YES;
        [self.recordBtn setImage:[UIImage imageNamed:@"person_edit_recordup"] forState:UIControlStateNormal];
        [self.recordBtn setImage:[UIImage imageNamed:@"person_edit_recorddown"] forState:UIControlStateHighlighted];
        [self.recordBtn removeTarget:self action:@selector(saveRecordAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.recordBtn addTarget:self action:@selector(startRecordAction:) forControlEvents:UIControlEventTouchDown];
        [self.recordBtn addTarget:self action:@selector(stopRecordAction:) forControlEvents:UIControlEventTouchUpInside];
    }
}


- (void)openRecordServiceWithBlock:(void (^)(BOOL isSuccess))returnBlock
{
    AVAudioSessionRecordPermission permissionStatus = [[AVAudioSession sharedInstance] recordPermission];
    if (permissionStatus == AVAudioSessionRecordPermissionUndetermined) {
        [[AVAudioSession sharedInstance] requestRecordPermission:^(BOOL granted) {
            if (returnBlock) {
                returnBlock(granted);
            }
        }];
    } else if (permissionStatus == AVAudioSessionRecordPermissionDenied) {
        returnBlock(NO);
    } else {
        returnBlock(YES);
    }
}


#pragma mark - Getter && Setter

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont systemFontOfSize:22];
        _titleLabel.textColor = [XCTheme getTTMainColor];
        _titleLabel.text = @"录下您最棒的问候";
    }
    return _titleLabel;
}
- (UILabel *)tipLabel {
    if (!_tipLabel) {
        _tipLabel = [[UILabel alloc] init];
        _tipLabel.font = [UIFont systemFontOfSize:14];
        _tipLabel.textColor = [XCTheme getTTDeepGrayTextColor];
        _tipLabel.textAlignment = NSTextAlignmentCenter;
        _tipLabel.numberOfLines = 0;
        _tipLabel.text = @"用心录下问候,记录下你最美的声音，\n10秒内尽情发挥您的声线吧！";
    }
    return _tipLabel;
}

- (UILabel *)recordLabel {
    if (!_recordLabel) {
        _recordLabel = [[UILabel alloc] init];
        _recordLabel.font = [UIFont systemFontOfSize:14];
        _recordLabel.textColor = [XCTheme getTTDeepGrayTextColor];
        _recordLabel.text = @"长按录音";
    }
    return _recordLabel;
}

- (UILabel *)recordTimeLabel {
    if (!_recordTimeLabel) {
        _recordTimeLabel = [[UILabel alloc] init];
        _recordTimeLabel.font = [UIFont systemFontOfSize:14];
        _recordTimeLabel.textColor = [XCTheme getTTMainColor];
        _recordTimeLabel.text = @"00:00";
        _recordTimeLabel.hidden = YES;
    }
    return _recordTimeLabel;
}


- (UIButton *)backBtn {
    if (!_backBtn) {
        _backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_backBtn setImage:[UIImage imageNamed:@"nav_bar_back"] forState:UIControlStateNormal];
        [_backBtn setEnlargeEdgeWithTop:15 right:15 bottom:15 left:15];
        [_backBtn addTarget:self action:@selector(onClickBackAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _backBtn;
}

- (UIButton *)recordBtn {
    if (!_recordBtn) {
        _recordBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_recordBtn setImage:[UIImage imageNamed:@"person_edit_recordup"] forState:UIControlStateNormal];
        [_recordBtn setImage:[UIImage imageNamed:@"person_edit_recorddown"] forState:UIControlStateHighlighted];
        [_recordBtn addTarget:self action:@selector(startRecordAction:) forControlEvents:UIControlEventTouchDown];
        [_recordBtn addTarget:self action:@selector(stopRecordAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _recordBtn;
}

- (UILabel *)recordBtnLabel {
    if (!_recordBtnLabel) {
        _recordBtnLabel = [[UILabel alloc] init];
        _recordBtnLabel.text = @"长按开始录音";
        _recordBtnLabel.font = [UIFont systemFontOfSize:14];
        _recordBtnLabel.textColor = [XCTheme getTTDeepGrayTextColor];
        _recordBtnLabel.hidden = YES;
    }
    return _recordBtnLabel;
}

- (UIButton *)playOrPauseBtn {
    if (!_playOrPauseBtn) {
        _playOrPauseBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_playOrPauseBtn setImage:[UIImage imageNamed:@"person_edit_recordPlay"] forState:UIControlStateNormal];
        [_playOrPauseBtn setImage:[UIImage imageNamed:@"person_edit_recordPause"] forState:UIControlStateSelected];
        [_playOrPauseBtn addTarget:self action:@selector(onClickPlayOrPauseAction:) forControlEvents:UIControlEventTouchUpInside];
        _playOrPauseBtn.hidden = YES;
    }
    return _playOrPauseBtn;
}

- (UILabel *)playOrPauseBtnLabel {
    if (!_playOrPauseBtnLabel) {
        _playOrPauseBtnLabel = [[UILabel alloc] init];
        _playOrPauseBtnLabel.text = @"试听";
        _playOrPauseBtnLabel.font = [UIFont systemFontOfSize:14];
        _playOrPauseBtnLabel.textColor = [XCTheme getTTDeepGrayTextColor];
        _playOrPauseBtnLabel.hidden = YES;
    }
    return _playOrPauseBtnLabel;
}


- (UIButton *)rerecordBtn {
    if (!_rerecordBtn) {
        _rerecordBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_rerecordBtn setImage:[UIImage imageNamed:@"person_edit_rerecord"] forState:UIControlStateNormal];
        [_rerecordBtn addTarget:self action:@selector(onClickRerecordBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        _rerecordBtn.hidden = YES;

    }
    return _rerecordBtn;
}
- (UILabel *)rerecordBtnLabel {
    if (!_rerecordBtnLabel) {
        _rerecordBtnLabel = [[UILabel alloc] init];
        _rerecordBtnLabel.text = @"重录";
        _rerecordBtnLabel.font = [UIFont systemFontOfSize:14];
        _rerecordBtnLabel.textColor = [XCTheme getTTDeepGrayTextColor];
        _rerecordBtnLabel.hidden = YES;

    }
    return _rerecordBtnLabel;
}


@end
