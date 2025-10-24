//
//  TTAuthEditView.m
//  TuTu
//
//  Created by Macx on 2018/10/30.
//  Copyright © 2018 YiZhuan. All rights reserved.
//

#import "TTAuthEditView.h"

#import "XCTheme.h"
#import <Masonry/Masonry.h>

@interface TTAuthEditView()
/** textField */
@property (nonatomic, strong) UITextField *textField;
/** bottomLineView */
@property (nonatomic, strong) UIView *bottomLineView;
/** 验证码 */
@property (nonatomic, strong) UIButton *authCodeButton;
/** 图片验证码 */
@property (nonatomic, strong) UIButton *captchaImageButton;
/** 图片验证码 */
@property (nonatomic, strong) UIImageView *captchaImageView;
/** 图片验证码, 刷新按钮 */
@property (nonatomic, strong) UIButton *reloadButton;
@end

@implementation TTAuthEditView

#pragma mark - life cycle

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initView];
        [self initConstrations];
    }
    return self;
}

#pragma mark - public methods
- (instancetype)initWithPlaceholder:(NSString *)placeholder {
    if (self = [self initWithFrame:CGRectZero]) {
        self.textField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:placeholder attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:15], NSForegroundColorAttributeName : RGBCOLOR(202, 202, 202)}];
    }
    return self;
}

/**
 更新图片验证码
 
 @param captchaImage 图片
 */
- (void)updateCaptchaImage:(UIImage *)captchaImage {
    if (self.type == TTAuthEditViewTypeCaptchaImage) {
        self.captchaImageButton.hidden = YES;
        self.captchaImageView.hidden = NO;
        self.reloadButton.hidden = NO;
        
        self.captchaImageView.image = captchaImage;
    }
}

#pragma mark - [系统控件的Protocol]   //注意要把名字改掉，这个MARK只做功能划分，不是一个真正的MARK，每个不一样的Protocol，需要一个新的MARK”

#pragma mark - [自定义控件的Protocol] //注意要把名字改掉，这个MARK只做功能划分，不是一个真正的MARK，每个不一样的Protocol，需要一个新的MARK”

#pragma mark - [core相关的Protocol]  //注意要把名字改掉，这个MARK只做功能划分，不是一个真正的MARK，每个不一样的Protocol，需要一个新的MARK”

#pragma mark - event response
- (void)didClickedRightButton:(UIButton *)button {
    if (self.rightButtonDidClickBlcok) {
        self.rightButtonDidClickBlcok(button);
    }
}

- (void)didClickedCaptchaImageButton:(UIButton *)button {
    if (self.rightButtonDidClickBlcok) {
        self.rightButtonDidClickBlcok(button);
    }
}

#pragma mark - private method

- (void)initView {
    [self addSubview:self.textField];
    [self addSubview:self.bottomLineView];
    [self addSubview:self.authCodeButton];
    [self addSubview:self.captchaImageButton];
    [self addSubview:self.captchaImageView];
    [self addSubview:self.reloadButton];
    
    [self.authCodeButton addTarget:self action:@selector(didClickedRightButton:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)initConstrations {
    [self.textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.mas_equalTo(self);
        make.right.mas_equalTo(-90);
        make.left.mas_equalTo(15);
    }];
    
    [self.bottomLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(self);
        make.height.mas_equalTo(1);
    }];
    
    [self.authCodeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.right.mas_equalTo(self);
        make.height.mas_equalTo(30);
    }];
    
    [self.captchaImageButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self);
        make.top.bottom.mas_equalTo(self);
        make.width.mas_equalTo(133);
    }];
    
    [self.captchaImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.mas_equalTo(self.captchaImageButton);
    }];
    
    [self.reloadButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.top.mas_equalTo(self.captchaImageView);
        make.width.height.mas_equalTo(20);
    }];
}

#pragma mark - getters and setters
- (void)setType:(TTAuthEditViewType)type {
    _type = type;
    
    if (type == TTAuthEditViewTypeNormal) {
        [self.textField mas_updateConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(0);
        }];
        self.authCodeButton.hidden = YES;
        self.captchaImageButton.hidden = YES;
    } else if (type == TTAuthEditViewTypeSms) {
        [self.textField mas_updateConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-90);
        }];
        self.authCodeButton.hidden = NO;
        self.captchaImageButton.hidden = YES;
    } else if (type == TTAuthEditViewTypeCaptchaImage) {
        [self.textField mas_updateConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-133 - 15);
        }];
        self.authCodeButton.hidden = YES;
        self.captchaImageButton.hidden = NO;
    }
}

- (UITextField *)textField {
    if (!_textField) {
        _textField = [[UITextField alloc] init];
        _textField.tintColor = [XCTheme getTTMainColor];
        _textField.font = [UIFont systemFontOfSize:14];
        _textField.textColor = [XCTheme getTTMainTextColor];
    }
    return _textField;
}

- (UIView *)bottomLineView {
    if (!_bottomLineView) {
        _bottomLineView = [[UIView alloc] init];
        _bottomLineView.backgroundColor = RGBCOLOR(235, 235, 235);
        _bottomLineView.hidden = YES;
    }
    return _bottomLineView;
}

- (UIButton *)authCodeButton {
    if (!_authCodeButton) {
        _authCodeButton = [[UIButton alloc] init];
        [_authCodeButton setTitleColor:[XCTheme getTTMainColor]  forState:UIControlStateNormal];
        _authCodeButton.titleLabel.font = [UIFont systemFontOfSize:15];
        [_authCodeButton setTitleColor:UIColorFromRGB(0xB3B3B3) forState:UIControlStateDisabled];
        [_authCodeButton setTitle:@"获取验证码" forState:UIControlStateNormal];
        _authCodeButton.hidden = YES;
    }
    return _authCodeButton;
}

- (UIButton *)captchaImageButton {
    if (!_captchaImageButton) {
        _captchaImageButton = [[UIButton alloc] init];
        [_captchaImageButton setImage:[UIImage imageNamed:@"auth_register_captchaImage"] forState:UIControlStateNormal];
        [_captchaImageButton addTarget:self action:@selector(didClickedCaptchaImageButton:) forControlEvents:UIControlEventTouchUpInside];
        _captchaImageButton.hidden = YES;
    }
    return _captchaImageButton;
}

- (UIImageView *)captchaImageView {
    if (!_captchaImageView) {
        _captchaImageView = [[UIImageView alloc] init];
        _captchaImageView.layer.cornerRadius = 6;
        _captchaImageView.layer.borderWidth = 2;
        _captchaImageView.layer.borderColor = [RGBCOLOR(236, 236, 236) CGColor];
        _captchaImageView.userInteractionEnabled = YES;
        _captchaImageView.hidden = YES;
        _captchaImageView.layer.masksToBounds = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didClickedCaptchaImageButton:)];
        [_captchaImageView addGestureRecognizer:tap];
    }
    return _captchaImageView;
}

- (UIButton *)reloadButton {
    if (!_reloadButton) {
        _reloadButton = [[UIButton alloc] init];
        [_reloadButton setImage:[UIImage imageNamed:@"auth_register_captchaImage_reload"] forState:UIControlStateNormal];
        [_reloadButton addTarget:self action:@selector(didClickedCaptchaImageButton:) forControlEvents:UIControlEventTouchUpInside];
        _reloadButton.hidden = YES;
    }
    return _reloadButton;
}

@end
