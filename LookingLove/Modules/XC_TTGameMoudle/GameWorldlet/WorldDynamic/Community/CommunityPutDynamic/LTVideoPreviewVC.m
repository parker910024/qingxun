//
//  LTVideoPreviewVC.m
//  LTChat
//
//  Created by apple on 2019/7/26.
//  Copyright © 2019 wujie. All rights reserved.
//

#import "LTVideoPreviewVC.h"
#import "BaseNavigationController.h"
#import "XCConst.h"
#import <Masonry/Masonry.h>
#import "XCTheme.h"
#import "XCMacros.h"
#import "UIView+ZJFrame.h"
#import "UIView+XCToast.h"

@interface LTVideoPreviewVC ()

@property (nonatomic, strong) UIButton *deleteButton;

@property (nonatomic, strong) UIButton *backButton;

//@property (nonatomic, strong) AVPlayer * player;
@end

@implementation LTVideoPreviewVC

#pragma mark - life cycle
- (BOOL)isHiddenNavBar{
    return YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initView];
    [self initConstrations];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
//    [self.player.currentItem cancelPendingSeeks];
//    self.player = nil;
//    [[self.player.currentItem.asset cancelLoading];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
//    [self.player.currentItem cancelPendingSeeks];
//    self.player = nil;
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
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - public methods

#pragma mark - [系统控件的Protocol]

#pragma mark - [自定义控件的Protocol]

#pragma mark - [core相关的Protocol]

#pragma mark - event response
- (void)onButtonClick:(UIButton *)btn{
    if (self.deleteVideo) {
        self.deleteVideo();
    }
//    [self.player.currentItem cancelPendingSeeks];
//    self.player = nil;
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)backButtonClick{
//    [self.player.currentItem cancelPendingSeeks];
//    self.player = nil;
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - private method

- (void)initView {
    NSURL * url = [NSURL fileURLWithPath:self.videoPath];
    if (url) {
//        if (self.player) {
//            self.player = nil;
//        }
//        AVPlayerItem * item = [[AVPlayerItem alloc] initWithURL:url];
//        AVPlayer * player = [[AVPlayer alloc] initWithPlayerItem:item];
//        AVPlayerLayer * layer = [AVPlayerLayer playerLayerWithPlayer:player];
//        layer.videoGravity = AVLayerVideoGravityResizeAspectFill;
//        layer.frame = CGRectMake(0, 0, KScreenWidth, KScreenHeight);
//        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playbackFinished:) name:AVPlayerItemDidPlayToEndTimeNotification object:player.currentItem];
//        _player = player;
//        [player play];
//        //给AVPlayerItem添加播放完成通知
////        [self  addObserverToPlayerItem:self.player.currentItem];
//        [self.view.layer addSublayer:layer];
    }
    
    [self.view addSubview:self.backButton];
    [self.view addSubview:self.deleteButton];
}

- (void)initConstrations {

    [self.backButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view).mas_offset(10);
        make.top.mas_equalTo(statusbarHeight);
        make.height.width.mas_equalTo(44);
    }];
    [self.deleteButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.view).mas_offset(-20);
        make.centerY.mas_equalTo(self.backButton).mas_offset(0);
        make.height.mas_equalTo(30);
        make.width.mas_equalTo(78);

    }];
}
/**
 *  播放完成通知
 *
 *  @param notification 通知对象
 */
-(void)playbackFinished:(NSNotification *)notification{
    
    if (!self.view.window) {
        return;
    }
    // 播放完成后重复播放
    // 跳到最新的时间点开始播放
//    [_player seekToTime:CMTimeMake(0, 1)];
//    [_player play];
}
#pragma mark - getters and setters
//- (void)setVideoPath:(NSString *)videoPath{
//    _videoPath = videoPath;
//
//
//}
- (UIButton *)deleteButton{
    if (!_deleteButton) {
        _deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_deleteButton setTitle:@"public_delete" forState:UIControlStateNormal];
        _deleteButton.backgroundColor = UIColorFromRGB(0xffffff);
        [_deleteButton setImage:[UIImage imageNamed:@"community_delete"] forState:UIControlStateNormal];
        [_deleteButton setTitleColor:UIColorFromRGB(0x222222) forState:UIControlStateNormal];
        _deleteButton.titleLabel.font = [UIFont systemFontOfSize:15];
        _deleteButton.tag = 102;
        _deleteButton.imageEdgeInsets = UIEdgeInsetsMake(0, -2, 0, 0);
        _deleteButton.titleEdgeInsets = UIEdgeInsetsMake(0, 2, 0, 0);
        _deleteButton.layer.cornerRadius = 15;
        _deleteButton.layer.masksToBounds = YES;
        [_deleteButton addTarget:self action:@selector(onButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _deleteButton;
}
- (UIButton *)backButton {
    if (!_backButton) {
        _backButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _backButton.frame = CGRectMake(0, 0, 44, 44);
        [_backButton setTitleColor:[UIColor whiteColor] forState:0];
        
        [_backButton setImage:[UIImage imageNamed:@"nav_bar_back_new_white"] forState:UIControlStateNormal];
        //        [_backButton setTitle:NSLocalizedString(@"Cancel", nil) forState:0];
        [_backButton addTarget:self action:@selector(backButtonClick) forControlEvents:UIControlEventTouchUpInside];
//        _backButton.titleLabel.font = [UIFont systemFontOfSize:14];
    }
    return _backButton;
}

@end
