//
//  XCNewsInfoAttachment.m
//  Bberry
//
//  Created by 卫明何 on 2017/10/16.
//  Copyright © 2017年 XC. All rights reserved.
//

#import "XCNewsInfoAttachment.h"

@implementation XCNewsInfoAttachment

- (NSString *)cellContent:(NIMMessage *)message {
    return @"XCNewsNoticeContentMessageView";
}

- (CGSize)contentSize:(NIMMessage *)message cellWidth:(CGFloat)width {
    
    return CGSizeMake(240, 205);
}


@end
