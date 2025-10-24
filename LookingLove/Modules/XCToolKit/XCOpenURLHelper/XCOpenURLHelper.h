//
//  XCOpenURLHelper.h
//  XCToolKit
//
//  Created by lvjunhang on 2019/9/18.
//  Copyright © 2019 YiZhuan. All rights reserved.
//  URL打开辅助工具

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface XCOpenURLHelper : NSObject

/**
 打开APP设置页面
 */
+ (void)openSetttings;

/**
 打电话
 */
+ (void)call:(NSString *)phoneNumber;

/**
 发邮件
 */
+ (void)mailto:(NSString *)mailAddress;

/**
 打开URL
 */
+ (void)openURL:(NSURL *)url;

/**
 打开URL
 
 @param url 链接地址
 @param options 可选参数，传空：@{}
 @param completionHandler 结果回调
 */
+ (void)openURL:(NSURL *)url
        options:(NSDictionary<UIApplicationOpenExternalURLOptionsKey, id> *)options
completionHandler:(void(^ __nullable)(BOOL success))completionHandler;

@end

NS_ASSUME_NONNULL_END
