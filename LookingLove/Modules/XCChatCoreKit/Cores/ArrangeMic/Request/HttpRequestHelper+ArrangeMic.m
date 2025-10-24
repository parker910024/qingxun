//
//  HttpRequestHelper+ArrangeMic.m
//  XCChatCoreKit
//
//  Created by gzlx on 2018/12/13.
//  Copyright © 2018年 KevinWang. All rights reserved.
//

#import "HttpRequestHelper+ArrangeMic.h"
#import "ArrangeMicModel.h"

@implementation HttpRequestHelper (ArrangeMic)
/**
 房间开启或者关闭排麦
 
 @param roomId 房间的UId
 @param arrangeStatus 0 是关闭 1 是开启
 @param success 成功
 @param failure 失败
 */
+ (void)openOrCloseArrangeMicWith:(UserID)roomId
                          operUid:(UserID)operUid
                    arrangeStatus:(BOOL)arrangeStatus
                          success:(void(^)(NSDictionary * arrangeMicStatus))success
                             fail:(void(^)(NSString * message, NSNumber * failCode))failure{
    NSMutableDictionary * parmas= [NSMutableDictionary dictionary];
    NSString * method = @"room/queue/enable";
    [parmas safeSetObject:@(roomId) forKey:@"roomUid"];
    [parmas safeSetObject:@(operUid) forKey:@"operUid"];
    if (arrangeStatus) {
        [HttpRequestHelper POST:method params:parmas success:^(id data) {
            success(data);
        } failure:^(NSNumber *resCode, NSString *message) {
            failure(message, resCode);
        }];
    }else{
        [HttpRequestHelper DELETE:method params:parmas success:^(id data) {
            success(data);
        } failure:^(NSNumber *resCode, NSString *message) {
            failure(message, resCode);
        }];
    }
}


/**
 取消排麦/开始排麦
 
 @param roomUid 排麦的人id
 @param userStatus 0 开始排麦 1 取消排麦
 @Param operUid 报名的那个人id
 @param success 成功
 @param failure 失败
 */
+ (void)beginOrCancleArrangeMicWith:(UserID)roomUid
                            operUid:(UserID)operUid
                         userStatus:(int)userStatus
                            success:(void(^)(NSDictionary *stateDic))success
                            failure:(void(^)(NSString * message, NSNumber * failCode))failure{
    NSMutableDictionary * parmas= [NSMutableDictionary dictionary];
    NSString * method = @"room/queue";
    [parmas safeSetObject:@(roomUid) forKey:@"roomUid"];
    [parmas safeSetObject:@(operUid) forKey:@"operUid"];
    if (userStatus == 0) {
        [HttpRequestHelper POST:method params:parmas success:^(id data) {
            success(data);
        } failure:^(NSNumber *resCode, NSString *message) {
            failure(message, resCode);
        }];
    }else{
        [HttpRequestHelper DELETE:method params:parmas success:^(id data) {
            success(data);
        } failure:^(NSNumber *resCode, NSString *message) {
            failure(message, resCode);
        }];
    }
}

/**
 获取排麦列表
 
 @param roomUid 房主的uid
 @param operUid 操作者的UId
 @param success 成功
 @param failure 失败
 */
+ (void)getUserArrangeMicListWith:(UserID)roomUid
                          operUid:(UserID)operUid
                             page:(int)page
                         pageSize:(int)pageSize
                          success:(void(^)(ArrangeMicModel *model))success
                          failure:(void(^)(NSString * message, NSNumber * failureCode))failure{
    NSMutableDictionary * parmas= [NSMutableDictionary dictionary];
    NSString * method = @"room/queue/list";
    [parmas safeSetObject:@(roomUid) forKey:@"roomUid"];
    [parmas safeSetObject:@(operUid) forKey:@"operUid"];
    [parmas safeSetObject:@(page) forKey:@"page"];
    [parmas safeSetObject:@(pageSize) forKey:@"pageSize"];
    [HttpRequestHelper GET:method params:parmas success:^(id data) {
        ArrangeMicModel * model =  [ArrangeMicModel modelWithJSON:data];
        success(model);
    } failure:^(NSNumber *resCode, NSString *message) {
        failure(message, resCode);
    }];
}


/**
 获取排麦队列的长度
 @param roomUid 房主的uid
 @param success 成功
 @param failure 失败
 */
+ (void)getUserArrangeMicListSizeWith:(UserID)roomUid
                          success:(void(^)(NSNumber * count))success
                          failure:(void(^)(NSString * message, NSNumber * failureCode))failure{
    NSMutableDictionary * parmas= [NSMutableDictionary dictionary];
    NSString * method = @"room/queue/size";
    [parmas safeSetObject:@(roomUid) forKey:@"roomUid"];
    [HttpRequestHelper GET:method params:parmas success:^(id data) {
        success(data);
    } failure:^(NSNumber *resCode, NSString *message) {
        failure(message, resCode);
    }];
}


@end
