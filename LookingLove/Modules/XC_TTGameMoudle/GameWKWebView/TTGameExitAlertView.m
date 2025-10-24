//
//  TTGameExitAlertView.m
//  TuTu
//
//  Created by zoey on 2018/11/19.
//  Copyright © 2018年 YiZhuan. All rights reserved.
//

#import "TTGameExitAlertView.h"

#import "XCTheme.h"
#import <Masonry/Masonry.h>

@interface TTGameExitAlertView()
@property (strong , nonatomic) void(^cancelKTVAlert)(void);
@property (strong , nonatomic) void(^ensureKTVAlert)(void);

@property (nonatomic, strong) UIView *backView;
@property (strong , nonatomic) NSString *message;
@property (strong , nonatomic) UILabel *titleLabel;
@property (strong , nonatomic) UILabel *messageLabel;
@property (strong , nonatomic) UIButton *cancelBtn;
@property (strong , nonatomic) UIButton *ensureBtn;
@end

@implementation TTGameExitAlertView


- (instancetype)initWithFrame:(CGRect)frame title:(NSString *)title message:(NSString *)message cancel:(void(^)(void))cancel ensure:(void(^)(void))ensure{
    if (self = [super initWithFrame:frame]) {
        
        self.titleLabel.text = title;
        self.cancelKTVAlert = cancel;
        self.ensureKTVAlert = ensure;
        
        self.messageLabel.text = message;
        
        [self initSubViews];
    }
    return self;
}

- (void)initSubViews {
//    self.backgroundColor = UIColorRGBAlpha(0x000000, 0.6);
    
    [self addSubview:self.backView];
    
    [self.backView addSubview:self.titleLabel];
    [self.backView addSubview:self.messageLabel];
    [self.backView addSubview:self.cancelBtn];
    [self.backView addSubview:self.ensureBtn];
    
    [self.backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(295, 173));
        make.left.mas_equalTo(0);
        make.top.mas_equalTo(0);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.backView).offset(29);
        make.centerX.mas_equalTo(self.backView);
        make.width.mas_lessThanOrEqualTo(280);
    }];
    
    [self.messageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.titleLabel.mas_bottom).offset(17);
        make.centerX.mas_equalTo(self.backView);
        make.width.mas_lessThanOrEqualTo(260);
    }];
    
    
    
//    [self.cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.mas_equalTo(self).offset(5);
//        make.bottom.mas_equalTo(self).offset(-15);
//        make.height.mas_equalTo(38);
//        make.width.mas_equalTo(self.ensureBtn);
//        make.right.mas_equalTo(self.ensureBtn.mas_left).offset(-5);
//    }];
//    [self.ensureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.right.mas_equalTo(self).offset(-5);
//        make.height.bottom.mas_equalTo(self.cancelBtn);
//    }];
    
}

#pragma mark - Event
- (void)onClickEnsureBtn:(UIButton *)btn {
    !self.ensureKTVAlert?:self.ensureKTVAlert();
}


- (void)onClickCancelBtn:(UIButton *)btn {
    !self.cancelKTVAlert?:self.cancelKTVAlert();
}


#pragma mark - Getter && Setter

- (UIView *)backView{
    if (!_backView) {
        _backView = [[UIView alloc] init];
        _backView.backgroundColor = UIColor.whiteColor;
        _backView.layer.cornerRadius = 8;
        _backView.layer.masksToBounds = YES;
    }
    return _backView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.text = @"";
        _titleLabel.font = [UIFont systemFontOfSize:16];
        _titleLabel.textColor = [XCTheme getTTMainTextColor];
    }
    return _titleLabel;
}

- (UILabel *)messageLabel {
    if (!_messageLabel) {
        _messageLabel = [[UILabel alloc] init];
        _messageLabel.numberOfLines = 0;
        _messageLabel.textAlignment = NSTextAlignmentCenter;
        _messageLabel.font = [UIFont systemFontOfSize:14];
        _messageLabel.textColor = [XCTheme getTTMainTextColor];
    }
    return _messageLabel;
}

- (UIButton *)cancelBtn {
    if (!_cancelBtn) {
        _cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _cancelBtn.frame = CGRectMake(15, 173 - 15 - 38, (295 - 35) / 2, 38);
        [_cancelBtn setTitle:@"认输退出" forState:UIControlStateNormal];
        [_cancelBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        
        CAGradientLayer *gradient = [CAGradientLayer layer];
        gradient.frame = _cancelBtn.bounds;
        gradient.colors = @[(id)UIColorFromRGB(0xFC6C6F).CGColor,(id)UIColorFromRGB(0xFF9169).CGColor];
        gradient.startPoint = CGPointMake(0, 0.5);
        gradient.endPoint = CGPointMake(1, 0.5);
        [_cancelBtn.layer addSublayer:gradient];
        
        _cancelBtn.layer.cornerRadius = 19;
        _cancelBtn.layer.masksToBounds = YES;
        _cancelBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [_cancelBtn addTarget:self action:@selector(onClickCancelBtn:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancelBtn;
}

- (UIButton *)ensureBtn {
    if (!_ensureBtn) {
        _ensureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_ensureBtn setTitle:@"继续游戏" forState:UIControlStateNormal];
        _ensureBtn.frame = CGRectMake(295 - 12 - (295 - 35) / 2, 173 - 15 - 38, (295 - 35) / 2, 38);
        [_ensureBtn setTitleColor:UIColorFromRGB(0xffffff) forState:UIControlStateNormal];
        
        CAGradientLayer *gradient = [CAGradientLayer layer];
        gradient.frame = _ensureBtn.bounds;
        gradient.colors = @[(id)UIColorFromRGB(0x05C7C7).CGColor,(id)UIColorFromRGB(0x57EDC2).CGColor];
        gradient.startPoint = CGPointMake(0, 0.5);
        gradient.endPoint = CGPointMake(1, 0.5);
        [_ensureBtn.layer addSublayer:gradient];
        
        _ensureBtn.layer.cornerRadius = 19;
        _ensureBtn.layer.masksToBounds = YES;
        _ensureBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [_ensureBtn addTarget:self action:@selector(onClickEnsureBtn:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _ensureBtn;
}

@end
