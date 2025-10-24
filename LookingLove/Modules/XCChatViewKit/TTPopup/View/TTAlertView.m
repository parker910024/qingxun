//
//  TTAlertView.m
//  XC_TTChatViewKit
//
//  Created by lee on 2019/5/20.
//  Copyright © 2019 YiZhuan. All rights reserved.
//

#import "TTAlertView.h"

#import <Masonry/Masonry.h>
#import "XCTheme.h"
#import "XCMacros.h"

#import "TTAlertConfig.h"

static CGFloat const kMargin = 25.f;
static CGFloat const kPadding = 20.f;
static CGFloat const kBtnHeight = 43.f;

@interface TTAlertView ()

@property (nonatomic, strong) UILabel *titleLabel;      // 标题
@property (nonatomic, strong) UILabel *messageLabel;    // 内容
@property (nonatomic, strong) UIButton *cancelButton;   // 取消按钮
@property (nonatomic, strong) UIButton *confirmButton;  // 确认按钮

@end

@implementation TTAlertView

#pragma mark - lifeCyle
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = UIColor.whiteColor;
        
        [self initViews];
        [self initConstraints];
    }
    return self;
}

- (void)initViews {
    [self addSubview:self.titleLabel];
    [self addSubview:self.messageLabel];
    [self addSubview:self.cancelButton];
    [self addSubview:self.confirmButton];
}

- (void)initConstraints {
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self);
        make.top.mas_equalTo(kPadding);
        make.left.right.mas_equalTo(self).inset(kPadding);
    }];
    
    [self.messageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.titleLabel.mas_bottom).offset(kMargin);
        make.left.right.mas_equalTo(self).inset(kPadding);
    }];
    
    [self.cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(43);
        make.right.mas_equalTo(self.mas_centerX).offset(-8);
        make.left.mas_equalTo(kPadding);
        make.bottom.mas_equalTo(-kPadding);
    }];
    
    [self.confirmButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(kBtnHeight);
        make.left.mas_equalTo(self.mas_centerX).offset(8);
        make.right.mas_equalTo(-kPadding);
        make.bottom.mas_equalTo(-kPadding);
    }];
}

#pragma mark - Button Events
- (void)onClickConfirmButtonAction:(UIButton *)confirmButton {
    !_confirmAction ?: _confirmAction();
    !_dismissAction ?: _dismissAction();
}

- (void)onClickCancelButtonAction:(UIButton *)cancelButton {
    !_cancelAction ?: _cancelAction();
    !_dismissAction ?: _dismissAction();
}

#pragma mark - private method

/**
 设置 messageLabel 需要显示的富文本效果

 @param config 弹窗配置
 @return 富文本内容
 */
- (NSMutableAttributedString *)messageAttributeString:(TTAlertConfig *)config {
    
    NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] initWithString:config.message];
    
    if (config.messageLineSpacing > 0) { // 行间距
        NSMutableParagraphStyle *paragraphStyle   = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.lineSpacing = config.messageLineSpacing;
        paragraphStyle.alignment = self.messageLabel.textAlignment;
        
        [attString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, config.message.length)];
    }

    // 富文本显示效果
    [config.messageAttributedConfig enumerateObjectsUsingBlock:^(TTAlertMessageAttributedConfig * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        // 遍历数组，添加展示富文本效果
        if ([obj isKindOfClass:[TTAlertMessageAttributedConfig class]]) {
            if (obj.text && obj.text.length > 0) {
                NSRange range = [config.message rangeOfString:obj.text];
             
                // 如果外部指定了 range 。就不用查找出的 range
                if (obj.range.length != 0) {
                    
                    if (obj.range.location + obj.range.length > config.message.length) {
                        NSAssert(NO, @"obj.range out of bounds");
                        return;
                    }
                    
                    range = obj.range;
                }
                
                if (obj.font) { // 字体
                    [attString addAttribute:NSFontAttributeName value:obj.font range:range];
                }
                
                if (obj.color) { // 颜色
                    [attString addAttribute:NSForegroundColorAttributeName value:obj.color range:range];
                }
            }
        }
        
    }];
    
    return attString;
}

#pragma mark - getter && setter

- (void)setConfig:(TTAlertConfig *)config {
    _config = config;
    
    // cornerRadius
    if (config.cornerRadius > 0) {
        self.layer.cornerRadius = config.cornerRadius;
        self.layer.masksToBounds = YES;
    }
    //背景
    self.backgroundColor = config.backgroundColor;
    // title
    _titleLabel.text = config.title;
    _titleLabel.textColor = config.titleColor;
    _titleLabel.font = config.titleFont;
    
    // cancel button
    [_cancelButton setTitle:config.cancelButtonConfig.title forState:UIControlStateNormal];
    [_cancelButton setTitleColor:config.cancelButtonConfig.titleColor forState:UIControlStateNormal];
    [_cancelButton.titleLabel setFont:config.cancelButtonConfig.font];
    [_cancelButton setBackgroundColor:config.cancelButtonConfig.backgroundColor];
    [_cancelButton setBackgroundImage:config.cancelButtonConfig.backgroundImage forState:UIControlStateNormal];
    if (config.cancelButtonConfig.cornerRadius > 0) {
        _cancelButton.layer.cornerRadius = config.cancelButtonConfig.cornerRadius;
        _cancelButton.layer.masksToBounds = YES;
    }
    
    // confirm button
    [_confirmButton setTitle:config.confirmButtonConfig.title forState:UIControlStateNormal];
    [_confirmButton setTitleColor:config.confirmButtonConfig.titleColor forState:UIControlStateNormal];
    [_confirmButton.titleLabel setFont:config.confirmButtonConfig.font];
    [_confirmButton setBackgroundColor:config.confirmButtonConfig.backgroundColor];
    [_confirmButton setBackgroundImage:config.confirmButtonConfig.backgroundImage forState:UIControlStateNormal];
    if (config.confirmButtonConfig.cornerRadius > 0) {
        _confirmButton.layer.cornerRadius = config.confirmButtonConfig.cornerRadius;
        _confirmButton.layer.masksToBounds = YES;
    }
    
    // message
    _messageLabel.font = config.messageFont;
    _messageLabel.textColor = config.messageColor;
    
    if (config.messageAttributedConfig.count > 0) {
        _messageLabel.attributedText = [self messageAttributeString:config];
    } else {
        _messageLabel.text = config.message;
    }
    
    // 如果是轻寻项目
    if (projectType() == ProjectType_LookingLove) {
        _cancelButton.layer.borderColor = UIColorFromRGB(0xB3B3B3).CGColor;
        _cancelButton.layer.borderWidth = 2;
        
        _confirmButton.layer.borderColor = [XCTheme getTTMainTextColor].CGColor;
        _confirmButton.layer.borderWidth = 2.f;
    }
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLabel ;
}

- (UILabel *)messageLabel {
    if (!_messageLabel) {
        _messageLabel = [[UILabel alloc] init];
        _messageLabel.numberOfLines = 0;
        _messageLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _messageLabel;
}

- (UIButton *)cancelButton {
    if (!_cancelButton) {
        _cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_cancelButton addTarget:self action:@selector(onClickCancelButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancelButton;
}

- (UIButton *)confirmButton {
    if (!_confirmButton) {
        _confirmButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_confirmButton addTarget:self action:@selector(onClickConfirmButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _confirmButton;
}

@end
