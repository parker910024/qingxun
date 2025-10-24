//
//  HttpRequestHelper+RoomGiftValue.m
//  AFNetworking
//
//  Created by lvjunhang on 2019/4/25.
//

#import "HttpRequestHelper+RoomGiftValue.h"
#import "AuthCore.h"

@implementation HttpRequestHelper (RoomGiftValue)

/*
 获取房间所有麦序用户礼物值
 
 @param roomUid 房主 UID
 */
+ (void)requestRoomMicGiftValueForRoomUid:(UserID)roomUid success:(void (^)(RoomOnMicGiftValue *model))success failure:(void (^)(NSNumber *code, NSString *message))failure {
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params safeSetObject:[GetCore(AuthCore) getUid] forKey:@"uid"];
    [params safeSetObject:[NSNumber numberWithInteger:roomUid] forKey:@"roomUid"];
    
    [HttpRequestHelper GET:@"room/gift/value/get" params:params success:^(id data) {
        if (success) {
            RoomOnMicGiftValue *model = [RoomOnMicGiftValue yy_modelWithJSON:data];
            success(model);
        }
    } failure:^(NSNumber *resCode, NSString *message) {
        if (failure) {
            failure(resCode, message);
        }
    }];
}

/**
 清除礼物值
 
 @param roomUid 房主 UID
 @param micUid 被清除的用户
 */
+ (void)requestRoomGiftValueCleanWithRoomUid:(UserID)roomUid micUid:(UserID)micUid success:(void (^)(RoomOnMicGiftValue *model))success failure:(void (^)(NSNumber *code, NSString *msg))failure {
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params safeSetObject:[GetCore(AuthCore) getUid] forKey:@"uid"];
    [params safeSetObject:[NSNumber numberWithInteger:roomUid] forKey:@"roomUid"];
    [params safeSetObject:[NSNumber numberWithInteger:micUid] forKey:@"micUid"];
    
    [HttpRequestHelper DELETE:@"room/gift/value/clean" params:params success:^(id data) {
        if (success) {
            RoomOnMicGiftValue *model = [RoomOnMicGiftValue yy_modelWithJSON:data];
            success(model);
        }
    } failure:^(NSNumber *resCode, NSString *message) {
        if (failure) {
            failure(resCode, message);
        }
    }];
}

/**
 礼物值打开情况下，下麦
 
 @param roomUid 房主 UID
 @param micUid 下麦用户
 @param position 麦序位置
 */
+ (void)requestRoomGiftValueStatusDownMicWithRoomUid:(UserID)roomUid micUid:(UserID)micUid position:(NSString *)position success:(void (^)(void))success failure:(void (^)(NSNumber *code, NSString *msg))failure {
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params safeSetObject:[GetCore(AuthCore) getUid] forKey:@"uid"];
    [params safeSetObject:[NSNumber numberWithInteger:roomUid] forKey:@"roomUid"];
    [params safeSetObject:[NSNumber numberWithInteger:micUid] forKey:@"micUid"];
    [params safeSetObject:position forKey:@"position"];
    
    [HttpRequestHelper POST:@"room/gift/value/down/mic" params:params success:^(id data) {
        if (success) {
            success();
        }
    } failure:^(NSNumber *resCode, NSString *message) {
        if (failure) {
            failure(resCode, message);
        }
    }];
}

/**
 礼物值打开情况下，上麦
 
 @param roomUid 房主 UID
 @param micUid 上麦用户
 @param position 麦序位置
 */
+ (void)requestRoomGiftValueStatusUpMicWithRoomUid:(UserID)roomUid micUid:(UserID)micUid position:(NSString *)position success:(void (^)(void))success failure:(void (^)(NSNumber *code, NSString *msg))failure {
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params safeSetObject:[GetCore(AuthCore) getUid] forKey:@"uid"];
    [params safeSetObject:[NSNumber numberWithInteger:roomUid] forKey:@"roomUid"];
    [params safeSetObject:[NSNumber numberWithInteger:micUid] forKey:@"micUid"];
    [params safeSetObject:position forKey:@"position"];
    
    [HttpRequestHelper POST:@"room/gift/value/up/mic" params:params success:^(id data) {
        if (success) {
            success();
        }
    } failure:^(NSNumber *resCode, NSString *message) {
        if (failure) {
            failure(resCode, message);
        }
    }];
}

/**
 关闭房间礼物值开关
 
 @param roomUid 房主 UID
 */
+ (void)requestRoomGiftValueCloseWithRoomUid:(UserID)roomUid success:(void (^)(void))success failure:(void (^)(NSNumber *code, NSString *msg))failure {
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params safeSetObject:[GetCore(AuthCore) getUid] forKey:@"uid"];
    [params safeSetObject:[NSNumber numberWithInteger:roomUid] forKey:@"roomUid"];
    
    [HttpRequestHelper POST:@"room/gift/value/close" params:params success:^(id data) {
        if (success) {
            success();
        }
    } failure:^(NSNumber *resCode, NSString *message) {
        if (failure) {
            failure(resCode, message);
        }
    }];
}

/**
 开启房间礼物值开关
 
 @param roomUid 房主 UID
 */
+ (void)requestRoomGiftValueOpenWithRoomUid:(UserID)roomUid success:(void (^)(void))success failure:(void (^)(NSNumber *code, NSString *msg))failure {
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params safeSetObject:[GetCore(AuthCore) getUid] forKey:@"uid"];
    [params safeSetObject:[NSNumber numberWithInteger:roomUid] forKey:@"roomUid"];
    
    [HttpRequestHelper POST:@"room/gift/value/open" params:params success:^(id data) {
        if (success) {
            success();
        }
    } failure:^(NSNumber *resCode, NSString *message) {
        if (failure) {
            failure(resCode, message);
        }
    }];
}

@end
