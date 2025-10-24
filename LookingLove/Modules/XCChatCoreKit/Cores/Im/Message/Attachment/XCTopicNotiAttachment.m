//
//  XCTopicNotiAttachment.m
//  XCChatCoreKit
//
//  Created by zoey on 2019/3/4.
//  Copyright © 2019年 YiZhuan. All rights reserved.
//

#import "XCTopicNotiAttachment.h"

@implementation XCTopicNotiAttachment


- (NSString *)cellContent:(NIMMessage *)message{
    return @"XCTopicNotiMessageView";
}

- (CGSize)contentSize:(NIMMessage *)message cellWidth:(CGFloat)width{
    NIMCustomObject *object = (NIMCustomObject *)message.messageObject;
    Attachment *att = (Attachment *)object.attachment;
    XCTopicNotiAttachment *customObject = [XCTopicNotiAttachment yy_modelWithJSON:att.data];
    CGFloat maxwidth = [UIScreen mainScreen].bounds.size.width-55-15;
    //    CGFloat messageWidth =  [UIScreen mainScreen].bounds.size.width - 86 - 109;
    CGFloat messageWidth =  maxwidth - 76 - 18;
    CGSize size = [customObject.msg boundingRectWithSize:CGSizeMake(messageWidth, CGFLOAT_MAX) options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil].size;
    
    return CGSizeMake(maxwidth,size.height+51);
    return CGSizeMake(maxwidth,size.height + 35);
}



@end
