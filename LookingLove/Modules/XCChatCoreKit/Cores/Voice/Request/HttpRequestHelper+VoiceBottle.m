//
//  HttpRequestHelper+VoiceBottle.m
//  XCChatCoreKit
//
//  Created by fengshuo on 2019/6/5.
//  Copyright © 2019 YiZhuan. All rights reserved.
//

#import "HttpRequestHelper+VoiceBottle.h"
#import "NSMutableDictionary+Safe.h"
#import "AuthCore.h"

@implementation HttpRequestHelper (VoiceBottle)

+ (void)voliceBottleGetPiaWith:(UserID)uid
                      pageSize:(int)pageSize
                          type:(VoicePiaType)type
                       success:(void(^)(NSArray *array))success
                       failure:(void (^)(NSNumber *, NSString *))failure {
    NSString * method = @"voice/pia/get";
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    [params safeSetObject:@(uid) forKey:@"uid"];
    [params safeSetObject:@(pageSize) forKey:@"pageSize"];
    [HttpRequestHelper GET:method params:params success:^(id data) {
        NSArray * array = [NSArray yy_modelArrayWithClass:[VoiceBottlePiaModel class] json:data];
        success(array);
    } failure:^(NSNumber *resCode, NSString *message) {
        failure(resCode, message);
    }];
}

/** 获取声音匹配列表 */
+ (void)requestVoiceMatchingListWithGender:(NSInteger)gender
                                  pageSize:(NSInteger)pageSize
                                   success:(void(^)(NSArray *array))success
                                   failure:(void (^)(NSNumber *, NSString *))failure {
    NSString * method = @"voice/list";
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    NSString *uid = [GetCore(AuthCore) getUid];
    [params safeSetObject:uid forKey:@"uid"];
    [params safeSetObject:@(pageSize) forKey:@"pageSize"];
    [params safeSetObject:@(gender) forKey:@"gender"];
    [HttpRequestHelper POST:method params:params success:^(id data) {
        NSArray * array = [NSArray yy_modelArrayWithClass:[VoiceBottleModel class] json:data];
        success(array);
    } failure:^(NSNumber *resCode, NSString *message) {
        failure(resCode, message);
    }];
}

/** 声音喜欢or不喜欢请求 */
+ (void)sendVoiceLikeRequestWithVoiceId:(NSInteger)voiceId
                                 isLike:(BOOL)isLike
                                success:(void(^)(void))success
                                failure:(void (^)(NSNumber *, NSString *))failure {
    NSString * method = @"voice/like";
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    NSString *uid = [GetCore(AuthCore) getUid];
    [params safeSetObject:uid forKey:@"uid"];
    [params safeSetObject:@(voiceId) forKey:@"voiceId"];
    [params safeSetObject:@(isLike) forKey:@"type"];
    [HttpRequestHelper POST:method params:params success:^(id data) {
        success();
    } failure:^(NSNumber *resCode, NSString *message) {
        failure(resCode, message);
    }];
}

/**
 上传声音到服务器
 
 @param uid 用户的id
 @param voiceUrl 声音的链接
 @param voiceLength 声音的长度
 @param piaId 剧本的id
 @param type 剧本的类型
 @param voiceId 声音的id
 */
+ (void)updateVoiceToServiceWith:(UserID)uid
                        voiceUrl:(NSString *)voiceUrl
                     voiceLength:(int)voiceLength
                           piaId:(UserID)piaId
                            type:(VoicePiaType)type
                         voiceId:(UserID)voiceId
                         success:(void(^)(VoiceBottleModel * model))success
                         failure:(void (^)(NSNumber *, NSString *))failure {
    NSString * method = @"voice/save";
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    [params safeSetObject:@(uid) forKey:@"uid"];
    [params safeSetObject:voiceUrl forKey:@"voiceUrl"];
    [params safeSetObject:@(voiceLength) forKey:@"voiceLength"];
    [params safeSetObject:@(piaId) forKey:@"piaId"];
    [params safeSetObject:@(type) forKey:@"type"];
    if (voiceId && voiceId > 0) {
       [params safeSetObject:@(voiceId) forKey:@"voiceId"];
    }

    [HttpRequestHelper POST:method params:params success:^(id data) {
        VoiceBottleModel * model = [VoiceBottleModel yy_modelWithJSON:data];
        success(model);
    } failure:^(NSNumber *resCode, NSString *message) {
        failure(resCode, message);
    }];
}

/** 增加声音播放次数 */
+ (void)addVoicePlayCountRequestWithVoiceId:(UserID)voiceId
                                   voiceUid:(UserID)voiceUid
                                    success:(void(^)(void))success
                                    failure:(void (^)(NSNumber *, NSString *))failure {
    NSString * method = @"voice/add/play/count";
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    NSString *uid = [GetCore(AuthCore) getUid];
    [params safeSetObject:uid forKey:@"uid"];
    if (voiceId > 0) {
        [params safeSetObject:@(voiceId) forKey:@"voiceId"];
    }
    [params safeSetObject:@(voiceUid) forKey:@"voiceUid"];
    [HttpRequestHelper POST:method params:params success:^(id data) {
        success();
    } failure:^(NSNumber *resCode, NSString *message) {
        failure(resCode, message);
    }];
}

/**
 请求我的声音列表
 */
+ (void)requestMyVoiceListWithSuccess:(void(^)(NSArray *array))success
                              failure:(void (^)(NSNumber *, NSString *))failure {
    NSString *method = @"voice/my";
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    NSString *uid = [GetCore(AuthCore) getUid];
    [params safeSetObject:uid forKey:@"uid"];
    [HttpRequestHelper POST:method params:params success:^(id data) {
        NSArray * array = [NSArray yy_modelArrayWithClass:[VoiceBottleModel class] json:data];
        success(array);
    } failure:^(NSNumber *resCode, NSString *message) {
        failure(resCode, message);
    }];
}

/** 查询旧版本个人介绍声音 */
+ (void)requestOldVoiceIntroduceWithSuccess:(void(^)(NSDictionary *dict))success
                                    failure:(void (^)(NSNumber *, NSString *))failure {
    NSString *method = @"voice/history/query";
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    NSString *uid = [GetCore(AuthCore) getUid];
    [params safeSetObject:uid forKey:@"uid"];
    [HttpRequestHelper POST:method params:params success:^(id data) {
        success(data);
    } failure:^(NSNumber *resCode, NSString *message) {
        failure(resCode, message);
    }];
}

/** 同步旧版本个人介绍声音到声音瓶子 */
+ (void)sendOldVoiceIntroduceSyncVoiceBottle:(NSInteger)voiceId
                                     success:(void(^)(void))success
                                     failure:(void (^)(NSNumber *, NSString *))failure {
    NSString *method = @"voice/history/sync";
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    NSString *uid = [GetCore(AuthCore) getUid];
    [params safeSetObject:uid forKey:@"uid"];
    [params safeSetObject:@(voiceId) forKey:@"voiceId"];
    [HttpRequestHelper POST:method params:params success:^(id data) {
        success();
    } failure:^(NSNumber *resCode, NSString *message) {
        failure(resCode, message);
    }];
}



@end
