//
//  XCChatterboxAttachment.m
//  AFNetworking
//
//  Created by apple on 2019/5/29.
//

#import "XCChatterboxAttachment.h"
#import "XCMacros.h" // 约束的宏定义
#define kScale(x) ((x) / 375.0 * KScreenWidth)

@implementation XCChatterboxAttachment

- (NSString *)cellContent:(NIMMessage *)message{
    NIMCustomObject * object = message.messageObject;
    Attachment * attach = (Attachment *)object.attachment;
    if (attach.first == Custom_Noti_Header_PrivateChat_Chatterbox) {
        if (attach.second == Custom_Noti_Sub_PrivateChat_Chatterbox_Init) {
            return @"XCChatterboxGameHellocContentView";
        }
    }
    return @"XCChatterboxGameContentView";
}

- (CGSize)contentSize:(NIMMessage *)message cellWidth:(CGFloat)width{
    NIMCustomObject * object = message.messageObject;
    Attachment * attach = (Attachment *)object.attachment;
    if (attach.first == Custom_Noti_Header_PrivateChat_Chatterbox) {
        if (attach.second == Custom_Noti_Sub_PrivateChat_Chatterbox_Init) {
            return CGSizeMake([UIScreen mainScreen].bounds.size.width, 83);
        }
    }
    NSInteger height = kScale(517);
    return CGSizeMake(kScale(250), height);
}

@end
