//
//  XCLittleWorldAutoQuitAttachment.m
//  XCChatCoreKit
//
//  Created by Lee on 2019/10/31.
//  Copyright © 2019 YiZhuan. All rights reserved.
//

#import "XCLittleWorldAutoQuitAttachment.h"

@implementation XCLittleWorldAutoQuitAttachment


- (CGSize)contentSize:(NIMMessage *)message cellWidth:(CGFloat)width {
    return CGSizeMake([UIScreen mainScreen].bounds.size.width - 65 - 38.5, 144);
}

- (NSString *)cellContent:(NIMMessage *)message {
    return @"XCLittleWorldAutoQuitMessageContentView";
}

@end
