//
//  TTPrivateChatInputView.h
//  AFNetworking
//
//  Created by apple on 2019/5/28.
//

#import <UIKit/UIKit.h>

#import <NIMSDK/NIMSDK.h>

//cache
#import "NIMInputAtCache.h"

//view
#import "TTPrivateInputToolBar.h"

#import "NIMInputEmoticonContainerView.h"

//protocol
#import "NIMInputProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@class NIMInputEmoticonContainerView;

@protocol TTPrivateChatInputViewDelegate <NSObject>

@optional

- (void)didChangeInputHeight:(CGFloat)inputHeight;

@end

@interface TTPrivateChatInputView : UIView

@property (strong, nonatomic) NIMSession *session;

@property (nonatomic,assign) NSInteger maxTextLength;

@property (strong, nonatomic) TTPrivateInputToolBar *toolBar;

@property (strong, nonatomic)  UIView *emojiContainer;

@property (nonatomic,assign) TTPrivateInputStatus status;

@property (nonatomic, strong) NIMInputAtCache *atCache;

- (instancetype)initWithFrame:(CGRect)frame;

- (void)reset;

- (void)refreshStatus:(TTPrivateInputStatus)status;

- (void)setInputTextPlaceHolder:(NSString*)placeHolder;

- (void)setInputDelegate:(id<TTPrivateChatInputViewDelegate>)delegate;

//外部设置
- (void)setInputActionDelegate:(id<NIMInputActionDelegate>)actionDelegate;
//清楚所有输入框的的东西
- (void)cleanMessage;


@end

NS_ASSUME_NONNULL_END
