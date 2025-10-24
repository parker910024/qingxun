//
//  XCPlayerTool.h
//  XCToolKit
//
//  Created by Macx on 2019/6/13.
//  Copyright © 2019 YiZhuan. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@class XCPlayerTool;

@protocol XCPlayerToolDelegate<NSObject>
@optional
/** 播放完成 */
- (void)playerToolDidFinish:(XCPlayerTool *)playerTool;
/**
 播放进度的回调
 
 @param playerTool tool
 @param duration 总时间
 @param time 当前播放的时间
 */
- (void)playerTool:(XCPlayerTool *)playerTool duration:(NSInteger)duration time:(NSInteger)time;
@end

@interface XCPlayerTool : NSObject
@property (nonatomic, weak) id<XCPlayerToolDelegate> delegate;
@property (nonatomic, assign) BOOL isPlaying;
@property (nonatomic, assign) BOOL isPauseing;
/** 播放的地址 */
@property (nonatomic, strong, readonly) NSString *filePath;

/** 播放器的单例 */
+ (instancetype)sharedPlayerTool;

/** 开始播放*/
- (void)startPlay:(NSString *)filePath;

/** 暂停*/
- (void)pause;
/** 重新播放*/
- (void)resume;
/** 停止*/
- (void)stop;
/** 从零开始重新播放 */
- (void)rePlay;
@end

NS_ASSUME_NONNULL_END
