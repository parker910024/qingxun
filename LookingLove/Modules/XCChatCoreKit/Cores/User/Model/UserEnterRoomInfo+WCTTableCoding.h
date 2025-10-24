//
//  UserEnterRoomInfo+WCTTableCoding.h
//  XCChatCoreKit
//
//  Created by zoey on 2018/12/4.
//  Copyright © 2018年 KevinWang. All rights reserved.
//

#import "UserEnterRoomInfo.h"
#import "WCDBObjc.h"

@interface UserEnterRoomInfo ()<WCTTableCoding>
WCDB_PROPERTY(enterRoomUid)
WCDB_PROPERTY(enterTime)
@end
