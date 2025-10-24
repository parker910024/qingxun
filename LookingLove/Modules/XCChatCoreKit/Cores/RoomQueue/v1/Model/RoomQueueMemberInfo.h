//
//  RoomQueueMemberInfo.h
//  BberryCore
//
//  Created by 卫明何 on 2017/9/11.
//  Copyright © 2017年 chenran. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <NIMSDK/NIMSDK.h>
#import "RoomQueue.h"
#import "BaseObject.h"

@interface RoomQueueMemberInfo : NSObject

@property (nonatomic, strong) RoomQueue *roomQueue;
@property (nonatomic, strong) NIMChatroomMember *chatRoomMember;
@property (nonatomic, assign) NSInteger gender;
@end
