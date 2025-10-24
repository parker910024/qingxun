//
//  XCRedPacketInfoAttachment.m
//  Bberry
//
//  Created by 卫明何 on 2017/10/16.
//  Copyright © 2017年 XC. All rights reserved.
//

#import "XCRedPacketInfoAttachment.h"

@implementation XCRedPacketInfoAttachment

- (NSString *)cellContent:(NIMMessage *)message {
    return @"XCRecPacketConentMessageView";
}


- (CGSize)contentSize:(NIMMessage *)message cellWidth:(CGFloat)width {
    
    return CGSizeMake(200, 50);
}


@end
