//
//  MeetingCoreClient.h
//  BberryCore
//
//  Created by chenran on 2017/5/29.
//  Copyright © 2017年 chenran. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol MeetingCoreClient <NSObject>
@optional
- (void)onReserveMeetingSuccess;
- (void)onReserveMeetingFailth;

- (void)onJoinMeetingSuccess;
- (void)onJoinMeetingFailth;

- (void)onLeaveMeetingSuccess;

- (void)onSpeakingUsersReport:(NSMutableArray *)uids;
- (void)onMySpeakingStateUpdate:(BOOL)speaking;

- (void)onMeetingQualityBad;
- (void)onMeetingQualityDown;

- (void)onIntoNewRoomSuccess;


- (void)onUpdateNextMusicName:(NSString *)musicName Artist:(NSString *)artistName;
- (void)onCurrentMusicPlayStatusChange:(BOOL)isPlaying;

//mv播放完
- (void)onVideoPlayComplete;
//收到新的mv
- (void)onReceiveVideoFrom:(NSInteger)uid;

@end
