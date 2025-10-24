//
//  RoomQueueAttachment.h
//  BberryCore
//
//  Created by 卫明何 on 2017/9/11.
//  Copyright © 2017年 chenran. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Attachment.h"
#import <NIMSDK/NIMSDK.h>
#import "RoomQueue.h"
#import "BaseObject.h"

@interface RoomQueueAttachment : BaseObject <NIMCustomAttachment>

@property (assign, nonatomic) UserID uid;
@property (strong, nonatomic) RoomQueue *roomQueue;
@property (copy, nonatomic) NSDictionary *encodeAttachment;

@end
