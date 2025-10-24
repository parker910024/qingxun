//
//  MediaCore.h
//  BberryCore
//
//  Created by chenran on 2017/5/24.
//  Copyright © 2017年 chenran. All rights reserved.
//

#import "BaseCore.h"

@interface MediaCore : BaseCore
- (void) record;
- (void) cancelRecord;
- (void) stopRecord;
- (BOOL) isRecording;

- (void) play:(NSString *)filePath;
- (void) stopPlay;
- (BOOL) isPlaying;
@end
