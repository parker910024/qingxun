////
////  MeetingCoreV2.m
////  BberryCore
////
////  Created by KevinWang on 2018/6/28.
////  Copyright © 2018年 chenran. All rights reserved.
////
//
//#import "MeetingCoreV2.h"
//#import "MeetingCoreClient.h"
//
//#import "UserInfo.h"
//#import "HostUrlManager.h"
//
//#import "AuthCore.h"
//#import "UserCore.h"
//#import "RoomCore.h"
//#import "ImRoomCoreClient.h"
//#import "ImRoomCoreClientV2.h"
//
//#import <ZegoAudioRoom/zego-api-mediaplayer-oc.h>
//#import <ZegoAudioRoom/zego-api-sound-level-oc.h>
//#import <ZegoAudioRoom/zego-api-audio-processing-oc.h>
//
//
//@interface MeetingCoreV2()
//<ZegoAudioRoomDelegate,
//ZegoAudioLivePublisherDelegate,
//ZegoAudioLivePlayerDelegate,
//ZegoSoundLevelDelegate,
//ZegoMediaPlayerEventDelegate>
//
//@property(nonatomic, strong) NSMutableArray *speakingArray;
//@property(nonatomic, assign) BOOL isSpeaking;
//@property (nonatomic, strong) ZegoAudioRoomApi *engine;
//@property (nonatomic, strong) ZegoMediaPlayer *mediaPlayer;
//
//@end
//
//@implementation MeetingCoreV2
//
//- (instancetype)init
//{
//    self = [super init];
//    if (self) {
//        self.isMute = NO;
//        
//#ifdef DEBUG
//        EnvironmentType env = (EnvironmentType)[[NSUserDefaults standardUserDefaults]integerForKey:ENV_ID];
//        if (env==DevType){
//            [ZegoAudioRoomApi setUseTestEnv:YES];
//        }else if (env==TestType){
//            [ZegoAudioRoomApi setUseTestEnv:YES];
//        }else if (env==Pre_ReleaseType){
//            [ZegoAudioRoomApi setUseTestEnv:NO];
//        }else if (env==ReleaseType){
//            [ZegoAudioRoomApi setUseTestEnv:NO];
//        }else{
//            [ZegoAudioRoomApi setUseTestEnv:YES];
//        }
//        
//        // 调试信息开关
//        [ZegoAudioRoomApi setVerbose:YES];
//#else
//        [ZegoAudioRoomApi setUseTestEnv:NO];
//#endif
//        //设置模式默认为2 (实时语音类型), 可以取值0 (直播类型)
//        [ZegoAudioRoomApi setBusinessType:0];
//        
//        _engine = [[ZegoAudioRoomApi alloc] initWithAppID:[self appID] appSignature:[self zegoAppSign]];
//        [_engine enableAGC:true];
//        //手动发布
//        [_engine setManualPublish:true];
//        //delegate
//        [_engine setAudioRoomDelegate:self];
//        [_engine setAudioPublisherDelegate:self];
//        [_engine setAudioPlayerDelegate:self];
//        
//        
//        AddCoreClient(ImRoomCoreClientV2, self);
//    }
//    return self;
//}
//
//#pragma mark - ZegoAudioRoomDelegate
///**
// 与 server 断开通知
// 
// @param errorCode 错误码，0 表示无错误
// @param roomID 房间 ID
// @discussion 建议开发者在此通知中进行重新登录、推/拉流、报错、友好性提示等其他恢复逻辑。与 server 断开连接后，SDK 会进行重试，重试失败抛出此错误。请注意，此时 SDK 与服务器的所有连接均会断开
// */
//- (void)onDisconnect:(int)errorCode roomID:(NSString *)roomID{
//    //    NSLog(@"errorCode:%d---roomID:%@",errorCode,roomID);
//    NotifyCoreClient(MeetingCoreClient, @selector(onMeetingQualityDown), onMeetingQualityDown);
//}
//
///**
// 流更新消息，此时sdk会开始拉流/停止拉流
// 
// @param type 增加/删除流
// @param stream 流信息
// */
//- (void)onStreamUpdated:(ZegoAudioStreamType)type stream:(ZegoAudioStream*)stream{
//    
//}
//
//#pragma mark - ZegoAudioLivePublisherDelegate
///**
// 推流状态更新
// 
// @param stateCode 状态码
// @param streamID 流ID
// @param info 推流信息
// */
//- (void)onPublishStateUpdate:(int)stateCode streamID:(NSString *)streamID streamInfo:(NSDictionary *)info{
//    
//}
//
//#pragma mark - ZegoAudioLivePlayerDelegate
///**
// 播放流事件
// 
// @param stateCode 播放状态码
// @param stream 流信息
// */
//- (void)onPlayStateUpdate:(int)stateCode stream:(ZegoAudioStream *)stream{
//    
//}
//
///**
// 观看质量更新
// 
// @param streamID 观看流ID
// @param quality quality 参考ZegoApiPlayQuality定义
// */
//- (void)onPlayQualityUpate:(NSString *)streamID quality:(ZegoApiPlayQuality)quality{
//    
//}
//
//#pragma mark - ZegoSoundLevelDelegate
//
///**
// soundLevel 更新回调
// 
// @param soundLevels 回调信息列表，列表项结构参考 ZegoSoundLevelInfo 定义
// */
//- (void)onSoundLevelUpdate:(NSArray<ZegoSoundLevelInfo *> *)soundLevels{
//    if (!self.isMute) {
//        [self onSpeakingUsersReport:soundLevels];
//    }
//
//}
//
//
///**
// captureSoundLevel 更新回调
// 
// @param captureSoundLevel 采集音量回调，结构参考 ZegoSoundLevelInfo 定义
// */
//- (void)onCaptureSoundLevelUpdate:(ZegoSoundLevelInfo *)captureSoundLevel{
//    if (captureSoundLevel != nil && self.actor) {
//        //         NSLog(@"streamID:%@---soundLevel:%f",captureSoundLevel.streamID,captureSoundLevel.soundLevel);
//        [self onSpeakingUsersReport:@[captureSoundLevel]];
//    }
//}
//#pragma mark - ZegoMediaPlayerEventDelegate
///**
// 开始播放
// */
//- (void)onPlayStart{
//    NSLog(@"");
//}
///**
// 播放错误
// 
// */
//- (void)onPlayError:(int)code{
//    NSLog(@"");
//}
///**
// 音频开始播放
// */
//- (void)onAudioBegin{
//    NSLog(@"");
//}
///**
// 播放结束
// */
//- (void)onPlayEnd{
//    NSLog(@"");
//    [self startPlayMusicAtIndex:(self.currentIndex + 1) % self.musicLists.count];
//    NotifyCoreClient(MeetingCoreClient, @selector(onUpdateNextMusicName:Artist: ), onUpdateNextMusicName:self.currentMusic.musicName Artist:self.currentMusic.musicArtists);
//}
//
//#pragma mark - ImRoomCoreClientV2
//- (void)onMeExitChatRoomSuccessV2 {
//    self.isPlaying = NO;
//    self.currentMusic = nil;
//    [self stopPlayMusic];
//    [self.mediaPlayer uninit];
//    NotifyCoreClient(MeetingCoreClient, @selector(onIntoNewRoomSuccess), onIntoNewRoomSuccess);
//}
//
//
//#pragma mark - puble method
//
////加入zego
//- (void)joinMeeting:(NSString *)roomId actor:(BOOL)actor{
//    self.mediaPlayer = [[ZegoMediaPlayer alloc] initWithPlayerType:MediaPlayerTypeAux];
//    [self adjustMusicSoundVol:80];
//    [self.mediaPlayer setDelegate:self];
//    //开始监听
//    [[ZegoSoundLevel sharedInstance] setSoundLevelDelegate:self];
//    [[ZegoSoundLevel sharedInstance] setSoundLevelMonitorCycle:1200]; //监控周期 [100, 3000]。默认 200 ms。
//    [[ZegoSoundLevel sharedInstance] startSoundLevelMonitor];
//    UserInfo *userInfo = [GetCore(UserCore) getUserInfoInDB:GetCore(AuthCore).getUid.userIDValue];
//    //设置用户id跟name
//    [ZegoAudioRoomApi setUserID:GetCore(AuthCore).getUid userName:userInfo.nick];
//    self.isMute = NO;
//    [self.engine enableSpeaker:true];
//    if (GetCore(ImRoomCoreV2).currentRoomInfo.audioQuality == AudioQualityType_High) {
////        [self.engine setLatencyMode:ZEGOAPI_LATENCY_MODE_LOW];
////        [self.engine setAudioBitrate:16000];//取值范围16000到192000   码率越高音质效果越好
////        [ZegoAudioRoomApi setAudioDeviceMode:ZEGOAPI_AUDIO_DEVICE_MODE_COMMUNICATION];
////        [self.engine enableAEC:true];
//        [self.engine setLatencyMode:ZEGOAPI_LATENCY_MODE_NORMAL];
//        [self.engine setAudioBitrate:48000];
//        [ZegoAudioRoomApi setAudioDeviceMode:ZEGOAPI_AUDIO_DEVICE_MODE_GENERAL];
//        
//        [ZegoAudioProcessing enableReverb:true mode:ZEGOAPI_AUDIO_REVERB_MODE_LARGE_AUDITORIUM];
//        [ZegoAudioProcessing enableVirtualStereo:true angle:90];
//    }else {
////        [self.engine setLatencyMode:ZEGOAPI_LATENCY_MODE_NORMAL];
////        [self.engine setAudioBitrate:48000];
////        [ZegoAudioRoomApi setAudioDeviceMode:ZEGOAPI_AUDIO_DEVICE_MODE_GENERAL];
//        
//        [self.engine setLatencyMode:ZEGOAPI_LATENCY_MODE_LOW];
//        [self.engine setAudioBitrate:16000];//取值范围16000到192000   码率越高音质效果越好
//        [ZegoAudioRoomApi setAudioDeviceMode:ZEGOAPI_AUDIO_DEVICE_MODE_COMMUNICATION];
//        
//    }
//    
//    //加入zego
//    int state = [self.engine loginRoom:roomId completionBlock:^(int errorCode) {
//        if (actor) {
//            //发布
//            [self.engine startPublish];
//        }else {
//            //停止
//            [self.engine stopPublish];
//        }
//    }];
//    if (state != 1) {
//        [YYLogger info:@"JoinZegoChannelFailure" message:@"failure--->stat:%d",state];
//        NotifyCoreClient(MeetingCoreClient, @selector(onJoinMeetingFailth), onJoinMeetingFailth);
//    }else{
//        [YYLogger info:@"JoinZegoChannelSuccess" message:@"success--->stat:%@",roomId];
//        NotifyCoreClient(MeetingCoreClient, @selector(onJoinMeetingSuccess), onJoinMeetingSuccess);
//    }
//    
//}
//
//- (void)resetMeeting:(NSString *)roomId actor:(BOOL)actor{
//    
//    [self.engine stopPublish];
//    if (GetCore(ImRoomCoreV2).currentRoomInfo.audioQuality == AudioQualityType_High) {
//        //        [self.engine setLatencyMode:ZEGOAPI_LATENCY_MODE_LOW];
//        //        [self.engine setAudioBitrate:16000];//取值范围16000到192000   码率越高音质效果越好
//        //        [ZegoAudioRoomApi setAudioDeviceMode:ZEGOAPI_AUDIO_DEVICE_MODE_COMMUNICATION];
//        //        [self.engine enableAEC:true];
//        [self.engine setLatencyMode:ZEGOAPI_LATENCY_MODE_NORMAL];
//        [self.engine setAudioBitrate:48000];
//        [ZegoAudioRoomApi setAudioDeviceMode:ZEGOAPI_AUDIO_DEVICE_MODE_GENERAL];
//        
//        [ZegoAudioProcessing enableReverb:true mode:ZEGOAPI_AUDIO_REVERB_MODE_LARGE_AUDITORIUM];
//        [ZegoAudioProcessing enableVirtualStereo:true angle:90];
//    }else {
//        //        [self.engine setLatencyMode:ZEGOAPI_LATENCY_MODE_NORMAL];
//        //        [self.engine setAudioBitrate:48000];
//        //        [ZegoAudioRoomApi setAudioDeviceMode:ZEGOAPI_AUDIO_DEVICE_MODE_GENERAL];
//        
//        [self.engine setLatencyMode:ZEGOAPI_LATENCY_MODE_LOW];
//        [self.engine setAudioBitrate:16000];//取值范围16000到192000   码率越高音质效果越好
//        [ZegoAudioRoomApi setAudioDeviceMode:ZEGOAPI_AUDIO_DEVICE_MODE_COMMUNICATION];
//        
//    }
//    
//    if (self.actor&&!self.isCloseMicro) {
//        [self.engine startPublish];
//    }
//    
//}
//- (void) leaveMeeting:(NSString *)roomId{
//    
//    self.actor = NO;
//    [[ZegoSoundLevel sharedInstance] stopSoundLevelMonitor];
//    BOOL res = [self.engine logoutRoom];
//    if (res) {
//        [YYLogger info:@"leaveAgoraChannelSuccess" message:@"success--->stat:%d",res];
//        NotifyCoreClient(MeetingCoreClient, @selector(onLeaveMeetingSuccess), onLeaveMeetingSuccess);
//    }else {
//        [YYLogger info:@"leaveAgoraChannelfailure" message:@"failure--->stat:%d",res];
//    }
//    
//}
///**
// （声音输出）静音开关enableSpeaker
// true 不静音，false 静音。默认 true
// true 成功，false 失败
// 设置为关闭后，内置扬声器和耳机均无声音输出
// */
//- (BOOL)setMute:(BOOL)isMute {
//    BOOL result = NO;
//    if (isMute) {
//        if ([self.engine enableSpeaker:false]) {
//            result = YES;
//        }else{
//            result = NO;
//        }
//    }else{
//        if ([self.engine enableSpeaker:true]) {
//            result = YES;
//        }else{
//            result = NO;
//        }
//    }
//    if (result) {
//        self.isMute = isMute;
//    }
//    
//    return result;
//}
///**
// 开启关闭麦克风enableMic
// true 打开，false 关闭。默认 false
// true 成功，false 失败
// */
//- (BOOL)setCloseMicro:(BOOL)close{
//    BOOL result = NO;
//    if (close) {
//        if ([self.engine enableMic:false]) {
//            [self.engine stopPublish];
//            result = YES;
//        } else {
//            result = NO;
//        }
//    } else {
//        if ([self.engine enableMic:true]) {
//            [self.engine startPublish];
//            result = YES;
//        }else {
//            result = NO;
//        }
//    }
//    if (result) {
//        self.isCloseMicro = close;
//    }
//    return result;
//}
//
//- (BOOL)setMeetingRole:(BOOL)actor{
//    
//    BOOL result = NO;
//    if (actor) {
//        if (!self.isCloseMicro) {
//            if ([self.engine startPublish]) {
//                result = YES;
//            }else {
//                result = NO;
//            }
//            [self.engine enableMic:true];
//        }else{
//            result = YES;
//        }
//    } else {
//        if (self.isPlaying) {
//            self.isPlaying = NO;
//            self.currentMusic = nil;
//            [self stopPlayMusic];
//        }
//        [self.engine enableMic:false];
//        [self.engine stopPublish];
//        result = YES;
//    }
//    
//    if (result) {
//        self.actor = actor;
//    }
//    return YES;
//}
//
//
//#pragma mark - private method
//- (void)onSpeakingUsersReport:(NSArray *)report {
//    NSMutableArray *uids = [NSMutableArray array];
//    if (report != nil && report.count > 0) {
//        for (ZegoSoundLevelInfo *userInfo in report) {
//            NSString *uid = nil;
//            NSArray *strArray = [userInfo.streamID componentsSeparatedByString:@"-"];
//            if (strArray.count>=2) {
//                uid = [strArray objectAtIndex:1];
//                if (userInfo.soundLevel > 3) {
//                    [uids addObject:@(uid.userIDValue)];
//                }
//            }
//        }
//        self.speakingArray = uids;
//        NotifyCoreClient(MeetingCoreClient, @selector(onSpeakingUsersReport:), onSpeakingUsersReport:self.speakingArray);
//    } else {
//        if (self.speakingArray != nil) {
//            self.speakingArray = nil;
//            NotifyCoreClient(MeetingCoreClient, @selector(onSpeakingUsersReport:), onSpeakingUsersReport:nil);
//        }
//    }
//    
//}
//
//
//#pragma mark - public music
////播放器
//- (BOOL)startPlayMusicAtIndex:(NSInteger)index {
//    int state = 1;
//    [self.mediaPlayer stop];//切换歌曲need stop
//    NSString * fileName = self.musicLists[index].musicName;
//    NSString * documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
//    documentsPath = [NSString stringWithFormat:@"%@/music/",documentsPath];
//    NSString * musicPath = [documentsPath stringByAppendingString:fileName];
//    NSLog(@"地址：%@",musicPath);
//    
//    if (musicPath) {
//        
//        self.currentIndex = index;
//        self.currentMusic = self.musicLists[self.currentIndex];
//        state = [self.engine enableAux:true];
//        [self.mediaPlayer start:musicPath Repeat:NO];
//        
//    }
//    return !state;
//}
///**
// 混音开关enableAux
// true 启用混音输入，false 关闭混音输入。默认 false
// */
//- (void)stopPlayMusic{
//    [self.mediaPlayer stop];
//    [self.engine enableAux:false];
//}
///**
// 混音静音开关- (bool)muteAux:(bool)bMute;
// true: aux 输入播放静音，false: 不静音。默认 false
// */
//- (BOOL)pausePlayMusic {
//    [self.mediaPlayer pause];
//    return true;
//}
//
//- (void)resumePlayMusic {
//    [self.mediaPlayer resume];
//}
//
////调整music音量大小
//- (void)adjustMusicSoundVol:(NSInteger)vol {
//    self.soundVol = vol;
//    [self.mediaPlayer setVolume:(int)vol];
//    
//}
//
////调整混音音量大小
//- (int)adjustVoiceVol:(NSInteger)vol {
//    self.voiceVol = vol;
//    int result = 1;
////    [self.engine setAuxVolume:(int)vol];
//    [self.engine setPlayVolume:(int)vol];
//    return result;
//}
//
//#pragma mark - private method
//- (uint32_t)appID{
//
//    return 4124511964;
//}
//
//- (NSData *)zegoAppSign{
//
//    Byte signkey[] = {0x18,0xe6,0x59,0x90,0x40,0x52,0xa7,0x0e,0x76,0x26,0x2a,0xa5,0xae,0xd9,0xb3,0x68,0x61,0x09,0xcb,0xf5,0x75,0x15,0xcd,0x41,0xb6,0xa3,0x92,0x90,0x22,0x89,0xc1,0xde};
//    return [NSData dataWithBytes:signkey length:32];
//}
//
//@end
