//
//  MediaCoreClient.h
//  BberryCore
//
//  Created by chenran on 2017/5/24.
//  Copyright © 2017年 chenran. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol MediaCoreClient <NSObject>
@optional
- (void) onRecordAudioBegan:(NSString*)filePath;
- (void) onRecordAudioComplete:(NSString*)filePath;
- (void) onRecordAudioProgress:(NSTimeInterval)currentTime;
- (void) onRecordAudioCancel;

- (void) onPlayAudioBegan:(NSString *)filePath;
- (void) onPlayAudioComplete:(NSString *)filePath;
@end
