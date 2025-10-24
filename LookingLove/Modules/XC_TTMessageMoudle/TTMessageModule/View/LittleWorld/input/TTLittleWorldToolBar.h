//
//  TTLittleWorldToolBar.h
//  XC_TTMessageMoudle
//
//  Created by fengshuo on 2019/7/3.
//  Copyright © 2019 WJHD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NIMGrowingTextView.h"
NS_ASSUME_NONNULL_BEGIN

typedef enum : NSUInteger {
    TTLittleWorldInputStatusText,//文本框
    TTLittleWorldInputStatusEmoticon,//表情
} TTLittleWorldInputStatus;

@protocol TTLittleWorldToolBarDelegate <NSObject>

@optional

- (BOOL)textViewShouldBeginEditing;

- (void)textViewDidEndEditing;

- (BOOL)shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)replacementText;

- (void)textViewDidChange;

- (void)textViewTextDidChange:(NIMGrowingTextView *)textView;

- (void)toolBarWillChangeHeight:(CGFloat)height;

- (void)toolBarDidChangeHeight:(CGFloat)height;

@end


@interface TTLittleWorldToolBar : UIView
/** 表情*/
@property (strong, nonatomic) UIButton          *emoticonBtn;
/** 图片*/
@property (strong, nonatomic) UIButton          *photoButton;
/** 显示的内容*/
@property (nonatomic,copy) NSString             *contentText;
/** 可以输入几行*/
@property (nonatomic,assign) NSInteger          maxNumberOfInputLines;
/** 代理*/
@property (nonatomic,weak) id<TTLittleWorldToolBarDelegate> delegate;
/** 是不是展示键盘*/
@property (nonatomic,assign) BOOL               showsKeyboard;
/** */
@property (nonatomic, assign) TTLittleWorldInputStatus  status;

- (void)update:(TTLittleWorldInputStatus)status;

@end

@interface TTLittleWorldToolBar (InputText)
- (void)setEnable:(BOOL)isEnable;

- (void)setText:(NSString *)text;

- (NSRange)selectedRange;

- (void)setPlaceHolder:(NSString *)placeHolder;

- (void)insertText:(NSString *)text;

- (void)deleteText:(NSRange)range;

@end

NS_ASSUME_NONNULL_END
