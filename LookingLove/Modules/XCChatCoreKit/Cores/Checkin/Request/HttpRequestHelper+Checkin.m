//
//  HttpRequestHelper+Checkin.m
//  AFNetworking
//
//  Created by lvjunhang on 2019/3/25.
//

#import "HttpRequestHelper+Checkin.h"
#import "AuthCore.h"

@implementation HttpRequestHelper (Checkin)

/**
 签到分享统计接口
 
 @param completion 完成回调
 */
+ (void)requestCheckinShareOnCompletion:(HttpRequestHelperCheckinCompletion)completion {
    NSString *path = @"/sign/signShare";
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:GetCore(AuthCore).getUid forKey:@"uid"];
    
    [self checkin_request:path
                 method:HttpRequestHelperMethodPOST
                 params:params
             completion:completion];
}

/**
 领取累计奖励
 
 @param configId 奖励配置id
 @param completion 完成回调
 */
+ (void)requestCheckinReceiveTotalRewardWithConfigId:(NSString *)configId completion:(HttpRequestHelperCheckinCompletion)completion {
    
    NSString *path = @"/sign/receiveTotalReward";
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:GetCore(AuthCore).getUid forKey:@"uid"];
    [params setValue:configId forKey:@"configId"];
    
    [self checkin_request:path
                   method:HttpRequestHelperMethodPOST
                   params:params
               completion:completion];
}

/**
 瓜分金币
 
 @param completion 完成回调
 */
+ (void)requestCheckinDrawOnCompletion:(HttpRequestHelperCheckinCompletion)completion {
    NSString *path = @"/sign/draw";
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:GetCore(AuthCore).getUid forKey:@"uid"];
    
    [self checkin_request:path
                   method:HttpRequestHelperMethodPOST
                   params:params
               completion:completion];
}

/**
 每日签到奖励预告
 
 @param completion 完成回调
 */
+ (void)requestCheckinRewardTodayNoticeOnCompletion:(HttpRequestHelperCheckinCompletion)completion {
    NSString *path = @"/sign/rewardTodayNotice";
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:GetCore(AuthCore).getUid forKey:@"uid"];
    
    [self checkin_request:path
                   method:HttpRequestHelperMethodPOST
                   params:params
               completion:completion];
}

/**
 获取签到详情
 
 @param completion 完成回调
 */
+ (void)requestCheckinSignDetailOnCompletion:(HttpRequestHelperCheckinCompletion)completion {
    NSString *path = @"/sign/signDetail";
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:GetCore(AuthCore).getUid forKey:@"uid"];
    
    [self checkin_request:path
                   method:HttpRequestHelperMethodPOST
                   params:params
               completion:completion];
}

/**
 签到接口
 
 @param completion 完成回调
 */
+ (void)requestCheckinSignOnCompletion:(HttpRequestHelperCheckinCompletion)completion {
    NSString *path = @"/sign/sign";
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:GetCore(AuthCore).getUid forKey:@"uid"];
    
    [self checkin_request:path
                   method:HttpRequestHelperMethodPOST
                   params:params
               completion:completion];
}

/**
 累计奖励预告
 
 @param completion 完成回调
 */
+ (void)requestCheckinRewardTotalNoticeOnCompletion:(HttpRequestHelperCheckinCompletion)completion {
    NSString *path = @"/sign/rewardTotalNotice";
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:GetCore(AuthCore).getUid forKey:@"uid"];
    
    [self checkin_request:path
                   method:HttpRequestHelperMethodPOST
                   params:params
               completion:completion];
}

/**
 瓜分金币通知栏
 
 @param completion 完成回调
 */
+ (void)requestCheckinDrawNoticeOnCompletion:(HttpRequestHelperCheckinCompletion)completion {
    NSString *path = @"/sign/drawNotice";
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:GetCore(AuthCore).getUid forKey:@"uid"];
    
    [self checkin_request:path
                   method:HttpRequestHelperMethodPOST
                   params:params
               completion:completion];
}

/**
 签到提醒(开启/关闭)
 
 @param completion 完成回调
 */
+ (void)requestCheckinSignRemindOnCompletion:(HttpRequestHelperCheckinCompletion)completion {
    NSString *path = @"/sign/remind";
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:GetCore(AuthCore).getUid forKey:@"operUid"];
    
    [self checkin_request:path
                   method:HttpRequestHelperMethodPOST
                   params:params
               completion:completion];
}

/**
 获取签到分享图片

 @param shareType 分享类型：1普通，2领取礼物，3瓜分金币
 @param day 天数
 @param reward 奖励
 @param completion 完成回调
 */
+ (void)requestCheckinShareImageWithType:(NSInteger)shareType
                                     day:(NSString *)day
                                  reward:(NSString *)reward
                              completion:(HttpRequestHelperCheckinCompletion)completion {
    
    NSString *path = @"/sign/getShareImage";
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:GetCore(AuthCore).getUid forKey:@"uid"];
    [params setValue:@(shareType) forKey:@"shareType"];
    [params setValue:day forKey:@"day"];
    [params setValue:reward forKey:@"reward"];
    
    [self checkin_request:path
                   method:HttpRequestHelperMethodGET
                   params:params
               completion:completion];
}

/**
 获取补签信息
 
 @param signDay 第几天补签
 */
+ (void)requestCheckinReplenishInfoWithSignDay:(NSUInteger)signDay
                                    completion:(HttpRequestHelperCheckinCompletion)completion {
    
    NSString *path = @"/sign/replenish/info";
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:GetCore(AuthCore).getUid forKey:@"uid"];
    [params setValue:@(signDay) forKey:@"signDay"];

    [self checkin_request:path
                   method:HttpRequestHelperMethodGET
                   params:params
               completion:completion];
}

/**
 补签
 
 @param signDay 第几天补签
 */
+ (void)requestCheckinReplenishWithSignDay:(NSUInteger)signDay
                                completion:(HttpRequestHelperCheckinCompletion)completion {
    
    NSString *path = @"/sign/replenish";
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:GetCore(AuthCore).getUid forKey:@"uid"];
    [params setValue:@(signDay) forKey:@"signDay"];
    
    [self checkin_request:path
                   method:HttpRequestHelperMethodPOST
                   params:params
               completion:completion];
}

#pragma mark - Private Methods
+ (void)checkin_request:(NSString *)url
               method:(HttpRequestHelperMethod)method
               params:(NSDictionary *)params
           completion:(HttpRequestHelperCheckinCompletion)completion {
    if ([url hasPrefix:@"/"]) {
        url = [url substringFromIndex:1];
    }
    
    [self request:url method:method params:params success:^(id data) {
        if (completion) {
            completion(data, nil, nil);
        }
    } failure:^(NSNumber *resCode, NSString *message) {
        if (completion) {
            completion(nil, resCode, message);
        }
    }];
}

@end
