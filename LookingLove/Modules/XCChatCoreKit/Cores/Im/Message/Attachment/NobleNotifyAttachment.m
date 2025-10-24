//
//  NobleNotifyAttachment.m
//  BberryCore
//
//  Created by 卫明何 on 2018/1/18.
//  Copyright © 2018年 chenran. All rights reserved.
//

#import "NobleNotifyAttachment.h"

@implementation NobleNotifyAttachment
- (NSString *)cellContent:(NIMMessage *)message{
    return @"XCNobleNotifyContentView";
}

- (CGSize)contentSize:(NIMMessage *)message cellWidth:(CGFloat)width{
    NIMCustomObject *object = (NIMCustomObject *)message.messageObject;
    NobleNotifyAttachment *customObject = (NobleNotifyAttachment*)object.attachment;
    CGFloat height = [customObject.msg boundingRectWithSize:CGSizeMake([UIScreen mainScreen].bounds.size.width - 130, CGFLOAT_MAX) options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]} context:nil].size.height;
    return CGSizeMake([UIScreen mainScreen].bounds.size.width - 120, height);
}


@end

