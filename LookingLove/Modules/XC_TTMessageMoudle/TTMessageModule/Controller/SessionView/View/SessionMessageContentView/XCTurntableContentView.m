//
//  XCTurntableContentView.m
//  XChat
//
//  Created by 卫明何 on 2018/1/3.
//  Copyright © 2018年 XC. All rights reserved.
//

#import "XCTurntableContentView.h"
#import "TurntableAttachment.h"
#import "XCTurntableMessageView.h"
#import "UIView+NTES.h"

NSString *const XCTurntableMessageViewClick = @"XCTurntableMessageViewClick";

@interface XCTurntableContentView ()

@property (strong, nonatomic) XCTurntableMessageView *contentView;

@end

@implementation XCTurntableContentView

- (instancetype)initSessionMessageContentView {
    self = [super initSessionMessageContentView];
    if (self) {
        self.opaque = YES;
        _contentView = [[XCTurntableMessageView alloc] init];
        [self addSubview:_contentView];
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    UIEdgeInsets contentInsets = self.model.contentViewInsets;
    CGFloat tableViewWidth = self.superview.width;
    CGSize contentSize = [self.model contentSize:tableViewWidth];
    CGRect imageViewFrame = CGRectMake(contentInsets.left, contentInsets.top, contentSize.width, contentSize.height);
    self.contentView.frame  = imageViewFrame;
//    CALayer *maskLayer = [CALayer layer];
//    maskLayer.cornerRadius = 13.0;
//    maskLayer.backgroundColor = [UIColor blackColor].CGColor;
//    maskLayer.frame = self.contentView.bounds;
//    self.contentView.layer.mask = maskLayer;
}

- (void)refresh:(NIMMessageModel *)data {
    [super refresh:data];
}


-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    if ([self.delegate respondsToSelector:@selector(onCatchEvent:)]) {
        NIMKitEvent *event = [[NIMKitEvent alloc] init];
        event.eventName = XCTurntableMessageViewClick;
        event.messageModel = self.model;
        event.data = self;
        [self.delegate onCatchEvent:event];
    }
}


@end
