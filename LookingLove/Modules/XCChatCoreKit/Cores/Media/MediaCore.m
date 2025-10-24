//
//  MediaCore.m
//  BberryCore
//
//  Created by chenran on 2017/5/24.
//  Copyright © 2017年 chenran. All rights reserved.
//

#import "MediaCore.h"
#import <NIMSDK/NIMSDK.h>
#import "MediaCoreClient.h"

@interface MediaCore()<NIMMediaManagerDelegate>

@end
@implementation MediaCore

- (instancetype)init
{
    self = [super init];
    if (self) {
        [[NIMSDK sharedSDK].mediaManager addDelegate:self];
        [[NIMSDK sharedSDK].mediaManager setNeedProximityMonitor:NO];
//        [[NIMSDK sharedSDK].mediaManager switchAudioOutputDevice:NIMAudioOutputDeviceSpeaker];
        [NIMSDK sharedSDK].mediaManager.recordProgressUpdateTimeInterval = 1;
    }
    return self;
}

- (void) record
{
    if (![[NIMSDK sharedSDK].mediaManager isRecording]) {
        [[NIMSDK sharedSDK].mediaManager record:NIMAudioTypeAAC duration:10];
    }
}

- (void) stopRecord
{
    [[NIMSDK sharedSDK].mediaManager stopRecord];
}

- (void)cancelRecord
{
    [[NIMSDK sharedSDK].mediaManager cancelRecord];
}

- (BOOL)isRecording
{
    return [[NIMSDK sharedSDK].mediaManager isRecording];
}

- (void) play:(NSString *)filePath
{
    if (filePath.length <= 0) {
        return;
    }
    [[NIMSDK sharedSDK].mediaManager play:filePath];
}

- (void) stopPlay
{
    [[NIMSDK sharedSDK].mediaManager stopPlay];
}

- (BOOL)isPlaying
{
    return [[NIMSDK sharedSDK].mediaManager isPlaying];
}

#pragma markrecordAudio - NIMMediaManagerDelegate
- (void)recordAudio:(NSString *)filePath didBeganWithError:(NSError *)error
{
    if (error == nil && filePath.length > 0) {
        NotifyCoreClient(MediaCoreClient, @selector(onRecordAudioBegan:), onRecordAudioBegan:filePath);
    }
}

- (void)recordAudio:(NSString *)filePath didCompletedWithError:(NSError *)error
{
    if (error == nil && filePath.length > 0) {
        NotifyCoreClient(MediaCoreClient, @selector(onRecordAudioComplete:), onRecordAudioComplete:filePath);
    }
}

- (void)recordAudioDidCancelled
{
    NotifyCoreClient(MediaCoreClient, @selector(onRecordAudioCancel), onRecordAudioCancel);
}

- (void)recordAudioProgress:(NSTimeInterval)currentTime
{
    NotifyCoreClient(MediaCoreClient, @selector(onRecordAudioProgress:), onRecordAudioProgress:currentTime);
}

- (void)playAudio:(NSString *)filePath didBeganWithError:(NSError *)error
{
    NotifyCoreClient(MediaCoreClient, @selector(onPlayAudioBegan:), onPlayAudioBegan:filePath);
}

- (void)playAudio:(NSString *)filePath didCompletedWithError:(NSError *)error
{
    NotifyCoreClient(MediaCoreClient, @selector(onPlayAudioComplete:), onPlayAudioComplete:filePath);
}
@end
