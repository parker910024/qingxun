//
//  NSDictionary+ BVJSONString.m
//  YYMobileFramework
//
//  Created by xianmingchen on 15/11/2.
//  Copyright © 2015年 YY Inc. All rights reserved.
//

#import "NSDictionary+JSON.h"

@implementation NSDictionary (JSON)
- (NSString*) toJSONWithPrettyPrint:(BOOL)prettyPrint{
    
    
    if ([NSJSONSerialization isValidJSONObject:self]) {
        
        NSError *error =nil;
        
        
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:self options:(NSJSONWritingOptions)    (prettyPrint ? NSJSONWritingPrettyPrinted : 0)  error:&error];
        
        if (!jsonData) {
            NSLog(@"toJSONWithPrettyPrint: error: %@", error.localizedDescription);
            return @"{}";
        } else {
            return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        }
        
    }else{
        return @"{}";
    }
    
}
@end
