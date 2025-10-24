//
//  RoomQueueCustomAttachment.h
//  BberryCore
//
//  Created by Mac on 2017/12/19.
//  Copyright © 2017年 chenran. All rights reserved.
//

#import "BaseObject.h"
#import "Attachment.h"
#import <NIMSDK/NIMSDK.h>
#import "MicroState.h"
#import "BaseObject.h"
#import "UserInfo.h"

@interface RoomQueueCustomAttachment : BaseObject<NIMCustomAttachment>
@property (nonatomic, assign) GroupType  groupType;
@property (nonatomic, assign) int micPosition;
/** 操作者的名字*/
@property (nonatomic, copy) NSString *handleNick;
/** 被操作者的uid*/
@property (assign, nonatomic) UserID uid;
/** 被操作者的名字*/
@property (nonatomic, copy) NSString *targetNick;
/** 麦序信息*/
@property (strong, nonatomic) MicroState *microState;
@property (copy, nonatomic) NSDictionary *encodeAttachment;
/**
 操作者的Uid
 */
@property(nonatomic, assign)UserID handleUid;

@end
