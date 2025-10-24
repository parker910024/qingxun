//
//  XCUserUpgradeAttachment.h
//  BberryCore
//
//  Created by KevinWang on 2018/6/21.
//  Copyright © 2018年 chenran. All rights reserved.
//
// 用户升级attachemt

#import "Attachment.h"
#import <NIMSDK/NIMSDK.h>
#import "XCCustomAttachmentInfo.h"

@interface XCUserUpgradeAttachment : Attachment<NIMCustomAttachment,XCCustomAttachmentInfo>

@property (nonatomic,assign)UserID uid;
@property (nonatomic, copy) NSString *levelName;
//@property (nonatomic, copy) NSString *experLevelName;//用户等级
//@property (nonatomic, copy) NSString *charmLevelName;//魅力等级

@end
