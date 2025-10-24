//
//  LookingLoveMain.h
//  LookingLoveManager
//
//  Created by KevinWang on 2019/10/29.
//  Copyright © 2019 WUJIE INTERACTIVE. All rights reserved.
//
/*
 AppDelegate 使用
 */

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LookingLoveMain : NSObject

+ (void)lookingLoveDidFinishLaunchingWithOptions;

+ (void)lookingLoveApplicationWillResignActive;

+ (void)lookingLoveApplicationDidEnterBackground;

+ (void)lookingLoveApplicationWillEnterForeground;

+ (void)lookingLoveApplicationDidBecomeActive;

+ (void)lookingLoveApplicationWillTerminate;

@end

NS_ASSUME_NONNULL_END
