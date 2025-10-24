//
//  XCSessionConfig.h
//  XChat
//
//  Created by 卫明何 on 2017/10/12.
//  Copyright © 2017年 XC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NIMSessionConfig.h"

@interface TTSessionConfig : NSObject<NIMSessionConfig>
@property (nonatomic,strong) NIMSession *session;

/**
 是否为公会的群聊类型，default:NO
 */
@property (nonatomic, assign, getter=isGuildGroupType) BOOL guildGroupType;

/** 是不是房间私聊*/
@property (nonatomic, assign, getter=isRoomMessage) BOOL roomMessage;

@end
