//
//  TTBindSuccessView.m
//  TuTu
//
//  Created by lee on 2018/11/7.
//  Copyright © 2018 YiZhuan. All rights reserved.
//

#import "TTBindSuccessView.h"

#import <Masonry/Masonry.h>
#import "XCTheme.h"
#import "XCMacros.h"
#import "XCCurrentVCStackManager.h"

#import "UIView+ZJFrame.h"
#import "UIView+XCToast.h"

#import "TTPopup.h"

@interface TTBindSuccessView ()

@property (nonatomic, strong) UIImageView *successImageView;
@property (nonatomic, strong) UILabel *textLabel;
@property (nonatomic, strong) UIButton *closeBtn;

@end

@implementation TTBindSuccessView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self baseUI];
        [self initViews];
        [self initConstraints];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
}

#pragma mark -
#pragma mark lifeCycle
- (void)baseUI {
    self.layer.cornerRadius = 8.f;
    self.layer.masksToBounds = YES;
    self.backgroundColor = [UIColor whiteColor];
}
- (void)initViews {
    [self addSubview:self.successImageView];
    [self addSubview:self.textLabel];
    [self addSubview:self.closeBtn];
}

- (void)initConstraints {
    [self.successImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(18);
        make.centerX.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(76, 76));
    }];
    
    [self.textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.top.mas_equalTo(self.successImageView.mas_bottom).offset(7);
    }];
    
    [self.closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.top.mas_equalTo(self.textLabel.mas_bottom).offset(22);
        make.height.mas_equalTo(38);
        make.width.mas_equalTo(124);
    }];
}

#pragma mark -
#pragma mark private methods
+ (void)showBindSuccessViewWithHandler:(TTBindViewDismissHandler)handler {
    TTBindSuccessView *bindSuccessView = [[TTBindSuccessView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth - 64, 195)];
    bindSuccessView.dismissHandler = handler;
    
    [TTPopup popupView:bindSuccessView style:TTPopupStyleAlert];
}

#pragma mark -
#pragma mark button click events
- (void)closeBtnClickAction:(UIButton *)btn {
    
    [TTPopup dismiss];
    !_dismissHandler ? : _dismissHandler();
}

#pragma mark -
#pragma mark getter & setter
- (UIImageView *)successImageView
{
    if (!_successImageView) {
        _successImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Binding_successIcon"]];
    }
    return _successImageView;
}

- (UILabel *)textLabel
{
    if (!_textLabel) {
        _textLabel = [[UILabel alloc] init];
        _textLabel.text = @"恭喜您！绑定成功";
        _textLabel.textColor = [XCTheme getMSMainTextColor];
        _textLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:17];
        _textLabel.adjustsFontSizeToFitWidth = YES;
        _textLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _textLabel;
}

- (UIButton *)closeBtn {
    if (!_closeBtn) {
        _closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_closeBtn setTitle:@"关闭" forState:UIControlStateNormal];
        [_closeBtn setTitleColor:[XCTheme getTTMainColor] forState:UIControlStateNormal];
        [_closeBtn setBackgroundColor:UIColorFromRGB(0xF0F0F0)];
        [_closeBtn.titleLabel setFont:[UIFont systemFontOfSize:15.f]];
        _closeBtn.layer.masksToBounds = YES;
        _closeBtn.layer.cornerRadius = 19;
        [_closeBtn addTarget:self action:@selector(closeBtnClickAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _closeBtn;
}

@end
