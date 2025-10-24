//
//  MeetingCore.h
//  Bberry
//
//  Created by KevinWang on 2018/8/11.
//  Copyright © 2018年 XC. All rights reserved.
//

#import "BaseCore.h"
#import "ImRoomCoreV2.h"
#import "MusicInfo.h"
#import "RoomInfo.h"
#import <AgoraRtcKit/AgoraRtcEngineKit.h>

@interface MeetingCore : BaseCore

@property(nonatomic, strong, readonly) AgoraRtcEngineKit *engine;

@property(nonatomic, assign) BOOL isCloseMicro;//是否关闭🎤
@property(nonatomic, assign) BOOL actor;//是否主播
@property(nonatomic, assign) BOOL isMute;//是否关闭🎺

@property(nonatomic, assign) BOOL isVoiceOperated;
@property(nonatomic, assign, readwrite)NSInteger voiceVol;//人声大小
@property(nonatomic, assign, readwrite)NSInteger soundVol;//音乐声音大小

//join
- (void)joinMeeting:(NSString *)name actor:(BOOL)actor;//进入房间
- (void)resetMeeting:(NSString *)name actor:(BOOL)actor;//重置音质
- (void)leaveMeeting:(NSString *)name;//离开房间

//control
- (BOOL)setMeetingRole:(BOOL)actor;//设置为主播
- (BOOL)setCloseMicro:(BOOL)close;//关扬声器，不听其他人的声音
- (BOOL)setMute:(BOOL)isMute;//关麦 不能说话


//music
@property(nonatomic, strong)NSMutableArray<MusicInfo *> *musicLists; //music
@property(nonatomic, strong)MusicInfo * currentMusic;
@property(nonatomic, assign)NSInteger currentIndex;
@property(nonatomic, assign) BOOL isPlaying;

- (BOOL)startPlayMusicAtIndex:(NSInteger)index;
- (void)stopPlayMusic;
- (BOOL)pausePlayMusic;
- (void)resumePlayMusic;
- (void)adjustMusicSoundVol:(NSInteger)vol;
- (int)adjustVoiceVol:(NSInteger)vol;

@end



