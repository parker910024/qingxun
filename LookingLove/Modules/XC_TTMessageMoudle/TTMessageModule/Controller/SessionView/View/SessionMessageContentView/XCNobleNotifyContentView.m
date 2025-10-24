//
//  XCNobleNotifyContentView.m
//  XChat
//
//  Created by 卫明何 on 2018/1/18.
//  Copyright © 2018年 XC. All rights reserved.
//

#import "XCNobleNotifyContentView.h"
#import "UIView+NTES.h"
#import "NobleNotifyAttachment.h"
#import <Masonry/Masonry.h>

NSString *const XCNobleNotifyMessageViewClick = @"XCNobleNotifyMessageViewClick";

@interface XCNobleNotifyContentView ()
@property (nonatomic, strong) UILabel *msgLabel;
@end

@implementation XCNobleNotifyContentView

- (instancetype)initSessionMessageContentView {
    self = [super initSessionMessageContentView];
    if (self) {
        self.opaque = YES;
        [self addSubview:self.msgLabel];
        [_msgLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.mas_equalTo(self.mas_leading).offset(15);
            make.top.mas_equalTo(self.mas_top).offset(15);
            make.trailing.mas_equalTo(self.mas_trailing).offset(-15);
            make.bottom.mas_equalTo(self.mas_bottom).offset(-15);
        }];

        
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    UIEdgeInsets contentInsets = self.model.contentViewInsets;
    CGFloat tableViewWidth = self.superview.width;
    CGSize contentSize = [self.model contentSize:tableViewWidth];
    
    CGRect imageViewFrame = CGRectMake(contentInsets.left, contentInsets.top, contentSize.width, contentSize.height);
    self.msgLabel.frame = imageViewFrame;
//    self.contentView.frame  = imageViewFrame;
    //    CALayer *maskLayer = [CALayer layer];
    //    maskLayer.cornerRadius = 13.0;
    //    maskLayer.backgroundColor = [UIColor blackColor].CGColor;
    //    maskLayer.frame = self.contentView.bounds;
    //    self.contentView.layer.mask = maskLayer;
}

- (void)refresh:(NIMMessageModel *)data {
    [super refresh:data];
    NIMCustomObject *custom = (NIMCustomObject *)data.message.messageObject;
    NobleNotifyAttachment *attachment = (NobleNotifyAttachment*)custom.attachment;
    self.msgLabel.text = attachment.msg;
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    if ([self.delegate respondsToSelector:@selector(onCatchEvent:)]) {
        NIMKitEvent *event = [[NIMKitEvent alloc] init];
        event.eventName = XCNobleNotifyMessageViewClick;
        event.messageModel = self.model;
        event.data = self;
        [self.delegate onCatchEvent:event];
    }
}

#pragma mark - Getter

- (UILabel *)msgLabel {
    if (_msgLabel == nil) {
        _msgLabel = [[UILabel alloc]init];
        _msgLabel.numberOfLines = 0;
        _msgLabel.font = [UIFont systemFontOfSize:15];
        }
    return _msgLabel;
}

@end
