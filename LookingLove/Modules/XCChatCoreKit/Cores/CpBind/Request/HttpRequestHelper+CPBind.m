//
//  HttpRequestHelper+CPBind.m
//  UKiss
//
//  Created by apple on 2018/9/29.
//  Copyright © 2018年 yizhuan. All rights reserved.
//

#import "HttpRequestHelper+CPBind.h"
#import "AuthCore.h"
#import "CPOnline.h"
#import "XCRedPckageModel.h"


@implementation HttpRequestHelper (CPBind)
+ (void)requestCPBindWithUniqueCode:(NSString *)code
                    recomUniqueCode:(NSString *)recomUniqueCode
                            success:(void (^)(void))success
                            failure:(void (^)(NSNumber *resCode, NSString *message))failure{
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params safeSetObject:[GetCore(AuthCore) getUid] forKey:@"uid"];
    [params safeSetObject:code forKey:@"uniqueCode"];
    if (recomUniqueCode.length>0) {
        [params safeSetObject:recomUniqueCode forKey:@"recomUniqueCode"];
    }

    [HttpRequestHelper POST:@"coupleuser/bind" params:params success:^(id data) {
        success();
    } failure:^(NSNumber *resCode, NSString *message) {
        if (failure) {
            failure(resCode, message);
        }
    }];
}


+ (void)requestCPUnBindSuccess:(void (^)(void))success
                       failure:(void (^)(NSNumber *resCode, NSString *message))failure{
    NSDictionary * param = @{
                             @"uid": [GetCore(AuthCore) getUid]
                             };
    [HttpRequestHelper GET:@"coupleuser/unbind" params:param success:^(id data) {
        success();
    } failure:^(NSNumber *resCode, NSString *message) {
        if (failure) {
            failure(resCode, message);
        }
    }];
}

+ (void)requestCPOnlineWithUid:(NSString *)uid
                     coupleUid:(NSString *)coupleUid
                        roomId:(NSString *)roomId
                       Success:(void (^)(CPOnline *cpOnline))success
                       failure:(void (^)(NSNumber *resCode, NSString *message))failure {
    NSString *method = @"online/getStatus";
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params safeSetObject:uid forKey:@"uid"];
    [params safeSetObject:coupleUid forKey:@"coupleUid"];
    [params safeSetObject:roomId forKey:@"roomId"];
    
    [HttpRequestHelper POST:method params:params success:^(id data) {
        CPOnline *cpOnline = [CPOnline modelWithJSON:data];
        success(cpOnline);
    } failure:^(NSNumber *resCode, NSString *message) {
        if (failure) {
            failure(resCode, message);
        }
    }];
}

+ (void)requestCPOnlineFinishWithUid:(NSString *)uid
                           coupleUid:(NSString *)coupleUid
                              roomId:(NSString *)roomId
                             Success:(void (^)(XCRedPckageModel *onlineFinish))success
                             failure:(void (^)(NSNumber *resCode, NSString *message))failure {
    NSString *method = @"online/finish";
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params safeSetObject:uid forKey:@"uid"];
    [params safeSetObject:coupleUid forKey:@"coupleUid"];
    [params safeSetObject:roomId forKey:@"roomId"];
    
    [HttpRequestHelper POST:method params:params success:^(id data) {
        XCRedPckageModel *cpOnline = [XCRedPckageModel modelWithJSON:data];
        success(cpOnline);
    } failure:^(NSNumber *resCode, NSString *message) {
        if (failure) {
            failure(resCode, message);
        }
    }];
}

+ (void)requestCPOnlineAddAccompanyWithUid:(NSString *)uid
                                      type:(NSString *)type
                                   Success:(void (^)(int accompanyValue , int addValue))success
                                   failure:(void (^)(NSNumber *resCode, NSString *message))failure {
    NSString *method = @"online/addAccompany";
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params safeSetObject:uid forKey:@"uid"];
    [params safeSetObject:type forKey:@"type"];
    [HttpRequestHelper POST:method params:params success:^(id data) {
        int accompanyValue = [data[@"accompanyValue"] integerValue];
        int addValue = [data[@"addValue"] integerValue];
        success(accompanyValue,addValue);
    } failure:^(NSNumber *resCode, NSString *message) {
        if (failure) {
            failure(resCode, message);
        }
    }];
}

+ (void)requestCPOnlineGetInfoWithUid:(NSString *)uid
                              Success:(void (^)(NSString *lastLoginTime))success
                              failure:(void (^)(NSNumber *resCode, NSString *message))failure;{
    NSString *method = @"online/getInfo";
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params safeSetObject:uid forKey:@"uid"];
    
    [HttpRequestHelper POST:method params:params success:^(id data) {
        NSString *lastLoginTimeStr = data[@"lastLoginTime"];
        success(lastLoginTimeStr);
    } failure:^(NSNumber *resCode, NSString *message) {
        if (failure) {
            failure(resCode, message);
        }
    }];
}

+ (void)requestCPOnlineTextModeWithUid:(NSString *)uid
                               Success:(void (^)())success
                               failure:(void (^)(NSNumber *resCode, NSString *message))failure {
    NSString *method = @"online/textMode";
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params safeSetObject:uid forKey:@"uid"];
    [HttpRequestHelper POST:method params:params success:^(id data) {
        success();
    } failure:^(NSNumber *resCode, NSString *message) {
        if (failure) {
            failure(resCode, message);
        }
    }];
}

+ (void)requestCPLeaveRoomAndSyncTimeUid:(NSString *)uid
                                 coupleUid:(NSString *)coupleUid
                                  roomId:(NSInteger)roomId
                             leavediffer:(long)leavediffer
                                 Success:(void (^)())success
                                 failure:(void (^)(NSNumber *resCode, NSString *message))failure {
    NSString *method = @"room/leaveRoomAndSyncTime";
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params safeSetObject:uid forKey:@"uid"];
    [params safeSetObject:coupleUid forKey:@"coupleUid"];
    [params safeSetObject:@(roomId) forKey:@"roomId"];
    [params safeSetObject:@(leavediffer) forKey:@"leavediffer"];
    [HttpRequestHelper POST:method params:params success:^(id data) {
        success();
    } failure:^(NSNumber *resCode, NSString *message) {
        if (failure) {
            failure(resCode, message);
        }
    }];
}

+ (void)requestCPRoomSyncTimeUid:(NSString *)uid
                       coupleUid:(NSString *)coupleUid
                          roomId:(NSInteger)roomId
                         Success:(void (^)())success
                         failure:(void (^)(NSNumber *resCode, NSString *message))failure {
    NSString *method = @"online/syncTime";
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params safeSetObject:uid forKey:@"uid"];
    [params safeSetObject:coupleUid forKey:@"coupleUid"];
    [params safeSetObject:@(roomId) forKey:@"roomId"];
    [HttpRequestHelper POST:method params:params success:^(id data) {
        success();
    } failure:^(NSNumber *resCode, NSString *message) {
        if (failure) {
            failure(resCode, message);
        }
    }];
}

@end
