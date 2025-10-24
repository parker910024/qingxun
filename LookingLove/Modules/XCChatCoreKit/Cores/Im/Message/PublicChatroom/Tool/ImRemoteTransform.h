//
//  ImRemoteTransform.h
//  AFNetworking
//
//  Created by 卫明 on 2018/11/14.
//

#import <Foundation/Foundation.h>

#import <NIMSDK/NIMMessage.h>
#import "ImRemoteMessage.h"

NS_ASSUME_NONNULL_BEGIN

@interface ImRemoteTransform : NSObject

+ (NSArray<NIMMessage *> *)remoteArrToNIMMessages:(NSArray<ImRemoteMessage *> *)messages;

+ (NIMMessage *)remoteTransformToNIMMessage:(ImRemoteMessage *)remoteMessage;

@end

NS_ASSUME_NONNULL_END
