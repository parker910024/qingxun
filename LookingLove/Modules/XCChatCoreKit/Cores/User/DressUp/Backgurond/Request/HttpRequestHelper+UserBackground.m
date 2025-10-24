//
//  HttpRequestHelper+UserBackground.m
//  BberryCore
//
//  Created by Macx on 2018/6/20.
//  Copyright © 2018年 chenran. All rights reserved.
//

#import "HttpRequestHelper+UserBackground.h"
#import "AuthCore.h"

@implementation HttpRequestHelper (UserBackground)

/**
 获取背景商城列表
 
 @param success 成功
 @param failure 失败
 */
+ (void)getBackgroundListWithPageSize:(NSString *)pageSize page:(NSString *)page uid:(UserID)uid Success:(void (^)(NSArray *))success failure:(void (^)(NSNumber *, NSString *))failure {

    NSString *method = @"background/list";
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    if (projectType() == ProjectType_BB) {
        method = @"background/fixed";
        [params setObject:@(7) forKey:@"channelType"];
    }
    if (uid == 0) {
        [params setObject:[GetCore(AuthCore) getUid] forKey:@"uid"];
        
    }else {
        [params setObject:@(uid) forKey:@"uid"];
    }
    [params setObject:pageSize forKey:@"pageSize"];
    [params setObject:page forKey:@"page"];
    [params setObject:@"2" forKey:@"status"];
    [HttpRequestHelper GET:method params:params success:^(id data) {
        
        NSArray *backgroundList = [UserBackground modelsWithArray:data];
        if (success) {
            success(backgroundList);
        }
    } failure:^(NSNumber *resCode, NSString *message) {
        if (failure) {
            failure(resCode, message);
        }
    }];
    
}


/**
 使用背景
 
 @param backgroundId 背景ID
 @param success 成功
 @param failure 失败
 */
+ (void)useBackgroundByBackgroundId:(NSString *)backgroundId roomUid:(NSString *)roomUid Success:(void (^)(BOOL))success failure:(void (^)(NSNumber *, NSString *))failure {
    NSString *method = @"background/doUse";
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:roomUid forKey:@"roomUid"];
    [params setObject:[GetCore(AuthCore) getUid] forKey:@"uid"];
    [params setObject:[GetCore(AuthCore) getTicket] forKey:@"ticket"];
    [params setObject:backgroundId forKey:@"backgroundId"];
    
    
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


/**
 取消使用背景
 
 @param success 成功
 @param failure 失败
 */
+ (void)cancelBackgroundByRoomUid:(NSString *)roomUid Success:(void (^)(BOOL))success failure:(void (^)(NSNumber *, NSString *))failure {
    NSString *method = @"background/cancel";
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:roomUid forKey:@"roomUid"];
    [params setObject:[GetCore(AuthCore) getTicket] forKey:@"ticket"];
    [params setObject:[GetCore(AuthCore) getUid] forKey:@"uid"];

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



/**
 购买背景
 
 @param backgroundId 背景ID
 @param success 成功
 @param failure 失败
 */
+ (void)buyOrRenewBackgroundByBackgroundId:(NSString *)backgroundId Success:(void (^)(BOOL))success failure:(void (^)(NSNumber *, NSString *))failure {
    NSString *method = @"background/buy";
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:[GetCore(AuthCore) getUid] forKey:@"uid"];
    [params setObject:[GetCore(AuthCore) getTicket] forKey:@"ticket"];
    [params setObject:backgroundId forKey:@"backgroundId"];
    
    [HttpRequestHelper POST:method params:params success:^(id data) {
        success(YES);
    } failure:^(NSNumber *resCode, NSString *message) {
        if (failure) {
            failure(resCode, message);
        }
    }];
}


/**
 获取背景详情
 
 @param backgroundId 头饰ID
 @param success 成功
 @param failure 失败
 */
+ (void)getBackgroundDetailWithBackgroundId:(NSString *)backgroundId Success:(void (^)(UserBackground *))success failure:(void (^)(NSNumber *, NSString *))failure {
    
}

/**
 获取用户的背景列表
 @param uid     用户id
 @param success 成功
 @param failure 失败
 */
+ (void)getBackgroundList:(NSString *)uid
                  success:(void (^)(NSArray *))success
                  failure:(void (^)(NSNumber *, NSString *))failure {
    NSString *method = @"background/listByUser";
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params safeSetObject:uid forKey:@"uid"];
    [params safeSetObject:[GetCore(AuthCore) getTicket] forKey:@"ticket"];
    
    
    [HttpRequestHelper GET:method params:params success:^(id data) {
        //        NSArray *headwearList = [NSArray yy_modelArrayWithClass:[UserHeadWear class] json:data];
        NSArray *backgroundList = [UserBackground modelsWithArray:data];
        if (success) {
            success(backgroundList);
        }
    } failure:^(NSNumber *resCode, NSString *message) {
        if (failure) {
            failure(resCode, message);
        }
    }];
}


/**
 获取用户可用背景列表
 @param uid     用户id
 @param success 成功
 @param failure 失败
 */
+ (void)getUserAvailableBackgroundList:(NSString *)uid
                  success:(void (^)(NSArray *))success
                  failure:(void (^)(NSNumber *, NSString *))failure {
    NSString *method = @"background/listByAvailable";
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    if (!uid || !uid.length) {
        [params safeSetObject:GetCore(AuthCore).getUid forKey:@"uid"];
    }else {
        [params safeSetObject:uid forKey:@"uid"];
    }
    [params safeSetObject:[GetCore(AuthCore) getTicket] forKey:@"ticket"];
    
    [HttpRequestHelper GET:method params:params success:^(id data) {
        //        NSArray *headwearList = [NSArray yy_modelArrayWithClass:[UserHeadWear class] json:data];
        NSArray *headwearList = [UserBackground modelsWithArray:data];
        if (success) {
            success(headwearList);
        }
    } failure:^(NSNumber *resCode, NSString *message) {
        if (failure) {
            failure(resCode, message);
        }
    }];
}




/**
 赠送背景
 @param uid     赠送的用户id
 @param targetUid     被赠送的用户id
 @param backgroundId     背景id
 @param success 成功
 @param failure 失败
 */
+ (void)presentBackgroundFromUid:(NSString *)uid
                     toTargetUid:(UserID)targetUid
                withBackgroundId:(NSString *)backgroundId
                         success:(void (^)(BOOL))success
                         failure:(void (^)(NSNumber *, NSString *))failure {
    NSString *method = @"background/donate";
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:uid forKey:@"uid"];
    [params setObject:@(targetUid) forKey:@"targetUid"];
    [params setObject:[GetCore(AuthCore) getTicket] forKey:@"ticket"];
    [params setObject:backgroundId forKey:@"backgroundId"];
    
    [HttpRequestHelper POST:method params:params success:^(id data) {
        success(YES);
    } failure:^(NSNumber *resCode, NSString *message) {
        if (failure) {
            failure(resCode, message);
        }
    }];
}


@end
