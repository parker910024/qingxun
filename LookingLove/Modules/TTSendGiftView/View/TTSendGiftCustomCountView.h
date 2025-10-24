//
//  TTSendGiftCustomCountView.h
//  TTSendGiftView
//
//  Created by Macx on 2019/4/24.
//  Copyright © 2019 YiZhuan. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class TTSendGiftCustomCountView;

@protocol TTSendGiftCustomCountViewDelegate <NSObject>
@optional;

/**
 点击了确认按钮
 
 @param countView view
 @param button 确认按钮
 */
- (void)sendGiftCustomCountView:(TTSendGiftCustomCountView *)countView didClickSureButton:(UIButton *)button;
@end

@interface TTSendGiftCustomCountView : UIView
//输入框
@property (nonatomic, strong, readonly) UITextField *editTextFiled;
//发送按钮
@property (nonatomic, strong, readonly) UIButton *sendButton;

/** delegate */
@property (nonatomic, weak) id<TTSendGiftCustomCountViewDelegate> delegate;
@end

NS_ASSUME_NONNULL_END
