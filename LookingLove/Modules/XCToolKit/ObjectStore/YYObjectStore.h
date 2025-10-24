//
//  YYObjectStore.h
//  YYMobileCore
//
//  Created by wuwei on 14/6/11.
//  Copyright (c) 2014年 YY.inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IObjectStore.h"

@interface YYObjectStore : NSObject <IObjectStore>

+ (instancetype)objectStoreWithNamespace:(NSString *)ns;

- (instancetype)initWithNamespace:(NSString *)ns;
- (instancetype)initWithNamespace:(NSString *)ns inDirectory:(NSString *)directory;

- (BOOL)removeAllStores;

@end
