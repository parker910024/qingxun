//
//  XCLittleWorldAutoQuitMessageContentView.m
//  XC_TTMessageMoudle
//
//  Created by Lee on 2019/10/31.
//  Copyright © 2019 WJHD. All rights reserved.
//

#import "XCLittleWorldAutoQuitMessageContentView.h"
#import "XCLittleWorldAutoQuitView.h"
#import "UIImage+Utils.h"
#import "UIView+NIM.h"
#import "XCLittleWorldAutoQuitAttachment.h"

@interface XCLittleWorldAutoQuitMessageContentView ()<XCLittleWorldAutoQuitViewDelegate>
// 实体view
@property (nonatomic, strong) XCLittleWorldAutoQuitView *autoQuitView;
@end

@implementation XCLittleWorldAutoQuitMessageContentView

- (instancetype)initSessionMessageContentView {
    if (self = [super initSessionMessageContentView]) {
        [self addSubview:self.autoQuitView];
    }
    return self;
}

- (void)refresh:(NIMMessageModel *)data {
    [super refresh:data];
    NIMCustomObject * object = data.message.messageObject;
    Attachment * attach = (Attachment *)object.attachment;
    self.bubbleImageView.hidden = YES;
    if (attach.first == Custom_Noti_Header_Room_LittleWorldQuit) {
        if (attach.second == Custom_Noti_Sub_Room_LittleWorldQuit) {
            MessageLayout *layout = [MessageLayout yy_modelWithJSON:attach.data[@"layout"]];
            self.autoQuitView.layout = layout;
        }
    }
}

- (void)onClickAutoQuitViewButtonAction:(UIButton *)btn {
    if ([self.delegate respondsToSelector:@selector(onCatchEvent:)]) {
        NIMKitEvent *event = [[NIMKitEvent alloc] init];
        event.eventName = @"XCLittleWorldAutoQuitMessageContentViewClick";
        event.messageModel = self.model;
        event.data = self;
        [self.delegate onCatchEvent:event];
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.autoQuitView.nim_top = 0;
    self.autoQuitView.nim_left = 0;
    self.autoQuitView.nim_size = self.nim_size;
}

- (XCLittleWorldAutoQuitView *)autoQuitView {
    if (!_autoQuitView) {
        _autoQuitView = [[XCLittleWorldAutoQuitView alloc] init];
        _autoQuitView.delegate = self;
    }
    return _autoQuitView;
}

@end
