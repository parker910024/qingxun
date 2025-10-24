//
//  HeadWearCore.m
//  BberryCore
//
//  Created by Macx on 2018/5/10.
//  Copyright © 2018年 chenran. All rights reserved.
//

#import "HeadWearCore.h"
#import "HttpRequestHelper+HeadWear.h"
#import "UserCoreClient.h"
#import "AuthCore.h"
#import "UserCore.h"
#import "XCDBManager.h"
#import "UserCache.h"

@implementation HeadWearCore

/**
  我的头饰列表
 **/
- (void)requestHeadwearListByPage:(NSString *)page pageSize:(NSString *)pageSize state:(int)state uid:(UserID)uid {
    [HttpRequestHelper getHeadwearListWithPageSize:pageSize page:page uid:uid Success:^(NSArray *data) {
        NotifyCoreClient(UserCoreClient, @selector(onGetHeadWearListSuccess:state:), onGetHeadWearListSuccess:data state:state);

    } failure:^(NSNumber *resCode, NSString *message) {
        NotifyCoreClient(UserCoreClient, @selector(onGetHeadwearListFailth:), onGetHeadwearListFailth:message);
    }];
}




/**
 请求头饰账单
 @param page 页码
 @param pageSize 每页数量
 */
- (void)requestHeadwearBillByPage:(NSString *)page pageSize:(NSString *)pageSize state:(int)state {
    [HttpRequestHelper getHeadwearBillListWithPageSize:pageSize page:page Success:^(NSArray *list) {
        
    } failure:^(NSNumber *reCode, NSString *message) {
        
    }];
}



/**
 请求头饰列表
 */
- (void)requestUserHeadwear:(UserHeadwearPlaceType)placeType uid:(NSString *)uid {
    [HttpRequestHelper getUserHeadwearList:uid success:^(NSArray *list) {
        NotifyCoreClient(UserCoreClient, @selector(onGetOwnHeadwearList:success:), onGetOwnHeadwearList:placeType success:list);
    } failure:^(NSNumber *reCode, NSString *message) {
        NotifyCoreClient(UserCoreClient, @selector(onGetOwnHeadwearList:failth:), onGetOwnHeadwearList:placeType failth:message);
    }];
}

/**
 购买头饰
 
 @param headwearId 头饰Id
 @return complete就是成功 error就是失败
 */
- (RACSignal *)buyHeadwearByHeadwearId:(NSString *)headwearId type:(NSInteger)type{
    @weakify(self);
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [HttpRequestHelper buyOrRenewHeadwearByHeadwearId:headwearId type:type Success:^(BOOL success) {
            @strongify(self);
            self.hasNewCarOrder = YES;
            [subscriber sendCompleted];
        } failure:^(NSNumber *resCode, NSString *message) {
            NSError *error = [[NSError alloc]initWithDomain:message code:[resCode integerValue] userInfo:nil];
            [subscriber sendError:error];

        }];
        return nil;
    }];
}


/**
 赠送头饰
 
 @param headwearId 头饰Id
 @param targetUid  被赠送Id
  @return complete就是成功 error就是失败
 */
- (RACSignal *)presentHeadwearByHeadwearId:(NSString *)headwearId toTargetUid:(UserID)targetUid {
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        
       NSString *uid = GetCore(AuthCore).getUid;
        
        [HttpRequestHelper presentHeadwearFromUid:uid toTargetUid:targetUid withHeadwearId:headwearId success:^(BOOL success) {
            [subscriber sendCompleted];
        } failure:^(NSNumber *resCode, NSString *message) {
            NSError *error = [[NSError alloc]initWithDomain:message code:[resCode integerValue] userInfo:nil];
            [subscriber sendError:error];
        }];
        return nil;
    }];
}

/**
 使用头饰（headwearId传0则不适用头饰）
 
 @param headwearId 头饰Id
 */
- (void)userHeadwearByHeadwearId:(NSString *)headwearId {
    [HttpRequestHelper userHeadwearByHeadwearId:headwearId Success:^(BOOL success) {
        NotifyCoreClient(UserCoreClient, @selector(onUseHeadwearSuccess), onUseHeadwearSuccess)
    } failure:^(NSNumber *reCode, NSString *message) {
        NotifyCoreClient(UserCoreClient, @selector(onUseHeadwearFailth:), onUseHeadwearFailth:message);
    }];
}
/**
 使用头饰（headwearId传0则不适用头饰）
 
 @param headwearId 头饰Id
 */
- (void)userHeadwearByHeadwearId:(NSString *)headwearId andHeadWear:(UserHeadWear *)headwear{
    [HttpRequestHelper userHeadwearByHeadwearId:headwearId Success:^(BOOL success) {
        [self updateMyHeadWear:headwear];
        NotifyCoreClient(UserCoreClient, @selector(onUseHeadwearSuccess), onUseHeadwearSuccess)
    } failure:^(NSNumber *reCode, NSString *message) {
        NotifyCoreClient(UserCoreClient, @selector(onUseHeadwearFailth:), onUseHeadwearFailth:message);
    }];
}


/**
 获取头饰详情
 
 @param headwearId 头饰Id
 @return 包含头饰详情模型的signal
 */
- (RACSignal *)getHeadwearDetailByHeadwearId:(NSString *)headwearId {
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [HttpRequestHelper getHeadwearDetailWithHeadwearId:headwearId Success:^(UserHeadWear *hearwear) {
            if (hearwear) {
                [subscriber sendNext:hearwear];
                [subscriber sendCompleted];
            }else {
                NSError *error = [[NSError alloc]initWithDomain:@"获取的头饰数据为空" code:400 userInfo:nil];
                [subscriber sendError:error];
            }
        } failure:^(NSNumber *resCode, NSString *message) {
            NSError *error = [[NSError alloc]initWithDomain:message code:[resCode integerValue] userInfo:nil];
            [subscriber sendError:error];
        }];
        return nil;
    }];
}
/**
 购买头饰
 
 @param headwearId 头饰Id
 @return complete就是成功 error就是失败
 */
- (RACSignal *)buyHeadwearByHeadwearId:(NSString *)headwearId headwear:(UserHeadWear *)headerwear type:(NSInteger)type {
    @weakify(self);
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {

        [HttpRequestHelper buyOrRenewHeadwearByHeadwearId:headwearId type:type Success:^(BOOL success) {
             [subscriber sendCompleted];
            @strongify(self);
            [self updateMyHeadWear:headerwear];
            self.hasNewCarOrder = YES;
        } failure:^(NSNumber *resCode, NSString *message) {
            NSError *error = [[NSError alloc]initWithDomain:message code:[resCode integerValue] userInfo:nil];
            [subscriber sendError:error];
            
        }];
        return nil;
    }];
}

#pragma mark -
#pragma mark v2 版本
//***************** 2019年03月25日 公会线添加 v2 版本  ******************/
/**
 购买头饰 v2 版本
 interface headwear/v2/buy
 
 @param headwearId 头饰id
 @param currencyType 支付货币类型：0金币，1萝卜
 @return complete就是成功 error就是失败
 
 */
- (RACSignal *)buyHeadwearByHeadwearId:(NSString *)headwearId currencyType:(BuyGoodsType)currencyType {
    @weakify(self);
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        
        [HttpRequestHelper buyHeadwearWithHeadwearID:headwearId currencyType:currencyType Success:^(BOOL success) {
            @strongify(self);
            self.hasNewCarOrder = YES;
            [subscriber sendCompleted];
        } failure:^(NSNumber *resCode, NSString *message) {
            NSError *error = [[NSError alloc] initWithDomain:message code:[resCode integerValue] userInfo:nil];
            [subscriber sendError:error];
        }];
        return nil;
    }];
}

/**
 赠送头饰 v2 版本
 interface headwear/v2/headwear/donate
 
 @param headwearId 头饰 id
 @param targetUid 赠送目标 uid
 @param currencyType 支付货币类型：0金币，1萝卜
 @return complete就是成功 error就是失败
 */
- (RACSignal *)presentHeadwearByHeadwearId:(NSString *)headwearId toTargetUid:(UserID)targetUid currencyType:(BuyGoodsType)currencyType {
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [HttpRequestHelper presentHeadwearWithHeadwearId:headwearId toTargetUid:targetUid currencyType:currencyType success:^(BOOL success) {
            [subscriber sendCompleted];
        } failure:^(NSNumber *resCode, NSString *message) {
            NSError *error = [[NSError alloc] initWithDomain:message code:[resCode integerValue] userInfo:nil];
            [subscriber sendError:error];
        }];
        return nil;
    }];
}

#pragma mark  - Private

- (void)updateMyHeadWear:(UserHeadWear *)headwear {
    if ([headwear.headwearId isEqualToString:@"0"]) {
        headwear = nil;
    }
    UserInfo *myInfo = [GetCore(UserCore)getUserInfoInDB:[GetCore(AuthCore)getUid].userIDValue];
    headwear.status = Headwear_Status_ok;
    myInfo.userHeadwear = headwear;
    [[XCDBManager defaultManager]creatOrUpdateUser:myInfo complete:nil];
    [[UserCache shareCache]saveUserInfo:myInfo];
}
@end
