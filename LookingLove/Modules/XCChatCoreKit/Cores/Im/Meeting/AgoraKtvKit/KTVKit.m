//
//  KTVKit.m
//  Agora-Online-KTV
//
//  Created by zhanxiaochao on 2018/9/20.
//  Copyright © 2018年 Agora. All rights reserved.
//

#import "KTVKit.h"

#if !TARGET_OS_SIMULATOR
#import <IJKMediaFramework/IJKMediaFramework.h>
#import "AgoraAudioFrame.h"

@interface KTVKit()
{
    BOOL isChangeAudio;
    AgoraRtcEngineKit *_rtcEngine;
    BOOL isLoadSuccess;
    float tmp;
    BOOL isCreate;
}
@property(nonatomic, strong) id<IJKMediaPlayback> player;

@end
#endif

@implementation KTVKit
+ (instancetype)shareInstance{
    
    static dispatch_once_t once;
    static KTVKit *sharedInstance;
    dispatch_once(&once, ^{
        if (sharedInstance == NULL) {
            
            sharedInstance = [[self alloc] init];
        }
    });
    return sharedInstance;
    
}
#if !TARGET_OS_SIMULATOR
-(void)createKTVKitWithView:(UIView *)view rtcEngine:(nonnull AgoraRtcEngineKit *)rtcEngine withsampleRate:(int)sampleRate
{
    if (isCreate) {
        return;
    }
    isCreate = YES;
    _rtcEngine = rtcEngine;
    _containerView = view;
    NSLog(@"穿件KTV");
    [[AgoraAudioFrame shareInstance] registerEngineKit:_rtcEngine];
    
    [_rtcEngine setParameters:@"{\"che.video.keep_prerotation\":false}"];
    [_rtcEngine setParameters:@"{\"che.video.local.camera_index\":1025}"];
    
    //初始化之后加入频道之前开启耳返
    [_rtcEngine setRecordingAudioFrameParametersWithSampleRate:sampleRate channel:2 mode:AgoraAudioRawFrameOperationModeReadWrite samplesPerCall:sampleRate * 0.01 * 2];
    [_rtcEngine setPlaybackAudioFrameParametersWithSampleRate:sampleRate channel:2 mode:AgoraAudioRawFrameOperationModeReadWrite samplesPerCall:sampleRate * 0.01 * 2];
    //开启说话人检测功能
    [_rtcEngine enableAudioVolumeIndication:900 smooth:3 report_vad:NO];
    //加入房间
    [_rtcEngine setExternalVideoSource:true useTexture:false pushMode:true];
    [_rtcEngine setVideoResolution:CGSizeMake(640, 360) andFrameRate:15 bitrate:620];
    [_rtcEngine setParameters:@"{\"che.audio.use.remoteio\":true}"];
    [_rtcEngine setParameters:@"{\"che.audio.keep.audiosession\":true}"];
    [_rtcEngine setLocalVoiceReverbOfType:AgoraAudioReverbDryLevel withValue:0];
    
    [_rtcEngine setLocalVoiceReverbOfType:AgoraAudioReverbWetLevel withValue:4];
    
    [_rtcEngine setLocalVoiceReverbOfType:AgoraAudioReverbRoomSize withValue:60];
    
    [_rtcEngine setLocalVoiceReverbOfType:AgoraAudioReverbWetDelay withValue:18];
    
    [_rtcEngine setLocalVoiceReverbOfType:AgoraAudioReverbStrength withValue:80];
    [AgoraAudioFrame shareInstance].sampleRate = sampleRate;
    
}
//切歌
-(void)loadMV:(NSString *)videoPath;
{
    [[AgoraAudioFrame shareInstance] destroyAudioBuf];
    [self initIjkPlayer:videoPath view:_containerView];
}
//获取视频时长
-(double)getDuation{
    return self.player.duration;
}
//获取当前的视频位置
-(float)getCurrentPosition{
    return self.player.currentPlaybackTime/self.player.duration;
}
//原唱伴奏切换
-(void)switchAudioTrack:(BOOL)isSwitch{
    [self.player changeAudioStream:isSwitch];
}
//调整伴奏音量
-(void)adjustVoiceVolume:(double )volume{
    [AgoraAudioFrame shareInstance].voiceNum = volume;
}
//调整背景音量
-(void)adjustAccompanyVolume:(double)volume{
    
    [AgoraAudioFrame shareInstance].songNum = volume;

}
//视频的播放/暂停
-(void)play{
    [self.player play];
}
-(void)pause{
    [self.player pause];
}

- (BOOL)isIJKPlay {
    if (self.player) {
        return YES;
    }else {
        return NO;
    }
}

//引擎重启
-(void)resume{
    if (self.player) {
        [self.player pause];
        [self.player stop];
        [self.player shutdown];
        [self.player.view removeFromSuperview];
        self.player = NULL;
    }
    [[AgoraAudioFrame shareInstance] destroyAudioBuf];
    isCreate = NO;
    [_rtcEngine enableInEarMonitoring:false];
}
//初始化ijk
-(void)initIjkPlayer:(NSString *)url view:(UIView *)view{
    _containerView = view;
    isLoadSuccess = false;
    if (self.player) {
        [self.player pause];
        //注意一下切歌的逻辑  切歌时先暂停 执行一个过场动画3~5s  再切歌 这样最好
        [self.player stop];
        [self.player shutdown];
        [[AgoraAudioFrame shareInstance] destroyAudioBuf];
        [self.player.view removeFromSuperview];
        self.player = NULL;
        
    }
    
    //设置伴奏音量默认大小
    [AgoraAudioFrame shareInstance].songNum = 0.5;
    //设置人声音量默认大小
    [AgoraAudioFrame shareInstance].voiceNum = 0.5;

    IJKFFOptions *options = [IJKFFOptions optionsByDefault];
    //开启硬件解码器
    [options setOptionIntValue:1 forKey:@"videotoolbox" ofCategory:kIJKFFOptionCategoryPlayer];
    [options setPlayerOptionIntValue:10 forKey:@"min-frames"];
    //获取视频的地址
    //    self.player = [[IJKFFMoviePlayerController alloc] initWithContentURL:[NSURL URLWithString:@"http://compress.mv.letusmix.com/914184d11605138c7de8c28f2905c63a.mp4"] withOptions:options];
    self.player = [[IJKFFMoviePlayerController alloc] initWithContentURL:[NSURL URLWithString:url] withOptions:options];
    self.player.view.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    self.player.view.frame = view.bounds;
    self.player.scalingMode = IJKMPMovieScalingModeFill;
    self.player.shouldAutoplay = false;
    [self.player setPauseInBackground:true];
    view.autoresizesSubviews = YES;
    [view addSubview:self.player.view];
    [self registerNotifications];
    [self refreshMediaControl];
    [self.player prepareToPlay];
    tmp = 0.000000f;
}
-(void)registerRTCEngine:(AgoraRtcEngineKit *)rtcEngine{
    _rtcEngine = rtcEngine;
    
}
-(void)registerNotifications{
    [self removeNotifications];
    //注册引擎回调
    [[AgoraAudioFrame shareInstance] registerEngineKit:_rtcEngine];
    //注册音频回调通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ijk_Audio_CallBack:) name:@"ijk_Audio_CallBack" object:nil];
    //注册视频回调通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ijk_video_CallBack:) name:@"ijk_video_CallBack" object:nil];
    //注册音频回调通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(PlaybackDidFinish:) name:IJKMPMoviePlayerPlaybackDidFinishNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadMVSuccess) name:IJKMPMediaPlaybackIsPreparedToPlayDidChangeNotification object:nil];
    
}
-(void)ijk_video_CallBack:(NSNotification *)notification{
    
    CVPixelBufferRef buffer = (__bridge CVPixelBufferRef)(notification.object);
    AgoraVideoFrame *videoFrame = [[AgoraVideoFrame alloc] init];
    videoFrame.format = 12;
    videoFrame.time = CMTimeMake(CACurrentMediaTime()*1000, 1000);
    videoFrame.textureBuf = buffer;
    [_rtcEngine pushExternalVideoFrame:videoFrame];
    
}
//得到音频数据的处理
-(void)ijk_Audio_CallBack:(NSNotification *)notification
{
    NSData *data = notification.object;
    char * p = (char *)[data bytes];
    if (isLoadSuccess) {
        [[AgoraAudioFrame shareInstance] pushAudioSource:p byteLength:data.length];
    }
}
//播放完成回调
-(void)PlaybackDidFinish:(NSNotification *)not{
    NSLog(@"not.userInfo%@",not.userInfo);
    if (self.delegate && [self.delegate respondsToSelector:@selector(ktvStatusCallBack:)]) {
        [self.delegate ktvStatusCallBack:KTVStatusTypeCompleted];
    }
    
}
-(void)removeNotifications{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"ijk_Audio_CallBack" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"ijk_video_CallBack" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:IJKMPMoviePlayerPlaybackDidFinishNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:IJKMPMediaPlaybackIsPreparedToPlayDidChangeNotification object:nil];
}
-(void)destroyKTVKit
{
    [self resume];
    [self removeNotifications];
}
-(void)loadMVSuccess{
    isLoadSuccess = true;
    if (self.delegate && [self.delegate respondsToSelector:@selector(ktvStatusCallBack:)]) {
        [self.delegate ktvStatusCallBack:KTVStatusTypePrepared];
    }
}
-(void)refreshMediaControl{
    float postion = 0.000000f;
     postion = [self getCurrentPosition];
    float duation = 0.f;
    int limitduation = 960;
    if (isLoadSuccess) {
       duation = [self getDuation];
        if ((int)duation > 120) {
            limitduation = 990;
        }
    }
    if (isLoadSuccess && postion != 0.00000f && (int)(postion * 100) - (int)(tmp* 100) == 0 && (int)(postion * 1000) > limitduation ) {
        isLoadSuccess = false;
        if (self.delegate && [self.delegate respondsToSelector:@selector(ktvStatusCallBack:)]) {
            [self.delegate ktvStatusCallBack:KTVStatusTypeCompleted];
        }
    }
    NSLog(@"positon  --> %f",postion);
    if (self.player) {
        [self performSelector:@selector(refreshMediaControl) withObject:nil afterDelay:1];
    }
    tmp = postion;
}
- (BOOL)isrtcEngine {
    if (_rtcEngine) {
        return YES;
    }
    
    return NO;
}
#else
//创建KTVKit
-(void)createKTVKitWithView:(UIView *)view rtcEngine:(nonnull AgoraRtcEngineKit *)rtcEngine withsampleRate:(int)sampleRate{
    
}
//切歌
-(void)loadMV:(NSString *)videoPath{
    
}
//获取视频时长
-(double)getDuation{
    return 0.0;
}
//获取当前的视频位置
-(float)getCurrentPosition{
    return 0.0;
}
//原唱伴奏切换
-(void)switchAudioTrack:(BOOL)isSwitch{
    
}
//调整伴奏音量
-(void)adjustVoiceVolume:(double )volume{
    
}
//调整背景音量
-(void)adjustAccompanyVolume:(double)volume{
    
}
//视频的播放/暂停
-(void)play{
    
}
-(void)pause{
    
}
//引擎释放
-(void)resume{
    
}
//引擎销毁
-(void)destroyKTVKit{
    
}

//ijkplay 是否存在
- (BOOL)isIJKPlay{
    return YES;
}
- (BOOL)isrtcEngine {
    return YES;
}
-(void)registerRTCEngine:(AgoraRtcEngineKit *)rtcEngine {
    
}
#endif
@end
