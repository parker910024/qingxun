//
//  XCNewsInfoAttachment.h
//  Bberry
//
//  Created by 卫明何 on 2017/10/16.
//  Copyright © 2017年 XC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <NIMSDK/NIMSDK.h>
#import "XCCustomAttachmentInfo.h"
#import "Attachment.h"

@interface XCNewsInfoAttachment : Attachment<NIMCustomAttachment,XCCustomAttachmentInfo>
@property (copy, nonatomic) NSString *title;
@property (copy, nonatomic) NSString *pic;
@property (copy, nonatomic) NSString *subTitle;
@property (copy, nonatomic) NSString *skipUrl;

@property (copy, nonatomic) NSString *picUrl;
@property (copy, nonatomic) NSString *desc;
@property (copy, nonatomic) NSString *webUrl;

- (NSString *)cellContent:(NIMMessage *)message;
- (CGSize)contentSize:(NIMMessage *)message cellWidth:(CGFloat)width;
@end
