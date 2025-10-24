//
//  XCInviteMicAttachment.h
//  BberryCore
//
//  Created by Mac on 2017/12/18.
//  Copyright © 2017年 chenran. All rights reserved.
//

#import "Attachment.h"
#import <NIMSDK/NIMSDK.h>
#import "XCCustomAttachmentInfo.h"

@interface XCInviteMicAttachment : Attachment<NIMCustomAttachment>

//service
@property (nonatomic, copy) NSString *inviteUid;
@property (nonatomic, copy) NSString *position;
//NIMSDK
@property (nonatomic, copy) NSString *uid;
@property (nonatomic, copy) NSString *micPosition;

@property (nonatomic, copy) NSString *handleNick;
@property (nonatomic, copy) NSString *targetNick;

- (NSString *)cellContent:(NIMMessage *)message;
- (CGSize)contentSize:(NIMMessage *)message cellWidth:(CGFloat)width;


@end
