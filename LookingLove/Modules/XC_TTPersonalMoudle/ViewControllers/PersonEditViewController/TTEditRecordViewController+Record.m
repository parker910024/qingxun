//
//  TTEditRecordViewController+Record.m
//  TuTu
//
//  Created by Macx on 2018/11/8.
//  Copyright © 2018年 YiZhuan. All rights reserved.
//

#import "TTEditRecordViewController+Record.h"
#import "MediaCore.h"
#import "CoreManager.h"

@implementation TTEditRecordViewController (Record)




#pragma mark - MediaCoreClient
- (void)onPlayAudioComplete:(NSString *)filePath {
    if ([filePath isEqualToString:self.filePath]) {
        self.playOrPauseBtn.selected = NO;
    }
}

- (void)onRecordAudioBegan:(NSString *)filePath
{
    if (filePath.length > 0) {
        self.filePath = filePath;
        self.recordTimeLabel.text = @"00:00";
    }
}

- (void)onRecordAudioCancel
{
    self.recordTimeLabel.text = @"00:00";
}

- (void)onRecordAudioComplete:(NSString *)filePath
{
    if ([filePath isEqualToString:self.filePath]) {
    }
}

- (void)onRecordAudioProgress:(NSTimeInterval)currentTime
{
    NSInteger t = (NSInteger) currentTime;
    NSString *time = @"";
    if (currentTime >= 10) {
        time = @"00:10";
    } else {
        time = [NSString stringWithFormat:@"00:0%ld", t];
    }
    self.secondTime = t;
    self.recordTimeLabel.text = time;
}

@end
