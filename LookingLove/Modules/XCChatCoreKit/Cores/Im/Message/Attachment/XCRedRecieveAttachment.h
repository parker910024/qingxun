//
//  XCRedRecieveAttachment.h
//  XCChatCoreKit
//
//  Created by lvjunhang on 2020/5/18.
//  Copyright © 2020 YiZhuan. All rights reserved.
//  房间收到红包

#import "Attachment.h"

NS_ASSUME_NONNULL_BEGIN

@interface XCRedRecieveAttachment : Attachment

@property (nonatomic, copy) NSString *notifyText;//红包文案
@property (nonatomic, copy) NSString *startTime;//开始时间
@property (nonatomic, assign) NSInteger roomUid;//房主
@property (nonatomic, copy) NSString *title;//房间标题？
@property (nonatomic, copy) NSString *nick;//发红包的
@property (nonatomic, assign) NSInteger uid;//发红包的

@end

NS_ASSUME_NONNULL_END
