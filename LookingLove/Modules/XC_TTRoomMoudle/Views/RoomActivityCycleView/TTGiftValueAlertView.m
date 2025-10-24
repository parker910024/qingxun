
//
//  TTGiftValueAlertView.m
//  XC_TTRoomMoudle
//
//  Created by lee on 2019/4/26.
//  Copyright © 2019 YiZhuan. All rights reserved.
//

#import "TTGiftValueAlertView.h"
#import <Masonry/Masonry.h>
#import "XCTheme.h"
#import "XCMacros.h"
#import "UIView+ZJFrame.h"

@interface TTGiftValueAlertView ()
// 标题
@property (nonatomic, strong) UILabel *titleLabel;
// 内容
@property (nonatomic, strong) UILabel *textLabel;
// 不再显示按钮
@property (nonatomic, strong) UIButton *notShowNextTimeBtn;
// ok
@property (nonatomic, strong) UIButton *enterBtn;
// cancel
@property (nonatomic, strong) UIButton *cancelBtn;

@end

@implementation TTGiftValueAlertView

#pragma mark -
#pragma mark - lifeCycle
- (instancetype)initWithFrame:(CGRect)frame text:(NSString *)text {
    self = [super initWithFrame:frame];
    if (self) {
        [self initViews];
        [self initConstraints];
        _textLabel.text = text;
        self.backgroundColor = UIColor.whiteColor;
        self.layer.cornerRadius = 14;
        self.layer.masksToBounds = YES;
    }
    return self;
}

- (void)initViews {
    [self addSubview:self.titleLabel];
    [self addSubview:self.textLabel];
    [self addSubview:self.notShowNextTimeBtn];
    [self addSubview:self.enterBtn];
    [self addSubview:self.cancelBtn];
}

- (void)initConstraints {
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(30);
        make.centerX.mas_equalTo(self);
    }];
    
    [self.textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.titleLabel.mas_bottom).offset(16);
        make.left.right.mas_equalTo(self).inset(44);
    }];
    
    [self.notShowNextTimeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.textLabel.mas_bottom).offset(26);
        make.centerX.mas_equalTo(self);
    }];
    
    [self.cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.right.mas_equalTo(self.mas_centerX).offset(-8);
        make.top.mas_equalTo(self.notShowNextTimeBtn.mas_bottom).offset(22);
        make.height.mas_equalTo(38);
    }];
    
    [self.enterBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.top.mas_equalTo(self.cancelBtn);
        make.right.mas_equalTo(-20);
        make.left.mas_equalTo(self.mas_centerX).offset(8);
    }];
}

#pragma mark -
#pragma mark clients

#pragma mark -
#pragma mark private methods

#pragma mark -
#pragma mark button click events
- (void)onEnterBtnClickAction:(UIButton *)enterBtn {
    // 将下次是否还要再显示的勾选传递出去。根据业务逻辑不同，各自处理。
    !_enterHandler ?: _enterHandler(self.notShowNextTimeBtn.selected);
}

- (void)onCancelBtnClickAction:(UIButton *)cancelBtn {
    // 点击取消当然是直接消失。写多一个只是为了预留。
    !_cancelHandler ?: _cancelHandler();
}

- (void)onNotShowNextTimeBtnClickAction:(UIButton *)notShowNextTimeBtn {
    notShowNextTimeBtn.selected = !notShowNextTimeBtn.selected;
}

#pragma mark -
#pragma mark getter & setter
- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.text = @"提示";
        _titleLabel.textColor = [XCTheme getTTMainTextColor];
        _titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:16];
        _titleLabel.adjustsFontSizeToFitWidth = YES;
    }
    return _titleLabel;
}

- (UILabel *)textLabel {
    if (!_textLabel) {
        _textLabel = [[UILabel alloc] init];
        _textLabel.text = @"关闭礼物值将会清除当前麦上所有礼物值数据，确认关闭吗? ";
        _textLabel.textColor = [XCTheme getTTMainTextColor];
        _textLabel.font = [UIFont systemFontOfSize:14];
        _textLabel.adjustsFontSizeToFitWidth = YES;
        _textLabel.numberOfLines = 0;
    }
    return _textLabel;
}

- (UIButton *)notShowNextTimeBtn {
    if (!_notShowNextTimeBtn) {
        _notShowNextTimeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_notShowNextTimeBtn setTitle:@"不再提示" forState:UIControlStateNormal];
        [_notShowNextTimeBtn setTitleColor:[XCTheme getTTDeepGrayTextColor] forState:UIControlStateNormal];
        [_notShowNextTimeBtn.titleLabel setFont:[UIFont systemFontOfSize:13]];
        [_notShowNextTimeBtn setImage:[UIImage imageNamed:@"giftValue_notShowBtn_normal"] forState:UIControlStateNormal];
        [_notShowNextTimeBtn setImage:[UIImage imageNamed:@"giftValue_notShowBtn_select"] forState:UIControlStateSelected];
        [_notShowNextTimeBtn addTarget:self action:@selector(onNotShowNextTimeBtnClickAction:) forControlEvents:UIControlEventTouchUpInside];
        _notShowNextTimeBtn.imageEdgeInsets = UIEdgeInsetsMake(0, -6, 0, 0);
        _notShowNextTimeBtn.selected = NO;
    }
    return _notShowNextTimeBtn;
}

- (UIButton *)cancelBtn {
    if (!_cancelBtn) {
        _cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_cancelBtn setBackgroundColor:UIColorFromRGB(0xFEF5ED)];
        [_cancelBtn setTitleColor:[XCTheme getTTMainColor] forState:UIControlStateNormal];
        [_cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
        [_cancelBtn.titleLabel setFont:[UIFont systemFontOfSize:15]];
        _cancelBtn.layer.cornerRadius = 19.f;
        _cancelBtn.layer.masksToBounds = YES;
        [_cancelBtn addTarget:self action:@selector(onCancelBtnClickAction:) forControlEvents:UIControlEventTouchUpInside];
        
        if (projectType() == ProjectType_LookingLove) {
            [_cancelBtn setTitleColor:UIColorFromRGB(0x000000) forState:UIControlStateNormal];
            _cancelBtn.backgroundColor = UIColorFromRGB(0xFFFFFF);
            _cancelBtn.layer.borderWidth = 2;
            _cancelBtn.layer.borderColor = UIColorFromRGB(0xB3B3B3).CGColor;
        }
    }
    return _cancelBtn;
}

- (UIButton *)enterBtn {
    if (!_enterBtn) {
        _enterBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_enterBtn setBackgroundColor:[XCTheme getTTMainColor]];
        [_enterBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        [_enterBtn setTitle:@"确认" forState:UIControlStateNormal];
        [_enterBtn.titleLabel setFont:[UIFont systemFontOfSize:15]];
        _enterBtn.layer.cornerRadius = 19.f;
        _enterBtn.layer.masksToBounds = YES;
        [_enterBtn addTarget:self action:@selector(onEnterBtnClickAction:) forControlEvents:UIControlEventTouchUpInside];
        
        if (projectType() == ProjectType_LookingLove) {
            [_enterBtn setTitleColor:UIColorFromRGB(0x000000) forState:UIControlStateNormal];
            _enterBtn.layer.borderWidth = 2;
            _enterBtn.layer.borderColor = UIColorFromRGB(0x000000).CGColor;
        }
    }
    return _enterBtn;
}

@end
