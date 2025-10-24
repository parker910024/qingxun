//
//  TTWorldletJoinSuccessAlertView.m
//  XC_TTGameMoudle
//
//  Created by lvjunhang on 2019/11/20.
//  Copyright © 2019 WUJIE INTERACTIVE. All rights reserved.
//

#import "TTWorldletJoinSuccessAlertView.h"

#import "XCMacros.h"
#import "UIImageView+QiNiu.h"
#import "XCTheme.h"

#import <Masonry/Masonry.h>

@interface TTWorldletJoinSuccessAlertView ()
@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UILabel *contentLabel;
@property (nonatomic, strong) UIButton *enterButton;
@property (nonatomic, strong) UIButton *cancelButton;

@end

@implementation TTWorldletJoinSuccessAlertView

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
    [self addSubview:self.iconImageView];
    [self addSubview:self.contentLabel];
    [self addSubview:self.enterButton];
    [self addSubview:self.cancelButton];
}

- (void)initConstraint {
    
    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(23);
        make.centerX.mas_equalTo(self);
    }];
    
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.iconImageView.mas_bottom).offset(8);
        make.left.right.mas_equalTo(self).inset(30);
    }];
    
    [self.enterButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentLabel.mas_bottom).offset(33);
        make.size.mas_equalTo(CGSizeMake(120, 38));
        make.centerX.mas_equalTo(self);
    }];
    
    [self.cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.enterButton.mas_bottom).offset(17);
        make.centerX.mas_equalTo(self);
    }];
    
}

#pragma mark - Actions
- (void)enterBtnAction:(UIButton *)sender {
    if (self.enterActionBlock) {
        self.enterActionBlock();
    }
}

- (void)cancelButtonAction:(UIButton *)sender {
    if (self.browseActionBlock) {
        self.browseActionBlock();
    }
}

#pragma mark - Setter Getter
- (void)setName:(NSString *)name {
    _name = name;
    
    NSString *emphasize = [NSString stringWithFormat:@"“%@”", name];
    NSString *str = [NSString stringWithFormat:@"恭喜您！成功加入小世界\n%@",emphasize];
    NSRange range = [str rangeOfString:emphasize];

    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:str];
    [attStr addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:16] range:range];
    
    self.contentLabel.attributedText = attStr;
}

- (UIImageView *)iconImageView {
    if (!_iconImageView) {
        _iconImageView = [[UIImageView alloc] init];
        _iconImageView.image = [UIImage imageNamed:@"littleworld_alert_checkmark"];
    }
    return _iconImageView;
}

- (UILabel *)contentLabel {
    if (!_contentLabel) {
        _contentLabel = [[UILabel alloc] init];
        _contentLabel.textColor = XCTheme.getTTMainTextColor;
        _contentLabel.font = [UIFont systemFontOfSize:16];
        _contentLabel.numberOfLines = 0;
        _contentLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _contentLabel;
}

- (UIButton *)enterButton {
    if (!_enterButton) {
        _enterButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _enterButton.backgroundColor = XCTheme.getTTMainColor;
        [_enterButton setTitle:@"加入群聊" forState:UIControlStateNormal];
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
        [_cancelButton setTitle:@"继续逛逛" forState:UIControlStateNormal];
        _cancelButton.titleLabel.font = [UIFont systemFontOfSize:13];
        [_cancelButton setTitleColor:UIColorFromRGB(0xB3B3B3) forState:UIControlStateNormal];
        [_cancelButton addTarget:self action:@selector(cancelButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancelButton;
}

@end
