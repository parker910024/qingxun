//
//  WBMakeNameplateView.m
//  WanBan
//
//  Created by HUA on 2020/9/5.
//  Copyright © 2020 WUJIE INTERACTIVE. All rights reserved.
//

#import "WBMakeNameplateAlertView.h"

#import "XCMacros.h"
#import "XCTheme.h"
#import "XCCurrentVCStackManager.h"
#import "UIView+XCToast.h"
#import "TTPopup.h"
#import "LittleWorldCore.h"
#import "UIImage+Utils.h"
#import <SDWebImage/UIImageView+WebCache.h>

#import <Masonry/Masonry.h>

@interface WBMakeNameplateAlertView ()<UITextFieldDelegate>
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *countLabel;
@property (nonatomic, strong) UITextField *contentTextField;
@property (nonatomic, strong) UIButton *cancelButton;
@property (nonatomic, strong) UIButton *confirmButton;
@property (nonatomic, strong) UIView *underline;//下划线
@property (nonatomic, strong) UIImageView *nameplateImageView;//铭牌图片
@property (nonatomic, strong) UILabel *fixedLabel;//文案

@property (nonatomic, strong) UILabel *msgTipsLabel;

@property (nonatomic, copy) AlertViewInputCompletion completion;
@property (nonatomic, copy) AlertViewCancelDismiss dismiss;
@end
@implementation WBMakeNameplateAlertView

#pragma mark - life cycle

- (instancetype)initWithFrame:(CGRect)frame {
    
    /// 设置默认宽高
    if (CGRectEqualToRect(frame, CGRectZero)) {
        frame = CGRectMake(0, 0, KScreenWidth-35*2, 247);
    }
    
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = UIColor.whiteColor;
        self.layer.cornerRadius = 20;
        self.layer.masksToBounds = YES;
        
        [self initView];
        [self initConstraints];
        [self addNotification];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldDidChangeValue:) name: UITextFieldTextDidChangeNotification object:self.contentTextField];
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
//- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
//
//    //删除
//    if (string.length == 0) {
//        [self updateCount:range.location];
//        return YES;
//    }
//
//    //字数不设限
//    if (self.maxCount == 0) {
//        return YES;
//    }
//
//    NSMutableString *mText = [NSMutableString stringWithString:textField.text];
//    [mText insertString:string atIndex:range.location];
//
//    //字数在范围内
//    if (mText.length > self.maxCount) {
//        //字数在范围外
////        textField.text = [mText substringToIndex:self.maxCount];
//        [self updateCount:textField.text.length];
//        [UIView showToastInKeyWindow:@"已达到字数上限" duration:1.6 position:YYToastPositionCenter];
//
//        return NO;
//    }
//
//    [self updateCount:mText.length];
//
//    return YES;
//}
//
- (void)textFieldDidChangeValue:(NSNotification *)notification
{
    UITextField *textField = (UITextField *)[notification object];

    NSString *toBeString = textField.text;

    //获取高亮部分
    UITextRange *selectedRange = [textField markedTextRange];
    UITextPosition *position = [textField positionFromPosition:selectedRange.start offset:0];

    // 没有高亮选择的字，则对已输入的文字进行字数统计和限制
    if (!position)
    {
        if (toBeString.length > self.maxCount)
        {
            NSRange rangeIndex = [toBeString rangeOfComposedCharacterSequenceAtIndex:self.maxCount];
            if (rangeIndex.length == 1)
            {
                textField.text = [toBeString substringToIndex:self.maxCount];
                self.fixedLabel.text = [toBeString substringToIndex:self.maxCount];
            }
            else
            {
                NSRange rangeRange = [toBeString rangeOfComposedCharacterSequencesForRange:NSMakeRange(0, self.maxCount)];
                textField.text = [toBeString substringWithRange:rangeRange];
                self.fixedLabel.text = [toBeString substringWithRange:rangeRange];
            }
        } else {
            self.fixedLabel.text = textField.text;
        }
        [self updateCount:self.fixedLabel.text.length];
    }


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
       // self.msgTipsLabel.text = [NSString stringWithFormat:@"字符数不得少于 %lu", (unsigned long)self.minCount];
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
    self.contentTextField.rightView = self.countLabel;
    self.contentTextField.rightViewMode = UITextFieldViewModeAlways;
    [self addSubview:self.contentTextField];
    [self addSubview:self.nameplateImageView];
    [self addSubview:self.fixedLabel];
    [self addSubview:self.countLabel];
    [self addSubview:self.cancelButton];
    [self addSubview:self.confirmButton];
    [self addSubview:self.underline];
    
  //  [self addSubview:self.msgTipsLabel];
}

- (void)initConstraints {
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(25);
        make.centerX.equalTo(self.mas_centerX);
    }];
    
    [self.nameplateImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.top.equalTo(self.titleLabel.mas_bottom).offset(22);
        make.width.equalTo(@60);
        make.height.equalTo(@15);
    }];
    
    [self.fixedLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.nameplateImageView.mas_centerY);
        make.left.equalTo(self.nameplateImageView.mas_left).offset(17);
        make.width.equalTo(@40);
    }];
    
    [self.contentTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.nameplateImageView.mas_bottom).offset(25);
        make.left.right.mas_equalTo(self).inset(35);
        make.height.mas_equalTo(40);
    }];
    
    [self.countLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.contentTextField.mas_centerY);
        make.right.mas_equalTo(self.contentTextField).offset(-35);
    }];
    
//    [self.cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.right.mas_equalTo(self).inset(15);
//    }];
    
    [self.confirmButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.mas_centerX);
        make.top.mas_equalTo(self.contentTextField.mas_bottom).offset(25);
        make.height.mas_equalTo(44);
        make.width.mas_equalTo(@120);
    }];
    
    [self.underline mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self).inset(35);
        make.top.equalTo(self.contentTextField.mas_bottom);
        make.height.equalTo(@1);
    }];
    
//    [self.msgTipsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.mas_equalTo(self.contentTextField.mas_bottom).offset(4);
//        make.centerX.mas_equalTo(0);
//    }];
}

/// 更新计数
- (void)updateCount:(unsigned long)count {
    self.countLabel.text = [NSString stringWithFormat:@"%lu/%lu   ", count, (unsigned long)self.maxCount];
}

#pragma mark - Getter Setter
- (void)setUrl:(NSString *)url {
    [self.nameplateImageView sd_setImageWithURL:[NSURL URLWithString:url]];
}

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
        _titleLabel.textColor = UIColorFromRGB(0x343434);
        _titleLabel.font = [UIFont boldSystemFontOfSize:18];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLabel;
}

- (UILabel *)countLabel {
    if (_countLabel == nil) {
        _countLabel = [[UILabel alloc] init];
        _countLabel.frame = CGRectMake(0, 0, 35, 10);
        _countLabel.textColor = UIColorFromRGB(0xBBBBBB);
        _countLabel.font = [UIFont systemFontOfSize:12 weight:UIFontWeightMedium];
        _countLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _countLabel;
}

- (UITextField *)contentTextField {
    if (_contentTextField == nil) {
        _contentTextField = [[UITextField alloc] init];
        _contentTextField.delegate = self;
//        _contentTextField.layer.cornerRadius = 20;
//        _contentTextField.layer.masksToBounds = YES;
//        _contentTextField.backgroundColor = UIColorFromRGB(0xF9F9F9);
        _contentTextField.font = [UIFont systemFontOfSize:15];
        _contentTextField.attributedPlaceholder =  [[NSAttributedString alloc] initWithString:@"请输入铭牌字样" attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:15], NSForegroundColorAttributeName : UIColorFromRGB(0xB4B4B4)}];
        _contentTextField.leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 15, 10)];
        _contentTextField.leftViewMode = UITextFieldViewModeAlways;
        
       
    }
    return _contentTextField;
}

- (UIButton *)cancelButton {
    if (_cancelButton == nil) {
        _cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _cancelButton.layer.masksToBounds = YES;
        [_cancelButton setBackgroundImage:[UIImage imageNamed:@"dress_nameplate_cancel"] forState:normal];
        [_cancelButton addTarget:self action:@selector(cancelButtonTapped:) forControlEvents:UIControlEventTouchUpInside];

    }
    return _cancelButton;
}

- (UIButton *)confirmButton {
    if (_confirmButton == nil) {
        _confirmButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_confirmButton setTitle:@"确定" forState:UIControlStateNormal];
        [_confirmButton setTitleColor:UIColorFromRGB(0x333333) forState:UIControlStateNormal];
        _confirmButton.titleLabel.font = [UIFont systemFontOfSize:15 weight:UIFontWeightMedium];
        //_confirmButton.backgroundColor = [XCTheme getTTMainColor];
        _confirmButton.layer.cornerRadius = 22;
        _confirmButton.layer.masksToBounds = YES;
        [_confirmButton addTarget:self action:@selector(confirmButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
        [_confirmButton setBackgroundColor:UIColorFromRGB(0x3AEBDF)];
        _confirmButton.layer.borderWidth = 2;
        _confirmButton.layer.borderColor = UIColorFromRGB(0x333333).CGColor;
        
//        if (projectType() == ProjectType_CeEr) {
//            _confirmButton.layer.cornerRadius = 8;
//            _confirmButton.backgroundColor = XCThemeMainColor;
//        }
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

- (UIImageView *)nameplateImageView {
    if (!_nameplateImageView) {
        _nameplateImageView = [UIImageView new];
    }
    return _nameplateImageView;
}

- (UILabel *)fixedLabel {
    if (!_fixedLabel) {
        _fixedLabel = [UILabel new];
        _fixedLabel.textColor = [UIColor whiteColor];
        _fixedLabel.font = [UIFont systemFontOfSize:9];
        _fixedLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _fixedLabel;
}

- (UIView *)underline {
    if (!_underline) {
        _underline = [UIView new];
        _underline.backgroundColor = UIColorFromRGB(0xE6E6E6);
    }
    return _underline;
}

@end
