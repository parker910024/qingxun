//
//  XCSinglePing.h
//  XCToolKit
//
//  Created by KevinWang on 2019/7/27.
//  Copyright © 2019 YiZhuan. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class XCPingItem;

typedef void(^PingCallBack)(XCPingItem *pingitem);

typedef NS_ENUM(NSUInteger, XCSinglePingStatus) {
    XCSinglePingStatusDidStart,
    XCSinglePingStatusDidFailToSendPacket,
    XCSinglePingStatusDidReceivePacket,
    XCSinglePingStatusDidReceiveUnexpectedPacket,
    XCSinglePingStatusDidTimeOut,
    XCSinglePingStatusDidError,
    XCSinglePingStatusDidFinished,
};

@interface XCPingItem : NSObject
// 主机名
@property (nonatomic, copy) NSString *hostName;
// 单次耗时
@property (nonatomic, assign) double millSecondsDelay;
// 当前ping状态
@property (nonatomic, assign) XCSinglePingStatus status;

@end

@interface XCSinglePing : NSObject

+ (instancetype)startWithHostName:(NSString *)hostName count:(NSInteger)count pingCallBack:(PingCallBack)pingCallBack;

- (instancetype)initWithHostName:(NSString *)hostName count:(NSInteger)count pingCallBack:(PingCallBack)pingCallBack;

@end


NS_ASSUME_NONNULL_END
