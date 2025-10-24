//
//  LocalTimeAdjustManager.h
//  XCChatCoreKit
//
//  Created by KevinWang on 2018/6/2.
//  Copyright © 2018年 XC. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LocalTimeAdjustManager : NSObject

@property (nonatomic, assign) long offset;

@property (nonatomic, assign) long adjustedLocalTimestamp;

+ (instancetype)shareManager;

- (long)localTimestamp;

@end

NS_ASSUME_NONNULL_END
