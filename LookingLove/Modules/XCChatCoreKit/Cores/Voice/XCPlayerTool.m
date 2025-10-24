//
//  XCPlayerTool.m
//  XCToolKit
//
//  Created by Macx on 2019/6/13.
//  Copyright © 2019 YiZhuan. All rights reserved.
//

#import "XCPlayerTool.h"
#import <AVFoundation/AVFoundation.h>
#import <AVKit/AVKit.h>

#import "XCMacros.h"
#import "FileCore.h"
#import "FileCoreClient.h"

@interface XCPlayerTool ()<FileCoreClient>

@property (nonatomic, strong) AVPlayer *player;
@property (nonatomic, strong) id timeObserver;
@property (nonatomic, assign) BOOL hasObserver;
/** 记录外界传入的播放地址 */
@property (nonatomic, strong) NSString *filePath;
@end

@implementation XCPlayerTool
#pragma mark - life cycle
static id instance;
+ (instancetype)sharedPlayerTool {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (instance == nil) {
            instance = [[self alloc] init];
        }
    });
    return instance;
}

#pragma mark - puble method

- (void)startPlay:(NSString *)filePath {
    
    if ([AVAudioSession sharedInstance].category != AVAudioSessionCategoryPlayback) {
        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
        [[AVAudioSession sharedInstance] setActive:YES error:nil];
    }
    
    if (!filePath || filePath.length <= 0) {
        return;
    }
    self.filePath = filePath;
    NSString *parm = @"imageslim";
    if ([filePath containsString:parm]) {
        filePath = [filePath substringToIndex:filePath.length-(parm.length+1)];
    }
    
    if ([filePath hasPrefix:@"https://nim.nosdn"]) { // 云信的声音
        AddCoreClient(FileCoreClient, self);
        [GetCore(FileCore) downloadVoice:filePath];
    } else {
        [self play:filePath];
    }
}

- (void)play:(NSString *)filePath {
    // 移除监听器
    [self removeObserver];
    
    // 设置播放的url
    NSURL *url = [NSURL fileURLWithPath:filePath];
    if ([filePath hasPrefix:@"http://"] || [filePath hasPrefix:@"https://"]) {
        url = [NSURL URLWithString:filePath];
    }
    // 设置播放的item
    AVPlayerItem *playerItem = [[AVPlayerItem alloc] initWithURL:url];
    if (self.player == nil) {
        self.player = [[AVPlayer alloc] init];
        self.player.volume = 1;
    }
    
    self.player = [AVPlayer playerWithPlayerItem:playerItem];
    [self.player play];
    
    // 添加监听器
    [self addObserver];
}

/** 暂停*/
- (void)pause {
    
    [self.player pause];
    self.isPlaying = NO;
    self.isPauseing = YES;
}

/** 重新播放*/
- (void)resume {
    if (!self.isPlaying) {
        [self.player play];
        self.isPlaying = YES;
        self.isPauseing = NO;
    }
}

/** 从零开始重新播放 */
- (void)rePlay {
    CMTime dragedCMTime = CMTimeMake(0, 1);
    [self.player seekToTime:dragedCMTime toleranceBefore:CMTimeMake(1,1) toleranceAfter:CMTimeMake(1,1) completionHandler:^(BOOL finished) {
        [self resume];
    }];
}

/** 停止*/
- (void)stop {
    
    [self.player pause];
//    @KWeakify(self);
//    [self.player seekToTime:kCMTimeZero completionHandler:^(BOOL finished) {
//        @KStrongify(self);
    self.isPlaying = NO;
    self.isPauseing = NO;
//    }];
    
    // 解决stop后依然会有声音
    [self removeObserver];
    [self.player.currentItem cancelPendingSeeks];
    [self.player.currentItem.asset cancelLoading];
    
    // 解决stop后获取不到资源，暂停，播放后 继续播放之前的缓存资源
    [self.player replaceCurrentItemWithPlayerItem:nil];
    self.filePath = @"";
    
    RemoveCoreClient(FileCoreClient, self);
}

#pragma mark - FileCoreClient
// 下载完成
- (void)onDownloadVoiceSuccess:(NSString *)oldVersionFilePath {
    [self play:oldVersionFilePath];
}

- (void)onDownloadVoiceFailth:(NSError *)error {
//    [XCHUDTool showErrorWithMessage:@"播放失败，请检查网络" inView:self.view];
}

#pragma mark - private method
- (void)addObserver {
    
    if (!self.hasObserver) {
        
        self.hasObserver = YES;
        
        // KVO来观察status属性的变化
        [self.player.currentItem addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];
        // KVO监测加载情况
        [self.player.currentItem addObserver:self forKeyPath:@"loadedTimeRanges" options:NSKeyValueObservingOptionNew context:nil];
        
        
        @KWeakify(self);
        self.timeObserver = [self.player addPeriodicTimeObserverForInterval:CMTimeMake(1, 1) queue:nil usingBlock:^(CMTime time) {
            @KStrongify(self);
            AVPlayerItem *currentItem = self.player.currentItem;
            NSArray *loadedRanges = currentItem.seekableTimeRanges;
            if (loadedRanges.count > 0 && currentItem.duration.timescale != 0) {
                NSInteger currentSecond = currentItem.currentTime.value * 1.0 / currentItem.currentTime.timescale;
                if (self.delegate && [self.delegate respondsToSelector:@selector(playerTool:duration:time:)]) {
                    [self.delegate playerTool:self duration:CMTimeGetSeconds(self.player.currentItem.duration) - 1 time:currentSecond];
                }
            }
        }];
        
        // 通知
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playFinish) name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
    }
}

- (void)removeObserver {
    
    if (self.hasObserver) {
        self.hasObserver = NO;
        
        [self.player.currentItem removeObserver:self forKeyPath:@"status"];
        [self.player.currentItem removeObserver:self forKeyPath:@"loadedTimeRanges"];
        
        [self.player removeTimeObserver:self.timeObserver];
        self.timeObserver = nil;
        
        [[NSNotificationCenter defaultCenter] removeObserver:self name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context{
    
    if ([keyPath isEqualToString:@"status"]) {
        // 取出status的新值
        AVPlayerItemStatus status = [change[NSKeyValueChangeNewKey] intValue];
        switch (status) {
            case AVPlayerItemStatusFailed: {
                
            } break;
            case AVPlayerItemStatusReadyToPlay: {
                
                [self.player play];
                self.isPlaying = YES;
                self.isPauseing = NO;
            } break;
            case AVPlayerItemStatusUnknown: {
                
            } break;
            default: break;
        }
    } else if ([keyPath isEqualToString:@"loadedTimeRanges"]) {
        //        NSArray *array = self.player.currentItem.loadedTimeRanges;
        //        // 本次缓冲的时间范围
        //        CMTimeRange timeRange = [array.firstObject CMTimeRangeValue];
        //        // 缓冲总长度
        //        NSTimeInterval totalBuffer = CMTimeGetSeconds(timeRange.start) + CMTimeGetSeconds(timeRange.duration);
        //        // 音乐的总时间
        //        NSTimeInterval duration = CMTimeGetSeconds(self.player.currentItem.duration);
        //        // 计算缓冲百分比例
        //        NSTimeInterval scale = totalBuffer / duration;
    }
}

- (void)playFinish {
    self.isPlaying = NO;
    self.isPauseing = NO;
    if (self.delegate && [self.delegate respondsToSelector:@selector(playerToolDidFinish:)]) {
        [self.delegate playerToolDidFinish:self];
    }
}
@end
