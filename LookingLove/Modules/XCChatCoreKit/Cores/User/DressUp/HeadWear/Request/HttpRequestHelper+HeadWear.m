//
//  HttpRequestHelper+HeadWear.m
//  BberryCore
//
//  Created by Macx on 2018/5/10.
//  Copyright © 2018年 chenran. All rights reserved.
//

#import "HttpRequestHelper+HeadWear.h"
#import "AuthCore.h"
#import "UserHeadWear.h"


@implementation HttpRequestHelper (HeadWear)


/**
 获取头饰商城列表
 
 @param success 成功
 @param failure 失败
 */
+ (void)getHeadwearListWithPageSize:(NSString *)pageSize page:(NSString *)page uid:(UserID)uid Success:(void (^)(NSArray *))success failure:(void (^)(NSNumber *, NSString *))failure {
    
    NSString *method = @"v1/headwear";
    if (projectType() == ProjectType_Pudding ||
        projectType() == ProjectType_LookingLove ||
        projectType() == ProjectType_Planet) {
        method = @"headwear/v2/list";
    }
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    if (projectType() == ProjectType_BB) {
        method = @"v1/headwear/fixed";
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

        NSArray *hearwearList = [UserHeadWear modelsWithArray:data];
        if (success) {
            success(hearwearList);
        }
    } failure:^(NSNumber *resCode, NSString *message) {
        if (failure) {
            failure(resCode, message);
        }
    }];
}



/**
 使用头饰
 
 @param headwearId 头饰ID
 @param success 成功
 @param failure 失败
 */
+ (void)userHeadwearByHeadwearId:(NSString *)headwearId Success:(void (^)(BOOL))success failure:(void (^)(NSNumber *, NSString *))failure {
    
    NSString *method = @"v1/user/headwear/use";
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:[GetCore(AuthCore) getUid] forKey:@"uid"];
    [params setObject:[GetCore(AuthCore) getTicket] forKey:@"ticket"];
    [params setObject:headwearId forKey:@"headwearId"];
    
    
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
 购买头饰
 
 @param headwearId 头饰ID
 @param type 1.购买 2.续费
 @param success 成功
 @param failure 失败
 */
+ (void)buyOrRenewHeadwearByHeadwearId:(NSString *)headwearId type:(NSInteger)type Success:(void (^)(BOOL))success failure:(void (^)(NSNumber *, NSString *))failure {
    NSString *method = @"v1/headwear/buy";
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:[GetCore(AuthCore) getUid] forKey:@"uid"];
    [params setObject:[GetCore(AuthCore) getTicket] forKey:@"ticket"];
//    [params setObject:@(type) forKey:@"type"];
    [params setObject:headwearId forKey:@"headwearId"];
    
    [HttpRequestHelper POST:method params:params success:^(id data) {
        success(YES);
    } failure:^(NSNumber *resCode, NSString *message) {
        if (failure) {
            failure(resCode, message);
        }
    }];
}


/**
 获取头饰详情
 
 @param headwearId 头饰ID
 @param success 成功
 @param failure 失败
 */
+ (void)getHeadwearDetailWithHeadwearId:(NSString *)headwearId Success:(void (^)(UserHeadWear *))success failure:(void (^)(NSNumber *, NSString *))failure {
    NSString *method = @"v1/headwear/";
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:[GetCore(AuthCore) getUid] forKey:@"uid"];
    [params setObject:headwearId forKey:@"headwearId"];
    
    [HttpRequestHelper GET:method params:params success:^(id data) {
//        UserHeadWear *headwear = [UserHeadWear yy_modelWithJSON:data];
        UserHeadWear *headwear = [UserHeadWear modelWithJSON:data];
        if (success) {
            success(headwear);
        }
    } failure:^(NSNumber *resCode, NSString *message) {
        if (failure) {
            failure(resCode, message);
        }
    }];
}

/**
 获取用户的头饰列表
 @param uid     用户id
 @param success 成功
 @param failure 失败
 */
+ (void)getUserHeadwearList:(NSString *)uid
                    success:(void (^)(NSArray *))success
                    failure:(void (^)(NSNumber *, NSString *))failure {
    NSString *method = @"v1/user/headwear";
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params safeSetObject:uid forKey:@"uid"];
    [params safeSetObject:[GetCore(AuthCore) getTicket] forKey:@"ticket"];
    
    // 2019-03-26 公会线修改。时间允许的情况下写一份新接口调用
    if (projectType() == ProjectType_Pudding ||
        projectType() == ProjectType_LookingLove ||
        projectType() == ProjectType_Planet) {
        method = @"headwear/v2/user/list";
        
        [HttpRequestHelper GET:method params:params success:^(id data) {
            NSArray *headwearList = [UserHeadWear modelsWithArray:data];
            if (success) {
                success(headwearList);
            }
        } failure:^(NSNumber *resCode, NSString *message) {
            if (failure) {
                failure(resCode, message);
            }
        }];
        return;
    }
    
    [HttpRequestHelper POST:method params:params success:^(id data) {
//        NSArray *headwearList = [NSArray yy_modelArrayWithClass:[UserHeadWear class] json:data];
        NSArray *headwearList = [UserHeadWear modelsWithArray:data];
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
 赠送头饰
 @param uid     赠送的用户id
 @param targetUid     被赠送的用户id
 @param headwearId     头饰id
 @param success 成功
 @param failure 失败
 */
+ (void)presentHeadwearFromUid:(NSString *)uid
                   toTargetUid:(UserID)targetUid
                withHeadwearId:(NSString *)headwearId
                       success:(void (^)(BOOL))success
                       failure:(void (^)(NSNumber *, NSString *))failure {
    NSString *method = @"v1/headwear/donate";
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:uid forKey:@"uid"];
    [params setObject:@(targetUid) forKey:@"targetUid"];
    [params setObject:[GetCore(AuthCore) getTicket] forKey:@"ticket"];
    [params setObject:headwearId forKey:@"headwearId"];
    
    [HttpRequestHelper POST:method params:params success:^(id data) {
            success(YES);
    } failure:^(NSNumber *resCode, NSString *message) {
        if (failure) {
            failure(resCode, message);
        }
    }];
}
/**
 获取我的头饰账单
 
 @param success 成功
 @param failure 失败
 */
+ (void)getHeadwearBillListWithPageSize:(NSString *)pageSize page:(NSString *)page Success:(void (^)(NSArray *))success failure:(void (^)(NSNumber *, NSString *))failure {
    NSString *method = @"v1/headwear/bill";
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:[GetCore(AuthCore) getUid] forKey:@"uid"];
    [params setObject:pageSize forKey:@"pageSize"];
    [params setObject:page forKey:@"page"];
    [HttpRequestHelper GET:method params:params success:^(id data) {
//        NSArray *hearwearList = [NSArray yy_modelArrayWithClass:[UserHeadWear class] json:data];
        NSArray *hearwearList = [UserHeadWear modelsWithArray:data];
        if (success) {
            success(hearwearList);
        }
    } failure:^(NSNumber *resCode, NSString *message) {
        if (failure) {
            failure(resCode, message);
        }
    }];
}

#pragma mark -
#pragma mark v2 版本
// ***********  2019-03-25 公会线添加  v2 版本接口(赠送，购买) *************/
// 购买
+ (void)buyHeadwearWithHeadwearID:(NSString *)headwearID
                     currencyType:(BuyGoodsType)currencyType
                          Success:(void (^)(BOOL))success
                          failure:(void (^)(NSNumber *, NSString *))failure {
    NSString *method = @"headwear/v2/buy";
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:[GetCore(AuthCore) getUid] forKey:@"uid"];
    [params setObject:@(currencyType) forKey:@"currencyType"];
    [params setObject:headwearID forKey:@"headwearId"];
    
    [HttpRequestHelper POST:method params:params success:^(id data) {
        success(YES);
    } failure:^(NSNumber *resCode, NSString *message) {
        if (failure) {
            failure(resCode, message);
        }
    }];
}

// 赠送
+ (void)presentHeadwearWithHeadwearId:(NSString *)headwearId toTargetUid:(UserID)targetUid currencyType:(BuyGoodsType)currencyType success:(void (^)(BOOL))success failure:(void (^)(NSNumber *, NSString *))failure {
    NSString *method = @"headwear/v2/headwear/donate";
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:[GetCore(AuthCore) getUid] forKey:@"uid"];
    [params setObject:@(targetUid) forKey:@"targetUid"];
    [params setObject:@(currencyType) forKey:@"currencyType"];
    [params setObject:headwearId forKey:@"headwearId"];
    
    [HttpRequestHelper POST:method params:params success:^(id data) {
        success(YES);
    } failure:^(NSNumber *resCode, NSString *message) {
        if (failure) {
            failure(resCode, message);
        }
    }];
}

@end
