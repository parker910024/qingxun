//
//  MSAlertView.m
//  XCChatViewKit
//
//  Created by KevinWang on 2019/1/24.
//  Copyright © 2019 YiZhuan. All rights reserved.
//

#import "MSAlertView.h"
#import "XCTheme.h"
#import <Masonry.h>
#import "XCMacros.h"
#import "UIImage+Utils.h"

@interface MSAlertView()

@property (nonatomic, strong) UILabel *tipLabel;
@property (nonatomic, strong) UILabel *messageLabel;
@property (nonatomic, strong) UIButton *cancleButton;
@property (nonatomic, strong) UIButton *sureButton;

@property (nonatomic, copy) NSMutableAttributedString *message;
@property (nonatomic, copy) NSString *cancleTitle;
@property (nonatomic, copy) NSString *sureTitle;

@end

@implementation MSAlertView

#pragma mark - Life Style
- (instancetype)initWithFrame:(CGRect)frame
                 alertMessage:(NSMutableAttributedString *)message
                  cancleTitle:(NSString *)cancleTitle
                    sureTitle:(NSString *)sureTitle{
    
    if (self=[super initWithFrame:frame]) {
        _message = message;
        _cancleTitle = cancleTitle;
        _sureTitle = sureTitle;
        [self setupSubviews];
        [self setupSubviewsConstraints];
        [self setData];
    }
    return self;
}

#pragma mark - event response
- (void)sure{
    if ([self.delegate respondsToSelector:@selector(alertViewDidClickSureButton:)]) {
        [self.delegate alertViewDidClickSureButton:self];
    }
}
- (void)cancle{
    if ([self.delegate respondsToSelector:@selector(alertViewDidClickCancleButton:)]) {
        [self.delegate alertViewDidClickCancleButton:self];
    }
}


#pragma mark - Private

- (void)setData{
    self.tipLabel.text = @"提示";
    self.messageLabel.attributedText = self.message;
    [self.cancleButton setTitle:self.cancleTitle forState:UIControlStateNormal];
    [self.sureButton setTitle:self.sureTitle forState:UIControlStateNormal];
}

- (void)setupSubviews{
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = 20.0;
    [self addSubview:self.tipLabel];
    self.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.messageLabel];
    [self addSubview:self.cancleButton];
    [self addSubview:self.sureButton];
    
    if (projectType() == ProjectType_Haha) { // haha
        [self.cancleButton setTitleColor:UIColorFromRGB(0x333333) forState:UIControlStateNormal];
        self.cancleButton.backgroundColor = RGBCOLOR(230, 230, 230);
        self.cancleButton.titleLabel.font = [UIFont systemFontOfSize:14.0];
        
        
        self.sureButton.backgroundColor = [XCTheme getMainDefaultColor];
        [self.sureButton setBackgroundImage:[UIImage new] forState:UIControlStateNormal];
        self.sureButton.titleLabel.textColor = [UIColor whiteColor];
        self.sureButton.titleLabel.font = [UIFont systemFontOfSize:14.0];
        
        self.layer.cornerRadius = 10;
        
        self.cancleButton.layer.cornerRadius = 5;
        self.sureButton.layer.cornerRadius = 5;
    }
}
- (void)setupSubviewsConstraints{
    
    [self.tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.top.equalTo(self).offset(20);
    }];
    [self.messageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.top.equalTo(self.tipLabel.mas_bottom).offset(15);
    }];
    
    if (projectType() == ProjectType_Haha) { // haha
        [self.cancleButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self).offset(-20);
            make.width.equalTo(@140);
            make.height.equalTo(@38);
            make.left.equalTo(self).offset(8);
        }];
        [self.sureButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.width.height.equalTo(self.cancleButton);
            make.right.equalTo(self).offset(-8);
        }];
    } else { // mengshen
        [self.cancleButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self).offset(-18);
            make.width.equalTo(@100);
            make.height.equalTo(@40);
            make.right.equalTo(self.mas_centerX).offset(-10);
        }];
        [self.sureButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.width.height.equalTo(self.cancleButton);
            make.left.equalTo(self.mas_centerX).offset(10);
        }];
    }
    
}

#pragma mark - Getter
- (UILabel *)tipLabel{
    if (!_tipLabel) {
        _tipLabel = [[UILabel alloc] init];
        _tipLabel.numberOfLines = 1;
        _tipLabel.font = [UIFont boldSystemFontOfSize:17.0];
        _tipLabel.textColor = UIColorFromRGB(0x333333);
        _tipLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _tipLabel;
}
- (UILabel *)messageLabel{
    if (!_messageLabel) {
        _messageLabel = [[UILabel alloc] init];
        _messageLabel.numberOfLines = 0;
        _messageLabel.font = [UIFont systemFontOfSize:14.0];
        _messageLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _messageLabel;
}
- (UIButton *)cancleButton{
    if (!_cancleButton) {
        _cancleButton = [[UIButton alloc] init];
        _cancleButton.backgroundColor = UIColorFromRGB(0xE6E6E6);
        [_cancleButton setTitleColor:UIColorFromRGB(0x999999) forState:UIControlStateNormal];
        _cancleButton.titleLabel.font = [UIFont systemFontOfSize:15.0];
        _cancleButton.layer.masksToBounds = YES;
        _cancleButton.layer.cornerRadius = 20.0;
        [_cancleButton addTarget:self action:@selector(cancle) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancleButton;
}
- (UIButton *)sureButton{
    if (!_sureButton) {
        _sureButton = [[UIButton alloc] init];
        UIImage *image = [UIImage gradientColorImageFromColors:@[UIColorFromRGB(0x735BFE),UIColorFromRGB(0x8E61FF)] gradientType:GradientTypeLeftToRight imgSize:CGSizeMake(140, 40)];
        [_sureButton setBackgroundImage:image forState:UIControlStateNormal];
        [_sureButton setTitleColor:UIColorFromRGB(0xffffff) forState:UIControlStateNormal];
        _sureButton.titleLabel.font = [UIFont systemFontOfSize:15.0];
        _sureButton.layer.masksToBounds = YES;
        _sureButton.layer.cornerRadius = 20.0;
        [_sureButton addTarget:self action:@selector(sure) forControlEvents:UIControlEventTouchUpInside];
    }
    return _sureButton;
}

@end
