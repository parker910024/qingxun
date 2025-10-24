//
//  XCParamsDecode.m
//  BberryCore
//
//  Created by 卫明何 on 2018/5/4.
//  Copyright © 2018年 chenran. All rights reserved.
//

#import "XCParamsDecode.h"
#import "NSString+MessageDigest.h"
#import "AuthCore.h"
#import "PLTimeUtil.h"
#import "DESEncrypt.h"
#import "NSString+NTES.h"

@implementation XCParamsDecode
+ (NSMutableDictionary *)decodeParams:(NSString *)method params:(NSMutableDictionary *)params client:(AFHTTPSessionManager *)client formatter:(NSDateFormatter *)formatter {
    if (!params) {
        params = [NSMutableDictionary dictionary];
    }
    if ([GetCore(AuthCore)getUid].length > 0) {
        [client.requestSerializer setValue:[GetCore(AuthCore)getUid] forHTTPHeaderField:@"pub_uid"];
    }else {
        [client.requestSerializer setValue:nil forHTTPHeaderField:@"pub_uid"];
    }
    if ([GetCore(AuthCore)getTicket].length > 0) {
        [client.requestSerializer setValue:[GetCore(AuthCore)getTicket] forHTTPHeaderField:@"pub_ticket"];
    }else {
        [client.requestSerializer setValue:nil forHTTPHeaderField:@"pub_ticket"];
    }
    NSDate *datenow = [NSDate date];
    [params setObject:[NSString stringWithFormat:@"%lld", (long long)[datenow timeIntervalSince1970]*1000] forKey:@"pub_timestamp"];
    [params setObject:[self uuidString] forKey:@"uuid"];
    [params setObject:[XCParamsDecode xcSign:[params mutableCopy] method:method] forKey:@"pub_sign"];
    return params;
}


+ (NSString *)xcSign:(NSMutableDictionary *)dic method:(NSString *)method {
    [dic removeObjectForKey:@"ticket"];
    NSMutableString *stringA = [NSMutableString string];
    //按字典key升序排序
    NSArray *sortKeys = [[dic allKeys] sortedArrayUsingSelector:@selector(compare:)];
    //拼接格式 “key0=value0&key1=value1&key2=value2”
    for (NSString *key in sortKeys) {
        [stringA appendString:[NSString stringWithFormat:@"%@=%@&", key, dic[key]]];
    }
    //拼接参数加密签名 PARAMSSECRET
    [stringA appendString:[NSString stringWithFormat:@"key=%@", keyWithType(KeyType_ParamsEncode, NO)]];
    //MD5加密签名
    NSString *stringB = [stringA MD5String];
    //返回大写字母
    return stringB.uppercaseString;
}

+ (NSString *)uuidString
{
    CFUUIDRef uuid_ref = CFUUIDCreate(NULL);
    CFStringRef uuid_string_ref= CFUUIDCreateString(NULL, uuid_ref);
    NSString *uuid = [NSString stringWithString:(__bridge NSString *)uuid_string_ref];
    CFRelease(uuid_ref);
    CFRelease(uuid_string_ref);
    return [uuid lowercaseString];
}


@end
