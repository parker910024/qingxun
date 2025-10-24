//
//  NobleSourceInfo.h
//  BberryCore
//
//  Created by 卫明何 on 2018/1/10.
//  Copyright © 2018年 chenran. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum : NSUInteger {
    NobleSourceTypeID = 1, //ids 本地资源
    NobleSourceTypeURL = 2, //url 网络资源
    NobleSourceTypeColor = 3, //colors 颜色
} NobleSourceType;

@interface NobleSourceInfo : NSObject

/**
 资源类型
 */
@property (nonatomic, assign) NobleSourceType sourceType;

/**
 值
 */
@property (nonatomic, strong) NSMutableArray *values;


/**
 单独值，作为查询用
 */
@property (nonatomic, strong) id source;

@end
