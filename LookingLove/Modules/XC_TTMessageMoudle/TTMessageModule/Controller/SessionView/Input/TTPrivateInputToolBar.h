//
//  TTPrivateInputToolBar.h
//  AFNetworking
//
//  Created by apple on 2019/5/28.
//

#import <UIKit/UIKit.h>
#import "NIMGrowingTextView.h"

NS_ASSUME_NONNULL_BEGIN


typedef enum : NSUInteger {
    TTPrivateInputStatusText,
    TTPrivateInputStatusEmoticon,
} TTPrivateInputStatus;

typedef enum : NSUInteger {
    TTPrivateInputBarItemText,
    TTPrivateInputBarItemEmoticon,
} TTPrivateInputBarItemType;

@protocol TTPrivateInputToolBarDelegate <NSObject>

@optional

- (BOOL)textViewShouldBeginEditing;

- (void)textViewDidEndEditing;

- (BOOL)shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)replacementText;

- (void)textViewDidChange;

- (void)textViewTextDidChange:(NIMGrowingTextView *)textView;

- (void)toolBarWillChangeHeight:(CGFloat)height;

- (void)toolBarDidChangeHeight:(CGFloat)height;

@end


@interface TTPrivateInputToolBar : UIView

@property (strong, nonatomic) UIButton          *emoticonBtn;

@property (strong, nonatomic) UIButton          *atButton;

@property (nonatomic,copy) NSString             *contentText;

@property (nonatomic,assign) NSInteger          maxNumberOfInputLines;

@property (nonatomic,weak) id<TTPrivateInputToolBarDelegate> delegate;

@property (nonatomic,assign) BOOL               showsKeyboard;

@property (nonatomic, assign) TTPrivateInputStatus     status;


- (void)update:(TTPrivateInputStatus)status;

@end


@interface TTPrivateInputToolBar(InputText)

- (void)setText:(NSString *)text;

- (NSRange)selectedRange;

- (void)setPlaceHolder:(NSString *)placeHolder;

- (void)insertText:(NSString *)text;

- (void)deleteText:(NSRange)range;

@end

NS_ASSUME_NONNULL_END
