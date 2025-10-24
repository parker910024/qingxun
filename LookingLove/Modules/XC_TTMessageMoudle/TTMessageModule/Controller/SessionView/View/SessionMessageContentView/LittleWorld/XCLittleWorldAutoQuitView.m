//
//  XCLittleWorldAutoQuitView.m
//  XC_TTMessageMoudle
//
//  Created by Lee on 2019/10/31.
//  Copyright © 2019 WJHD. All rights reserved.
//

#import "XCLittleWorldAutoQuitView.h"
#import <Masonry/Masonry.h>
#import "XCTheme.h"
#import <YYText/YYText.h>

@interface XCLittleWorldAutoQuitView ()

@property (nonatomic, strong) UILabel *titleLabel; // 标题
@property (nonatomic, strong) UILabel *timeLabel; // 时间
@property (nonatomic, strong) UILabel *messageLabel; // 内容
@property (nonatomic, strong) UIButton *joinButton; // 再次加入按钮

@end

@implementation XCLittleWorldAutoQuitView

#pragma mark -
#pragma mark lifeCycle
- (instancetype)init {
    self = [super init];
    if (self) {
        [self initViews];
        [self initConstraints];
    }
    return self;
}

- (void)initViews {
    self.backgroundColor = UIColor.whiteColor;
    [self addSubview:self.titleLabel];
    [self addSubview:self.timeLabel];
    [self addSubview:self.messageLabel];
    [self addSubview:self.joinButton];
}

- (void)initConstraints {
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(14.5);
        make.top.mas_equalTo(10);
    }];
    
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-14.5);
        make.centerY.mas_equalTo(self.titleLabel);
    }];
    
    [self.messageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self).inset(14.5);
        make.top.mas_equalTo(self.titleLabel.mas_bottom).offset(12.5);
    }];
    
    [self.joinButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(-15);
        make.centerX.mas_equalTo(self);
        make.width.mas_equalTo(105);
        make.height.mas_equalTo(38);
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
- (void)onClickJoinButtonAction:(UIButton *)joinButton {
    if (self.delegate && [self.delegate respondsToSelector:@selector(onClickAutoQuitViewButtonAction:)]) {
        [self.delegate onClickAutoQuitViewButtonAction:joinButton];
    }
}
#pragma mark -
#pragma mark Public Methods

#pragma mark -
#pragma mark Private Methods

#pragma mark -
#pragma mark Getters and Setters
- (void)setLayout:(MessageLayout *)layout {
    _layout = layout;
    if (layout) {
        self.titleLabel.text = layout.title.content;
        self.timeLabel.text = layout.time.content;
        NSMutableAttributedString *msgString = [[NSMutableAttributedString alloc] init];
        
        [layout.contents enumerateObjectsUsingBlock:^(LayoutParams * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:obj.content];
            [string addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:obj.fontSize.floatValue] range:NSMakeRange(0, string.length)];
            [string addAttribute:NSForegroundColorAttributeName value:UIColorFromRGB(0x333333) range:NSMakeRange(0, string.length)];
            [msgString appendAttributedString:string];
        }];
        
        msgString.yy_lineSpacing = 5;
        
        self.messageLabel.attributedText = msgString;
    }
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = UIColorFromRGB(0x333333);
        _titleLabel.font = [UIFont boldSystemFontOfSize:15];
    }
    return _titleLabel;
}

- (UILabel *)timeLabel {
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.textColor = UIColorFromRGB(0x999999);
        _timeLabel.font = [UIFont systemFontOfSize:12];
        _timeLabel.textAlignment = NSTextAlignmentRight;
    }
    return _timeLabel;
}

- (UILabel *)messageLabel {
    if (!_messageLabel) {
        _messageLabel = [[UILabel alloc] init];
        _messageLabel.textColor = UIColorFromRGB(0x333333);
        _messageLabel.font = [UIFont systemFontOfSize:14];
        _messageLabel.numberOfLines = 0;
    }
    return _messageLabel;
}

- (UIButton *)joinButton {
    if (!_joinButton) {
        _joinButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_joinButton setTitle:@"点击重连" forState:UIControlStateNormal];
        [_joinButton setBackgroundColor:[XCTheme getTTMainColor]];
        [_joinButton setTitleColor:[XCTheme getTTMainTextColor] forState:UIControlStateNormal];
        _joinButton.layer.cornerRadius = 19.f;
        _joinButton.layer.masksToBounds = YES;
        _joinButton.layer.borderWidth = 2.f;
        _joinButton.layer.borderColor = XCTheme.getTTMainTextColor.CGColor;
        _joinButton.titleLabel.font = [UIFont systemFontOfSize:15];
        [_joinButton addTarget:self action:@selector(onClickJoinButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _joinButton;
}
@end
