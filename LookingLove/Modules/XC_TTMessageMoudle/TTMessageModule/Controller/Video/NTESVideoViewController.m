//
//  NTESVideoViewController.m
//  NIM
//
//  Created by chris on 15/4/12.
//  Copyright (c) 2015年 Netease. All rights reserved.
//

#import "NTESVideoViewController.h"
#import "UIAlertView+NTESBlock.h"
#import "XCHUDTool.h"
#import <NIMSDK/NIMSDK.h>

@interface NTESVideoViewController ()

@property (nonatomic,strong) NTESVideoViewItem *item;

@property (nonatomic,strong) NTESAVMoivePlayerController *avPlayer;

@end

@implementation NTESVideoViewController

- (instancetype)initWithVideoViewItem:(NTESVideoViewItem *)item
{
    self = [super initWithNibName:nil bundle:nil];
    if (self)
    {
        _item = item;
    }
    return self;
}

- (void)dealloc{
    [_avPlayer stop];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [[NIMSDK sharedSDK].resourceManager cancelTask:_item.path];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeAll;
    self.navigationItem.title = @"视频短片";
    if ([[NSFileManager defaultManager] fileExistsAtPath:self.item.path]) {
        [self startPlay];
    }else{
        __weak typeof(self) wself = self;
        [self downLoadVideo:^(NSError *error) {
            if (!error) {
                [wself startPlay];
            } else {
              [XCHUDTool showErrorWithMessage:@"加载失败" inView:wself.view];
            }
        }];
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear: animated];
    if (![[self.navigationController viewControllers] containsObject: self])
    {
        [self topStatusUIHidden:NO];
    }
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [self.avPlayer pause];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear: animated];
    if (_avPlayer.playbackState == NTESAVMoviePlaybackStatePlaying) {//不要调用.get方法，会过早的初始化播放器
        [self topStatusUIHidden:YES];
    }else{
        [self topStatusUIHidden:NO];
    }
}



- (void)downLoadVideo:(void(^)(NSError *error))handler{
    __weak typeof(self) wself = self;
    [[NIMSDK sharedSDK].resourceManager download:self.item.url filepath:self.item.path progress:^(float progress) {
    } completion:^(NSError *error) {
        if (wself) {
            if (handler) {
                handler(error);
            }
        }
    }];
}

- (void)startPlay{
    self.avPlayer.view.frame = self.view.bounds;
    self.avPlayer.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    [self.avPlayer prepareToPlay];
    [self.view addSubview:self.avPlayer.view];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(moviePlaybackComplete:)
                                                 name:NTESAVMoviePlayerPlaybackDidFinishNotification
                                               object:self.avPlayer];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(moviePlayStateChanged:)
                                                 name:NTESAVMoviePlayerPlaybackStateDidChangeNotification
                                               object:self.avPlayer];
    
    
    CGRect bounds = self.avPlayer.view.bounds;
    CGRect tapViewFrame = CGRectMake(0, 0, bounds.size.width, bounds.size.height);
    UIView *tapView = [[UIView alloc]initWithFrame:tapViewFrame];
    [tapView setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
    tapView.backgroundColor = [UIColor clearColor];
    [self.avPlayer.view addSubview:tapView];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(onTap:)];
    [tapView  addGestureRecognizer:tap];
}

- (void)moviePlaybackComplete: (NSNotification *)aNotification
{
    if (self.avPlayer == aNotification.object)
    {
        [self topStatusUIHidden:NO];
        NSDictionary *notificationUserInfo = [aNotification userInfo];
        NSNumber *resultValue = [notificationUserInfo objectForKey:NTESAVMoviePlayerPlaybackDidFinishReasonUserInfoKey];
        NTESAVMovieFinishReason reason = [resultValue intValue];
        if (reason == NTESAVMovieFinishReasonPlaybackError)
        {
            NSError *mediaPlayerError = [notificationUserInfo objectForKey:@"error"];
            NSString *errorTip = [NSString stringWithFormat:@"播放失败: %@", [mediaPlayerError localizedDescription]];
            [XCHUDTool showErrorWithMessage:errorTip inView:self.view];
        }
    }
    
}

- (void)moviePlayStateChanged: (NSNotification *)aNotification
{
    if (self.avPlayer == aNotification.object)
    {
        switch (self.avPlayer.playbackState)
        {
            case NTESAVMoviePlaybackStatePlaying:
                [self topStatusUIHidden:YES];
                break;
            case NTESAVMoviePlaybackStatePaused:
            case NTESAVMoviePlaybackStateStopped:
            case NTESAVMoviePlaybackStateInterrupted:
                [self topStatusUIHidden:NO];
            case NTESAVPMoviePlaybackStateSeekingBackward:
            case NTESAVPMoviePlaybackStateSeekingForward:
                break;
        }
        
    }
}

- (void)topStatusUIHidden:(BOOL)isHidden
{
    [[UIApplication sharedApplication] setStatusBarHidden:isHidden];
    self.navigationController.navigationBar.hidden = isHidden;
}

- (void)onTap: (UIGestureRecognizer *)recognizer
{
    switch (self.avPlayer.playbackState)
    {
        case NTESAVMoviePlaybackStatePlaying:
            [self.avPlayer pause];
            break;
        case NTESAVMoviePlaybackStatePaused:
        case NTESAVMoviePlaybackStateStopped:
        case NTESAVMoviePlaybackStateInterrupted:
            [self.avPlayer play];
            break;
        default:
            break;
    }
}

- (NTESAVMoivePlayerController *)avPlayer {
    if (!_avPlayer) {
        _avPlayer = [[NTESAVMoivePlayerController alloc] initWithContentURL:[NSURL fileURLWithPath:self.item.path]];
        _avPlayer.scalingMode = NTESAVMovieScalingModeAspectFill;
    }
    return _avPlayer;
}


@end


@implementation NTESVideoViewItem
@end

