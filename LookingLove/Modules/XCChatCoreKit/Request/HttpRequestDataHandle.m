//
//  HttpRequestDataHandle.m
//  XCChatCoreKit
//
//  Created by KevinWang on 2019/1/24.
//  Copyright © 2019 YiZhuan. All rights reserved.
//

#import "HttpRequestDataHandle.h"
#import "XCMacros.h"
#import "NSString+JsonToDic.h"

#import "HttpErrorClient.h"
#import "BalanceErrorClient.h"
#import "AlertCoreClient.h"
#import "PurseCoreClient.h"
#import "AuthCore.h"
#import "AuthCoreClient.h"

@interface HttpRequestDataHandle()

@property (nonatomic, strong) NSArray *needFiltURI;

@end

static HttpRequestDataHandle * instance = nil;

@implementation HttpRequestDataHandle

+ (instancetype)defaultHandle{
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[HttpRequestDataHandle alloc]init];
    });
    return instance;
}


- (void)handleRequestSuccessData:(NSString *)method response:(id)responseObject{
    
    NSString *message = [responseObject valueForKey:@"message"];
    NSNumber *resCode = [responseObject valueForKey:@"code"];
    
    if (resCode.longValue == 2103) {
        NotifyCoreClient(BalanceErrorClient, @selector(onBalanceNotEnough), onBalanceNotEnough);
        return ;
    }
 
    // 提现时，金额过大，需要先实名认证
    if (resCode.longValue == 10111) {
        NotifyCoreClient(PurseCoreClient, @selector(requestWithdrawalsFailNeedCertified:), requestWithdrawalsFailNeedCertified:resCode.longValue);
        return ;
    }
    
    /// 超管登录，需要短信验证 @fulong
    if ([responseObject isKindOfClass:[NSDictionary class]]) {
        if (projectType() == ProjectType_LookingLove &&
            [method isEqualToString:@"oauth/token"] &&
            [[responseObject objectForKey:@"superCodeVerify"] integerValue] == 1) {
            
            NotifyCoreClient(AuthCoreClient, @selector(onloginUserIsSuperAdminNeedVerifcial), onloginUserIsSuperAdminNeedVerifcial);
            return;
        }
    }
    

    if (projectType() == ProjectType_TuTu ||
        projectType() == ProjectType_Pudding ||
        projectType() == ProjectType_MengSheng ||
        projectType() == ProjectType_BB ||
        projectType() == ProjectType_LookingLove ||
        projectType() == ProjectType_Planet) {
        
        if (![self.needFiltURI containsObject:method]) {
            
            // 青少年模式进房错误 code == 30000 时，进行弹窗处理，同时不显示 toast。
            if (resCode.integerValue == 30000) {
                message = @"";
            }
            
            NotifyCoreClient(HttpErrorClient, @selector(requestFailureWithMsg:), requestFailureWithMsg:message);
            
        }else if ([method isEqualToString:@"oauth/token"] || [method isEqualToString:@"acc/third/login"]) {
            
            if (responseObject && [responseObject isKindOfClass:[NSDictionary class]] && [responseObject objectForKey:@"reason"] && [responseObject objectForKey:@"date"]) {
                
                NotifyCoreClient(HttpErrorClient, @selector(requestAccountWasBlockWith:), requestAccountWasBlockWith:responseObject);
            }
        }
        
    }else {
        
        if (![self.needFiltURI containsObject:method]) {
            
            // 青少年模式进房错误 code == 30000 时，进行弹窗处理，同时不显示 toast。
            if (resCode.integerValue == 30000) {
                message = @"";
            }
            
            NotifyCoreClient(HttpErrorClient, @selector(requestFailureWithMsg:), requestFailureWithMsg:message);
        }
    }
}


- (void)handleRequestFailData:(NSString *)method errorInfo:(ErrorInfo *)errorInfo{
    if (projectType() == ProjectType_TuTu ||
        projectType() == ProjectType_Pudding ||
        projectType() == ProjectType_MengSheng ||
        projectType() == ProjectType_BB ||
        projectType() == ProjectType_LookingLove ||
        projectType() == ProjectType_Planet) {
        
        if (![self.needFiltURI containsObject:method]) {
            
            NotifyCoreClient(HttpErrorClient, @selector(requestFailureWithMsg:), requestFailureWithMsg:errorInfo.message);
            
        }
        //解决获取不到封禁的时间与原有，先去掉该代码--KevinWang 2019.6.10
//        else if ([method isEqualToString:@"oauth/token"] || [method isEqualToString:@"acc/third/login"]) {
//
//            NSRange rangeOfString = [errorInfo.message rangeOfString:@":"];
//            if (rangeOfString.location != NSNotFound) {
//                NSString *blockJson = [errorInfo.message substringFromIndex:rangeOfString.location];
//                NSDictionary *blockInfo = [NSString dictionaryWithJsonString:blockJson];
//                NotifyCoreClient(HttpErrorClient, @selector(requestAccountWasBlockWith:), requestAccountWasBlockWith:blockInfo);
//            }
//
//        }
    }else {
        
        if (![self.needFiltURI containsObject:method]) {
            
            NotifyCoreClient(HttpErrorClient, @selector(requestFailureWithMsg:), requestFailureWithMsg:errorInfo.message);
        }
    }
}

- (NSArray *)needFiltURI{
    if (!_needFiltURI) {
        _needFiltURI = @[@"user/isBindPhone",
                         @"gift/sendV3",
                         @"car/pay/byGold",
                         @"family/familyInfo",
                         @"family/detail",
                         @"acc/third/isExistsQqAccount",
                         @"room/queue",
                         @"oauth/token",
                         @"acc/third/login",
                         @"game/v1/gameInfo/getGameUrlV2",
                         @"works/play",
                         @"charge/activity/list",
                         @"gift/sendV4",
                         @"giftmagic/v1/batch/send",
                         @"room/blindDate/updateProcedure"];
    }
    return _needFiltURI;
}

@end
