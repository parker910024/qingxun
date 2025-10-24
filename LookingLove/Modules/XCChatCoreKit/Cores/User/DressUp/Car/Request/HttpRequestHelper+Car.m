//
//  HttpRequestHelper+Car.m
//  BberryCore
//
//  Created by 卫明何 on 2018/3/1.
//  Copyright © 2018年 chenran. All rights reserved.
//

#import "HttpRequestHelper+Car.h"
#import "AuthCore.h"
#import "UserCar.h"
#import "WBUserNameplate.h"

@implementation HttpRequestHelper (Car)


+ (void)getUserCarList:(NSString *)uid
               success:(void (^)(NSArray *))success
               failure:(void (^)(NSNumber *, NSString *))failure {
    NSString *method = @"car/carport/list";
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params safeSetObject:uid forKey:@"uid"];
    [params safeSetObject:[GetCore(AuthCore) getTicket] forKey:@"ticket"];
    
    // 2019-03-26 公会线添加。
    if (projectType() == ProjectType_Pudding ||
        projectType() == ProjectType_LookingLove ||
        projectType() == ProjectType_Planet) {
        method = @"car/carport/v2/list";
        [HttpRequestHelper GET:method params:params success:^(id data) {
            NSArray *carList = [UserCar modelsWithArray:data];
            if (success) {
                success(carList);
            }
        } failure:^(NSNumber *resCode, NSString *message) {
            if (failure) {
                failure(resCode, message);
            }
        }];
        return;
    }
    
    [HttpRequestHelper POST:method params:params success:^(id data) {

        NSArray *carList = [UserCar modelsWithArray:data];
        if (success) {
            success(carList);
        }
    } failure:^(NSNumber *resCode, NSString *message) {
        if (failure) {
            failure(resCode, message);
        }
    }];
    
}

+ (void)getCarDetailWithCarid:(NSString *)carId Success:(void (^)(UserCar *))success failure:(void (^)(NSNumber *, NSString *))failure {
    
    NSMutableString *method = [[NSMutableString alloc]initWithString:@"car/car/goods/"];
    [method appendString:carId];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    [HttpRequestHelper GET:method params:params success:^(id data) {
        
        UserCar *car = [UserCar modelWithJSON:data];
        if (success) {
            success(car);
        }
    } failure:^(NSNumber *resCode, NSString *message) {
        if (failure) {
            failure(resCode, message);
        }
    }];
    
}


+ (void)getCarListWithPageSize:(NSString *)pageSize page:(NSString *)page Success:(void (^)(NSArray *))success failure:(void (^)(NSNumber *, NSString *))failure {
    
    NSString *method = @"car/goods";
    if (projectType() == ProjectType_Pudding ||
        projectType() == ProjectType_LookingLove ||
        projectType() == ProjectType_Planet) {
        method = @"car/goods/v2/list";
    }
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    if (projectType() == ProjectType_BB) {
        method = @"car/goods/fixed";
        [params setObject:@(7) forKey:@"channelType"];
    }
    [params setObject:[GetCore(AuthCore) getUid] forKey:@"uid"];
    [params setObject:pageSize forKey:@"pageSize"];
    [params setObject:page forKey:@"page"];
    [params setObject:@"2" forKey:@"status"];
    [HttpRequestHelper GET:method params:params success:^(id data) {

        NSArray *carList = [UserCar modelsWithArray:data];
        if (success) {
            success(carList);
        }
    } failure:^(NSNumber *resCode, NSString *message) {
        if (failure) {
            failure(resCode, message);
        }
    }];
    
}

+ (void)userCarByCarId:(NSString *)carId Success:(void (^)(BOOL))success failure:(void (^)(NSNumber *, NSString *))failure {
    
    NSString *method = @"car/carport/use";
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:[GetCore(AuthCore) getUid] forKey:@"uid"];
    [params setObject:[GetCore(AuthCore) getTicket] forKey:@"ticket"];
    [params setObject:carId forKey:@"carId"];
    
    
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


+ (void)buyOrRenewCarByCarId:(NSString *)carId Success:(void (^)(BOOL))success failure:(void (^)(NSNumber *, NSString *))failure {
    
    NSString *method = @"car/pay/byGold";
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:[GetCore(AuthCore) getUid] forKey:@"uid"];
    [params setObject:[GetCore(AuthCore) getTicket] forKey:@"ticket"];
    [params setObject:carId forKey:@"carId"];
    
    
    [HttpRequestHelper POST:method params:params success:^(id data) {
        
        if (data) {
            success(YES);
        }
    } failure:^(NSNumber *resCode, NSString *message) {
        if (failure) {
            failure(resCode, message);
        }
    }];
    
}

/**
 赠送座驾
 
 @param carId 座驾ID
 @param targetUid 被赠送者Id
 @param success 成功
 @param failure 失败
 */
+ (void)presneteCarByCarId:(NSString *)carId targetUid:(UserID)targetUid Success:(void (^)(BOOL))success failure:(void (^)(NSNumber *, NSString *))failure {
    NSString *method = @"car/pay/giveByGold";
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:[GetCore(AuthCore) getUid] forKey:@"uid"];
    [params setObject:[GetCore(AuthCore) getTicket] forKey:@"ticket"];
    [params setObject:carId forKey:@"carId"];
    [params setObject:@(targetUid) forKey:@"targetUid"];
    [HttpRequestHelper POST:method params:params success:^(id data) {
        
        if (data) {
            success(YES);
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
+ (void)buyCarWithCarID:(NSString *)carID
           currencyType:(BuyGoodsType)currencyType
                Success:(void (^)(BOOL))success
                failure:(void (^)(NSNumber *, NSString *))failure {
    
    NSString *method = @"car/pay/v2/buy";
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:[GetCore(AuthCore) getUid] forKey:@"uid"];
    [params setObject:carID forKey:@"carId"];
    [params setObject:@(currencyType) forKey:@"currencyType"];
    
    [HttpRequestHelper POST:method params:params success:^(id data) {
        
        if (data) {
            success(YES);
        }
    } failure:^(NSNumber *resCode, NSString *message) {
        if (failure) {
            failure(resCode, message);
        }
    }];
}

// 赠送
+ (void)presneteCarByCarId:(NSString *)carId targetUid:(UserID)targetUid currencyType:(BuyGoodsType)currencyType Success:(void (^)(BOOL))success failure:(void (^)(NSNumber *, NSString *))failure {
    NSString *method = @"car/pay/v2/giveCar";
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:[GetCore(AuthCore) getUid] forKey:@"uid"];
    [params setObject:carId forKey:@"carId"];
    [params setObject:@(targetUid) forKey:@"targetUid"];
    [params setObject:@(currencyType) forKey:@"currencyType"];
    
    [HttpRequestHelper POST:method params:params success:^(id data) {
        
        if (data) {
            success(YES);
        }
    } failure:^(NSNumber *resCode, NSString *message) {
        if (failure) {
            failure(resCode, message);
        }
    }];
}

+ (void)getNameplateListWithPageSize:(NSString *)pageSize page:(NSString *)page Success:(void (^)(NSArray *))success failure:(void (^)(NSNumber *, NSString *))failure {
    
    NSString *method = @"nameplate/getList";
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    [params setObject:[GetCore(AuthCore) getUid] forKey:@"uid"];
    [params setObject:pageSize forKey:@"pageSize"];
    [params setObject:page forKey:@"page"];

    [HttpRequestHelper POST:method params:params success:^(id data) {

        NSArray *nameplateList = [WBUserNameplate modelsWithArray:data[@"nameplates"]];
        if (success) {
            success(nameplateList);
        }
    } failure:^(NSNumber *resCode, NSString *message) {
        if (failure) {
            failure(resCode, message);
        }
    }];
    
}


/**
制作铭牌

@param fixedWord 文案
@param namePlateId 铭牌库id
*/
+ (void)getMakeNamePlate:(NSString *)namePlateId fixedWord:(NSString *)fixedWord
                 success:(void (^)(bool))success
               failure:(void (^)(NSNumber *, NSString *))failure {
    NSString *method = @"nameplate/make";
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:[GetCore(AuthCore) getUid] forKey:@"uid"];
    [params safeSetObject:[GetCore(AuthCore) getTicket] forKey:@"ticket"];
    [params safeSetObject:fixedWord forKey:@"fixedWord"];
    [params safeSetObject:namePlateId forKey:@"id"];
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
使用摘下铭牌

@param used 操作(0 -- 摘下, 1 -- 使用)
@param namePlateId 铭牌库id
*/
+ (void)getUseNamePlate:(NSString *)namePlateId used:(NSInteger)used
                 success:(void (^)(bool))success
               failure:(void (^)(NSNumber *, NSString *))failure {
    NSString *method = @"nameplate/use";
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:[GetCore(AuthCore) getUid] forKey:@"uid"];
    [params safeSetObject:[GetCore(AuthCore) getTicket] forKey:@"ticket"];
    [params safeSetObject:@(used) forKey:@"used"];
    [params safeSetObject:namePlateId forKey:@"id"];
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
