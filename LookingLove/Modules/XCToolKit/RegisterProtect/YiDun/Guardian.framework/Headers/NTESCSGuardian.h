//
//  NTESCSGuardian.h
//  NTESCSGuardian
//
//  Created by NetEase on 16/10/19.
//  Copyright © 2016年 NetEase. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^ NdInfoBlock)(NSString *dToken);

typedef void (^ tokenBlock)(NSString *token);

/**
 设置 timeOut 时间单位
 */
typedef NS_ENUM(NSInteger, NTESCSTimeOutUnit) {
    NTESCSTimeOutSecondUnit = 1,    // 秒级
    NTESCSTimeOutMilliSecondUnit,   // 毫秒级
};

@interface NTESCSGuardian: NSObject

/**
 启动 SDK（默认关闭advanceMode）
 
 @param number 产品编号
 */
+ (void)startWithProductNumber:(NSString *)number;

/**
 启动 SDK（默认关闭advanceMode）
 
 @param number 产品编号
 @param urlPrefix 私有化域名，默认值为 https://ac.dun.163yun.com
 */
+ (void)startWithProductNumber:(NSString *)number urlPrefix:(NSString *)urlPrefix;

/**
 启动 SDK（默认关闭advanceMode）
 
 @param number 产品编号
 @param urlPrefix 私有化域名，默认值为 https://ac.dun.163yun.com
 @param channelName 渠道名称，默认值为 "App Store"
 */
+ (void)startWithProductNumber:(NSString *)number urlPrefix:(NSString *)urlPrefix channelName:(NSString *)channelName;

/**
 启动 SDK
 
 @param number 产品编号
 @param advanceMode 高级模式（为 YES 时需显式调用数据收集开始和停止接口，为 NO 时自动调用）
 @param urlPrefix 私有化域名，默认值为 https://ac.dun.163yun.com
 @param channelName 渠道名称，默认值为 "App Store"
 */
+ (void)startWithProductNumber:(NSString *)number advanceMode:(BOOL)advanceMode urlPrefix:(NSString *)urlPrefix channelName:(NSString *)channelName;

/**
 启动 SDK
 
 @param number 产品编号
 @param advanceMode 高级模式（为 YES 时需显式调用数据收集开始和停止接口，为 NO 时自动调用）
 @param timerMode 定时器模式（为 YES 时需要显式调用打开定时器接口，为 NO 时自动调用）
 @param urlPrefix 私有化域名，默认值为 https://ac.dun.163yun.com
 @param channelName 渠道名称，默认值为 "App Store"
 */
+ (void)startWithProductNumber:(NSString *)number advanceMode:(BOOL)advanceMode timerMode:(BOOL)timerMode urlPrefix:(NSString *)urlPrefix channelName:(NSString *)channelName;

/**
 设置 SDK 开始收集数据
 */
+ (void)start;

/**
 设置 SDK 停止收集数据
 */
+ (void)stop;

/**
 设置 SDK 启动定时器
 */
+ (void)startTimer;

/**
 设置 SDK 停止定时器
 */
+ (void)stopTimer;

/**
 同步获取 businessID 对应的 Token，默认超时时间3s，非多线程安全
 ⚠️ 建议不要使用多线程调用，如果需要多线程调用，请使用异步接口
 
 @param businessID 业务编号
 @return token 字符串
 */
+ (NSString *)getTokenWithBusinessID:(NSString *)businessID;

/**
 同步获取 businessID 对应的 Token，并指定超时时间，非多线程安全
 ⚠️ 建议不要使用多线程调用，如果需要多线程调用，请使用异步接口
 
 @param businessID 业务编号
 @param timeout 超时时间（范围：10s以内）
 @param unit 时间单位，可选秒、毫秒
 @return token 字符串
 */
+ (NSString *)getTokenWithBusinessID:(NSString *)businessID timeout:(int)timeout unit:(NTESCSTimeOutUnit)unit;

/**
 异步获取 businessID 对应的 Token，默认超时3s，多线程安全
 
 @param block 获取Token完成后回调
 */
+ (void)getTokenWithBusinessID:(NSString *)businessID completeHandler:(tokenBlock)block;

/**
 异步获取 businessID 对应的 Token，多线程安全
 
 @param block 获取token的block
 @param timeout 超时时间（范围：10s以内）
 @param unit 时间单位，可选秒、毫秒
 */
+ (void)getTokenWithBusinessID:(NSString *)businessID timeout:(int)timeout unit:(NTESCSTimeOutUnit)unit completeHandler:(tokenBlock)block;

/**
 同步获取 dToken，默认超时时间3s
 ⚠️ 建议不要使用多线程调用，如果需要多线程调用，请使用异步接口
 
 @return dToken 字符串
 */
+ (NSString *)getNdInfo;

/**
 同步获取 dToken，并指定超时时间和时间单位
 ⚠️ 建议不要使用多线程调用，如果需要多线程调用，请使用异步接口
 
 @param timeout 超时时间（范围：10s以内）
 @param unit 时间单位，可选秒、毫秒
 @return dToken 字符串
 */
+ (NSString *)getNdInfoWithTimeout:(int)timeout unit:(NTESCSTimeOutUnit)unit;

/**
 异步获取 dToken，并指定超时时间和时间单位，线程安全
 
 @param block 获取Token完成后回调
 */
+ (void)getNdInfoWithCompleteHandler:(NdInfoBlock)block;

/**
 异步获取 dToken，并指定超时时间和时间单位，线程安全
 
 @param timeout 超时时间（范围：10s以内）
 @param unit 时间单位，可选秒、毫秒
 @param block 获取Token完成后回调
 */
+ (void)getNdInfoWithTimeout:(int)timeout unit:(NTESCSTimeOutUnit)unit completeHandler:(NdInfoBlock)block;

/**
 清除SDK占用的缓存，建议在清除App缓存时，同时清除SDK缓存
 */
+ (void)cleanSDKCache;

/**
 获取当前SDK版本号
 */
+ (NSString *)getSDKVersion;

@end
