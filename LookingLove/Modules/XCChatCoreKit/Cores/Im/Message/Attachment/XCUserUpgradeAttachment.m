//
//  XCUserUpgradeAttachment.m
//  BberryCore
//
//  Created by KevinWang on 2018/6/21.
//  Copyright © 2018年 chenran. All rights reserved.
//

#import "XCUserUpgradeAttachment.h"

@implementation XCUserUpgradeAttachment

- (NSString *)cellContent:(NIMMessage *)message{
    return @"XCUpgradeMessageContentView";
}

- (CGSize)contentSize:(NIMMessage *)message cellWidth:(CGFloat)width{
    
    return CGSizeMake(219, 100);
}


@end
