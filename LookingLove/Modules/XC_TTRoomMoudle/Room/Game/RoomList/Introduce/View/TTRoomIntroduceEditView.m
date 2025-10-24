//
//  TTRoomIntroduceEditView.m
//  TuTu
//
//  Created by Macx on 2019/1/3.
//  Copyright © 2019 YiZhuan. All rights reserved.
//

#import "TTRoomIntroduceEditView.h"

#import "XCTheme.h"
#import <Masonry/Masonry.h>

@interface TTRoomIntroduceEditView()
/** textView */
@property (nonatomic, strong) UITextView *textView;
/** countLabel */
@property (nonatomic, strong) UILabel *ttCountLabel;
/** placeholderLabel */
@property (nonatomic, strong) UILabel *ttPlaceholderLabel;
/** ttTextContentView */
@property (nonatomic, strong) UIView *ttTextContentView;

/** self.ttLimitCount */
@property (nonatomic, assign) NSInteger ttLimitCount;
@end

@implementation TTRoomIntroduceEditView

#pragma mark - life cycle

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initView];
        [self initConstrations];
    }
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - public methods

#pragma mark - [系统控件的Protocol]   //注意要把名字改掉，这个MARK只做功能划分，不是一个真正的MARK，每个不一样的Protocol，需要一个新的MARK”

#pragma mark - [自定义控件的Protocol] //注意要把名字改掉，这个MARK只做功能划分，不是一个真正的MARK，每个不一样的Protocol，需要一个新的MARK”

#pragma mark - [core相关的Protocol]  //注意要把名字改掉，这个MARK只做功能划分，不是一个真正的MARK，每个不一样的Protocol，需要一个新的MARK”

#pragma mark - event response
- (void)textViewTextDidChange {
    NSInteger existedLength = self.textView.text.length;
    self.ttCountLabel.text = [NSString stringWithFormat:@"%zd/%zd", existedLength > self.ttLimitCount ? self.ttLimitCount : existedLength, self.ttLimitCount];
    
    if (self.textView.text.length > self.ttLimitCount) {
        UITextRange *markedRange = [self.textView markedTextRange];
        if (markedRange) {
            return;
        }
        //Emoji占2个字符，如果是超出了半个Emoji，用15位置来截取会出现Emoji截为2半
        //超出最大长度的那个字符序列(Emoji算一个字符序列)的range
        NSRange range = [self.textView.text rangeOfComposedCharacterSequenceAtIndex:self.ttLimitCount];
        self.textView.text = [self.textView.text substringToIndex:range.location];
    }
    
    if (existedLength > 0) {
        self.ttPlaceholderLabel.hidden = YES;
    } else {
        self.ttPlaceholderLabel.hidden = NO;
    }
}

#pragma mark - private method

- (void)initView {
    self.ttLimitCount = 300;
    
    [self addSubview:self.ttTextContentView];
    [self.ttTextContentView addSubview:self.textView];
    [self.ttTextContentView addSubview:self.ttPlaceholderLabel];
    [self addSubview:self.ttCountLabel];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textViewTextDidChange) name:UITextViewTextDidChangeNotification object:self.textView];
}

- (void)initConstrations {
    
    [self.ttTextContentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(-15);
        make.height.mas_equalTo(210);
    }];
    
    [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(5);
        make.left.mas_equalTo(3);
        make.right.mas_equalTo(-5);
        make.bottom.mas_equalTo(0);
    }];
    
    [self.ttPlaceholderLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.textView).offset(8);
        make.left.mas_equalTo(self.textView).offset(5);
    }];
    
    [self.ttCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.textView.mas_bottom).offset(4);
        make.right.mas_equalTo(-15);
    }];
}

#pragma mark - getters and setters
- (UITextView *)textView {
    if (!_textView) {
        _textView = [[UITextView alloc] init];
        _textView.backgroundColor = [UIColor clearColor];
        _textView.font = [UIFont systemFontOfSize:13];
        _textView.tintColor = [XCTheme getTTMainColor];
//        _textView.layer.cornerRadius = 5;
//        _textView.layer.masksToBounds = YES;
//        _textView.backgroundColor = [XCTheme getMSSimpleGrayColor];
    }
    return _textView;
}

- (UILabel *)ttCountLabel {
    if (!_ttCountLabel) {
        _ttCountLabel = [[UILabel alloc] init];
        _ttCountLabel.textColor = [XCTheme getTTDeepGrayTextColor];
        _ttCountLabel.font = [UIFont systemFontOfSize:10];
    }
    return _ttCountLabel;
}

- (UILabel *)ttPlaceholderLabel {
    if (!_ttPlaceholderLabel) {
        _ttPlaceholderLabel = [[UILabel alloc] init];
        _ttPlaceholderLabel.textColor = [XCTheme getTTDeepGrayTextColor];
        _ttPlaceholderLabel.font = [UIFont systemFontOfSize:13];
        _ttPlaceholderLabel.text = @"请输入公告内容";
    }
    return _ttPlaceholderLabel;
}

- (UIView *)ttTextContentView {
    if (!_ttTextContentView) {
        _ttTextContentView = [[UIView alloc] init];
        _ttTextContentView.layer.cornerRadius = 5;
        _ttTextContentView.layer.masksToBounds = YES;
        _ttTextContentView.backgroundColor = [XCTheme getTTSimpleGrayColor];
    }
    return _ttTextContentView;
}

@end
