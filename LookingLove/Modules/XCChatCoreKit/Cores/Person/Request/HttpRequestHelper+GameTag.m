//
//  HttpRequestHelper+GameTag.m
//  XCChatCoreKit
//
//  Created by new on 2019/3/26.
//  Copyright © 2019 YiZhuan. All rights reserved.
//

#import "HttpRequestHelper+GameTag.h"
#import "NSMutableDictionary+Safe.h"

@implementation HttpRequestHelper (GameTag)

+ (void)personPageGameTagDeleteOrUserWithLiveId:(NSInteger )liveId WithStatus:(NSInteger )status
                                        success:(void (^)(BOOL success))success
                                        failure:(void (^)(NSNumber *resCode, NSString *message))failure{
    
    NSString *method = @"live/useOrDelete";
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params safeSetObject:@(liveId) forKey:@"liveId"];
    [params safeSetObject:@(status) forKey:@"status"];
    [HttpRequestHelper POST:method params:params success:^(id data) {
        if (success) {
            success(YES);
        }
    } failure:^(NSNumber *resCode, NSString *message) {
        if (failure) {
            failure(resCode, message);
        }
    }];
    
}
@end
