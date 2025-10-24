//
//  XCCheckinDrawCoinMessageContentView.m
//  TTPlay
//
//  Created by lvjunhang on 2019/3/29.
//  Copyright © 2019 YiZhuan. All rights reserved.
//

#import "XCCheckinDrawCoinMessageContentView.h"

#import "XCCheckinDrawCoinAttachment.h"

#import "XCTheme.h"

#import "NSObject+YYModel.h"
#import <Masonry/Masonry.h>

NSString * const XCCheckinDrawCoinMessageContentViewClick = @"XCCheckinDrawCoinMessageContentViewClick";

@interface XCCheckinDrawCoinMessageContentView()
@property (nonatomic, strong) UILabel *contentLabel;
@end


@implementation XCCheckinDrawCoinMessageContentView

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
    XCCheckinDrawCoinAttachment *customObject = (XCCheckinDrawCoinAttachment*)object.attachment;
    
    NSString *coin = [NSString stringWithFormat:@"%@金币", customObject.goldNum];
    NSString *content = [NSString stringWithFormat:@"【签到瓜分百万】哇塞，恭喜%@签到获得%@！",customObject.nick, coin];
    NSRange nickRange = [content rangeOfString:customObject.nick];
    NSRange coinRange = [content rangeOfString:coin];
    
    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:content];
    [attr addAttribute:NSForegroundColorAttributeName value:[XCTheme getTTMainColor] range:nickRange];
    [attr addAttribute:NSForegroundColorAttributeName value:[XCTheme getTTMainColor] range:coinRange];

    self.contentLabel.attributedText = attr;
}

- (void)enterButtonAction:(UIButton *)sender {
    
    if ([self.delegate respondsToSelector:@selector(onCatchEvent:)]) {
        NIMKitEvent *event = [[NIMKitEvent alloc] init];
        event.eventName = XCCheckinDrawCoinMessageContentViewClick;
        event.messageModel = self.model;
        event.data = self;
        [self.delegate onCatchEvent:event];
    }
}

- (void)initView {
    [self addSubview:self.contentLabel];
}

- (void)layoutSubViewFrame {
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.mas_equalTo(self).inset(8);
        make.left.right.mas_equalTo(self).inset(10);
    }];
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

@end

