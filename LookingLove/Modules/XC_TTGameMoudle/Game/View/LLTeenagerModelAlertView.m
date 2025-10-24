//
//  LLTeenagerModelAlertView.m
//  XC_TTGameMoudle
//
//  Created by lee on 2019/7/28.
//  Copyright © 2019 YiZhuan. All rights reserved.
//

#import "LLTeenagerModelAlertView.h"
#import <Masonry/Masonry.h>
#import "XCTheme.h"
#import "XCMacros.h"
#import "UIView+ZJFrame.h"
#import "UIView+XCToast.h"
#import "UIButton+EnlargeTouchArea.h"

@interface LLTeenagerModelAlertView ()
@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UILabel *textLabel;
@property (nonatomic, strong) UIButton *teeagersButton;
@property (nonatomic, strong) UIButton *closeButton;
@end

@implementation LLTeenagerModelAlertView

#pragma mark -
#pragma mark lifeCycle
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initViews];
        [self initConstraints];
    }
    return self;
}

- (void)initViews {
    
    [self addSubview:self.bgView];
    [self addSubview:self.closeButton];
    
    [self.bgView addSubview:self.iconImageView];
    [self.bgView addSubview:self.textLabel];
    [self.bgView addSubview:self.teeagersButton];
}

- (void)initConstraints {
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self);
    }];
    
    [self.closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.mas_equalTo(self).inset(10);
        make.width.height.mas_equalTo(25);
    }];
    
    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self);
        make.top.mas_equalTo(33);
        make.width.mas_equalTo(57);
        make.height.mas_equalTo(52);
    }];
    
    [self.textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.iconImageView.mas_bottom).offset(20);
        make.left.right.mas_equalTo(self.bgView).inset(35);
    }];
    
    [self.teeagersButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.bgView);
        make.bottom.mas_equalTo(-38);
    }];
}

#pragma mark -
#pragma mark SystemApi Delegate

#pragma mark -
#pragma mark CustomView Delegate

#pragma mark -
#pragma mark CoreClients

#pragma mark -
#pragma mark Event Response
- (void)onClickCloseButtonAction:(UIButton *)closeButton {
    if (self.delegate && [self.delegate respondsToSelector:@selector(hiddeView:)]) {
        [self.delegate hiddeView:self];
    }
}

- (void)onClickTeeagersButtonAction:(UIButton *)teeagersButton {
    if (self.delegate && [self.delegate respondsToSelector:@selector(didClickTeenagerButtonAction:)]) {
        [self.delegate didClickTeenagerButtonAction:teeagersButton];
    }
}

#pragma mark -
#pragma mark Public Methods

#pragma mark -
#pragma mark Private Methods

#pragma mark -
#pragma mark Getters and Setters
- (UIView *)bgView {
    if (!_bgView) {
        _bgView = [[UIView alloc] init];
        _bgView.backgroundColor = [UIColor whiteColor];
        _bgView.layer.cornerRadius = 8;
        _bgView.layer.masksToBounds = YES;
    }
    return _bgView;
}

- (UIButton *)closeButton {
    if (!_closeButton) {
        _closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_closeButton setImage:[UIImage imageNamed:@"teeagerAlert_close"] forState:UIControlStateNormal];
        [_closeButton addTarget:self action:@selector(onClickCloseButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [_closeButton setEnlargeEdgeWithTop:15 right:15 bottom:15 left:15];
    }
    return _closeButton;
}

- (UIImageView *)iconImageView {
    if (!_iconImageView) {
        _iconImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"meInfo_parents_mode_icon"]];
    }
    return _iconImageView;
}

- (UILabel *)textLabel {
    if (!_textLabel) {
        _textLabel = [[UILabel alloc] init];
        _textLabel.font = [UIFont systemFontOfSize:14];
        _textLabel.textColor = [XCTheme getTTMainTextColor];
        _textLabel.numberOfLines = 0;
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        [paragraphStyle setLineSpacing:8];        //设置行间距
        
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:@"为呵护青少年健康成长，轻寻推出“青少年模式”，该模式下针对青少年推送精选优化的内容。"];
        [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [attributedString length])];
        _textLabel.attributedText = attributedString;
    }
    return _textLabel;
}

- (UIButton *)teeagersButton {
    if (!_teeagersButton) {
        _teeagersButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_teeagersButton setTitle:@"设置青少年模式" forState:UIControlStateNormal];
        [_teeagersButton setImage:[UIImage imageNamed:@"teeagerAlert_arrow"] forState:UIControlStateNormal];
        if (projectType() == ProjectType_Planet) {
            [_teeagersButton setTitleColor:XCTheme.getTTMainColor forState:UIControlStateNormal];
        } else {
            [_teeagersButton setTitleColor:UIColorFromRGB(0x01D39F) forState:UIControlStateNormal];
        }
        [_teeagersButton addTarget:self action:@selector(onClickTeeagersButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        _teeagersButton.transform = CGAffineTransformMakeScale(-1.0, 1.0);
        _teeagersButton.titleLabel.transform = CGAffineTransformMakeScale(-1.0, 1.0);
        _teeagersButton.imageView.transform = CGAffineTransformMakeScale(-1.0, 1.0);
        _teeagersButton.imageEdgeInsets = UIEdgeInsetsMake(0, -10, 0, 0);
    }
    return _teeagersButton;
}

@end
