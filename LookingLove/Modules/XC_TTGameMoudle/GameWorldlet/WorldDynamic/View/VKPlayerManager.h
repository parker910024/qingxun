//
//  VKPlayerManager.h
//  UKiss
//
//  Created by apple on 2019/1/8.
//  Copyright © 2019 yizhuan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>


@interface VKPlayerManager : NSObject

///播放器
@property (nonatomic, strong) AVAudioPlayer *player;
//录音
@property (nonatomic,strong) AVAudioRecorder *audioRecorder;
/** 录音文件地址 */
@property (nonatomic, copy) NSString *recordFilePath;
///播放音量大小
@property (nonatomic, assign) CGFloat volume;

+ (instancetype)shareInstance ;

/**
 循环播放音频
 
 @param filePath 本地路径
 @param volume 音量大小
 */
- (void)playerMusicWithPath:(NSString *)filePath volume:(CGFloat)volume;


/**
 播放一次音频
 
 @param filePath 本地路径
 @param completionBlock 播放完成回调
 */
- (void)playerVoiceWithPath:(NSString *)filePath completionBlock:(void (^)(void))completionBlock;

/**
 录音
 */
- (void)startRecording;

/**
 停止录音
 */
- (void)stopRecording;


/**
 停止音乐
 */
- (void)stopMusic;

/**
 停止音乐  是否需要执行完成回调（更新UI）
 */
- (void)stopMusicIsNeedCompletion:(BOOL)isNeedCompletion;



@end

