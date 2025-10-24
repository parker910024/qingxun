//
//  XCDidFinishLaunch.h
//  XCChatCoreKit
//
//  Created by Macx on 2019/6/27.
//  Copyright © 2019 YiZhuan. All rights reserved.
//  

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface XCDidFinishLaunch : NSObject
/**
 处理程序启动完毕后, 初始化一些需要初始化的core.
 使用时机, 在BaseTabBarViewController的viewDidAppear方法中初始化
 */
+ (void)didFinishLaunchAction;
@end

NS_ASSUME_NONNULL_END
