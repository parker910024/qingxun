//
//  ChatRoomInfoModel.h
//  BberryCore
//
//  Created by Mac on 2017/12/8.
//  Copyright © 2017年 chenran. All rights reserved.
//

#import "BaseObject.h"
#import <NIMSDK/NIMSDK.h>
#import "MicroState.h"
#import "UserInfo.h"

@interface ChatRoomMicSequence : BaseObject

//chatRoom ext字段包含roominfo&microstate信息

@property (nonatomic, strong) MicroState *microState;
@property (nonatomic, strong) NIMChatroomMember *chatRoomMember;
@property (nonatomic, strong) UserInfo *userInfo;

@end
