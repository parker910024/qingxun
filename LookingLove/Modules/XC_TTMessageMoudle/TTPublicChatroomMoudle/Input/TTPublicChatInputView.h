//
//  TTPublicChatInputView.h
//  TuTu
//
//  Created by 卫明 on 2018/10/30.
//  Copyright © 2018 YiZhuan. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <NIMSDK/NIMSDK.h>

//cache
#import "NIMInputAtCache.h"

//view
#import "TTPublicInputToolBar.h"
#import "NIMInputEmoticonContainerView.h"

//protocol
#import "NIMInputProtocol.h"


NS_ASSUME_NONNULL_BEGIN

@class NIMInputEmoticonContainerView;

@protocol TTPublicChatInputViewDelegate <NSObject>

@optional

- (void)didChangeInputHeight:(CGFloat)inputHeight;

@end

@interface TTPublicChatInputView : UIView

@property (strong, nonatomic) NIMSession *session;

@property (nonatomic,assign) NSInteger maxTextLength;

@property (strong, nonatomic) TTPublicInputToolBar *toolBar;

@property (strong, nonatomic)  UIView *emojiContainer;

@property (nonatomic,assign) TTInputStatus status;

@property (nonatomic, strong) NIMInputAtCache *atCache;

- (instancetype)initWithFrame:(CGRect)frame;

- (void)reset;

- (void)refreshStatus:(TTInputStatus)status;

- (void)setInputTextPlaceHolder:(NSString*)placeHolder;

- (void)setInputDelegate:(id<TTPublicChatInputViewDelegate>)delegate;

//外部设置
- (void)setInputActionDelegate:(id<NIMInputActionDelegate>)actionDelegate;
//清楚所有输入框的的东西
- (void)cleanMessage;

/**
 增加@人的次数
 */
- (void)addAtTimes;

@end

NS_ASSUME_NONNULL_END
