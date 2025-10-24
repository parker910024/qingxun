//
//  TTRoomSettingsInputAlertView.m
//  TuTu
//
//  Created by lvjunhang on 2018/11/6.
//  Copyright © 2018年 YiZhuan. All rights reserved.
//

#import "TTRoomSettingsInputAlertView.h"

#import "XCMacros.h"
#import "XCTheme.h"
#import "XCCurrentVCStackManager.h"
#import "UIView+XCToast.h"
#import "TTPopup.h"
#import "LittleWorldCore.h"

#import <Masonry/Masonry.h>

@interface TTRoomSettingsInputAlertView ()<UITextFieldDelegate>
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *countLabel;
@property (nonatomic, strong) UITextField *contentTextField;
@property (nonatomic, strong) UIButton *cancelButton;
@property (nonatomic, strong) UIButton *confirmButton;

@property (nonatomic, strong) UILabel *msgTipsLabel;

@property (nonatomic, copy) AlertViewInputCompletion completion;
@property (nonatomic, copy) AlertViewCancelDismiss dismiss;
@end

@implementation TTRoomSettingsInputAlertView

#pragma mark - life cycle

- (instancetype)initWithFrame:(CGRect)frame {
    
    /// 设置默认宽高
    if (CGRectEqualToRect(frame, CGRectZero)) {
        frame = CGRectMake(0, 0, KScreenWidth-32*2, 190);
    }
    
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = UIColor.whiteColor;
        self.layer.cornerRadius = 10;
        self.layer.masksToBounds = YES;
        
        [self initView];
        [self initConstraints];
        [self addNotification];
    }
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)addNotification {
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];

}

- (void)keyboardWillChangeFrame:(NSNotification *)notification {
     [[NSNotificationCenter defaultCenter] postNotificationName:KTTInputViewBecomeFirstResponder object:self.contentTextField];
}

- (void)keyboardWillShow:(NSNotification*)notification {
    
    GetCore(LittleWorldCore).isLittleWorldInput = YES;
    CGRect keyboardRect = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    CGRect rect = [self.superview convertRect:self.frame toView:[UIApplication sharedApplication].keyWindow];
    
    CGFloat top = KScreenHeight / 2 + rect.size.height / 2;
    
    CGFloat height = CGRectGetMinY(keyboardRect) - top;
    if (height < 0) {
        [UIView animateWithDuration:0.25 animations:^{
            self.superview.frame = CGRectMake(rect.origin.x, KScreenHeight / 2 - rect.size.height / 2 + (height - 10), rect.size.width, rect.size.height);
        } completion:^(BOOL finished) {
           
        }];
    }
    
   
}

- (void)keyboardWillHide:(NSNotification*)notification
{
    CGRect rect = [self.superview convertRect:self.frame toView:[UIApplication sharedApplication].keyWindow];
    
    [UIView animateWithDuration:0.25 animations:^{
        self.superview.frame = CGRectMake(rect.origin.x, KScreenHeight / 2 - rect.size.height / 2, rect.size.width, rect.size.height);
    }];
}

#pragma mark - public method
- (void)showAlertWithCompletion:(AlertViewInputCompletion)completion dismiss:(AlertViewCancelDismiss)dismiss {
    self.completion = completion;
    self.dismiss = dismiss;
    
    TTPopupConfig *config = [[TTPopupConfig alloc] init];
    config.contentView = self;
    config.style = TTPopupStyleAlert;
    config.didFinishDismissHandler = ^(BOOL isDismissOnBackgroundTouch) {
        if (self.dismiss) {
            self.dismiss();
        }
    };
    [TTPopup popupWithConfig:config];
}

#pragma mark - system protocols
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    //删除
    if (string.length == 0) {
        [self updateCount:range.location];
        return YES;
    }
    
    //字数不设限
    if (self.maxCount == 0) {
        return YES;
    }
    
    NSMutableString *mText = [NSMutableString stringWithString:textField.text];
    [mText insertString:string atIndex:range.location];

    //字数在范围内
    if (mText.length > self.maxCount) {
        //字数在范围外
        textField.text = [mText substringToIndex:self.maxCount];
        [self updateCount:textField.text.length];
        [UIView showToastInKeyWindow:@"已达到字数上限" duration:1.6 position:YYToastPositionCenter];
        
        return NO;
    }
    
    [self updateCount:mText.length];

    return YES;
}

#pragma mark - custom protocols
#pragma mark - core protocols
#pragma mark - event response
- (void)cancelButtonTapped:(UIButton *)sender {
    
    [TTPopup dismiss];
    
    if (self.dismiss) {
        self.dismiss();
    }
}

- (void)confirmButtonTapped:(UIButton *)sender {
    if (self.maxCount > 0 && self.contentTextField.text.length < self.minCount) {
        self.msgTipsLabel.text = [NSString stringWithFormat:@"字符数不得少于 %lu", (unsigned long)self.minCount];
        return;
    }
    
    self.msgTipsLabel.text = nil;
    
    [TTPopup dismiss];
    
    if (self.completion) {
        self.completion(self.contentTextField.text);
    }
}

#pragma mark - private method
- (void)initView {
    [self addSubview:self.titleLabel];
    [self addSubview:self.countLabel];
    [self addSubview:self.contentTextField];
    [self addSubview:self.cancelButton];
    [self addSubview:self.confirmButton];
    
    [self addSubview:self.msgTipsLabel];
}

- (void)initConstraints {
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(30);
        make.left.right.mas_equalTo(self).inset(15);
    }];
    
    [self.contentTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.titleLabel.mas_bottom).offset(15);
        make.left.right.mas_equalTo(self).inset(15);
        make.height.mas_equalTo(40);
    }];
    
    [self.countLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentTextField.mas_bottom).offset(4);
        make.right.mas_equalTo(self.contentTextField).offset(-10);
    }];
    
    [self.cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentTextField.mas_bottom).offset(30);
        make.left.mas_equalTo(20);
        make.height.mas_equalTo(43);
    }];
    
    [self.confirmButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.cancelButton.mas_right).offset(18);
        make.top.height.mas_equalTo(self.cancelButton);
        make.right.mas_equalTo(-20);
        make.width.mas_equalTo(self.cancelButton);
    }];
    
    [self.msgTipsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentTextField.mas_bottom).offset(4);
        make.centerX.mas_equalTo(0);
    }];
}

/// 更新计数
- (void)updateCount:(unsigned long)count {
    self.countLabel.text = [NSString stringWithFormat:@"%lu/%lu", count, (unsigned long)self.maxCount];
}

#pragma mark - Getter Setter
- (void)setMaxCount:(NSUInteger)maxCount {
    _maxCount = maxCount;
    
    self.countLabel.hidden = maxCount == 0;
    [self updateCount:self.content.length];
    
    if (maxCount > 0 && self.content && self.content.length > maxCount) {
        self.content = [self.content substringToIndex:self.maxCount];
    }
}

- (void)setTitle:(NSString *)title {
    _title = title;
    
    self.titleLabel.text = title;
}

- (void)setContent:(NSString *)content {
    
    if (self.maxCount > 0 && self.maxCount < content.length) {
        content = [content substringToIndex:self.maxCount];
    }
    
    _content = content;
    
    self.contentTextField.text = content;
    [self updateCount:content.length];
}

- (void)setPlaceholder:(NSString *)placeholder {
    _placeholder = placeholder;
    
    self.contentTextField.placeholder = placeholder;
}

- (void)setKeyboardType:(UIKeyboardType)keyboardType {
    _keyboardType = keyboardType;
    
    self.contentTextField.keyboardType = keyboardType;
}

- (UILabel *)titleLabel {
    if (_titleLabel == nil) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.text = @"标题";
        _titleLabel.textColor = [XCTheme getTTMainTextColor];
        _titleLabel.font = [UIFont systemFontOfSize:15];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLabel;
}

- (UILabel *)countLabel {
    if (_countLabel == nil) {
        _countLabel = [[UILabel alloc] init];
        _countLabel.textColor = [XCTheme getTTDeepGrayTextColor];
        _countLabel.font = [UIFont systemFontOfSize:10];
        _countLabel.textAlignment = NSTextAlignmentRight;
    }
    return _countLabel;
}

- (UITextField *)contentTextField {
    if (_contentTextField == nil) {
        _contentTextField = [[UITextField alloc] init];
        _contentTextField.delegate = self;
        _contentTextField.layer.cornerRadius = 20;
        _contentTextField.layer.masksToBounds = YES;
        _contentTextField.backgroundColor = UIColorFromRGB(0xF0F0F0);
        _contentTextField.placeholder = @"请输入";
        _contentTextField.leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 15, 10)];
        _contentTextField.leftViewMode = UITextFieldViewModeAlways;
        _contentTextField.rightView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 15, 10)];
        _contentTextField.rightViewMode = UITextFieldViewModeAlways;
    }
    return _contentTextField;
}

- (UIButton *)cancelButton {
    if (_cancelButton == nil) {
        _cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_cancelButton setTitle:@"取消" forState:UIControlStateNormal];
        [_cancelButton setTitleColor:[XCTheme getTTMainColor] forState:UIControlStateNormal];
        _cancelButton.titleLabel.font = [UIFont systemFontOfSize:15];
        _cancelButton.backgroundColor = UIColorFromRGB(0xFEF5ED);
        _cancelButton.layer.cornerRadius = 20;
        _cancelButton.layer.masksToBounds = YES;
        [_cancelButton addTarget:self action:@selector(cancelButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
        
        if (projectType() == ProjectType_CeEr) {
            [_cancelButton setTitleColor:XCThemeSubTextColor forState:UIControlStateNormal];
            _cancelButton.backgroundColor = UIColorFromRGB(0xEEEDF0);
            _cancelButton.layer.cornerRadius = 8;
        }
    }
    return _cancelButton;
}

- (UIButton *)confirmButton {
    if (_confirmButton == nil) {
        _confirmButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_confirmButton setTitle:@"确定" forState:UIControlStateNormal];
        [_confirmButton setTitleColor:UIColorFromRGB(0xFFFFFF) forState:UIControlStateNormal];
        _confirmButton.titleLabel.font = [UIFont systemFontOfSize:15];
        _confirmButton.backgroundColor = [XCTheme getTTMainColor];
        _confirmButton.layer.cornerRadius = 20;
        _confirmButton.layer.masksToBounds = YES;
        [_confirmButton addTarget:self action:@selector(confirmButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
        
        if (projectType() == ProjectType_CeEr) {
            _confirmButton.layer.cornerRadius = 8;
            _confirmButton.backgroundColor = XCThemeMainColor;
        }
    }
    return _confirmButton;
}

- (UILabel *)msgTipsLabel {
    if (_msgTipsLabel == nil) {
        _msgTipsLabel = [[UILabel alloc] init];
        _msgTipsLabel.textColor = UIColor.redColor;
        _msgTipsLabel.font = [UIFont systemFontOfSize:12];
        _msgTipsLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _msgTipsLabel;
}

@end
