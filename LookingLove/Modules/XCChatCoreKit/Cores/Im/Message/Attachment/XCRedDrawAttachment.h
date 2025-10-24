//
//  XCRedDrawAttachment.h
//  XCChatCoreKit
//
//  Created by lvjunhang on 2020/5/18.
//  Copyright © 2020 YiZhuan. All rights reserved.
//  抢到红包

#import "Attachment.h"

NS_ASSUME_NONNULL_BEGIN

@interface XCRedDrawAttachment : Attachment
@property (nonatomic, copy) NSString *recvUserNick;//抢红包的
@property (nonatomic, copy) NSString *amount;//抢到多少
@property (nonatomic, copy) NSString *sendUserNick;//发红包的
@end

NS_ASSUME_NONNULL_END
