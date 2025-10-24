//
//  HostUrlManager.h
//  Bberry
//
//  Created by KevinWang on 2018/6/2.
//  Copyright © 2018年 XC. All rights reserved.
//


#import <Foundation/Foundation.h>
#import "XCMacros.h"

typedef NS_ENUM(NSInteger,EnvironmentType){
    //开发环境
    DevType = 1<<1,
    //测试环境
    TestType = 1<<2,
    //预发布环境
    Pre_ReleaseType= 1<<3,
    //正式环境
    ReleaseType = 1<<4
};

#define kAppNetWorkEnv @"kAppNetWorkEnv"

@class RACSignal;
@interface HostUrlManager : NSObject

/**
 vkiss h5
 */
@property (nonatomic, copy ,readonly)NSString * hostH5Url;


//h5 分享的hosturl
@property (nonatomic, copy) NSString *webHostName;

//环境
@property (nonatomic, assign)EnvironmentType Env;


/**
 实例化

 @return 实例对象
 */
+ (instancetype)shareInstance;

/// 获取当前程序环境
/// 因为 shareInstance 实例没有初始化 Env属性get方法，
/// 考虑可能的未知影响，这里单独实现一个获取方法
- (EnvironmentType)currentEnvironment;

/**
 获取可以域名

 @param hostList 域名列表
 @return 信号量
 */
- (RACSignal *)rac_getFasterHostName:(NSArray *)hostList;


/**
 存储远程获取的域名列表

 @param hostList 域名列表
 */
- (void)saveHostList:(NSArray *)hostList;


/**
 获取本地缓存的远程域名列表

 @return 域名列表
 */
- (NSArray *)getHostListFromDisk;


/**
 获取硬编码的域名列表

 @return 域名列表
 */
- (NSArray *)getHostListFromMemory;


/**
 获取ip地址

 @return ip
 */
- (RACSignal *)rac_getIpHost;

/**
 获取可用的网络请求的域名

 @return 域名
 */
- (NSString *)hostUrl;


/**
 更新本地可以用网络请求域名

 @param hostUrl 域名
 */
- (void)updatHostUrl:(NSString *)hostUrl;
@end
