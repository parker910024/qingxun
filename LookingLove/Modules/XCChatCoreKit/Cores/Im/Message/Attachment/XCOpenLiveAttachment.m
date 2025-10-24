//
//  XCOpenLiveAttachment.m
//  Bberry
//
//  Created by 卫明何 on 2017/10/16.
//  Copyright © 2017年 XC. All rights reserved.
//

#import "XCOpenLiveAttachment.h"

@implementation XCOpenLiveAttachment

- (NSString *)cellContent:(NIMMessage *)message {
    return @"XCOpenLiveAlertMessageContentView";
}


- (CGSize)contentSize:(NIMMessage *)message cellWidth:(CGFloat)width {

    return CGSizeMake(200, 50);
}



@end


