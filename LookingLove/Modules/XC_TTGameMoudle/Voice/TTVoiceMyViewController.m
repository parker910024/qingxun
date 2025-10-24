//
//  TTVoiceMyViewController.m
//  XC_TTGameMoudle
//
//  Created by Macx on 2019/6/3.
//  Copyright © 2019 YiZhuan. All rights reserved.
//

#import "TTVoiceMyViewController.h"

#import "TTVoiceRecordViewController.h"

#import "TTVoiceMatchingNavView.h"
#import "TTVoiceMyCell.h"
#import "TTVoiceMyEmptyView.h"

#import "VoiceBottleCore.h"
#import "VoiceBottleCoreClient.h"
#import "VoiceBottleModel.h"

#import "XCMacros.h"
#import "XCTheme.h"
#import "XCHUDTool.h"
#import "TTStatisticsService.h"
#import <Masonry/Masonry.h>

@interface TTVoiceMyViewController ()<TTVoiceMyEmptyViewDelegate, VoiceBottleCoreClient>
/** 空view */
@property (nonatomic, strong) TTVoiceMyEmptyView *emptyView;
/** bg */
@property (nonatomic, strong) UIImageView *bgImageView;
/** 导航栏 */
@property (nonatomic, strong) TTVoiceMatchingNavView *navView;

/** 底部提示文案 */
@property (nonatomic, strong) UILabel *bottomTipLabel;
/** 声音的cell */
@property (nonatomic, strong) TTVoiceMyCell *voiceMyCell;
@end

@implementation TTVoiceMyViewController

#pragma mark - life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initView];
    [self initAction];
    [self initConstrations];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.voiceMyCell resetVoiceMyCell];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    //Remove Client Here
    RemoveCoreClientAll(self);
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

#pragma mark - public methods

#pragma mark - [系统控件的Protocol]   //注意要把名字改掉，这个MARK只做功能划分，不是一个真正的MARK，每个不一样的Protocol，需要一个新的MARK”

#pragma mark - TTVoiceMyEmptyViewDelegate
/** 点击了去录制按钮 */
- (void)voiceMyEmptyView:(TTVoiceMyEmptyView *)voiceMyEmptyView didClickRecordButton:(UIButton *)button {
    [TTStatisticsService trackEvent:@"my_sound_record" eventDescribe:@"我的声音_去录制"];
    TTVoiceRecordViewController *recoedVC = [[TTVoiceRecordViewController alloc] init];
    [self.navigationController pushViewController:recoedVC animated:YES];
}

#pragma mark - VoiceBottleCoreClient
/** 请求我的声音列表 */
- (void)requestMyVoiceListSuccess:(NSArray<VoiceBottleModel *> *)array {
    [XCHUDTool hideHUDInView:self.view];
    if (array.count) {
        self.emptyView.hidden = YES;
        self.voiceMyCell.hidden = NO;

        VoiceBottleModel *model = array[0];
        self.voiceMyCell.model = model;
    } else {
        self.emptyView.hidden = NO;
        self.voiceMyCell.hidden = YES;
    }
}

- (void)requestMyVoiceListFail:(NSString *)message errorCode:(NSNumber *)errorCode {
    [XCHUDTool showErrorWithMessage:message inView:self.view];
}

/** 声音录制完成 回调声音model*/
- (void)recordVoiceCompleteWithVoiceBottleModel:(VoiceBottleModel *)voiceModel {
    self.emptyView.hidden = YES;
    self.voiceMyCell.hidden = NO;
    
    self.voiceMyCell.model = voiceModel;
}

#pragma mark - event response

#pragma mark - private method
- (void)initAction {
    @KWeakify(self);
    self.navView.backButtonDidClickAction = ^{
        @KStrongify(self);
        [self.navigationController popViewControllerAnimated:YES];
    };
    
    self.voiceMyCell.reorderButtonDidClickAction = ^(VoiceBottleModel * _Nonnull model) {
        @KStrongify(self);
        [TTStatisticsService trackEvent:@"my_sound_rerecord" eventDescribe:@"我的声音_重新录制"];
        TTVoiceRecordViewController *recoedVC = [[TTVoiceRecordViewController alloc] init];
        recoedVC.voiceId = model.id;
        [self.navigationController pushViewController:recoedVC animated:YES];
    };
}

- (void)initView {
    [self.view addSubview:self.bgImageView];
    [self.view addSubview:self.emptyView];
    [self.view addSubview:self.navView];
    [self.view addSubview:self.bottomTipLabel];
    [self.view addSubview:self.voiceMyCell];
    
    AddCoreClient(VoiceBottleCoreClient, self);
    self.emptyView.hidden = YES;
    self.voiceMyCell.hidden = YES;
//    [XCHUDTool showGIFLoadingInView:self.view];
    [GetCore(VoiceBottleCore) requestMyVoiceList];
}

- (void)initConstrations {
    [self.bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.mas_equalTo(self.view);
    }];
    
    [self.navView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.mas_equalTo(self.view);
        make.height.mas_equalTo(kSafeAreaTopHeight + 64);
    }];
    
    [self.bottomTipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view);
        make.bottom.mas_equalTo(-kSafeAreaBottomHeight - 36);
    }];
    
    [self.emptyView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.mas_equalTo(self.view);
    }];
    
    [self.voiceMyCell mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(-15);
        make.top.mas_equalTo(90 + kSafeAreaTopHeight);
        make.height.mas_equalTo(103);
    }];
}

#pragma mark - getters and setters
- (BOOL)isHiddenNavBar {
    return YES;
}

- (TTVoiceMyEmptyView *)emptyView {
    if (!_emptyView) {
        _emptyView = [[TTVoiceMyEmptyView alloc] init];
        _emptyView.delegate = self;
    }
    return _emptyView;
}

- (TTVoiceMatchingNavView *)navView {
    if (!_navView) {
        _navView = [[TTVoiceMatchingNavView alloc] init];
        _navView.titleLabel.text = @"我的声音";
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

- (UILabel *)bottomTipLabel {
    if (!_bottomTipLabel) {
        _bottomTipLabel = [[UILabel alloc] init];
        _bottomTipLabel.text = @"录制的声音会自动放入声音匹配哦~";
        _bottomTipLabel.textColor = RGBACOLOR(255, 255, 255, 0.7);
        _bottomTipLabel.font = [UIFont systemFontOfSize:12];
    }
    return _bottomTipLabel;
}

- (TTVoiceMyCell *)voiceMyCell {
    if (!_voiceMyCell) {
        _voiceMyCell = [[TTVoiceMyCell alloc] init];
    }
    return _voiceMyCell;
}

@end
