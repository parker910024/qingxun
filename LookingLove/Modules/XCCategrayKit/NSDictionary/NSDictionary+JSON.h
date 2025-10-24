//
//  NSDictionary+ BVJSONString.h
//  YYMobileFramework
//
//  Created by xianmingchen on 15/11/2.
//  Copyright © 2015年 YY Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (JSON)
- (NSString *)toJSONWithPrettyPrint:(BOOL)prettyPrint;

@end
