//
//  XCCheckinNoticeMessageContentView.m
//  TTPlay
//
//  Created by lvjunhang on 2019/3/28.
//  Copyright © 2019 YiZhuan. All rights reserved.
//

#import "XCCheckinNoticeMessageContentView.h"
#import "XCCheckinNoticeAttachment.h"

#import "XCTheme.h"

#import "NSObject+YYModel.h"
#import <Masonry/Masonry.h>

NSString * const XCCheckinNoticeMessageContentViewClick = @"XCCheckinNoticeMessageContentViewClick";

@interface XCCheckinNoticeMessageContentView()
@property (nonatomic, strong) UIView *backView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *contentLabel;
@property (nonatomic, strong) UIView *sepView;
@property (nonatomic, strong) UIButton *enterButton;

@end


@implementation XCCheckinNoticeMessageContentView

- (instancetype)initSessionMessageContentView {
    if (self = [super initSessionMessageContentView]) {
        [self initView];
        [self layoutSubViewFrame];
    }
    return self;
}

- (void)refresh:(NIMMessageModel *)data {
    [super refresh:data];
    
    NIMCustomObject *object = (NIMCustomObject *)data.message.messageObject;
    XCCheckinNoticeAttachment *customObject = (XCCheckinNoticeAttachment*)object.attachment;
    
    self.titleLabel.text = customObject.title;
    self.contentLabel.text = customObject.content;
}

- (void)enterButtonAction:(UIButton *)sender {
    
    if ([self.delegate respondsToSelector:@selector(onCatchEvent:)]) {
        NIMKitEvent *event = [[NIMKitEvent alloc] init];
        event.eventName = XCCheckinNoticeMessageContentViewClick;
        event.messageModel = self.model;
        event.data = self;
        [self.delegate onCatchEvent:event];
    }
}

- (void)initView {
    [self addSubview:self.backView];
    [self.backView addSubview:self.titleLabel];
    [self.backView addSubview:self.contentLabel];
    [self.backView addSubview:self.sepView];
    [self.backView addSubview:self.enterButton];
}

- (void)layoutSubViewFrame {
    [self.backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(14);
        make.left.right.mas_equalTo(self.backView).inset(10);
    }];
    
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.titleLabel.mas_bottom).offset(10);
        make.left.right.mas_equalTo(self.backView).inset(10);
    }];
    
    [self.sepView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.backView);
        make.height.mas_equalTo(1);
        make.bottom.mas_equalTo(self.backView).offset(-40);
    }];
    
    [self.enterButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(self.backView);
        make.height.mas_equalTo(40);
    }];
}

- (UILabel *)titleLabel {
    if (_titleLabel == nil) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = UIColorFromRGB(0x1A1A1A);
        _titleLabel.font = [UIFont boldSystemFontOfSize:16];
        _titleLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _titleLabel;
}

- (UILabel *)contentLabel {
    if (_contentLabel == nil) {
        _contentLabel = [[UILabel alloc] init];
        _contentLabel.textColor = UIColorFromRGB(0x1A1A1A);
        _contentLabel.font = [UIFont systemFontOfSize:14];
        _contentLabel.numberOfLines = 0;
        _contentLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _contentLabel;
}

- (UIView *)sepView {
    if (_sepView == nil) {
        _sepView = [[UIView alloc] init];
        _sepView.backgroundColor = UIColorFromRGB(0xF0F0F0);
    }
    return _sepView;
}

- (UIButton *)enterButton {
    if (_enterButton == nil) {
        _enterButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_enterButton setTitleColor:UIColorFromRGB(0x333333) forState:UIControlStateNormal];
        _enterButton.titleLabel.font = [UIFont boldSystemFontOfSize:16];
        [_enterButton setTitle:@"去签到" forState:UIControlStateNormal];
        [_enterButton addTarget:self action:@selector(enterButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _enterButton;
}

- (UIView *)backView {
    if (_backView == nil) {
        _backView = [[UIView alloc] init];
        _backView.backgroundColor = [UIColor whiteColor];
        _backView.layer.cornerRadius = 5;
        
    }
    return _backView;
}

@end

