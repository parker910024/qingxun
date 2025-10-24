//
//  TTSendGiftCustomCountView.m
//  TTSendGiftView
//
//  Created by Macx on 2019/4/24.
//  Copyright © 2019 YiZhuan. All rights reserved.
//

#import "TTSendGiftCustomCountView.h"

#import <Masonry/Masonry.h>
#import "XCMacros.h"
#import "XCTheme.h"
#import "XCHUDTool.h"

@interface TTSendGiftCustomCountView()<UITextFieldDelegate>
//输入容器
@property (nonatomic, strong) UIView *editContainerView;
//输入框
@property (nonatomic, strong) UITextField *editTextFiled;
//发送按钮
@property (nonatomic, strong) UIButton *sendButton;
@end

@implementation TTSendGiftCustomCountView
#pragma mark - life cycle

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initView];
        [self initConstrations];
    }
    return self;
}

#pragma mark - public methods

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    NSString *countStr = [self.editTextFiled.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSInteger count = [countStr integerValue];
    if (count > 9999) {
        [XCHUDTool showErrorWithMessage:@"礼物数最多9999"];
        return NO;
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(sendGiftCustomCountView:didClickSureButton:)]) {
        [self.delegate sendGiftCustomCountView:self didClickSureButton:self.sendButton];
    }
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSString *regex =@"[0-9]*";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    if ([pred evaluateWithObject:string]) {
        return YES;
    }
    return NO;
}

#pragma mark - [自定义控件的Protocol] //注意要把名字改掉，这个MARK只做功能划分，不是一个真正的MARK，每个不一样的Protocol，需要一个新的MARK”

#pragma mark - [core相关的Protocol]  //注意要把名字改掉，这个MARK只做功能划分，不是一个真正的MARK，每个不一样的Protocol，需要一个新的MARK”

#pragma mark - event response
- (void)sendButtonDidClick:(UIButton *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(sendGiftCustomCountView:didClickSureButton:)]) {
        [self.delegate sendGiftCustomCountView:self didClickSureButton:sender];
    }
}

#pragma mark - private method

- (void)initView {
    [self addSubview:self.editContainerView];
    [self.editContainerView addSubview:self.editTextFiled];
    [self.editContainerView addSubview:self.sendButton];
}

- (void)initConstrations {
    [self.editContainerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.mas_equalTo(self);
    }];
    
    [self.editTextFiled mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.editContainerView).offset(15);
        make.top.equalTo(self.editContainerView).offset(5);
        make.bottom.equalTo(self.editContainerView).offset(-5);
        make.right.equalTo(self.editContainerView).offset(-70);
    }];
    
    [self.sendButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.editContainerView).offset(-10);
        make.top.bottom.equalTo(self.editTextFiled);
        make.width.equalTo(@50);
    }];
}

#pragma mark - getters and setters

- (UIView *)editContainerView {
    if (!_editContainerView) {
        _editContainerView = [[UIView alloc] init];
        _editContainerView.backgroundColor = [UIColor whiteColor];
    }
    return _editContainerView;
}

- (UITextField *)editTextFiled {
    if (!_editTextFiled) {
        _editTextFiled = [[UITextField alloc] init];
        _editTextFiled.placeholder = @"请输入赠送数额";
        _editTextFiled.borderStyle = UITextBorderStyleNone;
        _editTextFiled.returnKeyType = UIReturnKeyDone;
        _editTextFiled.delegate = self;
        _editTextFiled.keyboardType = UIKeyboardTypeNumberPad;
    }
    return _editTextFiled;
}

- (UIButton *)sendButton {
    if (!_sendButton) {
        _sendButton = [[UIButton alloc] init];
        [_sendButton setTitle:@"确定" forState:UIControlStateNormal];
        _sendButton.titleLabel.textColor = [UIColor whiteColor];
        _sendButton.titleLabel.font = [UIFont systemFontOfSize:15];
        _sendButton.backgroundColor = [XCTheme getTTMainColor];
        _sendButton.layer.cornerRadius = 5.0;
        _sendButton.layer.masksToBounds = YES;
        [_sendButton addTarget:self action:@selector(sendButtonDidClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _sendButton;
}

@end
