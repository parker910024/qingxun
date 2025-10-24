//
//  LookingLoveUtils.h
//  LookingLoveManager
//
//  Created by KevinWang on 2019/10/29.
//  Copyright © 2019 WUJIE INTERACTIVE. All rights reserved.
//
/*
其他 使用
*/

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LookingLoveUtils : NSObject

//开房
+ (void)lookingLoveWillShowRoom:(NSInteger)roomType;

//私聊
+ (void)lookingLoveWillShowP2PChat:(NSInteger)sessionID;

//个人信息
+ (void)lookingLoveWillShowMyInfo:(NSInteger)userID;

//充值
+ (void)lookingLoveWillShowRecharge:(NSInteger)userID;

@end

NS_ASSUME_NONNULL_END
