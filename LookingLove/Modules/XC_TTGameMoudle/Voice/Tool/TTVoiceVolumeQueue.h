//
//  TTVoiceVolumeQueue.h
//  XC_TTGameMoudle
//
//  Created by fengshuo on 2019/5/31.
//  Copyright © 2019 YiZhuan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TTVoiceVolumeQueue : NSObject
- (void)pushVolume:(CGFloat)volume;
- (void)pushVolumeWithArray:(NSArray *)array;
- (CGFloat)popVolume;
- (void)cleanQueue;
@end

NS_ASSUME_NONNULL_END
