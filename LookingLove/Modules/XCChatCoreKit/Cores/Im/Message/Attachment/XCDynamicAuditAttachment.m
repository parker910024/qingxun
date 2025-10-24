//
//  XCDynamicAuditAttachment.m
//  XCChatCoreKit
//
//  Created by lvjunhang on 2019/11/29.
//  Copyright © 2019 YiZhuan. All rights reserved.
//

#import "XCDynamicAuditAttachment.h"

#import "UIColor+UIColor_Hex.h"

#import <YYText/YYText.h>

@implementation XCDynamicAuditAttachment

- (NSString *)cellContent:(NIMMessage *)message {
    return @"DynamicAuditMessageContentView";
}

- (CGSize)contentSize:(NIMMessage *)message cellWidth:(CGFloat)width {
    
    NIMCustomObject *object = (NIMCustomObject *)message.messageObject;
    XCDynamicAuditAttachment *attachment = (XCDynamicAuditAttachment*)object.attachment;
    
    YYTextLayout *layout = [YYTextLayout layoutWithContainerSize:CGSizeMake(width - 130, CGFLOAT_MAX) text:[self contentAttributedStringWithAttachment:attachment messageId:message.messageId]];
    
    CGFloat contentHeight = layout.textBoundingSize.height;
    CGFloat headerHeight = 40;
    CGFloat totalHeight = contentHeight + headerHeight;
    
    return CGSizeMake(width-60*2, totalHeight + 10);
}

#pragma mark - Private Methods
- (NSMutableAttributedString *)contentAttributedStringWithAttachment:(XCDynamicAuditAttachment *)attachment messageId:(NSString *)messageId {
    
    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] init];
    MessageLayout *layout = attachment.layout;
    
    for (LayoutParams *params in layout.contents) {
        NSMutableAttributedString *subAttr = [[NSMutableAttributedString alloc]initWithString:params.content];
        
        if (params.fontSize.length > 0) {
            [subAttr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:[params.fontSize floatValue]] range:NSMakeRange(0, subAttr.length)];
        }
        
        if (params.fontColor.length > 0) {
            [subAttr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:params.fontColor] range:NSMakeRange(0, subAttr.length)];
        }
        
        [attr appendAttributedString:subAttr];
    }
    
    attr.yy_lineSpacing = 5;

    return attr;
}

@end
