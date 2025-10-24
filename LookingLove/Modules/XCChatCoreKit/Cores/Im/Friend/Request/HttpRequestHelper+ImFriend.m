//
//  HttpRequestHelper+ImFriend.m
//  XCChatCoreKit
//
//  Created by lvjunhang on 2019/12/24.
//  Copyright © 2019 YiZhuan. All rights reserved.
//

#import "HttpRequestHelper+ImFriend.h"
#import "AuthCore.h"

@implementation HttpRequestHelper (ImFriend)

+ (void)requestSecretarySystemUIDsWithCompletion:(HttpRequestHelperCompletion)completion
{
    NSString *path = @"client/prop";
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:GetCore(AuthCore).getUid forKey:@"uid"];
    
    [self request:path
           method:HttpRequestHelperMethodPOST
           params:params
       completion:completion];
}

@end
