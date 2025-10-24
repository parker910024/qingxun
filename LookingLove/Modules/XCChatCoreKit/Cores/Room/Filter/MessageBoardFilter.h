//
//  MessageBoardFilter.h
//  XCChatCoreKit
//
//  Created by 卫明 on 2019/1/24.
//  Copyright © 2019 KevinWang. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Attachment.h"

NS_ASSUME_NONNULL_BEGIN

@interface MessageBoardFilter : NSObject


/**
 是否支持的信息, 仅适用房间公屏

 @param message 云信消息实体
 @return 是否支持
 */
+ (BOOL)isSupportMsg:(NIMMessage *)message;

@end

NS_ASSUME_NONNULL_END
