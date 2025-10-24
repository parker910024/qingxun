//
//  FeedbackAttachment.m
//  XCChatCoreKit
//
//  Created by lvjunhang on 2020/5/9.
//  Copyright © 2020 YiZhuan. All rights reserved.
//

#import "FeedbackAttachment.h"

@implementation FeedbackAttachment

#pragma mark - XCCustomAttachmentInfo
/// 自定义气泡视图
/// @param message 消息内容
- (NSString *)cellContent:(NIMMessage *)message {
    return @"XCFeedbackMessageContentView";
}

/// 自定义气泡视图的大小
/// @param message 消息内容
/// @param width 屏幕宽度
- (CGSize)contentSize:(NIMMessage *)message cellWidth:(CGFloat)width {
    
    NIMCustomObject *object = (NIMCustomObject *)message.messageObject;
    FeedbackAttachment *attach = (FeedbackAttachment *)object.attachment;
    
    NSString *reportContent = [@"举报内容：" stringByAppendingString:attach.content];
    NSString *content = attach.replyType == 0 ? reportContent : attach.content;

    CGFloat viewWidth = width - 106;
    CGFloat contentWidth = viewWidth - 16 * 2 - 10 * 2;
    
    CGFloat titleHeight = [self textHeight:attach.msg width:contentWidth];
    CGFloat subtitleHeight = 17+12*2;//您的反馈内容：+上下间距
    CGFloat contentHeight = [self textHeight:content width:contentWidth];//内容
    CGFloat imageWidth = (contentWidth - 8*3)/4;
    CGFloat imageHeight = attach.imgList.count > 0 ? imageWidth+12 : 0;//12为与内容间隔
    CGFloat replyHeight = [self textHeight:attach.reply width:viewWidth-16*2];//回复
    
    CGFloat bgViewHeight = subtitleHeight + contentHeight + imageHeight + 10;
    if (attach.replyType == 0) {
        bgViewHeight += 46;//举报的用户ID和用户昵称
    }
    
    CGFloat height = 12 + titleHeight + 12 + bgViewHeight + 12 + replyHeight + 12;
    
    return CGSizeMake(viewWidth, height);
}

/// 左对齐的气泡，cell内容距离气泡的内间距
/// @param message 消息内容
- (UIEdgeInsets)contentViewInsets:(NIMMessage *)message {
    return UIEdgeInsetsZero;
}

#pragma mark - Private
- (CGFloat)textHeight:(NSString *)content width:(CGFloat)width {
    CGFloat height = [content boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil].size.height;
    return height;
}

@end
