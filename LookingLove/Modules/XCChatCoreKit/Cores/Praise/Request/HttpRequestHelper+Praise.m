//
//  HttpRequestHelper+Praise.m
//  BberryCore
//
//  Created by chenran on 2017/5/18.
//  Copyright © 2017年 chenran. All rights reserved.
//

#import "HttpRequestHelper+Praise.h"
#import "AuthCore.h"
#import "UserInfo.h"
#import "Attention.h"
#import "HeartCommentInfo.h"

@implementation HttpRequestHelper (Praise)

+ (void)praise:(UserID)paiseUid bePraisedUid:(UserID)bePraisedUid success:(void (^)(void))success failure:(void (^)(NSNumber *, NSString *))failure
{
    if (paiseUid <= 0 || bePraisedUid <= 0) {
        return;
    }
    
    NSString *ticket = [GetCore(AuthCore) getTicket];
    
    NSString *method = @"fans/like";
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:@(paiseUid) forKey:@"uid"];
    [params setObject:@(bePraisedUid) forKey:@"likedUid"];
    [params setObject:ticket forKey:@"ticket"];
    [params setObject:@(1) forKey:@"type"];
    
    [HttpRequestHelper POST:method params:params success:^(id data) {
        if (success) {
            success();
        }
    } failure:^(NSNumber *resCode, NSString *message) {
        if (failure) {
            failure(resCode, message);
        }
    }];
}

+ (void)cancel:(UserID)cancelUid beCanceledUid:(UserID)beCanceledUid success:(void (^)(void))success failure:(void (^)(NSNumber *, NSString *))failure
{
    if (cancelUid <= 0 || beCanceledUid <= 0) {
        return;
    }
    
    NSString *ticket = GetCore(AuthCore).getTicket;
    
    NSString *method = @"fans/like";
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:@(cancelUid) forKey:@"uid"];
    [params setObject:@(beCanceledUid) forKey:@"likedUid"];
    [params setObject:ticket forKey:@"ticket"];
    [params setObject:@(2) forKey:@"type"];
    
    [HttpRequestHelper POST:method params:params success:^(id data) {
        if (success) {
            success();
        }
    } failure:^(NSNumber *resCode, NSString *message) {
        if (failure) {
            failure(resCode, message);
        }
    }];
}

+ (void) deleteFriend:(UserID)deleteFriendUid beDeletedFriendUid:(UserID)beDeletedFriendUid
             success:(void (^)(void))success failure:(void (^)(NSNumber *, NSString *))failure
{
    if (deleteFriendUid <= 0 || beDeletedFriendUid <= 0) {
        return;
    }
    
    NSString *ticket = GetCore(AuthCore).getTicket;
    
    NSString *method = @"fans/fdelete";
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:@(deleteFriendUid) forKey:@"uid"];
    [params setObject:@(beDeletedFriendUid) forKey:@"likedId"];
    [params setObject:ticket forKey:@"ticket"];
    
    [HttpRequestHelper POST:method params:params success:^(id data) {
        if (success) {
            success();
        }
    } failure:^(NSNumber *resCode, NSString *message) {
        if (failure) {
            failure(resCode, message);
        }
    }];
}

+ (void) requestAttentionList:(UserID)uid
                        state:(int)state
                         page:(int)page
                     PageSize:(int)pageSize
                      success:(void (^)(NSArray *userIDs))success
                      failure:(void (^)(NSNumber *resCode, NSString *message))failure
{
    if (uid <= 0) {
        return;
    }
    
    NSString *method = @"fans/following";
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:@(uid) forKey:@"uid"];
    [params setObject:@(pageSize) forKey:@"pageSize"];
    [params setObject:@(page) forKey:@"pageNo"];
    
    [HttpRequestHelper GET:method params:params success:^(id data) {
//        NSArray *userInfos = [NSArray yy_modelArrayWithClass:[Attention class] json:data];
        NSArray *userInfos = [Attention modelsWithArray:data];
        if (success) {
            success(userInfos);
        }
    } failure:^(NSNumber *resCode, NSString *message) {
        if (failure) {
            failure(resCode, message);
        }
    }];
}

+ (void)isLike:(UserID)uid isLikeUid:(UserID)isLikeUid success:(void (^)(BOOL))success failure:(void (^)(NSNumber *, NSString *))failure
{
    if (uid <= 0) {
        return;
    }
    
    NSString *method = @"fans/islike";
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:@(uid) forKey:@"uid"];
    [params setObject:@(isLikeUid) forKey:@"isLikeUid"];
    
    [HttpRequestHelper GET:method params:params success:^(id data) {
        if (![data isKindOfClass:[NSDictionary class]]) {
            BOOL isLike = ((NSNumber *)data).boolValue;
            if (success) {
                success(isLike);
            }
        }else {
            success(NO);
        }
        
    } failure:^(NSNumber *resCode, NSString *message) {
        if (failure) {
            failure(resCode, message);
        }
    }];
}

//获取用户粉丝列表
+ (void)getFansListWithUid:(UserID)uid page:(NSInteger)page success:(void (^)(NSArray *))success failure:(void (^)(NSNumber *, NSString *))failure {
    NSString *method = @"fans/fanslist";
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:@(uid) forKey:@"uid"];
    if (page == 0) {
        [params setObject:@(1) forKey:@"pageNo"];
    }else {
        [params setObject:@(page) forKey:@"pageNo"];
    }
    [params setObject:@(20) forKey:@"pageSize"];
    [HttpRequestHelper GET:method params:params success:^(id data) {
        
        NSArray *userInfos = [Attention modelsWithArray:data[@"fansList"]];
        if (success) {
            success(userInfos);
        }
    } failure:^(NSNumber *resCode, NSString *message) {
        if (failure) {
            failure(resCode, message);
        }
    }];
}

+ (void) requestUnReadListTpye:(int)type
                   success:(void (^)(NSArray *lists))success
                   failure:(void (^)(NSNumber *resCode, NSString *message))failure{
    NSString *method = @"msg/unReadList";
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject: [GetCore(AuthCore) getUid] forKey:@"uid"];
    [params setObject:@(type) forKey:@"type"];
    [HttpRequestHelper POST:method params:params success:^(id data) {
        
        NSArray *lists = [HeartCommentInfo modelsWithArray:data];
        if (success) {
            success(lists);
        }
    } failure:^(NSNumber *resCode, NSString *message) {
        if (failure) {
            failure(resCode, message);
        }
    }];
}

+ (void) requestUnReadClearListTpye:(int)type
                            success:(void (^)())success
                            failure:(void (^)(NSString *message))failure{
    NSString *method = @"msg/clear";
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject: [GetCore(AuthCore) getUid] forKey:@"uid"];
    [params setObject:@(type) forKey:@"type"];
    [HttpRequestHelper POST:method params:params success:^(id data) {
        if (success) {
            success();
        }
    } failure:^(NSNumber *resCode, NSString *message) {
        if (failure) {
            failure(message);
        }
    }];
}

+ (void) requestUnReadCountSuccess:(void (^)(int likeCount, int commentCount))success
                            failure:(void (^)(NSString *message))failure{
    NSString *method = @"msg/unreadCount";
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject: [GetCore(AuthCore) getUid] forKey:@"uid"];
    
    [HttpRequestHelper POST:method params:params success:^(id data) {
        NSDictionary * dict = (NSDictionary *)data;
        int likeCount = [[dict valueForKey:@"likeCount"] intValue];
        int commentCount = [[dict valueForKey:@"commentCount"] intValue];
        if (success) {
            success(likeCount,commentCount);
        }
    } failure:^(NSNumber *resCode, NSString *message) {
        if (failure) {
            failure(message);
        }
    }];
}

+ (void) requestHistoryListTpye:(int)type
                           page:(NSInteger)page
                        minDate:(NSInteger)minDate
                        success:(void (^)(NSArray *lists))success
                        failure:(void (^)(NSString *message))failure{
    NSString *method = @"msg/historyList";
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject: [GetCore(AuthCore) getUid] forKey:@"uid"];
    [params setObject:@(type) forKey:@"type"];
    if (page == 0) {
        [params setObject:@(1) forKey:@"pageNum"];
    }else {
        [params setObject:@(page) forKey:@"pageNum"];
    }
    [params setObject:@(20) forKey:@"pageSize"];
    [params setObject:@(minDate) forKey:@"minDate"];
    [HttpRequestHelper POST:method params:params success:^(id data) {
        
        NSArray *lists = [HeartCommentInfo modelsWithArray:data];
        if (success) {
            success(lists);
        }
    } failure:^(NSNumber *resCode, NSString *message) {
        if (failure) {
            failure(message);
        }
    }];
}

@end
