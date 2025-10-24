//
//  NSArray+JSON.h
//  WanBan
//
//  Created by jiangfuyuan on 2020/9/25.
//  Copyright © 2020 WUJIE INTERACTIVE. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIkit/UIkit.h>
NS_ASSUME_NONNULL_BEGIN

@interface NSArray (JSON)

+ (NSString *)gs_jsonStringCompactFormatForNSArray:(NSArray *)arrJson;

@end

NS_ASSUME_NONNULL_END
