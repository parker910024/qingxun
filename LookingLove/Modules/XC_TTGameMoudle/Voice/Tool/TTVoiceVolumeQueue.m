//
//  TTVoiceVolumeQueue.m
//  XC_TTGameMoudle
//
//  Created by fengshuo on 2019/5/31.
//  Copyright © 2019 YiZhuan. All rights reserved.
//

#import "TTVoiceVolumeQueue.h"
#define minVolume 0.05
@interface TTVoiceVolumeQueue ()
@property (nonatomic, strong) NSMutableArray *volumeArray;
/**
 *
 */
@property (nonatomic,strong) NSNumber *num;
@end

@implementation TTVoiceVolumeQueue
- (instancetype)init{
    self = [super init];
    if (self) {
        self.volumeArray = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)pushVolume:(CGFloat)volume{
//    NSLog(@"%@",[NSThread currentThread]);
    if (volume >= minVolume) {
        _num = [NSNumber numberWithFloat:volume];
            [self.volumeArray addObject:_num];
    }
}

- (void)pushVolumeWithArray:(NSArray *)array{
    if (array.count > 0) {
        for (NSInteger i = 0; i < array.count; i++) {
            CGFloat volume = [array[i] floatValue];
            [self pushVolume:volume];
        }
    }
}

- (CGFloat)popVolume{
    CGFloat volume = -10;
    if (self.volumeArray.count > 0) {
        if (_num == nil) {
            
        }else {
            _num = [self.volumeArray firstObject];
            volume = [_num floatValue];
            [self.volumeArray removeObject:_num];
            _num = nil;
        }
        
    }
    return volume;
}

- (void)cleanQueue{
    if (self.volumeArray) {
        [self.volumeArray removeAllObjects];
    }
    self.num = nil;
}

- (NSNumber *)num {
    
    if (!_num) {
        _num = [[NSNumber alloc] init];
    }
    return _num;
}
@end
