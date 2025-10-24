//
//  TTRoomKTVAlerView.m
//  TuTu
//
//  Created by zoey on 2018/11/19.
//  Copyright © 2018年 YiZhuan. All rights reserved.
//

#import "TTRoomKTVAlerView.h"

#import "XCTheme.h"
#import "XCMacros.h"

#import <Masonry/Masonry.h>

@interface TTRoomKTVAlerView()
@property (strong , nonatomic) void(^cancelKTVAlert)(void);
@property (strong , nonatomic) void(^ensureKTVAlert)(void);
    
@property (strong , nonatomic) NSString *message;
@property (strong , nonatomic) NSAttributedString *attrMessage;

@property (strong , nonatomic) UILabel *subTitleLabel;
@property (strong , nonatomic) UILabel *backgroundLabel;

@property (strong , nonatomic) UILabel *titleLabel;
@property (strong , nonatomic) UILabel *messageLabel;
@property (strong , nonatomic) UIButton *cancelBtn;
@property (strong , nonatomic) UIButton *ensureBtn;
@end

@implementation TTRoomKTVAlerView


- (instancetype)initWithFrame:(CGRect)frame title:(NSString *)title subTitle:(NSString *)subTitle attrMessage:(NSAttributedString *)attrMessage message:(NSString *)message backgroundMessage:(NSAttributedString *)backgroundMessage cancel:(void(^)(void))cancel ensure:(void(^)(void))ensure {
    
    if (self = [super initWithFrame:frame]) {
        self.titleLabel.text = title;
        self.cancelKTVAlert = cancel;
        self.ensureKTVAlert = ensure;
        if (attrMessage) {
            self.messageLabel.attributedText = attrMessage;
        }else {
            self.messageLabel.text = message;
        }
        
        if (subTitle) {
            self.subTitleLabel.hidden = NO;
            self.backgroundLabel.hidden = NO;
            self.messageLabel.hidden = YES;
            self.subTitleLabel.text = subTitle;
            self.backgroundLabel.attributedText = backgroundMessage;
        }
        
        [self initSubViews];
    }
    return self;
    
}

- (void)initSubViews {
    self.backgroundColor = UIColorFromRGB(0xffffff);
    self.layer.cornerRadius = 8;
    [self addSubview:self.titleLabel];
    [self addSubview:self.subTitleLabel];
    [self addSubview:self.backgroundLabel];
    [self addSubview:self.messageLabel];
    [self addSubview:self.cancelBtn];
    [self addSubview:self.ensureBtn];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self).offset(29);
        make.centerX.mas_equalTo(self);
        make.width.mas_lessThanOrEqualTo(280);
    }];
    [self.subTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.titleLabel.mas_bottom).offset(6);
        make.centerX.mas_equalTo(self);
        make.width.mas_lessThanOrEqualTo(280);
    }];
    [self.backgroundLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.subTitleLabel.mas_bottom).offset(16);
        make.height.mas_equalTo(22);
        make.centerX.mas_equalTo(self);
    }];
    [self.messageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.titleLabel.mas_bottom).offset(17);
        make.centerX.mas_equalTo(self);
        make.width.mas_lessThanOrEqualTo(260);
    }];
    [self.cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.mas_centerX).offset(-8);
        make.bottom.mas_equalTo(self).offset(-15);
        make.height.mas_equalTo(38);
        make.width.mas_equalTo(120);
    }];
    [self.ensureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_centerX).offset(8);
        make.height.bottom.mas_equalTo(self.cancelBtn);
        make.width.mas_equalTo(120);
    }];
    
}

#pragma mark - Event
- (void)onClickEnsureBtn:(UIButton *)btn {
    !self.ensureKTVAlert?:self.ensureKTVAlert();
}


- (void)onClickCancelBtn:(UIButton *)btn {
    !self.cancelKTVAlert?:self.cancelKTVAlert();
}


#pragma mark - Getter && Setter
    
- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.text = @"";
        _titleLabel.font = [UIFont systemFontOfSize:16];
        _titleLabel.textColor = [XCTheme getTTMainTextColor];
    }
    return _titleLabel;
}

- (UILabel *)subTitleLabel {
    if (!_subTitleLabel) {
        _subTitleLabel = [[UILabel alloc] init];
        _subTitleLabel.hidden = YES;
        _subTitleLabel.textColor = [XCTheme getTTMainTextColor];
        _subTitleLabel.font = [UIFont systemFontOfSize:14];
    }
    return _subTitleLabel;
}

- (UILabel *)backgroundLabel {
    if (!_backgroundLabel) {
        _backgroundLabel = [[UILabel alloc] init];
        _backgroundLabel.hidden = YES;
        _backgroundLabel.layer.cornerRadius = 11;
        _backgroundLabel.layer.masksToBounds = YES;
        _backgroundLabel.backgroundColor = UIColorFromRGB(0xF5F5F5);
    }
    return _backgroundLabel;
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
        [_cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
        [_cancelBtn setTitleColor:[XCTheme getTTMainColor] forState:UIControlStateNormal];
        _cancelBtn.backgroundColor = UIColorFromRGB(0xFEF5ED);
        _cancelBtn.layer.cornerRadius = 19;
        _cancelBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [_cancelBtn addTarget:self action:@selector(onClickCancelBtn:) forControlEvents:UIControlEventTouchUpInside];
        
        if (projectType() == ProjectType_LookingLove) {
            [_cancelBtn setTitleColor:UIColorFromRGB(0x000000) forState:UIControlStateNormal];
            _cancelBtn.backgroundColor = UIColorFromRGB(0xFFFFFF);
            _cancelBtn.layer.borderWidth = 2;
            _cancelBtn.layer.borderColor = UIColorFromRGB(0xB3B3B3).CGColor;
        }
    }
    return _cancelBtn;
}

- (UIButton *)ensureBtn {
    if (!_ensureBtn) {
        _ensureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_ensureBtn setTitle:@"确定" forState:UIControlStateNormal];
        [_ensureBtn setTitleColor:UIColorFromRGB(0xffffff) forState:UIControlStateNormal];
        _ensureBtn.backgroundColor = [XCTheme getTTMainColor];
        _ensureBtn.layer.cornerRadius = 19;
        _ensureBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [_ensureBtn addTarget:self action:@selector(onClickEnsureBtn:) forControlEvents:UIControlEventTouchUpInside];
        
        if (projectType() == ProjectType_LookingLove) {
            [_ensureBtn setTitleColor:UIColorFromRGB(0x000000) forState:UIControlStateNormal];
            _ensureBtn.layer.borderWidth = 2;
            _ensureBtn.layer.borderColor = UIColorFromRGB(0x000000).CGColor;
        }
    }
    return _ensureBtn;
}

@end
