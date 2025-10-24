//
//  XCGiftAttachment.m
//  Bberry
//
//  Created by 卫明何 on 2017/10/16.
//  Copyright © 2017年 XC. All rights reserved.
//
// 礼物

#import "XCGiftAttachment.h"


@implementation XCGiftAttachment


- (NSString *)cellContent:(NIMMessage *)message {

    return @"XCGiftContentMessageView";
}

- (CGSize)contentSize:(NIMMessage *)message cellWidth:(CGFloat)width {

    return CGSizeMake(185, 60);
}


@end
