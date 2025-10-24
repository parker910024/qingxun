//
//  BaseObject.h
//  Bberry
//
//  Created by KevinWang on 2018/6/2.
//  Copyright © 2018年 XC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserID.h"
#import "YYUtility.h"
#import <YYModel/YYModel.h>
#import <ReactiveObjC/ReactiveObjC.h>
#import "XCConst.h"

@interface BaseObject : NSObject<YYModel>

/**
 *  依据数组初始化一个实例数组
 */
+ (NSArray *)modelsWithArray:(id)json;

/**
 *  依据字典初始化一个实例
 */
+ (instancetype)modelDictionary:(NSDictionary *)dictionary;

/**
 *  依据JSON对象初始化一个实例
 */
+ (instancetype)modelWithJSON:(id)json;

- (NSDictionary *)model2dictionary;

@end
