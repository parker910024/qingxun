//
//  PublicChatAtMemberAttachment.m
//  XCChatCoreKit
//
//  Created by 卫明 on 2018/11/7.
//  Copyright © 2018 KevinWang. All rights reserved.
//

#import "PublicChatAtMemberAttachment.h"

@implementation PublicChatAtMemberAttachment

- (NSString *)cellContent:(NIMMessage *)message{
    return @"XCUpgradeMessageContentView";
}

- (CGSize)contentSize:(NIMMessage *)message cellWidth:(CGFloat)width{
    
    return CGSizeMake(219, 100);
}

@end
