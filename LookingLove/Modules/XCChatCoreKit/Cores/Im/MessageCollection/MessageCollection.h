//
//  MessageCollection.h
//  XCChatCoreKit
//
//  Created by KevinWang on 2019/7/17.
//  Copyright © 2019 YiZhuan. All rights reserved.
//

#import "BaseCore.h"
#import <NIMSDK/NIMSDK.h>

NS_ASSUME_NONNULL_BEGIN

@interface MessageCollection : BaseCore

- (void)sendMessageCollectionRequestWithMessage:(NIMMessage *)message
                                firstAttachment:(int)firstAttachment;

- (void)messageCollectionRequestByPullQueueWithArray:(NSArray *)array;
@end

NS_ASSUME_NONNULL_END
