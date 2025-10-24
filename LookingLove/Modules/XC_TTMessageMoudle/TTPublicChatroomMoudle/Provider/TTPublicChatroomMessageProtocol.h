//
//  TTPublicChatroomMessageProtocol.h
//  TuTu
//
//  Created by 卫明 on 2018/11/1.
//  Copyright © 2018 YiZhuan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GiftAllMicroSendInfo.h"

NS_ASSUME_NONNULL_BEGIN

@protocol TTPublicChatroomMessageProtocol <NSObject>
@optional

- (void)onCurrentPublicChatroomMessageUpdate:(NSMutableArray *)messages;

- (void)onCurrentPublicChatroomSomeBodyAtYou:(NSString *)name;

- (void)onCurrentPublicChatroomReceiveGift:(GiftAllMicroSendInfo *)info;

@end

NS_ASSUME_NONNULL_END
