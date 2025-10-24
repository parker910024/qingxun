//
//  VKRecordButton.h
//  UKiss
//
//  Created by apple on 2019/3/12.
//  Copyright © 2019 yizhuan. All rights reserved.
//  录制按钮

#import <UIKit/UIKit.h>
@class VKRecordButton;

typedef NS_ENUM(NSInteger, VKRecordViewStatus) {
    VKRecordViewStatusEmpty = 1,              //还没开始录制
    VKRecordViewStatusRecording,              //正在录制
    VKRecordViewStatusCompleteRecorded,       //录制完成
    VKRecordViewStatusPlaying                 //正在播放
};

@protocol VKRecordButtonDelegate <NSObject>
//点击录制按钮回调
- (void)didClickRecordButton:(VKRecordButton *)recordButton changeRecordStatusCallBack:(VKRecordViewStatus)status;
@end


@interface VKRecordButton : UIView
///录音状态
@property (nonatomic, assign) VKRecordViewStatus status;
//进度
@property (nonatomic, assign) CGFloat progress;
///是否是声音录制样式
@property (nonatomic, assign) BOOL isDrawerStyle;

@property (nonatomic, weak) id<VKRecordButtonDelegate> delegate;

@end
