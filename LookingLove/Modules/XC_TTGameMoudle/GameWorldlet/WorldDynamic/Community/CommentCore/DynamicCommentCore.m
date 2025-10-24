//
//  CPBindCore.m
//  UKiss
//
//  Created by apple on 2018/9/29.
//  Copyright © 2018年 yizhuan. All rights reserved.
//

#import "DynamicCommentCore.h"
#import "DynamicCommentCoreClient.h"
#import "HttpRequestHelper+DynamicComment.h"

@implementation DynamicCommentCore


- (void)requestCommentListWithUid:(NSString *)uid dynamicId:(long)dynamicId pageNum:(NSInteger)pageNum {
    [HttpRequestHelper requestCommentListWithUid:uid dynamicId:dynamicId pageNum:pageNum Success:^(NSArray<CTCommentReplyModel *> * _Nonnull commentList , int totalCount) {
        NotifyCoreClient(DynamicCommentCoreClient, @selector(requestCommentListSuccess:totalCount:), requestCommentListSuccess:commentList totalCount:totalCount);
    } failure:^(NSNumber * _Nonnull resCode, NSString * _Nonnull message) {
        NotifyCoreClient(DynamicCommentCoreClient, @selector(requestCommentListFailth:), requestCommentListFailth:message);
    }];
}

- (void)requestAddCommentWithUid:(NSString *)uid dynamicId:(long)dynamicId content:(NSString *)content {
    [HttpRequestHelper requestAddCommentWithUid:uid dynamicId:dynamicId content:content Success:^(CTCommentReplyModel * _Nonnull commentModel) {
        NotifyCoreClient(DynamicCommentCoreClient, @selector(requestAddCommentSuccess:), requestAddCommentSuccess:commentModel);
    } failure:^(NSNumber * _Nonnull resCode, NSString * _Nonnull message) {
        NotifyCoreClient(DynamicCommentCoreClient, @selector(requestAddCommentFailth:), requestAddCommentFailth:message);
    }];
}

- (void)requestDeleteCommentWithUid:(NSString *)uid dynamicId:(long)dynamicId commentId:(long )commentId type:(int)type sender:(id)sender {
    [HttpRequestHelper requestDeleteCommentWithUid:uid dynamicId:dynamicId commentId:commentId type:type Success:^{
        NotifyCoreClient(DynamicCommentCoreClient, @selector(requestDeleteCommentSuccessWithCommentId:Sender:), requestDeleteCommentSuccessWithCommentId:commentId Sender:sender);
    } failure:^(NSNumber * _Nonnull resCode, NSString * _Nonnull message) {
        NotifyCoreClient(DynamicCommentCoreClient, @selector(requestDeleteCommentFailth:sender:), requestDeleteCommentFailth:message sender:sender);
    }];
}

- (void)requestReplyCommentWithUid:(NSString *)uid
                         dynamicId:(long)dynamicId
                             toUid:(long)toUid
                           content:(NSString *)content
                         commentId:(long )commentId
                              type:(int)type {
    [HttpRequestHelper requestReplyCommentWithUid:uid dynamicId:dynamicId toUid:toUid content:content commentId:commentId type:type Success:^(CTCommentReplyModel * _Nonnull commentModel) {
        NotifyCoreClient(DynamicCommentCoreClient, @selector(requestReplyCommentSuccess:), requestReplyCommentSuccess:commentModel);
    } failure:^(NSNumber * _Nonnull resCode, NSString * _Nonnull message) {
        NotifyCoreClient(DynamicCommentCoreClient, @selector(requestReplyCommentFailth:), requestReplyCommentFailth:message);
    }];
}

- (void)requestCommentDetailsWithUid:(NSString *)uid dynamicId:(long)dynamicId commentId:(long )commentId {
    [HttpRequestHelper requestCommentDetailsWithUid:uid dynamicId:dynamicId commentId:commentId Success:^(CTCommentReplyModel * _Nonnull commentModel) {
        NotifyCoreClient(DynamicCommentCoreClient, @selector(requestCommentDetailsSuccess:commentId:), requestCommentDetailsSuccess:commentModel commentId:commentId);
    } failure:^(NSNumber * _Nonnull resCode, NSString * _Nonnull message) {
        NotifyCoreClient(DynamicCommentCoreClient, @selector(requestCommentDetailsFailth:commentId:), requestCommentDetailsFailth:message commentId:commentId);
    }];
}

- (void)requestCommentReplyListWithUid:(NSString *)uid commentId:(long)commentId dynamicId:(long)dynamicId start:(NSInteger)start  ID:(long)ID{
    [HttpRequestHelper requestCommentReplyListWithUid:uid commentId:commentId dynamicId:dynamicId start:start ID:ID Success:^(NSArray<CTCommentReplyModel *> * _Nonnull commentList,int totalCount) {
        NotifyCoreClient(DynamicCommentCoreClient, @selector(requestCommentReplyListSuccess:totalCount:), requestCommentReplyListSuccess:commentList totalCount:totalCount);
    } failure:^(NSNumber * _Nonnull resCode, NSString * _Nonnull message) {
        NotifyCoreClient(DynamicCommentCoreClient, @selector(requestCommentReplyListFailth:), requestCommentReplyListFailth:message);
    }];
}

- (void)requestReportPushWithFormUid:(NSString *)formUid
                                    toUid:(NSString *)toUid
                               toCommenId:(long)toCommenId
                            reportContent:(NSString *)reportContent sender:(id)sender {
    [HttpRequestHelper requestReportPushWithFormUid:formUid toUid:toUid toCommenId:toCommenId reportContent:reportContent Success:^{
        NotifyCoreClient(DynamicCommentCoreClient, @selector(requestReportPushSuccessSender:), requestReportPushSuccessSender:sender);
    } failure:^(NSNumber * _Nonnull resCode, NSString * _Nonnull message) {
        NotifyCoreClient(DynamicCommentCoreClient, @selector(requestReportPushFailth:sender:), requestReportPushFailth:message sender:sender);
    }];
}

- (void)requestReportGetTypeWithUid:(NSString *)uid sender:(id)sender {
    [HttpRequestHelper requestReportGetTypeWithUid:uid Success:^(NSArray<NSDictionary *> * _Nonnull typeList) {
        NotifyCoreClient(DynamicCommentCoreClient, @selector(requestReportGetTypeSuccessTypeList:Sender:), requestReportGetTypeSuccessTypeList:typeList Sender:sender);
    } failure:^(NSNumber * _Nonnull resCode, NSString * _Nonnull message) {
        NotifyCoreClient(DynamicCommentCoreClient, @selector(requestReportGetTypeFailth:sender:), requestReportGetTypeFailth:message sender:sender);
    }];
}

@end
