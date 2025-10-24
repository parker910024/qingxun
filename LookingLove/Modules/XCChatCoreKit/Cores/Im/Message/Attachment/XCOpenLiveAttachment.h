//
//  XCOpenLiveAttachment.h
//  Bberry
//
//  Created by 卫明何 on 2017/10/16.
//  Copyright © 2017年 XC. All rights reserved.
//
// 上线

#import <Foundation/Foundation.h>
#import "XCCustomAttachmentInfo.h"
#import <NIMSDK/NIMSDK.h>
#import "Attachment.h"

@interface XCOpenLiveAttachment : Attachment <NIMCustomAttachment,XCCustomAttachmentInfo>

@property (nonatomic, assign) UserID uid;//用户ID
@property (nonatomic, copy) NSString *avatar;
@property (nonatomic, copy) NSString *nick;


- (NSString *)cellContent:(NIMMessage *)message;
- (CGSize)contentSize:(NIMMessage *)message cellWidth:(CGFloat)width;

@end
