//
//  XCLittleWorldAttachment.m
//  XCChatCoreKit
//
//  Created by fengshuo on 2019/7/9.
//  Copyright © 2019 YiZhuan. All rights reserved.
//

#import "XCLittleWorldAttachment.h"

@implementation XCLittleWorldAttachment

- (CGSize)contentSize:(NIMMessage *)message cellWidth:(CGFloat)width {
    return CGSizeMake(151, 30);
}

- (NSString *)cellContent:(NIMMessage *)message {
    return @"XCLittleWorldMessageContentView";
}

@end
