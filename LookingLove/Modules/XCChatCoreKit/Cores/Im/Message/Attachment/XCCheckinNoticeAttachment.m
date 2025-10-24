//
//  XCCheckinNoticeAttachment.m
//  XCChatCoreKit
//
//  Created by lvjunhang on 2019/3/28.
//  Copyright © 2019 YiZhuan. All rights reserved.
//

#import "XCCheckinNoticeAttachment.h"

@implementation XCCheckinNoticeAttachment

- (NSString *)cellContent:(NIMMessage *)message {
    return @"XCCheckinNoticeMessageContentView";
}

- (CGSize)contentSize:(NIMMessage *)message cellWidth:(CGFloat)width {
    
    NIMCustomObject *object = (NIMCustomObject *)message.messageObject;
    XCCheckinNoticeAttachment *customObject = (XCCheckinNoticeAttachment*)object.attachment;
    
    CGFloat viewWidth = [UIScreen mainScreen].bounds.size.width - 130;
    CGFloat height = [customObject.title boundingRectWithSize:CGSizeMake(viewWidth-20, CGFLOAT_MAX) options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil].size.height;
    return CGSizeMake(viewWidth, height + 90);
}

@end
