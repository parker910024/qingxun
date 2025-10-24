//
//  GuildOwnerHallInfo.m
//  XCChatCoreKit
//
//  Created by lvjunhang on 2019/1/17.
//  Copyright © 2019 KevinWang. All rights reserved.
//

#import "GuildOwnerHallInfo.h"

@implementation GuildOwnerHallGroupChat


@end

@implementation GuildOwnerHallInfo

+ (NSDictionary<NSString *,id> *)modelContainerPropertyGenericClass {
    return @{@"groupChats" : GuildOwnerHallGroupChat.class};
}
@end
