//
//  XCCheckinDrawCoinAttachment.m
//  XCChatCoreKit
//
//  Created by lvjunhang on 2019/3/29.
//  Copyright © 2019 YiZhuan. All rights reserved.
//

#import "XCCheckinDrawCoinAttachment.h"

@implementation XCCheckinDrawCoinAttachment

- (NSString *)cellContent:(NIMMessage *)message {
    return @"XCCheckinDrawCoinMessageContentView";
}

- (CGSize)contentSize:(NIMMessage *)message cellWidth:(CGFloat)width {
    
    NIMCustomObject *object = (NIMCustomObject *)message.messageObject;
    XCCheckinDrawCoinAttachment *customObject = (XCCheckinDrawCoinAttachment*)object.attachment;
    
    NSString *content = [NSString stringWithFormat:@"【签到瓜分百万】哇塞，恭喜%@签到获得%@金币！",customObject.nick, customObject.goldNum];
    CGFloat viewWidth = [UIScreen mainScreen].bounds.size.width - 130;
    CGFloat height = [content boundingRectWithSize:CGSizeMake(viewWidth-20, CGFLOAT_MAX) options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil].size.height;
    return CGSizeMake(viewWidth, height + 16);
}

@end
