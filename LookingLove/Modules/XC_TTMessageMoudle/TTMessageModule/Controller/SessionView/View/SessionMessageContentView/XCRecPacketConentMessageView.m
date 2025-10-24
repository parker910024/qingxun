//
//  XCRecPacketConentView.m
//  XChat
//
//  Created by 卫明何 on 2017/10/16.
//  Copyright © 2017年 XC. All rights reserved.
//

#import "XCRecPacketConentMessageView.h"
#import "XCRedPacketInfoAttachment.h"
#import "TTRedPackeMessageView.h"
#import "UIView+NTES.h"
#import "XCKeyWordTool.h"

NSString *const XCOnRedPacketNoticClick = @"XCOnRedPacketNoticClick";

@interface XCRecPacketConentMessageView ()
@property (strong, nonatomic) TTRedPackeMessageView *contentView;
@end

@implementation XCRecPacketConentMessageView

- (instancetype)initSessionMessageContentView {
    self = [super initSessionMessageContentView];
    if (self) {
        self.opaque = YES;
        _contentView  = [[TTRedPackeMessageView alloc] init];
        //        self.bubbleImageView.hidden = YES;
        [self addSubview:_contentView];
    }
    return self;
}

- (void)refresh:(NIMMessageModel *)data {
    [super refresh:data];
    NIMCustomObject *custom = (NIMCustomObject *)data.message.messageObject;
    XCRedPacketInfoAttachment *attachment = (XCRedPacketInfoAttachment*)custom.attachment;
    if (attachment.title > 0) {
        _contentView.redIcon.image = [UIImage imageNamed:@"message_redPacket"];
        _contentView.redLabel.text = [NSString stringWithFormat:@"收到%@%@，快去看吧！",[XCKeyWordTool sharedInstance].xcRedColor,attachment.title];
    }
    
}

- (void)layoutSubviews{
    [super layoutSubviews];
    UIEdgeInsets contentInsets = self.model.contentViewInsets;
    CGFloat tableViewWidth = self.superview.width;
    CGSize contentSize = [self.model contentSize:tableViewWidth];
    CGRect imageViewFrame = CGRectMake(contentInsets.left - 10, contentInsets.top, contentSize.width, contentSize.height);
    self.contentView.frame  = imageViewFrame;
    CALayer *maskLayer = [CALayer layer];
    maskLayer.cornerRadius = 13.0;
    maskLayer.backgroundColor = [UIColor blackColor].CGColor;
    maskLayer.frame = self.contentView.bounds;
    self.contentView.layer.mask = maskLayer;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {

    if ([self.delegate respondsToSelector:@selector(onCatchEvent:)]) {
        NIMKitEvent *event = [[NIMKitEvent alloc] init];
        event.eventName = XCOnRedPacketNoticClick;
        event.messageModel = self.model;
        event.data = self;
        [self.delegate onCatchEvent:event];
    }
}

@end
