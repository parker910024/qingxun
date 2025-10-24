//
//  HttpRequestHelper+Noble.m
//  BberryCore
//
//  Created by Mac on 2018/1/18.
//  Copyright © 2018年 chenran. All rights reserved.
//

#import "HttpRequestHelper+Noble.h"
#import "OnLineNobleInfo.h"
#import "AuthCore.h"
#import "GTMBase64.h"

@implementation HttpRequestHelper (Noble)

/*
 查询房间贵族列表
 roomUid:房主uid
 */
+ (void)requestRoomNobleUserList:(NSString *)roomUid
                         success:(void (^)(NSArray *list))success
                         failure:(void (^)(NSNumber *resCode, NSString *message))failure{
    NSString *method = @"noble/room/user/get";
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params safeSetObject:roomUid forKey:@"roomUid"];
    [params safeSetObject:GetCore(AuthCore).getUid forKey:@"uid"];
    [params safeSetObject:GetCore(AuthCore).getTicket forKey:@"ticket"];
    [HttpRequestHelper GET:method params:params success:^(id data) {

        NSArray *nobleLists = [OnLineNobleInfo modelsWithArray:data];

        if (success) {
            success(nobleLists);
        }
    } failure:^(NSNumber *resCode, NSString *message) {
        if (failure) {
            failure(resCode, message);
        }
    }];
}


+ (void)requestNobleOrderByNobleId:(NSNumber *)nobleId
                      nobleOptType:(OrderNobleType)nobleOptType
                           success:(void (^)(NSString *))success
                           failure:(void (^)(NSNumber *, NSString *))failure{
    
    NSString *method = @"order/noble";
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params safeSetObject:GetCore(AuthCore).getUid forKey:@"uid"];
    [params safeSetObject:GetCore(AuthCore).getTicket forKey:@"ticket"];
    [params safeSetObject:nobleId forKey:@"nobleId"];
    [params safeSetObject:@(nobleOptType) forKey:@"nobleOptType"];
    
    [HttpRequestHelper POST:method params:params success:^(id data) {
        success(data[@"recordId"]);
    } failure:^(NSNumber *resCode, NSString *message) {
        if (failure) {
            failure(resCode, message);
        }
    }];
}

+ (void)checkReceiptWithReceipt:(NSData *)receipt
                  nobleRecordId:(NSString *)nobleRecordId
                  transcationId:(NSString *)transcationId
                        success:(void (^)(NSString *))success
                        failure:(void (^)(NSNumber *, NSString *))failure{
    NSString *receiptBase64 = [[NSString alloc] initWithData:[GTMBase64 encodeData:receipt] encoding:NSUTF8StringEncoding];
    
    NSString *method = @"verify/iapNoble";
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params safeSetObject:GetCore(AuthCore).getUid forKey:@"uid"];
    [params safeSetObject:GetCore(AuthCore).getTicket forKey:@"ticket"];
    
    [params safeSetObject:receiptBase64 forKey:@"receipt"];
    [params safeSetObject:nobleRecordId forKey:@"nobleRecordId"];
    [params safeSetObject:transcationId forKey:@"transcationId"];
    [params setObject:@"true" forKey:@"chooseEnv"];
    
    [HttpRequestHelper POST:method params:params success:^(id data) {
        success(data);
    } failure:^(NSNumber *resCode, NSString *message) {
        if (failure) {
            failure(resCode, message);
        }
    }];
}

@end
