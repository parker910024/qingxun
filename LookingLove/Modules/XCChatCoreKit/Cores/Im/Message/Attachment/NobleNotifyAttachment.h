//
//  NobleNotifyAttachment.h
//  BberryCore
//
//  Created by 卫明何 on 2018/1/18.
//  Copyright © 2018年 chenran. All rights reserved.
//

//贵族


#import "Attachment.h"
#import <NIMSDK/NIMSDK.h>
#import "XCCustomAttachmentInfo.h"

@interface NobleNotifyAttachment : Attachment<NIMCustomAttachment,XCCustomAttachmentInfo>
@property (nonatomic,assign)UserID uid;
@property (nonatomic,copy) NSString *msg;
@end

