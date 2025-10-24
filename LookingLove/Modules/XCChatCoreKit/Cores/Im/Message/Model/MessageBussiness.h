//
//  MessageBussiness.h
//  BberryCore
//
//  Created by 卫明何 on 2018/5/25.
//  Copyright © 2018年 chenran. All rights reserved.
//

#import "BaseObject.h"
#import "LayoutParams.h"
#import "MessageLayout.h"
#import "Attachment.h"
#import "XCCustomAttachmentInfo.h"
#import "MessageParams.h"

typedef enum : NSUInteger {
    Message_Bussiness_Status_Untreated              =                1, //未处理
    Message_Bussiness_Status_Agree                  =                2, //已同意
    Message_Bussiness_Status_Refused                =                3, //已拒绝
    Message_Bussiness_Status_OutDate                =                4, //已过期
} Message_Bussiness_Status;

@interface MessageBussiness : Attachment <NIMCustomAttachment,XCCustomAttachmentInfo>
@property (nonatomic,assign) Message_Bussiness_Status status;
@property (nonatomic,assign) UserID approverUid;
@property (nonatomic,strong) NSString *approverNick;
@property (assign, nonatomic) P2PInteractive_SkipType routerType;
@property (strong, nonatomic) NSString *routerValue;
@property (strong, nonatomic) MessageLayout *layout;
@property (strong, nonatomic) NSString *url;
@property (strong, nonatomic) MessageParams *params;
@end
