//
//  MeetingCore.h
//  Bberry
//
//  Created by KevinWang on 2018/8/11.
//  Copyright © 2018年 XC. All rights reserved.
//
/*
 问题：
 1. 原唱伴唱 mv是不固定时间进行回返
 
 
 声网设置
 1. 麦上MV演唱 ：AgoraClientRoleBroadcaster    Auido+Video
 2. 麦上非演唱者：AgoraClientRoleBroadcaster    Auido。 enableLocalVideo
 3. 麦下听众   : AgoraClientRoleAudience
 
 移动端
 1. 普通->KTV:更换ui。 KTV->普通: 更换UI 清空已点歌曲
 2. 进入房间 显示正在播放歌曲的UI 根据演唱者id显示点唱标识
 3. 点歌：
 发送请求
 发送自定义消息
 收到点歌消息，公屏显示。已点+1
 4. 演唱
 
 IJKMPMoviePlayerPlaybackDidFinishNotification;
 IJKMPMoviePlayerPlaybackDidFinishReasonUserInfoKey;
 5. 演唱结束
 告诉服务器
 发送自定义消息
 收到演唱结束消息公屏显示已点-1
 
 6. 收到歌曲变更通知
 刷新UI与点唱标识。
 更换声网设置
 (或者收到结束消息，拿点歌单第一首显示？  还需要拿重新请求拿最新的歌单，可能调整过歌单)
 7. 唱歌中，有已点 在执行下麦，最小化 二次确认 切歌 切换声网配置
 被踢，被拉黑，退出房间 删除自己所有已点歌曲
 
 8. 切歌，删歌
 发送请求成功，发送自定义消息
 
 
 
 
 服务端
 1. KTV房间列表
 2. 房间类型（切换：是否开启KTV）
 3. 当前房间正在演唱的歌曲
 4. 切歌（需要发送房间歌曲改变通知）
 5. 已点歌曲:点歌（服务端判断），列表, 置顶，删除置顶歌曲,删除全部歌曲。
 6. 点歌台歌曲列表(封面，歌名,歌手，时长)
 7. 搜索歌曲
 8. 歌曲播放结束（变更了当前房间的演唱歌曲，需要给房间发送歌曲变更通知）
 */

#import "MeetingCore.h"
#import "MeetingCoreClient.h"

#import "AuthCore.h"
#import "UserInfo.h"
#import "UserCore.h"
#import "RoomCore.h"

#import "ImRoomCoreClient.h"
#import "ImRoomCoreClientV2.h"

#import "XCMacros.h"
#import <AVFoundation/AVFoundation.h>


@interface MeetingCore()<ImRoomCoreClient, AgoraRtcEngineDelegate>

@property(nonatomic, strong) NSMutableArray *speakingArray;
@property(nonatomic, assign) BOOL isSpeaking;
@property(nonatomic, strong) AgoraRtcEngineKit *engine;

@end

@implementation MeetingCore

#pragma mark - life cycle
//不管何时,只要有通知中心的出现,在dealloc的方法中都要移除所有观察者.
-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.isMute = NO;
        
        NSString *key = keyWithType(KeyType_Agora, NO);
        _engine = [AgoraRtcEngineKit sharedEngineWithAppId:key delegate:self];

        [self.engine setChannelProfile:AgoraChannelProfileLiveBroadcasting];
        [self.engine enableLastmileTest];
        
        //声网说，这句话（[self.engine setParameters:@"{\"che.audio.use.remoteio\":true}"];）是取消回音消除的，但是这个话从2017年年年末已经是这个参数，自从声网sdk升级到2.2.3之后（没问题的版本号是2.0.2），就出现时大面积的回音问题，虽然不知道是什么情况，但是声网建议把这句话取消掉。结果回音的问题真的没了。如果出现问题就找QQ：2831431515  2018-10-12 何卫明注
//        [self.engine setParameters:@"{\"che.audio.use.remoteio\":true}"];
        
        [self.engine setParameters:@"{\"che.audio.keep.audiosession\":true}"];
        
//        [[AVAudioSession sharedInstance] setActive:YES error:nil];//创建单例对象并且使其设置为活跃状态.
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(audioRouteChangeListenerCallback:)   name:AVAudioSessionRouteChangeNotification object:nil];//设置通知
        
        //log
#ifdef DEBUG
        [_engine setLogFilter:AgoraLogFilterInfo];
#else
        [_engine setLogFilter:0];
#endif
        AddCoreClient(ImRoomCoreClientV2, self);
    }
    return self;
}



//通知方法的实现
- (void)audioRouteChangeListenerCallback:(NSNotification*)notification
{
    
    NSDictionary *interuptionDict = notification.userInfo;
    NSInteger routeChangeReason = [[interuptionDict valueForKey:AVAudioSessionRouteChangeReasonKey] integerValue];
    switch (routeChangeReason) {
        case AVAudioSessionRouteChangeReasonNewDeviceAvailable:
            NSLog(@"耳机插入");
            break;
        case AVAudioSessionRouteChangeReasonOldDeviceUnavailable:
            [self.engine setEnableSpeakerphone:true];
            NSLog(@"耳机拔出");
            break;
        case AVAudioSessionRouteChangeReasonCategoryChange:
            // called at start - also when other audio wants to play
            NSLog(@"AVAudioSessionRouteChangeReasonCategoryChange");
            break;
    }
}

#pragma mark - AgoraRtcEngineDelegate
- (void)rtcEngine:(AgoraRtcEngineKit *)engine lastmileQuality:(AgoraNetworkQuality)quality{
    if (quality >= 3) {
        NotifyCoreClient(MeetingCoreClient, @selector(onMeetingQualityBad), onMeetingQualityBad);
    }
}

- (void)rtcEngineConnectionDidLost:(AgoraRtcEngineKit *)engine {
    NotifyCoreClient(MeetingCoreClient, @selector(onMeetingQualityDown), onMeetingQualityDown);
}


- (void)rtcEngine:(AgoraRtcEngineKit *)engine reportAudioVolumeIndicationOfSpeakers:(NSArray *)speakers totalVolume:(NSInteger)totalVolume {
    [self onSpeakingUsersReport:speakers];
}


- (void)rtcEngineLocalAudioMixingDidFinish:(AgoraRtcEngineKit *)engine{
    [self startPlayMusicAtIndex:(self.currentIndex + 1) % self.musicLists.count];
    NotifyCoreClient(MeetingCoreClient, @selector(onUpdateNextMusicName:Artist: ), onUpdateNextMusicName:self.currentMusic.musicName Artist:self.currentMusic.musicArtists);
}

//自己加入agora成功
-(void)rtcEngine:(AgoraRtcEngineKit *)engine didJoinChannel:(NSString *)channel withUid:(NSUInteger)uid elapsed:(NSInteger)elapsed{


}

#pragma mark - ImRoomCoreClientV2
//退出房间
- (void)onMeExitChatRoomSuccessV2 {
    self.isPlaying = NO;
    self.currentMusic = nil;
    [self stopPlayMusic];
    [self.engine leaveChannel:nil];

    NotifyCoreClient(MeetingCoreClient, @selector(onIntoNewRoomSuccess), onIntoNewRoomSuccess);
}

#pragma mark - puble method  join
//加入agora
- (void)joinMeeting:(NSString *)name actor:(BOOL)actor{
    self.isMute = NO;
    
    [self.engine setEnableSpeakerphone:YES];
    
    [self.engine enableAudio];
    [self.engine disableVideo];
    [self.engine enableAudioVolumeIndication:900 smooth:3 report_vad:NO];
    [self joinNormalMeeting:actor name:name];
}

//重新加入
- (void)resetMeeting:(NSString *)name actor:(BOOL)actor{

    [self.engine leaveChannel:nil];
    [self joinMeeting:name actor:actor];
    [self setMeetingRole:actor];

}
//离开agora
- (void) leaveMeeting:(NSString *)name{
    self.actor = NO;
    [self.engine leaveChannel:^(AgoraChannelStats * _Nonnull stat) {
        NotifyCoreClient(MeetingCoreClient, @selector(onLeaveMeetingSuccess), onLeaveMeetingSuccess);
    }];
}

#pragma mark - puble method control
//mute
- (BOOL)setMute:(BOOL)isMute {
    BOOL result = NO;
    if ([self.engine muteAllRemoteAudioStreams:isMute] == 0) {
        result = YES;
    }
    if (result) {
        self.isMute = isMute;
    }
    return result;
}
//关闭自己麦克风
- (BOOL)setCloseMicro:(BOOL)close{
    BOOL result = NO;
    if (close) {
        if ([self.engine muteLocalAudioStream:YES] == 0) {
            result = YES;
        }
    } else {
        if ([self.engine muteLocalAudioStream:NO] == 0) {
            result = YES;
        }
    }
    if (result) {
        self.isCloseMicro = close;
    }
    return result;
}

//设置主播
- (BOOL)setMeetingRole:(BOOL)actor{
    BOOL result = NO;

    result = [self updateNormalMeeting:actor];
    
    if (result) {
        self.actor = actor;
    }
    if (self.isCloseMicro) {
        [self setCloseMicro:self.isCloseMicro];
    }
    
    NSLog(@"这里身份更改为：%@",actor? @"主播": @"观众身份");
    
    return YES;
}



#pragma mark - puble method music
//播放
- (BOOL)startPlayMusicAtIndex:(NSInteger)index {
    
    int state = 1;
    NSString * fileName = self.musicLists[index].musicName;
    
    //        if (fileName.length<=0 && self.musicLists[index].localUri.length>0) {
    //            if (self.currentMusic && self.isPlaying) {
    //                [self stopPlayMusic];
    //            }
    //            return NO;
    //        }
    NSString * documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    documentsPath = [NSString stringWithFormat:@"%@/music/",documentsPath];
    NSString * musicPath = [documentsPath stringByAppendingString:fileName];
    
    
    if (musicPath) {
        if (self.currentMusic && self.isPlaying) {
            [self stopPlayMusic];
        }
        state = [self.engine startAudioMixing:musicPath loopback:NO replace:NO cycle:1];
        self.currentIndex = index;
        self.currentMusic = self.musicLists[self.currentIndex];
        
    }
    
    [self adjustVoiceVol:self.voiceVol];
    [self adjustMusicSoundVol:self.soundVol];
    return !state;
}
//停止播放
- (void)stopPlayMusic{
    [self.engine stopAudioMixing];
}
//暂停
- (BOOL)pausePlayMusic {
    return ![self.engine pauseAudioMixing];
}
//重新播放
- (void)resumePlayMusic {
    [self.engine resumeAudioMixing];
}
//调整音乐声音
- (void)adjustMusicSoundVol:(NSInteger)vol {
    self.soundVol = vol;
    //改变伴奏大小的属性
    [self.engine adjustAudioMixingVolume:vol];

}
//调整人声
- (int)adjustVoiceVol:(NSInteger)vol {
    int result = 1;
    if (vol) {
        result = [self.engine adjustRecordingSignalVolume:vol];
        self.voiceVol = vol;
    }
    return result;
}

#pragma mark - private method

//更新普通房间actor
- (BOOL)updateNormalMeeting:(BOOL)actor{
    BOOL result = NO;
    if (actor) {
        if ([self.engine setClientRole:AgoraClientRoleBroadcaster] == 0) {
            result = YES;
        }
        [self.engine muteLocalAudioStream:NO];
    } else {
        if ([self.engine setClientRole:AgoraClientRoleAudience] == 0) {
            result = YES;
        }
        [self.engine muteLocalAudioStream:YES];
    }
    return result;
}

//加入普通房间
- (void)joinNormalMeeting:(BOOL)actor name:(NSString *)name{
    if (actor) {
        [self.engine setClientRole:AgoraClientRoleBroadcaster];
    }else {
        [self.engine setClientRole:AgoraClientRoleAudience];
    }
    if (GetCore(ImRoomCoreV2).currentRoomInfo.audioQuality == AudioQualityType_High) {
        [self.engine setAudioProfile:AgoraAudioProfileMusicHighQuality scenario:AgoraAudioScenarioChatRoomEntertainment];
        [self.engine setLocalVoiceReverbOfType:AgoraAudioReverbRoomSize withValue:57];
    }else {
        [self.engine setAudioProfile:AgoraAudioProfileMusicStandard scenario:AgoraAudioScenarioChatRoomEntertainment];
    }
    int state = [self.engine joinChannelByToken:nil channelId:name info:nil uid:[[GetCore(AuthCore) getUid] integerValue] joinSuccess:^(NSString * _Nonnull channel, NSUInteger uid, NSInteger elapsed) {
    }];
    if (state != 0) {
        NotifyCoreClient(MeetingCoreClient, @selector(onJoinMeetingFailth), onJoinMeetingFailth);
    }else {
        NotifyCoreClient(MeetingCoreClient, @selector(onJoinMeetingSuccess), onJoinMeetingSuccess);
    }
}
//光圈回调
- (void)onSpeakingUsersReport:(NSArray *)report {
    NSMutableArray *uids = [NSMutableArray array];
    if (report != nil && report.count > 0) {
        for (AgoraRtcAudioVolumeInfo *userInfo in report) {
            NSString *uid = [NSString stringWithFormat:@"%ld",(long)userInfo.uid];
            if (userInfo.volume > 15){
                if (uid.userIDValue == 0) {
                    [uids addObject:@([GetCore(AuthCore) getUid].userIDValue)];
                }else {
                    [uids addObject:@(uid.userIDValue)];
                }
            }
        }
        self.speakingArray = uids;
        NotifyCoreClient(MeetingCoreClient, @selector(onSpeakingUsersReport:), onSpeakingUsersReport:self.speakingArray);
    } else {
        if (self.speakingArray != nil) {
            self.speakingArray = nil;
            NotifyCoreClient(MeetingCoreClient, @selector(onSpeakingUsersReport:), onSpeakingUsersReport:nil);
        }
    }
}

#pragma mark - Getter & Setter

- (void)setIsPlaying:(BOOL)isPlaying {
    _isPlaying = isPlaying;
    NotifyCoreClient(MeetingCoreClient,@selector(onCurrentMusicPlayStatusChange:), onCurrentMusicPlayStatusChange:isPlaying);
}

- (NSInteger)voiceVol{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSInteger value = [userDefaults integerForKey:@"constRoomMusicVoice"];
    return value>0 ? value : 50;
 
}

- (void)setVoiceVol:(NSInteger)voiceVol{
    if (voiceVol>0) {
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        [userDefaults setInteger:voiceVol forKey:@"constRoomMusicVoice"];
        [userDefaults synchronize];
    }
}

- (NSInteger)soundVol{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSInteger value = [userDefaults integerForKey:@"constRoomMusicSound"];
    return value>0 ? value : 50;
}

- (void)setSoundVol:(NSInteger)soundVol{
    if (soundVol>0) {
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        [userDefaults setInteger:soundVol forKey:@"constRoomMusicSound"];
        [userDefaults synchronize];
    }
}
@end
