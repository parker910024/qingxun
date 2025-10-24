//
//  TTLittleWorldInputView.h
//  XC_TTMessageMoudle
//
//  Created by fengshuo on 2019/7/3.
//  Copyright © 2019 WJHD. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <NIMSDK/NIMSDK.h>
//view
#import "TTLittleWorldToolBar.h"
#import "NIMInputEmoticonContainerView.h"

//protocol
#import "NIMInputProtocol.h"
#import "NIMInputAtCache.h"

NS_ASSUME_NONNULL_BEGIN
@protocol TTLittleWorldInputViewDelegate <NSObject>

@optional

- (void)didChangeInputHeight:(CGFloat)inputHeight;

- (void)didClickInputViewPhoto;

@end


@interface TTLittleWorldInputView : UIView
@property (strong, nonatomic) NIMSession *session;

@property (nonatomic,assign) NSInteger maxTextLength;

@property (strong, nonatomic) TTLittleWorldToolBar *toolBar;

@property (strong, nonatomic)  UIView *emojiContainer;

@property (nonatomic,assign) TTLittleWorldInputStatus status;

@property (nonatomic, strong) NIMInputAtCache *atCache;


- (instancetype)initWithFrame:(CGRect)frame;

- (void)reset;

- (void)refreshStatus:(TTLittleWorldInputStatus)status;

- (void)setInputTextPlaceHolder:(NSString*)placeHolder;

- (void)setInputDelegate:(id<TTLittleWorldInputViewDelegate>)delegate;

//外部设置
- (void)setInputActionDelegate:(id<NIMInputActionDelegate>)actionDelegate;
//清楚所有输入框的的东西
- (void)cleanMessage;
@end

NS_ASSUME_NONNULL_END
