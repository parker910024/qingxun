//
//  PraiseCore.m
//  BberryCore
//
//  Created by chenran on 2017/5/18.
//  Copyright © 2017年 chenran. All rights reserved.
//

#import "PraiseCore.h"
#import "PraiseCoreClient.h"
#import "AuthCore.h"
#import "AuthCoreClient.h"
#import "UserCore.h"
#import "ImFriendCoreClient.h"
#import "HttpRequestHelper+Praise.h"
#import "ShareCore.h"
#import "ShareSendInfo.h"
#import "Attachment.h"
#import "ImRoomCoreV2.h"
#import "ImMessageCore.h"

@interface PraiseCore()
@end

@implementation PraiseCore
- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (RACSignal *)rac_praise:(UserID)praiseUid WithBePraisedUid:(UserID)bePraisedUid {
    if (bePraisedUid  == GetCore(ImRoomCoreV2).currentRoomInfo.uid) {
        if ([GetCore(UserCore) getUserInfoInDB:GetCore(AuthCore).getUid.userIDValue].platformRole != XCUserInfoPlatformRoleSuperAdmin) {
        
        UserInfo *userInfo = [GetCore(UserCore)getUserInfoInDB:bePraisedUid];
        UserInfo *myInfo = [GetCore(UserCore) getUserInfoInDB:praiseUid];
        ShareSendInfo *info = [[ShareSendInfo alloc]init];
        info.uid = praiseUid;
        info.targetNick = userInfo.nick;
        info.targetUid = bePraisedUid;
        info.nick = myInfo.nick;
        
        Attachment *attachment = [[Attachment alloc]init];
        attachment.first = Custom_Noti_Header_Room_Tip;
        attachment.second = Custom_Noti_Header_Room_Tip_Attentent_Owner;
        attachment.data = info.encodeAttachemt;
        
        NSString *sessionId = [NSString stringWithFormat:@"%ld",(long)GetCore(ImRoomCoreV2).currentRoomInfo.roomId];
        [GetCore(ImMessageCore)sendCustomMessageAttachement:attachment sessionId:sessionId type:NIMSessionTypeChatroom];
        }
    }
    
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [HttpRequestHelper praise:praiseUid bePraisedUid:bePraisedUid success:^{
            [subscriber sendNext:@(bePraisedUid)];
            [subscriber sendCompleted];
        } failure:^(NSNumber *resCode, NSString *message) {
            NSError *error = [NSError errorWithDomain:NSCocoaErrorDomain code:[resCode integerValue] userInfo:@{NSLocalizedDescriptionKey:message}];
            [subscriber sendError:error];
        }];
        return nil;
    }];
}

- (void)praise:(UserID)paiseUid bePraisedUid:(UserID)bePraisedUid
{
    
    if (bePraisedUid  == GetCore(ImRoomCoreV2).currentRoomInfo.uid) {
        if ([GetCore(UserCore) getUserInfoInDB:GetCore(AuthCore).getUid.userIDValue].platformRole != XCUserInfoPlatformRoleSuperAdmin) {
        UserInfo *userInfo = [GetCore(UserCore)getUserInfoInDB:bePraisedUid];
        UserInfo *myInfo = [GetCore(UserCore) getUserInfoInDB:paiseUid];
        ShareSendInfo *info = [[ShareSendInfo alloc]init];
        info.uid = paiseUid;
        info.targetNick = userInfo.nick;
        info.targetUid = bePraisedUid;
        info.nick = myInfo.nick;
        
        Attachment *attachment = [[Attachment alloc]init];
        attachment.first = Custom_Noti_Header_Room_Tip;
        attachment.second = Custom_Noti_Header_Room_Tip_Attentent_Owner;
        attachment.data = info.encodeAttachemt;
        
        NSString *sessionId = [NSString stringWithFormat:@"%ld",(long)GetCore(ImRoomCoreV2).currentRoomInfo.roomId];
        [GetCore(ImMessageCore)sendCustomMessageAttachement:attachment sessionId:sessionId type:NIMSessionTypeChatroom];
        }
        
    }
    
    
    __block UserID bePraiseuid = bePraisedUid;
    [HttpRequestHelper praise:paiseUid bePraisedUid:bePraisedUid success:^{
        NotifyCoreClient(PraiseCoreClient, @selector(onPraiseSuccess:), onPraiseSuccess:bePraiseuid);
    } failure:^(NSNumber *resCode, NSString *message) {
        NotifyCoreClient(PraiseCoreClient, @selector(onPraiseFailth:), onPraiseFailth:message);
    }];
}

- (void)praise:(UserID)paiseUid bePraisedUid:(UserID)bePraisedUid completion:(void(^)(BOOL success, NSNumber * _Nullable code, NSString * _Nullable msg))completion {
    
    if (bePraisedUid  == GetCore(ImRoomCoreV2).currentRoomInfo.uid) {
        if ([GetCore(UserCore) getUserInfoInDB:GetCore(AuthCore).getUid.userIDValue].platformRole != XCUserInfoPlatformRoleSuperAdmin) {
        UserInfo *userInfo = [GetCore(UserCore)getUserInfoInDB:bePraisedUid];
        UserInfo *myInfo = [GetCore(UserCore) getUserInfoInDB:paiseUid];
        ShareSendInfo *info = [[ShareSendInfo alloc]init];
        info.uid = paiseUid;
        info.targetNick = userInfo.nick;
        info.targetUid = bePraisedUid;
        info.nick = myInfo.nick;
        
        Attachment *attachment = [[Attachment alloc]init];
        attachment.first = Custom_Noti_Header_Room_Tip;
        attachment.second = Custom_Noti_Header_Room_Tip_Attentent_Owner;
        attachment.data = info.encodeAttachemt;
        
        NSString *sessionId = [NSString stringWithFormat:@"%ld",(long)GetCore(ImRoomCoreV2).currentRoomInfo.roomId];
        [GetCore(ImMessageCore)sendCustomMessageAttachement:attachment sessionId:sessionId type:NIMSessionTypeChatroom];
        }
        
    }
    
    [HttpRequestHelper praise:paiseUid bePraisedUid:bePraisedUid success:^{
        !completion ?: completion(YES, nil, nil);
    } failure:^(NSNumber *resCode, NSString *message) {
        !completion ?: completion(NO, resCode, message);
    }];
}

- (void) cancel:(UserID)cancelUid beCanceledUid:(UserID)beCanceledUid beOperation:(UserInfo *)info {
    __block UserID beCancelUid = beCanceledUid;
    [HttpRequestHelper cancel:cancelUid beCanceledUid:beCanceledUid success:^{
        NotifyCoreClient(PraiseCoreClient, @selector(onCancelSuccess:beOperation:), onCancelSuccess:beCancelUid beOperation:info);
    } failure:^(NSNumber *resCode, NSString *message) {
        NotifyCoreClient(PraiseCoreClient, @selector(onCancelFailth:), onCancelFailth:message);
    }];
}

- (RACSignal *)rac_cancel:(UserID)cancelUid beCanceledUid:(UserID)beCanceledUid {
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        
        [HttpRequestHelper cancel:cancelUid beCanceledUid:beCanceledUid success:^{
            [subscriber sendNext:@(beCanceledUid)];
            [subscriber sendCompleted];
        } failure:^(NSNumber *resCode, NSString *message) {
            NSError *error = [NSError errorWithDomain:NSCocoaErrorDomain code:[resCode integerValue] userInfo:@{NSLocalizedDescriptionKey:message}];
            [subscriber sendError:error];
        }];
        
        return nil;
    }];
}

- (void) cancel:(UserID)cancelUid beCanceledUid:(UserID)beCanceledUid
{
    __block UserID beCancelUid = beCanceledUid;
    [HttpRequestHelper cancel:cancelUid beCanceledUid:beCanceledUid success:^{
        NotifyCoreClient(PraiseCoreClient, @selector(onCancelSuccess:), onCancelSuccess:beCancelUid);
    } failure:^(NSNumber *resCode, NSString *message) {
        NotifyCoreClient(PraiseCoreClient, @selector(onCancelFailth:), onCancelFailth:message);
    }];
}

- (void)deleteFriend:(UserID)deleteUid beDeletedUid:(UserID)beDeletedUid
{
    __block UserID beDeleteuid = beDeletedUid;
    [HttpRequestHelper deleteFriend:deleteUid beDeletedFriendUid:beDeletedUid success:^{
        NotifyCoreClient(PraiseCoreClient, @selector(onDeleteFriendSuccess:), onDeleteFriendSuccess:beDeleteuid);
    } failure:^(NSNumber *resCode, NSString *message) {
        NotifyCoreClient(PraiseCoreClient, @selector(onDeleteFriendFailth:), onDeleteFriendFailth:message);
    }];
}

- (void) requestAttentionListState:(int)state page:(int)page PageSize:(int)pageSize
{
    UserID uid = [GetCore(AuthCore) getUid].userIDValue;
    [HttpRequestHelper requestAttentionList:uid state:state page:page PageSize:pageSize success:^(NSArray *userInfos) {
        NotifyCoreClient(PraiseCoreClient, @selector(onRequestAttentionListState:success:), onRequestAttentionListState:state success:userInfos);
    } failure:^(NSNumber *resCode, NSString *message) {
        
    }];
}

- (void) requestAttentionForGamePageListState:(int)state page:(int)page PageSize:(int)pageSize
{
    UserID uid = [GetCore(AuthCore) getUid].userIDValue;
    [HttpRequestHelper requestAttentionList:uid state:state page:page PageSize:pageSize success:^(NSArray *userInfos) {
        NotifyCoreClient(PraiseCoreClient, @selector(onRequestAttentionListStateForGamePage:success:), onRequestAttentionListStateForGamePage:state success:userInfos);
    } failure:^(NSNumber *resCode, NSString *message) {
        
    }];
}


- (void)isLike:(UserID)uid isLikeUid:(UserID)isLikeUid
{
    __block UserID islikeUid = isLikeUid;
    [HttpRequestHelper isLike:uid isLikeUid:isLikeUid success:^(BOOL isLike) {
        NotifyCoreClient(PraiseCoreClient, @selector(onRequestIsLikeSuccess:islikeUid:), onRequestIsLikeSuccess:isLike islikeUid:islikeUid);
    } failure:^(NSNumber *resCode, NSString *message) {
        NotifyCoreClient(PraiseCoreClient, @selector(onRequestIsLikeFailth:), onRequestIsLikeFailth:message);
    }];
}

- (void) isUid:(UserID)uid isLikeUid:(UserID)isLikeUid success:(void (^)(BOOL isLike))success{
    
    [HttpRequestHelper isLike:uid isLikeUid:isLikeUid success:^(BOOL isLike) {
        success(isLike);
    } failure:^(NSNumber *resCode, NSString *message) {
        NotifyCoreClient(PraiseCoreClient, @selector(onRequestIsLikeFailth:), onRequestIsLikeFailth:message);
    }];
}

//获取粉丝列表
- (void) requestFansListState:(int)state page:(NSInteger)page{
    UserID uid = [GetCore(AuthCore) getUid].userIDValue;
    [HttpRequestHelper getFansListWithUid:uid page:page success:^(NSArray *userInfos) {
        NotifyCoreClient(PraiseCoreClient, @selector(onRequestFansListState:success:), onRequestFansListState:state success:userInfos);
    } failure:^(NSNumber *resCode, NSString *message) {
        NotifyCoreClient(PraiseCoreClient, @selector(onRequestFansListState:failth:), onRequestFansListState:state failth:message);
    }];
}


- (RACSignal *)rac_queryIsLike:(UserID)uid isLikeUid:(UserID)isLikeUid{
    
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        __block UserID islikeUid = isLikeUid;
        [HttpRequestHelper isLike:uid isLikeUid:isLikeUid success:^(BOOL isLike) {
            [subscriber sendNext:@(isLike)];
            [subscriber sendCompleted];
        } failure:^(NSNumber *resCode, NSString *message) {
            [subscriber sendError:nil];
        }];
        return nil;
    }];
}

- (void) requestUnReadListType:(int)type{
    [HttpRequestHelper requestUnReadListTpye:type success:^(NSArray *lists) {
        NotifyCoreClient(PraiseCoreClient, @selector(onRequestUnReadListSuccess:), onRequestUnReadListSuccess:lists);
    } failure:^(NSNumber *resCode, NSString *message) {
        NotifyCoreClient(PraiseCoreClient, @selector(onRequestUnReadListFailth:), onRequestUnReadListFailth:message);
    }];
}

- (void)requestUnReadClearListTpye:(int)type{
    [HttpRequestHelper requestUnReadClearListTpye:type success:^{
        NotifyCoreClient(PraiseCoreClient, @selector(requestUnReadClearListSuccess), requestUnReadClearListSuccess);
        
    } failure:^(NSString *message) {
        NotifyCoreClient(PraiseCoreClient, @selector(requestUnReadClearListFailth:), requestUnReadClearListFailth:message);
    }];
}
- (void)requestUnReadCount{
    [HttpRequestHelper requestUnReadCountSuccess:^(int likeCount, int commentCount) {
        NotifyCoreClient(PraiseCoreClient, @selector(requestUnReadCountTpyeSuccess:withCommentCount:), requestUnReadCountTpyeSuccess:likeCount withCommentCount:commentCount);
    } failure:^(NSString *message) {
        NotifyCoreClient(PraiseCoreClient, @selector(requestUnReadClearListSuccess), requestUnReadClearListSuccess);
        
    }];
}


/**
 查询评论历史消息
 
 @param type 类型 0, 评论 1，点赞
 @param page 页数
 */
- (void) requestHistoryListTpye:(int)type
                           page:(NSInteger)page
                        minDate:(NSInteger)minDate{
    
    [HttpRequestHelper requestHistoryListTpye:type page:page minDate:minDate success:^(NSArray *lists) {
        NotifyCoreClient(PraiseCoreClient, @selector(onRequestHistoryListSuccess:), onRequestHistoryListSuccess:lists);
    } failure:^(NSString *message) {
        NotifyCoreClient(PraiseCoreClient, @selector(onRequestHistoryListFailth:),onRequestHistoryListFailth:message);
    }];
}
@end
