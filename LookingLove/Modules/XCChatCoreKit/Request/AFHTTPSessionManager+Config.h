//
//  AFHTTPSessionManager+Config.h
//  Bberry
//
//  Created by KevinWang on 2018/6/2.
//  Copyright © 2018年 XC. All rights reserved.
//

#import "AFHTTPSessionManager.h"

@interface AFHTTPSessionManager (Config)
//参数
@property (nonatomic, strong) NSMutableDictionary * parmars;

//配置基本参数
+ (NSDictionary*)configBaseParmars:(NSDictionary*)parmars;
/** 公参 */
+ (NSDictionary *)basicParameters;

@end
