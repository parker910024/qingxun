//
//  XCRoomTeenagerModeAlertView.m
//  XCChatViewKit
//
//  Created by lee on 2019/8/8.
//  Copyright © 2019 YiZhuan. All rights reserved.
//

#import "XCRoomTeenagerModeAlertView.h"
#import <Masonry/Masonry.h>
#import "XCTheme.h"
#import "XCMacros.h"
#import "XCAlertControllerCenter.h"
#import "UIImage+Utils.h"

@interface XCRoomTeenagerModeAlertView ()

@property (nonatomic, copy) NSString *resMsg;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *textLabel;
@property (nonatomic, strong) UIButton *confirmButton;

@end

@implementation XCRoomTeenagerModeAlertView

#pragma mark -
#pragma mark lifeCycle
- (instancetype)initWithFrame:(CGRect)frame resMessage:(NSString *)resMsg {
    self = [super initWithFrame:frame];
    if (self) {
        _resMsg = resMsg;
        [self initViews];
        [self initConstraints];
        self.backgroundColor = UIColor.whiteColor;
    }
    return self;
}

- (void)initViews {
    [self addSubview:self.titleLabel];
    [self addSubview:self.textLabel];
    [self addSubview:self.confirmButton];
}

- (void)initConstraints {
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(15);
        make.centerX.mas_equalTo(self);
    }];
    
    [self.textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self).inset(40);
        make.top.mas_equalTo(self.titleLabel.mas_bottom).offset(15);
    }];

    [self.confirmButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(-20);
        make.size.mas_equalTo(CGSizeMake(140, 38));
        make.centerX.mas_equalTo(self);
    }];
}

- (void)layoutSubviews {
    [super layoutSubviews];

    self.layer.cornerRadius = 10;
    self.layer.masksToBounds = YES;

}
#pragma mark -
#pragma mark SystemApi Delegate

#pragma mark -
#pragma mark CustomView Delegate

#pragma mark -
#pragma mark CoreClients

#pragma mark -
#pragma mark Event Response

#pragma mark -
#pragma mark Public Methods

#pragma mark -
#pragma mark Private Methods
- (void)onClickConfirmButtonAction:(UIButton *)confirmButton {
    [[XCAlertControllerCenter defaultCenter] dismissAlertNeedBlock:NO];
    
    !_roomTeenagerModeAlertBlock ?: _roomTeenagerModeAlertBlock();
}
#pragma mark -
#pragma mark Getters and Setters
- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.text = @"提示";
        _titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:17];
        _titleLabel.textColor = [XCTheme getTTMainTextColor];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLabel;
}

- (UILabel *)textLabel {
    if (!_textLabel) {
        _textLabel = [[UILabel alloc] init];
        _textLabel.numberOfLines = 0;
        _textLabel.font = [UIFont systemFontOfSize:14];
        _textLabel.textColor = [XCTheme getTTMainTextColor];
        _textLabel.text = _resMsg;

        NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
        style.lineSpacing = 5;

        NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:_textLabel.text];
        [string addAttribute:NSParagraphStyleAttributeName value:style range:NSMakeRange(0, [_textLabel.text length])];
        _textLabel.attributedText = string;
    }
    return _textLabel;
}

- (UIButton *)confirmButton {
    if (!_confirmButton) {
        _confirmButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_confirmButton setTitle:@"确定" forState:UIControlStateNormal];
        [_confirmButton.titleLabel setFont:[UIFont systemFontOfSize:15]];
        _confirmButton.layer.cornerRadius = 19.f;
        _confirmButton.layer.masksToBounds = YES;
        [_confirmButton addTarget:self action:@selector(onClickConfirmButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        if (projectType() == ProjectType_BB) { // 萌圈
            UIImage *image = [UIImage gradientColorImageFromColors:@[UIColorFromRGB(0x6C62F5), UIColorFromRGB(0x8569FF)] gradientType:GradientTypeLeftToRight imgSize:CGSizeMake(KScreenWidth - 30, 40)];
            [_confirmButton setBackgroundImage:image forState:UIControlStateNormal];
        } if (projectType() == ProjectType_LookingLove) { // 轻寻
            [_confirmButton setBackgroundColor:[XCTheme getTTMainColor]];
            _confirmButton.layer.borderWidth = 2;
            _confirmButton.layer.borderColor = [XCTheme getTTMainTextColor].CGColor;
            [_confirmButton setTitleColor:[XCTheme getTTMainTextColor] forState:UIControlStateNormal];
        } else {
            [_confirmButton setBackgroundColor:UIColorFromRGB(0x42A8FA)];
        }
    }
    return _confirmButton;
}


@end
