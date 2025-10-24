//
//  APNSCore.h
//  BberryCore
//
//  Created by 卫明何 on 2017/9/4.
//  Copyright © 2017年 chenran. All rights reserved.
//

#import "BaseCore.h"

@interface APNSCore : BaseCore

/// 处理远程系统推送消息
/// @param payload 接收到的通知信息
- (void)handleRemoteNotification:(NSDictionary *)payload;

@end
