//
//  XCLittleWorldPostDynamicSuccessContentView.m
//  XC_TTMessageMoudle
//
//  Created by Lee on 2019/12/12.
//  Copyright © 2019 WJHD. All rights reserved.
//

#import "XCLittleWorldPostDynamicSuccessContentView.h"
#import "XCLittleWorldPostDynamicSuccessView.h"
#import "UIImage+Utils.h"
#import "UIView+NIM.h"

@interface XCLittleWorldPostDynamicSuccessContentView ()
@property (nonatomic, strong) XCLittleWorldPostDynamicSuccessView *postDynamicSuccessView;
@end

@implementation XCLittleWorldPostDynamicSuccessContentView

- (instancetype)initSessionMessageContentView {
    if (self = [super initSessionMessageContentView]) {
        [self addSubview:self.postDynamicSuccessView];
    }
    return self;
}

- (void)refresh:(NIMMessageModel *)data {
    [super refresh:data];
    NIMCustomObject * object = data.message.messageObject;
    Attachment * attach = (Attachment *)object.attachment;
    self.bubbleImageView.hidden = YES;
    if (attach.first == Custom_Noti_Header_Dynamic) {
        if (attach.second == Custom_Noti_Sub_Dynamic_ShareDynamic) {
            self.postDynamicSuccessView.dict = attach.data;
        }
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if ([self.delegate respondsToSelector:@selector(onCatchEvent:)]) {
        NIMKitEvent *event = [[NIMKitEvent alloc] init];
        event.eventName = @"XCLittleWorldPostDynamicSuccessContentViewClick";
        event.messageModel = self.model;
        event.data = self;
        [self.delegate onCatchEvent:event];
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.postDynamicSuccessView.nim_top = 0;
    self.postDynamicSuccessView.nim_left = 0;
    self.postDynamicSuccessView.nim_size = self.nim_size;
    self.postDynamicSuccessView.nim_height = 80;
}

- (XCLittleWorldPostDynamicSuccessView *)postDynamicSuccessView {
    if (!_postDynamicSuccessView) {
        _postDynamicSuccessView = [[XCLittleWorldPostDynamicSuccessView alloc] init];
    }
    return _postDynamicSuccessView;
}

@end
