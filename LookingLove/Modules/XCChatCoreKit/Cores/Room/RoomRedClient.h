//
//  RoomRedClient.h
//  XCChatCoreKit
//
//  Created by lvjunhang on 2020/7/27.
//  Copyright © 2020 YiZhuan. All rights reserved.
//  红包相关client

#import <Foundation/Foundation.h>

#import "XCRedAuthorityAttachment.h"

NS_ASSUME_NONNULL_BEGIN

@protocol RoomRedClient <NSObject>
/// 收到当前房间发红包的消息
- (void)onReceiveCurrentRoomSendRed;
/// 红包显示权限修改通知
- (void)onReceiveRedAuthorityChange:(XCRedAuthorityAttachment *)attach;
@end

NS_ASSUME_NONNULL_END
