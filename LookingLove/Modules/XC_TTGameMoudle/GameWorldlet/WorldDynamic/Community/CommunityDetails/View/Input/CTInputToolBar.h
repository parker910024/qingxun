//
//  CTInputToolBar.h
//  CTKit
//
//  Created by chris.
//  Copyright (c) 2015年 NetEase. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CTGrowingTextView;

typedef NS_ENUM(NSInteger,CTInputStatus)
{
    CTInputStatusText,
    CTInputStatusAudio,
    CTInputStatusEmoticon,
    CTInputStatusMore
};


@protocol CTInputToolBarDelegate <NSObject>

@optional

- (BOOL)textViewShouldBeginEditing;

- (void)textViewDidEndEditing;

- (BOOL)shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)replacementText;

- (void)textViewDidChange;

- (void)toolBarWillChangeHeight:(CGFloat)height;

- (void)toolBarDidChangeHeight:(CGFloat)height;

@end


@interface CTInputToolBar : UIView

@property (nonatomic,strong) UIButton    *voiceButton;

@property (nonatomic,strong) UIButton    *emoticonBtn;

@property (nonatomic,strong) UIButton    *moreMediaBtn;

@property (nonatomic,strong) UIButton    *recordButton;

@property (nonatomic,strong) UIButton    *cpButton;

@property (nonatomic,strong) UIButton    *pictureButton;

@property (nonatomic, strong) UIButton *sendMsgButton;

@property (nonatomic,strong) UIImageView *inputTextBkgImage;

@property (nonatomic,copy) NSString *contentText;

@property (nonatomic,weak) id<CTInputToolBarDelegate> delegate;

@property (nonatomic,assign) BOOL showsKeyboard;

@property (nonatomic,assign) NSArray *inputBarItemTypes;

@property (nonatomic,assign) NSInteger maxNumberOfInputLines;

@property (nonatomic,strong) CTGrowingTextView *inputTextView;


- (void)update:(CTInputStatus)status;

@end

@interface CTInputToolBar(InputText)

- (NSRange)selectedRange;

- (void)setPlaceHolder:(NSString *)placeHolder;

- (void)insertText:(NSString *)text;

- (void)deleteText:(NSRange)range;

@end
