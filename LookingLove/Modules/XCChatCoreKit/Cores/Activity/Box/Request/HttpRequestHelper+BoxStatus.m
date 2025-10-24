//
//  HttpRequestHelper+BoxStatus.m
//  XCChatCoreKit
//
//  Created by JarvisZeng on 2019/5/13.
//  Copyright © 2019 YiZhuan. All rights reserved.
//

#import "HttpRequestHelper+BoxStatus.h"

@implementation HttpRequestHelper (BoxStatus)
/*
 获取钻石宝箱活动状态
 */
+ (void)requestDiamondBoxActivityStatus:(void (^)(BoxStatus *status))success
                                failure:(void (^)(NSNumber *resCode, NSString *message))failure {
    
    NSString *method = @"box/open/status";
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params safeSetObject:@(2) forKey:@"type"];
    [HttpRequestHelper GET:method params:params success:^(id data) {
        BoxStatus *info = [BoxStatus modelWithJSON:data];
        success(info);
    } failure:^(NSNumber *resCode, NSString *message) {
        failure(resCode, message);
    }];
}
@end
