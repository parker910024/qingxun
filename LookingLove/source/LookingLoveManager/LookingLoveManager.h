//
//  LookingLoveManager.h
//  LookingLoveManager
//
//  Created by KevinWang on 2019/10/29.
//  Copyright © 2019 WUJIE INTERACTIVE. All rights reserved.
//
/*
tabBar 使用
*/

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LookingLoveManager : NSObject

//首页
+ (void)lookingLoveHomeWillShow:(NSInteger)showIndex;
+ (void)lookingLoveHomeDidShow:(NSInteger)showIndex;

//发现
+ (void)lookingLoveDiscoverWillShow:(NSInteger)showIndex;
+ (void)lookingLoveDiscoverDidShow:(NSInteger)showIndex;

//消息
+ (void)lookingLoveMessageWillShow:(NSInteger)showIndex;
+ (void)lookingLoveMessageDidShow:(NSInteger)showIndex;

//我的
+ (void)lookingLovePersonalWillShow:(NSInteger)showIndex;
+ (void)lookingLovePersonalDidShow:(NSInteger)showIndex;


@end

NS_ASSUME_NONNULL_END
