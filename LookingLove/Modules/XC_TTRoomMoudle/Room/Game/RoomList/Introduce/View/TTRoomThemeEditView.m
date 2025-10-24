
//
//  TTRoomThemeEditView.m
//  TuTu
//
//  Created by Macx on 2019/1/3.
//  Copyright © 2019 YiZhuan. All rights reserved.
//

#import "TTRoomThemeEditView.h"

#import "XCTheme.h"
#import <Masonry/Masonry.h>

@interface TTRoomThemeEditView()
/** textField */
@property (nonatomic, strong) UITextField *textField;
/** countLabel */
@property (nonatomic, strong) UILabel *ttCountLabel;

/** self.ttLimitCount */
@property (nonatomic, assign) NSInteger ttLimitCount;
@end

@implementation TTRoomThemeEditView

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
- (void)textFieldTextDidChange {
    NSInteger existedLength = self.textField.text.length;
    self.ttCountLabel.text = [NSString stringWithFormat:@"%zd/%zd", existedLength > self.ttLimitCount ? self.ttLimitCount : existedLength, self.ttLimitCount];
    
    if (self.textField.text.length > self.ttLimitCount) {
        UITextRange *markedRange = [self.textField markedTextRange];
        if (markedRange) {
            return;
        }
        //Emoji占2个字符，如果是超出了半个Emoji，用15位置来截取会出现Emoji截为2半
        //超出最大长度的那个字符序列(Emoji算一个字符序列)的range
        NSRange range = [self.textField.text rangeOfComposedCharacterSequenceAtIndex:self.ttLimitCount];
        self.textField.text = [self.textField.text substringToIndex:range.location];
    }
}

#pragma mark - private method

- (void)initView {
    self.ttLimitCount = 15;
    
    [self addSubview:self.textField];
    [self addSubview:self.ttCountLabel];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldTextDidChange) name:UITextFieldTextDidChangeNotification object:self.textField];
}

- (void)initConstrations {
    
    [self.textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.top.mas_equalTo(10);
        make.right.mas_equalTo(-15);
        make.height.mas_equalTo(42);
    }];
    
    [self.ttCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.textField.mas_bottom).offset(5);
        make.right.mas_equalTo(-15);
    }];
}

#pragma mark - getters and setters

- (UITextField *)textField {
    if (!_textField) {
        _textField = [[UITextField alloc] init];
        _textField.font = [UIFont systemFontOfSize:13];
        _textField.tintColor = [XCTheme getTTMainColor];
        _textField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请设置公告标题" attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:13], NSForegroundColorAttributeName : [XCTheme getTTDeepGrayTextColor]}];
        _textField.layer.cornerRadius = 5;
        _textField.layer.masksToBounds = YES;
        _textField.backgroundColor = [XCTheme getTTSimpleGrayColor];
        
        UIView *leftView = [[UIView alloc] init];
        leftView.frame = CGRectMake(0, 0, 7, 0);
        
        _textField.leftView = leftView;
        _textField.leftViewMode = UITextFieldViewModeAlways;
    }
    return _textField;
}

- (UILabel *)ttCountLabel {
    if (!_ttCountLabel) {
        _ttCountLabel = [[UILabel alloc] init];
        _ttCountLabel.textColor = [XCTheme getTTDeepGrayTextColor];
        _ttCountLabel.font = [UIFont systemFontOfSize:10];
    }
    return _ttCountLabel;
}

@end
