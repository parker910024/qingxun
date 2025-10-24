//
//  RoomMessageClient.h
//  AFNetworking
//
//  Created by 卫明 on 2019/3/7.
//

#import <Foundation/Foundation.h>

#import <NIMSDK/NIMSDK.h>

NS_ASSUME_NONNULL_BEGIN

@protocol RoomMessageClient <NSObject>

- (void)onReceiveMessageNeedDisplayOnScreen:(NIMMessage *)message;

@end

NS_ASSUME_NONNULL_END
