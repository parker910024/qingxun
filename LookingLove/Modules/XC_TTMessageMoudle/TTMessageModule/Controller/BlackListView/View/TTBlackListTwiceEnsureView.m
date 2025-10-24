//
//  XCBlackListTwiceEnsureView.m
//  XChat
//
//  Created by Macx on 2018/4/19.
//  Copyright © 2018年 XC. All rights reserved.
//

#import "TTBlackListTwiceEnsureView.h"
#import "XCMacros.h"
#import <Masonry.h>
#import "XCTheme.h"

@interface TTBlackListTwiceEnsureView()

@property (nonatomic, copy) ensureBlock  ensureBlock;
@property (nonatomic, copy) cancelBlock  cancelBlock;

@property (nonatomic, strong) UIView  *titleContentView;//内容标示
@property (nonatomic, strong) UILabel  *titleLabel;//标题
@property (nonatomic, strong) UILabel  *messageLabel;//内容

@property (nonatomic, strong) UIButton  *ensureBtn;//确认
@property (nonatomic, strong) UIButton  *cancelBtn;//取消

@end


@implementation TTBlackListTwiceEnsureView

- (instancetype)initWithTitle:(NSString *)title message:(NSString *)message ensureBlock:(ensureBlock)block cancel:(cancelBlock)cancelBlock {
    if (self = [super init]) {
        self.ensureBlock = block;
        self.cancelBlock = cancelBlock;
        self.frame = CGRectMake(0, 0, KScreenWidth-60, 190);
        [self initSubView];
        self.titleLabel.text = title?title:@"";
        self.messageLabel.text = message?message:@"";
    }
    return self;
}

- (void)initSubView {
    self.backgroundColor = [UIColor whiteColor];
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = 8;
    [self addSubview:self.titleContentView];
    [self.titleContentView addSubview:self.titleLabel];
    [self.titleContentView addSubview:self.messageLabel];
    [self addSubview:self.ensureBtn];
    [self addSubview:self.cancelBtn];
    [self makeConstraints];
}

- (void)makeConstraints {
    [self.titleContentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self);
        make.centerY.mas_equalTo(self).offset(-22);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.top.mas_equalTo(self.titleContentView);
    }];
    
    [self.messageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.titleLabel.mas_bottom).offset(16);
        make.bottom.left.right.mas_equalTo(self.titleContentView);
    }];
    [self.cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.mas_equalTo(self);
        make.height.mas_equalTo(44);
    }];
    [self.ensureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.bottom.mas_equalTo(self);
        make.height.width.mas_equalTo(self.cancelBtn);
        make.left.mas_equalTo(self.cancelBtn.mas_right);
    }];
}

#pragma mark - action

- (void)ensureBtnAction {
    !self.ensureBlock?:self.ensureBlock();
}

- (void)cancelBtnAction {
    !self.cancelBlock?:self.cancelBlock();
}


#pragma mark - getter && setter

- (UIView *)titleContentView {
    if (!_titleContentView) {
        _titleContentView = [[UIView alloc] init];
    }
    return _titleContentView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont boldSystemFontOfSize:18];
        _titleLabel.textColor = UIColorFromRGB(0x333333);
    }
    return _titleLabel;
}

- (UILabel *)messageLabel {
    if (!_messageLabel) {
        _messageLabel = [[UILabel alloc] init];
        _messageLabel.font = [UIFont systemFontOfSize:14];
        _messageLabel.textColor = UIColorFromRGB(0x333333);
        _messageLabel.numberOfLines = 0;
    }
    return _messageLabel;
}

- (UIButton *)cancelBtn {
    if (!_cancelBtn) {
        _cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
        [_cancelBtn addTarget:self action:@selector(cancelBtnAction) forControlEvents:UIControlEventTouchUpInside];
        [_cancelBtn setTitleColor:UIColorFromRGB(0x333333) forState:(UIControlState)UIControlStateNormal];
        _cancelBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        _cancelBtn.backgroundColor = UIColorFromRGB(0xebebeb);
    }
    return _cancelBtn;
}

- (UIButton *)ensureBtn {
    if (!_ensureBtn) {
        _ensureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_ensureBtn setTitle:@"确定" forState:UIControlStateNormal];
        [_ensureBtn addTarget:self action:@selector(ensureBtnAction) forControlEvents:UIControlEventTouchUpInside];
        [_ensureBtn setTitleColor:UIColorFromRGB(0xff84b0) forState:(UIControlState)UIControlStateNormal];
        _ensureBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        _ensureBtn.backgroundColor = UIColorFromRGB(0xebebeb);

    }
    return _ensureBtn;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
