//
//  XCDynamicPostSuccessAttachment.m
//  XCChatCoreKit
//
//  Created by Lee on 2019/12/12.
//  Copyright © 2019 YiZhuan. All rights reserved.
//

#import "XCDynamicPostSuccessAttachment.h"

@implementation XCDynamicPostSuccessAttachment

- (CGSize)contentSize:(NIMMessage *)message cellWidth:(CGFloat)width {
    return CGSizeMake([UIScreen mainScreen].bounds.size.width - 65 - 38.5 - 65, 80);
}

- (NSString *)cellContent:(NIMMessage *)message {
    return @"XCLittleWorldPostDynamicSuccessContentView";
}

@end
