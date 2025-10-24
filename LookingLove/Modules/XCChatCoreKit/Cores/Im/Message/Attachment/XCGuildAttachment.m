//
//  XCGuildAttachment.m
//  XCChatCoreKit
//
//  Created by lvjunhang on 2019/1/15.
//  Copyright © 2019 KevinWang. All rights reserved.
//

#import "XCGuildAttachment.h"

#import <YYText/YYText.h>
#import "UIColor+UIColor_Hex.h"
#import "AttributedStringDataModel.h"
#import "FamilyCore.h"

//操作面板固定高度
CGFloat const XCGuildAttachmentPanelHeight = 40.0f;

@implementation XCGuildAttachment

- (NSString *)cellContent:(NIMMessage *)message {
    return @"XCGuildMessageContentView";
}

- (CGSize)contentSize:(NIMMessage *)message cellWidth:(CGFloat)width {
    NIMCustomObject *object = (NIMCustomObject *)message.messageObject;
    XCGuildAttachment *attachment = (XCGuildAttachment*)object.attachment;
    
    YYTextLayout *layout = [YYTextLayout layoutWithContainerSize:CGSizeMake(width - 130, CGFLOAT_MAX) text:[self contentAttributedStringWithAttachment:attachment messageId:message.messageId]];
    
    CGFloat contenHeight = layout.textBoundingSize.height;
    CGFloat headerHeight = 40;
    CGFloat controlPanelHeight = [attachment panelViewHeight];
    CGFloat totalHeight = controlPanelHeight + contenHeight + headerHeight;
    
    return CGSizeMake(width-60*2, totalHeight + 15);
}

#pragma mark - Public Methods
//操作面板高度
- (CGFloat)panelViewHeight {
    return [self shouldShowPanelView] ? XCGuildAttachmentPanelHeight : CGFLOAT_MIN;
}

#pragma mark - Private Methods
//是否显示操作面板
- (BOOL)shouldShowPanelView {
    if (self.second != Custom_Noti_Sub_HALL_NOTICE &&
        self.second != Custom_Noti_Sub_HALL_BECOME_CHIEF) {
        return YES;
    }
    return NO;
}

- (NSMutableAttributedString *)contentAttributedStringWithAttachment:(XCGuildAttachment *)attachment messageId:(NSString *)messageId {
    
    AttributedStringDataModel *data = [GetCore(FamilyCore) queryAttrByMessageId:messageId];
    if ([data isKindOfClass:AttributedStringDataModel.class]) {
        return data.attributedString;
    }
    
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
    [GetCore(FamilyCore)saveAttributedString:attr WithMessageId:messageId isComplete:NO];
    return attr;
}

@end
