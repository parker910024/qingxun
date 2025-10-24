//
//  XCLittleWorldMessageContentView.m
//  XC_TTMessageMoudle
//
//  Created by fengshuo on 2019/7/9.
//  Copyright © 2019 WJHD. All rights reserved.
//

#import "XCLittleWorldMessageContentView.h"
#import "XCLittleWorldPartyView.h"
#import "XCLittleWorldAttachment.h"
#import "UIView+NIM.h"

NSString *const XCLittleWorldMessageContentViewClick = @"XCLittleWorldMessageContentViewClick";

@interface XCLittleWorldMessageContentView ()

/** ziview */
@property (nonatomic,strong) XCLittleWorldPartyView *partyView;


@end

@implementation XCLittleWorldMessageContentView

- (instancetype)initSessionMessageContentView {
    if (self = [super initSessionMessageContentView]) {
        [self addSubview:self.partyView];
    }
    return self;
}

- (void)refresh:(NIMMessageModel *)data {
    [super refresh:data];
    NIMCustomObject * object = data.message.messageObject;
    Attachment * attach = (Attachment *)object.attachment;
    self.bubbleImageView.hidden = YES;
    if (attach.first == Custom_Noti_Header_Game_LittleWorld) {
        if (attach.second == Custom_Noti_Sub_Little_World_Room_Notify) {
            XCLittleWorldAttachment * littleWorldAttach = [XCLittleWorldAttachment yy_modelWithJSON:attach.data];
             self.partyView.isOutGoing = self.model.message.isOutgoingMsg;
            self.partyView.littleWorldAttach = littleWorldAttach;
           
        }
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if ([self.delegate respondsToSelector:@selector(onCatchEvent:)]) {
        NIMKitEvent *event = [[NIMKitEvent alloc] init];
        event.eventName = XCLittleWorldMessageContentViewClick;
        event.messageModel = self.model;
        event.data = self;
        [self.delegate onCatchEvent:event];
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.partyView.nim_top = 0;
    self.partyView.nim_left = 0;
    self.partyView.nim_size = self.nim_size;
}

- (XCLittleWorldPartyView *)partyView {
    if (!_partyView) {
        _partyView = [[XCLittleWorldPartyView alloc] init];
    }
    return _partyView;
}


@end
