//
//  HttpRequestHelper+Activity.m
//  BberryCore
//
//  Created by 卫明何 on 2017/10/19.
//  Copyright © 2017年 chenran. All rights reserved.
//

#import "HttpRequestHelper+Activity.h"
#import "ActivityInfo.h"
#import "ActivityContainInfo.h"
#import "RoomCoreV2.h"
@implementation HttpRequestHelper (Activity)

+ (void)getOldUserRegressionActivityGiftWithInvitationCode:(NSString *)invitationCode uid:(UserID)uid success:(void (^)(BOOL))success failure:(void (^)(NSNumber *, NSString *))failure {
    NSString *method = @"user/goback";
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:@(uid) forKey:@"uid"];
    [params setObject:invitationCode forKey:@"inviteCode"];
    
    [HttpRequestHelper POST:method params:params success:^(id data) {
        success(YES);
    } failure:^(NSNumber *resCode, NSString *message) {
        failure(resCode,message);
    }];
    
}

+ (void)checkOldUserRegressionActivity:(UserID)uid
                               success:(void (^)(BOOL))success
                               failure:(void (^)(NSNumber *, NSString *))failure {
    NSString *method = @"user/checkLostUser";
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:@(uid) forKey:@"uid"];
    
    [HttpRequestHelper GET:method params:params success:^(id data) {
        if (data) {
            BOOL isClaimedAward = [[data objectForKey:@"isClaimedAward"] boolValue];
            BOOL isLostUser     = [[data objectForKey:@"isLostUser"] boolValue];
            if (isLostUser && !isClaimedAward) {
                success(YES);
            }else {
                success(NO);
            }
        }
    } failure:^(NSNumber *resCode, NSString *message) {
        failure(resCode,message);
    }];
}

+ (void)getActivityWithType:(NSInteger)type success:(void (^)(ActivityInfo *))success failure:(void (^)(NSNumber *, NSString *))failure {
    NSString *method = @"activity/query";
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:@(type) forKey:@"type"];
    
    [HttpRequestHelper GET:method params:params success:^(id data) {
        NSArray *act = data;
        if (act.count > 0) {
            ActivityInfo *info = [ActivityInfo yy_modelWithJSON:[data safeObjectAtIndex:0]];
            success(info);
        }
    } failure:^(NSNumber *resCode, NSString *message) {
        failure(resCode, message);
    }];
}

+ (void)getActivityListWithType:(NSInteger)type success:(void (^)(NSArray<ActivityInfo *> *))success failure:(void (^)(NSNumber *, NSString *))failure {
    NSString *method = @"activity/query";
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:@(type) forKey:@"type"];
    
    [HttpRequestHelper GET:method params:params success:^(id data) {
        if ([data isKindOfClass:[NSArray class]]) {
            NSArray<ActivityInfo *> *list = [NSArray yy_modelArrayWithClass:ActivityInfo.class json:data];
            success(list);
        }
    } failure:^(NSNumber *resCode, NSString *message) {
        failure(resCode, message);
    }];
    
}

+ (void)getActivityListWithTuTuType:(NSInteger)type
                            success:(void (^)(ActivityContainInfo *list))success
                            failure:(void (^)(NSNumber *resCode, NSString *message))failure {
    
    NSString *method = @"charge/activity/list";
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:@(type) forKey:@"type"];
    if (type == 2) {
        [params safeSetObject:@([GetCore(RoomCoreV2) getCurrentRoomInfo].roomId) forKey:@"roomId"];
    }
    [HttpRequestHelper POST:method params:params success:^(id data) {
        ActivityContainInfo *info = [ActivityContainInfo modelDictionary:data];
        success(info);
    } failure:^(NSNumber *resCode, NSString *message) {
        failure(resCode, message);
    }];
}

/// 获取活动高能暴击倒计时
/// @param completionHander 完成回调
+ (void)getActivityRunawayTimeWithRoomUid:(long long)roomUid
                         CompletionHander:(HttpRequestHelperCompletion)completionHander {
    NSString *method = @"activities/draw/getRoomRunawayTime";
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:@(roomUid) forKey:@"roomUid"];
    
    [self request:method
           method:HttpRequestHelperMethodGET
           params:params
       completion:completionHander];
}

@end
