//
//  TTMp4PlayerTool.h
//  CeEr
//
//  Created by jiangfuyuan on 2021/7/29.
//  Copyright © 2021 WUJIE INTERACTIVE. All rights reserved.
//

#import "BaseObject.h"
#import "GiftInfo.h"
#import "GiftAllMicroSendInfo.h"
NS_ASSUME_NONNULL_BEGIN

@interface TTMp4PlayerTool : BaseObject

+ (instancetype)defaultPlayerTool;

#pragma mark -- 播放单个 MP4的 操作。不需要做预加载，如气氛灯背景
/// 开始播放单个mp4
/// @param view 播放MP4的View
/// @param count 播放循环次数
/// @param urlString 播放链接
- (void)playMp4WithView:(UIView *)view withCount:(NSInteger)count andUrlString:(NSString *)urlString;

#pragma mark -- 需要预加载的MP4, 目前只有礼物，后续有新的类型，需要拓展
@property (nonatomic, strong) GiftInfo *info; // 需要下载的链接
/// 开始播放礼物mp4
/// @param view 播放MP4的View
/// @param count 播放循环次数
/// @param info 播放model
- (void)playGiftMp4WithView:(UIView *)view withCount:(NSInteger)count andGiftInfo:(GiftAllMicroSendInfo *)info;
/*------------       华丽的分割线     -----------------*/

/// 停止播放MP4
/// @param view 停止播放MP4的View
- (void)stopMp4WithView:(UIView *)view;

@end

NS_ASSUME_NONNULL_END
