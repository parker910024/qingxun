//
//  XCChatterboxPointAttachment.m
//  AFNetworking
//
//  Created by apple on 2019/6/3.
//

#import "XCChatterboxPointAttachment.h"

@implementation XCChatterboxPointAttachment

- (NSString *)cellContent:(NIMMessage *)message{
    return @"XCChatterboxPointContentView";
}

- (CGSize)contentSize:(NIMMessage *)message cellWidth:(CGFloat)width{
    
    return CGSizeMake(34, 40);
}


@end
