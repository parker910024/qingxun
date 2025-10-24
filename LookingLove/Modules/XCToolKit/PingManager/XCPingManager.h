//
//  XCPingManager.h
//  XCToolKit
//
//  Created by KevinWang on 2019/7/27.
//  Copyright © 2019 YiZhuan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XCAddressItem : NSObject

@property (nonatomic, copy, readonly) NSString *hostName;
/// average delay time
@property (nonatomic, assign, readonly) double delayMillSeconds;

@property (nonatomic, strong) NSMutableArray *delayTimes;

- (instancetype)initWithHostName:(NSString *)hostName;

@end

typedef void(^CompletionHandler)(NSString *, NSArray *);

NS_ASSUME_NONNULL_BEGIN

@interface XCPingManager : NSObject

+ (instancetype)sharedManager;

- (void)getFatestAddress:(NSArray *)addressList completionHandler:(CompletionHandler)completionHandler;

- (void)getBestAddress:(NSArray *)addressList completionHandler:(CompletionHandler)completionHandler;

@end

NS_ASSUME_NONNULL_END

