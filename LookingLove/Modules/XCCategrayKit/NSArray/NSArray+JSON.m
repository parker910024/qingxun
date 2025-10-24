//
//  NSArray+JSON.m
//  WanBan
//
//  Created by jiangfuyuan on 2020/9/25.
//  Copyright © 2020 WUJIE INTERACTIVE. All rights reserved.
//

#import "NSArray+JSON.h"

@implementation NSArray (JSON)

+ (NSString *)gs_jsonStringCompactFormatForNSArray:(NSArray *)arrJson {
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:arrJson options:NSJSONWritingPrettyPrinted error:nil];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    jsonString = [jsonString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    jsonString = [jsonString stringByReplacingOccurrencesOfString:@" " withString:@""];
    jsonString = [jsonString stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    return jsonString;
}

@end
