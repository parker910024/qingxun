//
//  HttpRequestHelper+PublicChatroom.m
//  XCChatCoreKit
//
//  Created by 卫明 on 2018/11/5.
//  Copyright © 2018 KevinWang. All rights reserved.
//

#import "HttpRequestHelper+PublicChatroom.h"
#import "AuthCore.h"
#import <NSObject+YYModel.h>

#import "ImRemoteMessage.h"
#import "ImRemoteTransform.h"
#import "ImPublicChatroomCore.h"

@implementation HttpRequestHelper (PublicChatroom)

+ (void)searchAtFriendNoticeFansKey:(NSString *)key
                            Success:(void (^)(NSArray<SearchResultInfo *> * _Nonnull))success
                            failure:(void (^)(NSNumber * _Nonnull, NSString * _Nonnull))failure {
    NSString *method = @"fans/search/fans";
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:[GetCore(AuthCore)getUid] forKey:@"uid"];
    [params setObject:key forKey:@"searchKey"];
    
    [HttpRequestHelper GET:method params:params success:^(id data) {
        NSArray *info = [NSArray yy_modelArrayWithClass:[SearchResultInfo class] json:data];
        success(info);
    } failure:^(NSNumber *resCode, NSString *message) {
        failure(resCode,message);
    }];
}

+ (void)fetchPublicMessageWithType:(TTPublicHistoryMessageDataProviderType)type
                      byChatroomid:(NSString *)chatroomId
                             count:(NSInteger)count
                         pageCount:(NSInteger)pageCount
                           success:(void (^)(NSArray<NIMMessage *> *))success
                           failure:(void (^)(NSNumber * _Nonnull, NSString * _Nonnull))failure {
    NSString *method = @"public/chatroom/getMsg";
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:@(count) forKey:@"pageSize"];
    [params setObject:@(pageCount) forKey:@"page"];
    [params setObject:[GetCore(AuthCore) getUid] forKey:@"uid"];
    [params setObject:type > 0?@(type):@(TTPublicHistoryMessageDataProviderType_AtMe) forKey:@"type"];
    
    [HttpRequestHelper GET:method params:params success:^(id data) {
        NSArray *messages = [NSArray yy_modelArrayWithClass:[ImRemoteMessage class] json:data];
        success([ImRemoteTransform remoteArrToNIMMessages:messages]);
    } failure:^(NSNumber *resCode, NSString *message) {
        failure(resCode,message);
    }];
}



+ (void)repuestPublicChatRoomNotMessage:(UserID)targetUid
                               duration:(int)duration
                                 remark:(NSString *)remark
                                success:(void (^)(void))success
                                failure:(void (^)(NSNumber *resCode, NSString *message))failure{
    
    NSString *method = @"room/mute/add";
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    if (projectType() == ProjectType_TuTu ||
        projectType() == ProjectType_Pudding ||
        projectType() == ProjectType_LookingLove ||
        projectType() == ProjectType_Planet) {
        
        method = @"userMute/record/add";
        
        [params setObject:@(GetCore(ImPublicChatroomCore).publicChatroomId) forKey:@"roomId"];
        [params setObject:@(targetUid) forKey:@"targetUid"];
        [params setObject:@(duration) forKey:@"muteTime"];
        [params setObject:remark forKey:@"reason"];
        
    } else {
        [params setObject:@(GetCore(ImPublicChatroomCore).publicChatroomUid) forKey:@"roomUid"];
        [params setObject:[GetCore(AuthCore) getUid] forKey:@"uid"];
        [params setObject:@(targetUid) forKey:@"targetUid"];
        [params setObject:@(duration) forKey:@"duration"];
        [params setObject:remark forKey:@"remark"];
    }
    
    [HttpRequestHelper POST:method params:params success:^(id data) {
        success();
    } failure:^(NSNumber *resCode, NSString *message) {
        failure(resCode,message);
    }];
}
@end
