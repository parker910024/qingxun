//
//  XCCPGamePrivateAttachment.m
//  XCChatCoreKit
//
//  Created by new on 2019/2/15.
//  Copyright © 2019 KevinWang. All rights reserved.
//

#import "XCCPGamePrivateAttachment.h"
#import "NSObject+YYModel.h"
@implementation XCCPGamePrivateAttachment

- (NSString *)cellContent:(NIMMessage *)message{
    return @"XCCPGamePrivateChatView";
}

- (CGSize)contentSize:(NIMMessage *)message cellWidth:(CGFloat)width{
    //    NIMCustomObject *object = (NIMCustomObject *)message.messageObject;
    //    XCCPGamePrivateAttachment *customObject = (XCCPGamePrivateAttachment*)object.attachment;
    //    if (!(customObject.avatar.length > 0 && customObject.title.length > 0)) {
    //        customObject = [XCCPGamePrivateAttachment yy_modelWithJSON:customObject.data];
    //    }
    //    CGFloat height = [customObject.title boundingRectWithSize:CGSizeMake([UIScreen mainScreen].bounds.size.width - 130, CGFLOAT_MAX) options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil].size.height;
    //    return CGSizeMake([UIScreen mainScreen].bounds.size.width - 120, height + 65);
    return CGSizeMake(180, 140);
}

@end
