//
//  TTPrivateInputToolBar.m
//  AFNetworking
//
//  Created by apple on 2019/5/28.
//

#import "TTPrivateInputToolBar.h"

//NIM
#import "UIView+NIM.h"

//tool
#import <Masonry/Masonry.h>

@interface TTPrivateInputToolBar ()
<
NIMGrowingTextViewDelegate
>

@property (nonatomic,copy)  NSArray<NSNumber *> *types;

@property (nonatomic,copy)  NSDictionary *dict;

@property (nonatomic,strong) NIMGrowingTextView *inputtTextField;

@end

@implementation TTPrivateInputToolBar

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initView];
        [self initConstrations];
    }
    return self;
}

- (void)initView {
    self.backgroundColor = [UIColor whiteColor];
    _inputtTextField = [[NIMGrowingTextView alloc] initWithFrame:CGRectZero];
    _inputtTextField.font = [UIFont systemFontOfSize:14.0f];
    _inputtTextField.maxNumberOfLines = _maxNumberOfInputLines?:4;
    _inputtTextField.minNumberOfLines = 1;
    _inputtTextField.textColor = [UIColor blackColor];
    _inputtTextField.backgroundColor = [UIColor clearColor];
    _inputtTextField.nim_size = [_inputtTextField intrinsicContentSize];
    _inputtTextField.textViewDelegate = self;
    _inputtTextField.returnKeyType = UIReturnKeySend;
    _inputtTextField.showsVerticalScrollIndicator = NO;
    _inputtTextField.showsHorizontalScrollIndicator = NO;
    [self addSubview:self.inputtTextField];
    [self addSubview:self.atButton];
    [self addSubview:self.emoticonBtn];
}

- (void)initConstrations {
    [self.atButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.width.mas_equalTo(22);
        make.trailing.mas_equalTo(self.mas_trailing).offset(-15);
        make.centerY.mas_equalTo(self.mas_centerY);
    }];
    [self.emoticonBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.width.mas_equalTo(22);
        make.trailing.mas_equalTo(self.atButton.mas_leading).offset(-10);
        make.centerY.mas_equalTo(self.mas_centerY);
    }];
    [self.inputtTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.mas_leading).offset(15);
        make.trailing.mas_equalTo(self.emoticonBtn.mas_leading).offset(-15);
        make.height.mas_equalTo(35);
        make.centerY.mas_equalTo(self.mas_centerY);
    }];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
}

- (CGSize)sizeThatFits:(CGSize)size {
    CGFloat height = 0;
    //算出 TextView 的宽度
    [self adjustTextFiledWidth:size.width];
    // TextView 自适应高度
    [self.inputtTextField layoutIfNeeded];
    
    height = (int)self.inputtTextField.frame.size.height;
    //得到 ToolBar 自身高度
    height = height + 2 * self.spacing + 2 * self.textViewPadding;
    
    return CGSizeMake(size.width,height);
}

- (void)adjustTextFiledWidth:(CGFloat)width {
    CGFloat textWidth = 0;
    
}

#pragma mark - NIMGrowingTextViewDelegate

- (BOOL)shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)replacementText {
    BOOL should = YES;
    if ([self.delegate respondsToSelector:@selector(shouldChangeTextInRange:replacementText:)]) {
        should = [self.delegate shouldChangeTextInRange:range replacementText:replacementText];
    }
    return should;
}


- (BOOL)textViewShouldBeginEditing:(NIMGrowingTextView *)growingTextView {
    BOOL should = YES;
    if ([self.delegate respondsToSelector:@selector(textViewShouldBeginEditing)]) {
        should = [self.delegate textViewShouldBeginEditing];
    }
    return should;
}

- (void)textViewDidEndEditing:(NIMGrowingTextView *)growingTextView {
    if ([self.delegate respondsToSelector:@selector(textViewDidEndEditing)]) {
        [self.delegate textViewDidEndEditing];
    }
}


- (void)textViewDidChange:(NIMGrowingTextView *)growingTextView {
    if ([self.delegate respondsToSelector:@selector(textViewDidChange)]) {
        [self.delegate textViewDidChange];
    }
    if ([self.delegate respondsToSelector:@selector(textViewTextDidChange:)]) {
        [self.delegate textViewTextDidChange:self.inputtTextField];
    }
}

- (void)willChangeHeight:(CGFloat)height {
    CGFloat toolBarHeight = height + 2 * self.spacing;
    if ([self.delegate respondsToSelector:@selector(toolBarWillChangeHeight:)]) {
        [self.delegate toolBarWillChangeHeight:toolBarHeight];
    }
}

- (void)didChangeHeight:(CGFloat)height {
    self.nim_height = height + 2 * self.spacing + 2 * self.textViewPadding;
    if ([self.delegate respondsToSelector:@selector(toolBarDidChangeHeight:)]) {
        [self.delegate toolBarDidChangeHeight:self.nim_height];
    }
}

#pragma mark - private method

- (void)update:(TTPrivateInputStatus)status {
    self.status = status;
    [self sizeToFit];
    
    [self.inputtTextField setHidden:NO];
}

#pragma mark - setter & getter

- (BOOL)showsKeyboard {
    return [self.inputtTextField isFirstResponder];
}


- (void)setShowsKeyboard:(BOOL)showsKeyboard {
    if (showsKeyboard) {
        [self.inputtTextField becomeFirstResponder];
    }
    else {
        [self.inputtTextField resignFirstResponder];
    }
}

- (UIButton *)atButton {
    if (!_atButton) {
        _atButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_atButton setImage:[UIImage imageNamed:@"message_public_chat_at_btn_normal"] forState:UIControlStateNormal];
        [_atButton setImage:[UIImage imageNamed:@"message_public_chat_at_btn_disable"] forState:UIControlStateDisabled];
        [_atButton setImage:[UIImage imageNamed:@"message_public_chat_at_btn_hightlight"] forState:UIControlStateHighlighted];
        [_atButton sizeToFit];
    }
    return _atButton;
}

- (UIButton *)emoticonBtn {
    if (!_emoticonBtn) {
        _emoticonBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_emoticonBtn setImage:[UIImage imageNamed:@"message_public_chat_emoji_btn_normal"] forState:UIControlStateNormal];
        [_emoticonBtn setImage:[UIImage imageNamed:@"message_public_chat_emoji_btn_disable"] forState:UIControlStateDisabled];
        
        [_emoticonBtn setImage:[UIImage imageNamed:@"message_public_chat_emoji_btn_highlight"] forState:UIControlStateHighlighted];
        [_emoticonBtn sizeToFit];
    }
    return _emoticonBtn;
}


- (CGFloat)spacing{
    return 6.f;
}

- (CGFloat)textViewPadding
{
    return 3.f;
}

- (NSString *)contentText {
    return self.inputtTextField.text;
}

- (void)setContentText:(NSString *)contentText {
    self.inputtTextField.text = contentText;
}

@end


@implementation TTPrivateInputToolBar(InputText)

- (void)setText:(NSString *)text {
    self.inputtTextField.text = text;
}

- (NSRange)selectedRange {
    return self.inputtTextField.selectedRange;
}

- (void)setPlaceHolder:(NSString *)placeHolder {
    self.inputtTextField.placeholderAttributedText = [[NSAttributedString alloc] initWithString:placeHolder attributes:@{NSForegroundColorAttributeName:[UIColor grayColor]}];
}

- (void)insertText:(NSString *)text {
    if (!self.atButton.enabled || !self.emoticonBtn.enabled) {
        return;
    }
    NSRange range = self.inputtTextField.selectedRange;
    NSString *replaceText = [self.inputtTextField.text stringByReplacingCharactersInRange:range withString:text];
    range = NSMakeRange(range.location + text.length, 0);
    self.inputtTextField.text = replaceText;
    self.inputtTextField.selectedRange = range;
}

- (void)deleteText:(NSRange)range {
    if (!self.atButton.enabled || !self.emoticonBtn.enabled) {
        return;
    }
    NSString *text = self.contentText;
    if (range.location + range.length <= [text length]
        && range.location != NSNotFound && range.length != 0)
    {
        NSString *newText = [text stringByReplacingCharactersInRange:range withString:@""];
        NSRange newSelectRange = NSMakeRange(range.location, 0);
        [self.inputtTextField setText:newText];
        self.inputtTextField.selectedRange = newSelectRange;
    }
}


@end
