//
//  XCRedPacketInfoAttachment.h
//  Bberry
//
//  Created by 卫明何 on 2017/10/16.
//  Copyright © 2017年 XC. All rights reserved.
//
// xcRedColor

#import <Foundation/Foundation.h>
#import <NIMSDK/NIMSDK.h>
#import "XCCustomAttachmentInfo.h"
#import "Attachment.h"

@interface XCRedPacketInfoAttachment : Attachment<NIMCustomAttachment,XCCustomAttachmentInfo>

@property (copy, nonatomic) NSString *title;

- (NSString *)cellContent:(NIMMessage *)message;
- (CGSize)contentSize:(NIMMessage *)message cellWidth:(CGFloat)width;

@end
