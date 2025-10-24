//
//  HttpRequestHelper+CPRoom.m
//  UKiss
//
//  Created by apple on 2018/10/13.
//  Copyright © 2018年 yizhuan. All rights reserved.
//

#import "HttpRequestHelper+CPRoom.h"


@implementation HttpRequestHelper (CPRoom)

+ (void)requestCPRoomUserSignInlistWithByUid:(NSString *)uid
                                      success:(void (^)(CPSignInlistModel *signInlistModel))success
                                      failure:(void (^)(NSNumber *resCode, NSString *message))failure {
    NSString *method = @"user/signInlist";
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params safeSetObject:uid forKey:@"uid"];
    [HttpRequestHelper POST:method params:params success:^(id data) {
        CPSignInlistModel *signInlistModel = [CPSignInlistModel modelDictionary:data];
        success(signInlistModel);
    } failure:^(NSNumber *resCode, NSString *message) {
        if (failure) {
            failure(resCode, message);
        }
    }];
}

/**
 //每日签到接口/打卡记录
 */
+ (void)requestCPRoomSignInWithByUid:(UserID)uid
                             success:(void (^)(XCRedPckageModel *signInInfo))success
                             failure:(void (^)(NSNumber *resCode, NSString *message))failure{
    NSDictionary * param = @{
                             @"uid":[NSNumber numberWithUserID:uid]
                             };
    [HttpRequestHelper GET:@"user/signIn" params:param success:^(id data) {
        XCRedPckageModel * info = [XCRedPckageModel yy_modelWithJSON:data];
        success(info);
    } failure:^(NSNumber *resCode, NSString *message) {
        if (failure) {
            failure(resCode, message);
        }
    }];
    
}


/**
 每天是否是每天第一次启动
 */
+ (void)requestCPRoomDayFirstWithByUid:(UserID)uid
                               success:(void (^)(BOOL isFirst))success
                               failure:(void (^)(NSNumber *resCode, NSString *message))failure{
    NSDictionary * param = @{
                             @"uid":[NSNumber numberWithUserID:uid]
                             };
    [HttpRequestHelper GET:@"user/dayFirst" params:param success:^(id data) {
//        NSLog(@"date%@",data);
        NSDictionary * dict = data;
        
//        BOOL isfirst =  [dict valueForKey:@"first"];
        success([[data valueForKey:@"first"] boolValue]);
    } failure:^(NSNumber *resCode, NSString *message) {
        if (failure) {
            failure(resCode, message);
        }
    }];
    
}

/**
 今天的打卡状态/记录
 */
+ (void)requestCPRoomSignInStatusWithByUid:(UserID)uid
                                   success:(void (^)(XCCPSignStatus * signStatus))success
                                   failure:(void (^)(NSNumber *resCode, NSString *message))failure{
    NSDictionary * param = @{
                             @"uid":[NSNumber numberWithUserID:uid]
                             };
    [HttpRequestHelper GET:@"user/signInStatus" params:param success:^(id data) {
        XCCPSignStatus * signStatus = [XCCPSignStatus yy_modelWithDictionary:data];
        success(signStatus);
    } failure:^(NSNumber *resCode, NSString *message) {
        if (failure) {
            failure(resCode, message);
        }
    }];
    
}

/**
 打卡提醒
 */
+ (void)requestCPRoomSignInRemindWithByUid:(UserID)uid
                                   success:(void (^)(void))success
                                   failure:(void (^)(NSNumber *resCode, NSString *message))failure{
    NSDictionary * param = @{
                             @"uid":[NSNumber numberWithUserID:uid]
                             };
    [HttpRequestHelper GET:@"user/signInRemind" params:param success:^(id data) {
        success();
    } failure:^(NSNumber *resCode, NSString *message) {
        if (failure) {
            failure(resCode, message);
        }
    }];
    
}

+ (void)requestCPRoomBackRoomWithByUid:(NSString *)uid
                               success:(void (^)(void))success
                               failure:(void (^)(NSNumber *resCode, NSString *message))failure {
    NSString *method = @"push/backRoom";
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
@end
