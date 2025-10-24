//
//  TTVoiceRecordTool.m
//  XC_TTGameMoudle
//
//  Created by fengshuo on 2019/5/31.
//  Copyright © 2019 YiZhuan. All rights reserved.
//

#import "XCVoiceRecordTool.h"
#import "lame.h"
#define RecordFielName @"record.caf"
#define MP3FielName @"play.mp3"

@interface XCVoiceRecordTool ()<AVAudioRecorderDelegate, AVAudioPlayerDelegate>
/** 录音文件地址 */
@property (nonatomic, strong) NSURL *recordFileUrl;
/** 定时器 */
@property (nonatomic, strong) NSTimer *updateVolumeTimer;

@property (nonatomic, strong) AVAudioSession *session;
@end

@implementation XCVoiceRecordTool

static id instance;
+ (instancetype)sharedRecordTool {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (instance == nil) {
            instance = [[XCVoiceRecordTool alloc] init];
        }
    });
    return instance;
}

#pragma mark - AVAudioRecorderDelegate
-(void)audioRecorderDidFinishRecording:(AVAudioRecorder *)recorder successfully:(BOOL)flag{
    if (flag) {
        [self.session setActive:NO error:nil];
    }
}

#pragma mark-  AVAudioPlayerDelegate
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag{
    if (flag) {
        /******播放成功，暂停定时器******/
        self.isNewPlayer = YES;
        [self pauseTimer];
        if ([_delegate respondsToSelector:@selector(recordTool:didFinishedPlayer:)]) {
            [_delegate recordTool:self didFinishedPlayer:player];
        }
    }
}

#pragma mark - puble method
/** 开始录音 */
- (void)startRecording {
    /*******录音时停止播放 删除曾经生成的文件*********/
    [self stopPlaying];
    [self destructionRecordingFile];
    
   
    /*******真机环境下需要的代码*********/
    NSError *sessionError;
    [self.session setCategory:AVAudioSessionCategoryPlayAndRecord error:&sessionError];
    if(self.session == nil){
        NSLog(@"Error creating session: %@", [sessionError description]);
    }else{
        [self.session setActive:YES error:nil];
    }
    if (![self.recorder record]) {
        [self.recorder deleteRecording];
    }
    [self.recorder record];
    /*******定时器开始*********/
    [self resumeTimer];
}

/** 暂停录音 */
- (void)pauseRecording{
    /*****暂停录音******/
    [self.recorder pause];
    /*****暂停计时器******/
    [self pauseTimer];
}

/** 继续录音 */
- (void)resumeRecording{
    [self.recorder record];
    [self resumeTimer];
}

/** 停止录音 */
- (void)stopRecording {
    /*****停止录音******/
    [self.recorder stop];
    /*****暂停计时器******/
    [self pauseTimer];
}


/** 播放录音文件 */
- (void)playRecordingFile {
    //*********** 播放时停止录音 ***********
    [self.recorder stop];
    //*********** 正在播放就返回 ***********
    if ([self.player isPlaying]) return;
    
    /*****复位定时器******/
    [self resumeTimer];
    /*****播放录音******/
    self.player = [[AVAudioPlayer alloc] initWithContentsOfURL:self.recordFileUrl error:NULL];
    self.player.delegate = self;
    self.player.enableRate = YES;
    [self.session setActive:YES error:nil];
    [self.session setCategory:AVAudioSessionCategoryPlayback error:nil];
    [self.player prepareToPlay];
    [self.player play];
    self.isNewPlayer = NO;
}

/** 播放录音文件 */
- (void)startPlaying {
    [self resumeTimer];
    [self.player play];
}
/** 停止播放录音文件 */
- (void)stopPlaying {
    [self.player stop];
}
/** 暂停播放录音文件 */
- (void)pausePlaying {
    [self.player pause];
}
/** 销毁录音 */
-(void)destructionRecordingFile {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (self.recordFileUrl) {
        [fileManager removeItemAtURL:self.recordFileUrl error:NULL];
    }
}
/** 销毁定时器对象 */
-(void)invalidateTimer{
    [self.updateVolumeTimer invalidate];
    self.updateVolumeTimer = nil;
}

/** 销毁合成文件 */
- (void)destructionDestinationFile{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (self.playerFileUrl) {
        [fileManager removeItemAtURL:self.playerFileUrl error:NULL];
    }
}

/**删除录音文件*/
-(void)deleteVoicRecord:(NSString * )pathName {
    NSFileManager* fileManager=[NSFileManager defaultManager];
    if([fileManager removeItemAtPath:pathName error:nil]){
        NSLog(@"删除");
    }
}

/** caf转换mp3*/
- (void)playAudioWithCafToMP3OfURL{
    
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *mp3FileName = [path stringByAppendingPathComponent:MP3FielName];
    
    [self deleteVoicRecord:mp3FileName];
    /**开始转换*/
    @try {
        int read, write;
        
        FILE *pcm = fopen ([self.recordFileUrl.relativePath cStringUsingEncoding:1 ], "rb" );  //source 被 转换的音频文件位置
        
        if (pcm == NULL ){
            NSLog ( @"file not found" );
        }else{
            
            //skip file header
            fseek (pcm, 4 * 1024 , SEEK_CUR );
            FILE *mp3 = fopen ([mp3FileName cStringUsingEncoding : 1 ], "wb" );  //output 输出生成的 Mp3 文件位置
            const int PCM_SIZE = 8192 ;
            const int MP3_SIZE = 8192 ;
            short int pcm_buffer[PCM_SIZE* 2 ];
            unsigned char mp3_buffer[MP3_SIZE];
            
            lame_t lame = lame_init ();
            lame_set_num_channels (lame, 2 ); // 设置 1 为单通道，默认为 2 双通道
            lame_set_in_samplerate (lame, 8000.0); //采样率
//            lame_set_VBR(lame, vbr_default);
            lame_set_brate(lame, 16);
            lame_set_mode(lame, 3);
            lame_set_quality (lame, 2 ); /* 2=high 5 = medium 7=low 音 质 */
            lame_init_params (lame);
            
            do {
                
                read = fread (pcm_buffer, 2 * sizeof ( short int ), PCM_SIZE, pcm);
                
                if (read == 0 )
                    write = lame_encode_flush (lame, mp3_buffer, MP3_SIZE);
                else
                    write = lame_encode_buffer_interleaved (lame, pcm_buffer, read, mp3_buffer, MP3_SIZE);
                fwrite (mp3_buffer, write, 1 , mp3);
            } while (read != 0 );
            
            lame_close (lame);
            fclose (mp3);
            fclose (pcm);
        }
    }
    
    @catch (NSException *exception) {
        NSLog ( @"%@" ,[exception description ]);
    }
    
    @finally {
        NSLog(@"-----转换MP3成功！！！");
        self.playerFileUrl = [NSURL fileURLWithPath:mp3FileName];
    }
}

#pragma mark - private method
//更新volume
- (void)updateVolume {
    [self.recorder updateMeters];
    //x的y次幂
    CGFloat normalizedValue = pow (10, [self.recorder averagePowerForChannel:0] / 20);
    
    if ([_delegate respondsToSelector:@selector(recordTool:didStartRecoring:)]) {
        [_delegate recordTool:self didStartRecoring:normalizedValue];
    }
}

// 暂停定时器
-(void)pauseTimer{
    if (!self.updateVolumeTimer.isValid) {
        return;
    }
    
    [self.updateVolumeTimer setFireDate:[NSDate distantFuture]];
}

//复位定时器
-(void)resumeTimer{
    if (!self.updateVolumeTimer.isValid) {
        return;
    }
    [self.updateVolumeTimer setFireDate:[NSDate dateWithTimeIntervalSinceNow:0]];
}


#pragma mark-  getter
-(AVAudioSession *)session{
    if (!_session) {
        _session = [AVAudioSession sharedInstance];
    }
    return _session;
}

-(NSTimer *)updateVolumeTimer{
    if (!_updateVolumeTimer) {
        _updateVolumeTimer = [NSTimer timerWithTimeInterval:0.1 target:self selector:@selector(updateVolume) userInfo:nil repeats:YES];
        [[NSRunLoop mainRunLoop] addTimer:_updateVolumeTimer forMode:NSRunLoopCommonModes];
        [_updateVolumeTimer fire];
    }
    return _updateVolumeTimer;
}


- (AVAudioRecorder *)recorder {
    if (!_recorder) {
        //***********获取沙盒地址***********
        NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
        NSString *filePath = [path stringByAppendingPathComponent:RecordFielName];
        _recordFileUrl = [NSURL fileURLWithPath:filePath];
        //********设置录音的一些参数*********
        NSMutableDictionary *setting = [NSMutableDictionary dictionary];
        //***********音频格式***********
        setting[AVFormatIDKey] = @(kAudioFormatLinearPCM);
        //*****录音采样率(Hz) 如：AVSampleRateKey==8000/44100/96000（影响音频的质量）****
        setting[AVSampleRateKey] = @(8000.f);
        //***********音频通道数 1 或 2(只有单通道才能转换为mp3)***********
        setting[AVNumberOfChannelsKey] = @(2);
        //***********线性音频的位深度  8、16、24、32***********
        setting[AVEncoderBitRateKey] = @(16);
        //***********录音的质量***********
        setting[AVEncoderAudioQualityKey] = [NSNumber numberWithInt:AVAudioQualityHigh];
        
        _recorder = [[AVAudioRecorder alloc] initWithURL:self.recordFileUrl settings:setting error:NULL];
        _recorder.delegate = self;
        _recorder.meteringEnabled = YES;
        
        [_recorder prepareToRecord];
    }
    return _recorder;
}


@end
