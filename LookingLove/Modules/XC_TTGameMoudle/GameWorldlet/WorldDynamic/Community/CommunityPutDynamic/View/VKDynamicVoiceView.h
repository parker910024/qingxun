//
//  VKDynamicVoiceView.h
//  UKiss
//
//  Created by apple on 2019/2/20.
//  Copyright © 2019 yizhuan. All rights reserved.
//  声音气泡

#import <UIKit/UIKit.h>

@protocol VKDynamicVoiceViewDelegate <NSObject>
///点击声音气泡
- (void)tapVoiceImageActionWithIsPlaying:(BOOL)isPlaying;
@optional
///删除
- (void)deleteVoice;
@end

@interface VKDynamicVoiceView : UIView

@property (nonatomic, weak) id<VKDynamicVoiceViewDelegate> delegate;
///是否正在播放
@property (nonatomic, assign) BOOL isPlaying;
///音频时长
@property (nonatomic, assign) CGFloat duration;
///是否是动态列表
@property (nonatomic, assign) BOOL isDynamicList;
/////是否是pia戏评论声音
//@property (nonatomic, assign) BOOL isPiaComment;

@end
