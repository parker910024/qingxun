//
//  XCGiftContentMessageView.m
//  XChat
//
//  Created by 卫明何 on 2017/10/16.
//  Copyright © 2017年 XC. All rights reserved.
//

#import "XCGiftContentMessageView.h"
#import "XCGiftMessageView.h"
#import "XCGiftAttachment.h"
#import "UIView+NIM.h"

#import <SDWebImage/UIImageView+WebCache.h>
#import "NSObject+YYModel.h"
#import "GiftAllMicroSendInfo.h"
#import "GiftCore.h"
#import "XCMacros.h"
#import "UIImageView+QiNiu.h"

#import "XCTheme.h"

NSString *const XCGiftContentMessageViewClick  = @"XCGiftContentMessageViewClick";

@interface XCGiftContentMessageView()
@property (strong, nonatomic) XCGiftMessageView *contentView;
@end

@implementation XCGiftContentMessageView

- (instancetype)initSessionMessageContentView {
    self = [super initSessionMessageContentView];
    if (self) {
        [self addSubview:self.contentView];
    }
    return self;
}

- (void)refresh:(NIMMessageModel *)data {
    [super refresh:data];
    NIMCustomObject *obj = (NIMCustomObject *)data.message.messageObject;
    Attachment * attach = obj.attachment;
    XCGiftAttachment *attachment = [[XCGiftAttachment alloc]init];
    if ([obj.attachment isKindOfClass:[XCGiftAttachment class]]) {
        attachment =  (XCGiftAttachment *)obj.attachment;
    }else if ([obj.attachment isKindOfClass:[Attachment class]]) {
        Attachment * att = (Attachment *)obj.attachment;
        GiftInfo *info = [GetCore(GiftCore)findGiftInfoByGiftId:[att.data[@"giftId"] integerValue]];
        if (!info) {
            info = [GiftInfo yy_modelWithDictionary:att.data[@"gift"]];
        }
        attachment.giftPic = info.giftUrl;
        attachment.giftNum = att.data[@"giftNum"];
        attachment.giftName = info.giftName;
    }
    NSString * name = attach.data[@"targetNick"] ? attach.data[@"targetNick"] : @"";
    [_contentView.giftImageView qn_setImageImageWithUrl:attachment.giftPic placeholderImage:[XCTheme defaultTheme].default_avatar type:ImageTypeRoomMagic];
    [_contentView.giftNum setText:[NSString stringWithFormat:@"赠给%@",name]];
    [_contentView.giftName setText:[NSString stringWithFormat:@"%@  X%@",attachment.giftName, attachment.giftNum]];
    if (self.model.message.isOutgoingMsg) {
        self.contentView.giftName.textColor = [UIColor whiteColor];
        self.contentView.giftNum.textColor = UIColorRGBAlpha(0xffffff, 0.8);
        self.contentView.giftImageView.backgroundColor = [UIColor whiteColor];
    }else {
        self.contentView.giftName.textColor = [XCTheme getTTMainTextColor];
        self.contentView.giftNum.textColor = [XCTheme getTTDeepGrayTextColor];
        self.contentView.giftImageView.backgroundColor = UIColorFromRGB(0xf7f7f7);
    }
}

- (void)layoutSubviews{
    [super layoutSubviews];
    self.contentView.nim_left = 0;
    self.contentView.nim_size = self.nim_size;
    self.contentView.nim_top = 0;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if ([self.delegate respondsToSelector:@selector(onCatchEvent:)]) {
        NIMKitEvent *event = [[NIMKitEvent alloc] init];
        event.eventName = XCGiftContentMessageViewClick;
        event.messageModel = self.model;
        event.data = self;
        [self.delegate onCatchEvent:event];
    }
}

- (XCGiftMessageView *)contentView {
    if (!_contentView) {
        _contentView = [[XCGiftMessageView alloc] init];
    }
    return _contentView;
}

@end
