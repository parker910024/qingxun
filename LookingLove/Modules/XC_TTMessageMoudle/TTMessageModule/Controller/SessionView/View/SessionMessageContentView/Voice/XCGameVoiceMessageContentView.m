//
//  XCGameVoiceMessageContentView.m
//  XC_TTMessageMoudle
//
//  Created by fengshuo on 2019/6/5.
//  Copyright © 2019 WJHD. All rights reserved.
//

#import "XCGameVoiceMessageContentView.h"
#import "XCGmaeVoiceMessageView.h"
#import "UIView+NIM.h"
#import "XCGameVoiceBottleAttachment.h"
#import <Masonry/Masonry.h>

NSString * const XCGameVoiceMessageContentViewClick = @"XCGameVoiceMessageContentViewClick";

@interface XCGameVoiceMessageContentView ()<XCGmaeVoiceMessageViewDelegate>
/** 显示内容的View*/
@property (nonatomic,strong) XCGmaeVoiceMessageView *messageContentView;
@end

@implementation XCGameVoiceMessageContentView

- (instancetype)initSessionMessageContentView {
    if (self = [super initSessionMessageContentView]) {
        [self addSubview:self.messageContentView];
        [self initContrations];
    }
    return self;
}

#pragma mark - XCGmaeVoiceMessageViewDelegate
- (void)gameVoiceMessage:(XCGmaeVoiceMessageView *)messageView didClickButtonWith:(P2PInteractive_SkipType)skipType {
    if ([self.delegate respondsToSelector:@selector(onCatchEvent:)]) {
        NIMKitEvent *event = [[NIMKitEvent alloc] init];
        event.eventName = XCGameVoiceMessageContentViewClick;
        event.messageModel = self.model;
        event.data = self;
        [self.delegate onCatchEvent:event];
    }
}

- (void)refresh:(NIMMessageModel *)data {
    [super refresh:data];
    NIMCustomObject *object = (NIMCustomObject *)data.message.messageObject;
     XCGameVoiceBottleAttachment *attach = (XCGameVoiceBottleAttachment*)object.attachment;
    if (attach.first == Custom_Noti_Header_Game_VoiceBottle) {
            self.messageContentView.attach = attach;
    }
}

- (void)initContrations {
    [self.messageContentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self);
    }];

}


- (XCGmaeVoiceMessageView *)messageContentView {
    if (!_messageContentView) {
        _messageContentView = [[XCGmaeVoiceMessageView alloc] init];
        _messageContentView.delegate = self;
    }
    return _messageContentView;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
