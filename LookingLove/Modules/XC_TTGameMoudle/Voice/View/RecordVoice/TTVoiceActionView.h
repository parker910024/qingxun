//
//  TTVoiceActionView.h
//  XC_TTGameMoudle
//
//  Created by fengshuo on 2019/5/31.
//  Copyright © 2019 YiZhuan. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef enum : NSUInteger {
    HandleActionRecordState_Prepare = 1,//录音前的准备
    HandleActionRecordState_Record = 2,//开始录音
    HandleActionRecordState_Finshed = 3,//录音结束
} HandleActionRecordState;

@class TTVoiceActionView;

@protocol TTVoiceActionViewDelegate <NSObject>

/** 点击了重录*/
- (void)ttVoiceActionView:(TTVoiceActionView *)view didClickRestart:(UIButton *)sender;

/** 点击了完成*/
- (void)ttVoiceActionView:(TTVoiceActionView *)view didClickComplete:(UIButton *)sender;

/** 点击了试听*/
- (void)ttVoiceActionView:(TTVoiceActionView *)view didClickAudition:(UIButton *)sender;
@end


@interface TTVoiceActionView : UIView
/** 试听*/
@property (nonatomic, strong) UIButton * auditionButton;
/** 试听显示的内容*/
@property (nonatomic, strong) UILabel * auditionLabel;
/** 当前的状态*/
@property (nonatomic,assign) HandleActionRecordState recordState;

@property (nonatomic,assign) id<TTVoiceActionViewDelegate> delegate;
/** 更新进度*/
- (void)updateProgress:(NSUInteger)progress;
@end

NS_ASSUME_NONNULL_END
