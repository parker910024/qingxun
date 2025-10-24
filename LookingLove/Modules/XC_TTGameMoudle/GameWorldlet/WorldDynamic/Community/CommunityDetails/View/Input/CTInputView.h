//
//  CTInputView.h
//  CTKit
//
//  Created by chris.
//  Copyright (c) 2015年 NetEase. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NIMInputProtocol.h"
#import "NIMSessionConfig.h"
#import "CTInputToolBar.h"
#import "CTInputAtCache.h"

@class CTInputMoreContainerView;
@class CTInputEmoticonContainerView;



typedef NS_ENUM(NSInteger, CTAudioRecordPhase) {
    CTAudioRecordPhaseStart,
    CTAudioRecordPhaseRecording,
    CTAudioRecordPhaseCancelling,
    CTAudioRecordPhaseEnd
};



@protocol CTInputDelegate <NSObject>

@optional

- (void)didChangeInputHeight:(CGFloat)inputHeight;

- (void)onTouchPictureButtonBtn:(id)sender;

- (void)onTouchCpButtonBtn:(id)sender;

@end

@interface CTInputView : UIView

@property (nonatomic, strong) NIMSession             *session;

@property (nonatomic, assign) NSInteger              maxTextLength;

@property (nonatomic, strong) UIView                 *muteView;

@property (nonatomic, strong) UILabel                *muteLabel;

@property (assign, nonatomic, getter=isRecording)    BOOL recording;

@property (strong, nonatomic)  CTInputToolBar *toolBar;
@property (strong, nonatomic)  UIView *moreContainer;
@property (strong, nonatomic)  UIView *emoticonContainer;

@property (nonatomic, assign) CTInputStatus status;
@property (nonatomic, strong) CTInputAtCache *atCache;
//提示文本
@property (nonatomic, copy) NSString *inputPlaceholder;

- (instancetype)initWithFrame:(CGRect)frame
                       config:(id<NIMSessionConfig>)config;

- (void)mute:(BOOL)isMute;

- (void)reset;

- (void)refreshStatus:(CTInputStatus)status;

- (void)setInputDelegate:(id<CTInputDelegate>)delegate;

//外部设置
- (void)setInputActionDelegate:(id<NIMInputActionDelegate>)actionDelegate;

- (void)setInputTextPlaceHolder:(NSString*)placeHolder;
- (void)updateAudioRecordTime:(NSTimeInterval)time;
- (void)updateVoicePower:(float)power;

@end
