//
//  XCRedContentView.m
//  XChat
//
//  Created by 卫明何 on 2018/5/31.
//  Copyright © 2018年 XC. All rights reserved.
//

#import "XCRedContentView.h"
#import "NSObject+YYModel.h"
#import "Attachment.h"

#import <Masonry/Masonry.h>
#import "XCTheme.h"
#import "XCKeyWordTool.h"

NSString *const XCRedInteractiveViewClick = @"XCRedInteractiveViewClick";

@interface XCRedContentView()
@property (strong, nonatomic) UILabel *message;
@property (strong, nonatomic) UIImageView *redBgImageView;
@property (strong, nonatomic) UIImageView *redIconImageView;
@property (strong, nonatomic) UILabel *statusLabel;
@property (strong, nonatomic) UIButton *clickRedButton;
@end

@implementation XCRedContentView

- (instancetype)initSessionMessageContentView {
    if (self = [super initSessionMessageContentView]) {
        self.opaque = YES;
        [self initView];
        [self initConstrations];
    }
    return self;
}


- (void)initView {
    self.bubbleImageView.hidden = YES;
    [self addSubview:self.redBgImageView];
    [self addSubview:self.redIconImageView];
    [self addSubview:self.message];
    [self addSubview:self.statusLabel];
}

- (void)initConstrations {
    [self.message mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.redBgImageView.mas_leading).offset(70);
        make.top.mas_equalTo(self.redBgImageView.mas_top).offset(22);
        make.trailing.mas_equalTo(self.redBgImageView.mas_trailing).offset(-15);
    }];
    [self.statusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.message.mas_leading);
        make.top.mas_equalTo(self.message.mas_bottom).offset(8);
    }];
    [self.redBgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.mas_leading).offset(13);
        make.trailing.mas_equalTo(self.mas_trailing).offset(-13);
        make.top.mas_equalTo(self.mas_top);
        make.bottom.mas_equalTo(self.mas_bottom).offset(-20);
    }];
    [self.redIconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.redBgImageView).offset(12);
        make.centerY.mas_equalTo(self.redBgImageView);
    }];
}

- (void)refresh:(NIMMessageModel *)data {
    [super refresh:data];
    NIMCustomObject *object = (NIMCustomObject *)data.message.messageObject;
    RedPacketDetailInfo *customObject;
    if (data.message.localExt) {
        customObject = [RedPacketDetailInfo yy_modelWithJSON:data.message.localExt];
    }else {
        if ([object.attachment isKindOfClass:[RedPacketDetailInfo class]]) {
            customObject =  (RedPacketDetailInfo *)object.attachment;
        }else if ([object.attachment isKindOfClass:[Attachment class]]) {
            Attachment * att = (Attachment *)object.attachment;
            customObject = [RedPacketDetailInfo yy_modelWithJSON:att.data];
        }
    }
    self.message.text = customObject.message.length > 0 ? customObject.message : @"恭喜发财，大吉大利";
    if (customObject.status == RedPacketStatus_NotOpen) {
        self.redBgImageView.image = [UIImage imageNamed:@"message_chat_red_bg_normal"];
        self.statusLabel.text = @"点击领取";
    }else if (customObject.status == RedPacketStatus_DidOpen || customObject.status == RedPacketStatus_OutDate || customObject.status == RedPacketStatus_OutBouns) {
        self.redBgImageView.image = [UIImage imageNamed:@"message_chat_red_bg_expired"];
        if (customObject.status == RedPacketStatus_DidOpen) {
            self.statusLabel.text = [NSString stringWithFormat:@"%@已领取", [XCKeyWordTool sharedInstance].xcRedColor];
        }else if (customObject.status == RedPacketStatus_OutDate) {
            self.statusLabel.text = [NSString stringWithFormat:@"%@已过期", [XCKeyWordTool sharedInstance].xcRedColor];
        }else if (customObject.status == RedPacketStatus_OutBouns) {
            self.statusLabel.text = [NSString stringWithFormat:@"%@已领完", [XCKeyWordTool sharedInstance].xcRedColor];
        }
    }
}



- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    if ([self.delegate respondsToSelector:@selector(onCatchEvent:)]) {
        NIMKitEvent *event = [[NIMKitEvent alloc] init];
        event.eventName = XCRedInteractiveViewClick;
        event.messageModel = self.model;
        event.data = self;
        [self.delegate onCatchEvent:event];
    }
}

- (void)clickRed:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(onCatchEvent:)]) {
        NIMKitEvent *event = [[NIMKitEvent alloc] init];
        event.eventName = XCRedInteractiveViewClick;
        event.messageModel = self.model;
        event.data = self;
        [self.delegate onCatchEvent:event];
    }
}

#pragma mark - Getter

- (UILabel *)message {
    if (!_message) {
        _message = [[UILabel alloc]init];
        _message.textColor = UIColorFromRGB(0xffffff);
        _message.font = [UIFont systemFontOfSize:14.f];
    }
    return _message;
}

- (UIImageView *)redBgImageView {
    if (!_redBgImageView) {
        _redBgImageView = [[UIImageView alloc]init];
        _redBgImageView.userInteractionEnabled = NO;
    }
    return _redBgImageView;
}

- (UIImageView *)redIconImageView {
    if (!_redIconImageView) {
        _redIconImageView = [[UIImageView alloc]init];
        _redIconImageView.image = [UIImage imageNamed:@"message_chat_red_ico"];
        _redIconImageView.userInteractionEnabled = NO;
    }
    return _redIconImageView;
}

- (UILabel *)statusLabel {
    if (!_statusLabel) {
        _statusLabel = [[UILabel alloc]init];
        _statusLabel.textColor = UIColorRGBAlpha(0xffffff, 0.5);
        _statusLabel.font = [UIFont systemFontOfSize:13.f];
    }
    return _statusLabel;
}

- (UIButton *)clickRedButton {
    if (!_clickRedButton) {
        _clickRedButton = [[UIButton alloc]init];
        [_clickRedButton addTarget:self action:@selector(clickRedButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _clickRedButton;
}

@end
