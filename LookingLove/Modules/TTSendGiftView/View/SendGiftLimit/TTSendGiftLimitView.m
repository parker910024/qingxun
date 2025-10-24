//
//  TTSendGiftLimitView.m
//  WanBan
//
//  Created by jiangfuyuan on 2020/11/30.
//  Copyright © 2020 WUJIE INTERACTIVE. All rights reserved.
//

#import "TTSendGiftLimitView.h"

#import "AuthCore.h"
#import "UserCore.h"
#import "AuthCoreClient.h"

#import "XCHUDTool.h"
#import "TTPopup.h"
#import "XCTheme.h"
#import "XCMacros.h"
#import "TTAuthEditView.h"

#import "UIView+NTES.h"
#import "UIView+Gradient.h"
#import "UIFont+FontCollection.h"
#import <Masonry/Masonry.h>

#define kScale(x) ((x) / 375.0 * KScreenWidth)
@interface TTSendGiftLimitView ()<UITextFieldDelegate>

@property (nonatomic, strong) UIView *backView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *contentLabel;
@property (nonatomic, strong) UIView *textBackView;
@property (nonatomic, strong) UITextField *limitTextField;
@property (nonatomic, strong) UIButton *sendButton;
@property (nonatomic, strong) UIButton *closeButton;
@property (nonatomic, strong) UIButton *sureButton;

@end


@implementation TTSendGiftLimitView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initViews];
        [self initContraints];
    }
    return self;
}

- (void)initViews {
    
    self.backgroundColor = UIColorRGBAlpha(0xffffff, 0);
    
    AddCoreClient(AuthCoreClient, self);
    
    [self addSubview:self.backView];
    [self.backView addSubview:self.titleLabel];
    [self.backView addSubview:self.contentLabel];
    [self.backView addSubview:self.textBackView];
    [self.textBackView addSubview:self.limitTextField];
    [self.textBackView addSubview:self.sendButton];
    [self.backView addSubview:self.closeButton];
    [self.backView addSubview:self.sureButton];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHidden:) name:UIKeyboardWillHideNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
}

- (void)keyboardWillShow:(NSNotification *)notification {
    
    CGFloat duration = [notification.userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue];
    
    //取得键盘最后的frame(根据userInfo的key----UIKeyboardFrameEndUserInfoKey = "NSRect: {{0, 227}, {320, 253}}";)
    CGRect keyboardFrame = [notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    //计算控制器的view需要平移的距离
//    CGFloat transformY = keyboardFrame.origin.y - self.view.frame.size.height;
    @weakify(self);
    [UIView animateWithDuration:duration animations:^{
        @strongify(self);
        self.backView.centerY = KScreenHeight / 2 - kScale(120);
    }];
}

- (void)keyboardWillHidden:(NSNotification *)notification {
    CGFloat duration = [notification.userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue];
    @weakify(self);
    [UIView animateWithDuration:duration animations:^{
        @strongify(self);
        self.backView.centerY = KScreenHeight / 2;
    }];
}

- (void)keyboardWillChangeFrame:(NSNotification *)notification {
    [[NSNotificationCenter defaultCenter] postNotificationName:KTTInputViewBecomeFirstResponder object:self.limitTextField];
}

- (void)dealloc {
    [GetCore(AuthCore) stopCountDown];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillChangeFrameNotification object:nil];
}

- (void)onRequestSmsCodeSuccess:(NSNumber *)type {
}

- (void)onRequestSmsCodeFailth:(NSString *)errorMsg {
    [XCHUDTool showErrorWithMessage:errorMsg];
    [self onCutdownFinish];
}

- (void)onCutdownOpen:(NSNumber *)number {
    [self.sendButton setTitle:[NSString stringWithFormat:@"%ds后重试", number.intValue] forState:UIControlStateNormal];
    self.sendButton.userInteractionEnabled = NO;
}

- (void)onCutdownFinish {
    //设置按钮的样式
    [self.sendButton setTitle:@"重新发送" forState:UIControlStateNormal];
    self.sendButton.userInteractionEnabled = YES;
}

- (void)sendVerificationCodeAction:(UIButton *)sender {
    UserInfo *info = [GetCore(UserCore) getUserInfoInDB:GetCore(AuthCore).getUid.userIDValue];
    [GetCore(AuthCore) requestSmsCode:info.phone type:@(15)];
}

- (void)closeButtonClick:(UIButton *)sender {
    [TTPopup dismiss];
}

- (void)sureButtonClick:(UIButton *)sender {
    [[GetCore(AuthCore) getVerificationSendGiftWithCode:self.limitTextField.text] subscribeNext:^(id  _Nullable x) {
        [XCHUDTool showSuccessWithMessage:@"解除限制成功"];
        [TTPopup dismiss];
    } error:^(NSError * _Nullable error) {
        [XCHUDTool showErrorWithMessage:error.domain];
    }];
}

- (void)setLimitType:(ConsumptionLimitType)limitType {
    _limitType = limitType;
    UserInfo *info = [GetCore(UserCore) getUserInfoInDB:GetCore(AuthCore).getUid.userIDValue];
    if (limitType == ConsumptionLimit_Daily) {
        _contentLabel.text = [NSString stringWithFormat:@"您的账号打赏即将超过每日限额，请理性消费，若确认需要继续打赏，请输入%@收到的短信验证码",info.phone];
    } else {
        _contentLabel.text = [NSString stringWithFormat:@"您的账号打赏即将超过每月限额，请理性消费，若确认需要继续打赏，请输入%@收到的短信验证码",info.phone];
    }
}

- (void)initContraints {
    
    [self.backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(self);
        make.width.mas_equalTo(280);
        make.height.mas_equalTo(293);
    }];
    
    [self.backView layoutIfNeeded];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.top.mas_equalTo(25);
    }];
    
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.backView).inset(20);
        make.top.mas_equalTo(self.titleLabel.mas_bottom).offset(20);
    }];
    
    [self.textBackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.right.mas_equalTo(-15);
        make.top.mas_equalTo(self.contentLabel.mas_bottom).offset(25);
        make.height.mas_equalTo(40);
    }];
    
    [self.limitTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.centerY.mas_equalTo(0);
        make.right.mas_equalTo(-90);
        make.height.mas_equalTo(40);
    }];
    
    [self.sendButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(0);
        make.right.mas_equalTo(-5);
        make.height.mas_equalTo(29);
        make.width.mas_equalTo(84);
    }];
    
    [self.closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(12.5);
        make.height.mas_equalTo(44);
        make.width.mas_equalTo(120);
        make.bottom.mas_equalTo(-25);
    }];
    
    [self.sureButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-12.5);
        make.height.mas_equalTo(44);
        make.width.mas_equalTo(120);
        make.bottom.mas_equalTo(-25);
    }];
}

- (UIView *)backView {
    if (!_backView) {
        _backView = [[UIView alloc] init];
        _backView.backgroundColor = UIColorFromRGB(0xffffff);
        _backView.layer.cornerRadius = 20;
        _backView.layer.masksToBounds = YES;
    }
    return _backView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = UIColorFromRGB(0x222222);
        _titleLabel.font = [UIFont PingFangSC_Medium_WithFontSize:17];
        _titleLabel.text = @"短信验证";
    }
    return _titleLabel;
}

- (UILabel *)contentLabel {
    if (!_contentLabel) {
        _contentLabel = [[UILabel alloc] init];
        _contentLabel.textColor = UIColorFromRGB(0x666666);
        _contentLabel.font = [UIFont systemFontOfSize:14];
        _contentLabel.numberOfLines = 0;
        _contentLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _contentLabel;
}

- (UIView *)textBackView {
    if (!_textBackView) {
        _textBackView = [[UIView alloc] init];
        _textBackView.backgroundColor = UIColorFromRGB(0xF9F9F9);
        _textBackView.layer.borderWidth = 0.5;
        _textBackView.layer.borderColor = UIColorFromRGB(0x979797).CGColor;
        _textBackView.layer.cornerRadius = 20;
        _textBackView.layer.masksToBounds = YES;
    }
    return _textBackView;
}

- (UITextField *)limitTextField {
    if (!_limitTextField) {
        _limitTextField = [[UITextField alloc] init];
        _limitTextField.textColor = UIColorFromRGB(0x666666);
        _limitTextField.font = [UIFont systemFontOfSize:14];
        _limitTextField.attributedPlaceholder = [[NSMutableAttributedString alloc] initWithString:@"验证码" attributes:@{NSForegroundColorAttributeName:UIColorFromRGB(0xBCBCBC),NSFontAttributeName:[UIFont systemFontOfSize:14]}];
        _limitTextField.keyboardType = UIKeyboardTypeNumberPad;
        _limitTextField.delegate = self;
    }
    return _limitTextField;
}

- (UIButton *)sendButton {
    if (!_sendButton) {
        _sendButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_sendButton setTitle:@"获取验证码" forState:UIControlStateNormal];
        [_sendButton setTitleColor:UIColorFromRGB(0xFFFFFF) forState:UIControlStateNormal];
        _sendButton.titleLabel.font = [UIFont systemFontOfSize:12];
        _sendButton.backgroundColor = UIColorFromRGB(0x9976FC);
        _sendButton.layer.cornerRadius = 15;
        _sendButton.layer.masksToBounds = YES;
        [_sendButton addTarget:self action:@selector(sendVerificationCodeAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _sendButton;
}

- (UIButton *)closeButton {
    if (!_closeButton) {
        _closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_closeButton setTitle:@"关闭" forState:UIControlStateNormal];
        [_closeButton setTitleColor:UIColorFromRGB(0x666666) forState:UIControlStateNormal];
        _closeButton.titleLabel.font = [UIFont systemFontOfSize:14];
        _closeButton.backgroundColor = UIColorFromRGB(0xF5F5F5);
        _closeButton.layer.cornerRadius = 22;
        _closeButton.layer.masksToBounds = YES;
        [_closeButton addTarget:self action:@selector(closeButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _closeButton;
}

- (UIButton *)sureButton {
    if (!_sureButton) {
        _sureButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_sureButton setTitle:@"确定" forState:UIControlStateNormal];
        [_sureButton setTitleColor:UIColorFromRGB(0xFFFFFF) forState:UIControlStateNormal];
        _sureButton.titleLabel.font = [UIFont boldSystemFontOfSize:14];
        _sureButton.backgroundColor = UIColorFromRGB(0x9976FC);
        _sureButton.layer.cornerRadius = 22;
        _sureButton.layer.masksToBounds = YES;
        [_sureButton addTarget:self action:@selector(sureButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _sureButton;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
