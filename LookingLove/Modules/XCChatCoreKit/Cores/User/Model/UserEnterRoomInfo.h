//
//  UserEnterRoomInfo.h
//  XCChatCoreKit
//
//  Created by zoey on 2018/12/4.
//  Copyright © 2018年 KevinWang. All rights reserved.
//

#import "BaseObject.h"

@interface UserEnterRoomInfo : BaseObject

@property (copy , nonatomic) NSString *enterRoomUid;//房间的uid
@property (copy , nonatomic) NSString *enterTime;//进入的时间

@end
