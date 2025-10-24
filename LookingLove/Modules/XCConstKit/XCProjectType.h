//
//  XCProjectType.h
//  XCConstKit
//
//  Created by apple on 2019/8/6.
//  Copyright © 2019 KevinWang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XCMacros.h"
NS_ASSUME_NONNULL_BEGIN

@interface XCProjectType : NSObject

+ (instancetype)sharedProjectType; // 创建单例

// 当前是哪个项目
@property (nonatomic, assign) ProjectType projectType;

@end

NS_ASSUME_NONNULL_END
