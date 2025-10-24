//
//  UserEnterRoomInfo.m
//  XCChatCoreKit
//
//  Created by zoey on 2018/12/4.
//  Copyright © 2018年 KevinWang. All rights reserved.
//

#import "UserEnterRoomInfo.h"
#import "UserEnterRoomInfo+WCTTableCoding.h"
#import "WCDBObjc.h"


@implementation UserEnterRoomInfo

WCDB_IMPLEMENTATION(UserEnterRoomInfo)
WCDB_SYNTHESIZE(enterRoomUid)
WCDB_SYNTHESIZE(enterTime)

WCDB_PRIMARY(enterRoomUid)
WCDB_INDEX("_index", enterRoomUid)



@end
