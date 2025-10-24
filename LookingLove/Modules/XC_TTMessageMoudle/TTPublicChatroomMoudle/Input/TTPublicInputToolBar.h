//
//  TTPublicInputToolBar.h
//  TuTu
//
//  Created by 卫明 on 2018/10/31.
//  Copyright © 2018 YiZhuan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NIMGrowingTextView.h"

NS_ASSUME_NONNULL_BEGIN

typedef enum : NSUInteger {
    TTInputStatusText,
    TTInputStatusEmoticon,
} TTInputStatus;

typedef enum : NSUInteger {
    TTPublicInputBarItemText,
    TTPublicInputBarItemEmoticon,
    TTPublicInputBarItemAt,
} TTPublicInputBarItemType;

@protocol TTPublicInputToolBarDelegate <NSObject>

@optional

- (BOOL)textViewShouldBeginEditing;

- (void)textViewDidEndEditing;

- (BOOL)shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)replacementText;

- (void)textViewDidChange;

- (void)textViewTextDidChange:(NIMGrowingTextView *)textView;

- (void)toolBarWillChangeHeight:(CGFloat)height;

- (void)toolBarDidChangeHeight:(CGFloat)height;

@end


@interface TTPublicInputToolBar : UIView

@property (strong, nonatomic) UIButton          *emoticonBtn;

@property (strong, nonatomic) UIButton          *atButton;

@property (nonatomic,copy) NSString             *contentText;

@property (nonatomic,assign) NSInteger          maxNumberOfInputLines;

@property (nonatomic,weak) id<TTPublicInputToolBarDelegate> delegate;

@property (nonatomic,assign) BOOL               showsKeyboard;

@property (nonatomic, assign) TTInputStatus     status;


- (void)update:(TTInputStatus)status;

@end

@interface TTPublicInputToolBar(InputText)

- (void)setEnable:(BOOL)isEnable;

- (void)setText:(NSString *)text;

- (NSRange)selectedRange;

- (void)setPlaceHolder:(NSString *)placeHolder;

- (void)insertText:(NSString *)text;

- (void)deleteText:(NSRange)range;

@end

NS_ASSUME_NONNULL_END
