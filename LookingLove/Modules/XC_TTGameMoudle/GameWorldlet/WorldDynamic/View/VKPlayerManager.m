//
//  VKPlayerManager.m
//  UKiss
//
//  Created by apple on 2019/1/8.
//  Copyright © 2019 yizhuan. All rights reserved.
//

#import "VKPlayerManager.h"
#import "UIView+XCToast.h"
#define RecordFielName @"record.wav"


@interface VKPlayerManager ()<AVAudioPlayerDelegate , AVAudioRecorderDelegate>

@property (nonatomic, strong) AVAudioSession *session;
///播放完成回调
@property (nonatomic, copy) void (^playerCompletionBlock)(void);

@end

@implementation VKPlayerManager

#pragma mark - puble method

+ (instancetype)shareInstance {
    static dispatch_once_t once;
    static VKPlayerManager *sharedInstance;
    dispatch_once(&once, ^{
        if (sharedInstance == NULL) {
            sharedInstance = [[self alloc] init];
        }
    });
    return sharedInstance;
}

///播放音频
- (void)playerMusicWithPath:(NSString *)filePath volume:(CGFloat)volume {
    [self.audioRecorder stop];
    //    [self setSysVolumWith:0.5];
    [self playerMusicWithPath:filePath volume:volume loop:YES completionBlock:nil];
}

- (void)playerVoiceWithPath:(NSString *)filePath completionBlock:(void (^)(void))completionBlock; {
    [self playerMusicWithPath:filePath volume:1 loop:NO completionBlock:completionBlock];
}


- (void)stopMusicIsNeedCompletion:(BOOL)isNeedCompletion {
    if (self.player.playing) {
        [self.player stop];
        self.player = nil;
        if (isNeedCompletion && self.playerCompletionBlock) {
            self.playerCompletionBlock();
        }
        self.playerCompletionBlock = nil;
    }
    self.volume = 1;
}

/** 开始录音 */
- (void)startRecording {
    /*******录音时停止播放 删除曾经生成的文件*********/
    [self stopMusic];
    [self destructionRecordingFile];
    /*******真机环境下需要的代码*********/
    NSError *sessionError;
    [self.session setCategory:AVAudioSessionCategoryPlayAndRecord error:&sessionError];
    if(self.session == nil){
        NSLog(@"Error creating session: %@", [sessionError description]);
    }else{
        [self.session setActive:YES error:nil];
    }
    [self.audioRecorder record];
}

///停止录音
- (void)stopRecording {
    if ([self.audioRecorder isRecording]) {
        [self.audioRecorder stop];
        //        /*****暂停计时器******/
        //        [self pauseTimer];
    }
}

- (void)stopMusic {
    [self stopMusicIsNeedCompletion:NO];
}

#pragma mark - AVAudioPlayerDelegate

///播放完成回调
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag {
    if (self.playerCompletionBlock) {
        self.playerCompletionBlock();
        self.playerCompletionBlock = nil;
    }
}

///播放出错回调
- (void)audioPlayerDecodeErrorDidOccur:(AVAudioPlayer *)player error:(NSError * __nullable)error {
    
}


-(void)audioRecorderDidFinishRecording:(AVAudioRecorder *)recorder successfully:(BOOL)flag{
    NSLog(@"录音完成!");
}


#pragma mark - 私有方法

/**
 播放音频
 
 @param filePath 本地路径
 @param volume 声音大小
 @param loop 是否循环播放
 @param completionBlock 播放完成回调
 */
- (void)playerMusicWithPath:(NSString *)filePath volume:(CGFloat)volume loop:(BOOL)loop completionBlock:(void (^)(void))completionBlock {
    [self.session setCategory:AVAudioSessionCategoryPlayback withOptions:AVAudioSessionCategoryOptionAllowBluetooth error:nil];
    if (self.player) {
        [self.player stop];
        self.player = nil;
    }
    if (![[NSFileManager defaultManager] fileExistsAtPath:filePath]) return;
    NSURL *url = [NSURL fileURLWithPath:filePath];
    NSError *AVerror = NULL;
    NSError * error;
    self.player = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&AVerror];
    self.player.numberOfLoops = loop ? -1 : 0;
    self.player.volume = volume;
    if (AVerror) {//无效链接
        [UIView showError:@"播放错误"];
        if (completionBlock) {
            completionBlock();
        }
        return;
    }
    self.player.delegate = self;
    [self.player prepareToPlay];
    [self.player play];
    self.playerCompletionBlock = completionBlock;
}

/** 销毁录音 */
-(void)destructionRecordingFile {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:self.recordFilePath]) {
        [fileManager removeItemAtPath:self.recordFilePath error:nil];
    }
}

#pragma mark - get/set方法

- (void)setVolume:(CGFloat)volume {
    _volume = volume;
    self.player.volume = volume;
}

- (NSString *)recordFilePath {
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *filePath = [path stringByAppendingPathComponent:RecordFielName];
    return filePath;
}

- (AVAudioRecorder *)audioRecorder {
    if (!_audioRecorder) {
        NSURL * recordFileUrl = [NSURL fileURLWithPath:self.recordFilePath];
        //********设置录音的一些参数*********
        NSMutableDictionary *setting = [NSMutableDictionary dictionary];
        //***********音频格式***********
        setting[AVFormatIDKey] = @(kAudioFormatLinearPCM);
        //*****录音采样率(Hz) 如：AVSampleRateKey==8000/44100/96000（影响音频的质量）****
        setting[AVSampleRateKey] = @(44100);
        //***********音频通道数 1 或 2(只有单通道才能转换为mp3)***********
        setting[AVNumberOfChannelsKey] = @(2);
        //***********线性音频的位深度  8、16、24、32***********
        setting[AVLinearPCMBitDepthKey] = @(16);
        //***********录音的质量***********
        setting[AVEncoderAudioQualityKey] = [NSNumber numberWithInt:AVAudioQualityHigh];
        
        _audioRecorder = [[AVAudioRecorder alloc] initWithURL:recordFileUrl settings:setting error:NULL];
        _audioRecorder.delegate = self;
        _audioRecorder.meteringEnabled = YES;
        
        [_audioRecorder prepareToRecord];
    }
    return _audioRecorder;
}

-(AVAudioSession *)session{
    if (!_session) {
        _session = [AVAudioSession sharedInstance];
    }
    return _session;
}

@end
