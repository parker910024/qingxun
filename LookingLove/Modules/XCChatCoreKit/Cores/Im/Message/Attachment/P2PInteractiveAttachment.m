//
//  P2PInteractive.m
//  BberryCore
//
//  Created by 卫明何 on 2018/4/9.
//  Copyright © 2018年 chenran. All rights reserved.
//

#import "P2PInteractiveAttachment.h"

@implementation P2PInteractiveAttachment

- (NSString *)cellContent:(NIMMessage *)message{
    return @"XCP2PInteractiveView";
}

- (CGSize)contentSize:(NIMMessage *)message cellWidth:(CGFloat)width{
    NIMCustomObject *object = (NIMCustomObject *)message.messageObject;
    if ([object.attachment isKindOfClass:[P2PInteractiveAttachment class]]) {
        P2PInteractiveAttachment *customObject = (P2PInteractiveAttachment*)object.attachment;
        CGSize size = [customObject.msg boundingRectWithSize:CGSizeMake([UIScreen mainScreen].bounds.size.width - 130, CGFLOAT_MAX) options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]} context:nil].size;
        return CGSizeMake(size.width + 5, size.height + 5);
    }else {
        Attachment *att = (Attachment *)object.attachment;
        
        P2PInteractiveAttachment *customObject = [P2PInteractiveAttachment yy_modelWithJSON:att.data];
        CGSize size = [customObject.msg boundingRectWithSize:CGSizeMake([UIScreen mainScreen].bounds.size.width - 130, CGFLOAT_MAX) options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]} context:nil].size;
        return CGSizeMake(size.width + 5, size.height +5);
    }
    
}


@end
