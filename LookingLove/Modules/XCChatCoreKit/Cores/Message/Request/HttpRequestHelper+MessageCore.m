//
//  HttpRequestHelper+MessageCore.m
//  XCChatCoreKit
//
//  Created by lvjunhang on 2019/11/8.
//  Copyright © 2019 YiZhuan. All rights reserved.
//

#import "HttpRequestHelper+MessageCore.h"

#import "AuthCore.h"

@implementation HttpRequestHelper (MessageCore)

/**
 获取互动消息列表
 */
+ (void)requestMessageDynamicListWithId:(NSString *)dynamicId pageSize:(NSInteger)pageSize completion:(HttpRequestHelperCompletion)completion {
    
    NSString *path = @"interactive/list";
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:GetCore(AuthCore).getUid forKey:@"uid"];
    [params setValue:dynamicId forKey:@"id"];
    [params setValue:@(MAX(pageSize, 10)) forKey:@"pageSize"];

    [self request:path
           method:HttpRequestHelperMethodPOST
           params:params
       completion:completion];
}

@end
