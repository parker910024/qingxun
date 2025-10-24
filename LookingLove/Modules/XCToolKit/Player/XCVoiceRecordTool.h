//
//  TTVoiceRecordTool.h
//  XC_TTGameMoudle
//
//  Created by fengshuo on 2019/5/31.
//  Copyright © 2019 YiZhuan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
NS_ASSUME_NONNULL_BEGIN

@class XCVoiceRecordTool;
@protocol TTVoiceRecordToolDelegate <NSObject>

@optional
-(void)recordTool:(XCVoiceRecordTool *)recordTool didStartRecoring:(CGFloat)value;
-(void)recordTool:(XCVoiceRecordTool *)recordTool didFinishedPlayer:(AVAudioPlayer *)player;

@end


@interface XCVoiceRecordTool : NSObject
/** 录音工具的单例 */
+ (instancetype)sharedRecordTool;

/** 开始录音 */
- (void)startRecording;
/** 暂停录音 */
- (void)pauseRecording;
/** 继续录音 */
- (void)resumeRecording;
/** 停止录音 */
- (void)stopRecording;
/** 销毁录音文件 */
- (void)destructionRecordingFile;

/** 播放录音文件 */
- (void)playRecordingFile;
/** 播放录音文件 */
- (void)startPlaying;
/** 暂停播放录音文件 */
- (void)pausePlaying;
/** 停止播放录音文件 */
- (void)stopPlaying;

/** 销毁合成文件 */
- (void)destructionDestinationFile;
/** 销毁定时器对象 */
- (void)invalidateTimer;
// 暂停定时器
-(void)pauseTimer;
//复位定时器
-(void)resumeTimer;
/** 录音的caf转换为mp3*/
- (void)playAudioWithCafToMP3OfURL;
/** 录音对象 */
@property (nonatomic, strong) AVAudioRecorder *recorder;

/** 播放器对象 */
@property (nonatomic, strong) AVAudioPlayer *player;

/** 更新音量参数的代理 */
@property (nonatomic, weak) id<TTVoiceRecordToolDelegate> delegate;

/** 是不是一需要一个新的播放器*/
@property (nonatomic,assign) BOOL isNewPlayer;

/** 录音文件转换为mp3后文件地址 */
@property (nonatomic, strong) NSURL *playerFileUrl;
@end

NS_ASSUME_NONNULL_END
