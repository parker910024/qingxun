//
//  XCTipsContentView.m
//  XChat
//
//  Created by 卫明何 on 2018/7/3.
//  Copyright © 2018年 XC. All rights reserved.
//

#import "XCTipsContentView.h"
#import "NIMMessageModel.h"
#import "UIView+NIM.h"
#import "NIMKitUtil.h"
#import "UIImage+NIMKit.h"
#import "NIMKit.h"
#import "RedPacketDetailInfo.h"
#import "AuthCore.h"
#import "XCKeyWordTool.h"

#import "BaseAttrbutedStringHandler.h"
#import <YYText.h>

@implementation XCTipsContentView


- (instancetype)initSessionMessageContentView
{
    if (self = [super initSessionMessageContentView]) {
        _label = [[YYLabel alloc]init];
        _label.numberOfLines = 0;
        [self addSubview:_label];
//        [self initConstrations];
    }
    return self;
}

//
//- (void)initConstrations {
//    [self.label mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.center.mas_equalTo(self.center);
//    }];
//}

- (void)refresh:(NIMMessageModel *)model
{
    [super refresh:model];
    self.label.attributedText = [self messageTipsContent:model.message];
    YYTextLayout *layout = [YYTextLayout layoutWithContainerSize:CGSizeMake([UIScreen mainScreen].bounds.size.width - 130, CGFLOAT_MAX) text:self.label.attributedText];
    self.label.nim_size = CGSizeMake(layout.textBoundingRect.size.width, layout.textBoundingRect.size.height);
    NIMKitSetting *setting = [[NIMKit sharedKit].config settingWithMessageType:NIMMessageTypeTip message:model.message];
    [self.bubbleImageView setImage:[[NIMKit sharedKit].config settingWithMessageType:NIMMessageTypeTip message:model.message].normalBackgroundImage];
    self.label.textColor = setting.textColor;
    self.label.textAlignment = NSTextAlignmentCenter;
    self.label.preferredMaxLayoutWidth = self.nim_width;
    self.label.font = setting.font;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
//    CGFloat padding = [NIMKit sharedKit].config.maxNotificationTipPadding;
//    self.label.nim_size = [self.label sizeThatFits:CGSizeMake(self.nim_width - 2 * padding, CGFLOAT_MAX)];
    self.nim_width = [UIScreen mainScreen].bounds.size.width;
    if (self.frame.origin.x >= 0) {
        self.label.nim_centerX = [UIScreen mainScreen].bounds.size.width * .5f;
    }else {
        self.label.nim_centerX = [UIScreen mainScreen].bounds.size.width * .5f + 26;
    }
    self.label.nim_centerY = self.nim_height * .5f;
    self.bubbleImageView.frame = CGRectInset(self.label.frame, -4, -4);
}

- (UIImage *)chatBubbleImageForState:(UIControlState)state outgoing:(BOOL)outgoing {
    return [[UIImage nim_imageInKit:@"icon_session_time_bg"] resizableImageWithCapInsets:UIEdgeInsetsFromString(@"{8,20,8,20}") resizingMode:UIImageResizingModeStretch];
}

- (NSMutableAttributedString *)messageTipsContent:(NIMMessage *)message {
    
    NSMutableAttributedString *text = nil;
    
    NIMCustomObject *object = (NIMCustomObject *)message.messageObject;
    Attachment *attachment = (Attachment *)object.attachment;
    
    if (attachment.second == Custom_Noti_Sub_Header_Group_RedPacket_Tips) {
        RedPacketDetailInfo *data = [RedPacketDetailInfo yy_modelWithJSON:attachment.data];
        NSMutableAttributedString *att = [[NSMutableAttributedString alloc]init];
        if (data.receiveNick.length > 0) {
            NSString *owner = nil;
            NSString *receiver = nil;
            if (data.receiveUid == [GetCore(AuthCore)getUid].userIDValue && data.senderUid == [GetCore(AuthCore)getUid].userIDValue) { // 自己领取了自己的hb
                receiver = @"你";
                owner = @"你";
            }else if (data.receiveUid == [GetCore(AuthCore)getUid].userIDValue && data.senderUid != [GetCore(AuthCore)getUid].userIDValue) { //自己抢了别人的hb
                receiver = @"你";
                owner = data.nick;
            }else if (data.senderUid == [GetCore(AuthCore)getUid].userIDValue && data.receiveUid != [GetCore(AuthCore)getUid].userIDValue) { //别人抢了自己的hb
                receiver = data.receiveNick;
                owner = @"你";
            }
            
            NSString *str = [NSString stringWithFormat:@"%@领了%@的",receiver,owner];
            
            [att appendAttributedString:[self creatImageAttributedStringWith:[UIImage imageNamed:@"message_chat_red_has_adopt"]]];
            [att appendAttributedString:[BaseAttrbutedStringHandler creatStrAttrByStr:@" "]];
            [att appendAttributedString:[BaseAttrbutedStringHandler creatStrAttrByStr:str]];
            [att appendAttributedString:[BaseAttrbutedStringHandler creatStrAttrByStr:[XCKeyWordTool sharedInstance].xcRedColor]];
            [att setAttributes:@{NSForegroundColorAttributeName:[UIColor redColor]} range:NSMakeRange(att.length - 2, 2)];
            return att;
        }
        
    }
    return text;
}

//图片富文本
- (NSMutableAttributedString *)creatImageAttributedStringWith:(UIImage *)image {
    UIImageView *imageView = [[UIImageView alloc]init];
    imageView.image = image;
    imageView.bounds = CGRectMake(5, 0, image.size.width, image.size.height);
    NSMutableAttributedString * imageString = [NSMutableAttributedString yy_attachmentStringWithContent:imageView contentMode:UIViewContentModeScaleAspectFit attachmentSize:CGSizeMake(imageView.frame.size.width, imageView.frame.size.height) alignToFont:[UIFont systemFontOfSize:15.0] alignment:YYTextVerticalAlignmentCenter];
    return imageString;
}

@end
