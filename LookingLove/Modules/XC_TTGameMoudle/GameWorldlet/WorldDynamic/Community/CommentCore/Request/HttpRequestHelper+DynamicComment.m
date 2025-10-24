//
//  HttpRequestHelper+CPBind.m
//  UKiss
//
//  Created by apple on 2018/9/29.
//  Copyright © 2018年 yizhuan. All rights reserved.
//

#import "HttpRequestHelper+DynamicComment.h"
#import "AuthCore.h"
#import "CTCommentReplyModel.h"


@implementation HttpRequestHelper (DynamicComment)

+ (void)requestCommentListWithUid:(NSString *)uid
                        dynamicId:(long)dynamicId
                        pageNum:(NSInteger)pageNum
                          Success:(void (^)(NSArray <CTCommentReplyModel *>* commentList,int totalCount))success
                          failure:(void (^)(NSNumber *resCode, NSString *message))failure {
    NSString *method = @"comment/list";
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params safeSetObject:uid forKey:@"uid"];
    [params safeSetObject:@(dynamicId) forKey:@"dynamicId"];
    [params safeSetObject:@(pageNum) forKey:@"pageNum"];
    [params safeSetObject:@(5) forKey:@"pageSize"];
    [HttpRequestHelper POST:method params:params success:^(id data) {
        NSArray *commentList = [CTCommentReplyModel  modelsWithArray:data[@"list"]];
        int count = [data[@"count"] intValue];
        success(commentList , count);
    } failure:^(NSNumber *resCode, NSString *message) {
        if (failure) {
            failure(resCode, message);
        }
    }];
}

+ (void)requestAddCommentWithUid:(NSString *)uid
                       dynamicId:(long)dynamicId
                         content:(NSString *)content
                         Success:(void (^)(CTCommentReplyModel * commentModel))success
                         failure:(void (^)(NSNumber *resCode, NSString *message))failure {
    NSString *method = @"comment/addComment";
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params safeSetObject:uid forKey:@"uid"];
    [params safeSetObject:@(dynamicId) forKey:@"dynamicId"];
    [params safeSetObject:content forKey:@"content"];
    [HttpRequestHelper POST:method params:params success:^(id data) {
        CTCommentReplyModel *model = [CTCommentReplyModel  modelDictionary:data];
        success(model);
    } failure:^(NSNumber *resCode, NSString *message) {
        if (failure) {
            failure(resCode, message);
        }
    }];
}

+ (void)requestDeleteCommentWithUid:(NSString *)uid
                          dynamicId:(long)dynamicId
                          commentId:(long )commentId
                          type:(int)type
                            Success:(void (^)(void))success
                            failure:(void (^)(NSNumber *resCode, NSString *message))failure {
    NSString *method = [NSString stringWithFormat:@"comment/delete/%ld",commentId];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params safeSetObject:uid forKey:@"uid"];
    [params safeSetObject:@(dynamicId) forKey:@"dynamicId"];
    [params safeSetObject:@(type) forKey:@"type"];
    [HttpRequestHelper POST:method params:params success:^(id data) {
        success();
    } failure:^(NSNumber *resCode, NSString *message) {
        if (failure) {
            failure(resCode, message);
        }
    }];
}

+ (void)requestReplyCommentWithUid:(NSString *)uid
                         dynamicId:(long)dynamicId
                             toUid:(long)toUid
                           content:(NSString *)content
                         commentId:(long )commentId
                              type:(int)type
                           Success:(void (^)(CTCommentReplyModel * commentModel))success
                           failure:(void (^)(NSNumber *resCode, NSString *message))failure {
    NSString *method = [NSString stringWithFormat:@"comment/reply/%ld",commentId];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params safeSetObject:uid forKey:@"uid"];
    [params safeSetObject:@(dynamicId) forKey:@"dynamicId"];
    [params safeSetObject:@(toUid) forKey:@"toUid"];
    [params safeSetObject:content forKey:@"content"];
    [params safeSetObject:@(type) forKey:@"type"];
    [HttpRequestHelper POST:method params:params success:^(id data) {
        CTCommentReplyModel *model = [CTCommentReplyModel  modelDictionary:data];
        success(model);
    } failure:^(NSNumber *resCode, NSString *message) {
        if (failure) {
            failure(resCode, message);
        }
    }];
}

+ (void)requestCommentDetailsWithUid:(NSString *)uid
                           dynamicId:(long)dynamicId
                           commentId:(long )commentId
                             Success:(void (^)(CTCommentReplyModel * commentModel))success
                             failure:(void (^)(NSNumber *resCode, NSString *message))failure {
    NSString *method = [NSString stringWithFormat:@"comment/get/%ld",commentId];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params safeSetObject:uid forKey:@"uid"];
    [params safeSetObject:@(dynamicId) forKey:@"dynamicId"];
    [HttpRequestHelper POST:method params:params success:^(id data) {
        CTCommentReplyModel *model = [CTCommentReplyModel  modelDictionary:data];
        success(model);
    } failure:^(NSNumber *resCode, NSString *message) {
        if (failure) {
            failure(resCode, message);
        }
    }];
}

+ (void)requestCommentReplyListWithUid:(NSString *)uid
                             commentId:(long)commentId
                             dynamicId:(long)dynamicId
                               start:(NSInteger)start
                                ID:(long)ID
                               Success:(void (^)(NSArray <CTCommentReplyModel *>* commentList , int totalCount))success
                               failure:(void (^)(NSNumber *resCode, NSString *message))failure {
    NSString *method = [NSString stringWithFormat:@"comment/%ld/moreReply",commentId];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params safeSetObject:uid forKey:@"uid"];
    [params safeSetObject:@(dynamicId) forKey:@"dynamicId"];
    [params safeSetObject:@(start) forKey:@"start"];
    [params safeSetObject:@(ID) forKey:@"id"];
    [params safeSetObject:@(5) forKey:@"pageSize"];
    [HttpRequestHelper POST:method params:params success:^(id data) {
        NSArray *commentList = [CTCommentReplyModel  modelsWithArray:data[@"list"]];
        int count = [data[@"count"] intValue];
        success(commentList,count);
    } failure:^(NSNumber *resCode, NSString *message) {
        if (failure) {
            failure(resCode, message);
        }
    }];
    
}

+ (void)requestReportPushWithFormUid:(NSString *)formUid
                                    toUid:(NSString *)toUid
                               toCommenId:(long)toCommenId
                            reportContent:(NSString *)reportContent
                                  Success:(void (^)(void))success
                                  failure:(void (^)(NSNumber *resCode, NSString *message))failure {
    NSString *method = @"report/push";
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params safeSetObject:formUid forKey:@"formUid"];
    [params safeSetObject:toUid forKey:@"toUid"];
    [params safeSetObject:@(toCommenId) forKey:@"toCommenId"];
    [params safeSetObject:reportContent forKey:@"reportContent"];
    [HttpRequestHelper POST:method params:params success:^(id data) {
        success();
    } failure:^(NSNumber *resCode, NSString *message) {
        if (failure) {
            failure(resCode, message);
        }
    }];
}

+ (void)requestReportGetTypeWithUid:(NSString *)uid
                            Success:(void (^)(NSArray <NSDictionary *>*typeList))success
                            failure:(void (^)(NSNumber *resCode, NSString *message))failure {
    NSString *method = @"report/getType";
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params safeSetObject:uid forKey:@"uid"];
    [HttpRequestHelper POST:method params:params success:^(id data) {
        NSArray *dataArr = (NSArray *)data;
        success(dataArr);
    } failure:^(NSNumber *resCode, NSString *message) {
        if (failure) {
            failure(resCode, message);
        }
    }];
}

@end
