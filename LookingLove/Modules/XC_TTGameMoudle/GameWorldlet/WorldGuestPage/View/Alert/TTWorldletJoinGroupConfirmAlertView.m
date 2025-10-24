//
//  TTWorldletJoinGroupConfirmAlertView.m
//  XC_TTGameMoudle
//
//  Created by lvjunhang on 2019/11/20.
//  Copyright © 2019 WUJIE INTERACTIVE. All rights reserved.
//

#import "TTWorldletJoinGroupConfirmAlertView.h"

#import "XCMacros.h"
#import "UIImageView+QiNiu.h"
#import "XCTheme.h"

#import <Masonry/Masonry.h>

@interface TTWorldletJoinGroupConfirmAlertView ()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *contentLabel;
@property (nonatomic, strong) UIButton *enterButton;
@property (nonatomic, strong) UIButton *cancelButton;

@end

@implementation TTWorldletJoinGroupConfirmAlertView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = UIColorFromRGB(0xffffff);
        self.layer.cornerRadius = 8;
        self.layer.masksToBounds = YES;
        
        [self initView];
        [self initConstraint];
    }
    return self;
}

- (void)initView {
    [self addSubview:self.titleLabel];
    [self addSubview:self.contentLabel];
    [self addSubview:self.enterButton];
    [self addSubview:self.cancelButton];
}

- (void)initConstraint {
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(30);
        make.centerX.mas_equalTo(self);
    }];
    
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.titleLabel.mas_bottom).offset(22);
        make.centerX.mas_equalTo(0);
    }];
    
    [self.enterButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentLabel.mas_bottom).offset(28);
        make.size.mas_equalTo(CGSizeMake(120, 38));
        make.centerX.mas_equalTo(self);
    }];
    
    [self.cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.enterButton.mas_bottom).offset(14);
        make.centerX.mas_equalTo(self);
    }];
    
}

#pragma mark - Actions
- (void)enterBtnAction:(UIButton *)sender {
    if (self.enterActionBlock) {
        self.enterActionBlock();
    }
}

#pragma mark - Setter Getter
- (void)setName:(NSString *)name {
    if (!name.length) {
        return;
    }
    _name = name;
    
    self.titleLabel.text = name;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.text = @"加入群聊";
        _titleLabel.font = [UIFont boldSystemFontOfSize:18];
        _titleLabel.textColor = XCTheme.getTTMainTextColor;
    }
    return _titleLabel;
}

- (UILabel *)contentLabel {
    if (!_contentLabel) {
        _contentLabel = [[UILabel alloc] init];
        _contentLabel.textColor = XCTheme.getTTMainTextColor;
        _contentLabel.font = [UIFont systemFontOfSize:16];
        _contentLabel.numberOfLines = 0;
        _contentLabel.textAlignment = NSTextAlignmentCenter;
        _contentLabel.text = @"加入群聊后可以和小世界的朋友们\n谈天说地，确认加入群聊吗？";
    }
    return _contentLabel;
}

- (UIButton *)enterButton {
    if (!_enterButton) {
        _enterButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _enterButton.backgroundColor = XCTheme.getTTMainColor;
        [_enterButton setTitle:@"立即加入" forState:UIControlStateNormal];
        _enterButton.titleLabel.font = [UIFont systemFontOfSize:15];
        [_enterButton setTitleColor:[XCTheme getTTMainTextColor] forState:UIControlStateNormal];
        _enterButton.layer.cornerRadius = 19;
        _enterButton.layer.borderColor = [XCTheme getTTMainTextColor].CGColor;
        _enterButton.layer.borderWidth = 2;
        [_enterButton addTarget:self action:@selector(enterBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _enterButton;
}

- (UIButton *)cancelButton {
    if (!_cancelButton) {
        _cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _cancelButton.userInteractionEnabled = NO;
        [_cancelButton setTitle:@"活跃度太低会被移出群聊哦~" forState:UIControlStateNormal];
        _cancelButton.titleLabel.font = [UIFont systemFontOfSize:13];
        [_cancelButton setTitleColor:UIColorFromRGB(0xB3B3B3) forState:UIControlStateNormal];
    }
    return _cancelButton;
}

@end

