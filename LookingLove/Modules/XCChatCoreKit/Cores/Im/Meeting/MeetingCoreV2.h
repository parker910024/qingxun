////
////  MeetingCoreV2.h
////  BberryCore
////
////  Created by KevinWang on 2018/6/28.
////  Copyright © 2018年 chenran. All rights reserved.
////
//
//
//#import "BaseCore.h"
//
//#import "ImRoomCoreV2.h"
//#import "MusicInfo.h"
//#import "RoomInfo.h"
//#import <ZegoAudioRoom/ZegoAudioRoom.h>
//
//@interface MeetingCoreV2 : BaseCore
//
//@property (nonatomic, strong, readonly) ZegoAudioRoomApi *engine;
//@property(nonatomic, assign) BOOL isCloseMicro;//是否关闭🎤
//@property(nonatomic, assign) BOOL actor;//是否主播
//@property(nonatomic, assign) BOOL isMute;//是否关闭🎺
//
//@property(nonatomic, assign) BOOL isPlaying;
//@property(nonatomic, assign) BOOL isVoiceOperated;
//@property(nonatomic, strong)NSMutableArray<MusicInfo *> *musicLists; //music
//@property(nonatomic, assign)NSInteger currentIndex;
//@property(nonatomic, assign)NSInteger voiceVol;//音量大小
//@property(nonatomic, assign)NSInteger soundVol;//music音量大小
//@property(nonatomic, strong)MusicInfo * currentMusic;
//
//- (void)joinMeeting:(NSString *)roomId actor:(BOOL)actor;//进入房间
//- (void)resetMeeting:(NSString *)roomId actor:(BOOL)actor;//重置音质
//- (void)leaveMeeting:(NSString *)roomId;//离开房间
//
//
//- (BOOL)startPlayMusicAtIndex:(NSInteger)index;
//- (void)stopPlayMusic;
//- (BOOL)pausePlayMusic;
//- (void)resumePlayMusic;
//- (void)adjustMusicSoundVol:(NSInteger)vol;
//- (int)adjustVoiceVol:(NSInteger)vol;
//
//
//- (BOOL)setMeetingRole:(BOOL)actor;//设置为主播
//- (BOOL)setCloseMicro:(BOOL)close;//关扬声器，不听其他人的声音
//- (BOOL)setMute:(BOOL)isMute;//关麦 不能说话
//
//@end
