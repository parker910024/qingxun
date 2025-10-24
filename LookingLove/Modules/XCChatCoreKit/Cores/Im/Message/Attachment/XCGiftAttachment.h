//
//  XCGiftAttachment.h
//  Bberry
//
//  Created by 卫明何 on 2017/10/16.
//  Copyright © 2017年 XC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <NIMSDK/NIMSDK.h>
#import "XCCustomAttachmentInfo.h"
#import "Attachment.h"

@interface XCGiftAttachment : Attachment<NIMCustomAttachment,XCCustomAttachmentInfo>

//avatar = "https://nos.netease.com/nim/NDI3OTA4NQ==/bmltYV83Nzg4OTc1NTFfMTUwNjg0NzEzNTI5MV83OTFmMWZlYS1iNjc4LTQ5YzQtOGZkYS01YjhlOTA5YTEzNWY=";
//giftId = 1010;
//giftNum = 1;
//nick = "\U5c0f\U83ab";
//targetUid = 90649;
//uid = 90663;

@property (copy, nonatomic) NSString *giftPic;
@property (copy, nonatomic) NSString *giftName;
@property (copy, nonatomic) NSString *giftNum;

- (NSString *)cellContent:(NIMMessage *)message;
- (CGSize)contentSize:(NIMMessage *)message cellWidth:(CGFloat)width;
@end
