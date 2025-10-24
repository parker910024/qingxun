//
//  XCNewsNoticeContentMessageView.m
//  XChat
//
//  Created by 卫明何 on 2017/10/16.
//  Copyright © 2017年 XC. All rights reserved.
//

#import "XCNewsNoticeContentMessageView.h"
#import "XCNewsNoticeMessageView.h"
#import "XCNewsInfoAttachment.h"
#import "UIView+NTES.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "NIMKit.h"
#import "XCMacros.h"
#import "XCWKWebViewController.h"

#import "XCTheme.h"

NSString *const XCNewsNoticeContentMessageViewClick  = @"XCNewsNoticeContentMessageViewClick";

@interface XCNewsNoticeContentMessageView()
@property (strong, nonatomic) XCNewsNoticeMessageView *contentView;
@end

@implementation XCNewsNoticeContentMessageView

- (instancetype)initSessionMessageContentView {
    self = [super initSessionMessageContentView];
    if (self) {
        self.opaque = YES;
        _contentView  = [[XCNewsNoticeMessageView alloc] init];
        //        self.bubbleImageView.hidden = YES;
        [self addSubview:_contentView];
    }
    return self;
}

- (void)refresh:(NIMMessageModel *)data {
    [super refresh:data];

    NIMCustomObject *custom = (NIMCustomObject *)data.message.messageObject;
    XCNewsInfoAttachment *attachment = (XCNewsInfoAttachment*)custom.attachment;
    [_contentView.picImageView sd_setImageWithURL:[NSURL URLWithString:attachment.picUrl] placeholderImage:[UIImage imageNamed:[XCTheme defaultTheme].default_avatar]];
    [_contentView.title setText:attachment.title];
    [_contentView.contentLabel setText:attachment.desc];
}

- (void)layoutSubviews{
    [super layoutSubviews];
    UIEdgeInsets contentInsets = self.model.contentViewInsets;
    CGFloat tableViewWidth = self.superview.width;
    CGSize contentSize = [self.model contentSize:tableViewWidth];
    CGRect imageViewFrame = CGRectMake(contentInsets.left - 10, contentInsets.top, contentSize.width, contentSize.height);
    self.contentView.frame  = imageViewFrame;
    [self.contentView layoutIfNeeded];
    CALayer *maskLayer = [CALayer layer];
    maskLayer.cornerRadius = 13.0;
    maskLayer.backgroundColor = [UIColor blackColor].CGColor;
    maskLayer.frame = self.contentView.bounds;
    self.contentView.layer.mask = maskLayer;
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {

    if ([self.delegate respondsToSelector:@selector(onCatchEvent:)]) {
        NIMKitEvent *event = [[NIMKitEvent alloc] init];
        event.eventName = XCNewsNoticeContentMessageViewClick;
        event.messageModel = self.model;
        event.data = self;
        [self.delegate onCatchEvent:event];
    }

//    event.eventName = NIMDemoEventNameOpenSnapPicture;
//    event.messageModel = self.model;
//    event.data = self;
    
}

@end
