//
//  TTEnterPaymentPWView.m
//  TuTu
//
//  Created by Macx on 2018/11/8.
//  Copyright © 2018年 YiZhuan. All rights reserved.
//

#import "TTEnterPaymentPWView.h"

//t
#import <Masonry/Masonry.h>
#import "XCTheme.h"
#import "XCMacros.h"

NSInteger kPayPWMaxLength = 6;

@interface TTEnterPaymentPWView()
@property (nonatomic, strong) UIButton  *closeBtn;//
@property (nonatomic, strong) UIButton  *forgetBtn;//
@property (nonatomic, strong) UILabel  *titleLabel;//
@property (nonatomic, strong) UIView   *lineView;//
@property (nonatomic, strong) UIView  *contianterView;//
//@property (nonatomic, strong) NSMutableArray<UIView *>  *placeViews;//
@property (nonatomic, strong) NSMutableArray<UIView *>  *maskViews;//小黑点
@end

@implementation TTEnterPaymentPWView


- (instancetype)init {
    if (self = [super init]) {
        self.frame = CGRectMake(0, 0, KScreenWidth, 150);
        [self initSubViews];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initSubViews];
    }
    return self;
}


- (void)initSubViews {
    self.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.closeBtn];
    [self addSubview:self.forgetBtn];
    [self addSubview:self.titleLabel];
    [self addSubview:self.lineView];
    [self addSubview:self.contianterView];
    
    
    [self.closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self).offset(10);
        make.top.mas_equalTo(self).offset(11);
        make.height.width.mas_equalTo(22);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self);
        make.top.mas_equalTo(self).offset(24);
    }];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self);
        make.top.mas_equalTo(self).offset(44);
        make.height.mas_equalTo(0.5);
    }];
    
    [self.contianterView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self).offset(15);
        make.right.mas_equalTo(self).offset(-15);
        make.height.mas_equalTo(45);
        make.top.mas_equalTo(self.lineView.mas_bottom).offset(15);
    }];
    
    [self.forgetBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self).offset(-15);
        make.top.mas_equalTo(self.contianterView.mas_bottom).offset(3);
    }];
    
    CGFloat width = (KScreenWidth-30)/kPayPWMaxLength;
    
    for (int i = 0; i<kPayPWMaxLength; i++) {
        UIView *placeView = [[UIView alloc] init];
        placeView.layer.borderColor = UIColorFromRGB(0xC0C0C0).CGColor;
        placeView.layer.borderWidth = 0.5;
        [self.contianterView addSubview:placeView];
        [placeView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.contianterView).offset(width*i);
            make.width.mas_equalTo(width);
            make.height.mas_equalTo(45);
            make.top.mas_equalTo(self.contianterView);
        }];
        
        UIView *maskView = [[UIView alloc] init];
        maskView.backgroundColor = [UIColor blackColor];
        maskView.layer.masksToBounds = YES;
        maskView.hidden = YES;
        maskView.layer.cornerRadius = 2;
        [placeView addSubview:maskView];
        [maskView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.mas_equalTo(placeView);
            make.width.height.mas_equalTo(4);
        }];
        
        [self.maskViews addObject:maskView];
    }
    
    
}

#pragma mark - Event

- (void)closeBtnAction {
    if (self.delegate && [self.delegate respondsToSelector:@selector(closePassword)])  {
        [self.delegate closePassword];
    }
}

- (void)forgetBtnAction {
    if (self.delegate && [self.delegate respondsToSelector:@selector(forgetPassword)])  {
        [self.delegate forgetPassword];
    }
}


#pragma mark - Getter && Setter

- (void)setInputLength:(NSUInteger)inputLength {
    _inputLength = inputLength;
    
    if (_inputLength > kPayPWMaxLength) {
        return;
    }
    
    for (int i = 0; i< kPayPWMaxLength; i++) {
        if (i < _inputLength) {
            self.maskViews[i].hidden = NO;
        }else {
            self.maskViews[i].hidden = YES;
        }
    }
    
}

- (UIButton *)closeBtn {
    if (!_closeBtn) {
        _closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_closeBtn addTarget:self action:@selector(closeBtnAction) forControlEvents:UIControlEventTouchUpInside];
        [_closeBtn setImage:[UIImage imageNamed:@"close_card_logo"] forState:UIControlStateNormal];
        
    }
    return _closeBtn;
}

- (UIButton *)forgetBtn {
    if (!_forgetBtn) {
        _forgetBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_forgetBtn addTarget:self action:@selector(forgetBtnAction) forControlEvents:UIControlEventTouchUpInside];
        [_forgetBtn setTitle:@"忘记密码?" forState:UIControlStateNormal];
        [_forgetBtn setTitleColor:UIColorFromRGB(0x129AF1) forState:UIControlStateNormal];
        _forgetBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    }
    return _forgetBtn;
}

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = UIColorFromRGB(0xF0F0F0);
    }
    return _lineView;
}

- (UIView *)contianterView {
    if (!_contianterView) {
        _contianterView = [[UIView alloc] init];
        _contianterView.layer.masksToBounds = YES;
        _contianterView.layer.cornerRadius = 5;
        _contianterView.layer.borderColor = UIColorFromRGB(0xF5F5F5).CGColor;
        _contianterView.layer.borderWidth = 0.5;
    }
    return _contianterView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.text = @"输入密码";
        _titleLabel.textColor = [UIColor blackColor];
        _titleLabel.font = [UIFont systemFontOfSize:16];
    }
    return _titleLabel;
}

- (NSMutableArray *)maskViews {
    if (!_maskViews) {
        _maskViews = @[].mutableCopy;
    }
    return _maskViews;
}

@end
